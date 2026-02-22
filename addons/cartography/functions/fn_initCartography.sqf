/**
 * UKSFTA Cartography - Master Init
 * Attaches the high-performance render hook to the map display.
 */

params ["_display"];

if (!hasInterface) exitWith {};

// IDD 12 is the main mission map
// We find the primary map control (IDC 51)
private _mapCtrl = _display displayCtrl 51;

if (!isNull _mapCtrl) then {
    // Add the native render hook
    _mapCtrl ctrlAddEventHandler ["Draw", {
        _this call uksfta_cartography_fnc_handleMapDraw;
    }];
    
    if (missionNamespace getVariable ["uksfta_environment_debug", false]) then { 
        systemChat "[UKSFTA-MAPS] Native Render Hook Active"; 
    };
};

true
