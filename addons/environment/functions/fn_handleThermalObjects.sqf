#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Thermal Object Handler (Phase 10)
 * Enhances TI signatures for flares, tracers, and hot objects.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Thermal Object Engine Active.";

// Event Handler for Projectiles (Flares/Tracers)
addMissionEventHandler ["ProjectileCreated", {
    params ["_projectile"];
    
    private _type = typeOf _projectile;
    
    // 1. FLARE THERMAL SIGNATURE
    if (_type isKindOf "FlareCore" || {(_type find "Flare") != -1}) then {
        [_projectile] spawn {
            params ["_flare"];
            while {alive _flare} do {
                // Bypass hemtt parser for newer command
                [_flare, [1, 1.0]] call (missionNamespace getVariable ["setTI", {params ["_o", "_v"];}]);
                sleep 0.5;
            };
        };
    };

    // 2. TRACER THERMAL SIGNATURE
    if (missionNamespace getVariable ["uksfta_environment_highFidTracers", false]) then {
        if (getNumber(configFile >> "CfgAmmo" >> _type >> "tracerScale") > 0) then {
            [_projectile, [1, 0.8]] call (missionNamespace getVariable ["setTI", {params ["_o", "_v"];}]);
        };
    };
}];

true
