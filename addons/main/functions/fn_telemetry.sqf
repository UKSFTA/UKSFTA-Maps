/**
 * UKSFTA Technical Infrastructure - Sovereign Logger
 * Standardized multi-level logging for all unit technologies.
 */

params [
    ["_level", "INFO"],
    ["_msg", ""],
    ["_component", "Core"]
];

private _threshold = missionNamespace getVariable ["uksfta_environment_logLevel", 1];

// 0: Errors, 1: Info, 2: Trace
private _lvlVal = 1;
if (_level == "ERROR") then { _lvlVal = 0; };
if (_level == "TRACE") then { _lvlVal = 2; };

if (_lvlVal <= _threshold) then {
    diag_log text (format ["[UKSF TASKFORCE ALPHA] <%1> [%2]: %3", toUpper _level, toUpper _component, _msg]);
};

true
