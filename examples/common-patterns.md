# Common Patterns

## Pattern 1: Compare Dev, Local, and Production

When you have three environment files and want a quick drift report.

Command:

```bash
./scripts/run.sh examples/data/.env.example examples/data/.env.local examples/data/.env.production
```

Sample input:

```text
examples/data/.env.example
examples/data/.env.local
examples/data/.env.production
```

Expected output:

```text
FILES_SCANNED: 3
TOTAL_KEYS: 5
MISSING_ENTRIES: 3
CONFLICT_KEYS: 4
MISSING:
  FEATURE_X -> examples/data/.env.example
  FEATURE_X -> examples/data/.env.production
  REDIS_URL -> examples/data/.env.local
CONFLICTS:
  API_URL
    examples/data/.env.example=<hidden>
    examples/data/.env.local=<hidden>
    examples/data/.env.production=<hidden>
  APP_NAME
    examples/data/.env.example=<hidden>
    examples/data/.env.local=<hidden>
    examples/data/.env.production=<hidden>
  LOG_LEVEL
    examples/data/.env.example=<hidden>
    examples/data/.env.local=<hidden>
    examples/data/.env.production=<hidden>
  REDIS_URL
    examples/data/.env.example=<hidden>
    examples/data/.env.production=<hidden>
```

## Pattern 2: JSON Output for CI or Bots

When another script needs machine-readable output.

Command:

```bash
./scripts/run.sh --format json examples/data/.env.example examples/data/.env.local examples/data/.env.production | python3 -c 'import json,sys; print(len(json.load(sys.stdin)["missing_entries"]))'
```

Sample input:

```text
--format json with three env files
```

Expected output:

```text
3
```

## Pattern 3: Require Critical Keys Everywhere

When certain keys must exist in every environment, even if not present anywhere yet.

Command:

```bash
./scripts/run.sh --require API_URL,SECRET_KEY examples/data/.env.example examples/data/.env.local examples/data/.env.production
```

Sample input:

```text
Required keys: API_URL, SECRET_KEY
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
    examples/data/.env.example=<hidden>
    examples/data/.env.local=<hidden>
    examples/data/.env.production=<hidden>
  APP_NAME
    examples/data/.env.example=<hidden>
    examples/data/.env.local=<hidden>
    examples/data/.env.production=<hidden>
  LOG_LEVEL
    examples/data/.env.example=<hidden>
    examples/data/.env.local=<hidden>
    examples/data/.env.production=<hidden>
  REDIS_URL
    examples/data/.env.example=<hidden>
    examples/data/.env.production=<hidden>
```
