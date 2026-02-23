#include "..\script_component.hpp"
/**
 * UKSFTA Cartography - Map Draw Handler
 * Manages the high-performance tactical overlays.
 */

params ["_mapCtrl"];

private _mode = missionNamespace getVariable ["UKSFTA_Cartography_Mode", "STANDARD"];

// Performance-optimized switch
// Mode toggles are handled via the CBA settings in preInit
switch (_mode) do {
    case "SATELLITE": {
        // High-Fidelity Satellite Layer
        // Using worldSize to correctly tile the entire map surface
        _mapCtrl drawIcon [
            "\A3\Map_Data\Data\Satellite_CA.paa",
            [1,1,1,1],
            [worldSize / 2, worldSize / 2, 0],
            worldSize,
            worldSize,
            0,
            "",
            0
        ];
    };
    case "TOPOGRAPHIC": {
        // High-Fidelity Topographic Layer (Contour focused)
        _mapCtrl drawIcon [
            "\A3\ui_f\data\map\mapcontrol\contour_ca.paa",
            [1,1,1,0.8],
            [worldSize / 2, worldSize / 2, 0],
            worldSize,
            worldSize,
            0,
            "",
            0
        ];
    };
    case "OS_HYBRID": {
        // UKSFTA Proprietary OS Hybrid Mode
        // Layering custom grids over topographic data
        _mapCtrl drawIcon [
            "\A3\Map_Data\Data\Satellite_CA.paa",
            [1,1,1,0.4],
            [worldSize / 2, worldSize / 2, 0],
            worldSize,
            worldSize,
            0,
            "",
            0
        ];
    };
    default {
        // Standard A3 View - No additional drawing required
    };
};

true
