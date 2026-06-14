# Capturing new scope mid-work (shared)

This is how a new idea, feature, refinement, or scope gets recorded **the moment it surfaces** —
whether you thought of it or **the user raised it**, and whether you're mid-`/jm:build`,
mid-`/jm:discover`, or running `/jm:capture` standalone. The thread never lives only in your head,
only in HANDOFF prose, or in Claude's native memory. It is the operational form of the constitution's
**"decompose, don't drop"** (`CONSTITUTION.md`).

Two entry points share this one protocol:
- **Inline** — an idea surfaces *while a working command is running* (`/jm:build`, `/jm:discover`).
  You apply this protocol **without leaving the session**, then return to the task/SPEC you were on.
- **Standalone** — `/jm:capture`, for an idea that surfaces *between* sessions, with work in progress.

## The iron rule
- **Never Claude native memory.** No `MEMORY.md`, no `~/.claude/**/memory/`. The `.jm/` folder is the
  only memory (`CONSTITUTION.md` → "Safety and reversibility").
- **Never a silent drop**, and never *"I'll remember to `/jm:ideate` it later"* as the **only** record.
  A thread parked outside `.jm/` is, to this system, a cut.

## Triage — one decision, then capture
Classify the thread, then write it into `.jm/`:

1. **Continuation of the phase you're building right now** → a later **TASK** of this phase, in
   `PROGRESS.md` and the SPEC's task plan (`build.md` §5). Not a NOTES seed — it's in-flight work.
2. **A refinement that belongs to one or more *already-planned* `pending` phases** → a **seed** in
   `.jm/NOTES.md` (create it if missing) targeting each phase by its stable **`slug`**, per
   `NOTES-FORMAT.md`. `/jm:discover` folds it into each phase's SPEC when that phase's turn comes — a
   seed touching several phases carries one checkbox per phase and is fully consumed only when all are
   folded.
3. **A distinct new capability** → a **new `pending` phase** in the ROADMAP (`ROADMAP-FORMAT.md` →
   "Phase mutability": number, slug, one-line deliverable, dependencies, `status` `pending`; one dated
   line in `## Structural changelog`) **plus** a seed in `.jm/NOTES.md` targeting that new phase's
   `slug`, capturing the detail and the *why* so its later `/jm:discover` starts with full context.
4. **Big or ambiguous — needs real divergence or a VISION change** → still capture the seed now
   (case 2 or 3) so it's concrete in `.jm/`. Its deep shaping happens at the phase's `/jm:discover`
   (which grills and may split into sibling phases). Re-architecting the **whole** roadmap is reserved
   for `/jm:ideate`, and `/jm:ideate` only runs at kickoff or once the current roadmap is complete — so
   note in the breadcrumb that ideate should revisit it then. Never run a heavy mid-flight ideate.

If it isn't new at all — it's a cut of the current task you were tempted to make — that's the
`build.md` §4 anti-cut reframe, not this protocol.

## Confirm first (human in the loop)
Before you **mutate the ROADMAP or reorder phases**, show the user the proposal and get go/no-go:
- *what* it is and *which case* (a note on phase NN, vs a new phase);
- for a **new phase**, its `#` / `slug` / one-line deliverable / dependencies and **where in the order
  it goes** (the sequencing the user cares about).

A note onto an existing `pending` phase is a low-friction confirm. A new phase, a reorder, or any
change to the canonical state always carries the user's explicit go — it is a state mutation.

## Then
- **Leave a trace**: a dated line in the ROADMAP `## Structural changelog`; and, if you're inside
  `/jm:build`, an entry in the HANDOFF's **"Open threads / impact on other phases"** pointing at the
  new phase / note.
- **Don't derail.** Capturing is a quick interjection. Inline, you **return to the task/SPEC you were
  on** — you are not switching context to build the new thing now.
