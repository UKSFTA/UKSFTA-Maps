// UKSFTA Test Mocks - Dummies out engine commands for headless testing
overcast = 0;
rain = 0;
fog = 0;
sunElevation = 45;
worldName = "altis";
missionNamespace setVariable ["uksfta_environment_enabled", true];
missionNamespace setVariable ["uksfta_environment_transitionSpeed", 1];
missionNamespace setVariable ["uksfta_environment_interferenceIntensity", 1];
missionNamespace setVariable ["uksfta_environment_enableSignalInterference", true];

setOvercast = { params ["_val"]; overcast = _val; };
setRain = { params ["_val"]; rain = _val; };
setFog = { params ["_val"]; fog = _val; };
diag_log = { params ["_msg"]; diag_log_output pushBack _msg; };
diag_log_output = [];
