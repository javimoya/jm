---
description: Captures a new idea, feature, or refinement that surfaced on the fly into the .jm/ system — instead of losing it to Claude's native memory or a future you'll forget to run. It orients read-only, lightly grills just enough to classify, confirms with you, then writes it where it belongs: a note on an existing pending phase (folded later by /jm:discover) or a new pending phase in the ROADMAP. Use it any time after /jm:ideate, with work in progress, when a thought comes up you don't want to drop. It does no implementation and starts no phase.
model: inherit
disable-model-invocation: true
argument-hint: "[the idea, or a target phase-id-or-slug]"
---

# /jm:capture — Grab a new idea into the system

You capture an idea that surfaced **on the fly** — between sessions, with work in progress — into
`.jm/`, so it is never lost to Claude's native memory or to a `/jm:ideate` you might forget to run.
You do **no implementation** and start no phase: you classify the idea, confirm, and record it. You
work in the project directory (cwd); state lives in `<cwd>/.jm/`.

This is the **standalone** entry point to the shared capture protocol
(`${CLAUDE_PLUGIN_ROOT}/jm-shared/CAPTURE.md`). The **inline** entry point — an idea surfacing
*during* a `/jm:build` or `/jm:discover` — applies the same protocol without leaving the session.

## When to use which command
- **`/jm:capture`** (this) — the roadmap exists and there's work in progress; you have a new idea for a
  **planned (`pending`) phase** or a **new phase**. The lightweight option.
- **`/jm:ideate`** — only at **kickoff** (no roadmap yet) or once the **current roadmap is complete**
  (every phase `done`), to plan from scratch or shape the next wave with full divergence. Not for
  grabbing a single idea mid-flight.
- **`/jm:discover`** — turn a phase's one-liner (and any `.jm/NOTES.md` seeds targeting it) into a SPEC.

## 0. Precondition
Read `.jm/ROADMAP.md`:
- **No `.jm/`, or a ROADMAP with no phase rows** → there's nothing to capture *into* yet. **Stop** and
  send the user to `/jm:ideate` to kick off the project first.
- **A ROADMAP with phases** → proceed. Capture coexists with work in progress; it does **not** require
  or change the active phase's working state.

## 1. Orient (read-only)
Read just enough to place the idea, changing nothing:
- `.jm/PRINCIPLES.md` (skim — the bar: decompose ≠ drop, never a silent cut).
- `.jm/ROADMAP.md` (the status table and the `pending` phases the idea might belong to).
- `.jm/CONTEXT.md`, `.jm/NOTES.md` (seeds already captured — don't duplicate one), and the SPECs of
  the neighbouring phases, so you don't contradict what's already planned.

## 2. Grill just enough to classify (`GRILLING.md`, lightly)
This is **not** a full ideation. Ask only what you need to triage the idea per `CAPTURE.md`, one
question at a time with your recommended answer:
- Is it a **refinement of an existing `pending` phase**, or a **distinct new capability** (its own
  vertical slice)?
- If a new phase: what's its one-line deliverable, what does it depend on, and **where in the order**
  does it go?

The **deep** shaping (acceptance criteria, task plan) is **not** done here — it's deferred to that
phase's `/jm:discover`, which reads the seed you leave. Capture the seed and the *why*; don't design
the phase.

## 3. Confirm first (human in the loop)
Before mutating the ROADMAP, **show the user the proposal and get go/no-go** (`CAPTURE.md` →
"Confirm first"): which case it is, and — for a new phase — its `#` / `slug` / one-line deliverable /
dependencies and its position in the order. A note onto an existing phase is a low-friction confirm;
adding or reordering a phase always carries the user's explicit go.

## 4. Write it into `.jm/` (never Claude memory)
Per `CAPTURE.md`'s triage:
- **Refinement of one or more `pending` phases** → append a **seed** to `.jm/NOTES.md` (create it if
  missing) targeting each phase by its `slug`, following `${CLAUDE_PLUGIN_ROOT}/jm-shared/NOTES-FORMAT.md`.
  A seed touching several phases carries one checkbox per phase.
- **Distinct new capability** → add a new `pending` phase to the ROADMAP (number, slug, one-line
  deliverable, dependencies, `status` `pending`) per `${CLAUDE_PLUGIN_ROOT}/jm-shared/ROADMAP-FORMAT.md`'s
  **Phase mutability** rule, **and** add a seed in `.jm/NOTES.md` targeting it, with the detail and the
  *why* for its future discovery.
- Either way: a dated line in the ROADMAP `## Structural changelog`. **Never** write to `MEMORY.md` or
  any `~/.claude/**/memory/` path.

## Close — ritual + breadcrumb
Run the close ritual (`${CLAUDE_PLUGIN_ROOT}/jm-shared/CLOSE-FORMAT.md`): persist the ROADMAP/NOTES,
append a `JOURNAL.md` entry, then the breadcrumb naming where the idea landed and what happens to it:
- Note on a phase: *"Noted on phase {NN} (`{slug}`); it'll be folded into the SPEC when you
  `/clear` + `/jm:discover` that phase."*
- New phase: *"Added phase {NN} `{slug}` (`pending`); discover it when its turn comes — `/jm:orient`
  will route you there. Carry on with what you were doing."*
