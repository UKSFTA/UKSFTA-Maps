#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Accumulation Engine (Phase 20)
 * Features Priority Logic LOD and ACE Goggles "Dirty Lens" Hook.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Accumulation Engine (Phase 20) Active.";

UKSFTA_Accum_PriorityUnits = [];
UKSFTA_Accum_Counter = 0;

[
    {
        UKSFTA_Accum_Counter = UKSFTA_Accum_Counter + 1;
        
        // --- 1. PRIORITY LOGIC LOD (Unit Capping) ---
        if (UKSFTA_Accum_Counter % 120 == 0) then {
            private _all = allUnits select { alive _x && { _x distance player < 300 } };
            // Group 1: Immediate (0-50m) | Group 2: Background (50-300m)
            UKSFTA_Accum_PriorityUnits = _all;
        };

        if !(missionNamespace getVariable ["uksfta_main_enabled", true] && {missionNamespace getVariable ["uksfta_environment_enableAccumulation", true]}) exitWith {};

        private _globalRate = missionNamespace getVariable ["uksfta_environment_accumulationRate", 1.0];
        
        {
            private _unit = _x;
            private _dist = _unit distance player;
            
            // PERFORMANCE BANDING
            // Band 1: Full Fidelity (<50m) | Band 2: Math Only (50-300m) | Band 3: Throttled (>300m)
            private _tickRate = case (_dist < 50): { 1 }; case (_dist < 300): { 10 }; default { 60 };
            
            if (UKSFTA_Accum_Counter % _tickRate == 0) then {
                if (local _unit) then {
                    // --- 2. MATHEMATICAL ACCUMULATION ---
                    private _isSwimming = (getPosASL _unit select 2) < 0;
                    private _isRaining = rain > 0.1;
                    
                    private _wet = _unit getVariable ["UKSFTA_Accum_Wetness", 0];
                    if (_isSwimming || _isRaining) then { _wet = (_wet + (0.01 * _globalRate)) min 1; } else { _wet = (_wet - 0.001) max 0; };
                    _unit setVariable ["UKSFTA_Accum_Wetness", _wet, true];

                    private _mud = _unit getVariable ["UKSFTA_Accum_Mud", 0];
                    if (stance _unit == "PRONE") then {
                        private _surface = toLower (surfaceType (getPosVisual _unit));
                        if (_surface find "mud" != -1 || _isRaining) then { _mud = (_mud + (0.02 * _globalRate)) min 1; };
                    };
                    _unit setVariable ["UKSFTA_Accum_Mud", _mud, true];

                    // --- 3. DIRTY LENS HOOK (ACE Goggles) ---
                    if (_unit == player && {missionNamespace getVariable ["uksfta_sensor_enableDirtyLens", true]}) then {
                        if (_mud > 0.8 && {random 1 < 0.05}) then {
                            [0.1] call (missionNamespace getVariable ["ace_goggles_fnc_applyDirt", {}]);
                        };
                        if (missionNamespace getVariable ["UKSFTA_Environment_Ashfall", 0] > 0.5) then {
                            [0.01] call (missionNamespace getVariable ["ace_goggles_fnc_applyDirt", {}]);
                        };
                    };
                };

                // --- 4. VISUAL APPLICATION (Band 1 Only) ---
                if (_dist < 50) then {
                    private _uiName = _unit getVariable ["UKSFTA_Accum_UIName", ""];
                    if (_uiName != "") then {
                        private _display = UKSFTA_Accum_DisplayMap get _uiName;
                        if (!isNil "_display" && {!isNull _display}) then {
                            (_display displayCtrl 101) ctrlSetFade (1 - (_unit getVariable ["UKSFTA_Accum_Wetness", 0]));
                            (_display displayCtrl 103) ctrlSetFade (1 - (_unit getVariable ["UKSFTA_Accum_Mud", 0]));
                            { _x ctrlCommit 1; } forEach [(_display displayCtrl 101), (_display displayCtrl 103)];
                        };
                    };
                };
            };
        } forEach UKSFTA_Accum_PriorityUnits;
    },
    0
] call CBA_fnc_addPerFrameHandler;

true
