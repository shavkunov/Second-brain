#!/usr/bin/env bash
# init-kb.test.sh — Verify that init-kb.sh creates the correct structure.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INIT_KB="$SCRIPT_DIR/../scripts/init-kb.sh"

# Create a temp directory for the test project
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT

echo "Testing init-kb.sh in: $TEST_DIR"

# --- Test 1: Basic invocation ---
echo -n "  Test 1: Basic invocation... "
bash "$INIT_KB" "$TEST_DIR" --name "Test Project"

# Verify KB directory exists
[[ -d "$TEST_DIR/kb" ]] || { echo "FAIL: kb/ not created"; exit 1; }

# Verify project folder exists (slug: test-project)
[[ -d "$TEST_DIR/kb/test-project" ]] || { echo "FAIL: test-project/ not created"; exit 1; }

# Verify all 6 files + map.md + README.md
for f in current.md technical.md runbook.md decisions.md history.md links.md; do
    [[ -f "$TEST_DIR/kb/test-project/$f" ]] || { echo "FAIL: $f not created"; exit 1; }
done
[[ -f "$TEST_DIR/kb/map.md" ]] || { echo "FAIL: map.md not created"; exit 1; }
[[ -f "$TEST_DIR/kb/README.md" ]] || { echo "FAIL: README.md not created"; exit 1; }

echo "PASS"

# --- Test 2: Project name substitution ---
echo -n "  Test 2: Name substitution in current.md... "
head -1 "$TEST_DIR/kb/test-project/current.md" | grep -q "Test Project" \
    || { echo "FAIL: project name not substituted in current.md"; exit 1; }
echo "PASS"

# --- Test 3: map.md references project folder ---
echo -n "  Test 3: map.md references... "
grep -q "test-project" "$TEST_DIR/kb/map.md" \
    || { echo "FAIL: map.md doesn't reference project folder"; exit 1; }
echo "PASS"

# --- Test 4: No --name flag (derive from directory) ---
TEST_DIR2="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR" "$TEST_DIR2"' EXIT

echo -n "  Test 4: Auto-derive project name... "
mkdir -p "$TEST_DIR2/my-awesome-app"
bash "$INIT_KB" "$TEST_DIR2/my-awesome-app"
[[ -d "$TEST_DIR2/my-awesome-app/kb/my-awesome-app" ]] \
    || { echo "FAIL: auto-derived slug not correct"; exit 1; }
echo "PASS"

# --- Test 5: Idempotent (run twice) ---
echo -n "  Test 5: Idempotent (run twice)... "
bash "$INIT_KB" "$TEST_DIR" --name "Test Project"
# Should still have all files
for f in current.md technical.md runbook.md decisions.md history.md links.md; do
    [[ -f "$TEST_DIR/kb/test-project/$f" ]] || { echo "FAIL: $f missing after re-run"; exit 1; }
done
echo "PASS"

# --- Test 6: Error on missing directory ---
echo -n "  Test 6: Error on missing directory... "
if bash "$INIT_KB" "/nonexistent/path" 2>/dev/null; then
    echo "FAIL: should have errored on missing directory"; exit 1
fi
echo "PASS"

# --- Test 7: Error on no arguments ---
echo -n "  Test 7: Error on no arguments... "
if bash "$INIT_KB" 2>/dev/null; then
    echo "FAIL: should have errored with no args"; exit 1
fi
echo "PASS"

echo ""
echo "All tests passed."
