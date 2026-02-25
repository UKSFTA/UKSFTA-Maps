#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Ballistics Engine (Gold Master)
 * Features real-time air density drag and side-airfriction scaling.
 * Parity with DAGGER and Realistic Ballistics Overhaul.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Ballistics Engine Active (Side-Friction Optimized).";

player addEventHandler ["FiredMan", {
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

    // 1. DENSITY RATIO (Meteorological Authority)
    private _rho = missionNamespace getVariable ["UKSFTA_Environment_AirDensity", 1.225];
    private _pos = getPosASL _projectile;
    private _alt = _pos select 2;
    
    // Altitude correction (ISA Standard Scale Height: 8500m)
    private _rho_alt = _rho * exp(-_alt / 8500);
    private _rhoRatio = _rho_alt / 1.225;

    // 2. SIDE-AIRFRICTION (Wind Drift Realism)
    // We adjust the drag and wind sensitivity based on air density
    private _sideDrag = getNumber (configFile >> "CfgAmmo" >> _ammo >> "sideAirFriction");
    if (_sideDrag > 0) then {
        // Density affects how much wind 'pushes' the bullet
        private _windMod = _rhoRatio; 
        _projectile setVariable ["UKSFTA_Ballistics_WindMod", _windMod];
    };

    // 3. DYNAMIC DRAG SCALING
    _projectile setVariable ["UKSFTA_Ballistics_DensityMod", _rhoRatio];

    // TRACER THERMAL SIGNATURE
    if (getNumber (configFile >> "CfgAmmo" >> _ammo >> "tracerScale") > 0) then {
        _projectile setVariable ["UKSFTA_IsTracer", true];
    };
}];

true
