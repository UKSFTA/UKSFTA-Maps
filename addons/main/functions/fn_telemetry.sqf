#include "..\script_component.hpp"
/**
 * UKSFTA Core - High-Performance Logging Backend
 * Handles tiered diagnostic output based on CBA settings.
 */

params [
    ["_level", "INFO"],
    ["_msg", ""],
    ["_component", "Core"]
];

private _logThreshold = missionNamespace getVariable ["uksfta_logLevel", 1];
private _numericLevel = 1;

switch (toUpper _level) do {
    case "ERROR": { _numericLevel = 0; };
    case "WARN":  { _numericLevel = 1; };
    case "INFO":  { _numericLevel = 1; };
    case "TRACE": { _numericLevel = 2; };
};

if (_numericLevel <= _logThreshold) then {
    diag_log text (format ["[UKSF TASKFORCE ALPHA] <%1> [%2]: %3", toUpper _level, toUpper _component, _msg]);
};
