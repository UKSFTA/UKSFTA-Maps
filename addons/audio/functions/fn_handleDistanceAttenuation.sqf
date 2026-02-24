#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Distance Attenuation Engine (Phase 16 Extension)
 * Simulates high-frequency air absorption for distant audio.
 */

params ["_sourcePos", "_volume", "_range"];

private _dist = player distance _sourcePos;
if (_dist < 300) exitWith { _volume }; // No attenuation for close sounds

// Frequency absorption logic
// Beyond 300m, we scale volume down and simulate muffling via lower volume 
// (Arma doesn't have a direct dynamic low-pass filter for playSound3D yet,
// so we compensate by reducing volume more aggressively at high ranges).
private _attenuationFactor = linearConversion [300, _range, _dist, 1.0, 0.2, true];

(_volume * _attenuationFactor)
