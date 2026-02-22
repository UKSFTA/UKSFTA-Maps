/**
 * UKSFTA Environment - PreInit Settings
 */

// We use a safe registration method that respects existing config entries
private _cat = "UKSFTA Environment";

[
    "uksfta_environment_preset", "LIST",
    ["Operational Mode", "ARCADE: Easier visibility. REALISM: Full Diamond Standard."],
    _cat, [["ARCADE", "REALISM"], ["Arcade (Relaxed)", "Realism (Diamond Standard)"], 1], 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_enabled", "CHECKBOX",
    ["Enable Framework (Server)", "Master toggle for the universal environment system."],
    _cat, true, 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_enableThermals", "CHECKBOX",
    ["Enable Thermal Realism", "Atmospheric conditions will degrade Thermal Imaging (TI) clarity."],
    _cat, true, 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_thermalIntensity", "SLIDER",
    ["Thermal Degradation Strength", "Higher = more grain/noise in TI."],
    _cat, [0, 5, 1, 1], 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_debug", "CHECKBOX",
    ["Enable Engine Debug", "Log telemetry to RPT."],
    _cat, false, 0, {}, false
] call CBA_fnc_addSetting;

[
    "uksfta_environment_debugHUD", "CHECKBOX",
    ["Enable Visual Debug HUD", "Show real-time telemetry on screen."],
    _cat, false, 0, {}, false
] call CBA_fnc_addSetting;

[
    "uksfta_environment_enableTurbulence", "CHECKBOX",
    ["Enable Aviation Turbulence", "Physical forces on aircraft during poor weather."],
    _cat, true, 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_enableUavInterference", "CHECKBOX",
    ["Enable UAV/GPS Interference", "Degrade UAV feeds and GPS precision."],
    _cat, true, 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_transitionSpeed", "SLIDER",
    ["Weather Transition Speed", "Higher = Faster weather changes."],
    _cat, [0.1, 5, 1, 1], 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_stormFrequency", "SLIDER",
    ["Storm Frequency", "Probability of weather state 2 (Storm)."],
    _cat, [0, 5, 1, 1], 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_environment_enableParticles", "CHECKBOX",
    ["Enable Storm Particles", "Visual sandstorm/snowstorm effects."],
    _cat, true, 0, {}, false
] call CBA_fnc_addSetting;

[
    "uksfta_environment_enableColdBreath", "CHECKBOX",
    ["Enable Cold Breath", "Visible breath in cold environments."],
    _cat, true, 0, {}, false
] call CBA_fnc_addSetting;

[
    "uksfta_environment_particleMultiplier", "SLIDER",
    ["Particle Density", "Scale amount of particles (Better FPS)."],
    _cat, [0, 1, 1, 2], 0, {}, false
] call CBA_fnc_addSetting;

[
    "uksfta_environment_visualIntensity", "SLIDER",
    ["PP Effect Intensity", "Strength of color correction/film grain."],
    _cat, [0, 2, 1, 1], 0, { [] call uksfta_environment_fnc_applyVisuals; }, false
] call CBA_fnc_addSetting;

[
    "uksfta_environment_forcedBiome", "LIST",
    ["Force Biome (Global)", "Override auto-detection."],
    _cat, [["AUTO", "TEMPERATE", "ARID", "ARCTIC", "TROPICAL", "MEDITERRANEAN", "SUBTROPICAL"], ["Automatic", "Temperate", "Arid", "Arctic", "Tropical", "Mediterranean", "Subtropical"], 0], 1, {}, true
] call CBA_fnc_addSetting;

true
