#include "..\script_component.hpp"
/**
 * UKSFTA Audio - UKSFTA World Alarm Engine (Phase 19)
 * Triggers building and car alarms in response to urban combat.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: World Alarm Engine Active.";

// 1. Urban Facility Alarms (Explosion Driven)
player addEventHandler ["Explosion", {
    params ["_unit", "_damage"];
    
    if !(missionNamespace getVariable ["uksfta_audio_enableAlarms", true]) exitWith {};
    
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
                        
                        // --- PREDATORY AI HOOK (Phase 20) ---
                        if (missionNamespace getVariable ["uksfta_ai_enableReactivity", true]) then {
                            private _nearAI = allUnits select { !isPlayer _x && { _x distance _house < 300 } };
                            if (_nearAI isNotEqualTo []) then {
                                [selectRandom _nearAI, _house] call (missionNamespace getVariable ["lambs_danger_fnc_assault", {params ["_u", "_p"];}]);
                            };
                        };
                        
                        sleep 4.2;
                    };
                    _house setVariable ["UKSFTA_Alarm_Active", nil];
                };
            };
        };
    };
}];

// 2. Realistic Car Alarms (Hit Driven) - Alarm + Horn Integration
private _fnc_addEH = missionNamespace getVariable ["CBA_fnc_addClassEventHandler", {params ["_c", "_e", "_code"];}];

["LandVehicle", "Hit", {
    params ["_unit", "_selection", "_damage", "_source", "_projectile"];
    
    if (_damage > 0.1 && {isNil {_unit getVariable "UKSFTA_Alarm_Active"}}) then {
        // Only trigger for non-armored civilian-style vehicles
        if (!(_unit isKindOf "Tank" || _unit isKindOf "Wheeled_APC_F" || _unit isKindOf "Air")) then {
            _unit setVariable ["UKSFTA_Alarm_Active", true];
            
            [_unit] spawn {
                params ["_veh"];
                
                // Select one of the two new realistic alarm sounds
                private _alarmSound = selectRandom [
                    "z\uksfta\addons\audio\sounds\world\Car_Alarm.ogg",
                    "z\uksfta\addons\audio\sounds\world\Car_Alarm1.ogg"
                ];
                
                // Realistic horns for layering
                private _hornSound = selectRandom [
                    "A3\Sounds_F\weapons\horns\car_horn_1.wss",
                    "A3\Sounds_F\weapons\horns\car_horn_2.wss"
                ];
                
                for "_i" from 1 to 40 do {
                    if (!alive _veh || isNull _veh) exitWith {};
                    
                    // Layer 1: The Alarm Beep
                    private _pitch = [1.0, 1.1] select (_i % 2 == 0);
                    playSound3D [_alarmSound, _veh, false, getPosASL _veh, 3, _pitch, 250];
                    
                    // Layer 2: The Horn (Synchronized rhythmic honking)
                    if (_i % 2 == 0) then {
                        playSound3D [_hornSound, _veh, false, getPosASL _veh, 2.5, 1.0, 300];
                    };
                    
                    sleep 0.6; // High-intensity alarm tempo
                };
                _veh setVariable ["UKSFTA_Alarm_Active", nil];
            };
        };
    };
}] call _fnc_addEH;

true
