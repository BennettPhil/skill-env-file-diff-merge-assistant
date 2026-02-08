# Basic Example: Compare Two Env Files

This example shows the fastest way to compare `.env.example` and `.env.local` and see exactly which keys are missing or conflicting.

## What You Will Learn

In this example, you will use `env-file-diff-merge-assistant` to compare two files. By the end, you will understand:

- How to run the basic compare command
- How missing keys are reported
- How strict mode can fail a check

## Prerequisites

- Run from the skill root directory
- Ensure `python3` is available

## Step 1: Run the Skill

```bash
./scripts/run.sh --show-values examples/data/.env.example examples/data/.env.local
```

## Step 2: See the Output

Expected output:

```text
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
```

## Step 3: Try a Variation

Use strict mode so CI-style checks fail when differences exist:

```bash
./scripts/run.sh --strict examples/data/.env.example examples/data/.env.local || echo "exit code: $?"
```

Expected output:

```text
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
```

## What Just Happened

The script parsed both files, built a key union, and reported where each key was missing. It also detected keys with different values across files and listed them as conflicts.

## Next Steps

- For practical team workflows, see [Common Patterns](./common-patterns.md)
- For command combinations and piping, see [Advanced Usage](./advanced-usage.md)
- For behavior under unusual inputs, see [Edge Cases](./edge-cases.md)
