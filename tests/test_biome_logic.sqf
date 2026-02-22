#include "mock_arma.sqf"
diag_log "🧪 Testing Biome Heuristics...";

// Use the virtual path established in the runner
private _fn = "/ext/Development/UKSFTA-Maps/addons/environment/functions/fnc_analyzeBiome.sqf";

// Test Case 1: Altis (Mediterranean)
worldName = "altis";
private _result = call compile preprocessFileLineNumbers _fn;
if (_result == "MEDITERRANEAN") then { diag_log "  ✅ Case Altis: PASS"; } else { diag_log "  ❌ Case Altis: FAIL"; };

// Test Case 2: Mission Override
missionNamespace setVariable ["UKSFTA_Environment_MissionBiome", "ARCTIC"];
_result = call compile preprocessFileLineNumbers _fn;
if (_result == "ARCTIC") then { diag_log "  ✅ Case Override: PASS"; } else { diag_log "  ❌ Case Override: FAIL"; };

diag_log "🏁 Biome Tests Complete.";
