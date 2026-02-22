/**
 * UKSFTA Cartography - Master Init
 */

if (!hasInterface) exitWith {};

// --- DISPLAY HANDLER REGISTRATION ---
// IDD 12 is the main map display
["scripted_map_draw", "onLoad", {
    params ["_display"];
    private _mapCtrl = _display displayCtrl 51;
    
    // Add the render hook
    _mapCtrl ctrlAddEventHandler ["Draw", {
        _this call uksfta_cartography_fnc_handleMapDraw;
    }];
    
    if (uksfta_environment_debug) then { systemChat "[UKSFTA-MAPS] Render Hook Active"; };
}, 12] call CBA_fnc_addDisplayHandler;

true
