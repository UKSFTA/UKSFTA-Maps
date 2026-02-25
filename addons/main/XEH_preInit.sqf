#include "script_component.hpp"
/**
 * UKSFTA Core - CBA Settings Framework (Standardized)
 */

private _catCore = "UKSFTA: Framework Core";
private _catAudio = "UKSFTA: Acoustic Immersion";
private _catEnv = "UKSFTA: Environment & FX";
private _catPhys = "UKSFTA: Physicality & Driving";

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

LOG("CBA Settings Framework Initialized.");
