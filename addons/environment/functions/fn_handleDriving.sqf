#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Driving Dynamics (Phase 18)
 * Procedural off-road bumps, wheel damage, and stuck system.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Driving Dynamics Active.";

[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _veh = objectParent player;
        
        // Only run if player is the driver
        if (!isNull _veh && { driver _veh == player } && { _veh isKindOf "LandVehicle" }) then {
            private _speed = speed _veh;
            private _onRoad = isOnRoad _veh;
            private _surface = toLower (surfaceType (getPosVisual _veh));
            private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];

            if (!_onRoad && { abs _speed > 10 }) then {
                // --- 1. TERRAIN BUMPS (Z-Force) ---
                // Random force based on speed and roughness
                private _bumpForce = (random (_speed / 50)) min 2;
                if (_bumpForce > 0.2) then {
                    _veh addForce [[0, 0, _bumpForce * 500], [0, 0, 0]];
                    addCamShake [_bumpForce, 0.5, 15];
                };

                // --- 2. WHEEL / TRACK FATIGUE ---
                // High speed off-road damages components
                if (_speed > 60) then {
                    private _damageChance = (_speed - 60) / 4000;
                    if (random 1.0 < _damageChance) then {
                        private _hitPoints = getAllHitPointsDamage _veh select 0;
                        private _wheels = _hitPoints select { (_x find "wheel" != -1) || (_x find "track" != -1) };
                        if (_wheels isNotEqualTo []) then {
                            [_veh, [selectRandom _wheels, (damage _veh) + 0.05]] remoteExec ["setHitPointDamage", _veh];
                            diag_log format ["[UKSF] <WARN>: Off-road component fatigue on %1", typeOf _veh];
                        };
                    };
                };

                // --- 3. STUCK SYSTEM (Mud / Sand / Snow) ---
                private _isBoggy = (_surface find "mud" != -1) || (_surface find "sand" != -1) || (_biome == "ARCTIC" && overcast > 0.8);
                if (_isBoggy && { _speed < 15 } && { abs _speed > 1 }) then {
                    // Risk of getting bogged down
                    private _stuckChance = (15 - _speed) / 500;
                    if (random 1.0 < _stuckChance && { isNil {_veh getVariable "UKSFTA_IsStuck"} }) then {
                        _veh setVariable ["UKSFTA_IsStuck", true, true];
                        
                        [_veh] spawn {
                            params ["_v"];
                            hint "Vehicle Bogged Down! Try to tow or reverse.";
                            
                            // Physically sink the vehicle slightly
                            private _pos = getPosASL _v;
                            private _helper = "Land_VR_Shape_01_cube_1m_F" createVehicleLocal [0,0,0];
                            _helper setPosASL [_pos select 0, _pos select 1, (_pos select 2) - 0.3];
                            _helper setVectorDirAndUp [vectorDir _v, vectorUp _v];
                            
                            _v attachTo [_helper, [0,0,0.3]];
                            
                            // Wait for help (towing or manual recovery)
                            waitUntil { sleep 2; !alive _v || { !(_v getVariable ["UKSFTA_IsStuck", false]) } };
                            
                            detach _v;
                            deleteVehicle _helper;
                        };
                    };
                };
            };
        };

        sleep 1;
    };
};

true
