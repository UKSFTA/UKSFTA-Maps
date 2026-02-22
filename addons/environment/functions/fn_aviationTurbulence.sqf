#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Aviation Turbulence
 * Physically-derived flight instability.
 */

if (!hasInterface) exitWith {};

// Strict guard: Wait for settings to sync
waitUntil { !isNil "uksfta_environment_enabled" };

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _veh = objectParent player;
    
    if (!isNil "_veh" && {(_veh isKindOf "Air") && !(_veh isKindOf "Parachute")}) then {
        private _overcast = overcast;
        private _wind = vectorMagnitude wind;
        private _alt = (getPosVisual _veh) select 2;
        
        // Intensity scaling
        private _intensity = missionNamespace getVariable ["uksfta_environment_turbulenceIntensity", 1.0];
        private _factor = ((_overcast * 0.5) + (_wind * 0.05)) * _intensity;
        
        // Altitude dampening (Turbulence drops as air thins)
        if (_alt > 2000) then { _factor = _factor * 0.5; };
        
        if (_factor > 0.1 && (alive _veh) && (isEngineOn _veh)) then {
            private _force = [
                (random _factor) - (_factor / 2),
                (random _factor) - (_factor / 2),
                (random _factor) - (_factor / 2)
            ];
            
            // Apply physical stress
            _veh addForce [_veh vectorModelToWorld _force, [0,0,0]];
        };
    };

    sleep 0.5;
};
true
