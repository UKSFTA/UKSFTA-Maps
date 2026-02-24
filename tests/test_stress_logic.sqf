/**
 * UKSFTA Environment - Stress Logic Audit (Phase 15)
 */

#include "mock_arma.sqf"

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🧪 UKSFTA STRESS & PANIC AUDIT";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";

// 1. STRESS CALCULATION MATH
private _testStress = {
    params ["_suppression", "_health", "_fatigue", "_enemies"];
    
    private _stress = 0;
    
    // Suppression: 0.6 factor
    _stress = _stress + (_suppression * 0.6);
    
    // Low Health Panic (< 0.5)
    if (_health < 0.5) then { _stress = _stress + ((0.5 - _health) * 0.5); };
    
    // Fatigue Amplifier (> 0.2 stress)
    if (_stress > 0.2) then { _stress = _stress + (_fatigue * 0.2); };
    
    // Combat Intensity
    _stress = _stress + (_enemies * 0.05);
    
    _stress min 1.0
};

// Scenario A: Safe (Full Health, No enemies)
private _safe = [0, 1, 0, 0] call _testStress;
if (_safe == 0) then {
    diag_log "  ✅ [STRESS] Safe State: PASS (0.0)";
} else {
    diag_log format ["  ❌ [STRESS] Safe State: FAIL (%1)", _safe];
};

// Scenario B: Suppressed (0.5 suppression)
private _suppressed = [0.5, 1, 0, 0] call _testStress; // 0.3
if (abs(_suppressed - 0.3) < 0.01) then {
    diag_log "  ✅ [STRESS] Suppression Only: PASS (~0.3)";
} else {
    diag_log format ["  ❌ [STRESS] Suppression Only: FAIL (%1)", _suppressed];
};

// Scenario C: Panic (Low Health 0.1, 2 Enemies)
private _panic = [0, 0.1, 0, 2] call _testStress; 
// Health: (0.5 - 0.1) * 0.5 = 0.2
// Enemies: 2 * 0.05 = 0.1
// Total: 0.3
if (abs(_panic - 0.3) < 0.01) then {
    diag_log "  ✅ [STRESS] Low Health Panic: PASS (~0.3)";
} else {
    diag_log format ["  ❌ [STRESS] Low Health Panic: FAIL (%1)", _panic];
};

// Scenario D: FUBAR (Full Suppression, Critical Health, Exhausted, Surrounded)
private _fubar = [1.0, 0.1, 1.0, 5] call _testStress;
// Supp: 0.6
// Health: 0.2
// Fatigue: 1 * 0.2 = 0.2 (since stress > 0.2)
// Enemies: 5 * 0.05 = 0.25
// Total: 1.25 -> clamped to 1.0
if (_fubar == 1.0) then {
    diag_log "  ✅ [STRESS] Maximum Overload: PASS (Clamped to 1.0)";
} else {
    diag_log format ["  ❌ [STRESS] Maximum Overload: FAIL (%1)", _fubar];
};

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🏁 STRESS AUDIT COMPLETE";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
true
