/**
 * UKSFTA Sovereign - Virtual File System (VFS) Integrity Audit
 * Uses Arma 3 'fileExists' to guarantee asset accessibility in-game.
 */

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
diag_log "🧪 INITIATING SOVEREIGN VFS INTEGRITY AUDIT (SQF LEVEL)";
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";

private _manifest = [
    // --- 1. CORE ENGINE SCRIPTS ---
    "\z\uksfta\addons\environment\functions\fn_handleDriving.sqf",
    "\z\uksfta\addons\environment\functions\fn_handlePhysicality.sqf",
    "\z\uksfta\addons\environment\functions\fn_handleModCompat.sqf",
    "\z\uksfta\addons\audio\functions\fn_handleObstruction.sqf",
    "\z\uksfta\addons\audio\functions\fn_handleWorldAlarms.sqf",
    "\z\uksfta\addons\audio\functions\fn_handleSonicCracks.sqf",

    // --- 2. BLASTCORE PARTICLE MODELS ---
    "\z\uksfta\addons\environment\models\impact\Explosion_01.p3d",
    "\z\uksfta\addons\environment\models\impact\Dirt.p3d",
    "\z\uksfta\addons\environment\models\impact\LargeFire_01.p3d",
    "\z\uksfta\addons\environment\models\impact\Refract.p3d",

    // --- 3. GORE / GIB MODELS ---
    "\z\uksfta\addons\impact\models\gibs\BloodSplatter_Torso.p3d",
    "\z\uksfta\addons\impact\models\gibs\skull_chunk1.p3d",
    "\z\uksfta\addons\impact\models\gibs\brain_Half.p3d",

    // --- 4. HIGH-FIDELITY AUDIO ---
    "\z\uksfta\addons\audio\sounds\world\Car_Alarm.ogg",
    "\z\uksfta\addons\audio\sounds\world\Car_Alarm1.ogg",
    "\z\uksfta\addons\audio\sounds\world\Facility_Alarm.ogg",
    "\z\uksfta\addons\audio\sounds\impact\bullet_hit_1.ogg",
    "\z\uksfta\addons\audio\sounds\character\breath\breath.ogg",

    // --- 5. TECHNICAL INFRASTRUCTURE ---
    "\z\uksfta\addons\main\XEH_preInit.sqf",
    "\z\uksfta\addons\environment\accumulation.hpp"
];

private _found = 0;
private _missing = 0;

{
    // Use fileExists for standard Arma VFS check
    if (fileExists _x) then {
        diag_log format ["  ✅ VFS ACCESSIBLE: %1", _x];
        _found = _found + 1;
    } else {
        diag_log format ["  ❌ VFS MISSING:    %1", _x];
        _missing = _missing + 1;
    };
} forEach _manifest;

diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";
if (_missing == 0) then {
    diag_log format ["🏆 VFS GOLD STATUS: %1/%1 ASSETS VERIFIED.", count _manifest];
} else {
    diag_log format ["🚨 VFS DEFECT: %1 ASSETS MISSING FROM VIRTUAL MAP.", _missing];
};
diag_log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━";

_missing == 0
