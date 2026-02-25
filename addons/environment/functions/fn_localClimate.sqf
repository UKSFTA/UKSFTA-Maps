#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Local Micro-Climate Engine (Phase 10)
 * Shade-aware temperature and humidity simulation.
 */

if (!hasInterface) exitWith {};

[] spawn {
    waitUntil { !isNull player };
    
    private _fnc_getSurfaceBiome = {
        params ["_surface"];
        private _s = toUpper _surface;
        if ("SNOW" in _s || "ICE" in _s || "WINTER" in _s) exitWith { "ARCTIC" };
        if ("SAND" in _s || "DESERT" in _s || "DRY" in _s) exitWith { "ARID" };
        if ("JUNGLE" in _s || "PALM" in _s) exitWith { "TROPICAL" };
        "TEMPERATE"
    };

    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _globalTemp = missionNamespace getVariable ["UKSFTA_Environment_GlobalTemp", 20];
        private _pos = getPosASL player;
        private _alt = _pos select 2;
        private _surface = surfaceType (getPosVisual player);
        
        private _localBiome = _surface call _fnc_getSurfaceBiome;
        private _surfaceOffset = 0;
        private _desat = 0;

        if (_localBiome == "ARCTIC") then { _surfaceOffset = -15; _desat = 0.2; };
        if (_localBiome == "ARID") then { _surfaceOffset = 5; };

        // --- SOLAR OCCLUSION (SHADE) ---
        private _shadeOffset = 0;
        private _sunElevation = call uksfta_environment_fnc_getSunElevation;
        
        if (_sunElevation > 0) then {
            // Calculate sun vector
            private _sunDir = (360 - (sunOrMoon * 360)) % 360; // Approximate
            private _sunPos = [
                (getPosASL player select 0) + (sin _sunDir * 1000),
                (getPosASL player select 1) + (cos _sunDir * 1000),
                (getPosASL player select 2) + (sin _sunElevation * 1000)
            ];
            
            // Check visibility to sun
            private _vis = [player, "VIEW", objNull] checkVisibility [eyePos player, _sunPos];
            if (_vis < 0.5) then {
                // We are in the shade
                _shadeOffset = -5; // Significant drop in direct heat
            };
        };

        private _altOffset = (_alt / 1000) * -6.5;
        private _localTemp = _globalTemp + _altOffset + _surfaceOffset + _shadeOffset;

        // --- WIND-CHILL FACTOR (DAGGER Synergy) ---
        // Effective temp drops in high winds (Approx formula)
        private _windStr = windStr;
        private _exposure = 1.0;
        if ([player, "VIEW", objNull] checkVisibility [eyePos player, (eyePos player) vectorAdd [0,0,50]] < 0.5) then { _exposure = 0.3; }; // Sheltered
        
        if (_localTemp < 10 && _windStr > 5) then {
            private _windChill = (35.74 + (0.6215 * _localTemp) - (35.75 * (_windStr^0.16)) + (0.4275 * _localTemp * (_windStr^0.16)));
            _localTemp = (_localTemp min _windChill); // Apply the colder value
        };
        
        missionNamespace setVariable ["UKSFTA_Environment_LocalTemp", _localTemp];
        missionNamespace setVariable ["UKSFTA_Environment_LocalBiome", _localBiome];
        missionNamespace setVariable ["uksfta_environment_visualDesatLocal", _desat];

        // --- ACE3 LOCAL SYNC ---
        private _aceBaselineT = _localTemp; 
        missionNamespace setVariable ["ace_weather_currentTemperature", _aceBaselineT];
        
        // Local Humidity shift
        private _globalHumid = missionNamespace getVariable ["UKSFTA_Environment_GlobalHumid", 0.5];
        private _localHumid = _globalHumid;
        if (_localBiome == "ARID" && overcast > 0.7) then { _localHumid = (_localHumid - 0.2) max 0.05; };
        missionNamespace setVariable ["ace_weather_currentHumidity", _localHumid];

        if (!isNil "ace_weather_fnc_updateTemperature") then { [true] call ace_weather_fnc_updateTemperature; };

        sleep 5; // Balanced frequency
    };
};

true
