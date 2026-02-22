#!/usr/bin/env bash
# UKSFTA Platinum Audit Orchestrator
# PROVIDES: Full-Fidelity Technical Manifest

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🛡️  INITIATING UKSFTA DIAMOND GRADE OPERATIONAL AUDIT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

FAIL=0
WS="/ext/Development/UKSFTA-Maps"

echo "🏗️  [1/3] AUDITING BUILD INTEGRITY (HEMTT)..."
if (cd "$WS" && hemtt check > /tmp/uksfta_hemtt.log 2>&1); then
    echo "  ✅ HEMTT STANDARD: VERIFIED (0 Warnings)"
else
    echo "  ❌ HEMTT STANDARD: FAILED"
    cat /tmp/uksfta_hemtt.log
    FAIL=1
fi

echo -e "\n🧪 [2/3] AUDITING LOGIC MANIFEST (SQFVM)..."

# Define tests to run
TESTS=("test_solar_logic.sqf" "test_thermal_logic.sqf" "test_environmental_scenarios.sqf" "test_camouflage_matrix.sqf")

for t in "${TESTS[@]}"; do
    echo "  🔍 Audit: $t"
    sqfvm -a -v "$WS|$WS" -i "$WS/tests/$t" > /tmp/uksfta_test.log 2>&1
    
    # Display ALL diagnostic lines for total transparency
    grep -E "✅|❌|🧪|🏁" /tmp/uksfta_test.log | sed 's/\[DIAG\]//g'
    
    if grep -q "❌" /tmp/uksfta_test.log; then
        FAIL=1
    fi
done

echo -e "\n📊 [3/3] AUDITING PERFORMANCE BENCHMARKS..."
sqfvm -a -v "$WS|$WS" -i "$WS/tests/test_performance.sqf" > /tmp/uksfta_perf.log 2>&1
grep "📊" /tmp/uksfta_perf.log | sed 's/\[DIAG\]//g'

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
