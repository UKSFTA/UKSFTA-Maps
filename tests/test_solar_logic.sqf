#include "mock_arma.sqf"
diag_log "🧪 Testing Solar Altitude Logic (FULL 24H CYCLE)...";

private _fn = "/ext/Development/UKSFTA-Maps/addons/environment/functions/fn_getSunElevation.sqf";

// Test Case 1: High Noon (12:00)
_mock_dayTime = 12;
private _elev12 = call compile preprocessFile _fn;
if (_elev12 > 80) then { diag_log "  ✅ Case 12:00: PASS"; } else { diag_log format ["  ❌ Case 12:00: FAIL (%1)", _elev12]; };

// Test Case 2: Midnight (00:00)
_mock_dayTime = 0;
private _elev00 = call compile preprocessFile _fn;
if (_elev00 < -80) then { diag_log "  ✅ Case 00:00: PASS"; } else { diag_log format ["  ❌ Case 00:00: FAIL (%1)", _elev00]; };

// Test Case 3: Sunrise (06:00)
_mock_dayTime = 6;
private _elev06 = call compile preprocessFile _fn;
if (_elev06 > -5 && _elev06 < 5) then { diag_log "  ✅ Case 06:00: PASS"; } else { diag_log format ["  ❌ Case 06:00: FAIL (%1)", _elev06]; };

diag_log "🏁 Solar Tests Complete.";
