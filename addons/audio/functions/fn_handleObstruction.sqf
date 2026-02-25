#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Acoustic Obstruction Engine (Optimized)
 * Features Distance-Based Culling and Spatial Caching.
 */

params ["_sourcePos", "_baseVolume"];

// 1. DISTANCE CULLING (LoD)
private _dist = player distance _sourcePos;
if (_dist < 5) exitWith { _baseVolume }; // Direct sound
if (_dist > 150) exitWith { _baseVolume * 0.8 }; // Static distant muffle (Bypass expensive LOS)

// 2. SPATIAL CACHING
// We only re-calculate obstruction if player has moved significant distance (>1m)
private _lastCheckPos = player getVariable ["UKSFTA_Audio_LastInterroPos", [0,0,0]];
private _lastVis = player getVariable ["UKSFTA_Audio_LastVisValue", 1.0];

private _visibility = _lastVis;
if (player distance _lastCheckPos > 1) then {
    _visibility = [player, "VIEW", objNull] checkVisibility [eyePos player, _sourcePos];
    player setVariable ["UKSFTA_Audio_LastInterroPos", getPosVisual player];
    player setVariable ["UKSFTA_Audio_LastVisValue", _visibility];
};

if (_visibility < 0.5) then {
    // Sound is obstructed
    _baseVolume = _baseVolume * 0.6;
};

_baseVolume
