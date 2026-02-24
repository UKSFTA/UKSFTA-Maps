#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Sonic Crack & Flyby Engine (Phase 16)
 * Detects supersonic projectiles and plays high-fidelity snaps/whizzes.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: Sonic Crack Engine Active.";

player addEventHandler ["BulletSnap", {
    params ["_unit", "_projectile", "_dist", "_velocity"];
    
    private _speed = vectorMagnitude _velocity;
    
    // Only crack if supersonic (> 343 m/s)
    if (_speed > 343) then {
        // High-fidelity snap sound
        // Using vanilla high-quality snaps or JSRS overrides if present
        private _snap = selectRandom [
            "A3\Sounds_F\weapons\Closure\soft_revolve_01.wss",
            "A3\Sounds_F\weapons\Closure\soft_revolve_02.wss"
        ];
        
        // Pitch scales with velocity (Doppler approximation)
        private _pitch = 0.9 + (_speed / 2000); 
        private _vol = (1.5 - (_dist / 15)) max 0.5; // Louder when closer

        playSound3D [_snap, _unit, false, getPosASL _unit, _vol, _pitch, 50];
    };
}];

true
