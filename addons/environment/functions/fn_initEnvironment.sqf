#include "..\script_component.hpp"
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
        [] spawn uksfta_environment_fnc_initDebug;
        [] spawn uksfta_environment_fnc_handleThermals;

        // --- EVENT-DRIVEN EMI ---
        private _lightningEvent = "Lightning";
        addMissionEventHandler [_lightningEvent, {
            if (missionNamespace getVariable ["uksfta_environment_enableSignalInterference", false] && {overcast > 0.8}) then {
                player setVariable ["tf_sendingDistanceMultiplicator", 0.05, true];
                [0.5 + random 1, { player setVariable ["tf_sendingDistanceMultiplicator", 1.0, true]; }] call CBA_fnc_waitAndExecute;
                
                // Thermal Flicker (Sovereign Mapping)
                if (missionNamespace getVariable ["uksfta_environment_enableThermals", false] && {!isNil "UKSFTA_TI_NOISE"}) then {
                    UKSFTA_SET_TI(UKSFTA_TI_NOISE,1.0);
                    [0.2 + random 0.3, { UKSFTA_SET_TI(UKSFTA_TI_NOISE,0); }] call CBA_fnc_waitAndExecute;
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
