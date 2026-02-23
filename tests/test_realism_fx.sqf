/**
 * UKSFTA Realism - FX Logic Validation
 */

private _results = [];

// 1. Validate Rain Particle Intervals
private _testRain = {
    params ["_rain"];
    linearConversion [0.1, 1, _rain, 0.008, 0.002, true];
};

private _lowRain = 0.1 call _testRain;
private _highRain = 1.0 call _testRain;

if (_lowRain == 0.008 && _highRain == 0.002) then {
    _results pushBack ["RAIN_INTERVALS", "PASSED"];
} else {
    _results pushBack ["RAIN_INTERVALS", "FAILED"];
};

// 2. Validate Visual Noise (Grain) Logic
private _testGrain = {
    params ["_sun", "_rain"];
    private _intensity = 0;
    if (_sun < 0.1) then {
        _intensity = [0.08, 0.15] select (_rain > 0.4);
    } else {
        if (_rain > 0.2) then {
            _intensity = linearConversion [0.2, 1, _rain, 0.02, 0.12, true];
        };
    };
    _intensity
};

private _nightClear = [0.05, 0] call _testGrain; // Should be 0.08
private _nightStorm = [0.05, 0.5] call _testGrain; // Should be 0.15
private _dayStorm = [1.0, 0.6] call _testGrain; // Mid-desaturation

if (_nightClear == 0.08 && _nightStorm == 0.15 && _dayStorm > 0.05) then {
    _results pushBack ["GRAIN_LOGIC", "PASSED"];
} else {
    _results pushBack ["GRAIN_LOGIC", "FAILED"];
};

_results
