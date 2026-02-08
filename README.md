# Env File Diff Merge Assistant

Compare multiple `.env` files and quickly see missing keys plus conflicting values.

Most compelling example:

```bash
./scripts/run.sh --show-values examples/data/.env.example examples/data/.env.local
```

Quick start:

```bash
chmod +x scripts/run.sh scripts/test-examples.sh
./scripts/run.sh examples/data/.env.example examples/data/.env.local
./scripts/test-examples.sh
```

More examples:

- `examples/basic-example.md`
- `examples/common-patterns.md`
- `examples/advanced-usage.md`
- `examples/edge-cases.md`

Prerequisites:

- `python3`
- POSIX shell (`bash`) for running `scripts/test-examples.sh`
