/**
 * UKSFTA Environment - State Transition Logic
 * Calculates the next logical weather state based on current conditions.
 */

params ["_currentIdx", "_profile"];

// State Map: 0 = Clear, 1 = Overcast, 2 = Storm
// Transition Matrix (Probabilities):
// From 0: 70% stay at 0, 30% go to 1
// From 1: 30% back to 0, 40% stay at 1, 30% go to 2
// From 2: 40% back to 1, 60% stay at 2

private _nextIdx = _currentIdx;
private _roll = random 100;

switch (_currentIdx) do {
    case 0: { if (_roll > 70) then { _nextIdx = 1; }; };
    case 1: {
        if (_roll < 30) then { _nextIdx = 0; }
        else { if (_roll > 70) then { _nextIdx = 2; }; };
    };
    case 2: { if (_roll < 40) then { _nextIdx = 1; }; };
};

_nextIdx
