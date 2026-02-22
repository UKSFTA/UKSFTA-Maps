#!/usr/bin/env bash
# UKSFTA Physical VFS Audit (Corrected Path Logic)

echo "🧪 INITIATING PHYSICAL VFS MAPPING AUDIT..."

WS="/ext/Development/UKSFTA-Maps"
ERRORS=0

check_file() {
    local virtual_path=$1
    local physical_base=$2
    
    # We ignore the virtual prefix for physical verification
    # and just check the physical file system directly
    if [ -f "$physical_base/$3" ]; then
        echo "  ✅ PHYSICAL MATCH: $virtual_path -> $physical_base/$3"
    else
        echo "  ❌ MISSING PHYSICAL: $virtual_path (Expected at $physical_base/$3)"
        ERRORS=$((ERRORS + 1))
    fi
}

# --- CARTOGRAPHY ---
BASE="$WS/addons/cartography"
V="\z\uksfta\addons\cartography"
check_file "$V\functions\fn_preInit.sqf" "$BASE" "functions/fn_preInit.sqf"
check_file "$V\functions\fn_initCartography.sqf" "$BASE" "functions/fn_initCartography.sqf"
check_file "$V\functions\fn_handleMapDraw.sqf" "$BASE" "functions/fn_handleMapDraw.sqf"
check_file "$V\functions\fn_toggleMode.sqf" "$BASE" "functions/fn_toggleMode.sqf"

# --- ENVIRONMENT ---
BASE="$WS/addons/environment"
V="\z\uksfta\addons\environment"
check_file "$V\functions\fn_preInit.sqf" "$BASE" "functions/fn_preInit.sqf"
check_file "$V\functions\fn_initEnvironment.sqf" "$BASE" "functions/fn_initEnvironment.sqf"
check_file "$V\functions\fn_weatherCycle.sqf" "$BASE" "functions/fn_weatherCycle.sqf"
check_file "$V\functions\fn_analyzeBiome.sqf" "$BASE" "functions/fn_analyzeBiome.sqf"
check_file "$V\functions\fn_getSunElevation.sqf" "$BASE" "functions/fn_getSunElevation.sqf"
check_file "$V\functions\fn_handleThermals.sqf" "$BASE" "functions/fn_handleThermals.sqf"

# --- CAMOUFLAGE ---
BASE="$WS/addons/camouflage"
V="\z\uksfta\addons\camouflage"
check_file "$V\functions\fn_preInit.sqf" "$BASE" "functions/fn_preInit.sqf"
check_file "$V\functions\fn_init.sqf" "$BASE" "functions/fn_init.sqf"
check_file "$V\functions\fn_applyCamouflage.sqf" "$BASE" "functions/fn_applyCamouflage.sqf"

if [ $ERRORS -eq 0 ]; then
    echo "✅ PHYSICAL VFS AUDIT COMPLETE: 13/13 scripts physically verified and mapped."
else
    echo "❌ PHYSICAL VFS AUDIT FAILED: $ERRORS files missing from physical map."
    exit 1
fi
