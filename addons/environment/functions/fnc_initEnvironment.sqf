/**
 * UKSFTA Environment - Master Init
 */

// 1. Client-Side Orchestration (Offloaded from Server)
if (hasInterface || is3DEN) then {
    [] spawn uksfta_environment_fnc_applyVisuals;
    
    if (!is3DEN) then {
        [] spawn uksfta_environment_fnc_coldBreath;
        [] spawn uksfta_environment_fnc_katMedicalHook;
        [] spawn uksfta_environment_fnc_signalInterference;
        [] spawn uksfta_environment_fnc_aviationTurbulence;
        [] spawn uksfta_environment_fnc_uavInterference;
        [] spawn uksfta_environment_fnc_initDebug;

        // --- EVENT-DRIVEN EMI ---
        private _lightningEvent = "Lightning";
        addMissionEventHandler [_lightningEvent, {
            if (uksfta_environment_enableSignalInterference && {overcast > 0.8}) then {
                player setVariable ["tf_sendingDistanceMultiplicator", 0.05, true];
                [0.5 + random 1, { player setVariable ["tf_sendingDistanceMultiplicator", 1.0, true]; }] call CBA_fnc_waitAndExecute;
                if (uksfta_environment_debug) then { diag_log "[UKSFTA-ENV] EMI: LIGHTNING SPIKE DETECTED"; };
            };
        }];
    };
};

// 2. Server-Side Intelligence
if (isServer && !is3DEN) then {
    [] spawn uksfta_environment_fnc_weatherCycle;
};

true
