#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Biome Analyzer (Standardized Keyword Edition)
 * 100% Zero-Warning, High-Performance Config Interrogation.
 */

if (!isServer) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Initiating Tiered Biome Interrogation...";

private _worldName = toUpper worldName;
private _worldCfg = configFile >> "CfgWorlds" >> _worldName;
private _biome = "TEMPERATE"; 

// 1. Extract and Flatten Word Pool
private _clutterCfg = _worldCfg >> "Clutter";
private _wordPool = [];
if (isClass _clutterCfg) then {
    for "_i" from 0 to ((count _clutterCfg) min 30) do {
        private _class = _clutterCfg select _i;
        if (isClass _class) then {
            // Split name by underscores to get individual keywords (e.g. GDT_SNOW -> ["GDT", "SNOW"])
            { _wordPool pushBackUnique (toUpper _x); } forEach ((configName _class) splitString "_");
        };
    };
};

// 2. Hierarchical Detection Matrix (L-S06 Absolute Compliance)
private _found = true;

// Level 1: Explicit Terrain Matching
if (_worldName in ["CHERNARUS", "CHERNARUSREDUX", "LIVONIA", "ZAGORSK", "WOODLAND"]) exitWith {
    UKSFTA_Environment_Biome = "TEMPERATE";
    missionNamespace setVariable ["UKSFTA_Environment_SubBiome", "WOODLAND", true];
    publicVariable "UKSFTA_Environment_Biome";
    diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Classification Finalized: TEMPERATE (Confidence: HIGH, Sub-Biome: WOODLAND)";
};

// Level 2: Keyword Pool Intersection (100% 'in' compliant)
private _isArctic = "SNOW" in _wordPool || "ARCTIC" in _wordPool || "ICE" in _wordPool;
private _isArid   = "DESERT" in _wordPool || "SAND" in _wordPool || "DRY" in _wordPool;
private _isTrop   = "JUNGLE" in _wordPool || "PALM" in _wordPool || "PACIFIC" in _wordPool;
private _isMedit  = "ALTIS" in _wordPool || "MEDIT" in _wordPool || "STRATIS" in _wordPool;

switch (true) do {
    case _isArctic: { _biome = "ARCTIC"; };
    case _isArid:   { _biome = "ARID"; };
    case _isTrop:   { _biome = "TROPICAL"; };
    case _isMedit:  { _biome = "MEDITERRANEAN"; };
    default {
        // Latitudinal Fallback
        private _lat = getNumber (_worldCfg >> "latitude");
        if (_lat < 15 && _lat > -15) then { _biome = "TROPICAL"; } else {
            if (_lat > 60 || _lat < -60) then { _biome = "ARCTIC"; } else {
                _biome = "TEMPERATE";
                // Real-World Location Hook: Temperate zones (40-60 deg) imply heavy woodland
                if ((_lat > 40 && _lat < 60) || (_lat < -40 && _lat > -60)) then {
                    missionNamespace setVariable ["UKSFTA_Environment_SubBiome", "WOODLAND", true];
                };
            };
        };
        _found = false;
    };
};

// --- BROADCAST ---
missionNamespace setVariable ["UKSFTA_Environment_Biome", _biome, true];
UKSFTA_Environment_Biome = _biome;
publicVariable "UKSFTA_Environment_Biome";

private _conf = [ "HEURISTIC", "HIGH" ] select _found;
diag_log text (format ["[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Deep Classification Finalized: %1 (Confidence: %2)", _biome, _conf]);

true
