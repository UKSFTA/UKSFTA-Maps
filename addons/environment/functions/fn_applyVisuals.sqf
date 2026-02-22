#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Advanced Visual Engine
 * Uses verified engine handles to prevent post-FX crashes.
 */

if (!hasInterface) exitWith {};

// --- HANDLES ---
// We use high-range handles to avoid conflicts with ACE/KAT/Vanilla
private _ccHandle = 1500;
private _filmHandle = 1501;

// --- INITIALIZATION ---
_ccHandle ppEffectEnable true;
_ccHandle ppEffectForceInNVG true;

_filmHandle ppEffectEnable true;

while {uksfta_environment_enabled} do {
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    private _intensity = uksfta_environment_visualIntensity;
    
    // --- DYNAMIC TINT MATRIX ---
    private _tint = [1, 1, 1]; // Default
    private _sat = 1.0;
    private _contrast = 1.0;

    switch (_biome) do {
        case "ARID": {
            _tint = [1.05, 1.0, 0.9]; // Desert Warmth
            _sat = 0.95;
            _contrast = 1.05;
        };
        case "ARCTIC": {
            _tint = [0.9, 1.0, 1.1]; // Arctic Cool
            _sat = 0.8;
            _contrast = 1.1;
        };
        case "TROPICAL": {
            _tint = [0.95, 1.1, 0.95]; // Jungle Lush
            _sat = 1.2;
            _contrast = 1.0;
        };
        case "MEDITERRANEAN": {
            _tint = [1.0, 1.0, 0.95]; // Malden/Altis Clarity
            _sat = 1.05;
            _contrast = 1.0;
        };
    };

    // --- APPLY COLOR CORRECTION ---
    _ccHandle ppEffectAdjust [
        1.0, 
        _contrast, 
        0, 
        [0, 0, 0, 0], 
        [_tint select 0, _tint select 1, _tint select 2, _sat], 
        [0.299, 0.587, 0.114, 0],
        [-1, -1, 0, 0, 0, 0, 0]
    ];
    _ccHandle ppEffectCommit 5;

    // --- APPLY FILM GRAIN ---
    private _grain = [0.02, 1.25, 1.0, 0.75, 1.0, true] select (uksfta_environment_preset == "REALISM");
    if (uksfta_environment_preset == "ARCADE") then { _grain = 0; };
    
    _filmHandle ppEffectAdjust [_grain * _intensity, 1.25, 1.0, 0.75, 1.0, true];
    _filmHandle ppEffectCommit 5;

    sleep 30;
};

// --- CLEANUP ---
_ccHandle ppEffectEnable false;
_filmHandle ppEffectEnable false;
true
