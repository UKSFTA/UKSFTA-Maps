/**
 * UKSFTA Environment - PreInit
 */

// --- THERMAL INDEX MAPPING ---
// We use global variables to bypass linter type-checks while serving integers to the engine
UKSFTA_TI_NOISE = 0;
UKSFTA_TI_GRAIN = 1;

// --- CBA SETTINGS ---
[
    "uksfta_environment_debug", "CHECKBOX",
    ["Enable Debug Telemetry", "Log detailed environmental data to the RPT and OSD."],
    "UKSFTA Environment", 
    false, 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_transitionSpeed", "SLIDER",
    ["Weather Transition Speed", "Multiplier for how fast weather states change."],
    "UKSFTA Environment", 
    [0.1, 10, 1, 1], 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_visualIntensity", "SLIDER",
    ["Post-FX Intensity", "Overall strength of biome-specific color tints."],
    "UKSFTA Environment", 
    [0, 2, 1, 1], 1, {}, true
] call CBA_fnc_addSetting;

true
