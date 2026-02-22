/**
 * UKSFTA Camouflage - Master Init
 */

if (!hasInterface) exitWith {};

// Start the main camouflage and grass loop
[] spawn {
    while {true} do {
        if (uksfta_camouflage_enabled && alive player) then {
            [] call uksfta_camouflage_fnc_applyCamouflage;
        } else {
            // Hard Reset to vanilla values if disabled
            player setUnitTrait ["camouflageCoef", 1];
            player setUnitTrait ["audibleCoef", 1];
        };
        sleep 5; // Low frequency for performance
    };
};

true
