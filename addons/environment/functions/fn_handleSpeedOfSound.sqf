#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Speed of Sound Engine (Phase 16)
 * Simulates audio propagation delay for distant explosions and shots.
 */

params ["_source", "_soundFile", "_range"];

if (isNull _source) exitWith {};

private _dist = player distance _source;
if (_dist < 50) exitWith { 
    // Instant play for close range
    playSound3D [_soundFile, _source, false, getPosASL _source, 5, 1, _range]; 
};

// Speed of Sound ~343 m/s
private _delay = _dist / 343;

// Schedule the delayed sound
[_soundFile, _source, _range, _delay] spawn {
    params ["_file", "_obj", "_rng", "_time"];
    sleep _time;
    if (alive _obj || !isNull _obj) then {
        playSound3D [_file, _obj, false, getPosASL _obj, 5, 1, _rng];
    } else {
        // Fallback position if object deleted
        playSound3D [_file, objNull, false, getPosASL _obj, 5, 1, _rng];
    };
};

true
