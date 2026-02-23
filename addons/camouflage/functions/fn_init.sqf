#include "..\script_component.hpp"
/**
 * UKSFTA Camouflage - Initialization
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [CAMOUFLAGE]: Master Initialization Sequence Starting...";

// --- MAIN STEALTH LOOP ---
[] spawn {
    diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [CAMOUFLAGE]: Stealth Processing Loop Active.";
    
    // Wait for environment to resolve biome
    waitUntil { !isNil "UKSFTA_Environment_Biome" };
    
    if (missionNamespace getVariable ["uksfta_environment_logLevel", 0] > 1) then {
        diag_log text (format ["[UKSF TASKFORCE ALPHA] <TRACE> [CAMOUFLAGE]: Environment Synced. Current Biome: %1", missionNamespace getVariable ["UKSFTA_Environment_Biome", "UNKNOWN"]]);
    };

    while { missionNamespace getVariable ["uksfta_camouflage_enabled", true] } do {
        if (missionNamespace getVariable ["uksfta_environment_logLevel", 0] > 1) then {
            diag_log text "[UKSF TASKFORCE ALPHA] <TRACE> [CAMOUFLAGE]: Executing Camouflage Matrix Update...";
        };
        
        call uksfta_camouflage_fnc_applyCamouflage;
        sleep 5;
    };
    
    diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [CAMOUFLAGE]: Stealth Processing Loop Terminated.";
};

true
