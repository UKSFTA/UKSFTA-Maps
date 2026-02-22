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

        // --- SOVEREIGN LIGHTNING LOOP ---
        // Bypassing addMissionEventHandler ["Lightning"] due to engine enum conflicts
        [] spawn {
            waitUntil { !isNil "uksfta_environment_enabled" };
            
            while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
                // We check if lightning is physically occurring via engine state
                if (lightnings > 0.7 && {overcast > 0.8}) then {
                    if (missionNamespace getVariable ["uksfta_environment_enableSignalInterference", false]) then {
                        player setVariable ["tf_sendingDistanceMultiplicator", 0.05, true];
                        [0.5 + random 1, { player setVariable ["tf_sendingDistanceMultiplicator", 1.0, true]; }] call CBA_fnc_waitAndExecute;
                    };
                    
                    if (missionNamespace getVariable ["uksfta_environment_enableThermals", false]) then {
                        UKSFTA_SET_TI(TI_NOISE,1.0);
                        [0.2 + random 0.3, { UKSFTA_SET_TI(TI_NOISE,0); }] call CBA_fnc_waitAndExecute;
                    };
                    
                    sleep (2 + random 5); // Prevent rapid re-triggering
                };
                sleep 0.5;
            };
        };
    };
};

// 2. Server-Side Intelligence
if (isServer && !is3DEN) then {
    [] spawn uksfta_environment_fnc_weatherCycle;
};

true
