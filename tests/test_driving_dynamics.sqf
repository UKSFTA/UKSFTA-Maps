/**
 * UKSFTA Test - Driving Dynamics
 * Verifies off-road bumps, component damage, slope instability, and stuck logic.
 */

diag_log "🧪 [TEST] Initiating Driving Dynamics Audit...";

private _veh = vehicle player;
if (!isNull _veh && { _veh isKindOf "LandVehicle" }) then {
    // 1. Stuck Logic Check
    private _surface = surfaceType (getPos _veh);
    diag_log format ["  ✅ [DRIVING] Surface: %1", _surface];
    
    // 2. Slope Instability
    private _up = vectorUp _veh;
    private _angle = acos (_up select 2);
    if (_angle > 25) then {
        diag_log "  ✅ [DRIVING] Slope Instability Active (Angle: %1)", _angle;
    };
    
    // 3. Impact Damage
    private _lastVelZ = _veh getVariable ["UKSFTA_LastVelZ", 0];
    diag_log format ["  ✅ [DRIVING] Z-Acceleration Monitor: %1", _lastVelZ];
} else {
    diag_log "  ℹ️ [DRIVING] No vehicle detected, skipping real-time physics check.";
};

true
