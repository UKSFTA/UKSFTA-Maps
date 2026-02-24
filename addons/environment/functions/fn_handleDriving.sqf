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
            
            // --- 0. CENTER OF MASS NORMALIZATION ---
            // Lower COM to prevent unrealistic 'Arcade Flipping' (Realistic Driving suite)
            if (isNil {_veh getVariable "UKSFTA_COM_Adjusted"}) then {
                private _com = getCenterOfMass _veh;
                _veh setCenterOfMass [_com select 0, _com select 1, (_com select 2) - 0.2];
                _veh setVariable ["UKSFTA_COM_Adjusted", true];
            };

            private _speed = speed _veh;
            private _onRoad = isOnRoad _veh;
            private _surface = toLower (surfaceType (getPosVisual _veh));
            private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];

            // --- 1. TOWING RECOVERY BRIDGE ---
            // If vehicle is stuck, check for ropes to release it
            if (_veh getVariable ["UKSFTA_IsStuck", false]) then {
                if (ropes _veh isNotEqualTo []) then {
                    _veh setVariable ["UKSFTA_IsStuck", false, true];
                    hint "Vehicle recovering via tow...";
                };
            };

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
                    // Risk of getting bogged down (Scale chance by Rain intensity)
                    private _softnessMod = 1 + (rain * 0.5); // Up to 50% more likely in heavy rain
                    private _stuckChance = ((15 - _speed) / 500) * _softnessMod;
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

                // --- 4. SLOPE INSTABILITY (Phase 18 Extension) ---
                private _up = vectorUp _veh;
                private _angle = acos (_up select 2);
                if (_angle > 25) then {
                    // Apply lateral force to simulate sliding on steep slopes
                    private _slideForce = (sin _angle) * 2000;
                    _veh addForce [[_slideForce, 0, 0], [0, 0, 0]];
                    if (_angle > 35 && _speed > 20) then { _veh setVelocityModelSpace [0, -2, 0]; }; // Lose traction
                };
            };

            // --- 5. IMPACT / JUMP DAMAGE ---
            private _velZ = (velocity _veh) select 2;
            private _lastVelZ = _veh getVariable ["UKSFTA_LastVelZ", 0];
            private _deltaZ = abs (_velZ - _lastVelZ);
            
            if (_deltaZ > 10 && {istouchingground _veh}) then {
                // Hard landing detected (> 5m fall equivalent)
                private _dmg = (_deltaZ - 10) / 20;
                _veh setDamage (damage _veh + _dmg);
                playSound3D ["A3\Sounds_F\vehicles\soft\Wheeled_Collision01.wss", _veh];
                diag_log format ["[UKSF]: Vehicle Impact Damage: %1 (DeltaZ: %2)", _dmg, _deltaZ];
            };
            _veh setVariable ["UKSFTA_LastVelZ", _velZ];
        };

        sleep 1;
    };
};

true
