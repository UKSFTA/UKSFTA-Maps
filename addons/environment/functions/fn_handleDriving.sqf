#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UKSFTA Driving Dynamics (Optimized PFH)
 * Features Component Caching and Surface Throttling.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Driving Dynamics (Optimized) Starting...";

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
            if (!_onRoad && { abs _speed > 5 }) then {
                
                // Cache surface type (every 1s)
                private _surface = _veh getVariable ["UKSFTA_Drv_CachedSurface", ""];
                if (diag_frameCount % 60 == 0) then {
                    _surface = toLower (surfaceType (getPosVisual _veh));
                    _veh setVariable ["UKSFTA_Drv_CachedSurface", _surface];
                };
                
                // TERRAIN BUMPS
                private _bumpForce = (random (_speed / 50)) min 2;
                if (_bumpForce > 0.3) then {
                    _veh addForce [[0, 0, _bumpForce * 500], [0, 0, 0]];
                    addCamShake [_bumpForce, 0.5, 15];
                };

                // COMPONENT FATIGUE (Cached Hitpoints)
                if (diag_frameCount % 120 == 0 && _speed > 60) then {
                    private _wheels = _veh getVariable ["UKSFTA_Drv_CachedWheels", []];
                    if (_wheels isEqualTo []) then {
                        private _hitPoints = getAllHitPointsDamage _veh select 0;
                        _wheels = _hitPoints select { (_x find "wheel" != -1) || (_x find "track" != -1) };
                        _veh setVariable ["UKSFTA_Drv_CachedWheels", _wheels];
                    };

                    if (random 1 < 0.05 && _wheels isNotEqualTo []) then {
                        [_veh, [selectRandom _wheels, (damage _veh) + 0.05]] remoteExec ["setHitPointDamage", _veh];
                        ["Off-road component fatigue detected.", "WARN"] call uksfta_main_fnc_notify;
                    };
                };
            };
        };
    },
    0.1
] call CBA_fnc_addPerFrameHandler;

true
