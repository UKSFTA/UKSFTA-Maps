/**
 * UKSFTA Environment - Aviation Turbulence Engine
 * COMPAT LAYER: Conflict-aware physics injection.
 */

if (!hasInterface) exitWith {};

while {true} do {
    private _veh = objectParent player;
    
    if (uksfta_environment_enableTurbulence && !isNull _veh && { _veh isKindOf "Air" } && { (driver _veh == player || gunner _veh == player) }) then {
        
        // --- CONFLICT CHECK ---
        // Checks if vehicle has native turbulence or specific high-fidelity flight systems
        // (e.g. AFM enabled or specific mod variables)
        private _hasNativePhys = _veh getVariable ["UKSFTA_HasCustomFlightModel", false];
        if (difficultyEnabled "RTD") then { _hasNativePhys = true; }; // Skip if Advanced Flight Model is on

        if (!_hasNativePhys && {overcast > 0.4}) then {
            private _speed = speed _veh;
            private _alt = (getPosATL _veh) select 2;
            private _intensity = (overcast * uksfta_environment_turbulenceIntensity);
            
            if (_alt < 400) then { _intensity = _intensity * 1.4; };
            if (_speed < 40) then { _intensity = _intensity * 0.1; }; 

            private _forceX = (random 2 - 1) * _intensity * 400;
            private _forceY = (random 2 - 1) * _intensity * 400;
            private _forceZ = (random 4 - 2) * _intensity * 800; 
            
            _veh addForce [_veh vectorModelToWorld [_forceX, _forceY, _forceZ], [0,0,0]];
            
            sleep (0.2 + random 0.3);
        } else {
            sleep 2;
        };
    } else {
        sleep 5;
    };
};
