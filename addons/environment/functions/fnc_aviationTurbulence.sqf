/**
 * UKSFTA Environment - Aviation Turbulence Engine
 * Applies physical forces to aircraft during high overcast/storms.
 */

if (!hasInterface) exitWith {};

while {true} do {
    private _veh = objectParent player;
    
    // Only run if player is pilot/copilot of an Air vehicle
    if (uksfta_environment_enableTurbulence && !isNull _veh && { _veh isKindOf "Air" } && { (driver _veh == player || gunner _veh == player) }) then {
        
        private _overcast = overcast;
        if (_overcast > 0.4) then {
            
            // --- CALIBRATION ---
            private _speed = speed _veh;
            private _alt = (getPosATL _veh) select 2;
            
            // Turbulence is stronger at high speeds and lower altitudes (surface thermals)
            private _intensity = (_overcast * uksfta_environment_turbulenceIntensity);
            if (_alt < 500) then { _intensity = _intensity * 1.5; };
            if (_speed < 50) then { _intensity = _intensity * 0.2; }; // Minimum at hover
            
            // --- PHYSICS INJECTION ---
            // Random vector [X, Y, Z]
            private _forceX = (random 2 - 1) * _intensity * 500;
            private _forceY = (random 2 - 1) * _intensity * 500;
            private _forceZ = (random 4 - 2) * _intensity * 1000; // Stronger vertical 'bumps'
            
            // Apply relative to vehicle model
            _veh addForce [_veh vectorModelToWorld [_forceX, _forceY, _forceZ], [0,0,0]];
            
            // Low-latency loop for smooth physics (0.1s - 0.5s)
            sleep (0.1 + random 0.4);
        } else {
            sleep 2;
        };
    } else {
        sleep 5; // Deep sleep when not in aircraft
    };
};
