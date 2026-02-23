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
        [] spawn {
            waitUntil { !isNil "uksfta_environment_enabled" };
            
            // Dedicated handle for lightning bursts
            private _ppLightning = ppEffectCreate ["FilmGrain", 1504];
            
            while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
                if (lightnings > 0.7 && {overcast > 0.8}) then {
                    if (missionNamespace getVariable ["uksfta_environment_enableSignalInterference", false]) then {
                        player setVariable ["tf_sendingDistanceMultiplicator", 0.05, true];
                        [0.5 + random 1, { player setVariable ["tf_sendingDistanceMultiplicator", 1.0, true]; }] call CBA_fnc_waitAndExecute;
                    };
                    
                    if (missionNamespace getVariable ["uksfta_environment_enableThermals", false] && {currentVisionMode player == 2}) then {
                        _ppLightning ppEffectEnable true;
                        _ppLightning ppEffectAdjust [1.0, 1.0, 1.0, 0.5, 1.0, true];
                        _ppLightning ppEffectCommit 0.1;
                        
                        [0.2 + random 0.3, {
                            params ["_fx"];
                            _fx ppEffectEnable false;
                        }, [_ppLightning]] call CBA_fnc_waitAndExecute;
                    };
                    
                    sleep (2 + random 5);
                };
                sleep 0.5;
            };
            ppEffectDestroy _ppLightning;
        };
    };
};

// 2. Server-Side Intelligence
if (isServer && !is3DEN) then {
    [] spawn uksfta_environment_fnc_weatherCycle;
};

true
