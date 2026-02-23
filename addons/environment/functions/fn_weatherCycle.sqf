#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Weather Evolution Cycle
 * Sovereign logic for biome-specific weather simulation.
 */

if (!isServer) exitWith {};

LOG_INFO("Sovereign Weather Engine Starting...");

while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    
    // Resolve next probabilistic state
    private _state = [_biome] call uksfta_environment_fnc_getNextState;
    _state params ["_overcast", "_rain", "_fog", "_wind", "_duration"];

    LOG_INFO(format ["New Weather State Generated: %1 | Duration: %2s", _state, _duration]);

    // Apply Transition
    private _time = _duration / (missionNamespace getVariable ["uksfta_environment_transitionSpeed", 1.0]);
    
    LOG_TRACE(format ["Transitioning Overcast to %1 over %2s", _overcast, _time]);
    _time setOvercast _overcast;
    
    LOG_TRACE(format ["Transitioning Rain to %1", _rain]);
    0 setRain _rain;
    
    LOG_TRACE(format ["Transitioning Fog to %1", _fog]);
    _time setFog _fog;
    
    setWind [_wind, _wind, true];
    
    // Atmospheric Sync
    if (_overcast > 0.8) then { 
        LOG_TRACE("Storm Conditions Detected. Enabling Sovereign Lightning.");
        0 setLightnings 1; 
    } else { 
        0 setLightnings 0; 
    };
    
    simulWeatherSync;
    LOG_INFO("Atmospheric Synchronization Complete.");

    sleep _duration;
};

LOG_INFO("Sovereign Weather Engine Terminated.");
true
