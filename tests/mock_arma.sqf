/**
 * UKSFTA Strict Mock Environment - Diamond Grade
 */

// --- ENGINE VARIABLES ---
_mock_dayTime = 12;
_mock_overcast = 0;
_mock_rain = 0;
_mock_fog = 0;
_mock_time = 100;
_mock_lightnings = 0;

// --- ENGINE COMMANDS ---
setOvercast = { params ["_val"]; _mock_overcast = _val; };
setRain = { params ["_val"]; _mock_rain = _val; };
setFog = { params ["_val"]; _mock_fog = _val; };
diag_log = { params ["_msg"]; };
isServer = true;
hasInterface = true;
is3DEN = false;
surfaceType = { "Gras" };
getPos = { [0,0,0] };
vectorMagnitude = { 0 };
stance = { "STAND" };
uniform = { "U_B_CombatUniform_mcam" };
setUnitTrait = { true };
ppEffectEnable = { true };
ppEffectAdjust = { true };
ppEffectCommit = { true };

// SOVEREIGN HOOK: Bypasses VM parser conflict
uksfta_fnc_setTI = { true };

// --- UKSFTA GLOBALS ---
uksfta_environment_enabled = true;
uksfta_environment_preset = "REALISM";
uksfta_environment_thermalIntensity = 1.0;
uksfta_environment_visualIntensity = 1.0;
uksfta_camouflage_enabled = true;
uksfta_camouflage_aiCompat = true;
uksfta_camouflage_grassFix = true;
uksfta_camouflage_intensity = 1.0;
