#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Biome Analyzer
 * Technical detection of terrain characteristics.
 */

if (!isServer) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Initiating Global Biome Detection...";

private _worldName = toUpper worldName;
private _biome = "TEMPERATE";

// 1. Static World Mapping
if (_worldName in ["ALTIS", "MALDEN", "STRATIS"]) then { _biome = "MEDITERRANEAN"; };
if (_worldName in ["TANOA", "ENOCH"]) then { _biome = "TROPICAL"; };
if (_worldName in ["ZAGORSK", "CHERNARUS", "LIVONIA"]) then { _biome = "TEMPERATE"; };

// 2. Dynamic Sampling (Heuristic)
private _pos = [worldSize / 2, worldSize / 2, 0];
private _objects = nearestObjects [_pos, [], 500];
private _treeCount = { _x isKindOf "Tree" } count _objects;

if (missionNamespace getVariable ["uksfta_environment_logLevel", 0] > 1) then {
    diag_log text (format ["[UKSF TASKFORCE ALPHA] <TRACE> [ENVIRONMENT]: Terrain Sample Result: %1 objects, %2 trees", count _objects, _treeCount]);
};

if (_treeCount < 10) then {
    diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Low Vegetation Density Detected. Escalating to ARID classification.";
    _biome = "ARID";
};

// 3. BROADCAST FINALIZATION
missionNamespace setVariable ["UKSFTA_Environment_Biome", _biome, true];
diag_log text (format ["[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Global Biome Classification Finalized: %1", _biome]);

true
