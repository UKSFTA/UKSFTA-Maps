#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Cold Breath Effect
 * Physiological immersion for arctic/cold biomes.
 */

if (!hasInterface) exitWith {};

// --- ABSOLUTE STARTUP GUARD ---
waitUntil { !isNil "uksfta_environment_enabled" };

LOG_INFO("Cold Breath Physiological Hook Active.");

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    private _temp = missionNamespace getVariable ["ace_weather_currentTemperature", 20];
    
    // Execute if biome is Arctic OR temp is below 5C
    if (_biome == "ARCTIC" || _temp < 5) then {
        private _unit = player;
        if (alive _unit && {isNull objectParent _unit} && {cameraView != "INTERNAL"}) then {
            // High-Fidelity Particle Logic
            drop [
                ["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 13, 0],
                "", "Billboard", 0.5, 0.5, 
                [0, 0, 0], [0, 0.2, -0.2], 
                1, 1.275, 1, 0.2, 
                [0, 0.2, 0.35], [[1, 1, 1, 0.5], [1, 1, 1, 0]], 
                [1000], 1, 0.04, "", "", _unit, 
                (360 - (getDir _unit)), true, 0.1
            ];
            LOG_TRACE("Breath Particle Spawned.");
        };
    };

    sleep (2.5 + random 2); // Dynamic respiratory rate
};

LOG_INFO("Cold Breath Loop Terminated.");
true
