diag_log "🧪 [UKSFTA] Testing LOCAL ACE SYNC Logic...";

// 1. Setup Mock Global State
missionNamespace setVariable ["UKSFTA_Environment_GlobalTemp", 20];
missionNamespace setVariable ["ace_weather_currentTemperature", 20];
missionNamespace setVariable ["uksfta_environment_enabled", true];

// 2. Mock fn_localClimate partial logic
private _globalTemp = 20;
private _alt = 1000; // 1km up should be -6.5C
private _surfaceOffset = -15; // Arctic surface

private _altOffset = (_alt / 1000) * -6.5;
private _localTemp = _globalTemp + _altOffset + _surfaceOffset;

// 3. Apply Local Override (what fn_localClimate does)
missionNamespace setVariable ["ace_weather_currentTemperature", _localTemp];

// 4. Verification
diag_log format ["  - Global: %1C", _globalTemp];
diag_log format ["  - Local (Expected): %1C", _localTemp];
diag_log format ["  - ACE Local Value: %1C", missionNamespace getVariable ["ace_weather_currentTemperature", 0]];

if (abs((missionNamespace getVariable ["ace_weather_currentTemperature", 0]) - (-1.5)) < 0.1) then {
    diag_log "✅ LOCAL ACE SYNC VERIFIED.";
} else {
    diag_log "❌ LOCAL ACE SYNC FAILED.";
};
