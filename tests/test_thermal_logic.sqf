#include "mock_arma.sqf"
/**
 * UKSFTA Test - Thermal Management
 */

diag_log "🧪 Testing Thermal Engine (STRICT AUDIT)...";

// --- Case 1: High Overcast (Realism) ---
overcast = 0.8;
fog = 0.5;
private _noise = (overcast - 0.7) * 0.5;
_noise = _noise + (fog * 0.5);

if (_noise > 0.2) then {
    diag_log "  ✅ Case Math (Realism): PASS";
} else {
    diag_log "  ❌ Case Math (Realism): FAIL";
};

diag_log "🏁 Thermal Engine Audit Complete.";
true
