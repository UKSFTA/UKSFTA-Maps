#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Dynamic Surface Pooling (Phase 8)
 * Implements performance-friendly rain puddles and blood pools using SimpleObjects.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Surface Pooling Engine Active.";

UKSFTA_Env_ActivePools = [];
private _maxPools = 20;

while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    private _rain = rain;
    private _units = allUnits select { _x distance player < 30 && {alive _x} };
    
    // 1. RAIN PUDDLES
    if (_rain > 0.4 && {count UKSFTA_Env_ActivePools < _maxPools}) then {
        private _spawnPos = player modelToWorld [random 20 - 10, random 20 - 10, 0];
        _spawnPos set [2, 0];
        
        // Ensure we are on a valid surface (not inside buildings)
        private _surface = toLower (surfaceType _spawnPos);
        if (_surface find "dirt" != -1 || _surface find "grass" != -1 || _surface find "road" != -1) then {
            private _puddle = createSimpleObject ["bloodsplatter\models\plane\bloodsplatter_plane.p3d", AGLToASL _spawnPos];
            _puddle setDir (random 360);
            _puddle setVectorUp (surfaceNormal _spawnPos);
            _puddle setObjectTexture [0, "z\uksfta\addons\environment\data\wet_ca.paa"];
            
            UKSFTA_Env_ActivePools pushBack [_puddle, time + 60 + (random 60)];
        };
    };

    // 2. BLOOD POOLS (Linked to ACE3 Bleeding)
    {
        private _bleeding = _x getVariable ["ace_medical_woundBleeding", 0];
        if (_bleeding > 0.5 && {count UKSFTA_Env_ActivePools < (_maxPools + 10)}) then {
            private _pos = getPosASL _x;
            private _pool = createSimpleObject ["bloodsplatter\models\plane\bloodsplatter_smallplane.p3d", _pos];
            _pool setDir (random 360);
            _pool setVectorUp (surfaceNormal _pos);
            _pool setObjectTexture [0, "z\uksfta\addons\environment\data\blood_ca.paa"];
            
            UKSFTA_Env_ActivePools pushBack [_pool, time + 300]; // Blood stays longer
        };
    } forEach _units;

    // 3. CLEANUP & FADING
    {
        _x params ["_obj", "_expiry"];
        if (time > _expiry || {player distance _obj > 100}) then {
            deleteVehicle _obj;
            UKSFTA_Env_ActivePools deleteAt _forEachIndex;
        };
    } forEachReversed UKSFTA_Env_ActivePools;

    sleep 10;
};

// Final Cleanup
{ deleteVehicle (_x select 0); } forEach UKSFTA_Env_ActivePools;
UKSFTA_Env_ActivePools = nil;
