#include "..\script_component.hpp"
/**
 * UKSFTA Audio - PreInit Settings
 */

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: Initializing Pre-Init Settings...";

// --- LOGGING LEVEL ---
[
    "uksfta_audio_logLevel", "LIST",
    ["Logging Level", "Adjust the verbosity of technical diagnostics in the RPT log."],
    "UKSFTA Audio",
    [
        [0, 1, 2],
        ["Errors Only", "Information", "Trace (Full Telemetry)"],
        1
    ], 1, {}, true
] call CBA_fnc_addSetting;

// --- MASTER ENABLE ---
[
    "uksfta_audio_enabled", "CHECKBOX",
    ["Enable Audio Framework", "Master toggle for the uksfta audio engine."],
    "UKSFTA Audio",
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- SONIC CRACKS ---
[
    "uksfta_audio_enableSonicCracks", "CHECKBOX",
    ["Enable Sonic Cracks", "High-fidelity supersonic crack simulation."],
    "UKSFTA Audio",
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- WEAPON TAILS ---
[
    "uksfta_audio_enableWeaponTails", "CHECKBOX",
    ["Enable Weapon Tails", "Dynamic weapon resonance based on environment."],
    "UKSFTA Audio",
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- FOLEY ---
[
    "uksfta_audio_enableFoley", "CHECKBOX",
    ["Enable Foley Effects", "Realistic movement and interaction sounds."],
    "UKSFTA Audio",
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- ARTILLERY WHISTLE ---
[
    "uksfta_audio_enableArtilleryWhistle", "CHECKBOX",
    ["Enable Artillery Whistle", "Incoming projectile audio cues."],
    "UKSFTA Audio",
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- AMBIENT SOUNDSCAPES ---
[
    "uksfta_audio_enableAmbientSoundscapes", "CHECKBOX",
    ["Enable Ambient Soundscapes", "Biome-specific background audio."],
    "UKSFTA Audio",
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- PHYSIOLOGY ---
[
    "uksfta_audio_enablePhysiology", "CHECKBOX",
    ["Enable Physiological Audio", "Breathing, gasping, and injury sounds."],
    "UKSFTA Audio",
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- DOPPLER ---
[
    "uksfta_audio_enableDoppler", "CHECKBOX",
    ["Enable Doppler Effects", "Dynamic pitch shifting for moving sources."],
    "UKSFTA Audio",
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- FOOTSTEPS ---
[
    "uksfta_audio_enableFootsteps", "CHECKBOX",
    ["Enable Enhanced Footsteps", "Surface-aware footstep audio."],
    "UKSFTA Audio",
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- OBSTRUCTION ---
[
    "uksfta_audio_enableObstruction", "CHECKBOX",
    ["Enable Acoustic Obstruction", "Sound muffling based on line-of-sight."],
    "UKSFTA Audio",
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- WORLD ALARMS ---
[
    "uksfta_audio_enableWorldAlarms", "CHECKBOX",
    ["Enable World Alarms", "Procedural building and car alarms."],
    "UKSFTA Audio",
    true, 1, {}, true
] call CBA_fnc_addSetting;

// --- BULLET IMPACTS ---
[
    "uksfta_audio_enableBulletImpacts", "CHECKBOX",
    ["Enable Bullet Impacts", "Custom impact sounds for bullets."],
    "UKSFTA Audio",
    true, 1, {}, true
] call CBA_fnc_addSetting;

true

