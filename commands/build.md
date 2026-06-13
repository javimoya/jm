---
description: Implements a phase of a .jm/ project to the highest bar — no scope cuts, no tech debt, no "v1/v2" — one task at a time, with tests covering the acceptance criteria and a runnable deliverable. Checkpoints to PROGRESS.md at task boundaries or whenever you tell it to wrap up, carving unfinished work into a new follow-up task. Use it after the phase SPEC is approved, or to continue the next task.
model: opus
effort: xhigh
---

# /jm:build — Phase implementation

You implement a phase's SPEC **to the highest bar**. You work in the project directory (cwd); state
lives in `<cwd>/.jm/`. Protocols and format specs in `${CLAUDE_PLUGIN_ROOT}/jm-shared/`.

## 0. Precondition (don't build the wrong thing)
Read the target phase's `status` in `.jm/ROADMAP.md` first:
- `pending`/`discovering` → there's no approved SPEC yet. **Stop** and send the user to `/jm:discover`
  (the SPEC must exist before building). Don't write code.
- `spec-ready` → proceed; §2's start gate is the human approval.
- `implementing` → proceed; resume the next task from `PROGRESS.md`.
- `auditing`/`done` → already built. Say so and route to `/jm:audit` (or `/jm:discover` for the next
  phase). `blocked` → surface why from the ROADMAP narrative and stop.

## 1. Constitution + context load
- Read `.jm/PRINCIPLES.md`. **Internalize it**: final product complete and perfect; effort is
  not a factor; zero debt; **decompose ≠ drop**.
- Read the phase's `SPEC.md`, its `PROGRESS.md` (which task is next), `CONTEXT.md`, and the ADRs.

## 2. Start gate (human in the loop)
Before touching code, **show the user the acceptance criteria + the deliverable + the task you're
about to do**, and ask for go/no-go. If the SPEC wasn't approved yet, this is their approval.

## 3. Test baseline
Run the suite and **record the real baseline**: how many pass/fail and the names of the failing ones.
Without this you can't claim "I broke nothing".

## 4. Implement the task to the highest bar
- Build the current task (or the whole phase if small) **complete and robust**. Cover the edge cases.
  **Write tests** that map to the acceptance criteria.
- **Anti-cut reframe**: if you feel tempted to defer/simplify/leave a TODO or stub, STOP and apply the
  constitution's test. The move is never to drop it: it's to **create a later task or a new phase**
  (record it in PROGRESS/ROADMAP). Never a silent drop.
- **Record decisions as ADRs.** When you make an architectural or surprising implementation decision
  that meets the three criteria of `${CLAUDE_PLUGIN_ROOT}/jm-shared/ADR-FORMAT.md`, write it to `.jm/adr/` and
  reference it in the HANDOFF. The "why" must survive in the docs, not just in your head.

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
- Leave the tree in a clean, compiling state.
- Set `status` coherently, then stop and tell the user to `/clear` and `/jm:build` the next task.

Never push a degrading session. Cutting early and handing off cleanly always wins.

## 6. Phase close (only when it's the last task)
When the phase is complete:
- Build the **deliverable** and **run the SPEC's "How to see it" yourself**; record the real result.
- Re-run the full suite: **green**, with the delta against the baseline.
- Write the `HANDOFF.md` draft (following `${CLAUDE_PLUGIN_ROOT}/jm-shared/HANDOFF-FORMAT.md`): what was built,
  decisions, how to verify + real result, test status baseline→final, open threads. Set
  `status` → `auditing`.
- **Self-accounting gate**: before declaring it done, explicitly list everything you
  simplified/deferred/left pending and turn it into a phase/task or justify it with the test.

## Close — ritual + breadcrumb
Run the close ritual (`${CLAUDE_PLUGIN_ROOT}/jm-shared/CLOSE-FORMAT.md`): persist `PROGRESS.md`/`HANDOFF.md` and the
ROADMAP status, append a `JOURNAL.md` entry, then the breadcrumb:
- If you split for a checkpoint: *"Task {N}/{M} of phase {NN} advanced; state in PROGRESS. Next:
  `/clear` + `/jm:build` (task {N+1})."*
- If you closed the phase: *"Phase {NN} implemented and set to `auditing`. Next: `/clear` + `/jm:audit`
  to audit it with fresh eyes before closing."*
