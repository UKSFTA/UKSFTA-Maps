#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Dynamic Caustics Engine
 * Procedurally generated underwater light refraction.
 */

if (!hasInterface) exitWith {};

private _ppCaustics = ppEffectCreate ["ChromAberration", 1505];
private _ppColor = ppEffectCreate ["ColorCorrections", 1506];

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Caustics Engine Initiated.";

while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    private _isUnderwater = (getPosASL player select 2) < -1.5 && {surfaceIsWater (getPosASL player)};
    
    if (_isUnderwater) then {
        private _sunAlt = call uksfta_environment_fnc_getSunElevation;
        private _intensity = linearConversion [-5, 90, _sunAlt, 0, 1, true];
        private _time = time;
        
        // Dynamic Aberration (Simulate Refraction)
        // Oscillate with sine waves based on time to mimic water movement
        private _abX = (sin (_time * 2)) * 0.005 * _intensity;
        private _abY = (cos (_time * 1.5)) * 0.005 * _intensity;
        
        _ppCaustics ppEffectEnable true;
        _ppCaustics ppEffectAdjust [_abX, _abY, true];
        _ppCaustics ppEffectCommit 0.1;
        
        // Underwater Tint (Green/Blue Shift)
        // Depth-based darkening? For now just uniform tint based on sun.
        _ppColor ppEffectEnable true;
        _ppColor ppEffectAdjust [
            1.0, 
            1.0, 
            0.0, 
            [0.1, 0.4, 0.6, 0.05 * _intensity], 
            [0.2, 0.5, 0.7, 0.5], 
            [0.299, 0.587, 0.114, 0]
        ];
        _ppColor ppEffectCommit 1;
        
    } else {
        _ppCaustics ppEffectEnable false;
        _ppColor ppEffectEnable false;
    };
    
    sleep 0.1;
};

ppEffectDestroy _ppCaustics;
ppEffectDestroy _ppColor;
true
