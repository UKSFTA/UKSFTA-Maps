#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Advanced Lightning Side Effects (Phase 3)
 * Probabilistic reaction to atmospheric electricity.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Lightning reaction loop active (Probabilistic).";

private _ppLightning = ppEffectCreate ["FilmGrain", 1504];
private _ppFlash = ppEffectCreate ["ColorCorrections", 1507];

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    private _overcast = overcast;
    private _lightningIntensity = lightnings;
    
    // Probabilistic check: if engine lightning is high OR if overcast is very high (static charge)
    private _prob = 0;
    if (_lightningIntensity > 0.5) then { _prob = 0.4; };
    if (_overcast > 0.9) then { _prob = _prob + 0.1; };
    
    if (random 1 < _prob) then {
        // --- 1. Thunderbolt Intensity (Phase 4) ---
        // Intense white-out flash for non-NVG users
        if (currentVisionMode player == 0) then {
            private _flashStrength = 0.1 + (0.4 * _lightningIntensity);
            _ppFlash ppEffectEnable true;
            _ppFlash ppEffectAdjust [1, 1, 0, [1, 1, 1, _flashStrength], [1, 1, 1, 1], [1, 1, 1, 0]];
            _ppFlash ppEffectCommit 0.05;
            
            [0.1, {
                params ["_fx"];
                _fx ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 1], [1, 1, 1, 0]];
                _fx ppEffectCommit 0.4;
                [0.4, { params ["_fx"]; _fx ppEffectEnable false; }, [_fx]] call CBA_fnc_waitAndExecute;
            }, [_ppFlash]] call CBA_fnc_waitAndExecute;
        };

        // --- 2. Signal Interference ---
        if (missionNamespace getVariable ["uksfta_environment_enableSignalInterference", true]) then {
            player setVariable ["tf_sendingDistanceMultiplicator", 0.05, true];
            [0.5 + random 1, { player setVariable ["tf_sendingDistanceMultiplicator", 1.0, true]; }] call CBA_fnc_waitAndExecute;
        };
        
        // --- 3. Thermal Visual Noise ---
        if (missionNamespace getVariable ["uksfta_environment_enableThermals", true] && {currentVisionMode player == 2}) then {
            _ppLightning ppEffectEnable true;
            _ppLightning ppEffectAdjust [1.5, 1.2, 1.0, 0.8, 1.0, true];
            _ppLightning ppEffectCommit 0.05;
            
            [0.1 + random 0.2, {
                params ["_fx"];
                _fx ppEffectAdjust [1.0, 1.0, 1.0, 0.5, 1.0, true];
                _fx ppEffectCommit 0.2;
                [0.2, { params ["_fx"]; _fx ppEffectEnable false; }, [_fx]] call CBA_fnc_waitAndExecute;
            }, [_ppLightning]] call CBA_fnc_waitAndExecute;
        };
        
        sleep (1 + random 4);
    };
    
    sleep 0.5;
};

ppEffectDestroy _ppLightning;
ppEffectDestroy _ppFlash;
true
