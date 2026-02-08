# Advanced Usage

## Scenario 1: Fail Fast but Keep Detailed Conflict Values

Use strict mode for CI while still printing real values for debugging.

Command:

```bash
./scripts/run.sh --show-values --strict --require API_URL,SECRET_KEY examples/data/.env.example examples/data/.env.local examples/data/.env.production || echo "exit code: $?"
```

Sample input:

```text
Three env files, strict mode, explicit required key SECRET_KEY
```

Expected output:

```text
FILES_SCANNED: 3
TOTAL_KEYS: 6
MISSING_ENTRIES: 6
CONFLICT_KEYS: 4
MISSING:
  FEATURE_X -> examples/data/.env.example
  FEATURE_X -> examples/data/.env.production
  REDIS_URL -> examples/data/.env.local
  SECRET_KEY -> examples/data/.env.example
  SECRET_KEY -> examples/data/.env.local
  SECRET_KEY -> examples/data/.env.production
CONFLICTS:
  API_URL
    examples/data/.env.example=https://api.example.com
    examples/data/.env.local=https://dev.api.local
    examples/data/.env.production=https://api.example.com
  APP_NAME
    examples/data/.env.example=Runner
    examples/data/.env.local=Runner Local
    examples/data/.env.production=Runner
  LOG_LEVEL
    examples/data/.env.example=info
    examples/data/.env.local=debug
    examples/data/.env.production=warn
  REDIS_URL
    examples/data/.env.example=redis://localhost:6379/0
    examples/data/.env.production=redis://redis:6379/0
exit code: 1
```

## Scenario 2: Pipe JSON into Another Tool

Extract only conflict key names for alerts or dashboards.

Command:

```bash
./scripts/run.sh --format json examples/data/.env.example examples/data/.env.local examples/data/.env.production | python3 -c 'import json,sys; d=json.load(sys.stdin); print(",".join(c["key"] for c in d["conflicts"]))'
```

Sample input:

```text
JSON output piped to python3 for key extraction
```

Expected output:

```text
API_URL,APP_NAME,LOG_LEVEL,REDIS_URL
```

## Scenario 3: Produce Compact Metrics for Automation

Generate a quick 2-line summary that can be parsed by scripts.

Command:

```bash
./scripts/run.sh --format json --require API_URL,SECRET_KEY examples/data/.env.example examples/data/.env.local examples/data/.env.production | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["total_keys"]); print(len(d["missing_entries"]))'
```

Sample input:

```text
JSON output with required keys
```

Expected output:

```text
6
6
```
