#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Immersive Rain Particles
 */

if (!hasInterface) exitWith {};

[] spawn {
    waitUntil { !isNull player };
    
    private _rainDrops = "#particlesource" createVehicleLocal [0,0,0];
    private _active = false;

    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _rain = rain;
        
        // High-performance vehicle check using objectParent (L-S18 compliant)
        if (_rain >= 0.1 && {isNull objectParent player || {(cameraView == "EXTERNAL")}}) then {
            _active = true;
            
            private _pos = getPosVisual player;
            _rainDrops setPos _pos;
            
            // Dynamic intensity scaling
            private _dropFactor = linearConversion [0.1, 1, _rain, 0.008, 0.002, true];
            private _animFactor = linearConversion [0.1, 1, _rain, 0.1, 0.25, true]; 
            
            _rainDrops setParticleCircle [15, [0, 0, 0]];   
            _rainDrops setParticleRandom [0.2, [15, 15, 0], [0, 0, 1], 10, 0.4, [0, 0, 0, 0], 1, 0];   
            
            _rainDrops setParticleParams [
                ["\A3\Data_F_Mark\ParticleEffects\Universal\waterBallonExplode_01", 4, 0, 16, 0], 
                "", "Billboard", 1, 0.4, [0, 0, 20], [0, 0, 0.5], 0, 15, 7.9, 0, 
                [0.05, (_animFactor + 0.15)], 
                [[0.6, 0.6, 0.6, 0.8], [0.6, 0.6, 0.6, 0]], 
                [2], 1, 0, "", "", vehicle player, 0, true
            ];    
            
            _rainDrops setDropInterval _dropFactor;
            sleep 5;
        } else {
            if (_active) then {
                _rainDrops setDropInterval 0;
                _active = false;
            };
            sleep 10;
        };
    };
    
    if (!isNull _rainDrops) then { deleteVehicle _rainDrops; };
};

true
