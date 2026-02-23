#include "..\script_component.hpp"
/**
 * UKSFTA Camouflage - Initialization
 */

if (!hasInterface) exitWith {};

LOG_INFO("Master Initialization Sequence Starting...");

// --- MAIN STEALTH LOOP ---
[] spawn {
    #include "..\script_component.hpp"
    LOG_INFO("Stealth Processing Loop Active.");
    
    // Wait for environment to resolve biome
    waitUntil { !isNil "UKSFTA_Environment_Biome" };
    LOG_TRACE(format ["Environment Synced. Current Biome: %1", missionNamespace getVariable ["UKSFTA_Environment_Biome", "UNKNOWN"]]);

    while { missionNamespace getVariable ["uksfta_camouflage_enabled", true] } do {
        LOG_TRACE("Executing Camouflage Matrix Update...");
        call uksfta_camouflage_fnc_applyCamouflage;
        sleep 5;
    };
    
    LOG_INFO("Stealth Processing Loop Terminated (Master Toggle).");
};

true
