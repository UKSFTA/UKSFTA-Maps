#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Driving Dynamics (PFH Optimized)
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Driving Dynamics (PFH Mode) Starting...";

[
    {
        if !(missionNamespace getVariable ["uksfta_main_enabled", true] && {missionNamespace getVariable ["uksfta_phys_enableDriving", true]}) exitWith {};

        private _veh = objectParent player;
        if (!isNull _veh && { driver _veh == player } && { _veh isKindOf "LandVehicle" }) then {
            
            // --- 0. CENTER OF MASS (Run Once) ---
            if (isNil {_veh getVariable "UKSFTA_COM_Adjusted"}) then {
                private _com = getCenterOfMass _veh;
                _veh setCenterOfMass [_com select 0, _com select 1, (_com select 2) - 0.2];
                _veh setVariable ["UKSFTA_COM_Adjusted", true];
            };

            private _speed = speed _veh;
            private _onRoad = isOnRoad _veh;

            // --- 1. PERFORMANCE THROTTLING ---
            // Only run physics updates if moving or off-road
            if (!_onRoad && { abs _speed > 5 }) then {
                private _surface = toLower (surfaceType (getPosVisual _veh));
                
                // TERRAIN BUMPS (Z-Force)
                private _bumpForce = (random (_speed / 50)) min 2;
                if (_bumpForce > 0.3) then {
                    _veh addForce [[0, 0, _bumpForce * 500], [0, 0, 0]];
                    addCamShake [_bumpForce, 0.5, 15];
                };

                // COMPONENT FATIGUE (Throttled)
                if (diag_frameCount % 30 == 0 && _speed > 60) then {
                    if (random 1 < 0.05) then {
                        private _hitPoints = getAllHitPointsDamage _veh select 0;
                        private _wheels = _hitPoints select { (_x find "wheel" != -1) || (_x find "track" != -1) };
                        if (_wheels isNotEqualTo []) then {
                            [_veh, [selectRandom _wheels, (damage _veh) + 0.05]] remoteExec ["setHitPointDamage", _veh];
                            ["Off-road component fatigue detected.", "WARN"] call uksfta_main_fnc_notify;
                        };
                    };
                };
            };
        };
    },
    0.1 // High-frequency but throttled internally
] call CBA_fnc_addPerFrameHandler;

true
