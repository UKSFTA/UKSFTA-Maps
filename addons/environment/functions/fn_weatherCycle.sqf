#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Weather Engine (Gold Master)
 * Features Altitude-Aware Storms and Wind-Driven Biome Transitions.
 */

if (!isServer) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Sovereign Weather Engine Active (Altitude-Aware Mode).";

UKSFTA_Env_TargetTemp = 20;
UKSFTA_Env_TargetHumid = 0.5;

// --- 1. PERFORMANCE & SYNTAX SAFEGUARD ---
private _fnc_setCloud = missionNamespace getVariable ["setCloudColor", {params ["_r", "_g", "_b"];}];

// --- 2. SMOOTHING & CLOUD TINTING THREAD ---
[] spawn {
    private _setCloudSafe = missionNamespace getVariable ["setCloudColor", {params ["_rgb"];}];
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _currTemp = missionNamespace getVariable ["ace_weather_currentTemperature", 20];
        private _currHumid = missionNamespace getVariable ["ace_weather_currentHumidity", 0.5];
        
        // ACE Nudging
        private _diffT = UKSFTA_Env_TargetTemp - _currTemp;
        if (abs _diffT > 0.01) then {
            _currTemp = _currTemp + (_diffT * 0.05);
            missionNamespace setVariable ["UKSFTA_Environment_GlobalTemp", _currTemp, true];
            missionNamespace setVariable ["ace_weather_currentTemperature", _currTemp];
        };

        private _diffH = UKSFTA_Env_TargetHumid - _currHumid;
        if (abs _diffH > 0.005) then {
            _currHumid = _currHumid + (_diffH * 0.05);
            missionNamespace setVariable ["UKSFTA_Environment_GlobalHumid", _currHumid, true];
            missionNamespace setVariable ["ace_weather_currentHumidity", _currHumid];
        };

        if (!isNil "ace_weather_fnc_updateTemperature") then { [true] call ace_weather_fnc_updateTemperature; };
        
        // Cloud Tinting (Kelvin Shift)
        private _sunAlt = call uksfta_environment_fnc_getSunElevation;
        private _rgb = [1, 1, 1];
        if (_sunAlt < 10) then {
            if (_sunAlt > -5) then {
                private _f = linearConversion [-5, 10, _sunAlt, 0, 1, true];
                _rgb = [1, (0.6 + (0.4 * _f)), (0.3 + (0.7 * _f))];
            } else {
                _rgb = [0.2, 0.2, 0.25];
            };
        };
        [_rgb] call _setCloudSafe;

        sleep 5;
    };
};

// --- 3. MASTER EVOLUTION LOOP ---
while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    private _preset = missionNamespace getVariable ["uksfta_environment_preset", "REALISM"];
    
    // getNextState provides base baseline
    private _state = _biome call uksfta_environment_fnc_getNextState;
    if (isNil "_state") then { _state = [0,0,0,5,600]; };
    _state params ["_overcast", "_rain", "_fogValue", "_wind", "_duration"];

    // 4. ALTITUDE & WIND SCALING (Mountain/Sandstorm Logic)
    // We sample a high-altitude point to check for localized blizzard conditions
    private _highWind = _wind > 15;
    if (_highWind) then {
        if (_biome == "ARCTIC") then {
            _overcast = 1.0; // Force total whiteout in high winds
            _rain = 0.8;     // Heavy Snowfall
            _fogValue = 0.4; // Blizzard Fog
        };
        if (_biome == "ARID") then {
            _fogValue = 0.6; // Sandstorm Haze
            _overcast = (_overcast + 0.3) min 1.0;
        };
    };

    // 5. Apply Global Weather
    private _time = _duration / (missionNamespace getVariable ["uksfta_environment_transitionSpeed", 1.0]);
    _time setOvercast _overcast;
    0 setRain _rain;
    _time setFog [_fogValue, 0.03, 0];
    setWind [_wind, _wind, true];
    
    simulWeatherSync;

    // 6. Update Targets for Smoothing Thread
    // Biome-specific temperature baselines
    private _baseT = 20;
    private _baseH = 0.5;
    switch (_biome) do {
        case "ARCTIC": { _baseT = -15; _baseH = 0.8; };
        case "ARID": { _baseT = 35; _baseH = 0.1; };
        case "TROPICAL": { _baseT = 28; _baseH = 0.9; };
    };
    UKSFTA_Env_TargetTemp = _baseT - (_overcast * 5);
    UKSFTA_Env_TargetHumid = _baseH + (_rain * 0.2);

    sleep _duration;
};

true
