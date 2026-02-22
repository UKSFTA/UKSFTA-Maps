#include "mock_arma.sqf"
diag_log "🧪 INITIATING SOVEREIGN TOTAL MATRIX (PRECISION EDITION)...";

private _biomes = ["TEMPERATE", "ARID", "ARCTIC", "TROPICAL", "MEDITERRANEAN", "SUBTROPICAL"];
private _presets = ["ARCADE", "REALISM"];
private _times = [12, 0]; // Noon, Midnight
private _weather = [0, 1]; // Clear, Storm

private _physProfiles = [
    ["TEMPERATE",     [10.0, 25.0, 0.5, 1013.0]],
    ["ARID",          [25.0, 45.0, 0.1, 1020.0]],
    ["ARCTIC",        [-30.0, 0.0, 0.8, 990.0]],
    ["TROPICAL",      [25.0, 32.0, 0.95, 1005.0]],
    ["MEDITERRANEAN", [18.0, 35.0, 0.4, 1015.0]],
    ["SUBTROPICAL",   [20.0, 30.0, 0.7, 1010.0]]
];

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
                _uksfta_rain = _uksfta_overcast * 0.5;

                // --- CALCULATION TRACE (PRECISION) ---
                private _sunAlt = sin ((_uksfta_dayTime - 6) * 15) * 90;
                private _sunFactor = (_sunAlt / 90.0) max 0.0;

                // Math from production
                private _aceTemp = (_tMin + ((_tMax - _tMin) * _sunFactor) - (_uksfta_overcast * 5.0)) + 0.0;
                private _aceHumid = ((_baseHumid + (_uksfta_rain * 0.2)) min 1.0) + 0.0;

                // --- VERBOSE LOG (WITH DECIMALS) ---
                diag_log format ["  📊 [%1][%2] T:%3 W:%4 | SUN:%5 | ACE_T:%6C | ACE_H:%7", 
                    _biome, _preset, _uksfta_dayTime, _uksfta_overcast,
                    ([_sunAlt, 2] call CBA_fnc_formatNumber), 
                    ([_aceTemp, 2] call CBA_fnc_formatNumber),
                    ([_aceHumid, 2] call CBA_fnc_formatNumber)
                ];

            } forEach _weather;
        } forEach _times;
    } forEach _presets;
} forEach _biomes;

diag_log "✅ PRECISION MATRIX AUDIT COMPLETE.";
