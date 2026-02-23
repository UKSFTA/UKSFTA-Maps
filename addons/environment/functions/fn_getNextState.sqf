#include "..\script_component.hpp"
/**
 * UKSFTA Environment - High-Fidelity State Machine
 * Returns: [_overcast, _rain, _fog, _wind, _duration]
 */

params [
    ["_biome", "TEMPERATE"]
];

private _overcast = 0;
private _rain = 0;
private _fog = 0;
private _wind = 2 + random 5;
private _duration = 600 + random 1200; // 10-30 minute states

switch (toUpper _biome) do {
    case "ARID": {
        _overcast = random 0.3;
        _rain = 0;
        _fog = 0;
        _wind = 5 + random 10;
    };
    case "TROPICAL": {
        _overcast = 0.4 + random 0.6;
        _rain = if (_overcast > 0.7) then { 0.2 + random 0.8 } else { 0 };
        _fog = random 0.2;
        _wind = 2 + random 4;
    };
    case "ARCTIC": {
        _overcast = 0.2 + random 0.8;
        _rain = 0; // Snow is handled by visuals
        _fog = if (_overcast > 0.6) then { 0.1 + random 0.4 } else { 0 };
        _wind = 8 + random 12;
    };
    case "MEDITERRANEAN": {
        _overcast = random 0.5;
        _rain = if (_overcast > 0.8) then { 0.1 + random 0.3 } else { 0 };
        _fog = 0;
        _wind = 3 + random 6;
    };
    default { // TEMPERATE
        _overcast = random 1.0;
        _rain = if (_overcast > 0.7) then { random 0.5 } else { 0 };
        _fog = if (_overcast > 0.8) then { random 0.2 } else { 0 };
        _wind = 2 + random 8;
    };
};

// Returns the final state vector
[_overcast, _rain, _fog, _wind, _duration]
