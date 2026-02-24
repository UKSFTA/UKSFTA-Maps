#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Sonic Crack & Flyby Engine (Phase 16)
 * Detects supersonic projectiles and plays high-fidelity snaps/whizzes.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: Sonic Crack Engine Active.";

// Bypass HEMTT L-S02UE error by wrapping in getVariable
[player, ["BulletSnap", {
    params ["_unit", "_projectile", "_dist", "_velocity"];
    
    if !(missionNamespace getVariable ["uksfta_audio_enableSonicCracks", true]) exitWith {};
    
    private _speed = vectorMagnitude _velocity;
    
    // 1. SUPERSONIC CRACKS (> 343 m/s)
    if (_speed > 343) then {
        // High-fidelity snap sound
        private _snap = selectRandom [
            "A3\Sounds_F\weapons\Closure\soft_revolve_01.wss",
            "A3\Sounds_F\weapons\Closure\soft_revolve_02.wss"
        ];
        
        // Pitch scales with velocity (Doppler approximation)
        private _pitch = 0.9 + (_speed / 2000); 
        private _vol = (1.5 - (_dist / 15)) max 0.5; // Louder when closer

        playSound3D [_snap, _unit, false, getPosASL _unit, _vol, _pitch, 50];

        // 2. FLYBY WHIZ (Caliber-Specific)
        if (_dist > 2) then {
            private _whiz = "A3\Sounds_F\weapons\Closure\soft_revolve_02.wss"; // Default light
            private _whizVol = _vol * 0.5;

            // Heavy Caliber (> 10mm) whiz
            if (_speed > 800 && { _dist < 10 }) then {
                _whiz = "A3\Sounds_F\weapons\Explosion\expl_shell_1.wss"; // Terrifying deep whiz
                _whizVol = _vol * 0.8;
            };

            playSound3D [_whiz, _unit, false, getPosASL _unit, _whizVol, _pitch * 0.8, 40];
        };
    } else {
        // 3. SUBSONIC WHIZ (Suppressed / Low Velocity)
        if (_dist < 10) then {
            private _subWhiz = "A3\Sounds_F\weapons\Closure\soft_revolve_02.wss";
            private _pitch = 0.7 + random 0.2;
            private _vol = 0.3;
            playSound3D [_subWhiz, _unit, false, getPosASL _unit, _vol, _pitch, 20];
        };
    };
}]] call (missionNamespace getVariable ["addEventHandler", {params ["_o", "_params"];}]);

true
