#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UKSFTA Storm Engine (Phase 8)
 * Dynamic Blizzard and Sandstorm particles based on WBK inspiration.
 */

if (!hasInterface) exitWith {};

params ["_biome", "_intensity"];

private _enableParticles = missionNamespace getVariable ["uksfta_environment_enableParticles", true];
private _multiplier = missionNamespace getVariable ["uksfta_environment_particleMultiplier", 1.0];

// 1. PERFORMANCE EXIT LOGIC
if (!_enableParticles || _multiplier <= 0 || _intensity < 0.4) exitWith {
    if (!isNil "UKSFTA_Environment_HazardEffect") then { { deleteVehicle _x; } forEach UKSFTA_Environment_HazardEffect; UKSFTA_Environment_HazardEffect = nil; };
    if (!isNil "UKSFTA_Environment_SandCC") then { ppEffectDestroy UKSFTA_Environment_SandCC; UKSFTA_Environment_SandCC = nil; };
    
    // Reset Snow
    if (_biome == "ARCTIC") then {
        [ 
            "", 1, 1, 1, 1, 1, 1, 1, 1, 1, [1, 1, 1, 1], 1, 1, 1, 1, false, false 
        ] call BIS_fnc_setRain;
    };
};

if (isNil "UKSFTA_Environment_HazardEffect") then { UKSFTA_Environment_HazardEffect = []; };

// 2. BIOME SPECIFIC LOGIC
switch (_biome) do {
    case "ARCTIC": {
        // --- BLIZZARD (Snow) ---
        // Uses high-perf setRain override for engine-level snowflakes
        [  
            "a3\data_f\snowflake16_ca.paa", 
            16, 
            0.01, 
            15, 
            0.05, 
            7 * _intensity, 
            0.5, 
            0.5, 
            0.07, 
            0.07, 
            [1, 1, 1, 0.5], 
            0.0, 
            0.2, 
            0.5, 
            0.5, 
            true, 
            false 
        ] call BIS_fnc_setRain;

        // Ground Fog / Whiteout Particles
        if (count UKSFTA_Environment_HazardEffect == 0) then {
            private _snowFog = "#particlesource" createVehicleLocal (getPosATL player);
            UKSFTA_Environment_HazardEffect pushBack _snowFog;
        };
        
        (UKSFTA_Environment_HazardEffect select 0) setParticleParams [ 
            ["\A3\Data_F\ParticleEffects\Universal\universal.p3d" , 16, 12, 13, 0], "", "Billboard", 1, 10, 
            [0, 0, -6], [0, 0, 0], 1, 1.275, 1, 0, 
            [5, 10], [[1, 1, 1, 0], [1, 1, 1, 0.1 * _intensity], [1, 1, 1, 0]], [1000], 1, 0, "", "", vehicle player
        ]; 
        (UKSFTA_Environment_HazardEffect select 0) setParticleRandom [3, [35, 35, 0], [-5, -5, -0.5], 2, 0.45, [0, 0, 0, 0.1], 0, 0];
        (UKSFTA_Environment_HazardEffect select 0) setDropInterval (0.01 / (_multiplier max 0.01));
    };

    case "ARID": {
        // --- SANDSTORM ---
        if (count UKSFTA_Environment_HazardEffect == 0) then {
            private _dust = "#particlesource" createVehicleLocal (getPosATL player);
            private _debris = "#particlesource" createVehicleLocal (getPosATL player);
            UKSFTA_Environment_HazardEffect = [_dust, _debris];
        };

        // 1. Dust Cloud
        (UKSFTA_Environment_HazardEffect select 0) setParticleParams [
            ["\A3\Data_F\ParticleEffects\Universal\universal.p3d" , 16, 12, 13, 0], "", "Billboard", 1, 10,
            [0, 0, -6], [0, 0, 0], 1, 1.275, 1, 0,
            [7, 12], [[0.8, 0.7, 0.5, 0], [0.8, 0.7, 0.5, 0.1 * _intensity], [0.8, 0.7, 0.5, 0]], [1000], 1, 0, "", "", vehicle player
        ];
        (UKSFTA_Environment_HazardEffect select 0) setParticleRandom [3, [50, 50, 0], [-5, -5, 0], 2, 0.45, [0, 0, 0, 0.1], 0, 0];
        (UKSFTA_Environment_HazardEffect select 0) setDropInterval (0.01 / (_multiplier max 0.01));

        // 2. Flying Debris (Sticks/Leaves)
        private _windX = wind select 0;
        private _windY = wind select 1;
        (UKSFTA_Environment_HazardEffect select 1) setParticleParams [
            ["\A3\data_f\ParticleEffects\Hit_Leaves\Sticks", 1, 1, 1], "", "SpaceObject", 1, 27, 
            [0, 0, 0], [_windX, _windY, 3], 2, 0.000001, 0.0, 0.1, 
            [0.5, 1.0], [[0.6, 0.5, 0.4, 1]], [1.5, 1], 13, 13, "", "", vehicle player
        ];
        (UKSFTA_Environment_HazardEffect select 1) setParticleRandom [0, [20, 20, 10], [5, 5, 2], 2, 0.1, [0, 0, 0, 0.5], 1, 1];
        (UKSFTA_Environment_HazardEffect select 1) setDropInterval (0.05 / (_multiplier max 0.01));

        // 3. Sandstorm Color Correction
        if (isNil "UKSFTA_Environment_SandCC") then {
            UKSFTA_Environment_SandCC = ppEffectCreate ["colorCorrections", 1550]; 
            UKSFTA_Environment_SandCC ppEffectEnable true; 
        };
        UKSFTA_Environment_SandCC ppEffectAdjust [0.8, 1, 0, [0.8, 0.7, 0.5, 0.1 * _intensity], [0.8, 0.7, 0.5, 0.2 * _intensity], [0.8, 0.7, 0.5, 0]]; 
        UKSFTA_Environment_SandCC ppEffectCommit 5;
    };
};

// 3. GLOBAL HAZARDS (Ashfall / Nuclear Winter)
private _globalAsh = missionNamespace getVariable ["UKSFTA_Environment_Ashfall", 0];
if (_globalAsh > 0) then {
    if (isNil "UKSFTA_Environment_AshfallEffect") then {
        UKSFTA_Environment_AshfallEffect = "#particlesource" createVehicleLocal (getPosATL player);
    };
    
    // Slow falling dark grey flakes
    UKSFTA_Environment_AshfallEffect setParticleParams [
        ["A3\Data_F\ParticleEffects\Universal\Universal", 16, 12, 8, 1], "", "Billboard", 1, 10,
        [0, 0, 0], [0, 0, -0.2], 1, 0.000001, 0, 1.4, [0.05, 0.05], [[0.1, 0.1, 0.1, 1]], [0, 1], 0.2, 1.2, "", "", player
    ];
    UKSFTA_Environment_AshfallEffect setParticleRandom [0, [20, 20, 10], [0, 0, 0], 0, 0.01, [0, 0, 0, 0.5], 0, 0];
    UKSFTA_Environment_AshfallEffect setDropInterval (0.01 / (_multiplier max 0.01));
} else {
    if (!isNil "UKSFTA_Environment_AshfallEffect") then {
        deleteVehicle UKSFTA_Environment_AshfallEffect;
        UKSFTA_Environment_AshfallEffect = nil;
    };
};

true
