/**
 * UKSFTA Camouflage - PreInit Settings
 */

[
    "uksfta_camouflage_enabled", "CHECKBOX",
    ["Enable Dynamic Camouflage", "Master toggle for the biome-aware camouflage system."],
    "UKSFTA Camouflage", true, 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_camouflage_aiCompat", "CHECKBOX",
    ["Enable AI Mod Balancing", "Automatically boosts camouflage when Lambs or VCOM AI are detected to counteract superhuman detection."],
    "UKSFTA Camouflage", true, 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_camouflage_grassFix", "CHECKBOX",
    ["Enable AI Grass Fix", "Improves concealment when prone in tall grass."],
    "UKSFTA Camouflage", true, 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_camouflage_intensity", "SLIDER",
    ["Camo Effectiveness", "Multiplier for camouflage bonuses (Higher = more stealthy)."],
    "UKSFTA Camouflage", [0, 2, 1, 1], 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_camouflage_perfMode", "LIST",
    ["Sampling Fidelity", "Adjust how often the terrain is sampled for camouflage matching."],
    "UKSFTA Camouflage", 
    [
        [0, 1, 2],
        ["Tactical (5m check)", "Balanced (10m check)", "Low-Impact (25m check)"],
        1
    ], 1, {}, true
] call CBA_fnc_addSetting;

[
    "uksfta_camouflage_highFidelity", "CHECKBOX",
    ["Enable High-Fidelity Sampling", "If disabled, uses biome-average colors instead of pixel-perfect sampling to save CPU."],
    "UKSFTA Camouflage", true, 1, {}, true
] call CBA_fnc_addSetting;

true
