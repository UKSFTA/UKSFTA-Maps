#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UAV Interference
 * Simulates signal degradation for remote sensors.
 */

if (!hasInterface) exitWith {};

// --- ABSOLUTE STARTUP GUARD ---
waitUntil { !isNil "uksfta_environment_enabled" };

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _uav = getConnectedUAV player;
    
    if (!isNull _uav) then {
        private _dist = player distance _uav;
        private _noise = 0;

        if (_dist > 2000) then { _noise = (_dist - 2000) / 3000; };
        
        // --- Standard Macro Call ---
        if (_noise > 0.05) then {
            UKSFTA_SET_TI(TI_NOISE,(_noise min 1.0));
        };
    };

    sleep 1;
};
true
