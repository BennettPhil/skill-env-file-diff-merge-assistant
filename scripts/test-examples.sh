#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

PASS_COUNT=0
FAIL_COUNT=0

run_check() {
  local name="$1"
  local cmd="$2"
  local expected="$3"

  local actual
  if ! actual="$(eval "$cmd" 2>&1)"; then
    actual="$actual"
  fi

  if [[ "$actual" == "$expected" ]]; then
    echo "PASS: $name"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo "FAIL: $name"
    echo "--- expected ---"
    printf '%s\n' "$expected"
    echo "--- actual ---"
    printf '%s\n' "$actual"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

EXPECTED_BASIC=$(cat <<'OUT'
FILES_SCANNED: 2
TOTAL_KEYS: 5
MISSING_ENTRIES: 2
CONFLICT_KEYS: 3
MISSING:
  FEATURE_X -> examples/data/.env.example
  REDIS_URL -> examples/data/.env.local
CONFLICTS:
  API_URL
    examples/data/.env.example=https://api.example.com
    examples/data/.env.local=https://dev.api.local
  APP_NAME
    examples/data/.env.example=Runner
    examples/data/.env.local=Runner Local
  LOG_LEVEL
    examples/data/.env.example=info
    examples/data/.env.local=debug
OUT
)

run_check \
  "basic text comparison" \
  "./scripts/run.sh --show-values examples/data/.env.example examples/data/.env.local" \
  "$EXPECTED_BASIC"

EXPECTED_STRICT=$(cat <<'OUT'
FILES_SCANNED: 2
TOTAL_KEYS: 5
MISSING_ENTRIES: 2
CONFLICT_KEYS: 3
MISSING:
  FEATURE_X -> examples/data/.env.example
  REDIS_URL -> examples/data/.env.local
CONFLICTS:
  API_URL
    examples/data/.env.example=<hidden>
    examples/data/.env.local=<hidden>
  APP_NAME
    examples/data/.env.example=<hidden>
    examples/data/.env.local=<hidden>
  LOG_LEVEL
    examples/data/.env.example=<hidden>
    examples/data/.env.local=<hidden>
exit code: 1
OUT
)

run_check \
  "strict mode exit code" \
  "./scripts/run.sh --strict examples/data/.env.example examples/data/.env.local || echo 'exit code: 1'" \
  "$EXPECTED_STRICT"

EXPECTED_COUNT="3"
run_check \
  "json missing count" \
  "./scripts/run.sh --format json examples/data/.env.example examples/data/.env.local examples/data/.env.production | python3 -c 'import json,sys; print(len(json.load(sys.stdin)[\"missing_entries\"]))'" \
  "$EXPECTED_COUNT"

echo
echo "RESULT: $PASS_COUNT passed, $FAIL_COUNT failed"
if [[ "$FAIL_COUNT" -gt 0 ]]; then
  exit 1
fi
