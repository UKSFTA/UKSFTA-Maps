#include "..\script_component.hpp"
/**
 * UKSFTA Environment - PreInit Settings
 */

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Initializing Pre-Init Settings...";

// --- LOGGING LEVEL ---
[
    "uksfta_environment_logLevel", "LIST",
    ["Logging Level", "Adjust the verbosity of technical diagnostics in the RPT log."],
    "UKSFTA Environment", 
    [
        [0, 1, 2],
        ["Errors Only", "Information", "Trace (Full Telemetry)"],
        1
    ], 1, {}, true
] call CBA_fnc_addSetting;

// --- OPERATIONAL MODE ---
[
    "uksfta_environment_preset", "LIST",
    ["Operational Mode", "ARCADE: Easier visibility. REALISM: Full Diamond Standard."],
    "UKSFTA Environment", 
    [
        ["ARCADE", "REALISM"],
        ["Arcade (Relaxed)", "Realism (Diamond Standard)"],
        1
    ], 1, {}, true
] call CBA_fnc_addSetting;

// --- MASTER ENABLE ---
[
    "uksfta_environment_enabled", "CHECKBOX",
    ["Enable Framework (Server)", "Master toggle for the universal dynamic environment engine."],
    "UKSFTA Environment", 
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- DIAGNOSTIC HUD ---
[
    "uksfta_environment_debugHUD", "CHECKBOX",
    ["Show Technical Telemetry (OSD)", "Displays real-time data for biomes, ballistics, and sensors."],
    "UKSFTA Environment", 
    false, 1, {}, true
] call CBA_fnc_addSetting;

// --- THERMAL REALISM ---
[
    "uksfta_environment_enableThermals", "CHECKBOX",
    ["Enable Thermal Realism", "Toggles atmospheric degradation of TI optics."],
    "UKSFTA Environment", 
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- SIGNAL INTERFERENCE ---
[
    "uksfta_environment_enableSignalInterference", "CHECKBOX",
    ["Enable Signal Interference", "Toggles atmospheric attenuation of radio signals (TFAR/ACRE)."],
    "UKSFTA Environment", 
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- INTENSITY SCALING ---
[
    "uksfta_environment_thermalIntensity", "SLIDER",
    ["Thermal Degradation Strength", "Overall strength of thermal sensor interference."],
    "UKSFTA Environment", 
    [0, 5, 1, 1], 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_interferenceIntensity", "SLIDER",
    ["Signal Interference Intensity", "Overall strength of radio signal attenuation."],
    "UKSFTA Environment", 
    [0, 5, 1, 1], 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_transitionSpeed", "SLIDER",
    ["Weather Transition Speed", "Multiplier for how fast weather states change."],
    "UKSFTA Environment", 
    [0.1, 10, 1, 1], 1, {}, true
] call CBA_fnc_addSetting;

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Pre-Init Settings Registered.";
true
