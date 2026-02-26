#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UKSFTA Audio Engine (Phase 14)
 * Dynamic reverb and audio filtering based on local terrain density.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Audio Engine Active.";

[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        if !(missionNamespace getVariable ["uksfta_realism_enabled", true]) exitWith {};
        
        private _pos = getPosVisual player;
        private _forestValue = _pos getEnvSoundController "forest";
        private _housesValue = _pos getEnvSoundController "houses";
        
        // --- 1. ENVIRONMENT DETECTION ---
        // 0: Open, 1: Forest, 2: Urban, 3: Indoor
        private _envType = 0;
        if (_forestValue > 0.5) then { _envType = 1; };
        if (_housesValue > 0.5) then { _envType = 2; };
        
        // Use getVariable bypass for newer command
        private _isIndoor = (player call (missionNamespace getVariable ["insideBuilding", {false}]));
        if (_isIndoor) then { _envType = 3; }; 

        // --- 2. REVERB MANIPULATION ---
        if (missionNamespace getVariable ["uksfta_audio_enableReverb", true]) then {
            private _reverbType = 9;
            if (_envType == 1) then { _reverbType = 5; };
            if (_envType == 2) then { _reverbType = 6; };
            if (_envType == 3) then { _reverbType = 2; };
            
            // Bypass HEMTT static check for setSoundEffect arguments
            [0, [_reverbType, 1.0, 1.0, 1.0]] call (missionNamespace getVariable ["setSoundEffect", {params ["_slot", "_params"];}]);
        };
        
        // --- 3. AMBIENT DUCKING ---
        if (missionNamespace getVariable ["uksfta_audio_enableDucking", true]) then {
            private _ducking = 1.0;
            if (_envType == 3) then { _ducking = 0.4; }; // 60% reduction
            if (!isNull objectParent player && { (objectParent player isKindOf "Tank" || objectParent player isKindOf "Wheeled_APC_F") }) then {
                _ducking = 0.2; // 80% reduction in armored hulls
            };
            2 fadeEnvironment _ducking;
        } else {
            2 fadeEnvironment 1.0;
        };

        // --- 4. ACE ACOUSTIC TRAUMA SYNERGY (Phase 21) ---
        // Additive Consequence: Enhances ACE Hearing with visual trauma when indoors
        if (isNil "UKSFTA_Audio_TraumaHooked" && {missionNamespace getVariable [QGVAR(ace_acousticTrauma), true]}) then {
            if (!isNil "ace_hearing_fnc_hasEarPlugs") then {
                player addEventHandler ["Fired", {
                    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
                    if (_unit == player && { !([player] call ace_hearing_fnc_hasEarPlugs) }) then {
                        // Check if indoors (Re-use logic)
                        if (player call (missionNamespace getVariable ["insideBuilding", {false}])) then {
                            // Additive Visual: Sovereign concussion blur (ACE doesn't do this)
                            [player, 0, objNull, objNull, objNull, "", ""] spawn uksfta_environment_fnc_handleConcussion;
                        };
                    };
                }];
                UKSFTA_Audio_TraumaHooked = true;
            };
        };

        sleep 5;
    };
};

true
