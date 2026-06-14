---
description: Implements a phase of a .jm/ project to the highest bar — no scope cuts, no tech debt, no "v1/v2" — one task at a time, with tests covering the acceptance criteria and a runnable deliverable. Checkpoints to PROGRESS.md at task boundaries or whenever you tell it to wrap up, carving unfinished work into a new follow-up task. Use it after the phase SPEC is approved, or to continue the next task.
model: inherit
effort: xhigh
disable-model-invocation: true
argument-hint: "[phase-id-or-slug]"
---

# /jm:build — Phase implementation

You implement a phase's SPEC **to the highest bar**. You work in the project directory (cwd); state
lives in `<cwd>/.jm/`. Protocols and format specs in `${CLAUDE_PLUGIN_ROOT}/jm-shared/`.

## 0. Precondition (don't build the wrong thing)
**Pick the phase**: the one named by the argument, else the **active phase** (the single one in a
working state), else the lowest `pending` whose every dependency is `done` (`ROADMAP-FORMAT.md`'s
selection rule). If the argument names a phase that isn't the active one, **stop** and report the
conflict — don't start parallel work. Then read its `status` in `.jm/ROADMAP.md`:
- `pending`/`discovering` → there's no approved SPEC yet. **Stop** and send the user to `/jm:discover`
  (the SPEC must exist before building). Don't write code.
- `spec-ready` → proceed; §2's start gate is the human approval.
- `implementing` → proceed; resume from `PROGRESS.md`. **If you arrived from an audit FAIL** (the
  HANDOFF's latest `Attempt` is FAIL with open `F-NN`), work **only** the `Audit N / F-NN` remediation
  tasks — nothing else — then return to audit via §6.
- `auditing`/`done` → already built. Say so and route to `/jm:audit` (or `/jm:discover` for the next
  phase).
- `blocked` → don't build. Surface `Reason` / `Unblock when` from the ROADMAP's `## Blocked phases`
  memory and stop; it is cleared (restoring `From`) only once the condition holds.

## 1. Constitution + context load
- Read `.jm/PRINCIPLES.md`. **Internalize it**: full bar inside the agreed product; **effort is never
  a reason to cut**; zero silent debt; **decompose ≠ drop**; a real out-of-scope call is a recorded
  *boundary* (taken to the user), never a quiet omission.
- Read the phase's `SPEC.md` (acceptance criteria + their evidence types), its `PROGRESS.md` (which
  task is next), `.jm/RUNBOOK.md` (how to run and test — create it per `${CLAUDE_PLUGIN_ROOT}/jm-shared/RUNBOOK-FORMAT.md`
  if it's missing), `CONTEXT.md`, and the ADRs.

## 2. Start gate (human in the loop)
Before touching code, **show the user the acceptance criteria + the deliverable + the task you're
about to do**, and ask for go/no-go. If the SPEC wasn't approved yet, this is their approval.

## 3. Durable start (persist BEFORE touching code)
After the go and **before any code change**, make the start recoverable — so an interrupted build is
never mistaken for "not started", and the user's own changes are never blamed on it:
1. **Record provenance** in `PROGRESS.md` (create it per `${CLAUDE_PLUGIN_ROOT}/jm-shared/PROGRESS-FORMAT.md`): the
   **base commit** (`git rev-parse HEAD`, or `unversioned` if not a git repo / no commits), the
   **pre-existing dirty paths** (`git status --porcelain` — the user's, off-limits), and an empty
   **owned paths** list.
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
  phase — leave existing phases' `#`/`slug` untouched (frozen phases have on-disk `phases/NN-slug/`
  dirs and history).
- **Record decisions as ADRs.** When you make an architectural or surprising implementation decision
  that meets the three criteria of `${CLAUDE_PLUGIN_ROOT}/jm-shared/ADR-FORMAT.md`, write it to `.jm/adr/` and
  reference it in the HANDOFF. The "why" must survive in the docs, not just in your head.
- **Safety and reversibility** (PRINCIPLES' "Safety and reversibility"): before any irreversible or
  outward step — a migration, dropping data, a deploy, anything you can't take back — name the rollback
  in one line and get a go/no-go first. If a change **you** made regressed behavior, restore the
  known-good state of **your own** step and re-sequence; don't patch over a broken base. Never use
  `git reset`/`clean`/`checkout -- .` to "get clean" — that destroys the user's pre-existing changes.

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
