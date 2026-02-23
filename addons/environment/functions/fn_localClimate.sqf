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
        private _globalTemp = missionNamespace getVariable ["ace_weather_currentTemperature", 20];
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

        sleep 2;
    };
};

true
