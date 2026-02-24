#include "mock_arma.sqf"
diag_log "🧪 INITIATING 48-HOUR WEATHER EVOLUTION (INLINED AUDIT)...";

private _biomes = ["TEMPERATE", "ARID", "ARCTIC", "TROPICAL", "MEDITERRANEAN"];
private _steps = 288; // 48 hours at 10-min resolution

{
    private _biome = _x;
    diag_log format ["  🌐 Testing Biome: %1", _biome];
    
    private _totalOvercast = 0;
    private _totalRain = 0;
    private _stormCount = 0;

    for "_i" from 1 to _steps do {
        // INLINED STATE MACHINE (Matches fn_getNextState.sqf)
        private _overcast = 0;
        private _rain = 0;
        private _wind = 2 + random 5;

        switch (toUpper _biome) do {
            case "ARID": { _overcast = random 0.3; _rain = 0; _wind = 5 + random 10; };
            case "TROPICAL": { _overcast = 0.4 + random 0.6; _rain = if (_overcast > 0.7) then { 0.2 + random 0.8 } else { 0 }; _wind = 2 + random 4; };
            case "ARCTIC": { _overcast = 0.2 + random 0.8; _rain = 0; _wind = 8 + random 12; };
            case "MEDITERRANEAN": { _overcast = random 0.5; _rain = if (_overcast > 0.8) then { 0.1 + random 0.3 } else { 0 }; _wind = 3 + random 6; };
            default { _overcast = random 1.0; _rain = if (_overcast > 0.7) then { random 0.5 } else { 0 }; _wind = 2 + random 8; };
        };
        
        _totalOvercast = _totalOvercast + _overcast;
        _totalRain = _totalRain + _rain;
        if (_rain > 0.5) then { _stormCount = _stormCount + 1; };

        if (_i % 144 == 0) then {
            diag_log format ["    ⏳ Progress: %1h | Last: [O:%2 R:%3 W:%4]", _i / 6, _overcast, _rain, _wind];
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
