#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UKSFTA Meteorological Engine (Multiplayer Optimized)
 * Driven by ISA (International Standard Atmosphere) and Frontal System Simulation.
 */

if (!isServer) exitWith {};

LOG("Meteorological Suite Initialized (Physics-Driven).");

// --- SIMULATION CONSTANTS ---
private _R = 287.058; // Gas constant for dry air
private _P0 = 1013.25; // Standard Sea Level Pressure (hPa)
private _T0 = 288.15; // Standard Sea Level Temp (K)

// --- GLOBAL ATMOSPHERE STATE ---
UKSFTA_Env_System_Pressure = 1013.25; 
UKSFTA_Env_System_Moisture = 0.5;    
UKSFTA_Env_System_Trend = 0;         

// Centralized state-check for clients (JIP Friendly)
missionNamespace setVariable ["UKSFTA_Env_State_Pressure", UKSFTA_Env_System_Pressure, true];
missionNamespace setVariable ["UKSFTA_Env_State_Moisture", UKSFTA_Env_System_Moisture, true];

// --- SMOOTHING & SYNC THREAD ---
[] spawn {
    private _fnc_setCloud = missionNamespace getVariable ["setCloudColor", {params ["_r", "_g", "_b"];}];
    
    while {missionNamespace getVariable [QGVAR(enabled), true]} do {
        private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
        private _sunAlt = call uksfta_environment_fnc_getSunElevation;
        
        // 1. DYNAMIC TEMPERATURE CALCULATION (ISA + Solar)
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
        
        if (!isNil "ace_weather_fnc_updateTemperature") then { [true] call ace_weather_fnc_updateTemperature; };

        // 3. AIR DENSITY CALCULATION (For Ballistics)
        private _tempK = _targetT + 273.15;
        private _density = (UKSFTA_Env_System_Pressure * 100) / (287.058 * _tempK);
        missionNamespace setVariable ["UKSFTA_Environment_AirDensity", _density, true];

        sleep 10;
    };
};

// --- MASTER METEOROLOGICAL EVOLUTION ---
[
    {
        if !(missionNamespace getVariable [QGVAR(enabled), true] && {missionNamespace getVariable [QGVAR(envNaturalism), true]}) exitWith {};

        // Gradual Pressure Nudge
        UKSFTA_Env_Server_Trend = (UKSFTA_Env_Server_Trend + (random 0.1 - 0.05)) max -1 min 1;
        UKSFTA_Env_Server_Pressure = (UKSFTA_Env_Server_Pressure + (UKSFTA_Env_Server_Trend * 1.5)) max 960 min 1040;
        
        private _moistureDelta = if (UKSFTA_Env_Server_Pressure < 1005) then { 0.02 } else { -0.01 };
        UKSFTA_Env_Server_Moisture = (UKSFTA_Env_Server_Moisture + _moistureDelta) max 0.1 min 1.0;

        // Broadcast only if significant change (>0.5% shift)
        private _oldP = missionNamespace getVariable ["UKSFTA_Env_State_Pressure", 1013];
        if (abs(_oldP - UKSFTA_Env_Server_Pressure) > 0.5) then {
            missionNamespace setVariable ["UKSFTA_Env_State_Pressure", UKSFTA_Env_Server_Pressure, true];
            missionNamespace setVariable ["UKSFTA_Env_State_Moisture", UKSFTA_Env_Server_Moisture, true];
        };

        // Resolve Visual Targets
        private _targetOvercast = (linearConversion [1020, 980, UKSFTA_Env_Server_Pressure, 0, 1, true] + (UKSFTA_Env_Server_Moisture * 0.5)) min 1.0;
        private _targetRain = if (_targetOvercast > 0.7 && UKSFTA_Env_Server_Trend < 0) then { (UKSFTA_Env_Server_Moisture * 0.2) } else { 0 };

        600 setOvercast _targetOvercast;
        60 setRain _targetRain;
        simulWeatherSync;

        if (missionNamespace getVariable [QGVAR(logLevel), 1] >= 2) then {
            diag_log text (format ["[UKSF] <TRACE> [MET]: P:%1 hPa | M:%2", round UKSFTA_Env_Server_Pressure, round (UKSFTA_Env_Server_Moisture * 100)]);
        };
    },
    10 
] call CBA_fnc_addPerFrameHandler;

true
