diag_log "🧪 INITIATING SOVEREIGN VFS DISCOVERY AUDIT (RELATIVE)...";

private _manifest = [
    // --- CARTOGRAPHY ---
    "z/uksfta/addons/cartography/functions/fn_preInit.sqf",
    "z/uksfta/addons/cartography/functions/fn_initCartography.sqf",
    "z/uksfta/addons/cartography/functions/fn_handleMapDraw.sqf",
    "z/uksfta/addons/cartography/functions/fn_toggleMode.sqf",
    
    // --- ENVIRONMENT ---
    "z/uksfta/addons/environment/functions/fn_preInit.sqf",
    "z/uksfta/addons/environment/functions/fn_initEnvironment.sqf",
    "z/uksfta/addons/environment/functions/fn_weatherCycle.sqf",
    "z/uksfta/addons/environment/functions/fn_analyzeBiome.sqf",
    "z/uksfta/addons/environment/functions/fn_getSunElevation.sqf",
    "z/uksfta/addons/environment/functions/fn_handleThermals.sqf",
    
    // --- CAMOUFLAGE ---
    "z/uksfta/addons/camouflage/functions/fn_preInit.sqf",
    "z/uksfta/addons/camouflage/functions/fn_init.sqf",
    "z/uksfta/addons/camouflage/functions/fn_applyCamouflage.sqf"
];

private _found = 0;
private _missing = 0;

{
    private _path = _x;
    private _content = preprocessFile _path;
    
    if (_content != "") then {
        diag_log format ["  ✅ DISCOVERED: %1", _path];
        _found = _found + 1;
    } else {
        diag_log format ["  ❌ NOT FOUND: %1", _path];
        _missing = _missing + 1;
    };
} forEach _manifest;

if (_missing == 0) then {
    diag_log format ["✅ VFS AUDIT COMPLETE: %1/13 scripts verified accessible.", _found];
} else {
    diag_log format ["❌ VFS AUDIT FAILED: %1 scripts missing from virtual mapping.", _missing];
};
