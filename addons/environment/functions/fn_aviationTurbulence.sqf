#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Aviation Turbulence
 * Physically-derived flight instability.
 */

if (!hasInterface) exitWith {};

// Strict guard: Wait for settings to sync
waitUntil { !isNil "uksfta_environment_enabled" };

LOG_INFO("Aviation Turbulence Engine Active.");

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _veh = vehicle player;
    
    if (_veh isKindOf "Air" && {!(_veh isKindOf "Parachute")} && {isEngineOn _veh}) then {
        private _overcast = overcast;
        private _wind = vectorMagnitude wind;
        private _alt = (getPosVisual _veh) select 2;
        
        // Intensity scaling
        private _intensity = missionNamespace getVariable ["uksfta_environment_turbulenceIntensity", 1.0];
        private _factor = ((_overcast * 0.6) + (_wind * 0.08)) * _intensity;
        
        // Altitude dampening (Turbulence drops as air thins)
        if (_alt > 1500) then { _factor = _factor * 0.4; };
        if (_alt > 3000) then { _factor = 0; };
        
        if (_factor > 0.1 && {alive _veh}) then {
            private _force = [
                (random _factor) - (_factor / 2),
                (random _factor) - (_factor / 2),
                (random _factor) * 0.5 // Mostly vertical stress
            ];
            
            // Apply physical stress to the airframe
            _veh addForce [_veh vectorModelToWorld _force, [0,0,0]];
            
            if (_factor > 0.8 && {random 100 < 5}) then {
                LOG_TRACE("Severe Turbulence Detected. Applying airframe stress.");
            };
        };
    };

    sleep 0.25; // High-frequency physical sampling
};

LOG_INFO("Aviation Turbulence Engine Terminated.");
true
