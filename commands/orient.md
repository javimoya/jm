---
description: Reconstructs "where you are" in a project orchestrated with this framework by reading .jm/ (ROADMAP, latest HANDOFF/PROGRESS, active SPEC). Use it in a clean session when you don't remember where you left off. It does no work: it only orients you and tells you exactly which skill to launch next (/jm:ideate, /jm:discover, /jm:build, or /jm:audit).
model: sonnet
effort: medium
---

# /jm:orient — Where am I?

You are the project's GPS. **You do no work**: you reconstruct state from disk and say what's next.
You work in the project directory (cwd); state lives in `<cwd>/.jm/`.

## 1. Is there a project?
- If **`.jm/` doesn't exist**: say so and send the user to `/jm:ideate` to start. Done.
- If it exists, continue.

## 2. Read the state (read-only)
- `.jm/PRINCIPLES.md` (skim, to recall the bar).
- `.jm/JOURNAL.md` (if it exists) → the **last entry**, to recall what the previous session did
  and what it said comes next.
- `.jm/ROADMAP.md` → the status table. Identify the **active phase**: the lowest-numbered one
  whose `status` is not `done`.
- Based on the active phase's `status`, read just enough:
  - `pending`/`discovering` → its SPEC if it exists, including the SPEC's "Open questions (working)"
    list (the next unresolved discovery question); otherwise nothing more.
  - `spec-ready`/`implementing` → `phases/NN/SPEC.md` and `phases/NN/PROGRESS.md` (which task is next).
  - `auditing` → `phases/NN/SPEC.md` and `phases/NN/HANDOFF.md` (the draft to audit).
  - `blocked` → the ROADMAP narrative (why).

## 3. Give the report (concise)
In a few lines:
- **Project**: {name, one sentence of the vision}.
- **Big picture**: {phases done / total; what's already been delivered}.
- **You are here**: phase {NN} `{slug}`, stage = {discovery | awaiting SPEC approval |
  implementation task {N}/{M} | audit}.
- **What's next**: the concrete step — in discovery, name the next open question if the SPEC has one.

## Close — breadcrumb
End with the exact action line, e.g.:
- *"Next: `/clear` then `/jm:discover` (phase 02 pending)."*
- *"Phase 01's SPEC is ready for your approval; review it, then `/clear` + `/jm:build`."*
- *"You're on task 2/3 of phase 01; `/clear` + `/jm:build` to continue."*
- *"Phase 01 is implemented; `/clear` + `/jm:audit` to close it."*

**Do not** modify any file.
