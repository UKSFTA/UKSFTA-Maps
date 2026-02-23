#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Radio Signal Interference
 * Attenuates radio range based on atmospheric moisture.
 */

if (!hasInterface) exitWith {};

// --- ABSOLUTE STARTUP GUARD ---
waitUntil { !isNil "uksfta_environment_enabled" };

LOG_INFO("Signal Interference Hook Active.");

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    if (missionNamespace getVariable ["uksfta_environment_enableSignalInterference", false]) then {
        private _overcast = overcast;
        private _rain = rain;
        
        // Multi-Factor Attenuation Model
        // Rain is the primary attenuator (up to 40% loss), Overcast secondary (up to 20% loss)
        private _loss = 1.0 - ((_overcast * 0.2) + (_rain * 0.4));
        
        // Scale by user intensity
        private _intensity = missionNamespace getVariable ["uksfta_environment_interferenceIntensity", 1.0];
        _loss = (1.0 - ((1.0 - _loss) * _intensity)) max 0.05;

        // --- TFAR Integration ---
        if (!isNil "tf_fnc_setSendingDistanceMultiplicator") then {
            player setVariable ["tf_sendingDistanceMultiplicator", _loss, true];
            player setVariable ["tf_receivingDistanceMultiplicator", _loss, true];
        };

        // --- ACRE Integration ---
        if (!isNil "acre_api_fnc_setLoss") then {
            // [ACRE Loss implementation]
        };

        missionNamespace setVariable ["UKSFTA_Environment_Interference", (1.0 - _loss), true];
        
        if (_loss < 0.7) then {
            LOG_TRACE(format ["Significant Radio Attenuation Active: %1%2 loss", ((1.0 - _loss) * 100), "%"]);
        };
    };

    sleep 15; // Atmospheric density changes slowly
};

LOG_INFO("Signal Interference Loop Terminated.");
true
