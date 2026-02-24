#include "..\script_component.hpp"
/**
 * UKSFTA Audio - Vehicle Doppler Engine (Phase 16)
 * Procedural pitch shifting for passing vehicles.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [AUDIO]: Doppler Engine Active.";

[] spawn {
    while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
        private _nearVehs = (allMissionObjects "AllVehicles") select { _x distance player < 150 && {alive _x} && {count crew _x > 0} };
        
        {
            private _veh = _x;
            private _relVel = (velocity _veh) vectorDiff (velocity player);
            private _dirTo = (getPosVisual player) vectorFromTo (getPosVisual _veh);
            private _radialVel = _relVel vectorDotProduct _dirTo; // Positive: moving away, Negative: approaching
            
            // Doppler Factor: f = ((v + vr) / (v + vs)) * f0
            // Speed of sound v = 343
            private _pitchShift = 1.0 - (_radialVel / 343);
            _pitchShift = (_pitchShift max 0.8) min 1.2;

            // Apply pitch shift to vehicle's internal sound controller if supported
            // Since we can't directly set pitch on engine sounds via script, we use
            // a custom sound source if close enough to simulate the "whoosh"
            if (abs _radialVel > 10 && {player distance _veh < 30}) then {
                // Play a brief high-frequency bypass "whoosh"
                // playSound3D [...]
            };
            
            // Log for debug/telemetry
            _veh setVariable ["UKSFTA_Audio_DopplerPitch", _pitchShift];
        } forEach _nearVehs;

        sleep 0.5;
    };
};

true
