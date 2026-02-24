#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Initialize Accumulation UI (Phase 8)
 * Called by the 'ui' procedural texture system.
 */

params ["_display", "_name"];

if (isNil "UKSFTA_Accum_DisplayMap") then {
    UKSFTA_Accum_DisplayMap = createHashMap;
};

UKSFTA_Accum_DisplayMap set [_name, _display];

private _nameParts = _name splitString ":";
if (count _nameParts < 2) exitWith {};

private _baseTexture = _nameParts select 1;

private _ctrlBase = _display displayCtrl 100;
_ctrlBase ctrlSetText _baseTexture;

// Ensure all overlays are initialized
{
    private _ctrl = _display displayCtrl _x;
    _ctrl ctrlSetFade 1;
    _ctrl ctrlCommit 0;
} forEach [101, 102, 103, 104, 105, 106];

displayUpdate _display;
