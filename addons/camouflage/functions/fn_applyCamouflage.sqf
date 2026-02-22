#include "..\script_component.hpp"
/**
 * UKSFTA Camouflage - Ghost Ops Implementation
 * High-fidelity stealth engine with Lambs/VCOM automated balancing.
 */

if (!hasInterface) exitWith {};

waitUntil { !isNil "uksfta_camouflage_enabled" };

while {uksfta_camouflage_enabled} do {
    private _unit = player;
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    private _intensity = uksfta_camouflage_intensity;
    
    private _camCoef = 1.0;
    private _audCoef = 1.0;

    // --- BIOME CALIBRATION ---
    private _uniform = toLower (uniform _unit);
    private _surface = toLower (surfaceType (getPos _unit));

    switch (_biome) do {
        case "ARID": {
            // Arid kits in desert (Linter compliant find)
            if ((_uniform find "arid" != -1) || (_uniform find "mc" != -1) || (_uniform find "desert" != -1)) then {
                _camCoef = 0.7; 
            };
            // Surface noise amplification
            if ((_surface find "stony" != -1) || (_surface find "gravel" != -1) || (_surface find "rock" != -1)) then {
                _audCoef = 1.2;
            };
        };
        case "ARCTIC": {
            if ((_uniform find "snow" != -1) || (_uniform find "winter" != -1) || (_uniform find "white" != -1)) then {
                _camCoef = 0.6;
            };
            // Snow dampening
            _audCoef = 0.7;
        };
        case "TROPICAL": {
            if ((_uniform find "jungle" != -1) || (_uniform find "tropic" != -1)) then {
                _camCoef = 0.75;
            };
            // Humidity amplification
            _audCoef = 1.1;
        };
    };

    // --- STANCE & GRASS OPTIMIZATION ---
    if (uksfta_camouflage_grassFix && {stance _unit == "PRONE"}) then {
        if (_surface find "gras" != -1) then {
            _camCoef = _camCoef * 0.8; // Prone in grass bonus
        };
    };

    // --- APPLY COEFFICIENTS ---
    private _finalCam = (_camCoef / _intensity) max 0.1;
    private _finalAud = (_audCoef * _intensity) min 2.0;

    _unit setUnitTrait ["camouflageCoef", _finalCam];
    _unit setUnitTrait ["audibleCoef", _finalAud];

    // --- AI SYSTEM BALANCING ---
    if (uksfta_camouflage_aiCompat) then {
        // Lambs/VCOM Balance
        if (!isNil "lambs_danger_fnc_combatMode") then {
            _unit setVariable ["lambs_danger_camouflageModifier", _finalCam, true];
        };
    };

    sleep 10;
};

// --- CLEANUP ---
player setUnitTrait ["camouflageCoef", 1.0];
player setUnitTrait ["audibleCoef", 1.0];
true
