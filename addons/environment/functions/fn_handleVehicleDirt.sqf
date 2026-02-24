#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Dynamic Vehicle Dirt (Phase 6)
 * Simulates dirt accumulation and visual obstruction.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Vehicle Dirt Engine Active.";

private _ppDirt = ppEffectCreate ["ColorCorrections", 1508];
private _lastPos = getPos player;

while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    private _veh = vehicle player;
    private _currPos = getPos player;
    
    if (_veh != player && {!isNull objectParent player}) then {
        private _dist = _lastPos distance _currPos;
        if (_dist > 1 && _dist < 500) then { // Sanity check for teleports
            private _surface = surfaceType (getPos _veh);
            private _dirtLevel = _veh getVariable ["UKSFTA_Env_DirtLevel", 0];
            
            // 1. Accumulation rate based on surface
            private _rate = 0.00001; // Baseline
            if (_surface find "grass" != -1 || _surface find "forest" != -1) then { _rate = 0.00005; };
            if (_surface find "sand" != -1 || _surface find "dirt" != -1) then { _rate = 0.0001; };
            
            // 2. Moisture multiplier
            if (rain > 0.1) then { _rate = _rate * 5; };
            
            _dirtLevel = (_dirtLevel + (_dist * _rate)) min 1.0;
            _veh setVariable ["UKSFTA_Env_DirtLevel", _dirtLevel, true];
        };

        // 3. Visual Obstruction (Windshield Dirt)
        private _visualDirt = _veh getVariable ["UKSFTA_Env_DirtLevel", 0];
        if (_visualDirt > 0.3 && {cameraView == "INTERNAL"}) then {
            _ppDirt ppEffectEnable true;
            // Apply a brownish tint and slight desaturation to simulate dirty glass
            _ppDirt ppEffectAdjust [
                1.0, 
                1.0 - (_visualDirt * 0.1), 
                0, 
                [0.1 * _visualDirt, 0.05 * _visualDirt, 0, 0], 
                [1, 1, 1, 1 - (_visualDirt * 0.2)], 
                [0.299, 0.587, 0.114, 0]
            ];
            _ppDirt ppEffectCommit 2;
        } else {
            _ppDirt ppEffectEnable false;
        };
    } else {
        _ppDirt ppEffectEnable false;
    };

    _lastPos = _currPos;
    sleep 2;
};

ppEffectDestroy _ppDirt;
true
