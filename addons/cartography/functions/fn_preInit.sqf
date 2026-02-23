#include "..\script_component.hpp"
/**
 * UKSFTA Cartography - PreInit Settings
 */

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [CARTOGRAPHY]: Initializing Pre-Init Settings...";

[
    "UKSFTA_Cartography_Mode", "LIST",
    ["Map Layer Mode", "Toggles the high-fidelity tactical overlay on the mission map."],
    "UKSFTA Cartography", 
    [
        ["STANDARD", "SATELLITE", "TOPOGRAPHIC", "OS_HYBRID"],
        ["Standard (Vanilla)", "Full Satellite", "Tactical Topographic", "UKSFTA OS Hybrid"],
        0
    ], 1, {}, true
] call CBA_fnc_addSetting;

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [CARTOGRAPHY]: Pre-Init Settings Registered.";
true
