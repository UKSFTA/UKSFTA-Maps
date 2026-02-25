#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Meteorological Engine (Multiplayer Optimized)
 * Server-Side Authority with State-Machine Offloading.
 */

if (!isServer) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Sovereign Meteorological Engine (Server Mode) Starting...";

// --- 1. SERVER-SIDE MET MATH ---
UKSFTA_Env_Server_Pressure = 1013.25;
UKSFTA_Env_Server_Moisture = 0.5;
UKSFTA_Env_Server_Trend = 0;

// Centralized state-check for clients (JIP Friendly)
missionNamespace setVariable ["UKSFTA_Env_State_Pressure", UKSFTA_Env_Server_Pressure, true];
missionNamespace setVariable ["UKSFTA_Env_State_Moisture", UKSFTA_Env_Server_Moisture, true];

// --- 2. PERFORMANCE ORCHESTRATOR (CBA PFH) ---
// We move weather evolution to a low-frequency staggered loop
[
    {
        // Gradual Pressure Nudge (Staggered to once every 10 seconds)
        UKSFTA_Env_Server_Trend = (UKSFTA_Env_Server_Trend + (random 0.1 - 0.05)) max -1 min 1;
        UKSFTA_Env_Server_Pressure = (UKSFTA_Env_Server_Pressure + (UKSFTA_Env_Server_Trend * 1.5)) max 960 min 1040;
        
        private _moistureDelta = if (UKSFTA_Env_Server_Pressure < 1005) then { 0.02 } else { -0.01 };
        UKSFTA_Env_Server_Moisture = (UKSFTA_Env_Server_Moisture + _moistureDelta) max 0.1 min 1.0;

        // Broadcast only if significant change (>0.5% shift)
        private _oldP = missionNamespace getVariable ["UKSFTA_Env_State_Pressure", 1013];
        if (abs(_oldP - UKSFTA_Env_Server_Pressure) > 0.5) then {
            missionNamespace setVariable ["UKSFTA_Env_State_Pressure", UKSFTA_Env_Server_Pressure, true];
            missionNamespace setVariable ["UKSFTA_Env_State_Moisture", UKSFTA_Env_Server_Moisture, true];
        };

        // Resolve Visual Targets
        private _targetOvercast = (linearConversion [1020, 980, UKSFTA_Env_Server_Pressure, 0, 1, true] + (UKSFTA_Env_Server_Moisture * 0.5)) min 1.0;
        private _targetRain = if (_targetOvercast > 0.7 && UKSFTA_Env_Server_Trend < 0) then { (UKSFTA_Env_Server_Moisture * 0.2) } else { 0 };

        // Apply engine transitions (Long windows for stability)
        600 setOvercast _targetOvercast;
        60 setRain _targetRain;
        simulWeatherSync;
    },
    10 // Run every 10 seconds on server only
] call CBA_fnc_addPerFrameHandler;

true
