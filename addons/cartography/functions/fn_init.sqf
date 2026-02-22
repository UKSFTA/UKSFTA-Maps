/**
 * UKSFTA Cartography - Master Init
 */

if (!hasInterface) exitWith {};

// --- MAP EVENT HOOK ---
// We hook into the main map display (IDD 12) whenever it opens
["osm_map_opened", {
    params ["_mapDisplay"];
    
    private _mapCtrl = _mapDisplay displayCtrl 51;
    
    // Add our custom Draw handler
    _mapCtrl ctrlAddEventHandler ["Draw", {
        _this call uksfta_cartography_fnc_handleMapDraw;
    }];
}] call CBA_fnc_addEventHandler;

// Wait for map display specifically
[] spawn {
    while {true} do {
        waitUntil { visibleMap };
        private _display = findDisplay 12;
        if (!isNull _display) then {
            ["osm_map_opened", [_display]] call CBA_fnc_localEvent;
        };
        waitUntil { !visibleMap };
        sleep 0.5;
    };
};

true
