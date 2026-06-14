# Changelog

All notable changes to `jm` are recorded here. Versions follow the `version` field in
`.claude-plugin/plugin.json`.

## 0.3.0

Robustness and safety pass. The workflow stays a pure-Markdown set of prompts — `ROADMAP.md` remains
the canonical, on-disk state — but the contracts between the commands are tightened so a fresh session
can never lose work, mistake another change for its own, or close a phase on unverified claims.

### Fixed
- **`orient.md` frontmatter was invalid YAML** (an unquoted `:` in the `description`), so Claude Code
  silently dropped its `model`/`effort` fields. Reworded so the frontmatter parses.

### Changed
- **All commands now use `model: inherit`** instead of pinning Opus/Sonnet, so they respect the
  session's configured model rather than forcing one a user may not have access to.
- **Constitution (`CONSTITUTION.md`) and `VISION-FORMAT.md`** now allow *explicit, approved* product
  boundaries and accepted tradeoffs — without weakening the rule that nothing is ever cut silently.
  A boundary is a recorded product decision; deferred-but-in-scope work is still sequenced and built.
- **`install.sh`** no longer uses the macOS-only `sed -i ''`; the path rewrite is portable to Linux.

### Added
- **`disable-model-invocation: true` on every command** — the mutating workflows only run when you
  type `/jm:…`, never because the model decided a request "looked like" one of them.
- **`context: fork` on `/jm:audit`** — the audit starts from a clean context instead of inheriting
  the implementer's conversation, so "fresh eyes" is real.
- **`argument-hint` on `/jm:discover`, `/jm:build`, `/jm:audit`** (`[phase-id-or-slug]`).
- **Durable build start** — `/jm:build` records its base commit, the pre-existing dirty paths, and
  flips the phase to `implementing` *before* it touches code, so an interrupted build is always
  recoverable and never blamed on the user's own uncommitted changes.
- **`RUNBOOK-FORMAT.md`** — a per-project `.jm/RUNBOOK.md` that pins the exact full-suite command,
  focused tests, build, deliverable steps, and destructive paths, so `/jm:build` and `/jm:audit`
  measure the same thing instead of re-guessing it each session.
- **Typed acceptance evidence** — SPEC criteria carry stable IDs and an evidence type
  (`automated` / `manual` / `visual` / `performance` / `security`); anything only *inferred* counts as
  not met and cannot close a phase.
- **Append-only audit history** — `/jm:audit` appends each attempt's verdict and findings to the
  HANDOFF; a later PASS never erases an earlier FAIL.
- **FAIL → resumable tasks** — an audit FAIL turns each finding into a stable `F-NN` remediation task
  in `PROGRESS.md` and the SPEC task plan, so the next `/jm:build` knows exactly what to fix.
- **`blocked` with memory** — a blocked phase records the state it came from, the reason, and a
  concrete unblock condition; unblocking restores the prior state exactly.
- **Change-ownership safety rules** — record dirty paths before working; never `reset`/`clean`/
  `checkout`/revert broadly; only undo changes this session provably created; keep secrets/PII out of
  `.jm/`.
- **Light CI** (`.github/workflows/ci.yml`) that validates command frontmatter and `bash -n`-checks
  the install scripts.

## 0.2.0

- Converted the workflow from skills to namespaced commands (`/jm:ideate`, `/jm:discover`,
  `/jm:build`, `/jm:audit`, `/jm:orient`).
- Added `/jm:wrap` — an on-demand checkpoint for the session in progress.

## 0.1.0

- Initial release: the ideate → discover → build → audit phased workflow with all project state kept
  on disk under `.jm/`.
