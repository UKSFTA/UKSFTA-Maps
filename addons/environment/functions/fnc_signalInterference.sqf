/**
 * UKSFTA Environment - Signal Interference Engine
 * Dynamically degrades TFAR/ACRE signals based on weather.
 */

if (!hasInterface) exitWith {};

// Wait for radio systems to initialize
waitUntil { time > 10 };

while {uksfta_environment_enabled} do {
    if (uksfta_environment_enableSignalInterference) then {
        private _overcast = overcast;
        private _rain = rain;
        private _intensity = uksfta_environment_interferenceIntensity;
        
        // Calculate Base Interference (Up to 40% loss during max storm)
        private _signalLoss = 1.0 + (_overcast * 0.4 * _intensity);
        if (_rain > 0.5) then { _signalLoss = _signalLoss + 0.2; };

        // --- TFAR INTEGRATION ---
        if (!isNil "TFAR_fnc_setSendingDistanceMultiplicator") then {
            // TFAR uses a coefficient for terrain/air loss. 
            // We increase the 'loss' which effectively reduces range.
            // TF_terrain_interruption_coefficient is a global setting, 
            // but we can adjust individual multipliers.
            [player, (1 / _signalLoss)] call TFAR_fnc_setSendingDistanceMultiplicator;
            [player, (1 / _signalLoss)] call TFAR_fnc_setReceivingDistanceMultiplicator;
        };

        // --- ACRE INTEGRATION ---
        if (!isNil "acre_api_fnc_setLossModel") then {
            // ACRE has a complex API. We adjust the global core signal loss.
            // 0 = no loss, higher = more loss.
            private _acreLoss = (_signalLoss - 1) * 0.5;
            // Pushing a global variable that ACRE hooks can read if configured,
            // or directly modifying the player's radio loss if API allows.
            missionNamespace setVariable ["UKSFTA_Environment_ACRE_Loss", _acreLoss];
        };

        // --- ATMOSPHERIC STATIC (EMI) ---
        // If lightning is high or sandstorm is active, add momentary spikes
        if (lightnings > 0.7) then {
            // Momentary 2x interference spike during electrical storms
            if (random 100 > 80) then {
                if (!isNil "TFAR_fnc_setSendingDistanceMultiplicator") then {
                    [player, 0.1] call TFAR_fnc_setSendingDistanceMultiplicator;
                };
                sleep (1 + random 2);
            };
        };
    } else {
        // Reset multipliers if disabled
        if (!isNil "TFAR_fnc_setSendingDistanceMultiplicator") then {
            [player, 1.0] call TFAR_fnc_setSendingDistanceMultiplicator;
            [player, 1.0] call TFAR_fnc_setReceivingDistanceMultiplicator;
        };
    };

    sleep 15;
};
