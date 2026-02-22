// Mock Environment
private _activeProfile = [
    [0.2, 0, 0], // State 0 (Clear)
    [0.6, 0.2, 0.1], // State 1 (Overcast)
    [0.9, 0.8, 0.3]  // State 2 (Storm)
];

private _currentState = 0;
private _transitions = [0, 0, 0];

diag_log "🚀 STARTING WEATHER LOGIC STRESS TEST (1000 CYCLES)";

for "_i" from 1 to 1000 do {
    // We pass the parameters expected by fnc_getNextState
    private _nextState = [_currentState, _activeProfile] call {
        params ["_currentIdx", "_profile"];
        
        private _nextIdx = _currentIdx;
        private _roll = random 100;

        switch (_currentIdx) do {
            case 0: { if (_roll > 70) then { _nextIdx = 1; }; };
            case 1: {
                if (_roll < 30) then { _nextIdx = 0; }
                else { if (_roll > 70) then { _nextIdx = 2; }; };
            };
            case 2: { if (_roll < 40) then { _nextIdx = 1; }; };
        };
        _nextIdx
    };
    
    if (_currentState == 0 && _nextState == 2) then {
        diag_log "❌ CRITICAL LOGIC FAILURE: Illegal transition 0 -> 2 detected!";
    };

    _currentState = _nextState;
    _transitions set [_currentState, (_transitions select _currentState) + 1];
};

diag_log format ["📊 Results: Clear: %1, Overcast: %2, Storm: %3", _transitions select 0, _transitions select 1, _transitions select 2];
diag_log "✅ TEST COMPLETE.";
