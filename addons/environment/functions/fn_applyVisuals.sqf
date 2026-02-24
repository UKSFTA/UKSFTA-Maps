#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Master Naturalism Engine (Phase 10)
 * High-fidelity, real-time color grading without external shaders.
 */

if (!hasInterface) exitWith {};

waitUntil { !isNil "uksfta_environment_enabled" };
if !(missionNamespace getVariable ["uksfta_environment_enabled", false]) exitWith {};

private _ccHandle = ppEffectCreate ["ColorCorrections", 1501];
_ccHandle ppEffectEnable true;
_ccHandle ppEffectForceInNVG true;

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Master Naturalism Engine Active.";

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    private _intensity = missionNamespace getVariable ["uksfta_environment_visualIntensity", 1.0];
    private _overcast = overcast;
    private _sunElevation = call uksfta_environment_fnc_getSunElevation;
    
    // 1. BASELINE NATURALISM
    private _rgb = [1, 1, 1];
    private _sat = 1.0;
    private _contrast = 1.05; // Subtle pop
    private _brightness = 1.0;
    private _offset = [0, 0, 0, 0];

    // 2. KELVIN-ACCURATE SOLAR GRADING
    if (_sunElevation > 15) then { // Noon
        _rgb = [1.0, 1.0, 1.0];
        _sat = 1.0;
    } else {
        if (_sunElevation > 0) then { // Golden Hour
            private _factor = linearConversion [0, 15, _sunElevation, 0, 1, true];
            _rgb = [1.1 - (0.1 * _factor), 0.95 + (0.05 * _factor), 0.85 + (0.15 * _factor)];
            _sat = 1.1 - (0.1 * _factor);
            _contrast = 1.1 - (0.05 * _factor);
        } else { // Night & Twilight
            if (_sunElevation > -10) then { // Blue Hour
                _rgb = [0.8, 0.85, 1.1];
                _sat = 0.7;
                _brightness = 0.9;
            } else { // Full Night
                private _moon = moonIntensity;
                _rgb = [0.7 + (0.1 * _moon), 0.75 + (0.15 * _moon), 1.0 + (0.1 * _moon)];
                _sat = 0.5 + (0.2 * _moon);
                _brightness = 0.8 + (0.2 * _moon);
                _contrast = 0.95 + (0.1 * _moon);
            };
        };
    };

    // 3. HAZE MITIGATION & ATMOSPHERIC DENSITY
    if (_overcast > 0.5) then {
        private _haze = linearConversion [0.5, 1.0, _overcast, 0, 1, true];
        _contrast = _contrast + (0.1 * _haze);
        _sat = _sat * (1 - (0.15 * _haze));
        _rgb = _rgb vectorMultiply (1 - (0.05 * _haze));
    };

    // 4. BIOME SPECIFIC REFINEMENT
    switch (_biome) do {
        case "ARID": { 
            _rgb = [(_rgb select 0) * 1.02, (_rgb select 1), (_rgb select 2) * 0.95]; 
            _contrast = _contrast + 0.05;
        };
        case "ARCTIC": { 
            _sat = _sat * 0.85; 
            _rgb = [(_rgb select 0) * 0.95, (_rgb select 1) * 0.98, (_rgb select 2) * 1.05];
            _contrast = _contrast + 0.1;
        };
    };

    // 5. APPLY MASTER GRADING
    _ccHandle ppEffectAdjust [
        _brightness, 
        _contrast, 
        0, 
        _offset, 
        [(_rgb select 0) * _intensity, (_rgb select 1) * _intensity, (_rgb select 2) * _intensity, _sat], 
        [0.299, 0.587, 0.114, 0]
    ];
    _ccHandle ppEffectCommit 15;

    sleep 15;
};

_ccHandle ppEffectEnable false;
ppEffectDestroy _ccHandle;
true
