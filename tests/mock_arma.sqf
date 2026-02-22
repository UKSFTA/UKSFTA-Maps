/**
 * UKSFTA Strict Mock Environment
 * Only defines genuine Arma 3 engine commands/namespaces.
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

// --- ENGINE COMMANDS (Strict Mocks) ---
setOvercast = { params ["_val"]; overcast = _val; };
setRain = { params ["_val"]; rain = _val; };
setFog = { params ["_val"]; fog = _val; };
diag_log = { params ["_msg"]; };
diag_tickTime = 1000;
sunOrMoon = 1;
lightnings = 0; // Correct engine command mock
worldName = "altis";
isServer = true;
hasInterface = true;
is3DEN = false;

// --- CBA SYSTEM ---
CBA_fnc_addSetting = { true };
CBA_fnc_formatNumber = { params ["_n"]; str _n };
CBA_fnc_waitAndExecute = { true };

// --- MISSION VARS ---
uksfta_environment_enabled = true;
uksfta_environment_debug = false;
uksfta_environment_preset = "REALISM";
uksfta_environment_thermalIntensity = 1.0;
uksfta_environment_enableThermals = true; // Added missing global
uksfta_environment_transitionSpeed = 1.0;
uksfta_environment_interferenceIntensity = 1.0;
uksfta_environment_enableSignalInterference = true;
uksfta_environment_enableTurbulence = true;
uksfta_environment_turbulenceIntensity = 1.0;
