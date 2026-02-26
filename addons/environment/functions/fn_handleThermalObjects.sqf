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
            _engineHeat = (_engineHeat + 0.01) min 1.0; // Rapid heat-up
        } else {
            private _coolRate = [0.002, 0.005] select (_biome == "ARCTIC");
            _engineHeat = (_engineHeat - _coolRate) max 0;
        };
        _veh setVariable ["UKSFTA_Heat_Engine", _engineHeat];

        // --- B. WHEEL/TRACK FRICTION ---
        private _fricHeat = _veh getVariable ["UKSFTA_Heat_Friction", 0];
        if (_speed > 5) then {
            _fricHeat = (_fricHeat + (_speed / 5000)) min 0.8;
        } else {
            _fricHeat = (_fricHeat - 0.005) max 0;
        };
        _veh setVariable ["UKSFTA_Heat_Friction", _fricHeat];

        // --- C. HULL SOLAR SOAK ---
        private _solarHeat = 0;
        if (_biome == "ARID") then {
            private _sunAlt = call uksfta_environment_fnc_getSunElevation;
            _solarHeat = (linearConversion [30, 90, _sunAlt, 0, 0.4, true]);
        };

        // --- D. APPLY TO TI SIGNATURE ---
        // We use setTIParameter to drive the material shader (Engine + Friction + Solar)
        private _totalHeat = (_engineHeat * 0.6) + (_fricHeat * 0.3) + _solarHeat;
        [_veh, [1, _totalHeat]] call (missionNamespace getVariable ["setTI", {params ["_o", "_v"];}]);

        // --- E. DYNAMIC HEAT HAZE (Engine Location) ---
        private _haze = _veh getVariable ["UKSFTA_HeatHaze", objNull];
        if (_engineHeat > 0.3) then {
            if (isNull _haze) then {
                _haze = "#particlesource" createVehicleLocal (getPosATL _veh);
                _haze attachTo [_veh, [0, -2, 0.5]]; 
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
