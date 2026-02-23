/**
 * UKSFTA Advanced Test - Dependency Resilience
 * Verifying graceful degradation in non-modded environments.
 */

diag_log "🛡️ INITIATING RESILIENCE AUDIT (VANILLA SIMULATION)";

// 1. Clear all mod hooks
kat_breathing_fnc_handleAsthma = nil;
ace_weather_fnc_calculateTemperature = nil;
tf_fnc_setSendingDistanceMultiplicator = nil;

// 2. Execute KAT Hook (Should exit silently without error)
diag_log "  🔍 Testing KAT Medical Hook (Mod Missing)...";
private _res = call uksfta_environment_fnc_katMedicalHook;
if (!isNil "_res") then { diag_log "    ✅ Success: Exited Gracefully."; } else { diag_log "    ❌ Failure: Unexpected State."; };

// 3. Execute Signal Interference (Mod Missing)
diag_log "  🔍 Testing Signal Interference (Mod Missing)...";
_res = call uksfta_environment_fnc_signalInterference;
if (!isNil "_res") then { diag_log "    ✅ Success: System Defaulted Gracefully."; } else { diag_log "    ❌ Failure: System Halted."; };

diag_log "✅ RESILIENCE AUDIT COMPLETE.";
true;
