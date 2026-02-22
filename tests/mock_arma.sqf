/**
 * UKSFTA Strict Mock Environment - Advanced
 * Adds support for Unit properties and Physics.
 */

// --- GLOBAL NAMESPACES ---
missionNamespace = objNull; 
uiNamespace = objNull;
parsingNamespace = objNull;

// --- ENGINE VARIABLES ---
dayTime = 12;
overcast = 0;
rain = 0;
fog = 0;
time = 100;
lightnings = 0;
sunOrMoon = 1;
worldName = "altis";

// --- ENGINE COMMANDS ---
setOvercast = { params ["_val"]; overcast = _val; };
setRain = { params ["_val"]; rain = _val; };
setFog = { params ["_val"]; fog = _val; };
diag_log = { params ["_msg"]; };
diag_tickTime = 1000;
isServer = true;
hasInterface = true;
is3DEN = false;
surfaceType = { "Gras" };
getPos = { [0,0,0] };
getPosATL = { [0,0,0] };
speed = { 0 };
velocity = { [0,0,0] };
vectorMagnitude = { 0 };
stance = { "STAND" };
uniform = { "U_B_CombatUniform_mcam" };
difficultyEnabled = { false };
objectParent = { objNull };
isKindOf = { false };
driver = { objNull };
gunner = { objNull };
vectorModelToWorld = { _this select 1 };
addForce = { true };
setTIParameter = { true };
ppEffectEnable = { true };
ppEffectAdjust = { true };
ppEffectCommit = { true };
setUnitTrait = { params ["_trait", "_val"]; player setVariable [_trait, _val]; };

// --- OBJECTS ---
player = objNull;
configFile = objNull;

// --- CBA SYSTEM ---
CBA_fnc_addSetting = { true };
CBA_fnc_formatNumber = { params ["_n"]; str _n };
CBA_fnc_waitAndExecute = { true };

// --- UKSFTA GLOBALS ---
uksfta_environment_enabled = true;
uksfta_environment_preset = "REALISM";
uksfta_environment_thermalIntensity = 1.0;
uksfta_environment_transitionSpeed = 1.0;
uksfta_environment_interferenceIntensity = 1.0;
uksfta_environment_enableSignalInterference = true;
uksfta_environment_enableThermals = true;
uksfta_environment_visualIntensity = 1.0;
uksfta_environment_enableTurbulence = true;
uksfta_environment_turbulenceIntensity = 1.0;
uksfta_camouflage_enabled = true;
uksfta_camouflage_aiCompat = true;
uksfta_camouflage_grassFix = true;
uksfta_camouflage_intensity = 1.0;
