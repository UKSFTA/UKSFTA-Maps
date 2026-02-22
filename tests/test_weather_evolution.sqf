#include "mock_arma.sqf"
diag_log "🧪 INITIATING 48-HOUR WEATHER EVOLUTION...";

private _activeProfile = [[0.2, 0, 0], [0.6, 0.2, 0.1], [0.9, 0.8, 0.3]];
private _currentState = 0;
private _counts = [0, 0, 0];
private _steps = 288; // 48 hours at 10-min resolution

for "_i" from 1 to _steps do {
    // Call the actual produzione logic
    private _next = [_currentState, _activeProfile] call compile preprocessFile "../addons/environment/functions/fn_getNextState.sqf";
    
    // Safety check for illegal transitions
    if (_currentState == 0 && _next == 2) then {
        diag_log format ["  ❌ ILLEGAL TRANSITION DETECTED AT STEP %1 (0 -> 2)", _i];
    };

    _currentState = _next;
    _counts set [_currentState, (_counts select _currentState) + 1];

    if (_i % 48 == 0) then {
        diag_log format ["  ⏳ Evolution Progress: %1h Complete | Current State: %2", _i / 6, _currentState];
    };
};

// --- DISTRIBUTION REPORT ---
private _clear = (_counts select 0) / _steps * 100;
private _overcast = (_counts select 1) / _steps * 100;
private _storm = (_counts select 2) / _steps * 100;

diag_log format ["📊 FINAL DISTRIBUTION: Clear: %1%% | Overcast: %2%% | Storm: %3%%", 
    ([_clear, 1] call CBA_fnc_formatNumber), 
    ([_overcast, 1] call CBA_fnc_formatNumber), 
    ([_storm, 1] call CBA_fnc_formatNumber)
];

if (_storm < 40) then {
    diag_log "✅ WEATHER BALANCE: MISSION CAPABLE (Storm occurrence within realistic bounds).";
} else {
    diag_log "⚠️  WEATHER BALANCE: ADVISORY (High storm probability detected).";
};

diag_log "🏁 Weather Evolution Complete.";
