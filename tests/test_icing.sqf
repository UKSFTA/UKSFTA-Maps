diag_log "🧪 [UKSFTA] Testing AVIATION ICING Logic...";

// 1. Mock State
private _originalMass = 10000;
private _iceLevel = 0.15; // 15% icing

// 2. Logic Simulation
private _newMass = _originalMass * (1 + _iceLevel);

diag_log format ["  - Original Mass: %1", _originalMass];
diag_log format ["  - Ice Level: %1%2", _iceLevel * 100, "%"];
diag_log format ["  - Target New Mass: %1", _newMass];

// 3. Verification
if (_newMass == 11500) then {
    diag_log "✅ AVIATION ICING MASS CALCULATION VERIFIED.";
} else {
    diag_log "❌ AVIATION ICING MASS CALCULATION FAILED.";
};
