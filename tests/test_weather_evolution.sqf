#include "mock_arma.sqf"
diag_log "🧪 INITIATING 48-HOUR WEATHER EVOLUTION (PHASE 10)...";

private _biomes = ["TEMPERATE", "ARID", "ARCTIC", "TROPICAL", "MEDITERRANEAN"];
private _steps = 288; // 48 hours at 10-min resolution

{
    private _biome = _x;
    diag_log format ["  🌐 Testing Biome: %1", _biome];
    
    private _totalOvercast = 0;
    private _totalRain = 0;
    private _stormCount = 0;

    for "_i" from 1 to _steps do {
        // Call the production logic
        private _weather = [_biome] call compile preprocessFile "../addons/environment/functions/fn_getNextState.sqf";
        _weather params ["_over", "_rain", "_fog", "_wind", "_dur"];
        
        _totalOvercast = _totalOvercast + _over;
        _totalRain = _totalRain + _rain;
        
        if (_rain > 0.5) then { _stormCount = _stormCount + 1; };

        if (_i % 144 == 0) then {
            diag_log format ["    ⏳ Progress: %1h | Last: [O:%2 R:%3 W:%4]", _i / 6, _over, _rain, _wind];
        };
    };

    private _avgO = _totalOvercast / _steps;
    private _avgR = _totalRain / _steps;
    private _stormP = (_stormCount / _steps) * 100;

    diag_log format ["  📊 [%1] AVG_OVERCAST: %2 | AVG_RAIN: %3 | STORM_FREQ: %4%%", 
        _biome, 
        ([_avgO, 2] call CBA_fnc_formatNumber), 
        ([_avgR, 2] call CBA_fnc_formatNumber),
        ([_stormP, 1] call CBA_fnc_formatNumber)
    ];
} forEach _biomes;

diag_log "✅ BIOME EVOLUTION AUDIT COMPLETE.";
diag_log "🏁 Weather Evolution Complete.";
true
