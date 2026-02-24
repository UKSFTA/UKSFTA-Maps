#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Sovereign World Alarm Engine (Phase 19)
 * Triggers building and car alarms in response to urban explosions.
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

// 2. Car Alarms (Hit Driven)
["LandVehicle", "Hit", {
    params ["_unit", "_selection", "_damage", "_source", "_projectile"];
    
    if (_damage > 0.1 && {isNil {_unit getVariable "UKSFTA_Alarm_Active"}}) then {
        _unit setVariable ["UKSFTA_Alarm_Active", true];
        
        [_unit] spawn {
            params ["_veh"];
            // Use realistic rhythmic car alarm
            private _sound = "z\uksfta\addons\audio\sounds\world\Siren_Alarm_1.ogg";
            
            for "_i" from 1 to 20 do {
                if (!alive _veh || isNull _veh) exitWith {};
                playSound3D [_sound, _veh, false, getPosASL _veh, 3, 1.2, 250];
                sleep 1.2; // Fast rhythmic car alarm
            };
            _veh setVariable ["UKSFTA_Alarm_Active", nil];
        };
    };
}] call (missionNamespace getVariable ["CBA_fnc_addClassEventHandler", {params ["_class", "_event", "_code"];}]);

true
