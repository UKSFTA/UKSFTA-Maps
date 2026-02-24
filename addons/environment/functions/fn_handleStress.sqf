#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Stress Engine (Phase 15)
 * Dynamic anxiety, panic, and suppression visualization.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Stress Engine Active.";

// --- PP EFFECTS ---
// Dedicated handles for anxiety visual stack
UKSFTA_Env_PP_Vignette = ppEffectCreate ["ColorCorrections", 3001];
UKSFTA_Env_PP_Chrom = ppEffectCreate ["ChromAberration", 3002];
UKSFTA_Env_PP_Blur = ppEffectCreate ["RadialBlur", 3003];

// Initialize with zero values (invisible)
UKSFTA_Env_PP_Vignette ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 0], [0.299, 0.587, 0.114, 0]];
UKSFTA_Env_PP_Vignette ppEffectCommit 0;
UKSFTA_Env_PP_Chrom ppEffectAdjust [0, 0, true];
UKSFTA_Env_PP_Chrom ppEffectCommit 0;
UKSFTA_Env_PP_Blur ppEffectAdjust [0, 0, 0.5, 0.5];
UKSFTA_Env_PP_Blur ppEffectCommit 0;

UKSFTA_Env_PP_Vignette ppEffectEnable true;
UKSFTA_Env_PP_Chrom ppEffectEnable true;
UKSFTA_Env_PP_Blur ppEffectEnable true;

[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        // 1. CALCULATE STRESS FACTORS
        private _suppression = getSuppression player;
        private _health = 1 - (damage player);
        private _fatigue = getFatigue player;
        private _nearbyEnemies = count (player nearTargets 50);
        
        // Base Stress Level (0.0 - 1.0)
        private _stress = 0;
        
        // Suppression is the primary driver (0.0-1.0)
        _stress = _stress + (_suppression * 0.6);
        
        // Low health induces panic
        if (_health < 0.5) then { _stress = _stress + ((0.5 - _health) * 0.5); };
        
        // Fatigue amplifies existing stress
        if (_stress > 0.2) then { _stress = _stress + (_fatigue * 0.2); };
        
        // Combat intensity (nearby enemies)
        _stress = _stress + (_nearbyEnemies * 0.05);
        
        _stress = _stress min 1.0;
        
        // 2. APPLY VISUAL EFFECTS
        if (_stress > 0.1) then {
            // Chromatic Aberration (Disorientation)
            private _chrom = _stress * 0.02; // Max 0.02
            UKSFTA_Env_PP_Chrom ppEffectAdjust [_chrom, _chrom, true];
            UKSFTA_Env_PP_Chrom ppEffectCommit 1;
            
            // Radial Blur (Tunnel Vision/Panic)
            private _blur = 0;
            if (_stress > 0.6) then { _blur = (_stress - 0.6) * 0.02; };
            UKSFTA_Env_PP_Blur ppEffectAdjust [_blur, _blur, 0.3, 0.3];
            UKSFTA_Env_PP_Blur ppEffectCommit 1;
            
            // Vignette (Darkening edges)
            private _vigAlpha = _stress * 0.5; // Max 0.5 opacity
            UKSFTA_Env_PP_Vignette ppEffectAdjust [
                1, 1, 0, 
                [0, 0, 0, 0], 
                [0, 0, 0, _vigAlpha],  // Darken edges
                [0.299, 0.587, 0.114, 0]
            ];
            UKSFTA_Env_PP_Vignette ppEffectCommit 1;
            
            // Camera Shake (Trembling)
            if (_stress > 0.8) then {
                enableCamShake true;
                addCamShake [_stress * 0.5, 2, 5 + (_stress * 10)];
            };
            
            // Audible Heartbeat (High Stress Only)
            if (_stress > 0.9) then {
                // Procedural heartbeat simulation via playSound UI
                // Note: Requires sound definition or generic thump
                // Using generic "heartbeat_1" style sounds if available or breathing
                if (diag_tickTime % 1 < 0.1) then {
                    // playSoundUI "Heartbeat_High"; // Placeholder
                };
            };
            
        } else {
            // Recovery
            UKSFTA_Env_PP_Chrom ppEffectAdjust [0, 0, true];
            UKSFTA_Env_PP_Chrom ppEffectCommit 2;
            UKSFTA_Env_PP_Blur ppEffectAdjust [0, 0, 0.5, 0.5];
            UKSFTA_Env_PP_Blur ppEffectCommit 2;
            UKSFTA_Env_PP_Vignette ppEffectAdjust [1, 1, 0, [0,0,0,0], [1,1,1,0], [0.299, 0.587, 0.114, 0]];
            UKSFTA_Env_PP_Vignette ppEffectCommit 2;
        };

        // Share stress level for other systems (e.g. sway, aim accuracy)
        player setVariable ["UKSFTA_Stress_Level", _stress, true];

        // --- ACE3 / KAT MEDICAL INTEGRATION ---
        if (_stress > 0.5) then {
            // Induce high heart rate in ACE3
            private _currentHR = player getVariable ["ace_medical_heartRate", 80];
            if (_currentHR < (80 + (_stress * 100))) then {
                player setVariable ["ace_medical_heartRate", (_currentHR + 5), true];
            };

            // Induce high breath rate (Respiratory Rate) for KAT/Physicality
            // Resting: 12-16. Stress: up to 40.
            private _respRate = 16 + (_stress * 24);
            player setVariable ["kat_medical_respiratoryRate", _respRate, true];
            missionNamespace setVariable ["UKSFTA_Environment_BreathRate", _respRate];
        } else {
            missionNamespace setVariable ["UKSFTA_Environment_BreathRate", 16];
        };

        sleep 1;
    };
};

true
