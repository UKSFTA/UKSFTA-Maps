/**
 * UKSFTA Environment - Heuristic Biome Analyzer
 * DATA PROVIDER: Exports biome state for all systems.
 */

// 1. Check for Overrides
private _edenBiome = getMissionConfigValue ["UKSFTA_Environment_MissionBiome", ""];
private _missionBiome = missionNamespace getVariable ["UKSFTA_Environment_MissionBiome", ""];
private _forced = uksfta_environment_forcedBiome;

private _biome = "TEMPERATE";

if (_edenBiome != "" && _edenBiome != "AUTO") then { _biome = toUpper _edenBiome; }
else {
    if (_missionBiome != "") then { _biome = toUpper _missionBiome; }
    else {
        if (_forced != "AUTO") then { _biome = _forced; }
        else {
            private _world = configFile >> "CfgWorlds" >> worldName;
            private _lat = getNumber (_world >> "latitude");
            if (_lat < 0) then { _lat = abs _lat; };
            
            if (_lat > 60) then { _biome = "ARCTIC"; }
            else {
                if (_lat < 15) then { _biome = "TROPICAL"; }
                else {
                    private _clutterNames = "";
                    { _clutterNames = _clutterNames + (toLower (configName _x)) + " "; } forEach (configProperties [_world >> "Clutter", "isClass _x"] select [0, 15]);
                    
                    if ("sand" in _clutterNames || "desert" in _clutterNames) then { _biome = "ARID"; }
                    else {
                        if ("palm" in _clutterNames || "jungle" in _clutterNames) then { _biome = "TROPICAL"; }
                        else {
                            if ("snow" in _clutterNames || "ice" in _clutterNames) then { _biome = "ARCTIC"; }
                            else {
                                private _name = toLower worldName;
                                if ("altis" in _name || "malden" in _name || "stratis" in _name || "dagger" in _name || "zagor" in _name) then { _biome = "MEDITERRANEAN"; }
                                else { if ("sahrani" in _name || "porto" in _name) then { _biome = "SUBTROPICAL"; }; };
                            };
                        };
                    };
                };
            };
        };
    };
};

missionNamespace setVariable ["UKSFTA_Environment_Biome", _biome, true];
_biome
