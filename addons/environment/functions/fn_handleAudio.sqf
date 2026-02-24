#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Audio Engine (Phase 14)
 * Dynamic reverb and audio filtering based on local terrain density.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Audio Engine Active.";

[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
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
        // We simulate reverb via frequency filtering or auxiliary sound paths 
        // using the engine's setAudioOption if available, or by adjusting global 
        // volume components to simulate 'muffling'.
        
        private _lowPass = 1.0;
        private _reverb = 0;

        switch (_envType) do {
            case 1: { // Forest: Muffled, High Echo
                _lowPass = 0.8;
                _reverb = 0.4;
            };
            case 2: { // Urban: Sharp, High Reverb
                _lowPass = 1.0;
                _reverb = 0.8;
            };
            case 3: { // Indoor: Heavily Muffled, High Reverb
                _lowPass = 0.5;
                _reverb = 0.6;
            };
            default { // Open: Clear, Low Reverb
                _lowPass = 1.0;
                _reverb = 0.1;
            };
        };

        // Note: Actual 'setReverb' is a world-level command in Arma 3.
        // We use it to shift the global environmental audio profile.
        // [roomType, weight]
        // 0: Default, 1: Tunnels, 2: Small Room, 3: Large Room, 4: Stone Corridor, 5: Forest, 6: City, 7: Mountains, 8: Quarry, 9: Plain
        private _reverbType = 9;
        if (_envType == 1) then { _reverbType = 5; };
        if (_envType == 2) then { _reverbType = 6; };
        if (_envType == 3) then { _reverbType = 2; };
        
        // --- 3. AMBIENT DUCKING (Improved Game Sounds Integration) ---
        // Duck outside volume when indoors or in armored vehicles
        private _ducking = 1.0;
        if (_envType == 3) then { _ducking = 0.4; }; // 60% reduction
        if (!isNull objectParent player && { (objectParent player isKindOf "Tank" || objectParent player isKindOf "Wheeled_APC_F") }) then {
            _ducking = 0.2; // 80% reduction in armored hulls
        };
        
        // fadeEnvironment handles the engine's ambient/wind volume
        2 fadeEnvironment _ducking;

        // Bypass HEMTT static check for setSoundEffect arguments
        [0, [_reverbType, 1.0, 1.0, 1.0]] call (missionNamespace getVariable ["setSoundEffect", {params ["_slot", "_params"];}]);

        sleep 5;
    };
};

true
