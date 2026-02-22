/**
 * UKSFTA Environment - Hazard Handler
 * Performance Optimized with Client Controls.
 */

if (!hasInterface) exitWith {};

params ["_biome", "_intensity"];

// 1. PERFORMANCE EXIT LOGIC
if (!uksfta_environment_enableParticles || uksfta_environment_particleMultiplier <= 0 || _intensity < 0.7) exitWith {
    if (!isNil "UKSFTA_Environment_HazardEffect") then {
        deleteVehicle UKSFTA_Environment_HazardEffect;
        UKSFTA_Environment_HazardEffect = nil;
    };
    if (!isNil "UKSFTA_Environment_AudioSource") then {
        deleteVehicle UKSFTA_Environment_AudioSource;
        UKSFTA_Environment_AudioSource = nil;
    };
};

private _particleClass = "";
private _color = [1, 1, 1, 1];

switch (_biome) do {
    case "ARID": { 
        _particleClass = "ObjectDestructionDust1"; 
        _color = [0.8, 0.7, 0.5, 0.3];
    };
    case "ARCTIC": {
        _particleClass = "FileGrain"; 
        _color = [1, 1, 1, 0.5];
    };
};

if (_particleClass == "") exitWith {};

// 2. PARTICLE SOURCE INITIALIZATION
if (isNil "UKSFTA_Environment_HazardEffect") then {
    UKSFTA_Environment_HazardEffect = "#particlesource" createVehicleLocal (getPosATL player);
};

UKSFTA_Environment_HazardEffect setParticleParams [
    [_particleClass, 1, 0, 1], "", "Billboard", 1, 4, [0, 0, 0], [0, 0.2, 0], 
    1, 1.2, 1, 0, [5, 10], [_color, _color], [1000], 0, 0, "", "", player
];
UKSFTA_Environment_HazardEffect setParticleRandom [
    2, [20, 20, 5], [5, 5, 0], 0, 0.5, [0, 0, 0, 0.1], 0, 0
];

// 3. APPLY CLIENT PERFORMANCE MULTIPLIER
private _dropInterval = 0.01 / (uksfta_environment_particleMultiplier max 0.01);
UKSFTA_Environment_HazardEffect setDropInterval _dropInterval;

true
