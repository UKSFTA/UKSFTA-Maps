#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Advanced Visual Engine (Clarity Edition)
 * Optimized to suppress engine distance haze.
 */

if (!hasInterface) exitWith {};

waitUntil { !isNil "uksfta_environment_enabled" };
if !(missionNamespace getVariable ["uksfta_environment_enabled", false]) exitWith {};

private _ccHandle = 1501;
private _filmHandle = 1502;

_ccHandle ppEffectEnable true;
_ccHandle ppEffectForceInNVG true;
_filmHandle ppEffectEnable true;

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Haze-Suppression Grading Active.";

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    private _intensity = missionNamespace getVariable ["uksfta_environment_visualIntensity", 1.0];
    private _overcast = overcast;
    
    private _sunElevation = call uksfta_environment_fnc_getSunElevation;
    
    private _rgb = [1, 1, 1];
    private _sat = 1.0;
    private _contrast = 1.1; // Baseline contrast bump to fight haze
    private _brightness = 1.0;

    // 1. Solar State Logic
    if (_sunElevation > 5) then { // Day
        _rgb = [1.0, 1.0, 1.0];
        _sat = 1.0;
    } else {
        if (_sunElevation > -5) then { // Golden/Blue
            _rgb = [1.05, 0.95, 0.9];
            _sat = 1.05;
        } else { // Night
            private _moon = moonIntensity; // 0 to 1
            // Adjust based on moon intensity for grading (Phase 3: Lunar Grading)
            _rgb = [0.8 + (0.1 * _moon), 0.85 + (0.1 * _moon), 1.0 + (0.1 * _moon)];
            _sat = 0.6 + (0.2 * _moon);
            _brightness = 0.85 + (0.15 * _moon);
            _contrast = _contrast - (0.05 * (1 - _moon)); // Lower contrast on pitch black nights
        };
    };

    // 2. HAZE MITIGATION PASS
    // We increase mid-tone contrast specifically during high overcast to fight the "milky" look
    if (_overcast > 0.4) then {
        private _hazeFactor = linearConversion [0.4, 1.0, _overcast, 0, 1, true];
        _contrast = _contrast + (0.15 * _hazeFactor); // Aggressive contrast to keep distance clear
        _sat = _sat * (1 - (0.2 * _hazeFactor));
    };

    // 3. Biome Overlay
    switch (_biome) do {
        case "ARID": { _rgb = [(_rgb select 0) * 1.02, _rgb select 1, (_rgb select 2) * 0.98]; };
        case "ARCTIC": { _sat = _sat * 0.85; _contrast = _contrast + 0.1; };
    };

    // 3a. Sub-Biome Overlay (Phase 4: Enoch Scattering)
    private _subBiome = missionNamespace getVariable ["UKSFTA_Environment_SubBiome", ""];
    if (_subBiome == "WOODLAND") then {
        // Enoch-style: Cooler shadows, slight green tint, punchier contrast
        _rgb = [(_rgb select 0) * 0.95, (_rgb select 1) * 1.02, (_rgb select 2) * 0.98]; 
        _contrast = _contrast + 0.05;
        _sat = _sat * 0.95; // Slightly desaturated "gritty" look
    };

    // 4. Local Micro-Climate Offset (Snow/Altitude)
    private _localDesat = missionNamespace getVariable ["uksfta_environment_visualDesatLocal", 0];
    _sat = (_sat - _localDesat) max 0.1;

    // 5. Final Grading (Refined for Clarity)
    _ccHandle ppEffectAdjust [
        _brightness, 
        _contrast, 
        -0.02, 
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
