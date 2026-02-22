/**
 * UKSFTA Environment - KAT Medical & ACE Sensory Hook
 * High-fidelity integration with medical and sensory sub-systems.
 */

if (!hasInterface) exitWith {};

// Wait for system stability
waitUntil { time > 5 };

while {uksfta_environment_enabled} do {
    private _temp = missionNamespace getVariable ["ace_weather_currentTemperature", 20];
    private _humid = missionNamespace getVariable ["ace_weather_currentHumidity", 0.5];
    
    // 1. KAT MEDICAL INTEGRATION
    // Check if KAT temperature simulation is active
    if (!isNil "kat_temperature_enable") then {
        if (kat_temperature_enable) then {
            // Push values to KAT core
            player setVariable ["kat_medical_airTemperature", _temp, true];
            player setVariable ["kat_medical_airHumidity", _humid, true];
        };
    } else {
        // Fallback for older KAT versions or manual overrides
        missionNamespace setVariable ["kat_medical_currentTemperature", _temp, true];
    };

    // 2. ACE GOGGLES SYNERGY
    // ACE Goggles fogging is driven by 'ace_weather_currentHumidity'.
    // We ensure this is high in specific biomes to trigger the 'Wipe' requirement.
    if (!isNil "ace_goggles_fnc_applyGoggleEffects") then {
        // We don't need to call the function directly as ACE loops it,
        // but we ensure the environment state is 'Fresh' for the engine.
        if (rain > 0.5) then {
            // Force ACE to recognize active rain for goggle droplets
            [player, rain] call ace_goggles_fnc_applyGoggleEffects;
        };
    };

    // 3. PHYSIOLOGICAL FATIGUE SCALING
    // In extreme heat (>35C) or extreme humidity (>90%), increase stamina drain
    if (_temp > 35 || _humid > 0.9) then {
        private _fatigue = getFatigue player;
        if (speed player > 0 && _fatigue < 1) then {
            player setFatigue (_fatigue + 0.002);
        };
    };

    sleep 20; 
};
