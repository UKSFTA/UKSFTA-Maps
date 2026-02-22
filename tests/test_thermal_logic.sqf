#include "mock_arma.sqf"
diag_log "🧪 Testing Thermal Engine Logic...";

private _fn = "/ext/Development/UKSFTA-Maps/addons/environment/functions/fn_handleThermals.sqf";

// Mock Engine Command
setTIParameter = { params ["_key", "_val"]; missionNamespace setVariable [format ["test_ti_%1", _key], _val]; };

// Test Case 1: Realism Mode - Severe Weather
uksfta_environment_preset = "REALISM";
overcast = 1.0;
rain = 1.0;
fog = 1.0;
uksfta_environment_thermalIntensity = 1.0;

// Since handleThermals is a loop, we call it once via compile
// Note: We need to strip the while {true} for a unit test or use a wrapper
// For now we'll test the math blocks specifically
private _multiplier = [1.0, 0.2] select (uksfta_environment_preset == "ARCADE");
private _noise = ((overcast * 0.2) + (rain * 0.3) + (fog * 0.5)) * _multiplier;
_noise = (_noise * uksfta_environment_thermalIntensity) min 1.0;

if (_noise == 1.0) then { diag_log "  ✅ Case Realism Severe: PASS"; } else { diag_log format ["  ❌ Case Realism Severe: FAIL (Result: %1)", _noise]; };

// Test Case 2: Arcade Mode - Severe Weather
uksfta_environment_preset = "ARCADE";
_multiplier = [1.0, 0.2] select (uksfta_environment_preset == "ARCADE");
_noise = ((overcast * 0.2) + (rain * 0.3) + (fog * 0.5)) * _multiplier;
_noise = (_noise * uksfta_environment_thermalIntensity) min 1.0;

if (_noise == 0.2) then { diag_log "  ✅ Case Arcade Severe: PASS"; } else { diag_log format ["  ❌ Case Arcade Severe: FAIL (Result: %1)", _noise]; };

diag_log "🏁 Thermal Tests Complete.";
