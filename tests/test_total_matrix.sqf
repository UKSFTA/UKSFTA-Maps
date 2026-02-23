#include "mock_arma.sqf"
diag_log "🧪 INITIATING SOVEREIGN TOTAL MATRIX (FLUID EDITION)...";

private _biomes = ["TEMPERATE", "ARID", "ARCTIC", "TROPICAL", "MEDITERRANEAN"];
private _presets = ["ARCADE", "REALISM"];
private _times = [12, 0]; // Noon, Midnight
private _weather = [0, 0.5, 1.0]; // Clear, Overcast, Monsoon

private _physProfiles = [
    ["TEMPERATE",     [8.0, 22.0, 0.5, 1013.0]],
    ["ARID",          [22.0, 42.0, 0.1, 1020.0]],
    ["ARCTIC",        [-25.0, 2.0, 0.8, 990.0]],
    ["TROPICAL",      [24.0, 33.0, 0.9, 1005.0]],
    ["MEDITERRANEAN", [16.0, 32.0, 0.4, 1015.0]]
];

// Mock latitude for test (Chernarus standard ~50)
private _lat = 50;
private _maxPossibleAlt = (90 - _lat) max 10;

// Native Linear Conversion Polyfill
private _fnc_linear = {
    params ["_minS", "_maxS", "_val", "_minT", "_maxT"];
    if (_val <= _minS) exitWith { _minT };
    if (_val >= _maxS) exitWith { _maxT };
    private _p = (_val - _minS) / (_maxS - _minS);
    _minT + (_p * (_maxT - _minT))
};

{
    private _biome = _x;
    private _pData = [];
    { if (_x select 0 == _biome) exitWith { _pData = _x select 1; }; } forEach _physProfiles;
    _pData params ["_tMin", "_tMax", "_baseHumid", "_basePress"];

    {
        private _preset = _x;
        uksfta_environment_preset = _preset;
        missionNamespace setVariable ["UKSFTA_Environment_Biome", _biome];

        {
            _uksfta_dayTime = _x;
            {
                _uksfta_overcast = _x;
                _uksfta_rain = _uksfta_overcast;

                // 1. Fluid Solar Math
                private _sunAlt = sin ((_uksfta_dayTime - 6) * 15) * 90;
                private _sunFactor = ([0, _maxPossibleAlt, _sunAlt, 0, 1] call _fnc_linear) max 0;

                private _rawTemp = (_tMin + ((_tMax - _tMin) * _sunFactor) - (_uksfta_overcast * 4.0));
                private _rawHumid = (_baseHumid + (_uksfta_rain * 0.15)) min 1.0;

                // 2. SOFT SCALING (Arcade)
                private _finalTemp = _rawTemp;
                private _finalHumid = _rawHumid;

                if (_preset == "ARCADE") then {
                    _finalTemp = 20 + ((_rawTemp - 20) * 0.4); 
                    _finalHumid = 0.5 + ((_rawHumid - 0.5) * 0.4);
                };

                diag_log format ["  📊 [%1][%2] T:%3 W:%4 | SUN:%5 | ACE_T:%6C | ACE_H:%7", 
                    _biome, _preset, _uksfta_dayTime, _uksfta_overcast,
                    ([_sunAlt, 2] call CBA_fnc_formatNumber), 
                    ([_finalTemp, 2] call CBA_fnc_formatNumber),
                    ([_finalHumid, 2] call CBA_fnc_formatNumber)
                ];

            } forEach _weather;
        } forEach _times;
    } forEach _presets;
} forEach _biomes;

diag_log "✅ PRECISION MATRIX AUDIT COMPLETE.";
