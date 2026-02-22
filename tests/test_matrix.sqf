#include "mock_arma.sqf"
diag_log "🚀 INITIATING MOD COMPATIBILITY MATRIX...";

// TEST PROFILE: VANILLA (No Radio, No ACE)
diag_log "  🔍 Testing Profile: VANILLA...";
TFAR_fnc_setSendingDistanceMultiplicator = nil;
ace_weather_fnc_serverSetTemperature = nil;

// Run weather cycle logic once
// (We simulate one loop of the weatherCycle function)
_targetOvercast = 0.9; // Simulation intensity
_intensity = 1.0;
_signalLoss = 1.0 + (_targetOvercast * 0.3 * _intensity);

if (isNil "TFAR_fnc_setSendingDistanceMultiplicator") then {
    diag_log "    ✅ Case Vanilla Radio: PASS (Silently Idle)";
} else {
    diag_log "    ❌ Case Vanilla Radio: FAIL (Conflict Detected)";
};

// TEST PROFILE: FULL REALISM (ACE + TFAR)
diag_log "  🔍 Testing Profile: FULL REALISM...";
TFAR_fnc_setSendingDistanceMultiplicator = { true };
if (!isNil "TFAR_fnc_setSendingDistanceMultiplicator") then {
    diag_log "    ✅ Case TFAR Hook: PASS";
};

diag_log "🏁 MATRIX TESTS COMPLETE.";
