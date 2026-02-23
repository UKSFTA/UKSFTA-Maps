#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UAV Interference (PP Stack)
 * Simulates signal degradation for remote sensors.
 */

if (!hasInterface) exitWith {};

// --- ABSOLUTE STARTUP GUARD ---
waitUntil { !isNil "uksfta_environment_enabled" };

// Dedicated handle for UAV degradation
private _ppFilmG = ppEffectCreate ["FilmGrain", 1503];

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _uav = getConnectedUAV player;
    
    if (!isNull _uav) then {
        private _dist = player distance _uav;
        private _noise = 0;

        if (_dist > 2000) then { _noise = (_dist - 2000) / 3000; };
        
        if (_noise > 0.05) then {
            _ppFilmG ppEffectEnable true;
            _ppFilmG ppEffectAdjust [(_noise min 1.0), 1.5, 2.5, 0.5, 1.0, true];
            _ppFilmG ppEffectCommit 0.2;
        } else {
            _ppFilmG ppEffectEnable false;
        };
    } else {
        _ppFilmG ppEffectEnable false;
    };

    sleep 1;
};

// Cleanup
ppEffectDestroy _ppFilmG;
true
