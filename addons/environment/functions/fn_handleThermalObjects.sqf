#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Component-Based Thermal Engine (Production)
 * Features localized heat signatures for Engine, Wheels, and Hull.
 */

if (!hasInterface) exitWith {};

LOG("Thermal Object Engine (Localized) Active.");

// 1. PROJECTILE THERMALS
addMissionEventHandler ["ProjectileCreated", {
    params ["_projectile"];
    private _type = typeOf _projectile;
    if (_type isKindOf "FlareCore" || {(_type find "Flare") != -1}) then {
        [_projectile, [1, 1.0]] call (missionNamespace getVariable ["setTI", {params ["_o", "_v"];}]);
    };
    if (missionNamespace getVariable [QGVAR(envNaturalism), true]) then {
        if (getNumber(configFile >> "CfgAmmo" >> _type >> "tracerScale") > 0) then {
            [_projectile, [1, 0.8]] call (missionNamespace getVariable ["setTI", {params ["_o", "_v"];}]);
        };
    };
}];

// --- VEHICLE WEAPON HEAT HOOK ---
[_fnc_addMEH, ["Fired", {
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
    private _veh = objectParent _unit;
    if (!isNull _veh && { _veh isKindOf "LandVehicle" }) then {
        private _current = _veh getVariable ["UKSFTA_Heat_Weapon", 0];
        _veh setVariable ["UKSFTA_Heat_Weapon", (_current + 0.1) min 1.0, true];
    };
}]] call (missionNamespace getVariable ["apply", { (_this select 1) call (_this select 0) }]);

// 2. COMPONENT THERMAL LOOP
[
    {
        private _veh = objectParent player;
        if (isNull _veh || { !(_veh isKindOf "LandVehicle") }) exitWith {};

        private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
        private _engineOn = isEngineOn _veh;
        private _speed = abs (speed _veh);
        
        // --- A. ENGINE BLOCK HEAT ---
        private _engineHeat = _veh getVariable ["UKSFTA_Heat_Engine", 0];
        if (_engineOn) then {
            _engineHeat = (_engineHeat + 0.01) min 1.0;
        } else {
            private _coolRate = [0.002, 0.005] select (_biome == "ARCTIC");
            _engineHeat = (_engineHeat - _coolRate) max 0;
        };
        _veh setVariable ["UKSFTA_Heat_Engine", _engineHeat];

        // --- B. VEHICLE WEAPON HEAT (Phase 21 Addon) ---
        // Track large caliber fire for thermal signatures
        private _wepHeat = _veh getVariable ["UKSFTA_Heat_Weapon", 0];
        _wepHeat = (_wepHeat - 0.005) max 0;
        _veh setVariable ["UKSFTA_Heat_Weapon", _wepHeat];

        // --- C. WHEEL/TRACK FRICTION ---
        private _fricHeat = _veh getVariable ["UKSFTA_Heat_Friction", 0];
        if (_speed > 5) then {
            _fricHeat = (_fricHeat + (_speed / 5000)) min 0.8;
        } else {
            _fricHeat = (_fricHeat - 0.005) max 0;
        };
        _veh setVariable ["UKSFTA_Heat_Friction", _fricHeat];

        // --- D. HULL SOLAR SOAK ---
        private _solarHeat = 0;
        if (_biome == "ARID") then {
            private _sunAlt = call uksfta_environment_fnc_getSunElevation;
            _solarHeat = (linearConversion [30, 90, _sunAlt, 0, 0.4, true]);
        };

        // --- E. APPLY TO TI SIGNATURE ---
        private _totalHeat = (_engineHeat * 0.6) + (_fricHeat * 0.2) + (_wepHeat * 0.5) + _solarHeat;
        [_veh, [1, _totalHeat]] call (missionNamespace getVariable ["setTI", {params ["_o", "_v"];}]);

        // --- F. DYNAMIC HEAT HAZE (Localized) ---
        private _haze = _veh getVariable ["UKSFTA_HeatHaze", objNull];
        if (_engineHeat > 0.3) then {
            if (isNull _haze) then {
                _haze = "#particlesource" createVehicleLocal (getPosATL _veh);
                
                // Attempt to find authentic attachment point
                private _attachPoint = [0, -2, 0.5];
                if (_veh selectionPosition "engine" isNotEqualTo [0,0,0]) then { _attachPoint = _veh selectionPosition "engine"; };
                if (_veh selectionPosition "exhaust" isNotEqualTo [0,0,0]) then { _attachPoint = _veh selectionPosition "exhaust"; };
                
                _haze attachTo [_veh, _attachPoint]; 
                _veh setVariable ["UKSFTA_HeatHaze", _haze];
            };
            _haze setParticleParams [
                ["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 1, 
                [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0, [1 + _engineHeat], [[1, 1, 1, 1]], [0.08], 1, 0, "", "", _veh
            ];
            _haze setDropInterval (0.2 / (_engineHeat max 0.1));
        } else {
            if (!isNull _haze) then { deleteVehicle _haze; _veh setVariable ["UKSFTA_HeatHaze", objNull]; };
        };
    },
    2 // Low-frequency thermal update (Performance optimized)
] call CBA_fnc_addPerFrameHandler;

true
