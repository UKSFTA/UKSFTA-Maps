/**
 * UKSFTA Environment - Cold Vapor Engine
 * Performance Optimized with Client Controls.
 */

if (!hasInterface) exitWith {};

// --- VAPOR PARTICLE SOURCE ---
private _vaporSource = "#particlesource" createVehicleLocal [0,0,0];
_vaporSource setParticleParams [
    ["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 13, 0], "", "Billboard", 
    1, 0.5, [0, 0, 0], [0, 0.2, -0.2], 1, 1.275, 1, 0, 
    [0, 0.2, 0], [[1, 1, 1, 0.05], [1, 1, 1, 0.01], [1, 1, 1, 0]], 
    [1000], 1, 0.04, "", "", objNull
];
_vaporSource setParticleRandom [
    2, [0, 0, 0], [0.25, 0.25, 0.25], 0, 0.5, 
    [0, 0, 0, 0.1], 0, 0, 10
];
_vaporSource setDropInterval 0; // Off by default

while {true} do {
    // 1. Check Master Enable + Client Toggle
    if (!uksfta_environment_enabled || !uksfta_environment_enableColdBreath || uksfta_environment_particleMultiplier <= 0) then {
        _vaporSource setDropInterval 0;
        sleep 5; // DEEP SLEEP when disabled
    } else {
        // 2. Get Temperature
        private _temp = missionNamespace getVariable ["ace_weather_currentTemperature", 20];
        
        // 3. Physical Conditions (Cold + Foot + Alive)
        if (_temp < 8 && alive player && isNull objectParent player && (getPosASL player) select 2 > -1) then {
            
            _vaporSource attachTo [player, [0, 0.15, 0], "head"];
            
            private _fatigue = getFatigue player;
            private _rate = 2 + (4 * _fatigue);
            
            // Adjust emission rate by client multiplier
            private _dropInterval = 0.1 / (uksfta_environment_particleMultiplier max 0.01);
            
            _vaporSource setDropInterval _dropInterval;
            sleep 0.5; // Exhale
            _vaporSource setDropInterval 0; // Stop
            sleep (10 / _rate); // Inhale
            
        } else {
            _vaporSource setDropInterval 0;
            sleep 2; // Medium sleep when conditions not met
        };
    };
};
