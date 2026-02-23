#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Weather Evolution Cycle
 */

if (!isServer) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Sovereign Weather Engine Starting...";

while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    private _biome = UKSFTA_Environment_Biome;
    if (isNil "_biome" || {_biome == "PENDING"}) then { _biome = "TEMPERATE"; };
    
    // Resolve next probabilistic state
    // Passing the string directly to avoid params array indexing issues
    private _state = _biome call uksfta_environment_fnc_getNextState;
    
    if (!isNil "_state" && {count _state == 5}) then {
        _state params ["_overcast", "_rain", "_fog", "_wind", "_duration"];

        diag_log text (format ["[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: New Weather State Generated: %1 | Duration: %2s", _biome, _duration]);

        // Apply Transition
        private _time = _duration / (missionNamespace getVariable ["uksfta_environment_transitionSpeed", 1.0]);
        
        if (missionNamespace getVariable ["uksfta_environment_logLevel", 0] > 1) then {
            diag_log text (format ["[UKSF TASKFORCE ALPHA] <TRACE> [ENVIRONMENT]: Overcast -> %1 | Rain -> %2 | Fog -> %3", _overcast, _rain, _fog]);
        };
        
        _time setOvercast _overcast;
        0 setRain _rain;
        _time setFog _fog;
        setWind [_wind, _wind, true];
        
        if (_overcast > 0.8) then { 0 setLightnings 1; } else { 0 setLightnings 0; };
        simulWeatherSync;

        sleep _duration;
    } else {
        diag_log text "[UKSF TASKFORCE ALPHA] <ERROR> [ENVIRONMENT]: Weather State Resolution Failed. Defaulting to 60s fallback.";
        sleep 60;
    };
};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Sovereign Weather Engine Terminated.";
true
