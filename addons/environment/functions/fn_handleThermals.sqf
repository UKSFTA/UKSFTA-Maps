#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Thermal Management (PP Stack)
 * Simulates atmospheric degradation of TI optics using standard PP effects.
 */

if (!hasInterface) exitWith {};

// --- ABSOLUTE STARTUP GUARD ---
waitUntil { !isNil "uksfta_environment_enabled" };

["INFO", "Thermal Management Hook Active.", "Environment"] call uksfta_environment_fnc_telemetry;

// Dedicated handles for UKSFTA Environmental TI
private _ppColorC = ppEffectCreate ["ColorCorrections", 1501];
private _ppFilmG = ppEffectCreate ["FilmGrain", 1502];

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    // Only apply while in Thermal view
    if (currentVisionMode player == 2 && {missionNamespace getVariable ["uksfta_environment_enableThermals", false]}) then {
        private _overcast = overcast;
        private _fog = fog;
        private _noise = 0;

        if (_overcast > 0.7) then { _noise = (_overcast - 0.7) * 0.5; };
        if (_fog > 0.3) then { _noise = _noise + (_fog * 0.5); };

        private _intensity = missionNamespace getVariable ["uksfta_environment_thermalIntensity", 1.0];
        _noise = (_noise * _intensity) min 1.0;

        if (_noise > 0.05) then {
            ["TRACE", format ["Thermal Noise Applied: %1", _noise], "Environment"] call uksfta_environment_fnc_telemetry;
            _ppColorC ppEffectEnable true;
            _ppColorC ppEffectAdjust [1, 1 - (_noise * 0.5), 0, [0,0,0,0], [1,1,1,1], [0.3,0.3,0.3,0]];
            _ppColorC ppEffectCommit 0.5;

            _ppFilmG ppEffectEnable true;
            _ppFilmG ppEffectAdjust [_noise, 1.25, 2.0, 0.5, 1.0, true];
            _ppFilmG ppEffectCommit 0.5;
        } else {
            _ppColorC ppEffectEnable false;
            _ppFilmG ppEffectEnable false;
        };
    } else {
        // Explicitly disable when not in TI to prevent "Flickering"
        _ppColorC ppEffectEnable false;
        _ppFilmG ppEffectEnable false;
    };

    sleep 1;
};

// Cleanup
ppEffectDestroy _ppColorC;
ppEffectDestroy _ppFilmG;
true
