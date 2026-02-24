/**
 * UKSFTA Main - CBA Settings Registration
 * Centralized control for all Sovereign Realism Engine modules.
 */

#include "script_component.hpp"

// --- 1. GLOBAL TOGGLE ---
[
    "uksfta_realism_enabled",
    "CHECKBOX",
    ["Enable Sovereign Realism", "Global master switch for all UKSFTA realism features."],
    "UKSFTA Sovereign",
    true,
    1,
    { if !(_this) then { diag_log "[UKSFTA] Realism Engine Suspended via CBA Settings."; }; }
] call CBA_fnc_addSetting;

// --- 2. ENVIRONMENT SETTINGS ---
[
    "uksfta_environment_enableAccumulation",
    "CHECKBOX",
    ["Enable Visual Accumulation", "Enable procedural wetness, mud, snow, and blood layering."],
    "UKSFTA Environment",
    true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_accumulationRate",
    "SLIDER",
    ["Accumulation Rate", "Speed of visual build-up (Wetness/Mud/etc)."],
    "UKSFTA Environment",
    [0.1, 5, 1, 1]
] call CBA_fnc_addSetting;

[
    "uksfta_environment_enableTides",
    "CHECKBOX",
    ["Enable Tidal Engine", "Simulate lunar-driven water level shifts on coastal maps."],
    "UKSFTA Environment",
    true
] call CBA_fnc_addSetting;

// --- 3. AUDIO & PHYSICALITY ---
[
    "uksfta_audio_enableReverb",
    "CHECKBOX",
    ["Enable Dynamic Reverb", "Procedural reverb profiles based on terrain density."],
    "UKSFTA Audio",
    true
] call CBA_fnc_addSetting;

[
    "uksfta_audio_enableDucking",
    "CHECKBOX",
    ["Enable Ambient Ducking", "Muffle outside environment sounds when indoors or in vehicles."],
    "UKSFTA Audio",
    true
] call CBA_fnc_addSetting;

[
    "uksfta_audio_enableSonicCracks",
    "CHECKBOX",
    ["Enable Sonic Cracks", "High-fidelity snaps and whizzes for supersonic rounds."],
    "UKSFTA Audio",
    true
] call CBA_fnc_addSetting;

[
    "uksfta_impact_enableRagdoll",
    "CHECKBOX",
    ["Enable Kinetic Ragdoll", "Knockdown units based on projectile kinetic energy."],
    "UKSFTA Impact",
    true
] call CBA_fnc_addSetting;

[
    "uksfta_impact_enableGore",
    "CHECKBOX",
    ["Enable High-Fid Gore", "Spawning of skull chunks and meat gibs on heavy impact."],
    "UKSFTA Impact",
    true
] call CBA_fnc_addSetting;

// --- 4. LOGGING ---
[
    "uksfta_main_logLevel",
    "LIST",
    ["Diagnostic Log Level", "Control the verbosity of UKSFTA realism logs."],
    "UKSFTA Core",
    [[0, 1, 2], ["Errors Only", "Standard", "Verbose Debug"], 1]
] call CBA_fnc_addSetting;

diag_log "[UKSFTA] <INFO> CBA Settings Registered.";
