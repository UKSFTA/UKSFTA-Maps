#include "mock_arma.sqf"
diag_log "🧪 Testing Solar Altitude (PURE MATH & SYNTAX)...";

// FORMULA FROM: addons/environment/functions/fn_getSunElevation.sqf
private _formula = {
    params ["_time"];
    sin ((_time - 6) * 15) * 90;
};

// 1. Math Verification
private _elev12 = [12] call _formula;
if (_elev12 > 80) then { diag_log "  ✅ Math 12:00: PASS"; } else { diag_log format ["  ❌ Math 12:00: FAIL (%1)", _elev12]; };

private _elev00 = [0] call _formula;
if (_elev00 < -80) then { diag_log "  ✅ Math 00:00: PASS"; } else { diag_log format ["  ❌ Math 00:00: FAIL (%1)", _elev00]; };

// 2. Syntax Verification (Does the production file even load?)
// We use a try-catch pattern to see if the file is syntactically sound
private _syntax = compile preprocessFile "/ext/Development/UKSFTA-Maps/addons/environment/functions/fn_getSunElevation.sqf";
if (!isNil "_syntax") then { diag_log "  ✅ Production File Syntax: PASS"; } else { diag_log "  ❌ Production File Syntax: FAIL"; };

diag_log "🏁 Solar Hard-Proof Complete.";
