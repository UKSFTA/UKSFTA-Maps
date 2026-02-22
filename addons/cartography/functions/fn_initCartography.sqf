/**
 * UKSFTA Cartography - Master Init
 */

if (!hasInterface) exitWith {};

// --- DISPLAY HANDLER REGISTRATION ---
// IDD 12 is the main map display
// Correct CBA Signature: [IDD, EVENT, CODE]
[12, "onLoad", {
    params ["_display"];
    private _mapCtrl = _display displayCtrl 51;
    
    // Add the render hook
    _mapCtrl ctrlAddEventHandler ["Draw", {
        _this call uksfta_cartography_fnc_handleMapDraw;
    }];
    
    if (missionNamespace getVariable ["uksfta_environment_debug", false]) then { 
        systemChat "[UKSFTA-MAPS] Render Hook Active"; 
    };
}] call CBA_fnc_addDisplayHandler;

true
