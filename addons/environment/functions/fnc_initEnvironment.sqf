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
    };
};

// 2. Server-Side Intelligence (Master Cycle)
if (isServer && !is3DEN) then {
    [] spawn uksfta_environment_fnc_weatherCycle;
};

true
