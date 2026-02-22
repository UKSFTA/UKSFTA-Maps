/**
 * UKSFTA Environment - Visual Engine
 */

if (!hasInterface) exitWith {};

private _cfg = missionNamespace getVariable ["UKSFTA_Environment_CurrentIntensity", 0];
private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];

private _intensity = _cfg;
private _visuals = [
    ["TEMPERATE",     [[1, 1, 1], [0.05, 0.05, 0.05], [0.1, 0.1, 0.15]]],
    ["ARID",          [[1.1, 1.0, 0.9], [0.1, 0.05, 0.02], [0.2, 0.15, 0.1]]],
    ["ARCTIC",        [[0.9, 1.0, 1.1], [0.02, 0.05, 0.1], [0.05, 0.05, 0.08]]],
    ["TROPICAL",      [[1.0, 1.1, 0.9], [0.05, 0.1, 0.05], [0.1, 0.15, 0.1]]],
    ["MEDITERRANEAN", [[1.05, 1.0, 0.95], [0.08, 0.05, 0.02], [0.15, 0.1, 0.05]]],
    ["SUBTROPICAL",   [[1.0, 1.05, 1.0], [0.05, 0.08, 0.05], [0.1, 0.1, 0.1]]]
];

private _profile = [];
{ if (_x select 0 == _biome) exitWith { _profile = _x select 1; }; } forEach _visuals;
if (count _profile == 0) then { _profile = (_visuals select 0) select 1; };

_profile params ["_tint", "_haze", "_fogColor"];

// --- SUN CALCULATION ---
private _sunAlt = sunElevation; // Correct engine command
private _isNight = (_sunAlt < -5);

// Apply PP Intensity from settings
private _masterIntensity = uksfta_environment_visualIntensity;

// 1. Color Correction
"ColorCorrection" ppEffectEnable true;
"ColorCorrection" ppEffectAdjust [
    1, 
    1 + (_intensity * 0.2 * _masterIntensity), 
    0, 
    [0, 0, 0, 0], 
    [(_tint select 0), (_tint select 1), (_tint select 2), 1], 
    [1, 1, 1, 0]
];
"ColorCorrection" ppEffectCommit 5;

// 2. Film Grain (Stormy/Night effect)
"FilmGrain" ppEffectEnable true;
private _grain = [0, 0.15] select (_intensity > 0.7 || _isNight);
"FilmGrain" ppEffectAdjust [_grain * _masterIntensity, 1, 1, 0, 1];
"FilmGrain" ppEffectCommit 5;

// 3. Volumetric Haze (Biome Specific)
// Note: setHorizonTint was invalid. We rely on ColorCorrection for global tint.
// We can use setFog to simulate local density if needed.

// 4. Storm Logic Hook
[_biome, _intensity] call uksfta_environment_fnc_handleStorms;

true
