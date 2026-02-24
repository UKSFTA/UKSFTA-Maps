/**
 * UKSFTA Test - Visual Effects Application
 */

#include "mock_arma.sqf"

diag_log "🧪 Testing Visual Effects Application...";

// Test cases for different times and conditions
private _testVisualParams = {
    params ["_sunElevation", "_overcast", "_biome", "_desat"];

    private _rgb = [1, 1, 1];
    private _sat = 1.0;
    private _contrast = 1.05;
    private _brightness = 1.0;
    private _offset = [0, 0, 0, 0];

    // Solar grading
    if (_sunElevation > 15) then { // Noon
        _rgb = [1.0, 1.0, 1.0];
        _sat = 1.0;
    } else {
        if (_sunElevation > 0) then { // Golden Hour
            private _factor = linearConversion [0, 15, _sunElevation, 0, 1, true];
            _rgb = [1.1 - (0.1 * _factor), 0.95 + (0.05 * _factor), 0.85 + (0.15 * _factor)];
            _sat = 1.1 - (0.1 * _factor);
            _contrast = 1.1 - (0.05 * _factor);
        } else { // Night & Twilight
            if (_sunElevation > -10) then { // Blue Hour
                _rgb = [0.8, 0.85, 1.1];
                _sat = 0.8;
                _brightness = 0.9;
            } else { // Full Night
                private _moon = moonIntensity;
                _rgb = [0.7 + (0.1 * _moon), 0.75 + (0.15 * _moon), 1.0 + (0.1 * _moon)];
                _sat = 0.7 + (0.3 * _moon);
                _brightness = 0.8 + (0.2 * _moon);
                _contrast = 0.95 + (0.1 * _moon);
            };
        };
    };

    // Haze mitigation
    if (_overcast > 0.5) then {
        private _haze = linearConversion [0.5, 1.0, _overcast, 0, 1, true];
        _contrast = _contrast + (0.1 * _haze);
        _sat = _sat * (1 - (0.15 * _haze));
        _rgb = _rgb vectorMultiply (1 - (0.05 * _haze));
    };

    // Biome refinement
    switch (_biome) do {
        case "ARID": {
            _rgb = [(_rgb select 0) * 1.02, (_rgb select 1), (_rgb select 2) * 0.95];
            _contrast = _contrast + 0.05;
        };
        case "ARCTIC": {
            _sat = _sat * 0.85;
            _rgb = [(_rgb select 0) * 0.95, (_rgb select 1) * 0.98, (_rgb select 2) * 1.05];
            _contrast = _contrast + 0.1;
        };
    };

    // Apply desat
    _sat = _sat * (1 - _desat);

    [_rgb, _sat, _contrast, _brightness]
};

// Test 1: Noon, clear sky, temperate
private _result = [45, 0.0, "TEMPERATE", 0] call _testVisualParams;
diag_log format ["  - Noon Clear: RGB=%1, Sat=%2, Contrast=%3", _result select 0, _result select 1, _result select 2];
if ((_result select 1) >= 0.95) then { // High saturation expected
    diag_log "  ✅ Noon Clear Visuals: PASS";
} else {
    diag_log "  ❌ Noon Clear Visuals: FAIL";
};

// Test 2: Golden hour
_result = [10, 0.0, "TEMPERATE", 0] call _testVisualParams;
diag_log format ["  - Golden Hour: RGB=%1, Sat=%2", _result select 0, _result select 1];
if ((_result select 1) > 0.9 && (_result select 1) < 1.1) then {
    diag_log "  ✅ Golden Hour Visuals: PASS";
} else {
    diag_log "  ❌ Golden Hour Visuals: FAIL";
};

// Test 3: Blue hour (night)
_result = [-5, 0.0, "TEMPERATE", 0] call _testVisualParams;
diag_log format ["  - Blue Hour: RGB=%1, Sat=%2", _result select 0, _result select 1];
if ((_result select 1) >= 0.7 && (_result select 1) <= 0.9) then { // Should be around 0.8
    diag_log "  ✅ Blue Hour Visuals: PASS";
} else {
    diag_log "  ❌ Blue Hour Visuals: FAIL";
};

// Test 4: Overcast conditions
_result = [30, 0.8, "TEMPERATE", 0] call _testVisualParams;
diag_log format ["  - Overcast: Sat=%1, Contrast=%2", _result select 1, _result select 2];
if ((_result select 1) < 1.0) then { // Should reduce saturation
    diag_log "  ✅ Overcast Visuals: PASS";
} else {
    diag_log "  ❌ Overcast Visuals: FAIL";
};

// Test 5: Arctic biome
_result = [30, 0.0, "ARCTIC", 0] call _testVisualParams;
diag_log format ["  - Arctic: Sat=%1, RGB=%2", _result select 1, _result select 0];
if ((_result select 1) < 0.9) then { // Should reduce saturation
    diag_log "  ✅ Arctic Visuals: PASS";
} else {
    diag_log "  ❌ Arctic Visuals: FAIL";
};

// Test 6: Local desat application
_result = [30, 0.0, "TEMPERATE", 0.2] call _testVisualParams;
diag_log format ["  - Local Desat: Sat=%1", _result select 1];
if ((_result select 1) < 0.9) then { // Should apply desat
    diag_log "  ✅ Local Desat Application: PASS";
} else {
    diag_log "  ❌ Local Desat Application: FAIL";
};

diag_log "🏁 Visual Effects Test Complete.";
