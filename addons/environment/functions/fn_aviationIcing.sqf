#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Aviation Icing Simulation (Phase 6)
 * Increases airframe weight and drag in freezing conditions.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Aviation Icing Engine Active.";

private _lastVeh = objNull;
private _originalMass = -1;

while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    private _unit = player;
    private _veh = vehicle _unit;

    // Only process if player is pilot/crew of an aircraft
    if (_veh isKindOf "Air" && {!(_veh isKindOf "Parachute")} && {_unit == (driver _veh) || _unit == (_veh turretUnit [0])}) then {
        
        // Reset if vehicle changed
        if (_veh != _lastVeh) then {
            _lastVeh = _veh;
            _originalMass = getMass _veh;
            _veh setVariable ["UKSFTA_Env_IceLevel", 0, true];
        };

        private _alt = (getPosASL _veh) select 2;
        private _temp = missionNamespace getVariable ["UKSFTA_Environment_LocalTemp", 20];
        private _overcast = overcast;
        private _iceLevel = _veh getVariable ["UKSFTA_Env_IceLevel", 0];

        // 1. Accumulation Logic
        // Conditions for icing: Freezing temps AND moisture (clouds/rain)
        if (_temp < 0 && (_overcast > 0.7 || rain > 0.1) && _alt > 500) then {
            private _rate = linearConversion [0, -20, _temp, 0.001, 0.005, true] * (1 + rain);
            _iceLevel = (_iceLevel + _rate) min 0.2; // Max 20% mass increase
        } else {
            // 2. Sublimation/Melting Logic
            // Melt if temp > 5C or at low altitude
            if (_temp > 5 || _alt < 300) then {
                _iceLevel = (_iceLevel - 0.01) max 0;
            };
        };

        _veh setVariable ["UKSFTA_Env_IceLevel", _iceLevel, true];

        // 3. Physical Application
        // Increase mass based on ice level
        if (_iceLevel > 0) then {
            private _newMass = _originalMass * (1 + _iceLevel);
            _veh setMass _newMass;
            
            if (missionNamespace getVariable ["uksfta_environment_logLevel", 0] > 1 && _iceLevel > 0.1) then {
                diag_log text (format ["[UKSF TASKFORCE ALPHA] <TRACE> [ENVIRONMENT]: Airframe Icing: %1%2", floor(_iceLevel * 100), "%"]);
            };
        } else {
            if (getMass _veh != _originalMass && _originalMass > 0) then {
                _veh setMass _originalMass;
            };
        };
    } else {
        _lastVeh = objNull;
        _originalMass = -1;
    };

    sleep 5;
};

true
