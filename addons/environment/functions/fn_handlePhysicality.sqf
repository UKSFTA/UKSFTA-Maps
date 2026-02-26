#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UKSFTA Physicality Engine (PFH Optimized)
 */

if (!hasInterface) exitWith {};

LOG("Physicality Engine (PFH Mode) Starting...");

[
    {
        if !(missionNamespace getVariable [QGVAR(enabled), true] && {missionNamespace getVariable [QGVAR(physPhysicality), true]}) exitWith {};

        private _stress = player getVariable ["UKSFTA_Stress_Level", 0];
        private _fatigue = getFatigue player;
        private _load = load player;
        private _speed = vectorMagnitude (velocity player);
        
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

        // --- 2b. WEAPON RELIABILITY (DAGGER Synergy) ---
        if (diag_frameCount % 300 == 0) then {
            private _mud = player getVariable ["UKSFTA_Accum_Mud", 0];
            if (_mud > 0.5 && {random 1 < (_mud * 0.05)}) then {
                if (!isNil "ace_overheating_fnc_jamWeapon") then {
                    [player, currentWeapon player] call ace_overheating_fnc_jamWeapon;
                    ["Weapon malfunction due to environmental fouling.", "WARN"] call uksfta_main_fnc_notify;
                };
            };
        };

        // --- 2c. ACE HEAT HAZE SYNERGY (Phase 21) ---
        // Additive Visual: Only runs if ACE Overheating is tracking temperature
        if (missionNamespace getVariable [QGVAR(ace_heatHaze), true] && { !isNil "ace_overheating_fnc_updateTemperature" }) then {
            private _temp = player getVariable ["ace_overheating_temperature", 0];
            if (_temp > 150) then {
                private _haze = player getVariable ["UKSFTA_WepHaze", objNull];
                if (isNull _haze) then {
                    _haze = "#particlesource" createVehicleLocal (getPosVisual player);
                    _haze attachTo [player, [0, 0.5, 0], "weapon"];
                    player setVariable ["UKSFTA_WepHaze", _haze];
                };
                private _intensity = (linearConversion [150, 600, _temp, 0.1, 1.0, true]);
                _haze setParticleParams [
                    ["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 0.5, 
                    [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0, [0.1 * _intensity], [[1, 1, 1, 1]], [0.08], 1, 0, "", "", player
                ];
                _haze setDropInterval (0.1 / _intensity);
            } else {
                private _haze = player getVariable ["UKSFTA_WepHaze", objNull];
                if (!isNull _haze) then { deleteVehicle _haze; player setVariable ["UKSFTA_WepHaze", objNull]; };
            };
        };

        // --- 3. SENSOR REALISM (Throttled) ---
        if (diag_frameCount % 60 == 0 && {currentVisionMode player == 1}) then {
            private _nearFlares = player nearObjects ["FlareCore", 50];
            if (_nearFlares isNotEqualTo []) then {
                private _pp = ppEffectCreate ["ColorCorrections", 3005];
                _pp ppEffectEnable true;
                _pp ppEffectAdjust [1, 1, 0, [1, 1, 1, 0], [1, 1, 1, 1], [0, 0, 0, 0]];
                _pp ppEffectCommit 0.1;
                [_pp] spawn { sleep 0.2; _this select 0 ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 0], [0, 0, 0, 0]]; _this select 0 ppEffectCommit 1.5; sleep 2; ppEffectDestroy (_this select 0); };
            };
        };
    },
    0.5
] call CBA_fnc_addPerFrameHandler;

true
