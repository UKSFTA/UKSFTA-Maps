/**
 * UKSFTA Advanced Test - Instruction Profiling (Fidelity Edition)
 */

#include "mock_arma.sqf"

private _modes = ["STANDARD", "SATELLITE", "TOPOGRAPHIC", "OS_HYBRID"];
diag_log "📊 INITIATING INSTRUCTION PROFILE: CARTOGRAPHY DRAW";

// Physically compile the production logic
private _fnc = compile preprocessFile "/ext/Development/UKSFTA-Maps/addons/cartography/functions/fn_handleMapDraw.sqf";

{
    private _mode = _x;
    missionNamespace setVariable ["UKSFTA_Cartography_Mode", _mode];
    
    diag_log format ["  🔍 Profiling Mode: %1", _mode];
    [objNull] call _fnc;
} forEach _modes;

diag_log "✅ PROFILE COMPLETE.";
true;
