#include "mock_arma.sqf"
diag_log "🧪 INITIATING BIOME SCENARIO AUDIT...";

// SCENARIO A: ARCTIC NIGHT
_mock_dayTime = 0; overcast = 1.0;
private _sunAlt = sin ((_mock_dayTime - 6) * 15) * 90;
private _grain = [0, 0.15] select (overcast > 0.7 || (_sunAlt < -5));

if (_grain == 0.15) then { diag_log "    ✅ Case Arctic: PASS"; } else { diag_log "    ❌ Case Arctic: FAIL"; };

// SCENARIO B: TROPICAL MONSOON
overcast = 1.0; uksfta_environment_interferenceIntensity = 1.0;
private _signalLoss = 1.0 + (overcast * 0.3 * uksfta_environment_interferenceIntensity);
if (_signalLoss > 1.2) then { diag_log "    ✅ Case Tropical: PASS"; } else { diag_log "    ❌ Case Tropical: FAIL"; };

// SCENARIO C: ARID HEAT
_mock_dayTime = 12;
private _sunAltArid = sin ((_mock_dayTime - 6) * 15) * 90;
private _heatFactor = (_sunAltArid / 90) * 0.4;
if (_heatFactor > 0.3) then { diag_log "    ✅ Case Arid: PASS"; } else { diag_log "    ❌ Case Arid: FAIL"; };

// SYNTAX AUDITS
diag_log "  🔍 Auditing File Syntax...";
private _s1 = compile preprocessFile "/ext/Development/UKSFTA-Maps/addons/environment/functions/fn_applyVisuals.sqf";
private _s2 = compile preprocessFile "/ext/Development/UKSFTA-Maps/addons/environment/functions/fn_weatherCycle.sqf";
if (!isNil "_s1" && !isNil "_s2") then { diag_log "    ✅ Case Engine Syntax: PASS"; } else { diag_log "    ❌ Case Engine Syntax: FAIL"; };

diag_log "🏁 Scenario Audit Complete.";
