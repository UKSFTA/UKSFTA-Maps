#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Weather Evolution Cycle (Master Driver)
 * Pushes data to Visuals and ACE3 Ballistics.
 */

if (!isServer) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Sovereign Weather Engine Starting (ACE3 Integrated)...";

while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    private _preset = missionNamespace getVariable ["uksfta_environment_preset", "REALISM"];
    
    // 1. Resolve Next Probabilistic State
    private _state = _biome call uksfta_environment_fnc_getNextState;
    if (isNil "_state") then { _state = [0,0,0,5,600]; };
    _state params ["_overcast", "_rain", "_fog", "_wind", "_duration"];

    // 2. Calculate Environmental Physics (Internal Model)
    private _sunAlt = call uksfta_environment_fnc_getSunElevation;
    private _sunFactor = (_sunAlt / 90.0) max 0.0;
    
    // Biome Profile Lookup
    private _physProfiles = [
        ["TEMPERATE",     [10.0, 25.0, 0.5, 1013.0]],
        ["ARID",          [25.0, 45.0, 0.1, 1020.0]],
        ["ARCTIC",        [-30.0, 0.0, 0.8, 990.0]],
        ["TROPICAL",      [25.0, 32.0, 0.95, 1005.0]],
        ["MEDITERRANEAN", [18.0, 35.0, 0.4, 1015.0]]
    ];
    
    private _pData = [10, 25, 0.5, 1013]; // Default
    { if (_x select 0 == _biome) exitWith { _pData = _x select 1; }; } forEach _physProfiles;
    _pData params ["_tMin", "_tMax", "_baseHumid", "_basePress"];

    // Calculate Raw Values
    private _rawTemp = (_tMin + ((_tMax - _tMin) * _sunFactor) - (_overcast * 5.0));
    private _rawHumid = (_baseHumid + (_rain * 0.2)) min 1.0;

    // 3. Apply Preset Dampening (Arcade Mode)
    private _finalTemp = _rawTemp;
    private _finalHumid = _rawHumid;

    if (_preset == "ARCADE") then {
        _finalTemp = (_rawTemp max -5) min 35; // Clamp to safe human limits
        _finalHumid = (_rawHumid max 0.3) min 0.8; // Avoid extreme ballistics
    };

    // 4. PUSH TO GLOBAL MISSION STATE (ACE3 & Framework)
    missionNamespace setVariable ["ace_weather_currentTemperature", _finalTemp, true];
    missionNamespace setVariable ["ace_weather_currentHumidity", _finalHumid, true];
    missionNamespace setVariable ["ace_weather_currentBarometricPressure", _basePress, true];
    
    // Trigger ACE3 ballistics update if mod is present
    if (!isNil "ace_weather_fnc_updateTemperature") then {
        [true] call ace_weather_fnc_updateTemperature;
    };

    // 5. Apply Engine Weather Transitions
    private _time = _duration / (missionNamespace getVariable ["uksfta_environment_transitionSpeed", 1.0]);
    
    _time setOvercast _overcast;
    0 setRain _rain;
    _time setFog _fog;
    setWind [_wind, _wind, true];
    
    if (_overcast > 0.8) then { 0 setLightnings 1; } else { 0 setLightnings 0; };
    simulWeatherSync;

    diag_log text (format ["[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: ACE3 PUSH -> T:%1C | H:%2 | P:%3", _finalTemp, _finalHumid, _basePress]);

    sleep _duration;
};

true
