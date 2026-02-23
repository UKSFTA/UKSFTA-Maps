#!/usr/bin/env bash
# UKSFTA Sovereign Diamond Audit Orchestrator
# Triple-Lock Validation: HEMTT + SQFLINT + SQFVM

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🛡️  INITIATING UKSFTA DIAMOND GRADE OPERATIONAL AUDIT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

FAIL=0
WS="/ext/Development/UKSFTA-Maps"

# VFS Mappings for SQFVM (Internal Logic only)
MAPS="-v /z/uksfta/addons/main|$WS/addons/main"
MAPS="$MAPS -v /z/uksfta/addons/environment|$WS/addons/environment"
MAPS="$MAPS -v /z/uksfta/addons/cartography|$WS/addons/cartography"
MAPS="$MAPS -v /z/uksfta/addons/camouflage|$WS/addons/camouflage"

# 1. HEMTT (Build Integrity - STRICT)
echo "🏗️  [1/7] AUDITING BUILD INTEGRITY (HEMTT)..."
(cd "$WS" && hemtt check) > /tmp/uksfta_hemtt.log 2>&1
if grep -qi "warning" /tmp/uksfta_hemtt.log || grep -qi "error" /tmp/uksfta_hemtt.log; then
    echo "  ❌ HEMTT STANDARD: FAILED (Warnings or Errors detected)"
    grep -E "warning|error" /tmp/uksfta_hemtt.log
    FAIL=1
else
    echo "  ✅ HEMTT STANDARD: VERIFIED (0 Warnings)"
fi

# 2. SQFLINT (Static Analysis)
echo -e "\n🔍 [2/7] AUDITING STATIC ANALYSIS (SQFLINT)..."
if sqflint -d "$WS/addons" 2>&1 | grep -v "fileExists" | grep -E "error|warning" > /tmp/uksfta_sqflint.log; then
    echo "  ❌ SQFLINT STANDARD: FAILED"
    cat /tmp/uksfta_sqflint.log
    FAIL=1
else
    echo "  ✅ SQFLINT STANDARD: VERIFIED"
fi

# 3. PHYSICAL VFS DISCOVERY
echo -e "\n📂 [3/7] AUDITING PHYSICAL VFS MAPPING..."
chmod +x "$WS/tests/test_physical_paths.sh"
if "$WS/tests/test_physical_paths.sh" > /tmp/uksfta_vfs.log 2>&1; then
    echo "  ✅ PHYSICAL VFS: VERIFIED"
else
    echo "  ❌ PHYSICAL VFS: FAILED"
    cat /tmp/uksfta_vfs.log | grep "❌"
    FAIL=1
fi

# 4. TOTAL OPERATIONAL MATRIX
echo -e "\n💎 [4/7] AUDITING SOVEREIGN TOTAL MATRIX (PRECISION)..."
sqfvm -a -v "$WS|$WS" -i "$WS/tests/test_total_matrix.sqf" > /tmp/uksfta_matrix.log 2>&1
grep "📊" /tmp/uksfta_matrix.log | sed 's/\[DIAG\]//g' | grep -E "ARCTIC|TROPICAL|ARID|TEMPERATE|MEDITERRANEAN"
if grep -q "❌" /tmp/uksfta_matrix.log; then FAIL=1; fi

# 5. INDIVIDUAL SCENARIOS
echo -e "\n🧪 [5/7] AUDITING INDIVIDUAL LOGIC PILLARS..."
CORE_TESTS=("test_solar_logic.sqf" "test_thermal_logic.sqf" "test_environmental_scenarios.sqf" "test_camouflage_matrix.sqf" "test_realism_fx.sqf")
for t in "${CORE_TESTS[@]}"; do
    sqfvm -a -v "$WS|$WS" -i "$WS/tests/$t" > /tmp/uksfta_core.log 2>&1
    if grep -q "❌" /tmp/uksfta_core.log; then 
        echo "  ❌ Audit FAILED: $t"
        FAIL=1
    else
        echo "  ✅ Audit PASSED: $t"
    fi
done

# 6. DIAGNOSTIC HUD
echo -e "\n📺 [6/7] AUDITING DIAGNOSTIC HUD LOGIC..."
sqfvm -a -v "$WS|$WS" -i "$WS/tests/test_debug_hud.sqf" > /tmp/uksfta_hud.log 2>&1
grep -E "HUD OUTPUT|✅" /tmp/uksfta_hud.log | sed 's/\[DIAG\]//g'
if grep -q "❌" /tmp/uksfta_hud.log; then FAIL=1; fi

# 7. WEATHER EVOLUTION
echo -e "\n🌦️  [7/7] AUDITING WEATHER EVOLUTION TIMELINE..."
sqfvm -a -v "$WS|$WS" -i "$WS/tests/test_weather_evolution.sqf" > /tmp/uksfta_evolution.log 2>&1
grep -E "⏳|📊|✅|❌" /tmp/uksfta_evolution.log | sed 's/\[DIAG\]//g'
if grep -q "❌" /tmp/uksfta_evolution.log; then FAIL=1; fi

if [ $FAIL -eq 0 ]; then
    echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🏅 FINAL STATUS: MISSION CAPABLE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🚨 FINAL STATUS: STALL (Technical Defects Detected)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    exit 1
fi
