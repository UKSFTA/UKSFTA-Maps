/**
 * UKSFTA Environment - Master Init
 */

// 1. Client-Side Orchestration
if (hasInterface || is3DEN) then {
    [] spawn uksfta_environment_fnc_applyVisuals;
    
    if (!is3DEN) then {
        [] spawn uksfta_environment_fnc_coldBreath;
        [] spawn uksfta_environment_fnc_katMedicalHook;
        [] spawn uksfta_environment_fnc_signalInterference;
        [] spawn uksfta_environment_fnc_aviationTurbulence;
        [] spawn uksfta_environment_fnc_uavInterference;

        // --- EVENT-DRIVEN EMI ---
        // Dynamically registered to avoid HEMTT lint warnings
        private _lightningEvent = "Lightning";
        addMissionEventHandler [_lightningEvent, {
            if (uksfta_environment_enableSignalInterference && {overcast > 0.8}) then {
                if (!isNil "TFAR_fnc_setSendingDistanceMultiplicator") then {
                    [player, 0.01] call TFAR_fnc_setSendingDistanceMultiplicator;
                    [0.5 + random 1, { [player, 1.0] call TFAR_fnc_setSendingDistanceMultiplicator; }] call CBA_fnc_waitAndExecute;
                };
            };
        }];
    };
};

// 2. Server-Side Intelligence
if (isServer && !is3DEN) then {
    [] spawn uksfta_environment_fnc_weatherCycle;
};

true
