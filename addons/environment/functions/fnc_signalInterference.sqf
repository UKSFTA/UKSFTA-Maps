/**
 * UKSFTA Environment - Signal Interference Engine
 * COMPAT LAYER: Feeds data into TFAR/ACRE APIs.
 */

if (!hasInterface) exitWith {};

// Wait for systems
waitUntil { time > 10 };

while {uksfta_environment_enabled} do {
    if (uksfta_environment_enableSignalInterference) then {
        private _overcast = overcast;
        private _rain = rain;
        private _intensity = uksfta_environment_interferenceIntensity;
        
        // --- DATA CALCULATION (Base Loss) ---
        private _signalLoss = 1.0 + (_overcast * 0.3 * _intensity);
        if (_rain > 0.5) then { _signalLoss = _signalLoss + 0.1; };

        // --- TFAR NATIVE HOOK ---
        if (!isNil "TFAR_fnc_setSendingDistanceMultiplicator") then {
            // Apply stable atmospheric loss
            [player, (1 / _signalLoss)] call TFAR_fnc_setSendingDistanceMultiplicator;
            [player, (1 / _signalLoss)] call TFAR_fnc_setReceivingDistanceMultiplicator;
        };

        // --- ACRE NATIVE HOOK ---
        if (!isNil "acre_api_fnc_setLossModel") then {
            // ACRE Loss Model: 0 = none, higher = more
            private _acreLoss = (_signalLoss - 1) * 0.4;
            // Push to mission namespace for any unit-specific ACRE overrides
            missionNamespace setVariable ["UKSFTA_Environment_ACRE_Loss", _acreLoss, true];
        };

        // --- GLOBAL EXPORT ---
        // Exports state for third-party EW mods to read
        missionNamespace setVariable ["UKSFTA_Environment_Interference", (_signalLoss - 1), true];

    } else {
        // Reset
        if (!isNil "TFAR_fnc_setSendingDistanceMultiplicator") then {
            [player, 1.0] call TFAR_fnc_setSendingDistanceMultiplicator;
        };
    };

    sleep 30; // High stability, low frequency
};
