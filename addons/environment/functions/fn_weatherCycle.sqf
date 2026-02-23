#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Weather Evolution Cycle (Fluid Driver)
 * Optimized for UKSFTA performance standards.
 */

if (!isServer) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Sovereign Weather Engine Starting (Fluid Mode)...";

// Persistence handles for smoothing
UKSFTA_Env_TargetTemp = 20;
UKSFTA_Env_TargetHumid = 0.5;

// --- SMOOTHING THREAD ---
// This thread runs every 5 seconds to incrementally nudge ACE variables
[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _currTemp = missionNamespace getVariable ["ace_weather_currentTemperature", 20];
        private _currHumid = missionNamespace getVariable ["ace_weather_currentHumidity", 0.5];
        
        // Nudge Temp (Max 0.2C change per 5s = 2.4C per minute)
        private _diffT = UKSFTA_Env_TargetTemp - _currTemp;
        if (abs _diffT > 0.01) then {
            _currTemp = _currTemp + (_diffT * 0.05);
            missionNamespace setVariable ["ace_weather_currentTemperature", _currTemp, true];
        };

        // Nudge Humid
        private _diffH = UKSFTA_Env_TargetHumid - _currHumid;
        if (abs _diffH > 0.005) then {
            _currHumid = _currHumid + (_diffH * 0.05);
            missionNamespace setVariable ["ace_weather_currentHumidity", _currHumid, true];
        };

        // Trigger ACE3 update
        if (!isNil "ace_weather_fnc_updateTemperature") then { [true] call ace_weather_fnc_updateTemperature; };
        
        sleep 5;
    };
};

// --- MASTER CALCULATION LOOP ---
while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    private _preset = missionNamespace getVariable ["uksfta_environment_preset", "REALISM"];
    
    private _state = _biome call uksfta_environment_fnc_getNextState;
    if (isNil "_state") then { _state = [0,0,0,5,600]; };
    _state params ["_overcast", "_rain", "_fog", "_wind", "_duration"];

    // 1. Map-Accurate Solar Math
    private _lat = getNumber (configfile >> "CfgWorlds" >> worldName >> "latitude") min 90;
    private _sunAlt = call uksfta_environment_fnc_getSunElevation;
    // Normalize sun factor based on latitude (90 - lat = max possible elevation at equinox)
    private _maxPossibleAlt = (90 - abs(_lat)) max 10;
    private _sunFactor = (linearConversion [0, _maxPossibleAlt, _sunAlt, 0, 1, true]) max 0;
    
    // 2. Biome Profile Lookup
    private _physProfiles = [
        ["TEMPERATE",     [8.0, 22.0, 0.5, 1013.0]],
        ["ARID",          [22.0, 42.0, 0.1, 1020.0]],
        ["ARCTIC",        [-25.0, 2.0, 0.8, 990.0]],
        ["TROPICAL",      [24.0, 33.0, 0.9, 1005.0]],
        ["MEDITERRANEAN", [16.0, 32.0, 0.4, 1015.0]]
    ];
    
    private _pData = [10, 25, 0.5, 1013];
    { if (_x select 0 == _biome) exitWith { _pData = _x select 1; }; } forEach _physProfiles;
    _pData params ["_tMin", "_tMax", "_baseHumid", "_basePress"];

    // 3. Dynamic Calculation
    private _targetT = (_tMin + ((_tMax - _tMin) * _sunFactor) - (_overcast * 4.0));
    private _targetH = (_baseHumid + (_rain * 0.15)) min 1.0;

    // 4. Soft-Scaling for Arcade Mode (Range Compression)
    if (_preset == "ARCADE") then {
        // Linear scale toward 20C/0.5H (Safe comfort zone)
        _targetT = 20 + ((_targetT - 20) * 0.4); 
        _targetH = 0.5 + ((_targetH - 0.5) * 0.4);
    };

    // 5. Commit Targets to Smoothing Thread
    UKSFTA_Env_TargetTemp = _targetT;
    UKSFTA_Env_TargetHumid = _targetH;
    missionNamespace setVariable ["ace_weather_currentBarometricPressure", _basePress, true];

    // 6. Apply Engine Weather Transitions
    private _time = _duration / (missionNamespace getVariable ["uksfta_environment_transitionSpeed", 1.0]);
    _time setOvercast _overcast;
    0 setRain _rain;
    _time setFog _fog;
    setWind [_wind, _wind, true];
    simulWeatherSync;

    sleep _duration;
};

true
