/**
 * UKSFTA Impact - Sovereign Impact Logic Audit (Phase 13)
 */

#include "mock_arma.sqf"

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🧪 UKSFTA IMPACT & DESTRUCTION AUDIT";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";

// 1. KINETIC KNOCKDOWN LOGIC
private _testKnockdown = {
    params ["_damage", "_caliber"];
    // (random 1.0 < (_damage * (_caliber min 2)))
    private _chance = _damage * (_caliber min 2);
    _chance
};

private _lowHit = [0.1, 1.0] call _testKnockdown; // 0.1
private _highHit = [0.5, 3.0] call _testKnockdown; // 1.0 (Guaranteed)

if (_lowHit == 0.1 && _highHit == 1.0) then {
    diag_log "  ✅ [KINETIC] Knockdown Probability: PASS";
} else {
    diag_log format ["  ❌ [KINETIC] Knockdown Probability: FAIL (L:%1 H:%2)", _lowHit, _highHit];
};

// 2. HEADGEAR PENETRATION LOGIC
private _testHelmet = {
    params ["_caliber", "_armor"];
    // (_caliber * 10 > _armor)
    (_caliber * 10 > _armor)
};

private _pistolVsHeavy = [0.5, 12] call _testHelmet; // 5 > 12 = False
private _rifleVsLight = [1.2, 4] call _testHelmet;  // 12 > 4 = True

if (!_pistolVsHeavy && _rifleVsLight) then {
    diag_log "  ✅ [GOKO] Helmet Penetration Logic: PASS";
} else {
    diag_log format ["  ❌ [GOKO] Helmet Penetration Logic: FAIL (P:%1 R:%2)", _pistolVsHeavy, _rifleVsLight];
};

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🏁 IMPACT AUDIT COMPLETE";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
true
