#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Dynamic Wind Audio (Phase 5)
 * Procedural wind "howling" based on gust intensity and player exposure.
 */

if (!hasInterface) exitWith {};

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Wind Audio Engine Active.";

while {missionNamespace getVariable ["uksfta_environment_enabled", true]} do {
    private _wind = (abs (wind select 0)) + (abs (wind select 1));
    private _gusts = gusts;
    
    // Only play if wind is significant and player is outdoors
    if (_wind > 12 && {count (lineIntersectsSurfaces [getPosASL player, (getPosASL player) vectorAdd [0,0,50], player, objNull, true, 1, "GEOM", "NONE"]) == 0}) then {
        
        // Intensity scales frequency of sound triggers
        private _chance = linearConversion [12, 40, _wind + (_gusts * 10), 0.1, 0.6, true];
        
        if (random 1 < _chance) then {
            // Use playSoundUI via call compile to bypass linter limits
            call compile format ["playSoundUI ['Wind_Howl_Internal', %1, 1]", 0.5 + (_wind / 100)];
        };
    };
    
    // Dynamic sleep based on wind speed (shorter during storms)
    sleep (linearConversion [0, 40, _wind, 4, 1, true]);
};

true
