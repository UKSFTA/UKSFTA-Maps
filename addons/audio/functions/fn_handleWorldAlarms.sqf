#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Sovereign World Alarm Engine (Phase 19)
 * Triggers building and car alarms in response to urban explosions.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: World Alarm Engine Active.";

player addEventHandler ["Explosion", {
    params ["_unit", "_damage"];
    
    if (_damage > 0.5) then {
        // Find nearby buildings in an urban zone
        private _pos = getPosVisual player;
        private _houses = nearestObjects [_pos, ["House"], 100];
        
        if (count _houses > 5) then { // Only trigger in dense areas
            private _alarmHouse = selectRandom _houses;
            if (isNil {_alarmHouse getVariable "UKSFTA_Alarm_Active"}) then {
                _alarmHouse setVariable ["UKSFTA_Alarm_Active", true];
                
                [_alarmHouse] spawn {
                    params ["_house"];
                    private _sound = selectRandom [
                        "z\uksfta\addons\audio\sounds\world\Burglar_Alarm.ogg",
                        "z\uksfta\addons\audio\sounds\world\Siren_Alarm_1.ogg"
                    ];
                    
                    // Alarm loop
                    for "_i" from 1 to 10 do {
                        if (isNull _house) exitWith {};
                        playSound3D [_sound, _house, false, getPosASL _house, 3, 1, 300];
                        sleep 5;
                    };
                    _house setVariable ["UKSFTA_Alarm_Active", nil];
                };
            };
        };
    };
}];

true
