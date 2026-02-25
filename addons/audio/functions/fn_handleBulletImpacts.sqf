#include "..\script_component.hpp"
/**
 * UKSFTA Impact - UKSFTA Impact Engine (Production)
 * Optimized kinetic reactions and material-aware gore.
 * Features FPS-Aware Culling and Quota Management to prevent lag.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [IMPACT]: Bullet Impact Engine Active (Performance Optimized).";

UKSFTA_Gore_Quota = 0; // Global counter to prevent particle spam

["CAManBase", "HitPart", {
    (_this select 0) params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect"];

    if !(missionNamespace getVariable ["uksfta_phys_enableGore", true]) exitWith {};
    
    // --- PERFORMANCE SAFEGUARDS ---
    // 1. FPS Culling: Disable expensive FX if client is lagging (< 30 FPS)
    if (diag_fps < 30) exitWith {};
    
    // 2. Proximity Culling: Only process if within 100m of player
    if (player distance _target > 100) exitWith {};

    // 3. Quota Management: Limit active gore emitters to 5 per second
    if (UKSFTA_Gore_Quota > 5) exitWith {};
    UKSFTA_Gore_Quota = UKSFTA_Gore_Quota + 1;
    [] spawn { sleep 1; UKSFTA_Gore_Quota = (UKSFTA_Gore_Quota - 1) max 0; };

    private _damage = _ammo select 1;
    private _caliber = _ammo select 2;

    // --- GORE LOGIC ---
    if (_damage > 0.3) then {
        // Headshot: Brain/Skull chunks
        if ("head" in _selection) then {
            private _skull = "#particlesource" createVehicleLocal _position;
            _skull setParticleClass "UKSFTA_SkullChunks";
            [_skull] spawn { sleep 0.1; deleteVehicle (_this select 0); };
        };

        // Torso: Meat Gibs
        if (_damage > 0.6 && {("spine" in (_selection select 0) || "body" in (_selection select 0))}) then {
            private _meat = "#particlesource" createVehicleLocal _position;
            _meat setParticleClass "UKSFTA_MeatGibs";
            [_meat] spawn { sleep 0.1; deleteVehicle (_this select 0); };
        };
    };

    // --- KINETIC RAGDOLL ---
    if (_damage > 0.5 && {random 1 < (_caliber / 5)}) then {
        [_target] spawn {
            params ["_unit"];
            if (alive _unit && {isNil {_unit getVariable "UKSFTA_Knockdown"}}) then {
                _unit setVariable ["UKSFTA_Knockdown", true];
                _unit setUnconscious true;
                sleep (2 + random 3);
                _unit setUnconscious false;
                _unit setVariable ["UKSFTA_Knockdown", nil];
            };
        };
    };
}] call (missionNamespace getVariable ["CBA_fnc_addClassEventHandler", {}]);

true
