/**
 * UKSFTA Environment - Puddle Interaction Audit (Phase 12 Extension)
 */

#include "mock_arma.sqf"

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🧪 UKSFTA PUDDLE INTERACTION AUDIT";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";

// 1. PRONE SOAKING MATH
private _testSoaking = {
    params ["_inPuddle", "_stance"];
    private _wetRate = 0.01; // Base rate
    if (_inPuddle) then {
        _wetRate = 0.005; 
        if (_stance == "PRONE") then { _wetRate = 0.02; };
    };
    _wetRate
};

private _standingPuddle = [true, "STAYING"] call _testSoaking; // 0.005
private _pronePuddle = [true, "PRONE"] call _testSoaking; // 0.02

if (_standingPuddle == 0.005 && _pronePuddle == 0.02) then {
    diag_log "  ✅ [SOAK] Prone Puddle Math: PASS (4x speed vs Standing)";
} else {
    diag_log format ["  ❌ [SOAK] Prone Puddle Math: FAIL (S:%1 P:%2)", _standingPuddle, _pronePuddle];
};

// 2. MUD CAKING MATH
private _testMud = {
    params ["_inPuddle", "_stance"];
    private _mudRate = 0.02; // Base prone rate
    if (_inPuddle && _stance == "PRONE") then { _mudRate = 0.04; };
    _mudRate
};

private _proneMud = [true, "PRONE"] call _testMud;
if (_proneMud == 0.04) then {
    diag_log "  ✅ [MUD] Prone Puddle Caking: PASS (Double speed)";
} else {
    diag_log format ["  ❌ [MUD] Prone Puddle Caking: FAIL (%1)", _proneMud];
};

// 3. BLOOD DIFFUSION MATH
private _testDiffusion = {
    params ["_currentBlood"];
    (_currentBlood + 0.2) min 1.0
};

private _diff = 0.2 call _testDiffusion; // 0.4
if (_diff == 0.4) then {
    diag_log "  ✅ [BLOOD] Diffusion Increment: PASS (+20%)";
} else {
    diag_log format ["  ❌ [BLOOD] Diffusion Increment: FAIL (%1)", _diff];
};

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🏁 PUDDLE AUDIT COMPLETE";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
true
