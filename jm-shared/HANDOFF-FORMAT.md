# HANDOFF.md format

`.jm/phases/NN-slug/HANDOFF.md` is the message to the next clean session — drafted by `/jm:build`,
finalized by `/jm:audit`. It must let someone without your context continue.

## Structure

```md
# HANDOFF — Phase {NN}: {title}

## What was built
{The delivered capability. What the system does now that it didn't before.}

## Decisions made
{Relevant implementation decisions. Architectural/surprising ones also go in as an ADR.}

## How to verify
- **Command / steps**: {the SPEC's "How to see it" / the RUNBOOK deliverable run, runnable}
- **Real observed result**: {what actually came out when you ran it}

## Acceptance evidence
{One row per SPEC criterion. A criterion is `confirmed` only with cited, reproducible evidence;
anything you can merely infer is NOT met.}

| AC | evidence type | check run | observed result | status |
|----|---------------|-----------|-----------------|--------|
| AC-1 | automated | {test name/path} | {what you saw} | confirmed |

## Test status
- **Baseline at start**: {N passing / M failing — names of the failing ones; the RUNBOOK full-suite command}
- **At close**: {N passing / 0 failing — or the delta, named and justified}

## Audit history (append-only)
{Owned by /jm:audit. One block per attempt, newest appended — a later PASS never erases an earlier
FAIL. /jm:build leaves this empty.}

### Attempt {N} — {PASS | FAIL} — {YYYY-MM-DD}
- **Boundary reviewed**: {base commit; owned paths; pre-existing dirty paths excluded}
- **Findings**: {FAIL → one per finding: `F-NN` {severity} — {what} — evidence — close condition.
  PASS → "none".}
- **Outcome**: {PASS → phase set to `done` | FAIL → phase set to `implementing`, F-NN tasks created}

## Open threads / impact on other phases
{Discoveries that mutated the ROADMAP. NOT cuts: recorded sequencing.}

## What the next session needs
{The minimum to start. Which phase and stage come next.}
```

## Rules

- **"How to verify" cites the REAL observed result** from actually running it — never "it should
  work". If you didn't run it, you can't write this section.
- **Acceptance evidence is per-criterion and `confirmed` means cited.** Every SPEC `AC-N` gets a row;
  `confirmed` names the evidence that proves it, with the matching evidence type. A row you can only
  infer is not met — and an unmet row cannot pass the audit.
- **Test status is baseline→final with names.** "Green" with no recorded baseline is invalid — you
  can't claim you broke nothing without a number to diff against. The command is the RUNBOOK full suite.
- **Audit history is append-only and owned by `/jm:audit`.** `/jm:build` leaves it empty; each audit
  appends one `Attempt N` block and never edits or deletes an earlier one — a later PASS keeps every
  prior FAIL visible. `/jm:audit` flips the phase status as the attempt's outcome dictates.
- **Open threads are recorded sequencing, not cuts.** New phases/tasks discovered here are legitimate
  ordering; a *cut* (lost capability or quality) is never recorded here — it's forbidden.
- **Self-sufficient.** The next session must continue from this handoff plus the docs it points to,
  with nothing left in your head.
