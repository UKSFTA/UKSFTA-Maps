/**
 * UKSFTA Environment - Diagnostic HUD
 * Visualizes technical telemetry for testing.
 */

if (!hasInterface) exitWith {};

// --- ABSOLUTE STARTUP GUARD ---
// Wait for settings to physically exist in missionNamespace
waitUntil { !isNil "uksfta_environment_debugHUD" };

// --- DEBUG HUD LOOP ---
[] spawn {
    private _header = "<t color='#4caf50' size='1.2' font='RobotoCondensedBold'>UKSFTA TELEMETRY</t><br/>";
    private _div = "<t color='#aaaaaa' size='0.8'>----------------------------</t><br/>";
    
    // Fail-safe condition
    while {true} do {
        if (missionNamespace getVariable ["uksfta_environment_debugHUD", false]) then {
            private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "PENDING"];
            private _camo = player getUnitTrait "camouflageCoef";
            private _audit = player getUnitTrait "audibleCoef";
            private _temp = missionNamespace getVariable ["ace_weather_currentTemperature", 0];
            private _interference = missionNamespace getVariable ["UKSFTA_Environment_Interference", 0];
            
            private _txt = _header + _div;
            _txt = _txt + format ["<t align='left'>BIOME:</t><t align='right' color='#ffffff'>%1</t><br/>", _biome];
            _txt = _txt + format ["<t align='left'>VIS COEF:</t><t align='right' color='#ffffff'>%1</t><br/>", ([_camo, 2] call CBA_fnc_formatNumber)];
            _txt = _txt + format ["<t align='left'>AUD COEF:</t><t align='right' color='#ffffff'>%1</t><br/>", ([_audit, 2] call CBA_fnc_formatNumber)];
            _txt = _txt + format ["<t align='left'>TEMP:</t><t align='right' color='#ffffff'>%1°C</t><br/>", ([_temp, 1] call CBA_fnc_formatNumber)];
            _txt = _txt + format ["<t align='left'>SIGNAL LOSS:</t><t align='right' color='#ff0000'>%1%%</t><br/>", ([_interference * 100, 0] call CBA_fnc_formatNumber)];
            _txt = _txt + _div;

            hintSilent parseText _txt;
        };
        sleep 0.5;
    };
};

true
