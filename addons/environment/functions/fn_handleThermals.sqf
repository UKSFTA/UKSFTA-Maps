#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Thermal Interference Engine
 */

if (!hasInterface) exitWith {};

waitUntil { !isNil "uksfta_environment_enableThermals" };

while {uksfta_environment_enabled} do {
    if (uksfta_environment_enabled && uksfta_environment_enableThermals) then {
        private _overcast = overcast;
        private _rain = rain;
        private _fog = fog;
        private _intensity = uksfta_environment_thermalIntensity;
        private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
        
        private _multiplier = [1.0, 0.2] select (uksfta_environment_preset == "ARCADE");
        private _noise = ((_overcast * 0.2) + (_rain * 0.3) + (_fog * 0.5)) * _multiplier;
        _noise = (_noise * _intensity) min 1.0;

        private _sunAlt = call uksfta_environment_fnc_getSunElevation;
        if (uksfta_environment_preset == "REALISM" && _biome == "ARID" && (_sunAlt > 20)) then {
            private _heatFactor = (_sunAlt / 90.0) * 0.4;
            _noise = (_noise + _heatFactor) min 1.0;
        };

        UKSFTA_SET_TI(0,_noise);
        UKSFTA_SET_TI(1,_noise * 0.5);

        if (uksfta_environment_preset == "REALISM" && (lightnings > 0.8) && (_overcast > 0.9)) then {
            if (random 100 > 90) then {
                UKSFTA_SET_TI(0,1.0);
                UKSFTA_SET_TI(1,1.0);
                sleep (0.1 + random 0.5);
            };
        };

    } else {
        UKSFTA_SET_TI(0,0);
        UKSFTA_SET_TI(1,0);
    };

    sleep 10;
};
true
