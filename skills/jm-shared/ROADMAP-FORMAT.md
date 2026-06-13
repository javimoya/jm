# ROADMAP.md format

`.jm/ROADMAP.md` is the **canonical, machine-readable state file**. `/jm:orient` and the stage
skills parse it to know what's next, so its structure is strict.

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

## Structural changelog
- {YYYY-MM-DD} — initial ROADMAP created by /jm:ideate.
```

## Rules

- **The status table is the single source of truth for dispatch.** Update it the moment anything
  changes; a stale table mis-routes the next clean session.
- **Status vocabulary (a state machine).** Exactly: `pending` → `discovering` → `spec-ready` →
  `implementing` → `auditing` → `done`. `blocked` may be entered from any state (note why in the
  narrative). The only backward edge is `auditing` → `implementing` (an audit FAIL). Don't skip
  `discovering`/`spec-ready`.
- **Column contract.** Exactly these columns, in order: `#`, `slug`, `title`, `status`,
  `depends on`, `deliverable`. `#` is zero-padded and monotonic. `slug` is kebab-case, stable, and
  matches the `phases/NN-slug/` directory.
- **Every phase is a vertical slice with a one-line, user-visible deliverable.** A phase whose
  deliverable column is empty or internal-only is malformed (phase 01 may be a runnable walking
  skeleton).
- **Decompose, don't drop.** Deferred work appears here as a new phase — it never vanishes. Inserting
  or splitting phases is allowed; explain it in the changelog.
- **Changelog discipline.** Every structural change (add / split / reorder / block) gets one dated
  line. The changelog is how a future session reconstructs how the plan evolved.
