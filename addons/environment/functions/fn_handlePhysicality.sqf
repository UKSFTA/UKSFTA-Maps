#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UKSFTA Physicality Engine (PFH Optimized)
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Physicality Engine (PFH Mode) Starting...";

[
    {
        if !(missionNamespace getVariable ["uksfta_main_enabled", true] && {missionNamespace getVariable ["uksfta_phys_enablePhysicality", true]}) exitWith {};

        private _stress = player getVariable ["UKSFTA_Stress_Level", 0];
        private _fatigue = getFatigue player;
        private _load = load player;
        
        // --- 1. STRESS-DRIVEN AIMING ---
        player setCustomAimCoef (1.0 + (_stress * 2.0) + (_fatigue * 1.0));
        player setUnitRecoilCoefficient (1.0 + (_stress * 0.5));

        // --- 2. WEIGHT-BASED INERTIA ---
        player setAnimSpeedCoef (1.0 - (_load * 0.15));
        player setUnitTrait ["loadCoef", (1.0 + _load)];

        // --- 2a. ICY FOOTING (DAGGER Synergy) ---
        private _surface = toLower (surfaceType (getPosVisual player));
        private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
        if (_biome == "ARCTIC" && {(_surface find "snow" != -1 || _surface find "ice" != -1)}) then {
            if (_speed > 3) then {
                // Subtle slide force
                player addForce [(vectorDir player vectorMultiply 500), [0,0,0]];
            };
        };

        // --- 3. SENSOR REALISM (Throttled) ---
        if (diag_frameCount % 60 == 0 && {currentVisionMode player == 1}) then {
            private _nearFlares = player nearObjects ["FlareCore", 50];
            if (_nearFlares isNotEqualTo []) then {
                // Auto-gating Whiteout
                private _pp = ppEffectCreate ["ColorCorrections", 3005];
                _pp ppEffectEnable true;
                _pp ppEffectAdjust [1, 1, 0, [1, 1, 1, 0], [1, 1, 1, 1], [0, 0, 0, 0]];
                _pp ppEffectCommit 0.1;
                [_pp] spawn { sleep 0.2; _this select 0 ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 0], [0, 0, 0, 0]]; _this select 0 ppEffectCommit 1.5; sleep 2; ppEffectDestroy (_this select 0); };
            };
        };
    },
    0.5 // Run every 0.5s instead of every frame
] call CBA_fnc_addPerFrameHandler;

true
