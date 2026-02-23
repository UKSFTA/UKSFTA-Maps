#include "..\script_component.hpp"
/**
 * UKSFTA Cartography - Toggle Mode
 * Cycles through tactical overlays.
 */

if (!hasInterface) exitWith {};

private _current = missionNamespace getVariable ["UKSFTA_Cartography_Mode", "STANDARD"];
private _modes = ["STANDARD", "SATELLITE", "TOPOGRAPHIC", "OS_HYBRID"];

private _nextIdx = ((_modes find _current) + 1) % (count _modes);
private _next = _modes select _nextIdx;

missionNamespace setVariable ["UKSFTA_Cartography_Mode", _next, true];

diag_log text (format ["[UKSF TASKFORCE ALPHA] <INFO> [CARTOGRAPHY]: Map Mode Toggled: %1", _next]);

true
