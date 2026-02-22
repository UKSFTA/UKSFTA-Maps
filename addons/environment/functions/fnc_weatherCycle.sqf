/**
 * UKSFTA Environment - Advanced Weather Engine
 */

if (!isServer) exitWith {};

waitUntil { !isNil "uksfta_environment_enabled" };
if (!uksfta_environment_enabled) exitWith {};

// --- DATA PROFILES ---
private _weatherProfiles = createHashMapFromArray [
    ["TEMPERATE",     [[0.2, 0, 0], [0.6, 0.2, 0.1], [0.9, 0.8, 0.3]]],
    ["ARID",          [[0.1, 0, 0], [0.3, 0, 0.05],  [0.6, 0.1, 0.1]]],
    ["ARCTIC",        [[0.2, 0, 0], [0.5, 0, 0.4],   [0.95, 0, 0.85]]],
    ["TROPICAL",      [[0.4, 0.1, 0.1], [0.8, 0.6, 0.2], [0.98, 0.95, 0.4]]],
    ["MEDITERRANEAN", [[0.1, 0, 0], [0.4, 0.1, 0.05], [0.7, 0.2, 0.1]]],
    ["SUBTROPICAL",   [[0.3, 0, 0], [0.6, 0.3, 0.1], [0.9, 0.5, 0.2]]]
];

private _physicalProfiles = createHashMapFromArray [
    ["TEMPERATE",     [10, 25, 0.5, 1013]],
    ["ARID",          [25, 45, 0.1, 1020]],
    ["ARCTIC",        [-30, 0, 0.8, 990]],
    ["TROPICAL",      [25, 32, 0.95, 1005]],
    ["MEDITERRANEAN", [18, 35, 0.4, 1015]],
    ["SUBTROPICAL",   [20, 30, 0.7, 1010]]
];

// --- INITIAL STATE ---
private _currentStateIdx = getMissionConfigValue ["UKSFTA_Environment_StartWeather", 0];
if (_currentStateIdx isEqualType "") then { _currentStateIdx = parseNumber _currentStateIdx; };

private _worldConfig = configFile >> "CfgWorlds" >> worldName;
private _nativeMaxWave = getNumber (_worldConfig >> "Sea" >> "MaxWave");
if (_nativeMaxWave == 0) then { _nativeMaxWave = 0.25; };

while {uksfta_environment_enabled} do {
    private _biome = call uksfta_environment_fnc_analyzeBiome;
    private _activeProfile = _weatherProfiles getOrDefault [_biome, _weatherProfiles get "TEMPERATE"];
    private _phys = _physicalProfiles getOrDefault [_biome, _physicalProfiles get "TEMPERATE"];
    _phys params ["_tMin", "_tMax", "_baseHumid", "_basePress"];
    
    // 1. Target
    (_activeProfile select _currentStateIdx) params ["_targetOvercast", "_targetRain", "_targetFog"];

    // 2. Transition (Select-optimized)
    private _baseTime = 1800 + (random 1800);
    private _transitionTime = _baseTime / (uksfta_environment_transitionSpeed max 0.1);
    private _finalTime = [_transitionTime, 0] select (time < 10);
    
    _finalTime setOvercast _targetOvercast;
    _finalTime setFog [_targetFog, 0.03, 0];
    
    [_finalTime, _targetRain] spawn {
        params ["_time", "_rain"];
        if (_time > 0) then { sleep (_time / 2); };
        (_time / 2) setRain _rain;
    };

    // 3. Hazard
    missionNamespace setVariable ["UKSFTA_Environment_CurrentIntensity", _targetOvercast, true];
    missionNamespace setVariable ["UKSFTA_Environment_CurrentBiome", _biome, true];

    // 4. ACE
    private _sunFactor = (sunElevation / 90) max 0;
    private _currentTemp = _tMin + ((_tMax - _tMin) * _sunFactor) - (_targetOvercast * 5);
    private _currentHumid = (_baseHumid + (_targetRain * 0.2)) min 1;
    private _currentPress = _basePress - (_targetOvercast * 10);

    if (!isNil "ace_weather_fnc_serverSetTemperature") then {
        [_currentTemp] call ace_weather_fnc_serverSetTemperature;
        [_currentHumid] call ace_weather_fnc_serverSetHumidity;
        [_currentPress] call ace_weather_fnc_serverSetBarometricPressure;
    } else {
        missionNamespace setVariable ["ace_weather_currentTemperature", _currentTemp, true];
        missionNamespace setVariable ["ace_weather_currentHumidity", _currentHumid, true];
        missionNamespace setVariable ["ace_weather_currentBarometricPressure", _currentPress, true];
    };

    // 5. Physics
    private _windStr = (_targetOvercast * 10) + (random 5);
    setWind [random _windStr, random _windStr, true];
    
    private _roll = random 100;
    private _stormChance = 30 * uksfta_environment_stormFrequency;
    if (_currentStateIdx == 1 && _roll < _stormChance) then { _currentStateIdx = 2; }
    else { _currentStateIdx = [_currentStateIdx, _activeProfile] call uksfta_environment_fnc_getNextState; };

    sleep _finalTime;
};
