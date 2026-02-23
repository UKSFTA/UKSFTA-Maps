#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Advanced Visual Engine (Dynamic Grading)
 * 100% Modular - Works on any terrain.
 */

if (!hasInterface) exitWith {};

waitUntil { !isNil "uksfta_environment_enabled" };
if !(missionNamespace getVariable ["uksfta_environment_enabled", false]) exitWith {};

// --- HANDLES ---
private _ccHandle = 1501;
private _filmHandle = 1502;

_ccHandle ppEffectEnable true;
_ccHandle ppEffectForceInNVG true;

_filmHandle ppEffectEnable true;

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Dynamic Color Grading Engine Active.";

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    private _intensity = missionNamespace getVariable ["uksfta_environment_visualIntensity", 1.0];
    private _overcast = overcast;
    
    // 1. Calculate Solar Influence
    private _sunElevation = call uksfta_environment_fnc_getSunElevation;
    
    // 2. Determine Base Grade (Sun Angle)
    private _rgb = [1, 1, 1];
    private _sat = 1.0;
    private _contrast = 1.0;
    private _brightness = 1.0;

    if (_sunElevation > 10) then { // Noon/Day
        _rgb = [1.0, 1.0, 1.0];
        _sat = 1.0;
        _contrast = 1.0;
    } else {
        if (_sunElevation > -5) then { // Golden Hour
            _rgb = [1.1, 0.95, 0.8]; 
            _sat = 1.1;
            _contrast = 1.05;
        } else { // Night
            _rgb = [0.8, 0.9, 1.1]; 
            _sat = 0.7;
            _contrast = 0.95;
            _brightness = 0.9;
        };
    };

    // 3. Apply Weather Extinction (Storm Grading)
    if (_overcast > 0.6) then {
        private _weatherFactor = linearConversion [0.6, 1.0, _overcast, 0, 1, true];
        _sat = _sat * (1 - (0.4 * _weatherFactor)); 
        _contrast = _contrast * (1 + (0.1 * _weatherFactor)); 
        _rgb = [
            (_rgb select 0) * (1 - (0.1 * _weatherFactor)),
            (_rgb select 1) * (1 - (0.05 * _weatherFactor)),
            (_rgb select 2) * (1 + (0.05 * _weatherFactor))
        ]; 
    };

    // 4. Apply Biome Tint Overlay
    switch (_biome) do {
        case "ARID": { _rgb = [(_rgb select 0) * 1.05, _rgb select 1, (_rgb select 2) * 0.95]; };
        case "ARCTIC": { _rgb = [(_rgb select 0) * 0.9, _rgb select 1, (_rgb select 2) * 1.1]; _sat = _sat * 0.9; };
        case "TROPICAL": { _sat = _sat * 1.1; };
    };

    // 5. Final Adjustment
    _ccHandle ppEffectAdjust [
        _brightness, 
        _contrast, 
        0, 
        [0, 0, 0, 0], 
        [(_rgb select 0) * _intensity, (_rgb select 1) * _intensity, (_rgb select 2) * _intensity, _sat], 
        [0.299, 0.587, 0.114, 0],
        [-1, -1, 0, 0, 0, 0, 0]
    ];
    _ccHandle ppEffectCommit 10;

    sleep 10;
};

_ccHandle ppEffectEnable false;
_filmHandle ppEffectEnable false;
true
