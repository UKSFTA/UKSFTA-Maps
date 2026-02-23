#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Diagnostic HUD
 */

if (!hasInterface) exitWith {};

// --- ABSOLUTE STARTUP GUARD ---
waitUntil { !isNil "uksfta_environment_debugHUD" };

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [ENVIRONMENT]: Diagnostic OSD Loop Active.";

// --- DEBUG HUD LOOP ---
[] spawn {
    private _header = "<t color='#4caf50' size='1.2' font='RobotoCondensedBold'>UKSFTA TELEMETRY</t><br/>";
    private _div = "<t color='#aaaaaa' size='0.8'>----------------------------</t><br/>";
    
    while {true} do {
        if (missionNamespace getVariable ["uksfta_environment_debugHUD", false]) then {
            private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", UKSFTA_Environment_Biome];
            if (isNil "_biome") then { _biome = "PENDING"; };
            
            private _camo = player getUnitTrait "camouflageCoef";
            private _audit = player getUnitTrait "audibleCoef";
            private _temp = missionNamespace getVariable ["ace_weather_currentTemperature", 0];
            private _interference = missionNamespace getVariable ["UKSFTA_Environment_Interference", 0];
            
            private _txt = _header + _div;
            _txt = _txt + format ["<t align='left'>BIOME:</t><t align='right' color='#ffffff'>%1</t><br/>", _biome];
            _txt = _txt + format ["<t align='left'>VIS COEF:</t><t align='right' color='#ffffff'>%1</t><br/>", _camo];
            _txt = _txt + format ["<t align='left'>AUD COEF:</t><t align='right' color='#ffffff'>%1</t><br/>", _audit];
            _txt = _txt + format ["<t align='left'>TEMP:</t><t align='right' color='#ffffff'>%1°C</t><br/>", _temp];
            _txt = _txt + format ["<t align='left'>SIGNAL LOSS:</t><t align='right' color='#ff0000'>%1%2</t><br/>", (_interference * 100), "%"];
            _txt = _txt + _div;

            hintSilent parseText _txt;
        };
        sleep 0.5;
    };
};

true
