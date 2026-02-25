#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Accumulation Engine (Gold Master + Performance Overhaul)
 * Optimized UI2Texture layering with Frame-Staggering, Unit Capping, and Altitude Scaling.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Accumulation Engine (Staggered Mode) Starting...";

UKSFTA_Accum_PriorityUnits = [];
UKSFTA_Accum_Counter = 0;

[
    {
        UKSFTA_Accum_Counter = UKSFTA_Accum_Counter + 1;
        
        if (UKSFTA_Accum_Counter % 120 == 0) then {
            private _all = allUnits select { alive _x && { _x distance player < 100 } };
            _all = [_all, [], { _x distance player }, "ASCEND"] call BIS_fnc_sortBy;
            UKSFTA_Accum_PriorityUnits = _all;
        };

        if !(missionNamespace getVariable ["uksfta_environment_enableAccumulation", true]) exitWith {};
        if !(missionNamespace getVariable ["uksfta_main_enabled", true]) exitWith {};

        private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
        private _globalRate = missionNamespace getVariable ["uksfta_environment_accumulationRate", 1.0];
        
        private _count = count UKSFTA_Accum_PriorityUnits;
        if (_count == 0) exitWith {};

        private _startIndex = (UKSFTA_Accum_Counter % (_count / 3 max 1)) * 3;
        private _endIndex = (_startIndex + 2) min (_count - 1);

        for "_i" from _startIndex to _endIndex do {
            private _unit = UKSFTA_Accum_PriorityUnits select _i;
            if (!isNil "_unit" && {!isNull _unit}) then {

                if (local _unit) then {
                    private _dist = _unit distance player;
                    private _calcChance = [0.2, 1.0] select (_dist < 20);
                    
                    if (random 1 < _calcChance) then {
                        private _pos = getPosVisual _unit;
                        private _isSwimming = (_pos select 2) < 0;
                        private _isRaining = rain > 0.1;
                        private _alt = _pos select 2;
                        
                        // WETNESS
                        private _wet = _unit getVariable ["UKSFTA_Accum_Wetness", 0];
                        if (_isSwimming || _isRaining) then {
                            _wet = (_wet + (0.01 * _globalRate)) min 1;
                        } else {
                            _wet = (_wet - 0.001) max 0;
                        };
                        _unit setVariable ["UKSFTA_Accum_Wetness", _wet, true];

                        // SNOW (Altitude Aware)
                        private _snow = _unit getVariable ["UKSFTA_Accum_Snow", 0];
                        if (_biome == "ARCTIC" && overcast > 0.7) then {
                            private _altMod = if (_alt > 500) then { 2.0 } else { 1.0 };
                            _snow = (_snow + (0.005 * _globalRate * _altMod)) min 1;
                        };
                        _unit setVariable ["UKSFTA_Accum_Snow", _snow, true];

                        // MUD (Stance + Surface Check)
                        private _mud = _unit getVariable ["UKSFTA_Accum_Mud", 0];
                        if (stance _unit == "PRONE") then {
                            private _surface = toLower (surfaceType _pos);
                            if (_surface find "mud" != -1 || _isRaining) then {
                                _mud = (_mud + (0.02 * _globalRate)) min 1;
                            };
                        };
                        _unit setVariable ["UKSFTA_Accum_Mud", _mud, true];
                        
                        // BLOOD (Medical Sync)
                        private _bleeding = _unit getVariable ["ace_medical_woundBleeding", 0];
                        if (_bleeding > 0) then {
                            private _blood = (_unit getVariable ["UKSFTA_Accum_Blood", 0]) + (_bleeding * 0.05);
                            _unit setVariable ["UKSFTA_Accum_Blood", _blood min 1, true];
                        };
                    };
                };

                // --- 2b. VISUAL APPLICATION ---
                private _uiName = _unit getVariable ["UKSFTA_Accum_UIName", ""];
                if (_uiName != "") then {
                    private _display = UKSFTA_Accum_DisplayMap get _uiName;
                    if (!isNil "_display" && {!isNull _display}) then {
                        if (_unit distance player < 30) then {
                            private _wet = _unit getVariable ["UKSFTA_Accum_Wetness", 0];
                            private _snow = _unit getVariable ["UKSFTA_Accum_Snow", 0];
                            private _mud = _unit getVariable ["UKSFTA_Accum_Mud", 0];
                            private _blood = _unit getVariable ["UKSFTA_Accum_Blood", 0];
                            
                            (_display displayCtrl 101) ctrlSetFade (1 - _wet);
                            (_display displayCtrl 102) ctrlSetFade (1 - _snow);
                            (_display displayCtrl 103) ctrlSetFade (1 - _mud);
                            (_display displayCtrl 104) ctrlSetFade (1 - _blood);
                            
                            { _x ctrlCommit 0.5; } forEach [(_display displayCtrl 101), (_display displayCtrl 102), (_display displayCtrl 103), (_display displayCtrl 104)];
                        };
                    };
                };
            };
        };
    },
    0
] call CBA_fnc_addPerFrameHandler;

true
