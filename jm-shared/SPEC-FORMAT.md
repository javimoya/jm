# SPEC.md format

`.jm/phases/NN-slug/SPEC.md` is the phase's **testable contract**, produced by `/jm:discover`.
`/jm:build` implements to it; `/jm:audit` measures against it. Be strict.

## Structure

```md
# SPEC — Phase {NN}: {title}

## Goal
{What capability this phase delivers and why now. 2-3 sentences.}

## Vertical slice
{The end-to-end capability being built. Not a horizontal layer.}

## Acceptance criteria (testable)
{Each criterion carries a stable ID, the Given/When/Then, the kind of evidence that will close it, and
the exact check that produces that evidence. IDs are stable for the life of the phase — audit findings
and tests reference them.}
- **AC-1** — {Given … when … then …}
  - **Evidence**: {automated | manual | visual | performance | security}
  - **Verify**: {the exact command/steps that produce that evidence — for `automated`, the test
    name/path, runnable from the RUNBOOK's full suite}
- **AC-2** — …

## Deliverable + "How to see it"
- **Deliverable**: {the runnable/observable artifact left when the phase closes}
- **How to see it**: {the real command or steps the user runs, and what to observe}

## Task plan
1. **Task 1 — {name}**: {implementation scope of this chunk}
2. **Task 2 — {name}**: {…}

## Decisions and terms touched
- ADRs created/affected: {links}
- CONTEXT.md terms sharpened: {list}

## Dependencies
{Which prior phases/artifacts are assumed done. What this phase unblocks.}

## Open questions (working)
{Transient grilling queue — present only while status is `discovering`. One bullet per unresolved
question, most important first. Emptied before the SPEC becomes `spec-ready`.}
- [ ] {next open question}
```

## Rules

- **Acceptance criteria have stable IDs, are atomic, and name their evidence.** Each `AC-N` is one
  Given/When/Then with an **evidence type** (`automated` preferred; `manual` / `visual` /
  `performance` / `security` allowed *only* when genuinely not automatable) and an exact, reproducible
  **Verify** step. A criterion that can only be *inferred* — no runnable check — isn't a criterion;
  sharpen it until it has one. IDs never change once assigned (audit findings cite them).
- **The deliverable is runnable/observable, and "How to see it" is a real command or concrete
  steps** the user runs — never a vague description. No "How to see it" means the phase has no
  validatable deliverable, which is malformed.
- **Tasks split implementation only.** No task has its own deliverable or tests (those are
  phase-level). Size each task so it comfortably fits one fresh `/jm:build` session; the user can
  checkpoint at any time, so size generously, not optimistically. An audit FAIL **appends** remediation
  tasks named `Audit N / F-NN — …` (one per finding) to this plan; they follow the same rule.
- **WHAT, not HOW.** The SPEC pins the contract and the acceptance, not a line-by-line
  implementation. Architectural choices belong in ADRs; domain terms in `CONTEXT.md` (link both under
  "Decisions and terms touched").
- **It's a contract.** Once approved, scope that grows mid-build doesn't get crammed in: it follows
  the decompose rule (new task/phase) with a changelog/ADR note.
- **"Open questions" is a resumable checkpoint, not part of the contract.** While `/jm:discover` is
  grilling, answered decisions are written into the sections above and the still-unresolved questions
  stay here, most-important-first. A phase stays `discovering` while this list is non-empty; it only
  becomes `spec-ready` once the list is empty and the contract is complete (then empty or drop the
  section). This is what lets a long discovery be cut and resumed cleanly.
