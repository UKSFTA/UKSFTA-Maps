#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Cold Breath Effect
 * Physiological immersion for arctic/cold biomes.
 */

if (!hasInterface) exitWith {};

// --- ABSOLUTE STARTUP GUARD ---
// Wait for settings to physically exist in missionNamespace
waitUntil { !isNil "uksfta_environment_enabled" };

// Safe loop condition using getVariable fallback
while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _enabled = missionNamespace getVariable ["uksfta_environment_enabled", false];
    if (!_enabled) exitWith {};

    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    
    // Only execute in cold conditions
    if (_biome == "ARCTIC" || {overcast > 0.8}) then {
        private _unit = player;
        // Optimization: HEMTT compliant check
        if (alive _unit && {isNull objectParent _unit}) then {
            // [Particle Effect Logic]
        };
    };

    sleep 4; // Physiological breathing rate
};
true
