#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Physicality Engine (Phase 17)
 * Stress-driven aiming, weight-based inertia, and movement scaling.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Physicality Engine Active.";

[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        if !(missionNamespace getVariable ["uksfta_main_enabled", true] && {missionNamespace getVariable ["uksfta_phys_enablePhysicality", true]}) exitWith {};
        
        private _stress = player getVariable ["UKSFTA_Stress_Level", 0];
        private _fatigue = getFatigue player;
        private _load = load player; // 0 to 1 range (approx)
        
        // --- 1. STRESS-DRIVEN AIMING ---
        // Increase sway based on stress and fatigue
        // Aiming Coef: 1.0 (Static) -> up to 4.0 (Extreme)
        private _aimCoef = 1.0 + (_stress * 2.0) + (_fatigue * 1.0);
        player setCustomAimCoef _aimCoef;
        
        // Increase Recoil based on stress (trembling hands)
        private _recoilCoef = 1.0 + (_stress * 0.5);
        player setUnitRecoilCoefficient _recoilCoef;

        // --- 2. WEIGHT-BASED INERTIA ---
        // Max speed scaling (Scout vs Juggernaut)
        // Anim Speed Coef: 1.0 (Light) -> 0.85 (Heavy)
        private _speedCoef = 1.0 - (_load * 0.15);
        player setAnimSpeedCoef _speedCoef;
        
        // Physical Weight / Acceleration Inertia
        // Higher weight = slower acceleration/deceleration
        player setUnitTrait ["loadCoef", (1.0 + _load)];

        // --- 3. SENSOR REALISM (NVG Gating) ---
        if (currentVisionMode player == 1) then { // NVG Active
            // Check for bright light sources in view
            private _nearFlares = player nearObjects ["FlareCore", 50];
            private _nearFires = nearestObjects [player, ["House", "Thing"], 10] select { (_x call (missionNamespace getVariable ["getFireIntensity", {0}])) > 0.5 };
            
            if (_nearFlares isNotEqualTo [] || _nearFires isNotEqualTo []) then {
                // Trigger auto-gating (temporary white-out)
                private _ppGating = ppEffectCreate ["ColorCorrections", 3005];
                _ppGating ppEffectEnable true;
                _ppGating ppEffectAdjust [1, 1, 0, [1, 1, 1, 0], [1, 1, 1, 1], [0, 0, 0, 0]];
                _ppGating ppEffectCommit 0.1;
                
                uiSleep 0.2;
                _ppGating ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 0], [0, 0, 0, 0]];
                _ppGating ppEffectCommit 1.5;
                
                [_ppGating] spawn { sleep 2; ppEffectDestroy (_this select 0); };
            };
        };

        sleep 2;
    };
};

true
