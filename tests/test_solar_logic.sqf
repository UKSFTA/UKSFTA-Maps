#include "mock_arma.sqf"
diag_log "🧪 Testing Solar Altitude Logic...";

private _fn = "/ext/Development/UKSFTA-Maps/addons/environment/functions/fn_getSunElevation.sqf";

// Test Case 1: High Noon (12:00)
dayTime = 12;
private _elev12 = call compile preprocessFileLineNumbers _fn;
if (_elev12 > 85) then { diag_log "  ✅ Case 12:00 (Peak): PASS"; } else { diag_log format ["  ❌ Case 12:00 (Peak): FAIL (Result: %1)", _elev12]; };

// Test Case 2: Midnight (00:00)
dayTime = 0;
private _elev00 = call compile preprocessFileLineNumbers _fn;
if (_elev00 < -85) then { diag_log "  ✅ Case 00:00 (Nadir): PASS"; } else { diag_log format ["  ❌ Case 00:00 (Nadir): FAIL (Result: %1)", _elev00]; };

// Test Case 3: Sunset (18:00)
dayTime = 18;
private _elev18 = call compile preprocessFileLineNumbers _fn;
if (_elev18 > -5 && _elev18 < 5) then { diag_log "  ✅ Case 18:00 (Horizon): PASS"; } else { diag_log format ["  ❌ Case 18:00 (Horizon): FAIL (Result: %1)", _elev18]; };

diag_log "🏁 Solar Tests Complete.";
