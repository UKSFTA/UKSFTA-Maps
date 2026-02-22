/**
 * UKSFTA Environment - Optimized Biome Analyzer
 * Scheduled execution to prevent join-time freezes.
 */

// 1. Instant Cache Check
private _cached = missionNamespace getVariable ["UKSFTA_Environment_Biome", ""];
if (_cached != "") exitWith { _cached };

// 2. Check for Overrides (Instant)
private _edenBiome = getMissionConfigValue ["UKSFTA_Environment_MissionBiome", ""];
private _missionBiome = missionNamespace getVariable ["UKSFTA_Environment_MissionBiome", ""];
private _forced = missionNamespace getVariable ["uksfta_environment_forcedBiome", "AUTO"];

private _biome = "TEMPERATE";

if (_edenBiome != "" && _edenBiome != "AUTO") exitWith { _biome = toUpper _edenBiome; _biome };
if (_missionBiome != "") exitWith { _biome = toUpper _missionBiome; _biome };
if (_forced != "AUTO") exitWith { _forced };

// 3. Heuristic Engine (Distributed)
private _world = configFile >> "CfgWorlds" >> worldName;
private _lat = getNumber (_world >> "latitude");
if (_lat < 0) then { _lat = abs _lat; };

if (_lat > 60) then { _biome = "ARCTIC"; }
else {
    if (_lat < 15) then { _biome = "TROPICAL"; }
    else {
        // Optimization: Use a string search on the name first (Linter compliant find)
        private _name = toLower worldName;
        if ((_name find "altis" != -1) || (_name find "malden" != -1) || (_name find "stratis" != -1) || (_name find "dagger" != -1) || (_name find "zagor" != -1)) then { 
            _biome = "MEDITERRANEAN"; 
        } else {
            if ((_name find "sahrani" != -1) || (_name find "porto" != -1)) then { 
                _biome = "SUBTROPICAL"; 
            } else {
                // Last Resort: Scan Clutter (Slowest)
                private _clutterNames = "";
                { 
                    _clutterNames = _clutterNames + (toLower (configName _x)) + " "; 
                } forEach (configProperties [_world >> "Clutter", "isClass _x"] select [0, 5]);
                
                if ((_clutterNames find "sand" != -1) || (_clutterNames find "desert" != -1)) then { _biome = "ARID"; }
                else {
                    if ((_clutterNames find "palm" != -1) || (_clutterNames find "jungle" != -1)) then { _biome = "TROPICAL"; }
                    else {
                        if ((_clutterNames find "snow" != -1) || (_clutterNames find "ice" != -1)) then { _biome = "ARCTIC"; };
                    };
                };
            };
        };
    };
};

missionNamespace setVariable ["UKSFTA_Environment_Biome", _biome, true];
_biome
