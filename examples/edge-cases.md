# Edge Cases

## Edge Case 1: One File Is Empty

When one environment file exists but has no variables.

Command:

```bash
./scripts/run.sh examples/data/.env.empty examples/data/.env.example
```

Sample input:

```text
.env.empty contains zero keys
```

Expected output:

```text
FILES_SCANNED: 2
TOTAL_KEYS: 4
MISSING_ENTRIES: 4
CONFLICT_KEYS: 0
MISSING:
  APP_NAME -> examples/data/.env.empty
  API_URL -> examples/data/.env.empty
  LOG_LEVEL -> examples/data/.env.empty
  REDIS_URL -> examples/data/.env.empty
CONFLICTS:
  (none)
```

## Edge Case 2: Malformed Lines

Malformed lines are ignored if they are not valid `KEY=VALUE` assignments.

Command:

```bash
./scripts/run.sh --show-values examples/data/.env.malformed examples/data/.env.example
```

Sample input:

```text
.env.malformed contains valid and invalid lines
```

Expected output:

```text
FILES_SCANNED: 2
TOTAL_KEYS: 4
MISSING_ENTRIES: 3
CONFLICT_KEYS: 1
MISSING:
  APP_NAME -> examples/data/.env.malformed
  LOG_LEVEL -> examples/data/.env.malformed
  REDIS_URL -> examples/data/.env.malformed
CONFLICTS:
  API_URL
    examples/data/.env.malformed=https://staging.example.com
    examples/data/.env.example=https://api.example.com
```

## Edge Case 3: Missing File Path

If an input file path does not exist, the command exits with code `2`.

Command:

```bash
./scripts/run.sh examples/data/.env.example examples/data/.env.does-not-exist 2>&1 || echo "exit code: $?"
```

Sample input:

```text
Second path points to a non-existent file
```

Expected output:

```text
ERROR: file not found: examples/data/.env.does-not-exist
exit code: 2
```
