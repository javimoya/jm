# RUNBOOK.md format

`.jm/RUNBOOK.md` pins **how this project is run and verified**, so every clean session executes the
*same* commands instead of re-guessing them. `/jm:build` runs the full suite from here for its
baseline; `/jm:audit` runs the same one to verify — if each invented its own command, "green" would
mean different things in different sessions. Created **lazily** — first pinned in `/jm:discover` or
`/jm:build` when a real run/test command exists — and kept current as the stack solidifies.

## Structure

```md
# RUNBOOK — {Project name}

## Prerequisites & setup
{Toolchain/runtime versions, install/bootstrap steps. The one-time commands to get a working tree
able to build and test (e.g. `npm ci`, `uv sync`, `make setup`).}

## Environment
{Environment variables the project needs — by NAME only, with what each is for. Never a value.
e.g. `DATABASE_URL` — connection string for the dev DB. `STRIPE_KEY` — test-mode API key.}

## Full suite (the canonical one)
{The single command that runs the complete test suite. This exact command is the baseline and the
audit check. e.g. `npm test` / `pytest -q` / `cargo test --all`.}

## Focused tests
{How to run a subset while iterating — by path, file, or name filter. e.g. `pytest path/to/test.py -k name`.}

## Lint / static analysis
{Format, lint, type-check, and any static gate. e.g. `ruff check . && mypy .`.}

## Build
{How to produce the build artifact, if any. e.g. `npm run build` / `cargo build --release`.}

## Deliverable — "How to see it"
{The real command(s)/steps a user runs to exercise the current deliverable and what to observe.
Mirrors the active SPEC's "How to see it".}

## Destructive paths & external effects
{Commands or steps that touch the network, write data, deploy, send, or are otherwise irreversible —
flagged so a session (especially `/jm:audit`) never runs them blindly. e.g. `make deploy` (pushes to
prod), `scripts/seed.py` (drops & recreates tables).}
```

## Rules

- **One canonical full-suite command.** "Full suite" must resolve to a single, copy-pasteable command.
  `/jm:build`'s baseline and `/jm:audit`'s verification run *that* command — never two different ones.
- **Env vars by name, never by value.** `.jm/` is committed. Record what a variable is for, never its
  secret value (constitution: "Keep secrets out of `.jm/`").
- **Destructive and outward steps are flagged, not hidden.** Anything that deletes, migrates, deploys,
  sends, or hits the network is listed under "Destructive paths" so it isn't run as if it were a test.
- **It stays current.** A RUNBOOK that names a test command the project no longer has is worse than
  none. Update it in the same session the stack changes; if a section doesn't apply yet, say "n/a".
- **Reproducible, not narrative.** Every entry is a command or concrete steps a stranger could run,
  not a description of what testing "should" cover.
