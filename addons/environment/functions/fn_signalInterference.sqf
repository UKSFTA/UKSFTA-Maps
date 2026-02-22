#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Signal Interference (TFAR/ACRE)
 * Atmospheric signal attenuation.
 */

if (!hasInterface) exitWith {};

// Strict guard: Wait for settings to sync
waitUntil { !isNil "uksfta_environment_enabled" };

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    if (missionNamespace getVariable ["uksfta_environment_enableSignalInterference", false]) then {
        private _overcast = overcast;
        private _intensity = missionNamespace getVariable ["uksfta_environment_interferenceIntensity", 1.0];
        
        // TFAR Sending Distance Multiplier
        // 1.0 = normal, 0.5 = half range
        private _loss = (1.0 - (_overcast * 0.3 * _intensity)) max 0.1;
        
        player setVariable ["tf_sendingDistanceMultiplicator", _loss, true];
        
        if (uksfta_environment_debug) then {
            // Telemetry handled in master debug
        };
    } else {
        player setVariable ["tf_sendingDistanceMultiplicator", 1.0, true];
    };

    sleep 60;
};
true
