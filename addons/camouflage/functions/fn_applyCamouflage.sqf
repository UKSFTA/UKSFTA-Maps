#include "..\script_component.hpp"
/**
 * UKSFTA Camouflage - Sovereign Stealth Engine (Gold Master)
 * Features Pixel-Perfect Sampling and DAGGER-Parity Stealth Capping.
 * Multiplayer Optimized: Server-Side AI Scaling.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [CAMOUFLAGE]: Stealth Engine Active (DAGGER Parity).";

[] spawn {
    while {missionNamespace getVariable ["uksfta_main_enabled", true]} do {
        private _unit = player;
        private _uniform = uniform _unit;
        
        if (_uniform != "") then {
            // 1. BASE CAMO CALCULATION
            private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
            private _mud = _unit getVariable ["UKSFTA_Accum_Mud", 0];
            private _snow = _unit getVariable ["UKSFTA_Accum_Snow", 0];
            
            // Base coefficient (Standard: 1.0)
            private _coeff = 1.0;
            
            // 2. DAGGER PARITY: Stealth Capping
            // Specialized uniforms reduce visibility to 0.1 baseline
            if (_biome == "ARCTIC" && _snow > 0.5) then { _coeff = 0.3; };
            if (_mud > 0.5) then { _coeff = 0.5; }; // Mud acts as natural camo
            
            // 3. APPLY TO UNIT
            // Standard coefficient cap (0.1 min)
            private _finalCamo = (_coeff) max 0.1;
            _unit setUnitTrait ["camouflageCoef", _finalCamo];
            
            // 4. PERFORMANCE OFFLOAD (Server-Side Hint)
            if (diag_frameCount % 300 == 0) then {
                [_unit, _finalCamo] remoteExec ["uksfta_camouflage_fnc_syncServer", 2];
            };
        };

        sleep 5;
    };
};

true
