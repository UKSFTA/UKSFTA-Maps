#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Cold Breath Effect
 * Physiological immersion for arctic/cold biomes.
 */

if (!hasInterface) exitWith {};

// --- ABSOLUTE STARTUP GUARD ---
waitUntil { !isNil "uksfta_environment_enabled" };

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Cold Breath Physiological Hook Active.";

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    private _temp = missionNamespace getVariable ["ace_weather_currentTemperature", 20];
    
    // Execute if biome is Arctic OR temp is below 5C
    if (_biome == "ARCTIC" || _temp < 5) then {
        private _unit = player;
        // removed cameraView != "INTERNAL" to allow first person
        if (alive _unit && {isNull objectParent _unit}) then {
            // Precise Head attachment
            private _headPos = _unit selectionPosition "head";
            
            // High-Fidelity Particle Logic (Refined for First Person)
            drop [
                ["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 13, 0],
                "", "Billboard", 1, 1.5, 
                _headPos, [0, 0, 0], 
                1, 1.275, 1, 0, 
                [0, 0.2, 0.4], [[1, 1, 1, 0.05], [1, 1, 1, 0]], 
                [1000], 1, 0, "", "", _unit
            ];
            
            if (missionNamespace getVariable ["uksfta_environment_logLevel", 0] > 1) then {
                diag_log text "[UKSF TASKFORCE ALPHA] <TRACE> [ENVIRONMENT]: Breath Particle Spawned (Attached).";
            };
        };
    };

    // Dynamic Respiratory Rate Scaling
    // 16 bpm = ~3.75s interval. 40 bpm = ~1.5s interval.
    private _breathRate = missionNamespace getVariable ["UKSFTA_Environment_BreathRate", 16];
    private _interval = 60 / (_breathRate max 1);
    
    sleep (_interval + (random 0.5));
};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Cold Breath Loop Terminated.";
true
