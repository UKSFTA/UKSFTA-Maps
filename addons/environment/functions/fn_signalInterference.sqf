/**
 * UKSFTA Environment - Signal Interference Engine
 */

if (!hasInterface) exitWith {};

waitUntil { time > 10 };

while {uksfta_environment_enabled} do {
    if (uksfta_environment_enableSignalInterference) then {
        private _overcast = overcast;
        private _rain = rain;
        private _intensity = uksfta_environment_interferenceIntensity;
        
        // --- PRESET SCALING (Optimized) ---
        private _multiplier = [1.0, 0.1] select (uksfta_environment_preset == "ARCADE");

        private _signalLoss = 1.0 + (_overcast * 0.3 * _intensity * _multiplier);
        if (_rain > 0.5) then { _signalLoss = _signalLoss + (0.1 * _multiplier); };
        private _m = 1.0 / _signalLoss;

        player setVariable ["tf_sendingDistanceMultiplicator", _m, true];
        player setVariable ["tf_receivingDistanceMultiplicator", _m, true];

        missionNamespace setVariable ["UKSFTA_Environment_Interference", (_signalLoss - 1), true];

    } else {
        player setVariable ["tf_sendingDistanceMultiplicator", 1.0, true];
        player setVariable ["tf_receivingDistanceMultiplicator", 1.0, true];
    };

    sleep 30; 
};
true
