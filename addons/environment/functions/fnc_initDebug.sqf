/**
 * UKSFTA Environment - Diagnostic HUD
 * Visualizes technical telemetry for testing.
 */

if (!hasInterface) exitWith {};

// --- DEBUG HUD LOOP ---
[] spawn {
    while {true} do {
        if (uksfta_environment_debugHUD) then {
            private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "PENDING"];
            private _camo = player getUnitTrait "camouflageCoef";
            private _audit = player getUnitTrait "audibleCoef";
            private _temp = missionNamespace getVariable ["ace_weather_currentTemperature", 0];
            private _interference = missionNamespace getVariable ["UKSFTA_Environment_Interference", 0];
            
            hintSilent parseText format [
                "<t color='#4caf50' size='1.2' font='RobotoCondensedBold'>UKSFTA TELEMETRY</t><br/>" +
                "<t color='#aaaaaa' size='0.8'>----------------------------</t><br/>" +
                "<t align='left'>BIOME:</t><t align='right' color='#ffffff'>%1</t><br/>" +
                "<t align='left'>VIS COEF:</t><t align='right' color='#ffffff'>%2</t><br/>" +
                "<t align='left'>AUD COEF:</t><t align='right' color='#ffffff'>%3</t><br/>" +
                "<t align='left'>TEMP:</t><t align='right' color='#ffffff'>%4°C</t><br/>" +
                "<t align='left'>SIGNAL LOSS:</t><t align='right' color='#ff0000'>%5%</t><br/>" +
                "<t color='#aaaaaa' size='0.8'>----------------------------</t>",
                _biome,
                ([_camo, 2] call CBA_fnc_formatNumber),
                ([_audit, 2] call CBA_fnc_formatNumber),
                ([_temp, 1] call CBA_fnc_formatNumber),
                ([_interference * 100, 0] call CBA_fnc_formatNumber)
            ];
        };
        sleep 0.5;
    };
};

true
