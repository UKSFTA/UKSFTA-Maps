#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UKSFTA World Destruction (Phase 13 Extension)
 * Advanced building collapse, vegetation damage, and secondary explosions.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: World Destruction Engine Active.";

// Event Handler for World Hits (Explosions/High Caliber)
addMissionEventHandler ["MapSingleClick", { /* Debug Tool if needed */ }];

// Core Destruction Logic
UKSFTA_Env_fnc_triggerCollapse = {
    params ["_building"];
    if (damage _building < 0.5) exitWith {};

    [_building] spawn {
        params ["_obj"];
        
        // 1. Initial Rumble
        if (player distance _obj < 100) then {
            addCamShake [2, 5, 10];
            playSound3D ["A3\Sounds_F\environment\uins\uins_collapse_1.wss", _obj];
        };

        // 2. Progressive Collapse (Vanguard/Blastcore Synergy)
        for "_i" from 1 to 5 do {
            private _dust = "#particlesource" createVehicleLocal (getPosATL _obj);
            _dust setParticleParams [
                ["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 12, 8, 1], "", "Billboard",
                1, 5, [0, 0, 0], [0, 0, 2], 0, 10, 7.9, 0.075, [2, 5, 10],
                [[0.5, 0.45, 0.3, 0.5], [0.5, 0.45, 0.3, 0]], [0.08], 1, 0, "", "", _obj
            ];
            _dust setDropInterval 0.01;
            [_dust] spawn { sleep 3; deleteVehicle (_this select 0); };
            
            _obj setDamage ((damage _obj) + 0.1);
            sleep 1;
        };
    };
};

// VEGETATION DESTRUCTION (Vanguard Integration)
UKSFTA_Env_fnc_handleVegetation = {
    params ["_target", "_projectile", "_caliber"];
    
    private _model = toLower ((getModelInfo _target) select 0);
    if ("tree" in _model || "bush" in _model) then {
        // Create visceral bark/leaf burst
        private _leaves = "#particlesource" createVehicleLocal (getPosATL _target);
        _leaves setParticleParams [
            ["\A3\Data_F\ParticleEffects\Universal\Vegetation", 16, 12, 1, 1], "", "SpaceObject",
            1, 2, [0, 0, 1], [random 2 - 1, random 2 - 1, 1], 1, 10, 7.9, 0.075, [0.1, 0.1],
            [[0.1, 0.3, 0.1, 1], [0.1, 0.3, 0.1, 0]], [0.08], 1, 0, "", "", _target
        ];
        _leaves setDropInterval 0.01;
        [_leaves] spawn { sleep 1; deleteVehicle (_this select 0); };

        if (_caliber > 10 && { random 1.0 < 0.2 }) then {
            _target setDamage 1; // Snap the tree
        };
    };
};

// SECONDARY EXPLOSIONS (Blastcore Integration)
UKSFTA_Env_fnc_handleSecondary = {
    params ["_vehicle"];
    if (!(_vehicle isKindOf "AllVehicles")) exitWith {};

    [_vehicle] spawn {
        params ["_veh"];
        sleep (random 5);
        if (!alive _veh) then {
            private _pos = getPosATL _veh;
            "SmallSecondary" createVehicleLocal _pos;
            
            // Physical Shockwave
            if (player distance _veh < 30) then {
                addCamShake [5, 2, 10];
                player setVelocity ((velocity player) vectorAdd ((vectorNormalized ((getPosASL player) vectorDiff (getPosASL _veh))) vectorMultiply 2));
            };

            // Ground Dust Puff (Blastcore Integration)
            private _dust = "#particlesource" createVehicleLocal _pos;
            _dust setParticleParams [
                ["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 12, 8, 1], "", "Billboard",
                1, 3, [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0.075, [5, 10, 15],
                [[0.6, 0.5, 0.4, 0.3], [0.6, 0.5, 0.4, 0]], [0.08], 1, 0, "", "", _veh
            ];
            _dust setDropInterval 0.01;
            [_dust] spawn { sleep 2; deleteVehicle (_this select 0); };

            // Audio Delay (Speed of Sound)
            [_veh, "A3\Sounds_F\weapons\Explosion\expl_big_1.wss", 500] call uksfta_environment_fnc_handleSpeedOfSound;
            
            // Blastcore Refraction
            private _refr = "#particlesource" createVehicleLocal _pos;
            _refr setParticleParams [
                ["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 0.5, 
                [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0, [2, 5], [[1, 1, 1, 1]], [1], 0, 0, "", "", _veh
            ];
            _refr setDropInterval 0.1;
            [_refr] spawn { sleep 0.5; deleteVehicle (_this select 0); };

            // Trigger Cook-off for Armored Vehicles
            [_veh] call uksfta_environment_fnc_handleCookoff;
        };
    };
};

true
