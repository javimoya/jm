---
description: Low-level discovery of ONE phase of a .jm/ project. Grills to produce the phase's SPEC (goal, vertical slice, testable acceptance criteria, deliverable and "How to see it", and a task plan sized so each task fits one fresh build session). Sharpens CONTEXT/ADRs inline and, if it discovers new things, mutates the ROADMAP. Use it at the start of a phase, before /jm:build.
model: inherit
disable-model-invocation: true
argument-hint: "[phase-id-or-slug]"
---

# /jm:discover — Phase discovery

You turn a ROADMAP phase (today one line) into a **SPEC: a testable contract** that `/jm:build` can
implement with no further questions. You work in the project directory (cwd); state lives in
`<cwd>/.jm/`.

Shared protocols in `${CLAUDE_PLUGIN_ROOT}/jm-shared/` (`GRILLING.md`, `CONTEXT-FORMAT.md`, `ADR-FORMAT.md`,
`SPEC-FORMAT.md`).

## 1. Light orientation + constitution
- Read `.jm/PRINCIPLES.md` (the bar: full-bar product, decompose ≠ drop, out-of-scope only as a
  recorded *boundary*).
- Read `.jm/ROADMAP.md`, `.jm/CONTEXT.md`, `.jm/adr/`, `.jm/RUNBOOK.md` (if present), and the
  SPEC/HANDOFF of neighbouring phases (so you don't contradict what's already decided).
- **Pick the phase** per `${CLAUDE_PLUGIN_ROOT}/jm-shared/ROADMAP-FORMAT.md`'s **Active phase & selection** rule
  (the named argument, else the active phase, else the lowest ready `pending`; an explicit phase that
  isn't the active one → **stop** and report the conflict). Set its `status` → `discovering` (it becomes the single active phase).
- **Guard**: if the chosen phase is already `spec-ready`/`implementing`/`done`, it already has a SPEC
  (and maybe code). Don't silently re-discover and clobber it: say so and confirm with the user first,
  or route (`spec-ready` → `/jm:build`; `done` → the next phase). If it's `blocked`, surface the block
  and unblock per `ROADMAP-FORMAT.md`'s "Blocking & unblocking" (confirm `Unblock when`, restore
  `From`) only with the user's ok, else stop. If discovery itself hits an external wall, propose a
  block the same way rather than guessing.

## 2. Grill the phase (the `GRILLING.md` protocol)
One question at a time, with your recommended answer, exploring the code when the answer is there.
Nail down:
- **The vertical slice**: this phase's end-to-end capability (not a horizontal layer).
- **The testable acceptance criteria** — each an `AC-N` with an **evidence type** (`automated`
  preferred; `manual`/`visual`/`performance`/`security` only when truly not automatable) and the exact
  **Verify** check that closes it.
- **The concrete deliverable + "How to see it"** (the real command/steps the user will run).
- **Pin the run/verify commands in `.jm/RUNBOOK.md`** as they firm up — the single full-suite command,
  the deliverable run, focused tests, and any destructive paths (`${CLAUDE_PLUGIN_ROOT}/jm-shared/RUNBOOK-FORMAT.md`).
  Env var **names** only, never secret values.
- Sharpen terms in `CONTEXT.md` **inline**; offer ADRs only on the three criteria.

As you grill, **write each answer straight into the SPEC** and keep the still-unresolved ones in the
SPEC's **"Open questions (working)"** list (most important first) — that list is your resumable queue.
The phase stays `discovering` while it's non-empty, so a long discovery can be cut and continued in a
fresh session.

## 3. Size into tasks
Estimate whether the implementation **comfortably** fits one `/jm:build` session. If it doesn't,
**split it into N small, ordered tasks**. Remember: tasks split *only* the implementation; they have
no deliverable and no tests of their own. The user can also checkpoint mid-build at any time, so size
generously rather than optimistically.

## 4. Re-planning (if you discover new things)
If discovery reveals work that doesn't belong in this phase: **don't cut it**. Create it as a **new
phase** (or reorder/split phases) in the ROADMAP and note it in the changelog. If it's an
architectural pivot, add an ADR as well.
- **Only `pending` phases are mutable** — follow `${CLAUDE_PLUGIN_ROOT}/jm-shared/ROADMAP-FORMAT.md`'s **Phase
  mutability** rule: never change a frozen phase's `#`/`slug`, renumber/reorder within `pending`,
  append if no clean renumber, never delete a phase.

## 5. Write the SPEC
Write `.jm/phases/NN-slug/SPEC.md` following `${CLAUDE_PLUGIN_ROOT}/jm-shared/SPEC-FORMAT.md`. Only when the
"Open questions" list is **empty** and the contract is complete: empty (or drop) that section and set
the phase `status` → `spec-ready` in the ROADMAP. If questions remain, leave it `discovering`.

## Close — ritual + breadcrumb + GATE
Run the close ritual (`${CLAUDE_PLUGIN_ROOT}/jm-shared/CLOSE-FORMAT.md`): persist the SPEC (partial or complete),
update the ROADMAP status, append a `JOURNAL.md` entry, then the breadcrumb.
- **SPEC complete** (sign-off GATE — it needs your approval before implementing):
  *"Phase {NN}'s SPEC is ready at `.jm/phases/NN-slug/SPEC.md` ({M} tasks). Review and approve
  it; when you're happy: `/clear` then `/jm:build` to implement task 1."*
- **Discovery cut mid-way** (status stays `discovering`): *"Phase {NN} discovery checkpointed; {K}
  open questions left, next is '{the next question}'. Continue with `/clear` + `/jm:discover`."*
