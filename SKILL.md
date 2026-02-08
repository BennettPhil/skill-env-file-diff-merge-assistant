---
name: env-file-diff-merge-assistant
description: Compare multiple .env files, show missing keys, and highlight conflicting values.
version: 0.1.0
license: Apache-2.0
---

# Env File Diff Merge Assistant

## Purpose

This skill compares multiple `.env` files and reports what is missing in each file plus which keys have conflicting values across environments. It is intended for quick local checks and CI gates when keeping `.env.example`, `.env.local`, and deployment files in sync.

## See It in Action

Start with `examples/basic-example.md` for the fastest path to a working command and expected output.

## Examples Index

- `examples/basic-example.md`: Minimal command to compare two env files and read the report.
- `examples/common-patterns.md`: Typical day-to-day usage for local checks, CI JSON output, and required keys.
- `examples/advanced-usage.md`: Piping, strict mode checks, and richer output combinations.
- `examples/edge-cases.md`: Behavior with empty files, malformed lines, and missing files.

## Reference

- Command: `./scripts/run.sh [options] <env-file> [<env-file> ...]`
- `--format text|json`: Output format (default `text`).
- `--show-values`: Include actual conflict values in text mode.
- `--strict`: Exit with code `1` when missing entries or conflicts exist.
- `--require KEY1,KEY2`: Treat listed keys as required in every file.
- Exit codes:
- `0`: Successful run with no strict failures.
- `1`: Strict mode failure (differences found).
- `2`: Invalid usage or file access errors.

## Installation

- `python3` must be available in `PATH`.
- No third-party dependencies are required.
- Make scripts executable if needed:
- `chmod +x scripts/run.sh scripts/test-examples.sh`

