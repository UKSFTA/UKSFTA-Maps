#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Radio Signal Interference
 * Attenuates radio range based on atmospheric moisture.
 */

if (!hasInterface) exitWith {};

// --- ABSOLUTE STARTUP GUARD ---
waitUntil { !isNil "uksfta_environment_enabled" };

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    if (missionNamespace getVariable ["uksfta_environment_enableSignalInterference", false]) then {
        private _overcast = overcast;
        private _rain = rain;
        private _loss = 1.0 - ((_overcast * 0.2) + (_rain * 0.3));
        
        // Scale by user intensity
        private _intensity = missionNamespace getVariable ["uksfta_environment_interferenceIntensity", 1.0];
        _loss = (1.0 - ((1.0 - _loss) * _intensity)) max 0.1;

        // TFAR Integration
        player setVariable ["tf_sendingDistanceMultiplicator", _loss, true];
        player setVariable ["tf_receivingDistanceMultiplicator", _loss, true];

        if (missionNamespace getVariable ["uksfta_environment_debugHUD", false]) then {
            // [Debug logging handled by initDebug OSD]
        };
    };

    sleep 10;
};
true
