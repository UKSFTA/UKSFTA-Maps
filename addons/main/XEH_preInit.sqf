#include "script_component.hpp"
/**
 * UKSFTA Core - CBA Settings Framework (Production)
 */

private _catCore = "UKSFTA: Framework Core";
private _catAudio = "UKSFTA: Acoustic Immersion";
private _catEnv = "UKSFTA: Environment & FX";
private _catPhys = "UKSFTA: Physicality & Driving";
private _catAI = "UKSFTA: AI & Sensors";
private _catACE = "UKSFTA: Kinetic Synergy (ACE)";

// --- 1. CORE SYSTEM ---
[
    QGVAR(enabled), "CHECKBOX",
    ["Enable Realism Framework", "Master toggle for all UKSFTA realism and immersion modules."],
    _catCore, true, 1,
    { if !(_this) then { LOG("Realism Framework Suspended."); }; }
] call CBA_fnc_addSetting;

[
    QGVAR(logLevel), "LIST",
    ["Diagnostic Verbosity", "Controls the detail of UKSFTA telemetry in the RPT log."],
    _catCore, [[0, 1, 2], ["Minimal (Errors)", "Standard", "Verbose Debug"], 1]
] call CBA_fnc_addSetting;

// --- 2. ACOUSTIC IMMERSION ---
[
    QGVAR(audioEnabled), "CHECKBOX",
    ["Enable Advanced Audio", "Global toggle for advanced audio engines (Reverb, Ducking, Cracks)."],
    _catAudio, true
] call CBA_fnc_addSetting;

[
    QGVAR(audioObstruction), "CHECKBOX",
    ["Acoustic Obstruction", "Dynamically muffles sounds when the source is behind walls or objects."],
    _catAudio, true
] call CBA_fnc_addSetting;

// --- 3. ENVIRONMENT & FX ---
[
    QGVAR(envAccumulation), "CHECKBOX",
    ["Visual Accumulation", "Procedural layering of wetness, mud, snow, and blood on personnel."],
    _catEnv, true
] call CBA_fnc_addSetting;

[
    QGVAR(envNaturalism), "CHECKBOX",
    ["Meteorological Suite", "Enables physics-driven ISA weather and Kelvin atmospheric scattering."],
    _catEnv, true
] call CBA_fnc_addSetting;

// --- 4. PHYSICALITY & DRIVING ---
[
    QGVAR(physPhysicality), "CHECKBOX",
    ["Biometric Physicality", "Links weapon sway and movement inertia to stress, fatigue, and load."],
    _catPhys, true
] call CBA_fnc_addSetting;

[
    QGVAR(physDriving), "CHECKBOX",
    ["Advanced Driving Dynamics", "Procedural off-road bumps, wheel fatigue, and bogging risk."],
    _catPhys, true
] call CBA_fnc_addSetting;

// --- 5. AI & SENSORS ---
[
    "uksfta_ai_enableReactivity", "CHECKBOX",
    ["AI Predatory Reactivity", "Force AI (LAMBS/VCOM) to investigate triggered alarms and near-miss flybys."],
    _catAI, true
] call CBA_fnc_addSetting;

[
    "uksfta_sensor_enableNoise", "CHECKBOX",
    ["Meteorological Sensor Noise", "Adds grain and bloom to Thermal/NVG based on humidity and temperature."],
    _catAI, true
] call CBA_fnc_addSetting;

[
    "uksfta_sensor_enableDirtyLens", "CHECKBOX",
    ["Dirty Lens Hook (ACE)", "Link uniform accumulation (Mud/Ash) to ACE Goggles dirt/condensation."],
    _catAI, true
] call CBA_fnc_addSetting;

// --- 6. KINETIC SYNERGY (ACE HOOKS) ---
[
    QGVAR(ace_heatHaze), "CHECKBOX",
    ["Enhanced Weapon Mirage", "Link ACE overheating temperature to visual barrel heat haze/mirage."],
    _catACE, true
] call CBA_fnc_addSetting;

[
    QGVAR(ace_acousticTrauma), "CHECKBOX",
    ["Indoor Acoustic Trauma", "Severe blurring/muffling when firing heavy weapons indoors without protection."],
    _catACE, true
] call CBA_fnc_addSetting;

[
    QGVAR(ace_shockwave), "CHECKBOX",
    ["Explosive Shockwaves", "Environment-aware shockwaves that shatter nearby glass from ACE explosions."],
    _catACE, true
] call CBA_fnc_addSetting;

LOG("CBA Settings Framework Initialized.");
