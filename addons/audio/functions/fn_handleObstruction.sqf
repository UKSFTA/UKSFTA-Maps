#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Acoustic Obstruction Engine (Phase 19)
 * Simulates sound muffling when a source is behind a wall or object.
 */

params ["_sourcePos", "_baseVolume"];

private _dist = player distance _sourcePos;
if (_dist < 5) exitWith { _baseVolume }; // No obstruction for point-blank sounds

// Check line-of-sight visibility to sound source
// 1.0 = clear, 0.0 = fully blocked
private _visibility = [player, "VIEW", objNull] checkVisibility [eyePos player, _sourcePos];

if (_visibility < 0.5) then {
    // Sound is obstructed
    // We reduce volume by 40% and shift pitch slightly lower to simulate low-pass
    private _muffleFactor = 0.6;
    _baseVolume = _baseVolume * _muffleFactor;
};

_baseVolume
