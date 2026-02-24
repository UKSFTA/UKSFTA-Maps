#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Bullet Impact Engine
 * Plays impact sounds when bullets hit surfaces.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: Bullet Impact Engine Active.";

player addEventHandler ["HitPart", {
    params ["_target", "_shooter", "_bullet", "_position", "_velocity", "_selection", "_ammo", "_direction", "_radius", "_surface", "_direct"];

    if (_target != player) exitWith {}; // Only for player hits for now, or expand to all

    private _impactSound = format ["uksfta_bullet_hit_%1", 1 + floor random 8];
    
    playSound3D [_impactSound, _position, false, _position, 1.0, 1.0, 50];
}];
