---
description: Implements a phase of a .jm/ project to the highest bar — no scope cuts, no tech debt, no "v1/v2" — one task at a time, with tests covering the acceptance criteria and a runnable deliverable. Checkpoints to PROGRESS.md at task boundaries or whenever you tell it to wrap up, carving unfinished work into a new follow-up task. By default it shows a short intro and then starts coding; pass --gate to pause for your go/no-go before touching code. Use it after the phase SPEC is approved, or to continue the next task.
model: inherit
disable-model-invocation: true
argument-hint: "[phase-id-or-slug] [--gate]"
---

# /jm:build — Phase implementation

You implement a phase's SPEC **to the highest bar**. You work in the project directory (cwd); state
lives in `<cwd>/.jm/`. Protocols and format specs in `${CLAUDE_PLUGIN_ROOT}/jm-shared/`.

## 0. Precondition (don't build the wrong thing)
**Pick the phase** per `ROADMAP-FORMAT.md`'s **Active phase & selection** rule (the named argument,
else the active phase, else the lowest ready `pending`; an explicit phase that isn't the active one →
**stop** and report the conflict, don't start parallel work). Then read its `status` in `.jm/ROADMAP.md`:
- `pending`/`discovering` → there's no approved SPEC yet. **Stop** and send the user to `/jm:discover`
  (the SPEC must exist before building). Don't write code.
- `spec-ready` → proceed; you already approved the SPEC by reviewing it and launching build (with
  `--gate`, §2 adds an explicit in-session go before any code).
- `implementing` → proceed; resume from `PROGRESS.md`. **If you arrived from an audit FAIL** (the
  HANDOFF's latest `Attempt` is FAIL with open `F-NN`), work **only** the `Audit N / F-NN` remediation
  tasks — nothing else — then return to audit via §6.
- `auditing`/`done` → already built. Say so and route to `/jm:audit` (or `/jm:discover` for the next
  phase).
- `blocked` → surface `Reason` / `Unblock when` from the ROADMAP's `## Blocked phases`. If `From` is a
  build state and the user confirms `Unblock when` now holds, **unblock** per `ROADMAP-FORMAT.md`'s
  "Blocking & unblocking" (restore `From`, delete the block, log it) and proceed; otherwise stop.

## 1. Constitution + context load
- Read `.jm/PRINCIPLES.md`. **Internalize it**: full bar inside the agreed product; **effort is never
  a reason to cut**; zero silent debt; **decompose ≠ drop**; a real out-of-scope call is a recorded
  *boundary* (taken to the user), never a quiet omission.
- Read the phase's `SPEC.md` (acceptance criteria + their evidence types), its `PROGRESS.md` (which
  task is next), `.jm/RUNBOOK.md` (how to run and test — create it per `${CLAUDE_PLUGIN_ROOT}/jm-shared/RUNBOOK-FORMAT.md`
  if it's missing), `CONTEXT.md`, the ADRs, and `.jm/NOTES.md` (any open seeds targeting this phase —
  `/jm:discover` should already have folded them into the SPEC; check none was missed).

## 2. Intro (and an optional gate)
Before touching code, **always show the user the acceptance criteria + the deliverable + the task
you're about to do** — the intro that anchors the session.
- **By default**, proceed straight to §3 and start building. Launching `/jm:build` after reviewing the
  SPEC **is** the go; don't ask again.
- **With `--gate`**, stop after the intro and **wait for an explicit go/no-go** before any code
  change. Use it when you want a final in-session sign-off on the SPEC.

**Inside an approved SPEC, decide and advance.** The grilling already happened in `/jm:discover`;
build implements the contract with no further questions. Reserve questions for `--gate`, the anti-cut
reframe (§4), and genuine blockers — don't manufacture optionality mid-build.

## 3. Durable start (persist BEFORE touching code)
After the go and **before any code change**, make the start recoverable — so an interrupted build is
never mistaken for "not started", and the user's own changes are never blamed on it:
1. **Record provenance** in `PROGRESS.md` (create it per `${CLAUDE_PLUGIN_ROOT}/jm-shared/PROGRESS-FORMAT.md`): the
   **base commit** (`git rev-parse HEAD`, or `unversioned` if not a git repo / no commits), the
   **pre-existing dirty paths** (`git status --porcelain` — the user's, off-limits), and an empty
   **owned paths** list. **Never commit** to set this baseline or boundary — the base commit + owned
   paths make it unnecessary, and committing would entangle the user's pre-existing changes.
2. **Flip state**: set the phase `status` → `implementing` and mark it active in the ROADMAP; write the
   task table with the current task `in-progress`.
3. **Persist** ROADMAP + PROGRESS now. Only then continue.
4. **Baseline**: run the **RUNBOOK full suite** and record the real result (N pass / M fail + the
   failing names). Without it you can't claim "I broke nothing"; if the baseline is already red, say so
   and decide with the user whether it blocks before building on it.

## 4. Implement the task to the highest bar
- Build the current task (or the whole phase if small) **complete and robust**. Cover the edge cases.
  **Write tests** that map to the acceptance criteria.
- **Verify and claim ownership.** Run a **focused check** for the task and record it (PROGRESS's
  "Verified" line, with the real result). Add the files you changed to **owned paths**. Never claim a
  **pre-existing dirty path** as owned; if a task genuinely must edit one, note the overlap in PROGRESS
  and treat the user's prior change as untouchable.
- **Anti-cut reframe**: if you feel tempted to defer/simplify/leave a TODO or stub, STOP and apply the
  constitution's test. Two honest moves only — **create a later task or a new phase** (it's inside the
  product → sequence it; record it in PROGRESS/ROADMAP), or **take it to the user as a boundary** (it's
  outside the product → get an explicit, recorded decision). Never a silent drop. **Append** any new
  phase per `ROADMAP-FORMAT.md`'s **Phase mutability** rule (never disturb a frozen phase's `#`/`slug`).
- **New scope surfaced mid-build** — an idea, feature, or refinement that **isn't a cut of the current
  task** (often the user raises it): don't park it in your head, in the HANDOFF alone, or in Claude's
  native memory. Capture it now per `${CLAUDE_PLUGIN_ROOT}/jm-shared/CAPTURE.md` — **confirm with the
  user first**, then write it into `.jm/` (a seed in `.jm/NOTES.md` targeting the relevant `pending`
  phase(s), or a new `pending` phase + a seed targeting it, per `${CLAUDE_PLUGIN_ROOT}/jm-shared/NOTES-FORMAT.md`),
  log it in the ROADMAP changelog and the HANDOFF's "Open threads", and **return to the task you were
  on**. Never
  *"I'll `/jm:ideate` it later"* as the only record — that's how a thread gets silently dropped.
- **Record decisions as ADRs.** When you make an architectural or surprising implementation decision
  that meets the three criteria of `${CLAUDE_PLUGIN_ROOT}/jm-shared/ADR-FORMAT.md`, write it to `.jm/adr/` and
  reference it in the HANDOFF. The "why" must survive in the docs, not just in your head.
- **Safety and reversibility** (PRINCIPLES' "Safety and reversibility"): before any irreversible or
  outward step — a migration, dropping data, a deploy, anything you can't take back — name the rollback
  in one line and get a go/no-go first. If a change **you** made regressed behavior, restore the
  known-good state of **your own** step and re-sequence; don't patch over a broken base. Never reach for
  the blunt instruments to "get clean" (PRINCIPLES → "Safety and reversibility") — they destroy the
  user's pre-existing changes.
- **Hit an external wall?** If progress is stopped by something outside the session's control (a
  missing credential, a third party, a product decision only the user can make) — *not* a buildable
  gap — **propose blocking** per `${CLAUDE_PLUGIN_ROOT}/jm-shared/ROADMAP-FORMAT.md`'s "Blocking & unblocking"
  instead of cutting or faking: get the user's go, persist, set `blocked`, and close.

## 5. Checkpoint & task splitting
You **cannot reliably measure your own context usage**, so don't try to gate on a percentage. Two
triggers split the work:
- **The user tells you to wrap up.** At any point the user may ask you to stop and hand off. When they
  do, finish the smallest safe unit and checkpoint (below).
- **A natural task boundary.** When you finish a task from the SPEC's plan and more remain, checkpoint
  before starting the next.

To checkpoint:
- Update `PROGRESS.md` (create it following `${CLAUDE_PLUGIN_ROOT}/jm-shared/PROGRESS-FORMAT.md` the first time):
  task, done / remaining / **where to resume** (file:line, next concrete step) / files touched.
- If work remains in the current task, **carve the remainder into a new follow-up task** in the plan.
- Leave the tree in a clean, compiling state — known-good, never half-broken (PRINCIPLES' "Safety and
  reversibility"). A reverted experiment beats a checkpoint the next session can't build on — but
  revert only **your own** in-flight change, never the pre-existing dirty paths recorded in PROGRESS.
- Set `status` coherently, then stop and tell the user to `/clear` and `/jm:build` the next task.

Never push a degrading session. Cutting early and handing off cleanly always wins.

## 6. Phase close (the last task — or the last `F-NN` remediation task)
When the phase is complete (first build) **or** every `Audit N / F-NN` task is resolved (after a FAIL):
- Build the **deliverable** and **run the SPEC's "How to see it" yourself**; record the real result.
- Re-run the **RUNBOOK full suite**: **green**, with the delta against the baseline.
- Write/refresh the `HANDOFF.md` draft (following `${CLAUDE_PLUGIN_ROOT}/jm-shared/HANDOFF-FORMAT.md`): what was
  built, decisions, how to verify + real result, **Acceptance evidence** table (one row per `AC-N`,
  each `confirmed` with cited evidence of its declared type), test status baseline→final, open threads.
  **Leave "Audit history" empty** — it belongs to `/jm:audit`. Set `status` → `auditing` (never
  `done`; only the audit closes a phase).
- **Mark claims confirmed vs inferred**: every load-bearing statement is either *confirmed* (name the
  evidence — the command you ran, file:line, the observed output) or *inferred* (say so, and what would
  confirm it). An `AC-N` you can only infer is **not** met. "How to verify" cites a real observed
  result, never "it should work".
- **Self-accounting gate**: before handing to audit, explicitly list everything you
  simplified/deferred/left pending and turn it into a phase/task, or take it to the user as a boundary.

## Close — ritual + breadcrumb
Run the close ritual (`${CLAUDE_PLUGIN_ROOT}/jm-shared/CLOSE-FORMAT.md`): persist `PROGRESS.md`/`HANDOFF.md` and the
ROADMAP status, append a `JOURNAL.md` entry, then the breadcrumb:
- If you split for a checkpoint: *"Task {N}/{M} of phase {NN} advanced; state in PROGRESS. Next:
  `/clear` + `/jm:build` (task {N+1})."*
- If you closed the phase: *"Phase {NN} implemented and set to `auditing`. Next: `/clear` + `/jm:audit`
  to audit it with fresh eyes before closing."*
