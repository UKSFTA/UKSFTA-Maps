/**
 * UKSFTA Cartography - Mode Toggler
 */

private _current = missionNamespace getVariable ["UKSFTA_Cartography_Mode", "STANDARD"];
private _next = "STANDARD";

switch (_current) do {
    case "STANDARD":    { _next = "SATELLITE"; };
    case "SATELLITE":   { _next = "TOPOGRAPHIC"; };
    case "TOPOGRAPHIC": { _next = "STANDARD"; };
};

missionNamespace setVariable ["UKSFTA_Cartography_Mode", _next];
systemChat format ["[UKSFTA-MAPS] View Mode: %1", _next];

true
