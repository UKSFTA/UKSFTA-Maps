/**
 * UKSFTA Cartography - Optimized Map Draw Handler
 * Viewport-specific rendering for maximum performance.
 */

params ["_mapCtrl"];

private _mode = missionNamespace getVariable ["UKSFTA_Cartography_Mode", "STANDARD"];
if (_mode == "STANDARD") exitWith {};

// --- MAP METADATA ---
private _worldSize = getNumber (configFile >> "CfgWorlds" >> worldName >> "mapSize");
if (_worldSize == 0) then { _worldSize = 10240; };

private _texture = "";
private _alpha = 1.0;

switch (_mode) do {
    case "SATELLITE": {
        _texture = format ["z\uksfta\addons\maps\data\%1_sat_ca.paa", worldName];
    };
    case "TOPOGRAPHIC": {
        _texture = format ["z\uksfta\addons\maps\data\%1_topo_ca.paa", worldName];
    };
    case "OS_HYBRID": {
        // High-fidelity OS Style (Hybrid mix)
        _texture = format ["z\uksfta\addons\maps\data\%1_os_ca.paa", worldName];
        _alpha = 0.9;
    };
};

// --- PERFORMANCE-OPTIMIZED DRAWING ---
// Only draw if the texture exists
if (_texture != "" && {fileExists _texture}) then {
    
    // We utilize the native Arma 3 scaling. 
    // drawIcon is highly optimized for this.
    // By providing the map center and world size, the engine handles the clipping.
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
