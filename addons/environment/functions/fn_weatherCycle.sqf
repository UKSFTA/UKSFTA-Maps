#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Meteorological Engine (Gold Master)
 * Driven by ISA (International Standard Atmosphere) and Frontal System Simulation.
 * Real-world physics: Pressure, Density, and Moisture Saturation.
 */

if (!isServer) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Sovereign Meteorological Engine Initialized (Physics-Driven).";

// --- SIMULATION CONSTANTS ---
private _R = 287.058; // Gas constant for dry air
private _P0 = 1013.25; // Standard Sea Level Pressure (hPa)
private _T0 = 288.15; // Standard Sea Level Temp (K)

// --- GLOBAL ATMOSPHERE STATE ---
UKSFTA_Env_System_Pressure = 1013.25; // Current Barometric Pressure
UKSFTA_Env_System_Moisture = 0.5;    // Absolute Humidity (0-1)
UKSFTA_Env_System_Trend = 0;         // -1 (Stormy) to +1 (Clear)

// --- SMOOTHING & SYNC THREAD ---
[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
        private _sunAlt = call uksfta_environment_fnc_getSunElevation;
        
        // 1. DYNAMIC TEMPERATURE CALCULATION (ISA + Solar)
        // Base temp adjusted by pressure (Adiabatic heating/cooling approximation)
        private _baseT = 15;
        switch (_biome) do {
            case "ARCTIC": { _baseT = -10; };
            case "ARID": { _baseT = 30; };
            case "TROPICAL": { _baseT = 25; };
        };
        
        private _solarMod = (linearConversion [-10, 90, _sunAlt, -5, 10, true]);
        private _pressureMod = (UKSFTA_Env_System_Pressure - 1013.25) * 0.1;
        
        private _targetT = _baseT + _solarMod + _pressureMod;
        private _targetH = UKSFTA_Env_System_Moisture;

        // 2. SYNC TO ACE3 (The 'Authority' push)
        missionNamespace setVariable ["ace_weather_currentTemperature", _targetT, true];
        missionNamespace setVariable ["ace_weather_currentHumidity", _targetH, true];
        missionNamespace setVariable ["ace_weather_currentBarometricPressure", UKSFTA_Env_System_Pressure, true];
        
        // Force ACE update
        if (!isNil "ace_weather_fnc_updateTemperature") then { [true] call ace_weather_fnc_updateTemperature; };

        // 3. AIR DENSITY CALCULATION (For Ballistics)
        // rho = P / (R * T)
        private _tempK = _targetT + 273.15;
        private _density = (UKSFTA_Env_System_Pressure * 100) / (287.058 * _tempK);
        missionNamespace setVariable ["UKSFTA_Environment_AirDensity", _density, true];

        sleep 10;
    };
};

// --- MASTER METEOROLOGICAL EVOLUTION ---
while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    // 1. SIMULATE FRONTAL SYSTEMS
    // Randomize the 'Trend' (Atmospheric instability)
    UKSFTA_Env_System_Trend = (UKSFTA_Env_System_Trend + (random 0.2 - 0.1)) max -1 min 1;
    
    // Nudge pressure based on trend (Gradual shift)
    UKSFTA_Env_System_Pressure = (UKSFTA_Env_System_Pressure + (UKSFTA_Env_System_Trend * 2)) max 960 min 1040;
    
    // Moisture builds in Low Pressure, dries in High Pressure
    private _moistureDelta = if (UKSFTA_Env_System_Pressure < 1005) then { 0.05 } else { -0.02 };
    UKSFTA_Env_System_Moisture = (UKSFTA_Env_System_Moisture + _moistureDelta) max 0.1 min 1.0;

    // 2. RESOLVE VISUAL WEATHER (Gradual)
    // Overcast is a direct function of Low Pressure and Moisture
    private _targetOvercast = (linearConversion [1020, 980, UKSFTA_Env_System_Pressure, 0, 1, true] + (UKSFTA_Env_System_Moisture * 0.5)) min 1.0;
    
    // Rain triggers if Overcast > 0.7 AND Pressure is dropping
    private _targetRain = 0;
    if (_targetOvercast > 0.7 && UKSFTA_Env_System_Trend < 0) then {
        _targetRain = (UKSFTA_Env_System_Moisture * (1 - (UKSFTA_Env_System_Pressure / 1013))) max 0 min 1;
    };

    // 3. APPLY ENGINE TRANSITIONS (Very Gradual)
    private _transitionTime = 300 + (random 300); // 5-10 minute transitions
    _transitionTime setOvercast _targetOvercast;
    _transitionTime setRain _targetRain;
    
    // Fog scales with Humidity and Low Pressure
    private _fogVal = if (UKSFTA_Env_System_Moisture > 0.8) then { (UKSFTA_Env_System_Moisture - 0.8) * 2 } else { 0 };
    _transitionTime setFog [_fogVal, 0.03, 0];

    // 4. DYNAMIC WIND (Pressure Gradient approximation)
    private _windStr = abs(UKSFTA_Env_System_Trend * 15);
    setWind [_windStr, _windStr, true];

    diag_log format ["[UKSF] <MET>: P:%1 hPa | M:%2 | Overcast:%3 | Rain:%4 | Trend:%5", 
        round UKSFTA_Env_System_Pressure, 
        round (UKSFTA_Env_System_Moisture * 100), 
        round (_targetOvercast * 100),
        round (_targetRain * 100),
        UKSFTA_Env_System_Trend
    ];

    sleep _transitionTime;
};

true
