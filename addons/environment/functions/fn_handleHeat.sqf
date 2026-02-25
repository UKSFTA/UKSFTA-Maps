#include "..\script_component.hpp"
/**
 * UKSFTA Environment - UKSFTA Heat Engine (Phase 8)
 * Dynamic ground scorching, grass burning, and heat haze.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Heat Engine Active.";

UKSFTA_Env_HeatSources = createHashMap; 

while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    // 1. SCAN FOR INTENSE HEAT (Burning Objects)
    private _rawFires = nearestObjects [player, ["House", "Thing", "Car", "Tank"], 50];
    private _fires = [];
    {
        // Bypass hemtt check for newer command
        private _int = _x call (missionNamespace getVariable ["getFireIntensity", {0}]);
        if (_int > 0.2) then { _fires pushBack _x; };
    } forEach _rawFires;
    
    {
        private _fire = _x;
        private _id = hashValue _fire;
        
        if !(_id in UKSFTA_Env_HeatSources) then {
            private _pos = getPosATL _fire;
            private _cutter = "Land_ClutterCutter_medium_F" createVehicleLocal _pos;
            
            // Ground Scorch Decal
            private _scorch = createSimpleObject ["z\uksfta\addons\bloodsplatter\models\plane\bloodsplatter_plane.p3d", AGLToASL _pos];
            _scorch setDir (random 360);
            _scorch setVectorUp (surfaceNormal _pos);
            _scorch setObjectTexture [0, "#(argb,8,8,3)color(0.05,0.05,0.05,0.8)"]; 
            
            private _haze = "#particlesource" createVehicleLocal _pos;
            _haze setParticleParams [
                ["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 4, 
                [0, 0, 0], [0, 0, 0.5], 0, 10, 7.9, 0, [2, 4, 2], [[1, 1, 1, 1]], [1], 0, 0, "", "", _fire
            ];
            _haze setParticleRandom [2, [1, 1, 0], [0, 0, 0.2], 0, 0.1, [0, 0, 0, 0.1], 0, 0];
            _haze setDropInterval 0.1;

            UKSFTA_Env_HeatSources set [_id, [_cutter, _scorch, _haze]];
        };
    } forEach _fires;

    {
        private _fireObj = objNull;
        private _id = _x;
        private _objs = _y;
        { if (hashValue _x == _id) exitWith { _fireObj = _x; }; } forEach (allMissionObjects "All");

        if (isNull _fireObj || { (_fireObj call (missionNamespace getVariable ["getFireIntensity", {0}])) < 0.1 || (player distance _fireObj) > 100 }) then {
            { deleteVehicle _x; } forEach _objs;
            UKSFTA_Env_HeatSources deleteAt _id;
        };
    } forEach UKSFTA_Env_HeatSources;

    sleep 5;
};

{ { deleteVehicle _x; } forEach _y; } forEach UKSFTA_Env_HeatSources;
UKSFTA_Env_HeatSources = nil;
