#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Thermal Management
 * Simulates atmospheric degradation of TI optics.
 */

if (!hasInterface) exitWith {};

// --- ABSOLUTE STARTUP GUARD ---
waitUntil { !isNil "uksfta_environment_enabled" };

while {missionNamespace getVariable ["uksfta_environment_enabled", false]} do {
    if (missionNamespace getVariable ["uksfta_environment_enableThermals", false]) then {
        private _overcast = overcast;
        private _fog = fog;
        private _noise = 0;

        if (_overcast > 0.7) then { _noise = (_overcast - 0.7) * 0.5; };
        if (_fog > 0.3) then { _noise = _noise + (_fog * 0.5); };

        // Scale by user setting
        private _intensity = missionNamespace getVariable ["uksfta_environment_thermalIntensity", 1.0];
        _noise = (_noise * _intensity) min 1.0;

        // --- Standard Macro Call ---
        if (_noise > 0.01) then {
            UKSFTA_SET_TI(TI_NOISE,_noise);
        } else {
            UKSFTA_SET_TI(TI_NOISE,0);
        };
    };

    sleep 2;
};
true
