/**
 * UKSFTA Environment - Ballistics Logic Audit (Phase 11)
 */

#include "mock_arma.sqf"

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🧪 UKSFTA BALLISTICS DENSITY AUDIT";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";

private _testDensity = {
    params ["_temp", "_alt"];
    private _tempK = _temp + 273.15;
    private _rhoRatio = (288.15 / _tempK) * (exp (-_alt / 8500));
    _rhoRatio
};

// 1. STP (Standard Temperature and Pressure) - 15C at Sea Level
private _stp = [15, 0] call _testDensity;
if (abs(_stp - 1.0) < 0.001) then {
    diag_log "  ✅ [DENSITY] STP (15C, 0m): PASS (Ratio ~1.0)";
} else {
    diag_log format ["  ❌ [DENSITY] STP (15C, 0m): FAIL (%1)", _stp];
};

// 2. High Altitude (2000m)
private _highAlt = [15, 2000] call _testDensity;
if (_highAlt < 0.8 && _highAlt > 0.7) then {
    diag_log format ["  ✅ [DENSITY] High Alt (2000m): PASS (Ratio ~%1)", _highAlt];
} else {
    diag_log format ["  ❌ [DENSITY] High Alt (2000m): FAIL (%1)", _highAlt];
};

// 3. Extreme Cold (Arctic -30C)
private _arctic = [-30, 0] call _testDensity;
if (_arctic > 1.1) then {
    diag_log format ["  ✅ [DENSITY] Arctic Cold (-30C): PASS (Ratio ~%1)", _arctic];
} else {
    diag_log format ["  ❌ [DENSITY] Arctic Cold (-30C): FAIL (%1)", _arctic];
};

// 4. Extreme Heat (Arid 50C)
private _arid = [50, 0] call _testDensity;
if (_arid < 0.9) then {
    diag_log format ["  ✅ [DENSITY] Arid Heat (50C): PASS (Ratio ~%1)", _arid];
} else {
    diag_log format ["  ❌ [DENSITY] Arid Heat (50C): FAIL (%1)", _arid];
};

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🏁 BALLISTICS AUDIT COMPLETE";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
true
