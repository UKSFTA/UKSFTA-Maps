#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Cold Breath Effect
 * Physiological immersion for arctic/cold biomes.
 */

if (!hasInterface) exitWith {};

// Strict guard: Wait for settings to sync
waitUntil { !isNil "uksfta_environment_enabled" };

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    
    // Only execute in cold conditions
    if (_biome == "ARCTIC" || {overcast > 0.8}) then {
        private _unit = player;
        if (alive _unit && {vehicle _unit == _unit}) then {
            // Logic for particle effect
            // [Effect Logic]
        };
    };

    sleep 4; // Physiological breathing rate
};
true
