#!/usr/bin/env python3
import argparse
import json
import re
import sys
from pathlib import Path


KEY_PATTERN = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


def parse_env_file(path: Path) -> dict:
    values = {}
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("export "):
            line = line[len("export ") :].strip()
        if "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip()
        if not KEY_PATTERN.match(key):
            continue
        values[key] = value
    return values


def to_json(files, keys, missing_entries, conflicts):
    payload = {
        "files_scanned": len(files),
        "files": files,
        "total_keys": len(keys),
        "missing_entries": [{"key": key, "file": file_name} for key, file_name in missing_entries],
        "conflicts": [
            {
                "key": key,
                "values": [{"file": file_name, "value": value} for file_name, value in items],
            }
            for key, items in conflicts
        ],
    }
    return json.dumps(payload, indent=2)


def to_text(files, keys, missing_entries, conflicts, show_values):
    lines = [
        f"FILES_SCANNED: {len(files)}",
        f"TOTAL_KEYS: {len(keys)}",
        f"MISSING_ENTRIES: {len(missing_entries)}",
        f"CONFLICT_KEYS: {len(conflicts)}",
        "MISSING:",
    ]
    if missing_entries:
        for key, file_name in missing_entries:
            lines.append(f"  {key} -> {file_name}")
    else:
        lines.append("  (none)")

    lines.append("CONFLICTS:")
    if conflicts:
        for key, items in conflicts:
            lines.append(f"  {key}")
            for file_name, value in items:
                shown = value if show_values else "<hidden>"
                lines.append(f"    {file_name}={shown}")
    else:
        lines.append("  (none)")
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(
        description="Compare env files and report missing keys and conflicting values."
    )
    parser.add_argument("--format", choices=["text", "json"], default="text")
    parser.add_argument("--show-values", action="store_true")
    parser.add_argument("--strict", action="store_true")
    parser.add_argument("--require", default="", help="Comma-separated keys required in every file.")
    parser.add_argument("files", nargs="+")
    args = parser.parse_args()

    files = [str(Path(file_name)) for file_name in args.files]
    parsed = {}
    for file_name in files:
        path = Path(file_name)
        if not path.exists():
            print(f"ERROR: file not found: {file_name}", file=sys.stderr)
            sys.exit(2)
        parsed[file_name] = parse_env_file(path)

    all_keys = sorted({key for values in parsed.values() for key in values})
    required_keys = [key.strip() for key in args.require.split(",") if key.strip()]
    for key in required_keys:
        if key not in all_keys:
            all_keys.append(key)
    all_keys = sorted(all_keys)

    missing_entries = []
    seen_missing = set()
    for key in all_keys:
        for file_name in files:
            if key not in parsed[file_name]:
                entry = (key, file_name)
                if entry not in seen_missing:
                    missing_entries.append(entry)
                    seen_missing.add(entry)
    missing_entries.sort(key=lambda item: (item[0], item[1]))

    conflicts = []
    for key in all_keys:
        key_values = []
        unique_values = set()
        for file_name in files:
            if key in parsed[file_name]:
                value = parsed[file_name][key]
                key_values.append((file_name, value))
                unique_values.add(value)
        if len(unique_values) > 1:
            conflicts.append((key, key_values))

    if args.format == "json":
        output = to_json(files, all_keys, missing_entries, conflicts)
    else:
        output = to_text(files, all_keys, missing_entries, conflicts, args.show_values)
    print(output)

    if args.strict and (missing_entries or conflicts):
        sys.exit(1)
    sys.exit(0)


if __name__ == "__main__":
    main()
