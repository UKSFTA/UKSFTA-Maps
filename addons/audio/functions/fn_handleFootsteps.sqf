#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Sovereign Footstep Engine (Gold Master)
 * Synchronized surface-aware movement audio with weight-based volume scaling.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: Footstep Engine Active (Event-Synchronized).";

// We use the AnimStep event for perfect synchronization with the animation
player addEventHandler ["AnimStep", {
    params ["_unit", "_anim", "_stepType", "_selectionName", "_isFootStep"];
    
    if (!_isFootStep) exitWith {};
    if !(missionNamespace getVariable ["uksfta_main_enabled", true]) exitWith {};

    private _speed = vectorMagnitude (velocity _unit);
    private _surface = toLower (surfaceType (getPosVisual _unit));
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    
    private _sound = "";
    private _vol = (0.2 + (load _unit * 0.3)) min 1.0;
    private _pitch = 0.95 + random 0.1;

    // --- SURFACE LOGIC ---
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
            _vol = _vol * 1.3;
        };
        case (_surface find "sand" != -1 || _biome == "ARID"): {
            _sound = selectRandom [
                "A3\Sounds_F\characters\footsteps\sand\sand_run_01.wss",
                "A3\Sounds_F\characters\footsteps\sand\sand_run_02.wss"
            ];
        };
        case (_surface find "grass" != -1 || _surface find "forest" != -1): {
            // Crunchy vegetation layer
            if (random 1 > 0.5) then {
                _sound = "A3\Sounds_F\characters\footsteps\grass\grass_run_01.wss";
                _pitch = 1.2; // Crunchy
            };
        };
    };

    if (_sound != "") then {
        // Play localized sound with short distance cutoff for performance
        playSound3D [_sound, _unit, false, getPosASL _unit, _vol, _pitch, 20];
    };
}];

true
