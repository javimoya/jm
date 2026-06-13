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
- **Command / steps**: {the SPEC's "How to see it", runnable}
- **Real observed result**: {what actually came out when you ran it}

## Test status
- **Baseline at start**: {N passing / M failing — names of the failing ones}
- **At close**: {N passing / 0 failing — or the delta, named and justified}

## Audit verdict
- **Result**: {PASS | FAIL}
- **Findings**: {cuts/debt caught, or "none"}

## Open threads / impact on other phases
{Discoveries that mutated the ROADMAP. NOT cuts: recorded sequencing.}

## What the next session needs
{The minimum to start. Which phase and stage come next.}
```

## Rules

- **"How to verify" cites the REAL observed result** from actually running it — never "it should
  work". If you didn't run it, you can't write this section.
- **Test status is baseline→final with names.** "Green" with no recorded baseline is invalid — you
  can't claim you broke nothing without a number to diff against.
- **The Audit verdict section is owned by `/jm:audit`.** `/jm:build` leaves it as a draft; `/jm:audit` fills it
  and flips the phase status.
- **Open threads are recorded sequencing, not cuts.** New phases/tasks discovered here are legitimate
  ordering; a *cut* (lost capability or quality) is never recorded here — it's forbidden.
- **Self-sufficient.** The next session must continue from this handoff plus the docs it points to,
  with nothing left in your head.
