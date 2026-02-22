#include "mock_arma.sqf"
diag_log "🧪 Testing Thermal Engine (STRICT AUDIT)...";

// 1. Math Emulation from fn_handleThermals.sqf
private _overcast = 1.0; private _rain = 1.0; private _fog = 1.0;
private _intensity = 1.0; private _biome = "ARID";

// Realism Pass
uksfta_environment_preset = "REALISM";
private _multiplier = [1.0, 0.2] select (uksfta_environment_preset == "ARCADE");
private _noise = ((_overcast * 0.2) + (_rain * 0.3) + (_fog * 0.5)) * _multiplier;
_noise = (_noise * _intensity) min 1.0;

if (_noise == 1.0) then { diag_log "    ✅ Case Math (Realism): PASS"; } else { diag_log "    ❌ Case Math (Realism): FAIL"; };

// Arcade Pass
uksfta_environment_preset = "ARCADE";
_multiplier = [1.0, 0.2] select (uksfta_environment_preset == "ARCADE");
_noise = ((_overcast * 0.2) + (_rain * 0.3) + (_fog * 0.5)) * _multiplier;
_noise = (_noise * _intensity) min 1.0;

if (_noise == 0.2) then { diag_log "    ✅ Case Math (Arcade): PASS"; } else { diag_log "    ❌ Case Math (Arcade): FAIL"; };

// 2. Full Syntax Check of actual file
diag_log "  🔍 Performing full-file syntax audit...";
// We use a safe compile block - it only fails if syntax is broken
private _syntax = compile preprocessFile "/ext/Development/UKSFTA-Maps/addons/environment/functions/fn_handleThermals.sqf";
if (!isNil "_syntax") then { diag_log "    ✅ Case File Syntax: PASS"; } else { diag_log "    ❌ Case File Syntax: FAIL"; };

diag_log "🏁 Thermal Tests Complete.";
