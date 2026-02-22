/**
 * UKSFTA Environment - Heuristic Biome Analyzer
 */

// 1. Check for Eden Map Attribute first (Stored in mission metadata)
private _edenBiome = getMissionConfigValue ["UKSFTA_Environment_MissionBiome", ""];
if (_edenBiome != "" && _edenBiome != "AUTO") exitWith { toUpper _edenBiome };

// 2. Check for manual init.sqf variable override
private _missionBiome = missionNamespace getVariable ["UKSFTA_Environment_MissionBiome", ""];
if (_missionBiome != "") exitWith { toUpper _missionBiome };

// 3. Check for Global CBA Override
private _forced = uksfta_environment_forcedBiome;
if (_forced != "AUTO") exitWith { _forced };

private _world = configFile >> "CfgWorlds" >> worldName;
private _biome = "TEMPERATE";

// --- LATITUDE AUDIT ---
private _lat = getNumber (_world >> "latitude");
if (_lat < 0) then { _lat = abs _lat; };
if (_lat > 60) exitWith { "ARCTIC" };
if (_lat < 15) then { _biome = "TROPICAL"; };

// --- VEGETATION AUDIT ---
private _clutterConfig = _world >> "Clutter";
private _clutterSamples = configProperties [_clutterConfig, "isClass _x"];
private _clutterNames = "";
{
    _clutterNames = _clutterNames + (toLower (configName _x)) + " ";
} forEach (_clutterSamples select [0, 15]);

if ("sand" in _clutterNames || "desert" in _clutterNames || "cactus" in _clutterNames) exitWith { "ARID" };
if ("palm" in _clutterNames || "jungle" in _clutterNames || "liana" in _clutterNames) exitWith { "TROPICAL" };
if ("snow" in _clutterNames || "ice" in _clutterNames) exitWith { "ARCTIC" };

// --- KEYWORDS ---
private _name = toLower worldName;
if ("altis" in _name || "malden" in _name || "stratis" in _name || "dagger" in _name || "zagor" in _name) exitWith { "MEDITERRANEAN" };
if ("sahrani" in _name || "porto" in _name) exitWith { "SUBTROPICAL" };

_biome
