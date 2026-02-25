#!/usr/bin/env bash
# UKSFTA Physical VFS Audit (Phase 19 Production)

echo "🧪 INITIATING PHYSICAL VFS MAPPING AUDIT..."

WS="/ext/Development/UKSFTA-Maps"
ERRORS=0

check_file() {
    local virtual_path=$1
    local physical_path="$WS/$2"
    
    if [ -f "$physical_path" ]; then
        echo "  ✅ PHYSICAL MATCH: $virtual_path -> $physical_path"
    else
        echo "  ❌ MISSING PHYSICAL: $virtual_path (Expected at $physical_path)"
        ERRORS=$((ERRORS + 1))
    fi
}

# --- 1. CORE ENGINES (SQF) ---
check_file "\z\uksfta\addons\environment\functions\fn_handleDriving.sqf" "addons/environment/functions/fn_handleDriving.sqf"
check_file "\z\uksfta\addons\environment\functions\fn_handlePhysicality.sqf" "addons/environment/functions/fn_handlePhysicality.sqf"
check_file "\z\uksfta\addons\environment\functions\fn_handleModCompat.sqf" "addons/environment/functions/fn_handleModCompat.sqf"
check_file "\z\uksfta\addons\audio\functions\fn_handleObstruction.sqf" "addons/audio/functions/fn_handleObstruction.sqf"
check_file "\z\uksfta\addons\audio\functions\fn_handleWorldAlarms.sqf" "addons/audio/functions/fn_handleWorldAlarms.sqf"

# --- 2. BLASTCORE MODELS (P3D) ---
check_file "\z\uksfta\addons\environment\models\impact\Explosion_01.p3d" "addons/environment/models/impact/Explosion_01.p3d"
check_file "\z\uksfta\addons\environment\models\impact\Dirt.p3d" "addons/environment/models/impact/Dirt.p3d"
check_file "\z\uksfta\addons\environment\models\impact\LargeFire_01.p3d" "addons/environment/models/impact/LargeFire_01.p3d"

# --- 3. GORE MODELS (P3D) ---
check_file "\z\uksfta\addons\impact\models\gibs\BloodSplatter_Torso.p3d" "addons/impact/models/gibs/BloodSplatter_Torso.p3d"
check_file "\z\uksfta\addons\impact\models\gibs\skull_chunk1.p3d" "addons/impact/models/gibs/skull_chunk1.p3d"
check_file "\z\uksfta\addons\impact\models\gibs\brain_Half.p3d" "addons/impact/models/gibs/brain_Half.p3d"

# --- 4. HIGH-FIDELITY AUDIO (OGG/WSS) ---
check_file "\z\uksfta\addons\audio\sounds\world\Car_Alarm.ogg" "addons/audio/sounds/world/Car_Alarm.ogg"
check_file "\z\uksfta\addons\audio\sounds\world\Car_Alarm1.ogg" "addons/audio/sounds/world/Car_Alarm1.ogg"
check_file "\z\uksfta\addons\audio\sounds\world\Facility_Alarm.ogg" "addons/audio/sounds/world/Facility_Alarm.ogg"
check_file "\z\uksfta\addons\audio\sounds\impact\bullet_hit_1.ogg" "addons/audio/sounds/impact/bullet_hit_1.ogg"

# --- 5. CBA SETTINGS ---
check_file "\z\uksfta\addons\main\XEH_preInit.sqf" "addons/main/XEH_preInit.sqf"

if [ $ERRORS -eq 0 ]; then
    echo "✅ PHYSICAL VFS AUDIT COMPLETE: All Production assets physically verified."
else
    echo "❌ PHYSICAL VFS AUDIT FAILED: $ERRORS files missing from physical map."
    exit 1
fi
