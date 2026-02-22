/**
 * UKSFTA Environment - PreInit Settings
 */

// --- GLOBAL MASTER ---
[
    "uksfta_environment_enabled", "CHECKBOX",
    ["Enable Framework (Server)", "Master toggle for the universal environment system."],
    "UKSFTA Environment", true, 1, {}, true
] call CBA_fnc_addSetting;

// --- DIAGNOSTICS & DEBUG ---
[
    "uksfta_environment_debug", "CHECKBOX",
    ["Enable Engine Debug", "Log technical telemetry (Biomes, Ballistics, Comms) to RPT."],
    "UKSFTA Environment", false, 0, {}, false
] call CBA_fnc_addSetting;

[
    "uksfta_environment_debugHUD", "CHECKBOX",
    ["Enable Visual Debug HUD", "Show real-time camouflage and environmental data on screen."],
    "UKSFTA Environment", false, 0, {}, false
] call CBA_fnc_addSetting;

// --- AVIATION & EW ---
[
    "uksfta_environment_enableTurbulence", "CHECKBOX",
    ["Enable Aviation Turbulence", "Apply physical forces to aircraft during poor weather."],
    "UKSFTA Environment", true, 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_enableUavInterference", "CHECKBOX",
    ["Enable UAV/GPS Interference", "Degrade UAV feeds and GPS precision in storms."],
    "UKSFTA Environment", true, 1, {}, true
] call CBA_fnc_addSetting;

// --- WEATHER & TRANSITIONS ---
[
    "uksfta_environment_transitionSpeed", "SLIDER",
    ["Weather Transition Speed", "Higher = Faster weather changes."],
    "UKSFTA Environment", [0.1, 5, 1, 1], 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_stormFrequency", "SLIDER",
    ["Storm Frequency", "Probability of weather state 2 (Storm)."],
    "UKSFTA Environment", [0, 5, 1, 1], 1, {}, true
] call CBA_fnc_addSetting;

// --- CLIENT PERFORMANCE ---
[
    "uksfta_environment_enableParticles", "CHECKBOX",
    ["Enable Storm Particles", "Visual sandstorm/snowstorm effects."],
    "UKSFTA Environment", true, 0, {}, false
] call CBA_fnc_addSetting;

[
    "uksfta_environment_particleMultiplier", "SLIDER",
    ["Particle Density", "Scale amount of particles (Better FPS)."],
    "UKSFTA Environment", [0, 1, 1, 2], 0, {}, false
] call CBA_fnc_addSetting;

[
    "uksfta_environment_visualIntensity", "SLIDER",
    ["PP Effect Intensity", "Strength of color correction/film grain."],
    "UKSFTA Environment", [0, 2, 1, 1], 0, { [] call uksfta_environment_fnc_applyVisuals; }, false
] call CBA_fnc_addSetting;

[
    "uksfta_environment_forcedBiome", "LIST",
    ["Force Biome (Global)", "Override auto-detection."],
    "UKSFTA Environment", 
    [
        ["AUTO", "TEMPERATE", "ARID", "ARCTIC", "TROPICAL", "MEDITERRANEAN", "SUBTROPICAL"],
        ["Automatic", "Temperate", "Arid / Desert", "Arctic / Winter", "Tropical / Jungle", "Mediterranean", "Subtropical"],
        0
    ], 1, {}, true
] call CBA_fnc_addSetting;

true
