/**
 * UKSFTA Environment - UAV & GPS Interference (EW)
 * BASE LAYER: Exports interference data for EW mods.
 */

if (!hasInterface) exitWith {};

while {true} do {
    if (uksfta_environment_enableUavInterference) then {
        private _overcast = overcast;
        private _uav = getConnectedUAV player;
        
        // --- 1. DATA CALCULATION ---
        // 0.0 = perfect link, 1.0 = total blackout
        private _ewInterference = if (_overcast > 0.6) then { (_overcast - 0.6) } else { 0 };
        if (rain > 0.5) then { _ewInterference = _ewInterference + 0.2; };
        _ewInterference = _ewInterference min 1.0;

        // --- 2. GLOBAL EXPORT ---
        // Third-party EW mods can read this to apply their own Feed Static / Signal Loss
        missionNamespace setVariable ["UKSFTA_Environment_EW_Level", _ewInterference, true];

        // --- 3. NATIVE VISUAL FALLBACK ---
        // Only apply if no other EW mod is handling it
        if (!isNull _uav && {missionNamespace getVariable ["UKSFTA_EW_OverrideActive", false] isEqualTo false}) then {
            if (_ewInterference > 0.2) then {
                private _jitter = _ewInterference * 0.05;
                "FilmGrain" ppEffectAdjust [_jitter, 1.25, 1, 0, 1];
                "FilmGrain" ppEffectCommit 2;
            };
        };
    };

    sleep 15;
};
