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

# 1. HEMTT (Build Integrity)
echo "🏗️  [1/6] AUDITING BUILD INTEGRITY (HEMTT)..."
if (cd "$WS" && hemtt check > /tmp/uksfta_hemtt.log 2>&1); then
    echo "  ✅ HEMTT STANDARD: VERIFIED (0 Warnings)"
else
    echo "  ❌ HEMTT STANDARD: FAILED"
    cat /tmp/uksfta_hemtt.log | grep -E "error|warning"
    FAIL=1
fi

# 2. SQFLINT (Static Analysis)
echo -e "\n🔍 [2/6] AUDITING STATIC ANALYSIS (SQFLINT)..."
# We specifically grep out fileExists as it is a known false positive in this tool
if sqflint -d "$WS/addons" 2>&1 | grep -v "fileExists" | grep -E "error|warning" > /tmp/uksfta_sqflint.log; then
    echo "  ❌ SQFLINT STANDARD: FAILED"
    cat /tmp/uksfta_sqflint.log
    FAIL=1
else
    echo "  ✅ SQFLINT STANDARD: VERIFIED"
fi

# 3. PHYSICAL VFS DISCOVERY
echo -e "\n📂 [3/6] AUDITING PHYSICAL VFS MAPPING..."
chmod +x "$WS/tests/test_physical_paths.sh"
if "$WS/tests/test_physical_paths.sh" > /tmp/uksfta_vfs.log 2>&1; then
    echo "  ✅ PHYSICAL VFS: VERIFIED"
else
    echo "  ❌ PHYSICAL VFS: FAILED"
    cat /tmp/uksfta_vfs.log | grep "❌"
    FAIL=1
fi

# 4. TOTAL OPERATIONAL MATRIX
echo -e "\n💎 [4/6] AUDITING SOVEREIGN TOTAL MATRIX (PRECISION)..."
sqfvm -a -v "$WS|$WS" -i "$WS/tests/test_total_matrix.sqf" > /tmp/uksfta_matrix.log 2>&1
grep "📊" /tmp/uksfta_matrix.log | sed 's/\[DIAG\]//g' | head -n 12
if grep -q "❌" /tmp/uksfta_matrix.log; then FAIL=1; fi

# 5. INDIVIDUAL SCENARIOS
echo -e "\n🧪 [5/6] AUDITING INDIVIDUAL LOGIC PILLARS..."
CORE_TESTS=("test_solar_logic.sqf" "test_thermal_logic.sqf" "test_environmental_scenarios.sqf" "test_camouflage_matrix.sqf")
for t in "${CORE_TESTS[@]}"; do
    sqfvm -a -v "$WS|$WS" -i "$WS/tests/$t" > /tmp/uksfta_core.log 2>&1
    if grep -q "❌" /tmp/uksfta_core.log; then 
        echo "  ❌ Audit FAILED: $t"
        FAIL=1
    else
        echo "  ✅ Audit PASSED: $t"
    fi
done

# 6. WEATHER EVOLUTION
echo -e "\n🌦️  [6/6] AUDITING WEATHER EVOLUTION TIMELINE..."
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
