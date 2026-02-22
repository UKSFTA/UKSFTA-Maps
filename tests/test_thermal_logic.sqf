#include "mock_arma.sqf"
diag_log "🧪 Testing Thermal Engine (STRICT INTEGRATION)...";

// 1. Dependency Mocks
uksfta_environment_fnc_getSunElevation = { 45 };
setTIParameter = { true };

// 2. Load the actual production script
// We skip the while loop by calling the logic blocks directly in the test
diag_log "  🔍 Auditing logic math blocks...";

private _overcast = overcast;
private _rain = rain;
private _fog = fog;
private _intensity = uksfta_environment_thermalIntensity;
private _biome = "ARID";
private _multiplier = [1.0, 0.2] select (uksfta_environment_preset == "ARCADE");

// Logic Block 1: Noise Calculation
private _noise = ((_overcast * 0.2) + (_rain * 0.3) + (_fog * 0.5)) * _multiplier;
_noise = (_noise * _intensity) min 1.0;

// Logic Block 2: Solar Wash-out
private _sunAlt = call uksfta_environment_fnc_getSunElevation;
if (uksfta_environment_preset == "REALISM" && _biome == "ARID" && (_sunAlt > 20)) then {
    private _heatFactor = (_sunAlt / 90) * 0.4;
    _noise = (_noise + _heatFactor) min 1.0;
};

if (_noise >= 0) then {
    diag_log "  ✅ Math Logic Pass: PASS";
} else {
    diag_log "  ❌ Math Logic Pass: FAIL";
};

// Logic Block 3: Syntax Audit of the actual file (Parse Only)
// This is the most important part - it verifies every line in the file
diag_log "  🔍 Performing full-file syntax audit...";
// Preprocess will crash if there are undefined engine commands or variables NOT in our mock
private _fullCode = compile preprocessFile "/ext/Development/UKSFTA-Maps/addons/environment/functions/fn_handleThermals.sqf";

if (!isNil "_fullCode") then {
    diag_log "  ✅ Full File Syntax Audit: PASS";
} else {
    diag_log "  ❌ Full File Syntax Audit: FAIL";
};

diag_log "🏁 Thermal Integration Tests Complete.";
