#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Tidal Engine (Phase 12)
 * Simulates procedural water level shifts and shoreline dynamics based on lunar phase.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Tidal Engine Active.";

UKSFTA_Env_TidalLevel = 0; // Relative offset in meters

[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        // 1. CALCULATE LUNAR INFLUENCE
        // moonPhase: 0 (New Moon), 0.5 (Full Moon), 1 (New Moon)
        private _phase = moonPhase date;
        private _intensity = moonIntensity;
        
        // Tidal strength is highest at New Moon (0/1) and Full Moon (0.5) -> Spring Tides
        private _lunarFactor = abs (cos (_phase * 360)); 
        
        // 2. CALCULATE TIME-BASED CYCLE (Semi-diurnal: 2 high, 2 low per day)
        // 24 hours = 1440 minutes. Cycle ~12.4 hours.
        private _dayMinutes = (dayTime * 60);
        private _tideCycle = sin (_dayMinutes * (360 / 744)); // 744 mins per half-lunar day
        
        // 3. RESOLVE TOTAL TIDAL OFFSET (-1.5m to +1.5m range)
        private _maxAmplitude = 1.5 * _lunarFactor;
        private _currentOffset = _tideCycle * _maxAmplitude;
        
        UKSFTA_Env_TidalLevel = _currentOffset;
        missionNamespace setVariable ["UKSFTA_Environment_TidalLevel", _currentOffset, true];

        // 4. SHORELINE DYNAMICS
        // If player is near water (<50m), adjust local environmental variables
        if (getPosASL player select 2 < 5) then {
            private _isNearWater = !(([(getPosASL player), 50] call (missionNamespace getVariable ["BIS_fnc_isUnderwater", {false}])) isEqualTo false);
            // BIS_fnc_isUnderwater check is slow, using surfaceType check instead for performance
            private _surface = surfaceType (getPosVisual player);
            if ("WATER" in (toUpper _surface) || (getPosASL player select 2 < _currentOffset)) then {
                // Force wetness accumulation if player is in the tidal zone
                missionNamespace setVariable ["UKSFTA_Environment_TidalWetness", 1.0];
            } else {
                missionNamespace setVariable ["UKSFTA_Environment_TidalWetness", 0];
            };
        };

        sleep 60; // Tidal shifts are slow
    };
};

true
