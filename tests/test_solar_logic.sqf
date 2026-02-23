#include "mock_arma.sqf"
/**
 * UKSFTA Test - Solar Elevation Logic
 */

diag_log "🧪 Testing Solar Altitude (PURE MATH & SYNTAX)...";

// Case 1: Noon
_uksfta_dayTime = 12;
private _sunAlt = sin ((_uksfta_dayTime - 6) * 15) * 90;
if (_sunAlt > 80) then {
    diag_log "  ✅ Math 12:00: PASS";
} else {
    diag_log "  ❌ Math 12:00: FAIL";
};

// Case 2: Midnight
_uksfta_dayTime = 0;
_sunAlt = sin ((_uksfta_dayTime - 6) * 15) * 90;
if (_sunAlt < -80) then {
    diag_log "  ✅ Math 00:00: PASS";
} else {
    diag_log "  ❌ Math 00:00: FAIL";
};

diag_log "🏁 Solar Hard-Proof Complete.";
true
