#include "..\script_component.hpp"
/**
 * UKSFTA Impact - UKSFTA Impact Engine (Production)
 * Features High-Visibility Long-Range Feedback and FPS-Aware Culling.
 */

if (!hasInterface) exitWith {};

LOG("Impact Engine (Long-Range Optimized) Active.");

// --- LONG-RANGE FEEDBACK SUITE ---
uksfta_audio_fnc_spawnSpotterSplash = {
    params ["_pos", "_surface"];
    
    if (player distance _pos < 800) exitWith {};

    private _dust = "#particlesource" createVehicleLocal _pos;
    _dust setParticleParams [
        ["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 12, 8, 0], "", "Billboard",
        1, 4, [0, 0, 0], [0, 0, 2], 0, 10, 7.9, 0, [4, 8, 12],
        [[0.5, 0.45, 0.4, 0.6], [0.5, 0.45, 0.4, 0]], [0.08], 1, 0, "", "", objNull
    ];
    _dust setDropInterval 0.01;
    
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
    
    private _parents = getShotParents _projectile;
    private _shooter = _parents select 0;
    if (_shooter != player && { vehicle player != _shooter }) exitWith {};

    private _type = typeOf _projectile;
    if (getNumber(configFile >> "CfgAmmo" >> _type >> "tracerScale") > 0) then {
        private _glow = "#particlesource" createVehicleLocal [0,0,0];
        _glow setParticleParams [
            ["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 12, 0, 0], "", "Billboard",
            1, 0.1, [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0, [0.5, 0.5],
            [[1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", _projectile
        ];
        _glow setDropInterval 0.001;
        _glow setParticleCircle [0, [0, 0, 0]];
        [_glow, _projectile] spawn { sleep 10; deleteVehicle (_this select 0); };
    };

    // 2. IMPACT MONITORING
    [_projectile] spawn {
        params ["_projectile"];
        private _lastPos = getPosASL _projectile;
        
        waitUntil {
            if (!isNull _projectile) then { _lastPos = getPosASL _projectile; };
            isNull _projectile
        };

        if (surfaceIsWater _lastPos) then {
            private _water = "#particlesource" createVehicleLocal _lastPos;
            _water setParticleParams [
                ["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 13, 7, 0], "", "Billboard",
                1, 2, [0, 0, 0], [0, 0, 5], 0, 10, 7.9, 0, [2, 5],
                [[1, 1, 1, 0.8], [1, 1, 1, 0]], [0.08], 1, 0, "", "", objNull
            ];
            _water setDropInterval 0.01;
            [_water] spawn { params ["_obj"]; sleep 1; deleteVehicle _obj; };
        } else {
            [_lastPos, ""] call uksfta_audio_fnc_spawnSpotterSplash;
        };
    };
}];

true
