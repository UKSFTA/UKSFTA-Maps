#include "mock_arma.sqf"
diag_log "🧪 INITIATING DIAGNOSTIC HUD EMULATION...";

// --- SHADOW WRAPPERS ---
_fn_display = { 
    params ["_text"]; 
    diag_log format ["  📺 [HUD OUTPUT] %1", _text]; 
};
_fn_parseText = { _this };
_fn_getUnitTrait = {
    params ["_unit", "_trait"];
    _unit getVariable [_trait, 1.0];
};

// --- SETUP STATE ---
uksfta_environment_debugHUD = true;
missionNamespace setVariable ["UKSFTA_Environment_Biome", "ARID"];
missionNamespace setVariable ["ace_weather_currentTemperature", 42.5];
missionNamespace setVariable ["UKSFTA_Environment_Interference", 0.35];
player setVariable ["camouflageCoef", 0.5];
player setVariable ["audibleCoef", 1.2];

// --- EXTRACT LOGIC FROM SOURCE (SHADOWED) ---
private _logic = {
    private _header = "<t color='#4caf50' size='1.2' font='RobotoCondensedBold'>UKSFTA TELEMETRY</t><br/>";
    private _div = "<t color='#aaaaaa' size='0.8'>----------------------------</t><br/>";
    
    if (uksfta_environment_debugHUD) then {
        private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "PENDING"];
        private _camo = [player, "camouflageCoef"] call _fn_getUnitTrait;
        private _audit = [player, "audibleCoef"] call _fn_getUnitTrait;
        
        private _temp = missionNamespace getVariable ["ace_weather_currentTemperature", 0];
        private _interference = missionNamespace getVariable ["UKSFTA_Environment_Interference", 0];
        
        private _txt = _header + _div;
        _txt = _txt + format ["<t align='left'>BIOME:</t><t align='right' color='#ffffff'>%1</t><br/>", _biome];
        _txt = _txt + format ["<t align='left'>VIS COEF:</t><t align='right' color='#ffffff'>%1</t><br/>", ([_camo, 2] call CBA_fnc_formatNumber)];
        _txt = _txt + format ["<t align='left'>AUD COEF:</t><t align='right' color='#ffffff'>%1</t><br/>", ([_audit, 2] call CBA_fnc_formatNumber)];
        _txt = _txt + format ["<t align='left'>TEMP:</t><t align='right' color='#ffffff'>%1°C</t><br/>", ([_temp, 1] call CBA_fnc_formatNumber)];
        
        // Final Fix: Safe Placeholder Pattern
        _txt = _txt + format ["<t align='left'>SIGNAL LOSS:</t><t align='right' color='#ff0000'>%1%2</t><br/>", ([_interference * 100, 0] call CBA_fnc_formatNumber), "%"];
        
        _txt = _txt + _div;

        (_txt call _fn_parseText) call _fn_display;
    };
};

// --- EXECUTE ---
call _logic;

diag_log "✅ DIAGNOSTIC HUD TEST COMPLETE.";
