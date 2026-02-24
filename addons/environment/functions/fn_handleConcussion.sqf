#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Concussion Engine (Phase 9)
 * High-fidelity shellshock and explosion impact visuals.
 * Inspiration: CG7 Suppression Overhaul
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Concussion Engine Active.";

// Initialize Post-Processing Handles
UKSFTA_Concussion_Blur = ppEffectCreate ["DynamicBlur", 500];
UKSFTA_Concussion_Blur ppEffectEnable true;
UKSFTA_Concussion_Blur ppEffectAdjust [0];
UKSFTA_Concussion_Blur ppEffectCommit 0;

UKSFTA_Concussion_Rad = ppEffectCreate ["RadialBlur", 501];
UKSFTA_Concussion_Rad ppEffectEnable true;
UKSFTA_Concussion_Rad ppEffectAdjust [0, 0, 0, 0];
UKSFTA_Concussion_Rad ppEffectCommit 0;

UKSFTA_Concussion_Chrom = ppEffectCreate ["ChromAberration", 502];
UKSFTA_Concussion_Chrom ppEffectEnable true;
UKSFTA_Concussion_Chrom ppEffectAdjust [0, 0, true];
UKSFTA_Concussion_Chrom ppEffectCommit 0;

UKSFTA_Concussion_Current = 0;
UKSFTA_Concussion_Thread = scriptNull;

// Event Handler for local explosions
player addEventHandler ["Explosion", {
    params ["_unit", "_damage"];
    
    if !(missionNamespace getVariable ["uksfta_environment_enableConcussion", true]) exitWith {};
    
    private _intensity = (_damage * 5) min 4;
    if (_intensity < 0.2) exitWith {};

    // Update global intensity (additive shellshock)
    UKSFTA_Concussion_Current = (UKSFTA_Concussion_Current + _intensity) min 5;

    if (!isNull UKSFTA_Concussion_Thread) then { terminate UKSFTA_Concussion_Thread; };

    UKSFTA_Concussion_Thread = [] spawn {
        private _duration = 5 + (UKSFTA_Concussion_Current * 8);
        
        // 1. IMPACT (Instant)
        UKSFTA_Concussion_Blur ppEffectAdjust [UKSFTA_Concussion_Current];
        UKSFTA_Concussion_Blur ppEffectCommit 0.1;
        
        private _radVal = (UKSFTA_Concussion_Current * 0.1) min 0.2;
        UKSFTA_Concussion_Rad ppEffectAdjust [_radVal, _radVal, 0.1, 0.1];
        UKSFTA_Concussion_Rad ppEffectCommit 0.1;
        
        UKSFTA_Concussion_Chrom ppEffectAdjust [UKSFTA_Concussion_Current * 0.05, UKSFTA_Concussion_Current * 0.05, true];
        UKSFTA_Concussion_Chrom ppEffectCommit 0.1;
        
        enableCamShake true;
        addCamShake [UKSFTA_Concussion_Current * 4, _duration * 0.5, 25];

        // 2. RECOVERY (Gradual)
        UKSFTA_Concussion_Blur ppEffectAdjust [0];
        UKSFTA_Concussion_Blur ppEffectCommit _duration;
        
        UKSFTA_Concussion_Rad ppEffectAdjust [0, 0, 0, 0];
        UKSFTA_Concussion_Rad ppEffectCommit _duration;
        
        UKSFTA_Concussion_Chrom ppEffectAdjust [0, 0, true];
        UKSFTA_Concussion_Chrom ppEffectCommit _duration;

        sleep _duration;
        UKSFTA_Concussion_Current = 0;
    };
}];

true
