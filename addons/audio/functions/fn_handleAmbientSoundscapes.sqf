#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Biome Soundscape Engine (Phase 16)
 * Generates ambient background noise based on real-time biome detection.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: Biome Soundscape Engine Active.";

[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
        private _isNight = sunOrMoon < 0.5;
        
        private _sound = "";
        private _vol = 0.5;

        switch (_biome) do {
            case "ARCTIC": {
                _sound = "A3\Sounds_F\environment\ambient\winds\wind_hard_1.wss";
                _vol = 0.8;
            };
            case "TROPICAL": {
                _sound = if (_isNight) then { "A3\Sounds_F\environment\ambient
ight
ight_cicadas_1.wss" } else { "A3\Sounds_F\environment\ambient\forest\forest_birds_1.wss" };
                _vol = 0.6;
            };
            case "ARID": {
                _sound = "A3\Sounds_F\environment\ambient\winds\wind_desert_1.wss";
                _vol = 0.4;
            };
            default { // TEMPERATE
                _sound = if (_isNight) then { "A3\Sounds_F\environment\ambient
ight
ight_crickets_1.wss" } else { "A3\Sounds_F\environment\ambient\forest\forest_wind_1.wss" };
                _vol = 0.5;
            };
        };

        if (_sound != "") then {
            // Ambient sounds are played non-positional for global immersion
            playSoundUI [_sound, _vol, 1];
        };

        sleep (30 + random 30); // Loop duration
    };
};

true
