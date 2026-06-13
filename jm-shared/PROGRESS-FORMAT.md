# PROGRESS.md format

`.jm/phases/NN-slug/PROGRESS.md` is `/jm:build`'s working memory across tasks — the checkpoint that
lets you `/clear` and resume cleanly. Terse is fine; unambiguous is mandatory.

## Structure

```md
# PROGRESS — Phase {NN}: {title}

## Task state

| # | task | status |
|---|------|--------|
| 1 | {name} | pending |
| 2 | {name} | pending |

## Per-task log (closed / split)

### Task {N} — {name} — {done | split mid-way}
- **Done**: {what got implemented and tested}
- **Remaining**: {what's left — if split, this became task N+1}
- **Where to resume**: {file:line, function, the next concrete step}
- **Files touched**: {list}
- **Notes for the next session**: {gotchas, in-flight decisions}
```

## Rules

- **One row per task**, status ∈ `pending` / `in-progress` / `done`. The plan here mirrors the SPEC's
  task plan; keep them consistent.
- **Every closed or split task logs "Where to resume" unambiguously** — a `file:line` or a concrete
  next step a stranger could act on. This is the whole point of the checkpoint.
- **A split creates the follow-up task in both places** — here and in the SPEC's task plan — so the
  next session sees it.
- **No deliverable or test claims here.** Those are phase-level and live in the HANDOFF.
