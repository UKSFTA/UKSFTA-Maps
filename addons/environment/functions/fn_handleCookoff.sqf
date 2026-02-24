#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Cook-off Engine (Phase 16 Extension)
 * Simulates procedural ammunition cook-off for destroyed armored vehicles.
 */

if (!hasInterface) exitWith {};

UKSFTA_Env_fnc_triggerCookoff = {
    params ["_veh"];
    if (!(_veh isKindOf "Tank" || _veh isKindOf "Wheeled_APC_F")) exitWith {};

    [_veh] spawn {
        params ["_obj"];
        
        // 1. Initial Intense Burn
        private _duration = 20 + (random 40);
        private _endTime = time + _duration;
        
        diag_log format ["[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Cook-off Started for %1", typeOf _obj];

        while {time < _endTime && !isNull _obj} do {
            // High-Frequency secondary "pops"
            if (random 1.0 < 0.3) then {
                private _popPos = _obj modelToWorld [random 2 - 1, random 2 - 1, random 1];
                
                // Audio: Metallic snap/pop
                playSound3D ["A3\Sounds_F\weapons\Closure\soft_revolve_01.wss", _obj, false, getPosASL _obj, 2, 1.5 + random 0.5, 50];
                
                // Visual: Spark/Small Fire burst
                private _spark = "#particlesource" createVehicleLocal _popPos;
                _spark setParticleParams [
                    ["\A3\data_f\ParticleEffects\Universal\Universal", 16, 13, 2, 0], "", "Billboard", 1, 0.1, 
                    [0, 0, 0], [0, 0, 1], 0, 10, 7.9, 0, [0.1, 0.2], [[1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", _obj
                ];
                _spark setDropInterval 0.01;
                [_spark] spawn { sleep 0.1; deleteVehicle (_this select 0); };
            };

            // Rare heavy ammunition detonation
            if (random 1.0 < 0.05) then {
                "SmallSecondary" createVehicleLocal (getPosATL _obj);
                playSound3D ["A3\Sounds_F\weapons\Explosion\expl_shell_1.wss", _obj, false, getPosASL _obj, 4, 0.8 + random 0.4, 300];
                addCamShake [2, 1, 15];
            };

            sleep (0.5 + random 1.5);
        };
        
        diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Cook-off Expired.";
    };
};

true
