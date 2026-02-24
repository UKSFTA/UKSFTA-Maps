#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Accumulation Engine (Phase 7)
 * Performance-optimized UI2Texture layering for dynamic unit visuals.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Accumulation Engine Starting...";

if (isNil "UKSFTA_Accum_DisplayMap") then {
    UKSFTA_Accum_DisplayMap = createHashMap;
};

while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    if !(missionNamespace getVariable ["uksfta_environment_enableAccumulation", true]) exitWith {};

    private _units = allUnits select { _x distance player < 50 && {alive _x} };
    private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
    private _globalRate = missionNamespace getVariable ["uksfta_environment_accumulationRate", 1.0];
    private _perfMode = missionNamespace getVariable ["uksfta_environment_perfMode", 1];
    
    // Performance derived values
    private _texRes = 512;
    private _sleepTime = 5;

    switch (_perfMode) do {
        case 0: { _texRes = 1024; _sleepTime = 2; };
        case 1: { _texRes = 512; _sleepTime = 5; };
        case 2: { _texRes = 128; _sleepTime = 10; };
        case 3: { 
            // Auto-detect based on FPS
            private _fps = diag_fps;
            if (_fps > 50) then { _texRes = 1024; _sleepTime = 3; } else {
                if (_fps > 25) then { _texRes = 512; _sleepTime = 6; } else {
                    _texRes = 256; _sleepTime = 12;
                };
            };
        };
    };
    
    {
        private _unit = _x;
        if (isNil {_unit getVariable "UKSFTA_Accum_Init"}) then {
            _unit setVariable ["UKSFTA_Accum_Init", true];
            _unit setVariable ["UKSFTA_Accum_Wetness", 0];
            _unit setVariable ["UKSFTA_Accum_Snow", 0];
            _unit setVariable ["UKSFTA_Accum_Mud", 0];
            _unit setVariable ["UKSFTA_Accum_Blood", 0];
            _unit setVariable ["UKSFTA_Accum_Burn", 0];
            _unit setVariable ["UKSFTA_Accum_Snowfall", 0];
        };

        // --- 1. MATHEMATICAL ACCUMULATION ---
        
        // Wetness
        private _isSwimming = (getPosASL _unit select 2) < 0;
        private _isRaining = rain > 0.1;
        private _wet = _unit getVariable ["UKSFTA_Accum_Wetness", 0];
        if (_isSwimming || _isRaining) then {
            _wet = (_wet + (0.01 * _globalRate)) min 1;
        } else {
            _wet = (_wet - 0.001) max 0;
        };
        _unit setVariable ["UKSFTA_Accum_Wetness", _wet];

        // Snow (Ground)
        private _snow = _unit getVariable ["UKSFTA_Accum_Snow", 0];
        if (_biome == "ARCTIC" && overcast > 0.8) then {
            _snow = (_snow + (0.005 * _globalRate)) min 1;
        } else {
            if (_wet > 0.5) then { _snow = (_snow - 0.01) max 0; };
        };
        _unit setVariable ["UKSFTA_Accum_Snow", _snow];

        // Mud
        private _mud = _unit getVariable ["UKSFTA_Accum_Mud", 0];
        private _surface = toLower (surfaceType (getPos _unit));
        private _isMuddySurface = (_surface find "mud" != -1 || _surface find "marsh" != -1 || _surface find "swamp" != -1);
        
        // Mud only accumulates if:
        // 1. We are prone on a surface that is naturally muddy
        // 2. We are prone on dirt/grass AND it is currently raining or we are wet
        if (stance _unit == "PRONE") then {
            if (_isMuddySurface || {(_wet > 0.3 || _isRaining) && (_surface find "dirt" != -1 || _surface find "grass" != -1)}) then {
                _mud = (_mud + (0.02 * _globalRate)) min 1;
            };
        } else {
            // Slight accumulation for crouching in mud
            if (stance _unit == "CROUCH" && _isMuddySurface) then {
                _mud = (_mud + (0.005 * _globalRate)) min 1;
            };
        };
        
        // Drying logic: Mud stays longer than water but eventually flakes off in dry heat
        if (!_isRaining && _wet < 0.1 && !_isMuddySurface) then {
            private _dryRate = 0.0005;
            if (_biome == "ARID") then { _dryRate = 0.002; }; // Faster drying in deserts
            _mud = (_mud - _dryRate) max 0;
        };
        _unit setVariable ["UKSFTA_Accum_Mud", _mud];

        // Blood
        private _bleeding = _unit getVariable ["ace_medical_woundBleeding", 0];
        private _blood = _unit getVariable ["UKSFTA_Accum_Blood", 0];
        if (_bleeding > 0) then {
            _blood = (_blood + (_bleeding * 0.05 * _globalRate)) min 1;
        } else {
            if (_wet > 0.8) then { _blood = (_blood - 0.01) max 0; };
        };
        _unit setVariable ["UKSFTA_Accum_Blood", _blood];

        // Burn (Dynamic Realism)
        private _burn = _unit getVariable ["UKSFTA_Accum_Burn", 0];
        // Accumulate burn if near fire or explosion
        private _nearFire = (nearestObjects [_unit, ["House", "Thing"], 3]) select { getFireIntensity _x > 0 };
        if (count _nearFire > 0) then {
            _burn = (_burn + (0.05 * _globalRate)) min 1;
        };
        _unit setVariable ["UKSFTA_Accum_Burn", _burn];

        // Snowfall (Visual overlay during active snow)
        private _snowfall = 0;
        if (_biome == "ARCTIC" && rain > 0.1) then { // Arma treats snow as rain in Arctic biomes
            _snowfall = rain;
        };
        _unit setVariable ["UKSFTA_Accum_Snowfall", _snowfall];

        // --- 2. VISUAL APPLICATION ---
        
        private _uniform = uniform _unit;
        if (_uniform != "") then {
            private _uiName = _unit getVariable ["UKSFTA_Accum_UIName", ""];
            if (_uiName == "") then {
                private _baseTex = (getObjectTextures _unit) select 0;
                if (!isNil "_baseTex" && {(_baseTex find "UKSFTA_Accumulation_Display") == -1}) then {
                    _uiName = format ["UKSFTA_ACCUM:%1:%2", _baseTex, floor(random 1000000)];
                    _unit setVariable ["UKSFTA_Accum_UIName", _uiName];
                    
                    // Apply procedural texture
                    // Resolution is performance-derived
                    _unit setObjectTexture [0, format ["#(argb,%1,%1,5)ui(""UKSFTA_Accumulation_Display"",""%2"")", _texRes, _uiName]];
                };
            };

            // Update UI if it exists
            if (_uiName != "") then {
                private _display = UKSFTA_Accum_DisplayMap get _uiName;
                if (!isNil "_display" && {!isNull _display}) then {
                    {
                        private _ctrl = _display displayCtrl (_x select 0);
                        private _val = _unit getVariable [_x select 1, 0];
                        _ctrl ctrlSetFade (1 - _val);
                        _ctrl ctrlCommit 0;
                    } forEach [
                        [101, "UKSFTA_Accum_Wetness"],
                        [102, "UKSFTA_Accum_Snow"],
                        [103, "UKSFTA_Accum_Mud"],
                        [104, "UKSFTA_Accum_Blood"],
                        [105, "UKSFTA_Accum_Burn"],
                        [106, "UKSFTA_Accum_Snowfall"]
                    ];
                    displayUpdate _display;
                };
            };
        };

    } forEach _units;

    sleep _sleepTime; // Performance-derived frequency
};

true
