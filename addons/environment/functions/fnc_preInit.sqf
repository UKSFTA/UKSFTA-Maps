/**
 * UKSFTA Environment - PreInit Settings
 * Optimized for performance and client-side control.
 */

// --- SERVER-SIDE CONTROLS ---
[
    "uksfta_environment_enabled", "CHECKBOX",
    ["Enable Framework (Server)", "Master toggle for the universal environment system."],
    "UKSFTA Environment", true, 1, {}, true
] call CBA_fnc_addSetting;

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

// --- CLIENT-SIDE PERFORMANCE CONTROLS ---
[
    "uksfta_environment_enableParticles", "CHECKBOX",
    ["Enable Storm Particles", "Enable sandstorm/snowstorm visual hazards."],
    "UKSFTA Environment", true, 0, {}, false
] call CBA_fnc_addSetting;

[
    "uksfta_environment_enableColdBreath", "CHECKBOX",
    ["Enable Cold Breath", "Enable visible breath vapor in cold environments."],
    "UKSFTA Environment", true, 0, {}, false
] call CBA_fnc_addSetting;

[
    "uksfta_environment_particleMultiplier", "SLIDER",
    ["Particle Density", "Scale the amount of particles generated (Lower = Better FPS)."],
    "UKSFTA Environment", [0, 1, 1, 2], 0, {}, false
] call CBA_fnc_addSetting;

[
    "uksfta_environment_visualIntensity", "SLIDER",
    ["PP Effect Intensity", "Strength of color correction and film grain."],
    "UKSFTA Environment", [0, 2, 1, 1], 0, { [] call uksfta_environment_fnc_applyVisuals; }, false
] call CBA_fnc_addSetting;

// --- BIOME CONTROL ---
[
    "uksfta_environment_forcedBiome", "LIST",
    ["Force Biome (Global)", "Override automatic biome detection for all clients."],
    "UKSFTA Environment", 
    [
        ["AUTO", "TEMPERATE", "ARID", "ARCTIC", "TROPICAL", "MEDITERRANEAN", "SUBTROPICAL"],
        ["Automatic", "Temperate", "Arid / Desert", "Arctic / Winter", "Tropical / Jungle", "Mediterranean", "Subtropical"],
        0
    ], 1, {}, true
] call CBA_fnc_addSetting;

true
