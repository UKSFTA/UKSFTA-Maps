#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Thermal Management (PP Stack)
 * Simulates atmospheric degradation of TI optics using standard PP effects.
 */

if (!hasInterface) exitWith {};

// --- ABSOLUTE STARTUP GUARD ---
waitUntil { !isNil "uksfta_environment_enabled" };

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Thermal Management Hook Active.";

// Dedicated handles for UKSFTA Environmental TI
private _ppColorC = ppEffectCreate ["ColorCorrections", 1501];
private _ppFilmG = ppEffectCreate ["FilmGrain", 1502];

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    // Only apply while in Thermal view
    if (currentVisionMode player == 2 && {missionNamespace getVariable ["uksfta_environment_enableThermals", false]}) then {
        private _overcast = overcast;
        private _fog = fog;
        private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
        private _sunAlt = call uksfta_environment_fnc_getSunElevation;
        
        private _noise = 0;
        private _washout = 0;

        // 1. Atmospheric Noise (Humidity/Fog)
        if (_overcast > 0.7) then { _noise = (_overcast - 0.7) * 0.5; };
        if (_fog > 0.3) then { _noise = _noise + (_fog * 0.5); };

        // 2. Thermal Washout (Phase 5: Arid Heat Soak)
        // Simulate "shimmer" and contrast loss at high noon in Arid maps
        if (_biome == "ARID" && _sunAlt > 30) then {
            _washout = linearConversion [30, 70, _sunAlt, 0, 0.4, true];
        };

        private _intensity = missionNamespace getVariable ["uksfta_environment_thermalIntensity", 1.0];
        _noise = ((_noise + _washout) * _intensity) min 1.0;

        if (_noise > 0.05) then {
            if (missionNamespace getVariable ["uksfta_environment_logLevel", 0] > 1) then {
                diag_log text (format ["[UKSF TASKFORCE ALPHA] <TRACE> [ENVIRONMENT]: Thermal Noise Applied: %1 (Washout: %2)", _noise, _washout]);
            };
            _ppColorC ppEffectEnable true;
            // Contrast is 1st param of ppEffectAdjust [brightness, contrast, ...]
            // We lower contrast as noise/washout increases
            _ppColorC ppEffectAdjust [1, 1 - (_noise * 0.6), 0, [0,0,0,0], [1,1,1,1], [0.3,0.3,0.3,0]];
            _ppColorC ppEffectCommit 0.5;

            _ppFilmG ppEffectEnable true;
            _ppFilmG ppEffectAdjust [_noise, 1.25, 2.0, 0.5, 1.0, true];
            _ppFilmG ppEffectCommit 0.5;
        } else {
            _ppColorC ppEffectEnable false;
            _ppFilmG ppEffectEnable false;
        };
    } else {
        _ppColorC ppEffectEnable false;
        _ppFilmG ppEffectEnable false;
    };

    sleep 1;
};

// Cleanup
ppEffectDestroy _ppColorC;
ppEffectDestroy _ppFilmG;
true
