/**
 * UKSFTA Environment - High-Fidelity Visual Engine
 * Refactored for universal technical compatibility.
 */

if (!hasInterface) exitWith {};

// Values: [BiomeName, [Brightness, Contrast, Desaturation, TintRGB, HazeColorRGB]]
private _visualProfiles = [
    ["TEMPERATE", [ 1, 1.05, 0.1, [1, 1, 0.9], [0.7, 0.7, 0.8] ]], 
    ["ARID",      [ 1.05, 1.1, 0.2, [1, 0.9, 0.8], [0.8, 0.7, 0.6] ]], 
    ["ARCTIC",    [ 1, 1.02, 0.0, [0.95, 0.95, 1], [0.9, 0.9, 1] ]], 
    ["TROPICAL",  [ 1, 1.08, 0.1, [0.9, 1, 0.9], [0.6, 0.8, 0.9] ]], 
    ["MEDITERRANEAN", [ 1.02, 1.05, 0.15, [1, 1, 0.85], [0.7, 0.75, 0.8] ]], 
    ["SUBTROPICAL", [ 1.03, 1.06, 0.1, [1, 0.95, 0.9], [0.75, 0.8, 0.85] ]]
];

waitUntil { time > 0 };

private _worldConfig = configFile >> "CfgWorlds" >> worldName;
private _nativeBaseAperture = getNumber (_worldConfig >> "HDRNewPars" >> "apertureStandard");
if (_nativeBaseAperture == 0) then { _nativeBaseAperture = 12.0; };

while {uksfta_environment_enabled} do {
    private _biome = call uksfta_environment_fnc_analyzeBiome;

    private _profile = [];
    { if (_x select 0 == _biome) exitWith { _profile = _x select 1; }; } forEach _visualProfiles;
    if (count _profile == 0) then { _profile = (_visualProfiles select 0) select 1; };
    
    _profile params ["_bright", "_contrast", "_desat", "_tint", "_haze"];

    private _sunAlt = sunElevation;
    private _isNight = _sunAlt < -10;
    private _moon = moonIntensity;
    
    private _nightBright = [0, 0.1 + (_moon * 0.15)] select (_isNight);
    private _finalBright = _bright + _nightBright;
    private _vIntensity = uksfta_environment_visualIntensity;
    private _overcastFactor = 1 - (overcast * 0.2);

    "ColorCorrections" ppEffectEnable true;
    "ColorCorrections" ppEffectAdjust [
        _finalBright, 
        _contrast * _vIntensity, 
        -0.005,
        [0, 0, 0, 0],
        [_tint select 0, _tint select 1, _tint select 2, _overcastFactor], 
        [0.299, 0.587, 0.114, 0],
        [-1, -1, 0, 0, 0, 0, 0]
    ];
    "ColorCorrections" ppEffectCommit 5;

    private _intensity = missionNamespace getVariable ["UKSFTA_Environment_CurrentIntensity", 0];
    [_biome, _intensity] call uksfta_environment_fnc_handleStorms;

    private _finalHaze = [_haze, [0.05, 0.05, 0.08]] select (_isNight);
    if (!isNil "setLighting") then {
        call compile format [
            "setLighting [
                'hazeColor', %1,
                'hazeBase', %2,
                'ambientIntensity', %3
            ]",
            _finalHaze,
            0.1 * overcast,
            1.0 + (_nightBright * 2.5)
        ];
    };

    private _grainIntensity = [0.015, 0.03] select (_isNight);
    "FilmGrain" ppEffectEnable true;
    "FilmGrain" ppEffectAdjust [_grainIntensity * _vIntensity, 1.25, 1, 0, 1];
    "FilmGrain" ppEffectCommit 5;

    private _targetAperture = [_nativeBaseAperture, _nativeBaseAperture * 0.8] select (overcast > 0.7);
    if (_isNight) then { _targetAperture = _nativeBaseAperture * 4; };
    setApertureNew [_targetAperture * 0.8, _targetAperture, _targetAperture * 1.5, 0.9];

    sleep 15; 
};
true
