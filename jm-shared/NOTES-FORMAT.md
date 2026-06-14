# NOTES.md format

`.jm/NOTES.md` is the project's **single backlog of seeds** — ideas, features, and refinements
captured by `/jm:capture` or by a working command's inline capture (`CAPTURE.md`), waiting to be
folded into phase SPECs. It is the project-wide, pre-SPEC counterpart of a SPEC's transient
"Open questions (working)" list.

**One file for the whole project** (it lives next to `ROADMAP.md` and `JOURNAL.md`), not one per
phase, so that:
- **reorganising or renumbering phases never moves or breaks a seed** — a seed references a phase by
  its **stable `slug`**, never its number;
- **a single seed can target several phases at once** — each target is folded (and checked off)
  independently, and the seed is fully consumed only when all of them are done.

## Structure

```md
# NOTES — {Project name}

## Open seeds
{Captured, not yet fully folded. Newest first. One `###` block per seed.}

### {short title}
- **Captured**: {YYYY-MM-DD}, {who raised it / which session or command}
- **Seed**: {what to fold, and the why behind it}
- **Fold into**:
  - [ ] `{slug-a}` — {the aspect this phase takes from the seed}
  - [ ] `{slug-b}` — {the aspect that phase takes}   ← extra lines only for a multi-phase seed

## Consumed
{Every target folded. Moved here whole — the decompose-don't-drop trace stays visible.}

### {short title} — captured {YYYY-MM-DD}
- **Folded**: `{slug-a}` → {AC-N / Task N / CONTEXT term / ADR} · `{slug-b}` → {…}  (/jm:discover {dates})
```

## Rules

- **`/jm:discover` consumes by phase.** When it discovers a phase, it folds in every open seed whose
  **Fold into** list has an **unchecked box for that phase's `slug`**, then checks that box with a
  pointer to where it landed (`AC-N`, a task, a CONTEXT term, an ADR).
- **Fully consumed = all boxes checked.** A seed stays in `## Open seeds` while any target box is
  unchecked (it's only partially folded). The moment the last box is checked, move the whole `###`
  block to `## Consumed`. Never delete a seed — moved, not erased, the same discipline as the ROADMAP
  changelog and the JOURNAL.
- **Reference phases by `slug`, never number.** Slugs are stable; numbers shift when pending phases are
  reordered. This is exactly what lets re-planning leave `NOTES.md` untouched.
- **Seeds are inputs, not contract.** Acceptance criteria, evidence, and the deliverable live in the
  SPEC; a seed only records what to consider and why, until discovery turns it into the contract.
- **A seed that belongs elsewhere is re-targeted, not dropped** (`CAPTURE.md`): change its `slug`
  targets, or split it into a new phase — never a silent drop.
- **Created lazily** on the first capture, with the `# NOTES — {name}` header. No secrets
  (`PRINCIPLES.md` → "Safety and reversibility"): record the *name* of an env var/credential, never
  its value.
```

