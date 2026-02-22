/**
 * UKSFTA Environment - Advanced Weather Engine
 */

if (!isServer) exitWith {};

waitUntil { !isNil "uksfta_environment_enabled" };
if (!uksfta_environment_enabled) exitWith {};

// --- PROFILES ---
private _weatherProfiles = [
    ["TEMPERATE",     [[0.2, 0, 0], [0.6, 0.2, 0.1], [0.9, 0.8, 0.3]]],
    ["ARID",          [[0.1, 0, 0], [0.3, 0, 0.05],  [0.6, 0.1, 0.1]]],
    ["ARCTIC",        [[0.2, 0, 0], [0.5, 0, 0.4],   [0.95, 0, 0.85]]],
    ["TROPICAL",      [[0.4, 0.1, 0.1], [0.8, 0.6, 0.2], [0.98, 0.95, 0.4]]],
    ["MEDITERRANEAN", [[0.1, 0, 0], [0.4, 0.1, 0.05], [0.7, 0.2, 0.1]]],
    ["SUBTROPICAL",   [[0.3, 0, 0], [0.6, 0.3, 0.1], [0.9, 0.5, 0.2]]]
];

// EXPLICIT FLOATS FOR PRECISION
private _physicalProfiles = [
    ["TEMPERATE",     [10.0, 25.0, 0.5, 1013.0]],
    ["ARID",          [25.0, 45.0, 0.1, 1020.0]],
    ["ARCTIC",        [-30.0, 0.0, 0.8, 990.0]],
    ["TROPICAL",      [25.0, 32.0, 0.95, 1005.0]],
    ["MEDITERRANEAN", [18.0, 35.0, 0.4, 1015.0]],
    ["SUBTROPICAL",   [20.0, 30.0, 0.7, 1010.0]]
];

private _worldConfig = configFile >> "CfgWorlds" >> worldName;
private _nativeMaxWave = getNumber (_worldConfig >> "Sea" >> "MaxWave");
if (_nativeMaxWave == 0) then { _nativeMaxWave = 0.25; };

private _currentStateIdx = 0;

while {uksfta_environment_enabled} do {
    private _biome = call uksfta_environment_fnc_analyzeBiome;
    
    private _activeProfile = [];
    { if (_x select 0 == _biome) exitWith { _activeProfile = _x select 1; }; } forEach _weatherProfiles;
    if (count _activeProfile == 0) then { _activeProfile = (_weatherProfiles select 0) select 1; };

    private _phys = [];
    { if (_x select 0 == _biome) exitWith { _phys = _x select 1; }; } forEach _physicalProfiles;
    if (count _phys == 0) then { _phys = (_physicalProfiles select 0) select 1; };
    
    _phys params ["_tMin", "_tMax", "_baseHumid", "_basePress"];
    
    _currentStateIdx = [_currentStateIdx, _activeProfile] call uksfta_environment_fnc_getNextState;
    (_activeProfile select _currentStateIdx) params ["_targetOvercast", "_targetRain", "_targetFog"];

    private _baseTime = 1800 + (random 1800);
    private _transitionTime = _baseTime / (uksfta_environment_transitionSpeed max 0.1);
    private _finalTime = [_transitionTime, 0] select (time < 10);
    
    _finalTime setOvercast _targetOvercast;
    _finalTime setFog [_targetFog, 0.03, 0.0];
    
    [_finalTime, _targetRain] spawn {
        params ["_time", "_rain"];
        if (_time > 0) then { sleep (_time / 2); };
        (_time / 2) setRain _rain;
    };

    missionNamespace setVariable ["UKSFTA_Environment_CurrentIntensity", _targetOvercast, true];
    missionNamespace setVariable ["UKSFTA_Environment_CurrentBiome", _biome, true];

    // --- ACE SYNC ---
    private _sunAlt = call uksfta_environment_fnc_getSunElevation;
    private _sunFactor = (_sunAlt / 90.0) max 0.0;
    private _currentTemp = _tMin + ((_tMax - _tMin) * _sunFactor) - (_targetOvercast * 5.0);
    private _currentHumid = (_baseHumid + (_targetRain * 0.2)) min 1.0;
    private _currentPress = _basePress - (_targetOvercast * 10.0);

    missionNamespace setVariable ["ace_weather_currentTemperature", _currentTemp, true];
    missionNamespace setVariable ["ace_weather_currentHumidity", _currentHumid, true];
    missionNamespace setVariable ["ace_weather_currentBarometricPressure", _currentPress, true];

    // --- TELEMETRY ---
    if (uksfta_environment_debug) then {
        diag_log format ["[UKSFTA-ENV] CYCLE: Biome=%1, Sun=%2, Temp=%3", _biome, _sunAlt, _currentTemp];
    };

    private _windStr = (_targetOvercast * 10.0) + (random 5.0);
    setWind [random _windStr, random _windStr, true];
    0 setGusts (_targetOvercast * 0.6);
    0 setWaves (_targetOvercast * _nativeMaxWave);

    sleep _finalTime;
};
true
