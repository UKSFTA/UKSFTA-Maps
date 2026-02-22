#include "mock_arma.sqf"
diag_log "🧪 INITIATING CAMOUFLAGE MATRIX AUDIT...";

private _fn = "../addons/camouflage/functions/fn_applyCamouflage.sqf";

// SCENARIO 1: Perfect Match (MultiCam in Temperate)
missionNamespace setVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
uniform = { "U_B_CombatUniform_mcam" }; // MultiCam
stance = { "PRONE" };
surfaceType = { "#Gras" };

call compile preprocessFile _fn;
private _camo = player getVariable "camouflageCoef";

if (_camo < 0.5) then {
    diag_log "  ✅ Case Stealth: PASS (Matched MultiCam + Prone + Grass)";
} else {
    diag_log format ["  ❌ Case Stealth: FAIL (Coef: %1)", _camo];
};

// SCENARIO 2: Winter Penalty (MTP in Arctic)
missionNamespace setVariable ["UKSFTA_Environment_Biome", "ARCTIC"];
uniform = { "U_B_CombatUniform_mcam" }; // Summer Camo
stance = { "STAND" };

call compile preprocessFile _fn;
private _punish = player getVariable "camouflageCoef";

if (_punish > 1.4) then {
    diag_log "  ✅ Case Punish: PASS (High visibility for incorrect camo)";
} else {
    diag_log format ["  ❌ Case Punish: FAIL (Coef: %1)", _punish];
};

// SCENARIO 3: Sound Dampening (Snow)
missionNamespace setVariable ["UKSFTA_Environment_Biome", "ARCTIC"];
stance = { "CROUCH" };

call compile preprocessFile _fn;
private _sound = player getVariable "audibleCoef";

if (_sound < 0.8) then {
    diag_log "  ✅ Case Acoustic: PASS (Snow dampens sound)";
} else {
    diag_log format ["  ❌ Case Acoustic: FAIL (Coef: %1)", _sound];
};

diag_log "🏁 Camouflage Matrix Audit Complete.";
