#include "mock_arma.sqf"
diag_log "🧪 Testing Solar Altitude Logic (GLOBAL HOOK)...";

private _fn = "/ext/Development/UKSFTA-Maps/addons/environment/functions/fn_getSunElevation.sqf";

// Test Case 1: High Noon (12:00)
missionNamespace setVariable ["uksfta_test_mock_dayTime", 12];
private _elev12 = call compile preprocessFile _fn;
if (_elev12 > 80) then { diag_log "  ✅ Case 12:00: PASS"; } else { diag_log format ["  ❌ Case 12:00: FAIL (%1)", _elev12]; };

// Test Case 2: Midnight (00:00)
missionNamespace setVariable ["uksfta_test_mock_dayTime", 0];
private _elev00 = call compile preprocessFile _fn;
if (_elev00 < -80) then { diag_log "  ✅ Case 00:00: PASS"; } else { diag_log format ["  ❌ Case 00:00: FAIL (%1)", _elev00]; };

// Reset
missionNamespace setVariable ["uksfta_test_mock_dayTime", nil];
diag_log "🏁 Solar Tests Complete.";
