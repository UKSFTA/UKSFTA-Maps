/**
 * UKSFTA Environment - Thermal Interference Engine
 */

if (!hasInterface) exitWith {};

while {uksfta_environment_enabled} do {
    if (uksfta_environment_enabled && uksfta_environment_enableThermals) then {
        private _overcast = overcast;
        private _rain = rain;
        private _fog = fog;
        private _intensity = uksfta_environment_thermalIntensity;
        private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
        
        // --- PRESET SCALING (Optimized) ---
        private _multiplier = [1.0, 0.2] select (uksfta_environment_preset == "ARCADE");

        private _noise = ((_overcast * 0.2) + (_rain * 0.3) + (_fog * 0.5)) * _multiplier;
        _noise = (_noise * _intensity) min 1.0;

        if (uksfta_environment_preset == "REALISM" && _biome == "ARID" && sunElevation > 20) then {
            private _heatFactor = (sunElevation / 90) * 0.4;
            _noise = (_noise + _heatFactor) min 1.0;
        };

        setTIParameter ["noise", _noise];
        setTIParameter ["grain", _noise * 0.5];

        if (uksfta_environment_preset == "REALISM" && lightnings > 0.8 && _overcast > 0.9) then {
            if (random 100 > 90) then {
                setTIParameter ["noise", 1.0];
                setTIParameter ["grain", 1.0];
                sleep (0.1 + random 0.5);
            };
        };

    } else {
        setTIParameter ["noise", 0];
        setTIParameter ["grain", 0];
    };

    sleep 10;
};
true
