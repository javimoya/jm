#!/usr/bin/env python3
"""Light contract check for the jm command frontmatter.

This is intentionally small: jm is a Markdown prompt plugin, so the cheap, high-value things to
guard in CI are that every command's YAML frontmatter parses and that the invariants we rely on
(no auto-invocation, an inherited model, the audit fork) are actually present. It does NOT try to
model project state — there is no state.json by design.

Exit non-zero on the first failure so CI fails loudly.
"""
import sys
from pathlib import Path

try:
    import yaml
except ModuleNotFoundError:
    sys.exit("PyYAML is required (pip install pyyaml)")

REPO = Path(__file__).resolve().parent.parent
COMMANDS = sorted((REPO / "commands").glob("*.md"))

# Commands that take an explicit phase id/slug argument.
WANT_ARG_HINT = {"discover.md", "build.md", "audit.md"}


def frontmatter(path: Path) -> dict:
    text = path.read_text()
    if not text.startswith("---"):
        raise ValueError("no frontmatter block")
    _, fm, _ = text.split("---", 2)
    data = yaml.safe_load(fm)
    if not isinstance(data, dict):
        raise ValueError("frontmatter is not a mapping")
    return data


def main() -> int:
    if not COMMANDS:
        print("no commands found", file=sys.stderr)
        return 1

    errors: list[str] = []
    for path in COMMANDS:
        name = path.name
        try:
            fm = frontmatter(path)
        except Exception as exc:  # noqa: BLE001 - report any parse failure
            errors.append(f"{name}: invalid frontmatter ({exc})")
            continue

        if not fm.get("description"):
            errors.append(f"{name}: missing 'description'")
        if fm.get("model") != "inherit":
            errors.append(f"{name}: expected model: inherit, got {fm.get('model')!r}")
        if fm.get("disable-model-invocation") is not True:
            errors.append(f"{name}: must set disable-model-invocation: true")
        if name in WANT_ARG_HINT and not fm.get("argument-hint"):
            errors.append(f"{name}: expected an argument-hint")

        # Only the audit runs in a forked context; nothing else should.
        has_fork = fm.get("context") == "fork"
        if name == "audit.md" and not has_fork:
            errors.append("audit.md: must set context: fork")
        if name != "audit.md" and has_fork:
            errors.append(f"{name}: only audit.md should set context: fork")

    if errors:
        print("Command frontmatter check FAILED:", file=sys.stderr)
        for e in errors:
            print(f"  - {e}", file=sys.stderr)
        return 1

    print(f"Command frontmatter check OK ({len(COMMANDS)} commands).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
