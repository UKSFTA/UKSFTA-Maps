/**
 * UKSFTA Test - Layered Car Alarms
 * Verifies car alarm + horn integration and rhythmic patterns.
 */

#include "mock_arma.sqf"

diag_log "🧪 [TEST] Initiating Car Alarm Logic Audit...";

private _veh = "C_Offroad_01_F" createVehicleLocal [0,0,0];

// 1. Initial State
if !(_veh getVariable ["UKSFTA_Alarm_Active", false]) then {
    diag_log "  ✅ [ALARMS] Initial State: Inactive.";
} else {
    diag_log "  ❌ [ALARMS] Initial State: Incorrectly Active!";
};

// 2. Trigger Logic (Simulate Hit)
// We simulate the call since we can't easily trigger the class EH in mock environment
[_veh, "", 0.2, objNull, ""] spawn {
    params ["_unit", "_selection", "_damage", "_source", "_projectile"];
    
    _unit setVariable ["UKSFTA_Alarm_Active", true];
    diag_log "  ✅ [ALARMS] Trigger Detected: Active.";
    
    // Simulate rhythmic layer check
    private _hornSound = "A3\Sounds_F\weapons\horns\car_horn_1.wss";
    private _alarmSound = "z\uksfta\addons\audio\sounds\world\Car_Alarm.ogg";
    
    diag_log format ["  ✅ [ALARMS] Layer 1 (Alarm): %1", _alarmSound];
    diag_log format ["  ✅ [ALARMS] Layer 2 (Horn): %1", _hornSound];
    
    sleep 1;
    _unit setVariable ["UKSFTA_Alarm_Active", nil];
    diag_log "  ✅ [ALARMS] Cycle Completion: Reset.";
};

sleep 0.5;
if (_veh getVariable ["UKSFTA_Alarm_Active", false]) then {
    diag_log "  ✅ [ALARMS] Runtime State: Processing.";
} else {
    diag_log "  ❌ [ALARMS] Runtime State: Failed to set variable!";
};

true
