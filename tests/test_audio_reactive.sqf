/**
 * UKSFTA Audio - Reactive Logic Audit (Phase 16)
 */

#include "mock_arma.sqf"

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🧪 UKSFTA REACTIVE AUDIO AUDIT";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";

// 1. SONIC CRACK PITCH MATH
private _testCrack = {
    params ["_speed"];
    0.9 + (_speed / 2000)
};

private _pistolSpeed = [380] call _testCrack; // 1.09
private _rifleSpeed = [900] call _testCrack; // 1.35

if (_pistolSpeed < _rifleSpeed) then {
    diag_log "  ✅ [SONIC] Velocity-Pitch Scaling: PASS";
} else {
    diag_log format ["  ❌ [SONIC] Velocity-Pitch Scaling: FAIL (P:%1 R:%2)", _pistolSpeed, _rifleSpeed];
};

// 2. GEAR FOLEY VOLUME MATH
private _testFoley = {
    params ["_speed", "_load"];
    (_speed / 10) * (0.5 + _load)
};

private _scout = [2, 0.2] call _testFoley; // (0.2) * 0.7 = 0.14
private _juggernaut = [6, 0.9] call _testFoley; // (0.6) * 1.4 = 0.84

if (_juggernaut > (_scout * 2)) then {
    diag_log "  ✅ [FOLEY] Weight-Volume Scaling: PASS";
} else {
    diag_log format ["  ❌ [FOLEY] Weight-Volume Scaling: FAIL (S:%1 J:%2)", _scout, _juggernaut];
};

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🏁 REACTIVE AUDIO AUDIT COMPLETE";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
true
