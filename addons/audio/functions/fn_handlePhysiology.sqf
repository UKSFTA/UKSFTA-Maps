#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Physiological Audio Engine (Phase 16)
 * Handles breathing, gasping, and drowning audio cues.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: Physiology Engine Active.";

UKSFTA_Audio_LastDiveState = false; // False: Dry, True: Underwater

[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _isUnderwater = (getPosASL player select 2) < -0.5;
        
        // 1. SURFACING GASP
        if (UKSFTA_Audio_LastDiveState && !_isUnderwater) then {
            // Player just surfaced
            playSoundUI ["uksfta_physiology_breath", 1.5, 0.8 + random 0.4];
        };
        UKSFTA_Audio_LastDiveState = _isUnderwater;

        // 2. DROWNING / OXYGEN STRESS
        if (_isUnderwater) then {
            private _oxy = getOxygenRemaining player;
            if (_oxy < 0.1 && {alive player}) then {
                // Play underwater death sound
                playSoundUI ["uksfta_physiology_Underwater_Death", 1.0, 1.0];
            };
            if (_oxy < 0.5) then {
                // Heartbeat/Panic thump
                playSoundUI ["A3\Sounds_F\weapons\Closure\soft_revolve_01.wss", 0.5, 0.5];
                addCamShake [1, 1, 5];
            };
        };

        // 3. ANXIETY HEARTBEAT (Sync with Stress Engine)
        private _stress = player getVariable ["UKSFTA_Stress_Level", 0];
        if (_stress > 0.9) then {
             playSoundUI ["A3\Sounds_F\weapons\Closure\soft_revolve_01.wss", 0.3, 0.6];
        };

        // 4. WOUND MOANING (Realistic Medical Integration)
        private _damage = damage player;
        private _unconscious = player getVariable ["ACE_isUnconscious", false];
        
        if (_damage > 0.6 || _unconscious) then {
            // Play randomized heavy breath/moan
            private _breathSounds = [
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_01.wss",
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_02.wss",
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_03.wss",
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_04.wss",
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_05.wss",
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_06.wss",
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_07.wss",
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_08.wss",
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_09.wss",
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_10.wss",
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_11.wss",
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_12.wss",
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_13.wss",
                "z\uksfta\addons\audio\sounds\character\breath\Soundbreathinjured_Max_14.wss"
            ];
            private _sound = selectRandom _breathSounds;
            playSoundUI [_sound, 0.8, 0.9 + random 0.2];
        };

        sleep 1.5;
    };
};

true
