/**
 * UKSFTA Environment - UAV & GPS Interference (EW)
 * Simulates atmospheric EMI on high-tech assets.
 */

if (!hasInterface) exitWith {};

while {true} do {
    if (uksfta_environment_enableUavInterference) then {
        private _overcast = overcast;
        private _uav = getConnectedUAV player;
        
        // 1. UAV VIDEO FEED INTERFERENCE
        if (!isNull _uav && _overcast > 0.7) then {
            private _jitter = (_overcast - 0.7) * 0.1;
            "FilmGrain" ppEffectAdjust [_jitter, 1.25, 1, 0, 1];
            "FilmGrain" ppEffectCommit 1;
        };

        // 2. GPS JITTER (EMI Simulation)
        if (lightnings > 0.8 && overcast > 0.9) then {
            if (!isNil "TFAR_fnc_setSendingDistanceMultiplicator" && {random 100 > 90}) then {
                [player, 0.05] call TFAR_fnc_setSendingDistanceMultiplicator;
                // Standard engine log to avoid macro conflicts
                diag_log "[UKSFTA-COP] UPLINK EMI: STATIC BURST DETECTED";
                sleep 2;
            };
        };
    };

    sleep 10;
};
