# ROADMAP.md format

`.jm/ROADMAP.md` is the **canonical, on-disk state** for the project — there is no separate state
file. `/jm:orient` and the working commands parse its status table to know what's next, so its
structure is strict: keep it exact.

## Structure

```md
# Roadmap — {Project name}

## State (machine-readable)

| # | slug | title | status | depends on | deliverable (1 line) |
|---|------|-------|--------|------------|----------------------|
| 01 | walking-skeleton | {title} | pending | — | {what you'll be able to see/run} |
| 02 | {slug} | {title} | pending | 01 | {what you'll be able to see/run} |

## Narrative
{Why this order of phases. What story they tell together. What each one unblocks.}

## Blocked phases
{Present only while a phase's status is `blocked`. One block per blocked phase; delete the block the
moment it is unblocked. This is the memory a flat `blocked` status would otherwise destroy.}

### Phase NN — {slug}
- **From**: {the status it held before blocking — restored verbatim on unblock}
- **Reason**: {the concrete thing blocking it}
- **Unblock when**: {an observable condition that, once true, clears the block}

## Structural changelog
- {YYYY-MM-DD} — initial ROADMAP created by /jm:ideate.
```

## Rules

- **The status table is the single source of truth for dispatch.** Update it the moment anything
  changes; a stale table mis-routes the next clean session.
- **Status vocabulary (a state machine).** Exactly: `pending` → `discovering` → `spec-ready` →
  `implementing` → `auditing` → `done`. The only backward edge is `auditing` → `implementing` (an
  audit FAIL). Don't skip `discovering`/`spec-ready`. `done` is terminal — never re-open it silently.
- **Active phase & selection (deterministic).** At most **one** phase may be in a working state
  (`discovering` / `spec-ready` / `implementing` / `auditing`) at a time — that is *the active phase*,
  and a command with no argument operates on it. If none is active, the next phase to work is the
  **lowest-numbered `pending` whose every `depends on` phase is `done`**; a `pending` phase with an
  unfinished dependency is not yet selectable. A command given an explicit phase id/slug that is not
  the active phase must **not** start parallel work — it reports the conflict and stops.
- **`blocked` carries memory.** `blocked` may be entered from any state, but never as a flat label:
  record `From` / `Reason` / `Unblock when` in the `## Blocked phases` section. Unblocking restores
  the `From` status **exactly** and deletes the block. A reason with no observable unblock condition
  is malformed (it creates a permanent, ambiguous block).
- **Column contract.** Exactly these columns, in order: `#`, `slug`, `title`, `status`,
  `depends on`, `deliverable`. `#` is zero-padded and monotonic. `slug` is kebab-case, stable, and
  matches the `phases/NN-slug/` directory.
- **Every phase is a vertical slice with a one-line, user-visible deliverable.** A phase whose
  deliverable column is empty or internal-only is malformed (phase 01 may be a runnable walking
  skeleton).
- **Decompose, don't drop.** Deferred work appears here as a new phase — it never vanishes. Inserting
  or splitting phases is allowed; explain it in the changelog.
- **Phase mutability (only `pending` is malleable).** A `pending` phase has no on-disk
  `phases/NN-slug/` directory yet, so it may be renumbered, reordered, split, or folded into. Any phase
  in a working / `done` / `blocked` state is **frozen** — it has a `phases/NN-slug/` directory and
  history; never change its `#` or `slug`. Renumber/reorder within the `pending` set only (keep `#`
  zero-padded and monotonic, never colliding with a frozen `#`); if a clean renumber isn't possible,
  **append** instead. Never delete a phase (that's a cut).
- **Changelog discipline.** Every structural change (add / split / reorder / block) gets one dated
  line. The changelog is how a future session reconstructs how the plan evolved.
