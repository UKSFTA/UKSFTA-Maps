#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Dynamic Visual Noise (FilmGrain)
 * Inspiration: RW_Effects (Malcain)
 * Implements grit and sensor-noise during low light / heavy rain.
 */

if (!hasInterface) exitWith {};

[] spawn {
    waitUntil { !isNull player };
    
    // Using 1502 to avoid collision with standard unit thermal/lightning handles (1504)
    private _ppGrain = ppEffectCreate ["FilmGrain", 1502];
    private _lastIntensity = -1;

    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _rain = rain;
        private _sun = sunOrMoon;
        private _intensity = 0;
        private _size = 0.5;

        // Base grain logic - Refactored for linter compliance
        if (_sun < 0.1) then { // Night
            _intensity = [0.08, 0.15] select (_rain > 0.4);
            _size = [0.8, 1.5] select (_rain > 0.4);
        } else { // Day
            if (_rain > 0.2) then {
                _intensity = linearConversion [0.2, 1, _rain, 0.02, 0.12, true];
                _size = 1.2;
            };
        };

        // Only commit if change is significant to save cycles
        if (abs(_intensity - _lastIntensity) > 0.01) then {
            if (_intensity > 0) then {
                _ppGrain ppEffectEnable true;
                _ppGrain ppEffectAdjust [_intensity, _size, 1, 0.1, 0.1, true];
                _ppGrain ppEffectCommit 10;
            } else {
                _ppGrain ppEffectEnable false;
            };
            _lastIntensity = _intensity;
        };

        sleep 10;
    };
    
    if (!isNil "_ppGrain") then { ppEffectDestroy _ppGrain; };
};

true
