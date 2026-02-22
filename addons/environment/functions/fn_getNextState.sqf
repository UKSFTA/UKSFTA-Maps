/**
 * UKSFTA Environment - Weather State Machine
 */

params ["_current"];

// Calculate probabilities for transitions
private _next = _current;
private _roll = random 100;

switch (_current) do {
    case 0: { // CLEAR
        if (_roll > 85) then { _next = 1; }; // 15% chance to Overcast
    };
    case 1: { // OVERCAST
        if (_roll < 20) then { _next = 0; }; // 20% chance to Clear
        if (_roll > 80) then { _next = 2; }; // 20% chance to Storm
    };
    case 2: { // STORM
        if (_roll < 40) then { _next = 1; }; // 40% chance to Overcast
    };
};

_next
