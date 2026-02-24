#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sovereign Heat Engine (Phase 8)
 * Dynamic ground scorching, grass burning, and heat haze.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Heat Engine Active.";

UKSFTA_Env_HeatSources = createHashMap; // Track active emitters to prevent spam

while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    // 1. SCAN FOR INTENSE HEAT (Burning Objects)
    private _fires = (nearestObjects [player, ["House", "Thing", "Car", "Tank"], 50]) select { getFireIntensity _x > 0.2 };
    
    {
        private _fire = _x;
        private _id = hashValue _fire;
        
        if !(_id in UKSFTA_Env_HeatSources) then {
            // --- INITIAL SCORCH & GRASS BURN ---
            private _pos = getPosATL _fire;
            
            // Flatten Grass (Clutter Cutter)
            private _cutter = "Land_ClutterCutter_medium_F" createVehicleLocal _pos;
            
            // Ground Scorch Decal
            private _scorch = createSimpleObject ["z\uksfta\addons\environment\data\surface_plane.p3d", AGLToASL _pos];
            _scorch setDir (random 360);
            _scorch setVectorUp (surfaceNormal _pos);
            _scorch setObjectTexture [0, "#(argb,8,8,3)color(0.05,0.05,0.05,0.8)"]; // Charcoal black
            
            // Heat Haze (Refraction)
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

    // 2. CLEANUP SOURCES THAT HAVE EXTINGUISHED OR ARE FAR AWAY
    {
        private _id = _key;
        private _objs = _value;
        private _fire = objNull;
        
        // Find the fire object again (expensive but safe)
        { if (hashValue _x == _id) exitWith { _fire = _x; }; } forEach (allMissionObjects "All");

        if (isNull _fire || {getFireIntensity _fire < 0.1 || player distance _fire > 100}) then {
            { deleteVehicle _x; } forEach _objs;
            UKSFTA_Env_HeatSources deleteAt _id;
        };
    } forEach UKSFTA_Env_HeatSources;

    sleep 5;
};

// Final Cleanup
{ { deleteVehicle _x; } forEach _value; } forEach UKSFTA_Env_HeatSources;
UKSFTA_Env_HeatSources = nil;
