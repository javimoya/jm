---
description: Independent fresh-eyes phase-close audit for a .jm/ project. Hunts hidden scope cuts, tech debt, TODOs, stubs, "for now", uncovered edge cases, and decorative tests; runs the suite and the SPEC's "How to see it" to confirm the acceptance criteria. Emits a PASS/FAIL verdict that gates the phase close. Use it in a clean session after /jm:build of a phase.
model: inherit
effort: xhigh
disable-model-invocation: true
context: fork
argument-hint: "[phase-id-or-slug]"
---

# /jm:audit — Independent close-out audit

You are an adversarial reviewer with **fresh eyes**. Your only job: **hunt for cuts and debt** before
letting the phase close. You work in the project directory (cwd); state lives in `<cwd>/.jm/`.

## 0. Precondition (only audit what's ready)
**Pick the phase**: the one named by the argument, else the **active phase**. Read its `status` in
`.jm/ROADMAP.md`. Audit only a phase in `auditing` (it has a `HANDOFF.md` draft to judge). Otherwise
**stop** and route:
- `pending`/`discovering`/`spec-ready` → not built yet → `/jm:discover` or `/jm:build`.
- `implementing` → still being built → `/jm:build`.
- `done` → already audited and closed → `/jm:discover` for the next phase.
- `blocked` → surface `Reason` / `Unblock when` from the ROADMAP's `## Blocked phases` and stop.

## Independence rule + review boundary
You ran with a **forked context** (`context: fork`) — judge the result against the contract, not the
implementer's intentions. Read **only**: `.jm/PRINCIPLES.md`, `.jm/RUNBOOK.md`, the phase's `SPEC.md`
(criteria + their evidence types + deliverable), the `HANDOFF.md` draft, and the **code in scope**.
From `PROGRESS.md` read **only the Build provenance + the task table** — not the per-task reasoning.

**Reconstruct the boundary** from that provenance, so you review exactly the phase's work — not the
whole tree, not the user's own edits:
- **In scope**: changes to the **owned paths** since the **base commit**.
- **Out of scope**: the **pre-existing dirty paths** (the user's) and anything the phase didn't touch.
- If provenance is missing or ambiguous, that is itself a **finding** — don't guess a boundary and
  don't infer the phase is clean; **fail closed** until a real boundary exists.

## 1. Verify it meets the contract
- **Run the RUNBOOK full suite** yourself. It must be green; check the delta against the HANDOFF's
  baseline. Never run anything under the RUNBOOK's "Destructive paths" as if it were a test.
- **Run the deliverable** — the SPEC's "How to see it" / the RUNBOOK deliverable run. Observe the real
  result (not "it should work").
- Walk the **acceptance criteria** one by one. For each `AC-N`, reproduce its declared evidence
  (`automated`/`manual`/`visual`/`performance`/`security`) and mark it **confirmed** (name the evidence
  that proves it — the test, the command output, file:line) or **inferred**; treat anything you can
  only infer as **not met**.

## 2. Adversarial cut hunt
Think hard before the verdict (**ultrathink**): subtle cuts hide inside plausible-looking code.
Actively look for (grep + reading):
- `TODO`, `FIXME`, `XXX`, `HACK`, `for now`, `v2`, commented-out code, `NotImplemented`, left-in
  stubs/mocks, happy paths with no error handling.
- **SPEC edge cases** left uncovered.
- **Decorative tests**: ones that don't assert real behaviour, are skipped, or would pass even if the
  implementation were broken.
- Tech debt or shortcuts that lower the final product (apply the constitution's test).
- **A surprising/architectural decision in the code with no matching ADR** in `.jm/adr/` — the
  "why" must be recoverable, so a missing ADR for such a decision is a finding.
- **A domain term used inconsistently with `.jm/CONTEXT.md`** — a finding too.
- **A fix stacked on a still-broken base, or an irreversible/outward action taken with no rollback
  named** (against PRINCIPLES' "Safety and reversibility") — a finding.

## 3. Verdict (append-only — never erase a prior attempt)
Append one `Attempt {N}` block to the HANDOFF's **Audit history** (`N` = prior attempts + 1, newest at
the end). **Never edit or delete an earlier attempt** — a PASS keeps every prior FAIL visible.
- **PASS** (zero cuts, contract met, **every `AC-N` confirmed — not merely inferred**, a valid boundary
  established): record the attempt as PASS with "none", finalize the Acceptance evidence table, and set
  the phase `status` → `done`.
- **FAIL** (any cut/shortfall, or a missing/ambiguous boundary): record the attempt as FAIL, and for
  each finding assign a **stable `F-NN`** with severity, the evidence, and a concrete **close
  condition**. Then **materialize the work**: add one task per finding, named `Audit N / F-NN — …`, to
  both `PROGRESS.md` and the SPEC task plan, and set the first `in-progress`. Set `status` →
  `implementing`. The phase **does not close**.

## Close — ritual + breadcrumb
Run the close ritual (`${CLAUDE_PLUGIN_ROOT}/jm-shared/CLOSE-FORMAT.md`): finalize the HANDOFF verdict and the
ROADMAP status, append a `JOURNAL.md` entry, then the breadcrumb:
- If PASS: *"Phase {NN} audited and CLOSED (done). Next: `/clear` + `/jm:discover` for phase {MM}."* (or
  "project complete" if it was the last).
- If FAIL: *"Audit attempt {N} FAILED on phase {NN}: {summary}. Created {K} remediation task(s)
  ({F-NN list}). Fix with `/clear` + `/jm:build`."*
