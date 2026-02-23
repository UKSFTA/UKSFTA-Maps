#include "..\script_component.hpp"
/**
 * UKSFTA Camouflage - Initialization
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [CAMOUFLAGE]: Master Initialization Sequence Starting...";

// --- MAIN STEALTH LOOP ---
[] spawn {
    #include "..\script_component.hpp"
    diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [CAMOUFLAGE]: Stealth Processing Loop Active.";
    
    // Wait for environment to resolve biome
    waitUntil { !isNil "UKSFTA_Environment_Biome" };
    
    while { missionNamespace getVariable ["uksfta_camouflage_enabled", true] } do {
        call uksfta_camouflage_fnc_applyCamouflage;
        sleep 5;
    };
    
    diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [CAMOUFLAGE]: Stealth Processing Loop Terminated.";
};

true
