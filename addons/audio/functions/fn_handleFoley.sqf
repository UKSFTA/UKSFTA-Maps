#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Gear Foley Engine (Phase 16)
 * Simulates equipment rattle and movement noise based on weight and speed.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: Gear Foley Engine Active.";

[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _speed = vectorMagnitude (velocity player);
        private _load = load player; // 0 to 1 range (approx)
        
        if (_speed > 1.5 && {isNull objectParent player}) then {
            // Movement detected, play foley
            private _vol = (_speed / 10) * (0.5 + _load);
            private _pitch = 0.9 + (random 0.2);
            
            // Randomized gear sound classes (JSRS Internalized)
            private _sound = selectRandom [
                "z\uksfta\addons\audio\sounds\character\foley\adjust_short1.wss",
                "z\uksfta\addons\audio\sounds\character\foley\adjust_short2.wss",
                "z\uksfta\addons\audio\sounds\character\foley\adjust_short3.wss"
            ];

            playSound3D [_sound, player, false, getPosASL player, _vol, _pitch, 20];
            
            // Frequency of rattle increases with speed
            sleep (0.8 / (_speed max 1));
        } else {
            sleep 1;
        };
    };
};

true
