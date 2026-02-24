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

// Randomize textures for variety
private _splatTex = selectRandom [
    "z\uksfta\addons\environment\data\blood_splat_1.paa",
    "z\uksfta\addons\environment\data\blood_splat_2.paa",
    "z\uksfta\addons\environment\data\blood_splat_3.paa",
    "z\uksfta\addons\environment\data\blood_splat_4.paa",
    "z\uksfta\addons\environment\data\blood_splat_5.paa"
];
( _display displayCtrl 107 ) ctrlSetText _splatTex;

private _burnTex = selectRandom [
    "z\uksfta\addons\environment\data\burn_char_1.paa",
    "z\uksfta\addons\environment\data\burn_char_2.paa"
];
( _display displayCtrl 105 ) ctrlSetText _burnTex;

// Ensure all overlays are initialized and randomize rotation
{
    private _ctrl = _display displayCtrl _x;
    _ctrl ctrlSetFade 1;
    _ctrl ctrlSetAngle [random 360, 0.5, 0.5];
    _ctrl ctrlCommit 0;
} forEach [101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111];

displayUpdate _display;
