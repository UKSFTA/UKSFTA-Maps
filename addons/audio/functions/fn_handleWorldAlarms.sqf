#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Sovereign World Alarm Engine (Phase 19)
 * Triggers building and car alarms in response to urban combat.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: World Alarm Engine Active.";

// 1. Urban Facility Alarms (Explosion Driven)
player addEventHandler ["Explosion", {
    params ["_unit", "_damage"];
    
    if (_damage > 0.5) then {
        // Find nearby buildings in an urban zone
        private _pos = getPosVisual player;
        private _houses = nearestObjects [_pos, ["House"], 150];
        
        if (count _houses > 5) then { // Only trigger in dense areas
            private _alarmHouse = selectRandom _houses;
            if (isNil {_alarmHouse getVariable "UKSFTA_Alarm_Active"}) then {
                _alarmHouse setVariable ["UKSFTA_Alarm_Active", true];
                
                [_alarmHouse] spawn {
                    params ["_house"];
                    // Use new high-fidelity facility alarm
                    private _sound = "z\uksfta\addons\audio\sounds\world\Facility_Alarm.ogg";
                    
                    // Alarm loop (Facility)
                    for "_i" from 1 to 12 do {
                        if (isNull _house) exitWith {};
                        playSound3D [_sound, _house, false, getPosASL _house, 4, 1, 400];
                        sleep 4.2;
                    };
                    _house setVariable ["UKSFTA_Alarm_Active", nil];
                };
            };
        };
    };
}];

// 2. Realistic Car Alarms (Hit Driven) - Direct EH Logic
// We use a broader EH to avoid SPE2 parser failure on mod variables
player addEventHandler ["FiredNear", {
    params ["_unit", "_shooter", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];
    
    // Simulate collateral damage alarms in urban centers
    if (_distance < 10) then {
        private _vehs = nearestObjects [_unit, ["Car", "Truck"], 30];
        if (_vehs isNotEqualTo []) then {
            private _veh = selectRandom _vehs;
            if (isNil {_veh getVariable "UKSFTA_Alarm_Active"}) then {
                _veh setVariable ["UKSFTA_Alarm_Active", true];
                [_veh] spawn {
                    params ["_v"];
                    private _alarmSound = "z\uksfta\addons\audio\sounds\world\Car_Alarm.ogg";
                    private _hornSound = "A3\Sounds_F\weapons\horns\car_horn_1.wss";
                    
                    for "_i" from 1 to 30 do {
                        if (!alive _v || isNull _v) exitWith {};
                        private _pitch = [1.0, 1.1] select (_i % 2 == 0);
                        playSound3D [_alarmSound, _v, false, getPosASL _v, 3, _pitch, 250];
                        if (_i % 2 == 0) then { playSound3D [_hornSound, _v, false, getPosASL _v, 2.5, 1.0, 300]; };
                        sleep 0.6;
                    };
                    _v setVariable ["UKSFTA_Alarm_Active", nil];
                };
            };
        };
    };
}];

true
