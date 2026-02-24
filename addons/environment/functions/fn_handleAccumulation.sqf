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
    private _perfMode = missionNamespace getVariable ["uksfta_environment_perfMode", 3];
    
    // Performance derived values
    private _texRes = 512;
    private _sleepTime = 5;

    // Detect Video Settings
    private _vidOpts = getVideoOptions;
    private _texQuality = _vidOpts getOrDefault ["textureQuality", 2];

    switch (_perfMode) do {
        case 0: { _texRes = 1024; _sleepTime = 2; };
        case 1: { _texRes = 512; _sleepTime = 5; };
        case 2: { _texRes = 128; _sleepTime = 10; };
        case 3: { 
            private _fps = diag_fps;
            private _maxRes = 1024;
            if (_texQuality < 4) then { _maxRes = 512; };
            if (_texQuality < 2) then { _maxRes = 256; };
            if (_texQuality < 1) then { _maxRes = 128; };

            if (_fps > 50) then { _texRes = _maxRes; _sleepTime = 3; } else {
                if (_fps > 25) then { _texRes = (_maxRes / 2) max 128; _sleepTime = 6; } else {
                    _texRes = (_maxRes / 4) max 64; _sleepTime = 12;
                };
            };
        };
    };
    
    {
        private _unit = _x;
        if (isNil {_unit getVariable "UKSFTA_Accum_Init"}) then {
            _unit setVariable ["UKSFTA_Accum_Init", true];
            _unit setVariable ["UKSFTA_Accum_Wetness", 0, true];
            _unit setVariable ["UKSFTA_Accum_Snow", 0, true];
            _unit setVariable ["UKSFTA_Accum_Mud", 0, true];
            _unit setVariable ["UKSFTA_Accum_Blood", 0, true];
            _unit setVariable ["UKSFTA_Accum_BloodSplatter", 0, true];
            _unit setVariable ["UKSFTA_Accum_Burn", 0, true];
            _unit setVariable ["UKSFTA_Accum_Ash", 0, true];
            _unit setVariable ["UKSFTA_Accum_Snowfall", 0, true];
        };

        // --- 1. MATHEMATICAL ACCUMULATION (Owner Only) ---
        if (local _unit) then {
            private _globalAsh = missionNamespace getVariable ["UKSFTA_Environment_Ashfall", 0];
            private _nearFire = (nearestObjects [_unit, ["House", "Thing", "Car", "Tank"], 5]) select { getFireIntensity _x > 0 };

            // Wetness
            private _isSwimming = (getPosASL _unit select 2) < 0;
            private _isRaining = rain > 0.1;
            private _wet = _unit getVariable ["UKSFTA_Accum_Wetness", 0];
            private _oldWet = _wet;
            if (_isSwimming || _isRaining) then {
                _wet = (_wet + (0.01 * _globalRate)) min 1;
            } else {
                _wet = (_wet - 0.001) max 0;
            };
            if (abs(_wet - _oldWet) > 0.01) then { _unit setVariable ["UKSFTA_Accum_Wetness", _wet, true]; };

            // Snow (Ground)
            private _snow = _unit getVariable ["UKSFTA_Accum_Snow", 0];
            private _oldSnow = _snow;
            if (_biome == "ARCTIC" && overcast > 0.8) then {
                _snow = (_snow + (0.005 * _globalRate)) min 1;
            } else {
                if (_wet > 0.5) then { _snow = (_snow - 0.01) max 0; };
            };
            // Thermal Melting
            if (count _nearFire > 0) then { _snow = (_snow - 0.05) max 0; };
            if (abs(_snow - _oldSnow) > 0.01) then { _unit setVariable ["UKSFTA_Accum_Snow", _snow, true]; };

            // Mud
            private _mud = _unit getVariable ["UKSFTA_Accum_Mud", 0];
            private _oldMud = _mud;
            private _surface = toLower (surfaceType (getPos _unit));
            private _isMuddySurface = (_surface find "mud" != -1 || _surface find "marsh" != -1 || _surface find "swamp" != -1);
            
            if (stance _unit == "PRONE") then {
                if (_isMuddySurface || {(_wet > 0.3 || _isRaining) && (_surface find "dirt" != -1 || _surface find "grass" != -1)}) then {
                    _mud = (_mud + (0.02 * _globalRate)) min 1;
                };
            } else {
                if (stance _unit == "CROUCH" && _isMuddySurface) then {
                    _mud = (_mud + (0.005 * _globalRate)) min 1;
                };
            };
            
            if (!_isRaining && _wet < 0.1 && !_isMuddySurface) then {
                private _dryRate = 0.0005;
                if (_biome == "ARID") then { _dryRate = 0.002; };
                _mud = (_mud - _dryRate) max 0;
            };
            if (abs(_mud - _oldMud) > 0.01) then { _unit setVariable ["UKSFTA_Accum_Mud", _mud, true]; };

            // Blood & Splatter
            private _bleeding = _unit getVariable ["ace_medical_woundBleeding", 0];
            private _blood = _unit getVariable ["UKSFTA_Accum_Blood", 0];
            private _bloodSplat = _unit getVariable ["UKSFTA_Accum_BloodSplatter", 0];
            private _oldBlood = _blood;
            
            if (_bleeding > 0) then {
                _blood = (_blood + (_bleeding * 0.05 * _globalRate)) min 1;
                _bloodSplat = (_bloodSplat + (_bleeding * 0.1 * _globalRate)) min 1;
            } else {
                if (_wet > 0.8) then { 
                    _blood = (_blood - 0.01) max 0;
                    _bloodSplat = (_bloodSplat - 0.005) max 0;
                };
            };
            if (abs(_blood - _oldBlood) > 0.01) then { 
                _unit setVariable ["UKSFTA_Accum_Blood", _blood, true];
                _unit setVariable ["UKSFTA_Accum_BloodSplatter", _bloodSplat, true];
            };

            // Burn
            private _burn = _unit getVariable ["UKSFTA_Accum_Burn", 0];
            private _oldBurn = _burn;
            if (count _nearFire > 0) then {
                _burn = (_burn + (0.05 * _globalRate)) min 1;
            };
            if (abs(_burn - _oldBurn) > 0.01) then { _unit setVariable ["UKSFTA_Accum_Burn", _burn, true]; };

            // Ash
            private _ash = _unit getVariable ["UKSFTA_Accum_Ash", 0];
            private _oldAsh = _ash;
            if (_globalAsh > 0 || count _nearFire > 0) then {
                _ash = (_ash + (0.005 * _globalRate)) min 1;
            } else {
                if (_wet > 0.5) then { _ash = (_ash - 0.01) max 0; };
            };
            if (count _nearFire > 0 && {getFireIntensity (_nearFire select 0) > 0.7}) then { _ash = (_ash - 0.02) max 0; };
            if (abs(_ash - _oldAsh) > 0.01) then { _unit setVariable ["UKSFTA_Accum_Ash", _ash, true]; };

            // Snowfall
            private _snowfall = 0;
            if (_biome == "ARCTIC" && rain > 0.1) then { _snowfall = rain; };
            _unit setVariable ["UKSFTA_Accum_Snowfall", _snowfall, true];
        };

        // --- 2. VISUAL APPLICATION ---
        private _uniform = uniform _unit;
        if (_uniform != "") then {
            private _uiName = _unit getVariable ["UKSFTA_Accum_UIName", ""];
            private _burnLevel = _unit getVariable ["UKSFTA_Accum_Burn", 0];

            if (_uiName == "") then {
                private _textures = getObjectTextures _unit;
                private _baseTex = _textures select 0;
                if (!isNil "_baseTex" && {(_baseTex find "UKSFTA_Accumulation_Display") == -1}) then {
                    _uiName = format ["UKSFTA_ACCUM:%1:%2", _baseTex, floor(random 1000000)];
                    _unit setVariable ["UKSFTA_Accum_UIName", _uiName];
                    
                    // Apply procedural texture to ALL valid selections
                    private _procTex = format ["#(argb,%1,%1,5)ui(""UKSFTA_Accumulation_Display"",""%2"")", _texRes, _uiName];
                    {
                        if (_x != "") then { _unit setObjectTexture [_forEachIndex, _procTex]; };
                    } forEach _textures;
                };
            };

            // Update UI if it exists
            if (_uiName != "") then {
                private _display = UKSFTA_Accum_DisplayMap get _uiName;
                if (!isNil "_display" && {!isNull _display}) then {
                    private _wet = _unit getVariable ["UKSFTA_Accum_Wetness", 0];
                    private _snow = _unit getVariable ["UKSFTA_Accum_Snow", 0];
                    private _mud = _unit getVariable ["UKSFTA_Accum_Mud", 0];
                    private _blood = _unit getVariable ["UKSFTA_Accum_Blood", 0];
                    private _bloodSplat = _unit getVariable ["UKSFTA_Accum_BloodSplatter", 0];
                    private _ash = _unit getVariable ["UKSFTA_Accum_Ash", 0];
                    private _snowfall = _unit getVariable ["UKSFTA_Accum_Snowfall", 0];

                    // 3-Stage Burn Progression
                    private _burnLight = linearConversion [0, 0.4, _burnLevel, 0, 1, true];
                    private _burnMedium = linearConversion [0.3, 0.7, _burnLevel, 0, 1, true];
                    private _burnExtreme = linearConversion [0.6, 1.0, _burnLevel, 0, 1, true];

                    {
                        private _ctrl = _display displayCtrl (_x select 0);
                        private _val = _x select 1;
                        _ctrl ctrlSetFade (1 - _val);
                        _ctrl ctrlCommit _sleepTime;
                    } forEach [
                        [101, _wet],
                        [102, _snow],
                        [103, _mud],
                        [104, _blood],
                        [107, _bloodSplat],
                        [109, _burnLight],
                        [110, _burnMedium],
                        [105, _burnExtreme],
                        [108, _ash],
                        [106, _snowfall]
                    ];
                    displayUpdate _display;

                    // Physical Face Change (High Intensity Burn)
                    if (_burnLevel > 0.7 && {face _unit != "BurnFace"}) then {
                        [_unit, "BurnFace"] remoteExec ["setFace", 0, _unit];
                    };
                };
            };
        };

    } forEach _units;

    sleep _sleepTime;
};

true
