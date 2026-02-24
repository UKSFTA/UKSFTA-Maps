#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Local Micro-Climate Engine
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

        private _altOffset = (_alt / 1000) * -6.5;
        private _localTemp = _globalTemp + _altOffset + _surfaceOffset;
        
        missionNamespace setVariable ["UKSFTA_Environment_LocalTemp", _localTemp];
        missionNamespace setVariable ["UKSFTA_Environment_LocalBiome", _localBiome];
        missionNamespace setVariable ["uksfta_environment_visualDesatLocal", _desat];

        // --- ACE3 LOCAL SYNC ---
        // ACE3 weather simulation typically treats 'ace_weather_currentTemperature' as 
        // a baseline (sea-level) temp and then applies its own altitude adjustment.
        // To force ACE to reflect our _localTemp at the current altitude, we set the 
        // baseline such that [Baseline - AltAdjust = LocalTemp].
        private _aceBaselineT = _localTemp - _altOffset; 
        missionNamespace setVariable ["ace_weather_currentTemperature", _aceBaselineT];
        
        // Local Humidity shift (e.g. higher humidity near water or lower in sandstorms)
        private _globalHumid = missionNamespace getVariable ["UKSFTA_Environment_GlobalHumid", 0.5];
        private _localHumid = _globalHumid;
        if (_localBiome == "ARID" && overcast > 0.7) then { _localHumid = (_localHumid - 0.2) max 0.05; };
        missionNamespace setVariable ["ace_weather_currentHumidity", _localHumid];

        // Force ACE update (true = force all caches to clear)
        if (!isNil "ace_weather_fnc_updateTemperature") then { [true] call ace_weather_fnc_updateTemperature; };

        sleep 2;
    };
};

true
