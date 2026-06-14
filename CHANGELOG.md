# Changelog

All notable changes to `jm` are recorded here. Versions follow the `version` field in
`.claude-plugin/plugin.json`.

## 0.5.0

### Added
- **Capture ideas on the fly — into `.jm/`, never Claude's native memory.** A new shared protocol
  `jm-shared/CAPTURE.md` defines how a new idea, feature, or refinement that surfaces mid-work gets
  recorded the moment it appears: triage it (a later **task**, a **note** on a planned `pending` phase,
  or a brand-new `pending` **phase**), **confirm before mutating the ROADMAP**, then write it to
  `.jm/`. Two entry points share it — inline (during `/jm:build` or `/jm:discover`) and the new
  standalone command below.
- **`/jm:capture` command.** A lightweight, invoke-anytime-after-ideate command that orients
  read-only, lightly grills just enough to classify, confirms, and files the idea where it belongs.
  For grabbing a stray idea with work in progress — without the heavyweight `/jm:ideate`.
- **A single `.jm/NOTES.md` backlog.** A new artifact (`jm-shared/NOTES-FORMAT.md`) — one
  project-level file, next to `ROADMAP.md` — holds **seeds**: ideas captured before a phase has a SPEC.
  Seeds reference phases by their stable **`slug`** (so renumbering never moves or breaks them), and a
  single seed can **target several phases**, each with its own checkbox. `/jm:discover` folds the seeds
  targeting the phase it's discovering and checks their boxes; a seed is fully consumed (moved to
  `## Consumed`, not deleted) only once every target is folded.

### Changed
- **The `.jm/` folder is now explicitly the only memory.** `PRINCIPLES.md` (the constitution) bans
  Claude Code's native memory system outright (no `MEMORY.md`, no `~/.claude/**/memory/`): a thread
  parked outside `.jm/` is, to this system, a silent drop. "Decompose, don't drop" gains a third case
  (a refinement of one or more `pending` phases → a seed in the `NOTES.md` backlog).
- **`/jm:build` starts coding by default.** The pre-code step now always shows the intro (acceptance
  criteria + deliverable + task) but **no longer asks for a go/no-go** unless you pass the new
  **`--gate`** flag — launching build after reviewing the SPEC is the approval. `/jm:build` also reads
  `.jm/NOTES.md`, captures new scope inline per `CAPTURE.md`, and carries a one-line "inside an approved
  SPEC, decide and advance" reinforcement.
- **`/jm:ideate` no longer re-plans mid-flight.** It runs only at kickoff or once the **current roadmap
  is complete** (every phase `done`); with work in progress it stops and routes a fresh idea to
  `/jm:capture`. `/jm:discover` and `/jm:wrap` route new scope through `CAPTURE.md`; `/jm:orient`
  surfaces phases that carry unconsumed `NOTES.md` seeds.
- **A short "Working style" note in the constitution** (act, don't narrate; outcome over visible
  process) keeps the signal high in tool-driven sessions.

## 0.4.3

### Changed
- **README highlights documented decisions as a strength.** The "Why" section gains a fifth
  failure-mode/method pair: "nobody remembers why" → every decision goes on the record (ADRs for the
  *why*, a glossary for the terms), so a fresh agent acts on past reasoning instead of guessing and can
  flag when a new ask contradicts an earlier call.

## 0.4.2

### Changed
- **Reframed the README "Why" around underspecified asks.** The lead failure mode is now "you didn't
  fully say what you wanted" — the most common reason agent work disappoints — and the grilling bullet
  sells the fix directly: a supercharged `grill-me` that pins down exactly what you want *and* helps
  you discover the things you hadn't thought of.

## 0.4.1

### Changed
- **README headlines the grilling capability.** The "Why" section now opens its method list with
  adversarial grilling as a first-class strength — diverge-then-converge interrogation across
  `/jm:ideate` and `/jm:discover`, including the new "confirm before you stop questioning" checkpoint —
  framed as a supercharged take on the well-known [`grill-me`](https://github.com/mattpocock/skills/blob/main/skills/productivity/grill-me/SKILL.md)
  skill, and paired with a new "the idea was never sharpened" failure mode.

## 0.4.0

### Added
- **A confirmation checkpoint before questioning ends.** `/jm:ideate` and `/jm:discover` no longer
  fall silent and move on the moment their planned questions run out: a new shared rule in
  `GRILLING.md` ("Confirm before you stop questioning") makes them turn back to the user, **propose the
  areas still worth exploring** (unexplored features/scenarios, edge cases, integrations, failure
  modes), and let the user — not the running-out of the list — decide whether to keep going or wrap up.
  Referenced from `ideate.md` §2 and `discover.md` §2.

### Changed
- **`/jm:ideate` diverges harder.** The divergence step now explicitly calls for lateral thinking —
  proposing possible features, capabilities, and out-of-the-box ideas from adjacent products and other
  domains — to open areas the user hasn't contemplated, fitting the vague-idea stage. Reinforced in
  both `ideate.md` §2 and `GRILLING.md`.

## 0.3.1

Follow-up hardening on 0.3.0: a real lifecycle for `blocked`, a graceful audit boundary for non-git
projects, a shared-rule cleanup pass, and a batch of contract/bug fixes surfaced by review.

### Added
- **`blocked` is now a first-class, writable lifecycle.** Previously the state was only ever *read* —
  nothing set or cleared it. A single "Blocking & unblocking" rule in `ROADMAP-FORMAT.md` now defines
  it end to end: it's only for an external wall the session can't clear (a missing credential, a third
  party, a product decision only the user can make) — never a way to defer buildable work; a working
  command (or `/jm:wrap`) **proposes** the block and the user confirms; the command that owns `From`
  later restores it on confirmation; `/jm:orient` is the read-only radar. `build`/`discover`/`audit`/
  `wrap` reference the rule.

### Changed
- **Audit boundary degrades gracefully without git.** `owned paths` is the authoritative review scope;
  with git the audit diffs them against the base commit in the working tree (and flags changes outside
  scope), and with no VCS it reviews the current state of the owned paths. It fails closed only when no
  boundary can be formed at all.
- **Never commit to establish a baseline or boundary** — pinned in `/jm:build` and `/jm:audit`, so the
  user's pre-existing changes are never entangled by a commit jm made.
- **Shared rules consolidated** (cleanup pass): the phase-selection rule and the "phase mutability"
  rule now live once in `ROADMAP-FORMAT.md` and are referenced by the commands; leftover "perfect
  product" wording was aligned with the "agreed bar" constitution; the commit policy and grilling
  protocol no longer derive from a parent `CLAUDE.md`.

### Fixed
- `/jm:orient` read phase files from `phases/NN/` instead of the real `phases/NN-slug/` directory.
- `/jm:wrap` now delegates the mid-audit checkpoint to a real section in `/jm:audit` and handles the
  `blocked` case instead of falling through to a no-op.
- `/jm:discover`'s no-argument phase selection now resumes the active phase before scanning pending.
- `RUNBOOK-FORMAT.md` claimed the RUNBOOK was scaffolded by `/jm:ideate`; it's created lazily in
  `/jm:discover` or `/jm:build` (matching `ideate`).
- `install.sh` backups no longer collide when the script runs twice in the same second.
- `tests/check_commands.py` parses each command's frontmatter once instead of twice.

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
