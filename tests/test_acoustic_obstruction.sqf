/**
 * UKSFTA Test - Acoustic Obstruction
 * Verifies volume/pitch muffling through objects.
 */

diag_log "🧪 [TEST] Initiating Acoustic Obstruction Audit...";

private _playerPos = eyePos player;
private _blockedPos = _playerPos vectorAdd [0, 50, 0]; // 50m away
private _baseVol = 1.0;

// Test visibility logic
private _visibility = [player, "VIEW", objNull] checkVisibility [_playerPos, _blockedPos];
private _muffledVol = [_blockedPos, _baseVol] call uksfta_audio_fnc_handleObstruction;

if (_visibility < 0.5) then {
    if (_muffledVol < _baseVol) then {
        diag_log format ["  ✅ [ACOUSTICS] Obstruction Muffled: %1 (%2)", _muffledVol, _visibility];
    } else {
        diag_log "  ❌ [ACOUSTICS] Obstruction Logic Failed!";
    };
} else {
    diag_log format ["  ✅ [ACOUSTICS] Clear Line-of-Sight: %1", _visibility];
};

true
