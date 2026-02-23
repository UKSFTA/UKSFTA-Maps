#include "..\script_component.hpp"
/**
 * UKSFTA Environment - KAT Medical Hook
 * Integrates environmental factors with KAT medical systems.
 */

if (!hasInterface) exitWith {};

// --- ABSOLUTE STARTUP GUARD ---
waitUntil { !isNil "uksfta_environment_enabled" };

diag_log text (format ["[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: %1", "KAT Medical Integration Hook Active."]);

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    private _overcast = overcast;
    
    // Check for KAT presence and Realism Mode
    if (!isNil "kat_breathing_fnc_handleAsthma" && {(missionNamespace getVariable ["uksfta_environment_preset", "REALISM"]) == "REALISM"}) then {
        // High humidity induced asthma simulation
        if (_biome == "TROPICAL" && {_overcast > 0.85}) then {
            if (random 100 < 2) then {
                diag_log text (format ["[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: %1", "Environmental Humidity Trigger: KAT Asthma Event."]);
                [player] call kat_breathing_fnc_handleAsthma;
            };
        };
        
        // Arid dust inhalation simulation
        if (_biome == "ARID" && {wind select 0 > 8}) then {
            if (random 100 < 1) then {
                diag_log text (format ["[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: %1", "Arid Dust Loading Trigger: KAT Breathing Degradation."]);
                [player, 0.1] call kat_breathing_fnc_addCarbonDioxide;
            };
        };
    };

    sleep 60; // Medical evaluation cycle
};

diag_log text (format ["[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: %1", "KAT Medical Loop Terminated."]);
true
