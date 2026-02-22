#include "mock_arma.sqf"
diag_log "🧪 INITIATING CAMOUFLAGE MATRIX AUDIT...";

private _fn = "../addons/camouflage/functions/fn_applyCamouflage.sqf";

// SCENARIO 1: Stealth Match
missionNamespace setVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
uniform = { "U_B_CombatUniform_mcam" }; 
stance = { "PRONE" };
surfaceType = { "#Gras" };

call compile preprocessFile _fn;
private _camo = player getVariable "camouflageCoef";

if (_camo < 0.5) then {
    diag_log "    ✅ Case Stealth Match: PASS";
} else {
    diag_log "    ❌ Case Stealth Match: FAIL";
};

// SCENARIO 2: Winter Penalty
missionNamespace setVariable ["UKSFTA_Environment_Biome", "ARCTIC"];
uniform = { "U_B_CombatUniform_mcam" }; 
stance = { "STAND" };

call compile preprocessFile _fn;
private _punish = player getVariable "camouflageCoef";

if (_punish > 1.4) then {
    diag_log "    ✅ Case Arctic Penalty: PASS";
} else {
    diag_log "    ❌ Case Arctic Penalty: FAIL";
};

diag_log "🏁 Camouflage Matrix Audit Complete.";
