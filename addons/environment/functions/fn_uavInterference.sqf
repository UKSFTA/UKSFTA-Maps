#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UAV Feed Interference
 * Atmospheric EMI for drone operations.
 */

if (!hasInterface) exitWith {};

// Strict guard: Wait for settings to sync
waitUntil { !isNil "uksfta_environment_enabled" };

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _uav = cameraOn;
    
    if (!isNil "_uav" && {(_uav isKindOf "UAV") || (getConnectedUAV player != objNull)}) then {
        private _overcast = overcast;
        private _intensity = missionNamespace getVariable ["uksfta_environment_interferenceIntensity", 1.0];
        
        // UAVs are more sensitive to atmospheric noise
        private _noise = (_overcast * 0.4) * _intensity;
        
        if (_noise > 0.1) then {
            // Apply visual noise to feed (No padding for HEMTT compliance)
            UKSFTA_SET_TI(TI_NOISE,_noise);
            UKSFTA_SET_TI(TI_GRAIN,_noise * 0.8);
        };
    };

    sleep 2;
};
true
