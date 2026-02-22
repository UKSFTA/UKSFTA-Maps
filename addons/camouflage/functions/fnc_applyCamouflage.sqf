/**
 * UKSFTA Camouflage - Core Logic
 * Presets: ARCADE (Simplified) vs REALISM (Full)
 */

if (!hasInterface) exitWith {};

private _biome = missionNamespace getVariable ["UKSFTA_Environment_Biome", "TEMPERATE"];
private _uniform = toLower (uniform player);
private _stance = stance player;
private _speed = vectorMagnitude (velocity player);

private _camoCoef = 1.0;
private _auditCoef = 1.0;

// --- PRESET LOGIC ---
if (uksfta_environment_preset == "ARCADE") then {
    // Fixed high-performance bonus for arcade play
    _camoCoef = 0.6;
    _auditCoef = 0.6;
} else {
    // REALISM: FULL HEURISTIC LOGIC
    private _aiBuffer = 1.0;
    if (uksfta_camouflage_aiCompat) then {
        private _hasLambs = isClass (configFile >> "CfgPatches" >> "lambs_danger");
        private _hasVcom = isClass (configFile >> "CfgPatches" >> "VCOM_AI");
        if (_hasLambs || _hasVcom) then { _aiBuffer = 0.85; };
    };

    private _matchBonus = 0.8; 
    switch (_biome) do {
        case "TEMPERATE": {
            if ("mtp" in _uniform || "multicam" in _uniform || "wood" in _uniform) then { _camoCoef = _camoCoef * _matchBonus; };
        };
        case "ARID": {
            if ("arid" in _uniform || "desert" in _uniform || "sand" in _uniform) then { _camoCoef = _camoCoef * _matchBonus; };
        };
        case "ARCTIC": {
            if ("winter" in _uniform || "snow" in _uniform || "white" in _uniform) then { 
                _camoCoef = _camoCoef * _matchBonus;
                _auditCoef = _auditCoef * 0.7;
            } else { 
                _camoCoef = _camoCoef * 1.5; 
            }; 
        };
        case "TROPICAL": {
            if ("tropic" in _uniform || "jungle" in _uniform) then { _camoCoef = _camoCoef * _matchBonus; };
            _auditCoef = _auditCoef * 1.2;
        };
    };

    switch (_stance) do {
        case "PRONE": { _camoCoef = _camoCoef * 0.5; _auditCoef = _auditCoef * 0.4; };
        case "CROUCH": { _camoCoef = _camoCoef * 0.8; _auditCoef = _auditCoef * 0.7; };
        case "STAND": { _camoCoef = _camoCoef * 1.0; _auditCoef = _auditCoef * 1.0; };
    };

    if (_speed > 2) then { _camoCoef = _camoCoef * 1.2; _auditCoef = _auditCoef * 1.5; };
    if (_speed > 5) then { _camoCoef = _camoCoef * 2.0; _auditCoef = _auditCoef * 3.0; };

    if (uksfta_camouflage_grassFix && _stance == "PRONE") then {
        private _surface = surfaceType (getPos player);
        if ("grass" in _surface || "forest" in _surface) then { _camoCoef = _camoCoef * 0.2; };
    };

    _camoCoef = _camoCoef * _aiBuffer;
    _auditCoef = _auditCoef * _aiBuffer;
};

// --- FINAL APPLICATION ---
private _finalCamo = (_camoCoef / (uksfta_camouflage_intensity max 0.1)) min 2.0 max 0.05;
private _finalAudit = _auditCoef min 2.0 max 0.05;

player setUnitTrait ["camouflageCoef", _finalCamo];
player setUnitTrait ["audibleCoef", _finalAudit];

true
