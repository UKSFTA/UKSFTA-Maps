#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Master Init
 */

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Master Initialization Sequence Starting...";

// 1. Core Logic (Server Primary)
if (isServer) then {
    diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Server Core Detected. Initiating Biome Detection...";
    call uksfta_environment_fnc_analyzeBiome;
};

// 2. Intelligence Orchestration (Wait for Biome)
[] spawn {
    #include "..\script_component.hpp"
    waitUntil { !isNil "UKSFTA_Environment_Biome" && {UKSFTA_Environment_Biome != "PENDING"} };
    
    if (isServer && !is3DEN) then {
        diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Biome Resolved. Spawning Weather Engine...";
        [] spawn uksfta_environment_fnc_weatherCycle;
    };
    
    if (hasInterface || is3DEN) then {
        diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Biome Resolved. Spawning Modules...";
        
        [] spawn { call uksfta_environment_fnc_applyVisuals; };
        
        if (!is3DEN) then {
            [] spawn { call uksfta_environment_fnc_coldBreath; };
            [] spawn { call uksfta_environment_fnc_katMedicalHook; };
            [] spawn { call uksfta_environment_fnc_signalInterference; };
            [] spawn { call uksfta_environment_fnc_aviationTurbulence; };
            [] spawn { call uksfta_environment_fnc_uavInterference; };
            [] spawn { call uksfta_environment_fnc_initDebug; };
            [] spawn { call uksfta_environment_fnc_handleThermals; };
            [] spawn { call uksfta_environment_fnc_rainEffect; };
            [] spawn { call uksfta_environment_fnc_visualNoise; };
            [] spawn { call uksfta_environment_fnc_localClimate; };
            [] spawn { call uksfta_environment_fnc_handleCaustics; };
            [] spawn { call uksfta_environment_fnc_handleWindAudio; };

            [] spawn { call uksfta_environment_fnc_handleLightning; };
        };
    };
};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Master Initialization Sequence Handed Off.";
true
