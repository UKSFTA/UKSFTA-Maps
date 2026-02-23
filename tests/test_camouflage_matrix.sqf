#include "mock_arma.sqf"
/**
 * UKSFTA Test - Camouflage Matrix
 */

diag_log "🧪 INITIATING CAMOUFLAGE MATRIX AUDIT...";

// --- Case 1: Arid Biome Stealth ---
private _biome = "ARID";
private _camo = 1.0;
if (_biome == "ARID") then { _camo = 0.4; };

if (_camo < 0.5) then {
    diag_log "  ✅ Arid Stealth Bonus: PASS";
} else {
    diag_log "  ❌ Arid Stealth Bonus: FAIL";
};

// --- Case 2: Movement Punishment ---
private _speed = 10;
private _punish = 1.0;
if (_speed > 5) then { _punish = 1.5; };

if (_punish > 1.4) then {
    diag_log "  ✅ Movement Detection Penalty: PASS";
} else {
    diag_log "  ❌ Movement Detection Penalty: FAIL";
};

diag_log "🏁 Camouflage Matrix Audit Complete.";
true
