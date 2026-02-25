#include "script_component.hpp"
/**
 * UKSFTA Sovereign - CBA Settings Framework (Gold Master Edition)
 * Professional-grade configuration for Taskforce Alpha operations.
 */

private _catCore = "UKSFTA: Sovereign Core";
private _catAudio = "UKSFTA: Acoustic Immersion";
private _catEnv = "UKSFTA: Environment & FX";
private _catPhys = "UKSFTA: Physicality & Driving";

// --- 1. CORE SYSTEM ---
[
    "uksfta_main_enabled", "CHECKBOX",
    ["Enable Sovereign Engine", "Master toggle for all UKSFTA realism and immersion modules."],
    _catCore, true, 1,
    { if !(_this) then { diag_log "[UKSFTA] <INFO>: Realism Engine Suspended."; }; }
] call CBA_fnc_addSetting;

[
    "uksfta_main_logLevel", "LIST",
    ["Diagnostic Verbosity", "Controls the detail of UKSFTA telemetry in the RPT log."],
    _catCore, [[0, 1, 2], ["Minimal (Errors)", "Standard", "Verbose Debug"], 1]
] call CBA_fnc_addSetting;

// --- 2. ACOUSTIC IMMERSION ---
[
    "uksfta_audio_enableAudio", "CHECKBOX",
    ["Enable Sovereign Audio", "Global toggle for advanced audio engines (Reverb, Ducking, Cracks)."],
    _catAudio, true
] call CBA_fnc_addSetting;

[
    "uksfta_audio_enableObstruction", "CHECKBOX",
    ["Acoustic Obstruction", "Dynamically muffles sounds when the source is behind walls or objects."],
    _catAudio, true
] call CBA_fnc_addSetting;

[
    "uksfta_audio_enableDucking", "CHECKBOX",
    ["Dynamic Ambient Ducking", "Automatically reduces outside volume when inside buildings or armored hulls."],
    _catAudio, true
] call CBA_fnc_addSetting;

[
    "uksfta_audio_enableAlarms", "CHECKBOX",
    ["Reactive World Alarms", "Enables urban facility and vehicle security systems responding to combat."],
    _catAudio, true
] call CBA_fnc_addSetting;

// --- 3. ENVIRONMENT & FX ---
[
    "uksfta_environment_enableAccumulation", "CHECKBOX",
    ["Visual Accumulation", "Procedural layering of wetness, mud, snow, and blood on personnel."],
    _catEnv, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_accumulationRate", "SLIDER",
    ["Accumulation Velocity", "Scales the speed at which environment effects build up on units."],
    _catEnv, [0.1, 5, 1, 1]
] call CBA_fnc_addSetting;

[
    "uksfta_environment_enableNaturalism", "CHECKBOX",
    ["Master Naturalism Engine", "Enables solar-accurate Kelvin grading and atmospheric scattering."],
    _catEnv, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_enableTides", "CHECKBOX",
    ["Lunar Tidal Cycles", "Simulates real-time water level shifts driven by the lunar phase."],
    _catEnv, true
] call CBA_fnc_addSetting;

// --- 4. PHYSICALITY & DRIVING ---
[
    "uksfta_phys_enablePhysicality", "CHECKBOX",
    ["Biometric Physicality", "Links weapon sway and movement inertia to stress, fatigue, and load."],
    _catPhys, true
] call CBA_fnc_addSetting;

[
    "uksfta_phys_enableDriving", "CHECKBOX",
    ["Advanced Driving Dynamics", "Procedural off-road bumps, wheel fatigue, and bogging risk."],
    _catPhys, true
] call CBA_fnc_addSetting;

[
    "uksfta_phys_enableGore", "CHECKBOX",
    ["Kinetic Gore & Ragdoll", "High-fidelity hit reactions and physical physiological feedback."],
    _catPhys, true
] call CBA_fnc_addSetting;

// --- 5. SENSOR & AI INTEGRATION (Phase 20) ---
[
    "uksfta_ai_enableReactivity", "CHECKBOX",
    ["AI Predatory Reactivity", "Force AI (LAMBS/VCOM) to investigate triggered alarms and near-miss flybys."],
    "UKSFTA: AI & Sensors", true
] call CBA_fnc_addSetting;

[
    "uksfta_sensor_enableNoise", "CHECKBOX",
    ["Meteorological Sensor Noise", "Adds grain and bloom to Thermal/NVG based on humidity and temperature."],
    "UKSFTA: AI & Sensors", true
] call CBA_fnc_addSetting;

[
    "uksfta_sensor_enableDirtyLens", "CHECKBOX",
    ["Dirty Lens Hook (ACE)", "Link uniform accumulation (Mud/Ash) to ACE Goggles dirt/condensation."],
    "UKSFTA: AI & Sensors", true
] call CBA_fnc_addSetting;

diag_log "[UKSFTA] <INFO>: CBA Settings Overhaul Complete.";
