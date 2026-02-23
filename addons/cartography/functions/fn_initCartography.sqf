#include "..\script_component.hpp"
/**
 * UKSFTA Cartography - Master Init
 * Attaches the high-performance render hook to the map display.
 */

params ["_display"];

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [CARTOGRAPHY]: Master Initialization Sequence Starting...";

// IDD 12 is the main mission map
// We find the primary map control (IDC 51)
private _mapCtrl = _display displayCtrl 51;

if (!isNull _mapCtrl) then {
    if (missionNamespace getVariable ["uksfta_environment_logLevel", 0] > 1) then {
        diag_log text "[UKSF TASKFORCE ALPHA] <TRACE> [CARTOGRAPHY]: Target Map Control (IDC 51) Located. Attaching Render Hook...";
    };
    
    // Add the native render hook
    _mapCtrl ctrlAddEventHandler ["Draw", {
        _this call uksfta_cartography_fnc_handleMapDraw;
    }];
    
    diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [CARTOGRAPHY]: Native Render Hook Active.";
};

true
