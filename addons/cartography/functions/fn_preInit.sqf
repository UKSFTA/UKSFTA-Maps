/**
 * UKSFTA Cartography - PreInit Settings
 */

[
    "uksfta_cartography_mode", "LIST",
    ["Active Map Layer", "Choose the high-performance tactical overlay style."],
    "UKSFTA Cartography", 
    [
        ["STANDARD", "SATELLITE", "TOPOGRAPHIC", "OS_HYBRID"],
        ["Standard (A3)", "High-Fidelity Satellite", "Topographic (Survey)", "OS-Hybrid (Tactical)"],
        0
    ], 1, {
        params ["_value"];
        missionNamespace setVariable ["UKSFTA_Cartography_Mode", _value];
    }, true
] call CBA_fnc_addSetting;

true
