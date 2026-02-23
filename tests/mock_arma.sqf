/**
 * UKSFTA Test Infrastructure - Mock Arma 3 Environment
 * Refactored for maximum SQFVM compatibility.
 */

// --- ENGINE VARIABLES ---
overcast = 0; 
rain = 0; 
fog = 0; 
lightnings = 0; 
sunElevation = 45; 
worldName = "Altis"; 
worldSize = 30720; 

// --- MISSION VARIABLES ---
_uksfta_dayTime = 12;

// --- COMMAND EMULATIONS ---
diag_log = { };
ppEffectCreate = { [random 1000] };
ppEffectEnable = { true };
ppEffectAdjust = { true };
ppEffectCommit = { true };
ppEffectDestroy = { true };
simulWeatherSync = { true };
setTIParameter = { true };
setOvercast = { overcast = _this select 0; true };
setRain = { rain = _this select 0; true };
setFog = { fog = _this select 0; true };
setLightnings = { lightnings = _this select 0; true };
setWind = { true };

// CBA Emulations
CBA_fnc_formatNumber = { _this select 0 };
CBA_fnc_waitAndExecute = { true };
CBA_fnc_addSetting = { true };

// Object Emulations
player = [0,0,0];
vehicle = { player };
objectParent = { objNull };
alive = { true };
isEngineOn = { true };
currentVisionMode = { 0 };
getPosVisual = { [0,0,0] };
getDir = { 0 };
cameraView = { "EXTERNAL" };
getUnitTrait = { 1.0 };

true;
