#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Weather Evolution Cycle
 * Sovereign logic for biome-specific weather simulation.
 */

if (!isServer) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Sovereign Weather Engine Starting...";

while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    
    // Resolve next probabilistic state
    private _state = [_biome] call uksfta_environment_fnc_getNextState;
    _state params ["_overcast", "_rain", "_fog", "_wind", "_duration"];

    diag_log text (format ["[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: New Weather State Generated: %1 | Duration: %2s", _state, _duration]);

    // Apply Transition
    private _time = _duration / (missionNamespace getVariable ["uksfta_environment_transitionSpeed", 1.0]);
    
    if (missionNamespace getVariable ["uksfta_environment_logLevel", 0] > 1) then {
        diag_log text (format ["[UKSF TASKFORCE ALPHA] <TRACE> [ENVIRONMENT]: Transitioning Overcast to %1 over %2s", _overcast, _time]);
    };
    _time setOvercast _overcast;
    
    if (missionNamespace getVariable ["uksfta_environment_logLevel", 0] > 1) then {
        diag_log text (format ["[UKSF TASKFORCE ALPHA] <TRACE> [ENVIRONMENT]: Transitioning Rain to %1", _rain]);
    };
    0 setRain _rain;
    
    if (missionNamespace getVariable ["uksfta_environment_logLevel", 0] > 1) then {
        diag_log text (format ["[UKSF TASKFORCE ALPHA] <TRACE> [ENVIRONMENT]: Transitioning Fog to %1", _fog]);
    };
    _time setFog _fog;
    
    setWind [_wind, _wind, true];
    
    // Atmospheric Sync
    if (_overcast > 0.8) then { 
        if (missionNamespace getVariable ["uksfta_environment_logLevel", 0] > 1) then {
            diag_log text "[UKSF TASKFORCE ALPHA] <TRACE> [ENVIRONMENT]: Storm Conditions Detected. Enabling Sovereign Lightning.";
        };
        0 setLightnings 1; 
    } else { 
        0 setLightnings 0; 
    };
    
    simulWeatherSync;
    diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Atmospheric Synchronization Complete.";

    sleep _duration;
};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Sovereign Weather Engine Terminated.";
true
