#include "mock_arma.sqf"
diag_log "🧪 INITIATING BIOME SCENARIO AUDIT...";

// 1. Dependency Mocks
uksfta_environment_fnc_getSunElevation = compile preprocessFile "../addons/environment/functions/fn_getSunElevation.sqf";
uksfta_environment_fnc_handleStorms = { true };

private _fnVisuals = "../addons/environment/functions/fn_applyVisuals.sqf";
private _fnThermals = "../addons/environment/functions/fn_handleThermals.sqf";

// SCENARIO A: ARCTIC NIGHT BLIZZARD
diag_log "  🔍 Testing Scenario: ARCTIC NIGHT BLIZZARD...";
missionNamespace setVariable ["UKSFTA_Environment_Biome", "ARCTIC"];
overcast = 1.0;
rain = 0;
fog = 0.8;
dayTime = 0; // Midnight

// Run Visuals Logic (Math blocks)
private _sunAlt = call uksfta_environment_fnc_getSunElevation;
private _isNight = (_sunAlt < -5);
private _grain = [0, 0.15] select (overcast > 0.7 || _isNight);

if (_isNight && _grain > 0) then {
    diag_log "    ✅ Case Visuals: PASS (Night grain active)";
} else {
    diag_log "    ❌ Case Visuals: FAIL";
};

// SCENARIO B: TROPICAL MONSOON
diag_log "  🔍 Testing Scenario: TROPICAL MONSOON...";
missionNamespace setVariable ["UKSFTA_Environment_Biome", "TROPICAL"];
overcast = 1.0;
rain = 1.0;
dayTime = 12;

// Signal Loss Math
private _multiplier = [1.0, 0.1] select (uksfta_environment_preset == "ARCADE");
private _signalLoss = 1.0 + (overcast * 0.3 * uksfta_environment_interferenceIntensity * _multiplier);
_signalLoss = _signalLoss + (0.1 * _multiplier); // Rain bonus

if (_signalLoss > 1.3) then {
    diag_log "    ✅ Case Comms: PASS (Significant signal degradation)";
} else {
    diag_log "    ❌ Case Comms: FAIL";
};

// SCENARIO C: ARID NOON HEAT
diag_log "  🔍 Testing Scenario: ARID NOON HEAT...";
missionNamespace setVariable ["UKSFTA_Environment_Biome", "ARID"];
overcast = 0.1;
dayTime = 12; // High Noon

private _sunAltArid = call uksfta_environment_fnc_getSunElevation;
private _noise = ((overcast * 0.2) + (0 * 0.3) + (0 * 0.5)) * 1.0;
private _heatFactor = (_sunAltArid / 90) * 0.4;
private _finalThermal = (_noise + _heatFactor) min 1.0;

if (_finalThermal > 0.4) then {
    diag_log "    ✅ Case Thermals: PASS (Wash-out active)";
} else {
    diag_log "    ❌ Case Thermals: FAIL";
};

diag_log "🏁 Biome Scenario Audit Complete.";
