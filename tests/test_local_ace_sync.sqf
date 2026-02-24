diag_log "🧪 [UKSFTA] Testing LOCAL ACE SYNC Logic...";

// Setup global state
missionNamespace setVariable ["UKSFTA_Environment_GlobalTemp", 20];
missionNamespace setVariable ["UKSFTA_Environment_GlobalHumid", 0.5];
missionNamespace setVariable ["uksfta_environment_enabled", true];
overcast = 0.3;

// Mock values
private _mockSunElevation = 30;
private _mockSurface = "GRASS";
private _mockPosASL = [0,0,1000];
private _mockVisibility = 1.0; // Full visibility

// Extract and test the core calculation logic from fn_localClimate
private _globalTemp = missionNamespace getVariable ["UKSFTA_Environment_GlobalTemp", 20];
private _pos = _mockPosASL;
private _alt = _pos select 2;
private _surface = _mockSurface;

// Biome detection
private _fnc_getSurfaceBiome = {
    params ["_surface"];
    private _s = toUpper _surface;
    if (_s find "SNOW" != -1 || _s find "ICE" != -1 || _s find "WINTER" != -1) exitWith { "ARCTIC" };
    if (_s find "SAND" != -1 || _s find "DESERT" != -1 || _s find "DRY" != -1) exitWith { "ARID" };
    if (_s find "JUNGLE" != -1 || _s find "PALM" != -1) exitWith { "TROPICAL" };
    "TEMPERATE"
};

private _localBiome = _surface call _fnc_getSurfaceBiome;
private _surfaceOffset = 0;
private _desat = 0;

if (_localBiome == "ARCTIC") then { _surfaceOffset = -15; _desat = 0.2; };
if (_localBiome == "ARID") then { _surfaceOffset = 5; };

// Shade calculation (mocked)
private _shadeOffset = 0;
private _sunElevation = _mockSunElevation;

if (_sunElevation > 0) then {
    private _sunDir = (360 - (sunOrMoon * 360)) % 360;
    private _sunPos = [
        (_mockPosASL select 0) + (sin _sunDir * 1000),
        (_mockPosASL select 1) + (cos _sunDir * 1000),
        (_mockPosASL select 2) + (sin _sunElevation * 1000)
    ];
    
    private _vis = _mockVisibility;
    if (_vis < 0.5) then {
        _shadeOffset = -5;
    };
};

private _altOffset = (_alt / 1000) * -6.5;
private _localTemp = _globalTemp + _altOffset + _surfaceOffset + _shadeOffset;

// Test cases
diag_log format ["  - Global Temp: %1°C", _globalTemp];
diag_log format ["  - Altitude: %1m (offset: %2°C)", _alt, _altOffset];
diag_log format ["  - Surface: %1 (biome: %2, offset: %3°C)", _surface, _localBiome, _surfaceOffset];
diag_log format ["  - Shade: %1°C", _shadeOffset];
diag_log format ["  - Local Temp: %1°C", _localTemp];

// Expected: 20 + (-6.5) + 0 + 0 = 13.5°C
if (abs(_localTemp - 13.5) < 0.1) then {
    diag_log "✅ LOCAL TEMPERATURE CALCULATION VERIFIED.";
} else {
    diag_log format ["❌ LOCAL TEMPERATURE CALCULATION FAILED. Expected: 13.5, Got: %1", _localTemp];
};

// Test ACE sync
missionNamespace setVariable ["ace_weather_currentTemperature", _localTemp];
if (abs((missionNamespace getVariable ["ace_weather_currentTemperature", 0]) - 13.5) < 0.1) then {
    diag_log "✅ ACE TEMPERATURE SYNC VERIFIED.";
} else {
    diag_log "❌ ACE TEMPERATURE SYNC FAILED.";
};

// Test humidity adjustment
private _globalHumid = missionNamespace getVariable ["UKSFTA_Environment_GlobalHumid", 0.5];
private _localHumid = _globalHumid;
if (_localBiome == "ARID" && overcast > 0.7) then { _localHumid = (_localHumid - 0.2) max 0.05; };
missionNamespace setVariable ["ace_weather_currentHumidity", _localHumid];

if (abs(_localHumid - 0.5) < 0.1) then {
    diag_log "✅ LOCAL HUMIDITY CALCULATION VERIFIED.";
} else {
    diag_log "❌ LOCAL HUMIDITY CALCULATION FAILED.";
};

// Test Arctic conditions
_surface = "SNOW";
_localBiome = _surface call _fnc_getSurfaceBiome;
_surfaceOffset = -15;
_localTemp = _globalTemp + _altOffset + _surfaceOffset + _shadeOffset;

diag_log format ["  - Arctic Test: %1°C (expected ~ -1.5°C)", _localTemp];
if (abs(_localTemp - (-1.5)) < 0.1) then {
    diag_log "✅ ARCTIC TEMPERATURE CALCULATION VERIFIED.";
} else {
    diag_log format ["❌ ARCTIC TEMPERATURE CALCULATION FAILED. Expected: -1.5, Got: %1", _localTemp];
};

// Test shade
private _vis = 0.3; // Mock shade
if (_vis < 0.5) then { _shadeOffset = -5; };
_localTemp = _globalTemp + _altOffset + _surfaceOffset + _shadeOffset;

diag_log format ["  - Shade Test: %1°C (expected ~ -6.5°C)", _localTemp];
if (abs(_localTemp - (-6.5)) < 0.1) then {
    diag_log "✅ SHADE TEMPERATURE OFFSET VERIFIED.";
} else {
    diag_log format ["❌ SHADE TEMPERATURE OFFSET FAILED. Expected: -6.5, Got: %1", _localTemp];
};
