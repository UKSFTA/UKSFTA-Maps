#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UKSFTA Compatibility Bridge (Phase 16)
 * Actively syncs UKSFTA environmental data to external mod variables (ACE, TFAR, LAMBS, etc).
 */

if (!hasInterface && !isServer) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Compatibility Bridge Active.";

[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _unit = player;
        if (!hasInterface) then { _unit = objNull; }; // Server logic below

        // --- 1. ACE3 WEATHER & MEDICAL SYNC (Client Side) ---
        if (hasInterface && {isClass (configFile >> "CfgPatches" >> "ace_weather")}) then {
            private _localTemp = missionNamespace getVariable ["UKSFTA_Environment_LocalTemp", 20];
            private _localHumid = missionNamespace getVariable ["UKSFTA_Environment_GlobalHumid", 0.5];
            private _localWind = missionNamespace getVariable ["UKSFTA_Environment_WindSpeed", 0];
            
            // Push UKSFTA Temp to ACE
            missionNamespace setVariable ["ace_weather_currentTemperature", _localTemp];
            missionNamespace setVariable ["ace_weather_currentHumidity", _localHumid];
            
            // Force ACE update
            if (!isNil "ace_weather_fnc_updateTemperature") then {
                [true] call ace_weather_fnc_updateTemperature;
            };
            
            // Sync Breath Rate to ACE Stamina
            private _respRate = missionNamespace getVariable ["UKSFTA_Environment_BreathRate", 16];
            if (_respRate > 30) then {
                // High stress = faster stamina loss
                _unit setVariable ["ace_advanced_fatigue_anreserve", (_unit getVariable ["ace_advanced_fatigue_anreserve", 2300]) - 5];
            };
        };

        // --- 2. RADIO SIGNAL LOSS (TFAR / ACRE) ---
        // We simulate interference via terrain/weather
        if (hasInterface) then {
            private _interference = 1.0;
            private _storm = rain > 0.5 || overcast > 0.8;
            
            if (_storm) then { _interference = 0.8; }; // 20% degradation
            if (missionNamespace getVariable ["UKSFTA_Environment_LocalBiome", ""] == "ARID" && windStr > 5) then { _interference = 0.7; }; // Sandstorm
            
            // TFAR Sync
            if (isClass (configFile >> "CfgPatches" >> "tfar_core")) then {
                _unit setVariable ["tf_receivingDistanceMultiplicator", _interference];
                _unit setVariable ["tf_transmittingDistanceMultiplicator", _interference];
            };
            
            // ACRE Sync
            if (isClass (configFile >> "CfgPatches" >> "acre_main")) then {
                // ACRE signal loss uses simpler occlusion, but we can hint loss via custom signal
                if (_interference < 0.8) then {
                    // Logic to degrade signal quality (placeholder for ACRE API)
                };
            };
        };

        // --- 3. AI SKILL & SUPPRESSION (LAMBS / VCOM) - SERVER SIDE ---
        if (isServer) then {
            private _globalVisibility = 1.0;
            if (rain > 0.5) then { _globalVisibility = 0.6; };
            if (fog > 0.3) then { _globalVisibility = _globalVisibility - (fog * 0.5); };
            
            // Adjust AI aiming accuracy based on weather
            {
                if (!isPlayer _x && local _x) then {
                    private _baseSkill = _x getVariable ["UKSFTA_BaseSkill", -1];
                    if (_baseSkill == -1) then {
                        _baseSkill = skill _x;
                        _x setVariable ["UKSFTA_BaseSkill", _baseSkill];
                    };
                    
                    // Reduce skill in bad weather (LAMBS compatible)
                    private _weatherMod = _globalVisibility max 0.2;
                    _x setSkill ["aimingAccuracy", (_baseSkill * _weatherMod)];
                    _x setSkill ["spotDistance", (_baseSkill * _weatherMod)];
                    
                    // VCOM / LAMBS Suppression Handling
                    // If UKSFTA Stress is high on AI, force suppression state
                    // (Requires AI stress logic, placeholder for now)
                };
            } forEach allUnits;
        };

        sleep 5;
    };
};

true
