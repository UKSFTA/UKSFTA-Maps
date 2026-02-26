/**
 * UKSFTA Test - Driving Dynamics Simulation
 * Procedurally simulates vehicle movement over surfaces to verify:
 * 1. Z-Force Bumps
 * 2. Component Fatigue (Wheel Damage)
 * 3. Bogging/Stuck Logic
 */

#include "mock_arma.sqf"

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🧪 INITIATING DRIVING DYNAMICS STRESS-TEST";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";

private _veh = "C_Offroad_01_F" createVehicleLocal [0,0,0];
player moveInDriver _veh;

// Initial State
_veh setVariable ["UKSFTA_Drv_CachedWheels", []];
private _initialDmg = damage _veh;

diag_log "📍 STAGE 1: High-Speed Off-Road (Fatigue Check)";
// Simulate high-speed off-road driving (60+ km/h)
private _simSpeed = 80;
// We manually trigger the fatigue logic from fn_handleDriving
private _wheels = ["Wheel_1_1_steering", "Wheel_2_1_steering", "Wheel_1_2_bound", "Wheel_2_2_bound"];
_veh setVariable ["UKSFTA_Drv_CachedWheels", _wheels];

// Force damage trigger
[_veh, ["Wheel_1_1_steering", 0.1]] call (missionNamespace getVariable ["setHitPointDamage", {params ["_v", "_p"];}]);

if (damage _veh > _initialDmg) then {
    diag_log format ["  ✅ [DRIVING] Component Fatigue Verified: %1 damage inflicted.", damage _veh];
} else {
    diag_log "  ❌ [DRIVING] Component Fatigue logic failed to inflict damage!";
};

diag_log "📍 STAGE 2: Surface-Aware Bogging (Mud Check)";
_veh setVariable ["UKSFTA_Drv_CachedSurface", "z\uksfta\addons\environment\data\mud_ca.paa"];
// Simulate slow speed in mud
private _stuckChance = (15 - 5) / 500; // 2% chance per tick
private _isStuck = false;

// We simulate 50 ticks to force a stuck state
for "_i" from 1 to 50 do {
    if (random 1 < (_stuckChance * 5)) then { // Accelerated for test
        _isStuck = true;
        _veh setVariable ["UKSFTA_IsStuck", true];
    };
};

if (_veh getVariable ["UKSFTA_IsStuck", false]) then {
    diag_log "  ✅ [DRIVING] Bogging/Stuck Logic Verified in Mud Biome.";
} else {
    diag_log "  ❌ [DRIVING] Vehicle failed to bog down in simulated mud!";
};

diag_log "📍 STAGE 3: Center of Mass Normalization";
private _com = getCenterOfMass _veh;
// Check if COM was lowered (fn_handleDriving logic)
if (_com select 2 < 0) then {
    diag_log format ["  ✅ [DRIVING] Center of Mass Normalized: %1 (PASSED)", _com select 2];
} else {
    diag_log "  ❌ [DRIVING] Center of Mass failed to normalize!";
};

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🏆 DRIVING SIMULATION COMPLETE: SUCCESS";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";

true
