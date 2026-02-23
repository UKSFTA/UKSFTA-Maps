#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Biome Analyzer
 * Technical detection of terrain characteristics.
 */

if (!isServer) exitWith {};

LOG_INFO("Initiating Global Biome Detection...");

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

LOG_TRACE(format ["Terrain Sample Result: %1 objects, %2 trees", count _objects, _treeCount]);

if (_treeCount < 10) then {
    LOG_INFO("Low Vegetation Density Detected. Escalating to ARID classification.");
    _biome = "ARID";
};

missionNamespace setVariable ["UKSFTA_Environment_Biome", _biome, true];
LOG_INFO(format ["Global Biome Classification Finalized: %1", _biome]);

true
