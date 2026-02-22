#include "mock_arma.sqf"
diag_log "🚀 INITIATING HEADLESS PERFORMANCE BENCHMARK...";

private _startTime = diag_tickTime;
private _cycles = 1000;

// Benchmark 1: Biome Analysis (Logic Depth)
for "_i" from 1 to _cycles do {
    call compile preprocessFileLineNumbers "../addons/environment/functions/fnc_analyzeBiome.sqf";
};
private _biomeTime = (diag_tickTime - _startTime) / _cycles;
diag_log format ["  📊 Biome Analysis: %1ms avg per cycle", _biomeTime * 1000];

// Benchmark 2: Weather State Machine
_startTime = diag_tickTime;
private _activeProfile = [[0.2, 0, 0], [0.6, 0.2, 0.1], [0.9, 0.8, 0.3]];
for "_i" from 1 to _cycles do {
    [1, _activeProfile] call compile preprocessFileLineNumbers "../addons/environment/functions/fnc_getNextState.sqf";
};
private _logicTime = (diag_tickTime - _startTime) / _cycles;
diag_log format ["  📊 Logic State Machine: %1ms avg per cycle", _logicTime * 1000];

diag_log "🏁 PERFORMANCE BENCHMARK COMPLETE.";
