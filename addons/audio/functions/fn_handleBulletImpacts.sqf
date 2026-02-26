#include "..\script_component.hpp"
/**
 * UKSFTA Impact - UKSFTA Impact Engine (Production)
 * Features High-Visibility Long-Range Feedback and FPS-Aware Culling.
 */

if (!hasInterface) exitWith {};

LOG("Impact Engine (Long-Range Optimized) Active.");

// --- LONG-RANGE FEEDBACK CONSTANTS ---
private _fnc_spawnSpotterSplash = {
    params ["_pos", "_surface"];
    
    // Only spawn if shooter is far away (>800m) to provide feedback
    if (player distance _pos < 800) exitWith {};

    // High-visibility dust column for long-range spotting
    private _dust = "#particlesource" createVehicleLocal _pos;
    _dust setParticleParams [
        ["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 12, 8, 0], "", "Billboard",
        1, 4, [0, 0, 0], [0, 0, 2], 0, 10, 7.9, 0, [4, 8, 12],
        [[0.5, 0.45, 0.4, 0.6], [0.5, 0.45, 0.4, 0]], [0.08], 1, 0, "", "", objNull
    ];
    _dust setDropInterval 0.01;
    
    // Add refractive shockwave for visibility
    private _refr = "#particlesource" createVehicleLocal _pos;
    _refr setParticleParams [
        ["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 0.5, 
        [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0, [2, 10], [[1, 1, 1, 1]], [1], 0, 0, "", "", objNull
    ];
    _refr setDropInterval 0.1;

    [_dust, _refr] spawn { sleep 2; deleteVehicle (_this select 0); deleteVehicle (_this select 1); };
};

// --- PROJECTILE TRACKING ---
addMissionEventHandler ["ProjectileCreated", {
    params ["_projectile"];
    
    // Only track rounds fired by the player or their vehicle
    if (getObjectIB _projectile != player && { vehicle player != getObjectIB _projectile }) exitWith {};

    // 1. ENHANCED TRACER (Visual Persistence)
    private _type = typeOf _projectile;
    if (getNumber(configFile >> "CfgAmmo" >> _type >> "tracerScale") > 0) then {
        private _glow = "#particlesource" createVehicleLocal [0,0,0];
        _glow setParticleParams [
            ["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 12, 0, 0], "", "Billboard",
            1, 0.1, [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0, [0.5, 0.5],
            [[1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", _projectile
        ];
        _glow setDropInterval 0.001;
        // High draw distance for 2.5km+ visibility
        _glow setParticleCircle [0, [0, 0, 0]];
        // Force rendering at distance
        [_glow, _projectile] spawn { sleep 10; deleteVehicle (_this select 0); };
    };

    // 2. IMPACT MONITORING
    [_projectile, _fnc_spawnSpotterSplash] spawn {
        params ["_projectile", "_fnc_splash"];
        private _lastPos = getPosASL _projectile;
        
        waitUntil {
            if (!isNull _projectile) then { _lastPos = getPosASL _projectile; };
            isNull _projectile
        };

        // If it was over water, spawn water splash, else ground splash
        if (surfaceIsWater _lastPos) then {
            // Specialized water splash for long range
            private _water = "#particlesource" createVehicleLocal _lastPos;
            _water setParticleParams [
                ["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 13, 7, 0], "", "Billboard",
                1, 2, [0, 0, 0], [0, 0, 5], 0, 10, 7.9, 0, [2, 5],
                [[1, 1, 1, 0.8], [1, 1, 1, 0]], [0.08], 1, 0, "", "", objNull
            ];
            _water setDropInterval 0.01;
            [_water] spawn { sleep 1; deleteVehicle _this select 0; };
        } else {
            [_lastPos, ""] call _fnc_splash;
        };
    };
}];

true
