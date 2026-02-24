#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Artillery Whistle Engine (Phase 16)
 * Detects incoming high-caliber shells and plays tearing/whistling audio.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: Artillery Whistle Engine Active.";

[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _nearProjectiles = player nearObjects ["ShellBase", 500];
        
        {
            private _shell = _x;
            private _vel = velocity _shell;
            private _speed = vectorMagnitude _vel;
            
            // If shell is falling towards player and fast
            if (_speed > 100 && {(_vel select 2) < -5}) then {
                private _dist = player distance _shell;
                
                // Trajectory check (is it landing near us?)
                private _predictedPos = (getPosATL _shell) vectorAdd (_vel vectorMultiply 1); // 1s prediction
                if ((_predictedPos distance player) < 100 && {isNil {_shell getVariable "UKSFTA_Whistled"}}) then {
                    _shell setVariable ["UKSFTA_Whistled", true];
                    
                    private _whistle = selectRandom [
                        "A3\Sounds_F\weapons\Closure\soft_revolve_01.wss", // Sharp tear
                        "A3\Sounds_F\weapons\Explosion\expl_shell_1.wss"
                    ];
                    
                    playSound3D [_whistle, player, false, getPosASL _shell, 2, 1.5, 200];
                };
            };
        } forEach _nearProjectiles;
        
        sleep 0.1; // High frequency check
    };
};

true
