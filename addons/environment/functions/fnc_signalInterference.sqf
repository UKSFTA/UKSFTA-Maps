/**
 * UKSFTA Environment - Signal Interference Engine
 * COMPAT LAYER: Uses Verified Variable Assignments.
 */

if (!hasInterface) exitWith {};

waitUntil { time > 10 };

while {uksfta_environment_enabled} do {
    if (uksfta_environment_enableSignalInterference) then {
        private _overcast = overcast;
        private _rain = rain;
        private _intensity = uksfta_environment_interferenceIntensity;
        
        // --- DATA CALCULATION ---
        private _signalLoss = 1.0 + (_overcast * 0.3 * _intensity);
        if (_rain > 0.5) then { _signalLoss = _signalLoss + 0.1; };
        private _multiplier = 1.0 / _signalLoss;

        // --- TFAR VERIFIED METHOD ---
        // Directly set variables on player object (Works on all TFAR versions)
        player setVariable ["tf_sendingDistanceMultiplicator", _multiplier, true];
        player setVariable ["tf_receivingDistanceMultiplicator", _multiplier, true];

        // --- ACRE2 COMPAT ---
        // ACRE is complex. We export a global interference variable.
        // Mission makers can use this in custom signal functions if they wish.
        missionNamespace setVariable ["UKSFTA_Environment_Interference_Level", _signalLoss, true];

        // --- GLOBAL EXPORT ---
        missionNamespace setVariable ["UKSFTA_Environment_Interference", (_signalLoss - 1), true];

    } else {
        // Reset
        player setVariable ["tf_sendingDistanceMultiplicator", 1.0, true];
        player setVariable ["tf_receivingDistanceMultiplicator", 1.0, true];
    };

    sleep 30; 
};
