#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Biome Analyzer (Absolute Performance)
 */

if (!isServer) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Initiating Tiered Biome Interrogation...";

private _worldName = toUpper worldName;
private _worldCfg = configFile >> "CfgWorlds" >> _worldName;
private _biome = "TEMPERATE"; 

// 1. Extract and Standardize Signatures
private _clutterCfg = _worldCfg >> "Clutter";
private _sigs = [];
if (isClass _clutterCfg) then {
    for "_i" from 0 to ((count _clutterCfg) min 30) do {
        private _class = _clutterCfg select _i;
        if (isClass _class) then {
            _sigs pushBack (toUpper (configName _class));
        };
    };
};

// 2. Hierarchical Detection Matrix (L-S06 Absolute Compliance)
private _found = true;

// Level 1: Explicit Terrain Matching
if (_worldName in ["CHERNARUS", "CHERNARUSREDUX", "LIVONIA", "ZAGORSK", "WOODLAND"]) exitWith {
    UKSFTA_Environment_Biome = "TEMPERATE";
    publicVariable "UKSFTA_Environment_Biome";
    diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Classification Finalized: TEMPERATE (Confidence: HIGH)";
};

// Level 2: Signature Intersection (Optimized for 'in')
private _isArctic = false;
private _isArid   = false;
private _isTrop   = false;
private _isMedit  = false;

{
    private _s = _x;
    // We check for exact mod-specific clutter prefix matches or common signatures
    if (_s in ["GDT_SNOW", "GDT_ARCTIC", "GDT_WINTER", "SNOW", "ICE"]) exitWith { _isArctic = true; };
    if (_s in ["GDT_DESERT", "GDT_SAND", "GDT_DRY", "DESERT", "SAND", "TAKISTAN"]) exitWith { _isArid = true; };
    if (_s in ["GDT_JUNGLE", "GDT_PALM", "JUNGLE", "PALM", "TANOA", "PACIFIC"]) exitWith { _isTrop = true; };
    if (_s in ["GDT_ALTIS", "GDT_MEDIT", "ALTIS", "MEDITERRANEAN"]) exitWith { _isMedit = true; };
} forEach _sigs;

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
