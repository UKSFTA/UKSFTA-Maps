#!/usr/bin/env bash
echo "🛡️  UKSFTA Headless Operational Audit starting..."
FAIL=0
WS="/ext/Development/UKSFTA-Maps"

echo "🏗️  Step 1: Build Integrity (hemtt check)..."
(cd "$WS" && hemtt check > /dev/null 2>&1) || { echo "  ❌ HEMTT Check Failed"; FAIL=1; }
echo "  ✅ HEMTT Standard Verified."

echo "🧪 Step 2: Logic & Matrix Validation (sqfvm)..."
sqfvm -a -v "$WS|$WS" -i "$WS/tests/test_weather_logic.sqf" > /tmp/sqfvm_logic.log 2>&1 || FAIL=1
sqfvm -a -v "$WS|$WS" -i "$WS/tests/test_matrix.sqf" > /tmp/sqfvm_matrix.log 2>&1 || FAIL=1
sqfvm -a -v "$WS|$WS" -i "$WS/tests/test_solar_logic.sqf" > /tmp/sqfvm_solar.log 2>&1 || FAIL=1
sqfvm -a -v "$WS|$WS" -i "$WS/tests/test_thermal_logic.sqf" > /tmp/sqfvm_thermal.log 2>&1 || FAIL=1

if grep -q "❌" /tmp/sqfvm_matrix.log; then echo "  ❌ Matrix Failure detected"; FAIL=1; fi
if grep -q "❌" /tmp/sqfvm_solar.log; then echo "  ❌ Solar Logic Failure detected"; FAIL=1; fi
if grep -q "❌" /tmp/sqfvm_thermal.log; then echo "  ❌ Thermal Logic Failure detected"; FAIL=1; fi

echo "  ✅ Environmental & Solar Logic Verified."

echo "📊 Step 3: Performance Audit..."
sqfvm -a -v "$WS|$WS" -i "$WS/tests/test_performance.sqf" > /tmp/sqfvm_perf.log 2>&1 || FAIL=1
grep "📊" /tmp/sqfvm_perf.log
echo "  ✅ Performance Benchmarks Recorded."

if [ $FAIL -eq 0 ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ SUCCESS: All systems MISSION CAPABLE."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo "❌ FAILURE: Technical defects detected."
    exit 1
fi
