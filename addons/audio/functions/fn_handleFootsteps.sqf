#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Surface-Aware Footstep Engine (Phase 16)
 * Enhances movement audio for Snow, Mud, and Sand based on Biome detection.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: Footstep Engine Active.";

[] spawn {
    private _lastPos = getPos player;
    
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _speed = vectorMagnitude (velocity player);
        private _dist = player distance _lastPos;
        
        // Only process if moving on foot
        if (_speed > 1.5 && {isNull objectParent player}) then {
            private _surface = toLower (surfaceType (getPos player));
            private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
            
            private _sound = "";
            private _vol = 0.3 + (load player * 0.2);

            switch (true) do {
                case (_surface find "snow" != -1 || _biome == "ARCTIC"): {
                    _sound = selectRandom [
                        "A3\Sounds_F\characters\footsteps\snow\snow_run_01.wss",
                        "A3\Sounds_F\characters\footsteps\snow\snow_run_02.wss",
                        "A3\Sounds_F\characters\footsteps\snow\snow_run_03.wss"
                    ];
                };
                case (_surface find "mud" != -1 || _surface find "marsh" != -1): {
                    _sound = selectRandom [
                        "A3\Sounds_F\characters\footsteps\mud\mud_run_01.wss",
                        "A3\Sounds_F\characters\footsteps\mud\mud_run_02.wss"
                    ];
                    _vol = _vol * 1.2;
                };
                case (_surface find "sand" != -1 || _biome == "ARID"): {
                    _sound = selectRandom [
                        "A3\Sounds_F\characters\footsteps\sand\sand_run_01.wss",
                        "A3\Sounds_F\characters\footsteps\sand\sand_run_02.wss"
                    ];
                };
            };

            if (_sound != "") then {
                playSound3D [_sound, player, false, getPosASL player, _vol, 0.9 + random 0.2, 15];
            };

            _lastPos = getPos player;
            // Interval based on speed
            sleep (0.5 / (_speed / 3));
        } else {
            sleep 0.5;
        };
    };
};

true
