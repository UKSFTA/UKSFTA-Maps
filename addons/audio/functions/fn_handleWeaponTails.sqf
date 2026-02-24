#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Dynamic Tail Engine (Phase 16)
 * Generates realistic weapon resonance based on local environment.
 */

if (!hasInterface) exitWith {};
private _enabled = missionNamespace getVariable ["uksfta_audio_enableWeaponTails", true];
if (!_enabled) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: Dynamic Tail Engine Active.";

player addEventHandler ["FiredMan", {
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_mag", "_projectile", "_veh"];

    if (!isNull _veh) exitWith {}; // Vehicle weapons have their own internal tails

    private _envType = missionNamespace getVariable ["uksfta_environment_LocalBiome", "TEMPERATE"]; // Primary biome fallback
    private _isIndoor = player call (missionNamespace getVariable ["insideBuilding", {false}]);
    
    private _pos = getPosVisual _unit;
    private _forest = _pos getEnvSoundController "forest";
    private _houses = _pos getEnvSoundController "houses";

    private _tailSound = "";
    private _vol = 1.0;

    switch (true) do {
        case (_isIndoor): {
            _tailSound = "A3\Sounds_F\weapons\Closure\soft_revolve_01.wss"; // Placeholder for indoor sharp tail
            _vol = 0.8;
        };
        case (_houses > 0.5): {
            _tailSound = "A3\Sounds_F\weapons\Explosion\expl_shell_1.wss"; // Deep urban echo
            _vol = 0.5;
        };
        case (_forest > 0.5): {
            _tailSound = "A3\Sounds_F\weapons\Closure\soft_revolve_02.wss"; // Muffled forest thud
            _vol = 0.6;
        };
        default {
            _tailSound = ""; // Open field uses engine tails
        };
    };

    if (_tailSound != "") then {
        // Play with slight randomized delay for distance processing
        [_tailSound, _unit, _vol] spawn {
            params ["_snd", "_u", "_v"];
            sleep (0.05 + random 0.05);
            playSound3D [_snd, _u, false, getPosASL _u, _v, 0.8 + random 0.2, 100];
        };
    };
}];

true
