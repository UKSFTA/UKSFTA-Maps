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
        // Optimization: Use a string comparison on the name first (Instant)
        private _name = toLower worldName;
        if ("altis" in _name || "malden" in _name || "stratis" in _name || "dagger" in _name || "zagor" in _name) then { 
            _biome = "MEDITERRANEAN"; 
        } else {
            if ("sahrani" in _name || "porto" in _name) then { 
                _biome = "SUBTROPICAL"; 
            } else {
                // Last Resort: Scan Clutter (Slowest)
                // We limit the scan to ensure performance
                private _clutterNames = "";
                { 
                    _clutterNames = _clutterNames + (toLower (configName _x)) + " "; 
                } forEach (configProperties [_world >> "Clutter", "isClass _x"] select [0, 5]);
                
                if ("sand" in _clutterNames || "desert" in _clutterNames) then { _biome = "ARID"; }
                else {
                    if ("palm" in _clutterNames || "jungle" in _clutterNames) then { _biome = "TROPICAL"; }
                    else {
                        if ("snow" in _clutterNames || "ice" in _clutterNames) then { _biome = "ARCTIC"; };
                    };
                };
            };
        };
    };
};

missionNamespace setVariable ["UKSFTA_Environment_Biome", _biome, true];
_biome
