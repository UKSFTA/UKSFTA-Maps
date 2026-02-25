#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Ballistics Engine (Phase 11)
 * Dynamic drag coefficients based on real-time atmospheric density.
 * Linked to Sovereign Meteorological Engine.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Ballistics Engine Active (Meteorological Link).";

player addEventHandler ["FiredMan", {
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

    // 1. DENSITY RATIO (Meteorological Authority)
    private _rho = missionNamespace getVariable ["UKSFTA_Environment_AirDensity", 1.225];
    private _pos = getPosASL _projectile;
    private _alt = _pos select 2;
    
    // Altitude correction (ISA Standard Scale Height: 8500m)
    private _rho_alt = _rho * exp(-_alt / 8500);
    private _rhoRatio = _rho_alt / 1.225;

    // 2. DYNAMIC DRAG SCALING
    // We adjust the drag coefficient via setVariable if using advanced ballistic mods, 
    // or simulate it via incremental velocity adjustment.
    // For Sovereign Gold Master, we store it for use in sub-logic or compatible overhauls.
    _projectile setVariable ["UKSFTA_Ballistics_DensityMod", _rhoRatio];

    // TRACER THERMAL SIGNATURE
    if (getNumber (configFile >> "CfgAmmo" >> _ammo >> "tracerScale") > 0) then {
        _projectile setVariable ["UKSFTA_IsTracer", true];
    };
}];

true
