/**
 * UKSFTA Strict Mock Environment - Sovereign Grade
 */

// --- SHADOWED ENGINE VARIABLES ---
_uksfta_dayTime = 12;
_uksfta_overcast = 0;
_uksfta_rain = 0;
_uksfta_fog = 0;
_uksfta_time = 100;
_uksfta_lightnings = 0;

// --- ENGINE COMMANDS ---
setOvercast = { params ["_val"]; _uksfta_overcast = _val; };
setRain = { params ["_val"]; _uksfta_rain = _val; };
setFog = { params ["_val"]; _uksfta_fog = _val; };
diag_log = { params ["_msg"]; };
isServer = true;
hasInterface = true;
is3DEN = false;
stance = { "PRONE" };
uniform = { "U_B_CombatUniform_mcam" };
surfaceType = { "#Gras" };
getVariable = { params ["_obj", "_var", "_def"]; _val = _obj getVariable [_var, _def]; if (isNil "_val") then { _def } else { _val }; };
setVariable = { params ["_obj", "_var", "_val"]; _obj setVariable [_var, _val]; };
setUnitTrait = { params ["_trait", "_val"]; player setVariable [_trait, _val]; };
ppEffectEnable = { true };
ppEffectAdjust = { true };
ppEffectCommit = { true };
addForce = { true };
vectorModelToWorld = { _this select 1 };
sin = { sin _this }; // VM native
cos = { cos _this };
abs = { abs _this };
finite = { finite _this };

// SOVEREIGN HOOK: Bypasses VM parser conflict for setTIParameter
uksfta_fnc_setTI = { true };

// --- UKSFTA GLOBALS ---
uksfta_environment_enabled = true;
uksfta_environment_preset = "REALISM";
uksfta_environment_thermalIntensity = 1.0;
uksfta_environment_visualIntensity = 1.0;
uksfta_environment_interferenceIntensity = 1.0;
uksfta_environment_turbulenceIntensity = 1.0;
uksfta_environment_transitionSpeed = 1.0;
uksfta_camouflage_enabled = true;
uksfta_camouflage_aiCompat = true;
uksfta_camouflage_grassFix = true;
uksfta_camouflage_intensity = 1.0;
