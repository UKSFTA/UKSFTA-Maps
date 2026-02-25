#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UKSFTA Accumulation Engine (Phase 20)
 * Optimized UI2Texture layering with Frame-Staggering and Unit Capping.
 */

if (!hasInterface) exitWith {};

LOG("Accumulation Engine (Staggered Mode) Starting...");

UKSFTA_Accum_PriorityUnits = [];
UKSFTA_Accum_Counter = 0;

[
    {
        UKSFTA_Accum_Counter = UKSFTA_Accum_Counter + 1;
        
        // --- 1. PRIORITY LOGIC LOD (Unit Capping) ---
        if (UKSFTA_Accum_Counter % 120 == 0) then {
            private _all = allUnits select { alive _x && { _x distance player < 300 } };
            // Sort by distance using correct scope
            _all = [_all, [], { player distance _x }, "ASCEND"] call BIS_fnc_sortBy;
            UKSFTA_Accum_PriorityUnits = _all;
        };

        if !(missionNamespace getVariable [QGVAR(enabled), true] && {missionNamespace getVariable [QGVAR(envAccumulation), true]}) exitWith {};

        private _globalRate = missionNamespace getVariable ["uksfta_environment_accumulationRate", 1.0];
        
        {
            private _unit = _x;
            private _dist = _unit distance player;
            
            // PERFORMANCE BANDING
            private _tickRate = [60, 10] select (_dist < 300);
            _tickRate = [1, _tickRate] select (_dist > 50);
            
            if (UKSFTA_Accum_Counter % _tickRate == 0) then {
                if (local _unit) then {
                    // --- 2. MATHEMATICAL ACCUMULATION ---
                    private _pos = getPosVisual _unit;
                    private _isSwimming = (_pos select 2) < 0;
                    private _isRaining = rain > 0.1;
                    private _alt = _pos select 2;
                    
                    // WETNESS
                    private _wet = _unit getVariable ["UKSFTA_Accum_Wetness", 0];
                    if (_isSwimming || _isRaining) then { _wet = (_wet + (0.01 * _globalRate)) min 1; } else { _wet = (_wet - 0.001) max 0; };
                    _unit setVariable ["UKSFTA_Accum_Wetness", _wet, true];

                    // SNOW (Altitude Aware)
                    private _snow = _unit getVariable ["UKSFTA_Accum_Snow", 0];
                    if ((missionNamespace getVariable ["UKSFTA_Environment_Biome", ""]) == "ARCTIC" && overcast > 0.7) then {
                        private _altMod = [1.0, 2.0] select (_alt > 500);
                        _snow = (_snow + (0.005 * _globalRate * _altMod)) min 1;
                    };
                    _unit setVariable ["UKSFTA_Accum_Snow", _snow, true];

                    // MUD (Stance + Surface Check)
                    private _mud = _unit getVariable ["UKSFTA_Accum_Mud", 0];
                    if (stance _unit == "PRONE") then {
                        private _surface = toLower (surfaceType _pos);
                        if (_surface find "mud" != -1 || _isRaining) then { _mud = (_mud + (0.02 * _globalRate)) min 1; };
                    };
                    _unit setVariable ["UKSFTA_Accum_Mud", _mud, true];

                    // --- 3. DIRTY LENS HOOK (ACE Goggles) ---
                    if (_unit == player && {missionNamespace getVariable ["uksfta_sensor_enableDirtyLens", true]}) then {
                        if (_mud > 0.8 && {random 1 < 0.05}) then { [0.1] call (missionNamespace getVariable ["ace_goggles_fnc_applyDirt", {}]); };
                    };
                };

                // --- 4. VISUAL APPLICATION (Band 1 Only) ---
                if (_dist < 50) then {
                    private _uiName = _unit getVariable ["UKSFTA_Accum_UIName", ""];
                    if (_uiName != "") then {
                        private _display = UKSFTA_Accum_DisplayMap get _uiName;
                        if (!isNil "_display" && {!isNull _display}) then {
                            (_display displayCtrl 101) ctrlSetFade (1 - (_unit getVariable ["UKSFTA_Accum_Wetness", 0]));
                            (_display displayCtrl 102) ctrlSetFade (1 - (_unit getVariable ["UKSFTA_Accum_Snow", 0]));
                            (_display displayCtrl 103) ctrlSetFade (1 - (_unit getVariable ["UKSFTA_Accum_Mud", 0]));
                            { _x ctrlCommit 1; } forEach [(_display displayCtrl 101), (_display displayCtrl 102), (_display displayCtrl 103)];
                        };
                    };
                };
            };
        } forEach UKSFTA_Accum_PriorityUnits;
    },
    0
] call CBA_fnc_addPerFrameHandler;

true
