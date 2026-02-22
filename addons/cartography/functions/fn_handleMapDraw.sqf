/**
 * UKSFTA Cartography - Optimized Map Draw Handler
 * Viewport-specific rendering with cached metadata for zero-lag.
 */

params ["_mapCtrl"];

private _mode = missionNamespace getVariable ["UKSFTA_Cartography_Mode", "STANDARD"];
if (_mode == "STANDARD") exitWith {};

// --- CACHED METADATA ---
private _worldSize = missionNamespace getVariable ["UKSFTA_Cartography_CachedSize", -1];
if (_worldSize == -1) then {
    _worldSize = getNumber (configFile >> "CfgWorlds" >> worldName >> "mapSize");
    if (_worldSize == 0) then { _worldSize = 10240; };
    missionNamespace setVariable ["UKSFTA_Cartography_CachedSize", _worldSize];
};

// --- CACHED TEXTURE CHECK ---
// We only check file existence once per mode change to save IO overhead
private _cacheKey = format ["UKSFTA_Carto_Tex_%1_%2", worldName, _mode];
private _texture = missionNamespace getVariable [_cacheKey, ""];

if (_texture == "") then {
    private _path = switch (_mode) do {
        case "SATELLITE":  { format ["z\uksfta\addons\maps\data\%1_sat_ca.paa", worldName] };
        case "TOPOGRAPHIC": { format ["z\uksfta\addons\maps\data\%1_topo_ca.paa", worldName] };
        case "OS_HYBRID":   { format ["z\uksfta\addons\maps\data\%1_os_ca.paa", worldName] };
        default { "" };
    };
    
    if (_path != "" && {fileExists _path}) then {
        _texture = _path;
        missionNamespace setVariable [_cacheKey, _texture];
    } else {
        missionNamespace setVariable [_cacheKey, "NONE"]; // Mark as missing to skip future checks
    };
};

// --- PERFORMANCE-OPTIMIZED DRAWING ---
if (_texture != "" && _texture != "NONE") then {
    private _alpha = [1.0, 0.9] select (_mode == "OS_HYBRID");
    _mapCtrl drawIcon [
        _texture,
        [1, 1, 1, _alpha],
        [_worldSize / 2, _worldSize / 2, 0],
        _worldSize,
        _worldSize,
        0,
        "",
        0
    ];
};

true
