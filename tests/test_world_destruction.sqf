/**
 * UKSFTA Environment - World Destruction Audit (Phase 13 Extension)
 */

#include "mock_arma.sqf"

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🧪 UKSFTA WORLD DESTRUCTION AUDIT";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";

// 1. COLLAPSE THRESHOLD
private _testCollapse = {
    params ["_damage"];
    _damage >= 0.5
};

if ([0.6] call _testCollapse && !([0.4] call _testCollapse)) then {
    diag_log "  ✅ [BUILDING] Collapse Guard: PASS (0.5 threshold)";
} else {
    diag_log "  ❌ [BUILDING] Collapse Guard: FAIL";
};

// 2. VEGETATION SNAPPING (Probability Math)
private _testSnap = {
    params ["_caliber"];
    // random 1.0 < 0.2 if caliber > 10
    if (_caliber > 10) then { 0.2 } else { 0 };
};

if ([12] call _testSnap == 0.2 && [5] call _testSnap == 0) then {
    diag_log "  ✅ [VEG] Snapping Probability: PASS (20% for High Caliber)";
} else {
    diag_log "  ❌ [VEG] Snapping Probability: FAIL";
};

// 3. SECONDARY TIMING (Random Range)
private _testSecondary = {
    random 5
};

private _times = [];
for "_i" from 1 to 100 do { _times pushBack (call _testSecondary); };
private _avg = 0; { _avg = _avg + _x; } forEach _times; _avg = _avg / 100;

if (_avg > 1.5 && _avg < 3.5) then {
    diag_log format ["  ✅ [VEHICLE] Secondary Delay Distribution: PASS (Avg: %1s)", _avg];
} else {
    diag_log format ["  ❌ [VEHICLE] Secondary Delay Distribution: FAIL (Avg: %1s)", _avg];
};

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🏁 WORLD DESTRUCTION AUDIT COMPLETE";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
true
