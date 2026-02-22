/**
 * UKSFTA Cartography - PreInit Settings
 */

[
    "uksfta_cartography_mode", "LIST",
    ["Active Map Style", "Toggle between different visual representations of the terrain."],
    "UKSFTA Maps", 
    [
        ["STANDARD", "SATELLITE", "TOPOGRAPHIC", "OS_HYBRID"],
        ["Standard (Vanilla/Enhanced)", "Satellite Imagery", "Topographic (Military)", "Ordnance Survey (Hybrid)"],
        0
    ], 1, {
        params ["_value"];
        missionNamespace setVariable ["UKSFTA_Cartography_Mode", _value];
    }, true
] call CBA_fnc_addSetting;

true
