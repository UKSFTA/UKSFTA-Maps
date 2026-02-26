#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UKSFTA Ballistics Engine (Production)
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

    // --- 4. TRANSONIC INSTABILITY (RBO Synergy) ---
    // Projectiles become unstable as they drop to subsonic speeds
    [_projectile] spawn {
        params ["_projectile"];
        waitUntil {
            sleep 0.1;
            private _vel = vectorMagnitude (velocity _projectile);
            isNull _projectile || { _vel < 360 && _vel > 300 }
        };
        if (!isNull _projectile) then {
            // Apply slight random deflection to simulate instability
            private _deflection = [(random 0.2 - 0.1), (random 0.2 - 0.1), (random 0.2 - 0.1)];
            _projectile setVelocity ((velocity _projectile) vectorAdd _deflection);

            // --- TRANSONIC AUDIO FEEDBACK ---
            // Play a unique 'unstable' whiz sound at the projectile's location
            private _sound = selectRandom [
                "A3\Sounds_F\weapons\Closure\sfx_bullet_whiz_01.wss",
                "A3\Sounds_F\weapons\Closure\sfx_bullet_whiz_02.wss"
            ];
            playSound3D [_sound, _projectile, false, getPosASL _projectile, 2, 0.8 + (random 0.2), 50];
        };
    };

    // TRACER THERMAL SIGNATURE
    if (getNumber (configFile >> "CfgAmmo" >> _ammo >> "tracerScale") > 0) then {
        _projectile setVariable ["UKSFTA_IsTracer", true];
    };
}];

true
