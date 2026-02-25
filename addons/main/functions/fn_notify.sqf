#include "..\script_component.hpp"
/**
 * UKSFTA Core - Notification Engine
 * Standardized high-fidelity branded feedback.
 */

params [
    ["_msg", ""],
    ["_type", "INFO"] // INFO, WARN, ALERT
];

if (!hasInterface) exitWith {};

private _color = "#4caf50"; // Info Green
private _icon = "\A3\ui_f\data\map\mapcontrol	askIcon_ca.paa";

switch (toUpper _type) do {
    case "WARN": { _color = "#ff9800"; _icon = "\A3\ui_f\data\map\mapcontrol	askIconFailed_ca.paa"; };
    case "ALERT": { _color = "#f44336"; _icon = "\A3\ui_f\data\map\mapcontrol	askIconCanceled_ca.paa"; };
};

private _structuredText = parseText format [
    "<t align='center' size='1.2' color='%1' font='RobotoCondensedBold'>UKSF TASKFORCE ALPHA</t><br/>" +
    "<t align='center' size='1.0' color='#ffffff'>%2</t>",
    _color, _msg
];

// Display via native notification if CBA isn't present, or use custom UI if needed
// For now, we use a structured hint for maximum visual impact
hintSilent _structuredText;
