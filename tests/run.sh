#!/bin/bash
# Java/Maven test runner with progressive unlocking

MODULE_ID="stack"

get_current_challenge_index() {
  if [ -f dsa.config.json ]; then
    python3 -c "import json; print(json.load(open('dsa.config.json'))['currentChallengeIndex'])" 2>/dev/null || echo "0"
  else
    echo "0"
  fi
}

# Test mapping
declare -a ALL_TESTS=(
  "Test01_CreateClass:create-class"
  "Test02_Push:push"
  "Test03_Pop:pop"
  "Test04_Peek:peek"
  "Test05_Size:size"
)

currentIndex=$(get_current_challenge_index)
maxTests=${#ALL_TESTS[@]}
testsToRun=$((currentIndex + 1))

echo "Running tests for: $MODULE_ID"
echo "Current challenge: $testsToRun/$maxTests"
echo ""

# Ensure src/test/java directory exists
mkdir -p src/test/java

# Clean src/test/java directory
find src/test/java -name 'Test*.java' -type f -delete 2>/dev/null

# Copy only unlocked test files
for i in $(seq 0 $currentIndex); do
  test_entry="${ALL_TESTS[$i]}"
  test_file=$(echo "$test_entry" | cut -d: -f1)
  if [ -f "tests/${test_file}.java" ]; then
    cp "tests/${test_file}.java" "src/test/java/"
  fi
done

# Compile
compile_output=$(mvn clean test-compile 2>&1)
compile_exit_code=$?
COMPILATION_FAILED=0
if [ $compile_exit_code -ne 0 ]; then
  echo "✗ Compilation failed:"
  echo "$compile_output"
  COMPILATION_FAILED=1
fi

# Run tests with Maven Surefire (only if compilation succeeded)
if [ $COMPILATION_FAILED -eq 0 ]; then
  mvn surefire:test -q > /dev/null 2>&1
  test_exit_code=$?
else
  test_exit_code=1
fi

# Generate report with Python
COMPILATION_FAILED=$COMPILATION_FAILED python3 << 'PYTHON_SCRIPT'
import json
import sys
import os
import xml.etree.ElementTree as ET

def get_current_challenge_index():
    try:
        if os.path.exists('dsa.config.json'):
            with open('dsa.config.json', 'r') as f:
                config = json.load(f)
                return config.get('currentChallengeIndex', 0)
    except Exception as e:
        return 0
    return 0

MODULE_ID = 'stack'

all_tests = [
    ("Test01_CreateClass", "create-class"),
    ("Test02_Push", "push"),
    ("Test03_Pop", "pop"),
    ("Test04_Peek", "peek"),
    ("Test05_Size", "size"),
]

current_index = get_current_challenge_index()
tests_to_run = all_tests[:current_index + 1]
locked_tests = all_tests[current_index + 1:]

# Check if compilation failed
COMPILATION_FAILED = os.environ.get('COMPILATION_FAILED', '0') == '1'

# Parse Surefire XML reports
test_results_map = {}
if COMPILATION_FAILED:
    # Mark all tests as failed due to compilation error
    for test_class, slug in tests_to_run:
        test_results_map[test_class] = (False, "Compilation failed: Stack class not found or incomplete")
else:
    try:
        for test_class, slug in tests_to_run:
            xml_file = f"target/surefire-reports/TEST-{test_class}.xml"
            if os.path.exists(xml_file):
                tree = ET.parse(xml_file)
                root = tree.getroot()
                failures = int(root.get('failures', 0))
                errors = int(root.get('errors', 0))
                passed = (failures == 0 and errors == 0)
                
                failure_msg = None
                if not passed:
                    for testcase in root.findall('.//testcase'):
                        failure = testcase.find('failure')
                        if failure is not None:
                            failure_msg = failure.get('message', 'Test failed')
                            break
                
                test_results_map[test_class] = (passed, failure_msg)
    except Exception as e:
        print(f"Warning: Could not parse test results: {e}", file=sys.stderr)

cases = []
passed_count = 0

for test_class, slug in tests_to_run:
    if test_class in test_results_map:
        passed, failure_msg = test_results_map[test_class]
        if passed:
            cases.append({"subchallengeId": slug, "passed": True})
            passed_count += 1
            print(f"✓ {slug}")
        else:
            cases.append({"subchallengeId": slug, "passed": False, "message": failure_msg or "Test failed"})
            print(f"✗ {slug}")
    else:
        cases.append({"subchallengeId": slug, "passed": False, "message": "Test not found"})
        print(f"✗ {slug}")

for test_class, slug in locked_tests:
    cases.append({"subchallengeId": slug, "passed": False, "message": "Challenge locked"})

total_run = len(tests_to_run)
report = {
    "moduleId": MODULE_ID,
    "summary": f"{passed_count}/{total_run} tests passed ({len(locked_tests)} locked)",
    "pass": passed_count == total_run,
    "cases": cases,
    "currentChallengeIndex": current_index,
}

with open(".dsa-report.json", "w") as f:
    json.dump(report, f, indent=2)

print(f"\nSummary: {report['summary']}")
sys.exit(0 if report["pass"] else 1)
PYTHON_SCRIPT

exit $?
