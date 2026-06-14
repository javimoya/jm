# PROGRESS.md format

`.jm/phases/NN-slug/PROGRESS.md` is `/jm:build`'s working memory across tasks — the checkpoint that
lets you `/clear` and resume cleanly. Terse is fine; unambiguous is mandatory.

## Structure

```md
# PROGRESS — Phase {NN}: {title}

## Build provenance
{Written by /jm:build before the first code change, then never rewritten (only "Owned paths" grows).
This is the boundary /jm:audit reviews against.}
- **Base commit**: {git HEAD when the build started, or `unversioned` if not a git repo / no commits}
- **Pre-existing dirty paths**: {paths already modified or untracked when the build started — the
  user's, NOT this build's. Off-limits: build/audit/wrap never revert these.}
- **Owned paths**: {files this build created or changed — grows as tasks proceed}

## Task state

| # | task | status |
|---|------|--------|
| 1 | {name} | pending |
| 2 | {name} | pending |

## Per-task log (closed / split)

### Task {N} — {name} — {done | split mid-way}
- **Done**: {what got implemented and tested}
- **Verified**: {the focused check run for this task and its real result — e.g. the test path + pass}
- **Remaining**: {what's left — if split, this became task N+1}
- **Where to resume**: {file:line, function, the next concrete step}
- **Files touched**: {list}
- **Notes for the next session**: {gotchas, in-flight decisions}
```

## Rules

- **One row per task**, status ∈ `pending` / `in-progress` / `done`. The plan here mirrors the SPEC's
  task plan; keep them consistent.
- **Build provenance is written once, before any code changes, and not rewritten.** Only "Owned paths"
  grows as tasks touch files. "Pre-existing dirty paths" are never claimed as owned and never reverted
  (constitution: "You only own what this session changed").
- **Every closed or split task logs "Where to resume" unambiguously** — a `file:line` or a concrete
  next step a stranger could act on. This is the whole point of the checkpoint.
- **A split creates the follow-up task in both places** — here and in the SPEC's task plan — so the
  next session sees it.
- **Audit-remediation tasks live here too.** An audit FAIL adds one task per finding, named
  `Audit N / F-NN — …`, in this table and the SPEC plan; `/jm:build` works exactly those on the next pass.
- **No phase-level deliverable or full-suite claims here.** The per-task "Verified" line is a *focused*
  check; the deliverable run and the full suite are phase-level and live in the HANDOFF.
