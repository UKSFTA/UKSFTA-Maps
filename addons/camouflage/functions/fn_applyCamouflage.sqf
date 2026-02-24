#include "..\script_component.hpp"
/**
 * UKSFTA Camouflage - Sovereign Stealth Engine (Phase 8)
 * Pixel-perfect terrain sampling with dynamic accumulation balancing.
 * Inspiration: DYNCAS (ThomasAngel & johnb43)
 */

if (!hasInterface) exitWith {};

// Strict guard: Wait for settings to sync
waitUntil { !isNil "uksfta_camouflage_enabled" };

if (isNil "UKSFTA_Camo_TexCache") then {
    UKSFTA_Camo_TexCache = createHashMap;
};

private _lastPos = [0,0,0];
private _lastUniform = "";
private _lastTexture = "";
private _baseCamo = 1.0;

while {missionNamespace getVariable ["uksfta_camouflage_enabled", false]} do {
    private _unit = player;
    
    if (alive _unit && {isNull objectParent _unit}) then {
        private _currPos = getPosASL _unit;
        private _uniform = uniform _unit;
        private _groundTex = surfaceTexture _currPos;
        private _perfMode = missionNamespace getVariable ["uksfta_camouflage_perfMode", 1];
        private _highFid = missionNamespace getVariable ["uksfta_camouflage_highFidelity", true];
        private _checkDist = [5, 10, 25] select _perfMode;

        // 1. DYNAMIC SAMPLING (Optimized by distance and fidelity)
        if (_currPos distance _lastPos > _checkDist || _uniform != _lastUniform || _groundTex != _lastTexture) then {
            _lastPos = _currPos;
            _lastUniform = _uniform;
            _lastTexture = _groundTex;

            if (_highFid) then {
                private _playerTex = (getObjectTextures _unit) param [0, ""];
                
                if (_playerTex != "" && _groundTex != "") then {
                    // Get player texture average
                    private _playerAvg = UKSFTA_Camo_TexCache get _playerTex;
                    if (isNil "_playerAvg") then {
                        _playerAvg = (getTextureInfo _playerTex) # 2;
                        _playerAvg deleteAt 3; // Remove alpha
                        UKSFTA_Camo_TexCache set [_playerTex, _playerAvg];
                    };

                    // Get ground texture average
                    private _groundAvg = UKSFTA_Camo_TexCache get _groundTex;
                    if (isNil "_groundAvg") then {
                        _groundAvg = (getTextureInfo _groundTex) # 2;
                        _groundAvg deleteAt 3;
                        UKSFTA_Camo_TexCache set [_groundTex, _groundAvg];
                    };

                    // Calculate Color Similarity (Sinusoidal Model)
                    private _diffs = [];
                    for "_i" from 0 to 2 do {
                        private _p = _playerAvg # _i;
                        private _g = _groundAvg # _i;
                        _diffs pushBack (abs (_g - _p) / ([_p, _g] select (_p <= _g)));
                    };
                    
                    // Base result: 0.6 (perfect match) to 1.6 (poor match)
                    _baseCamo = 1.1 + sin (deg (pi * selectMax _diffs) - 89.95) / 2;
                } else {
                    _baseCamo = 1.0;
                };
            } else {
                // Low Fidelity Fallback: Use Biome Averages (Very fast)
                private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
                _baseCamo = switch (_biome) do {
                    case "ARCTIC": { [1.3, 0.7] select ((_uniform find "winter" != -1) || (_uniform find "snow" != -1)); };
                    case "ARID": { [1.2, 0.8] select ((_uniform find "arid" != -1) || (_uniform find "desert" != -1)); };
                    default { 1.0 };
                };
            };
        };

        // 2. ACCUMULATION BALANCING (Real-time update)
        // If you are covered in mud on a muddy surface, you are harder to see.
        private _mud = _unit getVariable ["UKSFTA_Accum_Mud", 0];
        private _snow = _unit getVariable ["UKSFTA_Accum_Snow", 0];
        private _surface = toLower (surfaceType (getPos _unit));
        
        private _accumBonus = 0;
        if (_mud > 0.2 && (_surface find "mud" != -1 || _surface find "dirt" != -1)) then {
            _accumBonus = _accumBonus + (_mud * 0.25); // Up to 25% reduction
        };
        if (_snow > 0.2 && (_surface find "snow" != -1)) then {
            _accumBonus = _accumBonus + (_snow * 0.3); // Up to 30% reduction
        };

        // 3. ENVIRONMENTAL FACTORS
        private _fog = fog;
        private _rain = rain;
        private _light = getLightingAt _unit;
        private _brightness = (_light select 1) + (_light select 3); // Ambient + Dynamic
        
        private _envCoef = 1.0;
        if (_fog > 0.1) then { _envCoef = _envCoef * (1 - (linearConversion [0.1, 1.0, _fog, 0, 0.3, true])); };
        if (_rain > 0.5) then { _envCoef = _envCoef * 0.85; }; // Visual distortion from heavy rain
        
        // Night compensation (Lower visibility in the dark)
        if (_brightness < 100) then {
            _envCoef = _envCoef * 0.6;
        };

        // 4. STANCE & NOISE
        private _stanceCoef = 1.0;
        if (stance _unit == "PRONE") then { _stanceCoef = 0.7; };
        if (stance _unit == "CROUCH") then { _stanceCoef = 0.85; };

        // 5. FINAL CALCULATION
        private _intensity = missionNamespace getVariable ["uksfta_camouflage_intensity", 1.0];
        private _finalCam = ((_baseCamo - _accumBonus) * _envCoef * _stanceCoef) / _intensity;
        
        // Floor to prevent absolute invisibility unless ghillie + perfect setup
        _finalCam = _finalCam max 0.05;

        _unit setUnitTrait ["camouflageCoef", _finalCam];
        
        // Audible balancing
        private _audCoef = 1.0;
        if (_surface find "stony" != -1 || _surface find "gravel" != -1) then { _audCoef = 1.3; };
        if (_snow > 0.5) then { _audCoef = 0.7; }; // Soft snow muffles steps
        
        _unit setUnitTrait ["audibleCoef", (_audCoef * _intensity)];

        // Lambs/VCOM sync
        if (missionNamespace getVariable ["uksfta_camouflage_aiCompat", true]) then {
            _unit setVariable ["lambs_danger_camouflageModifier", _finalCam, true];
        };
    };

    sleep 5;
};

// Cleanup
player setUnitTrait ["camouflageCoef", 1.0];
player setUnitTrait ["audibleCoef", 1.0];
true
