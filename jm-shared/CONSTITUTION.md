# PRINCIPLES.md — The project constitution

> Read at the start of **every** working session (`/jm:ideate`, `/jm:discover`, `/jm:build`, `/jm:audit`). It is
> non-negotiable. It complements the repo's `CLAUDE.md` (baseline before claiming, verify before
> declaring, stay in scope) — it does not duplicate it.

## Prime directive

**We always produce the final, complete, robust, perfect product.** Quality and robustness are not
negotiable. **Effort is NEVER a factor** when choosing the best solution: if the right solution costs
ten times more, we do the right one. There is no "good enough".

## No scope cuts

- **No "v1 / v2 / later" as an excuse to ship less.** The final product loses no capability, no
  robustness, no edge-case handling.
- **Zero technical debt.** No `TODO`, `FIXME`, stub, left-in mock, `// for now`, shortcut,
  "leave it like this for now", or half-finished implementation in the final product.
- **Never pick the easier option over the better one.** When torn between two paths, the one that
  yields the best final product wins — not the one that saves you work.

## The reframe: decompose, don't drop

When you feel the urge to defer something, **that's not a signal to cut — it's a signal to
decompose**. The only permitted move:
- If it's a distinct capability → **create it as a new PHASE** in the ROADMAP (complete, with its own
  quality bar, tests, and deliverable). Record it.
- If it's the continuation of the implementation in progress → **create it as a later TASK** of the
  phase.

The thread is never dropped silently. The ROADMAP may grow; the final product's bar never drops.
Deferring = lowering the final product's quality (FORBIDDEN). Sequencing = same product, different
order (ALLOWED).

### The test (use it before ever "leaving something for later")

> **"Will the end state of the whole project be any less complete, robust, or clean if I do it this
> way?"**
> - **Yes → forbidden.** It's a cut. Do it right now, or turn it into a phase/task at full bar.
> - **No, it's only order → allowed.** The perfect product is decomposed into units; each at full
>   bar; the ROADMAP captures the rest without lowering anything.

## Each phase's contract

A phase does not close without ALL of this:
1. **Vertical slice**: an end-to-end capability, not a half-built horizontal layer.
2. **A concrete, runnable deliverable** the user can see/try/validate, with a **"How to see it"**
   section (a real command or steps). Phase 0 is a runnable *walking skeleton*.
3. **Acceptance criteria** (defined in the SPEC during `/jm:discover`, before implementing).
4. **A complete, green test suite** covering the criteria + regression, with a **recorded baseline**
   (how many passed/failed before; how many now). Real coverage, not decorative.
5. **A HANDOFF** written so the next clean session can continue without you explaining it.

## Tasks (partition of the implementation)

**Tasks** split *only* the `/jm:build` work of a phase, so it fits in context. A task has **no**
validatable deliverable and **no** tests of its own — those live at the phase level. `/jm:orient`,
`/jm:ideate`, `/jm:discover`, and `/jm:audit` are not split into tasks.

## Context discipline

A long session fills the context window and degrades results. The model **cannot reliably measure its
own context usage**, so we do not gate on a percentage. Two levers instead:
- `/jm:discover` **sizes tasks small** so each `/jm:build` comfortably fits one fresh session. This is the
  primary control.
- **You (the user) can checkpoint at any time.** Mid-`/jm:build`, tell the session to wrap up: it moves
  the unfinished part of the current task into a new follow-up task, records where to resume in
  `PROGRESS.md`, leaves the tree clean and prepared, and stops — so you can `/clear` and continue in a
  fresh session.

Cutting early and handing off cleanly always beats pushing a degraded session.

## Breadcrumb

**Every** skill ends by reminding the user, in one line: *where you are in the big picture + what's
next + which skill to continue with*. This is what connects the manual flow between clean sessions.
Every **working** skill (`/jm:ideate`, `/jm:discover`, `/jm:build`, `/jm:audit`) emits this breadcrumb as
the last step of the shared **close ritual** (`CLOSE-FORMAT.md`), which also updates the ROADMAP and
appends to the append-only `JOURNAL.md`. `/jm:orient` only reads.

## Close-out gate (self-accounting)

Before closing any phase or task, **explicitly** list everything you simplified, deferred, left as a
TODO/stub, or solved with a shortcut. For each item: either turn it into a phase/task, or justify it
with the test above. **Nothing closes with uncounted cuts.** The independent `/jm:audit` (fresh eyes)
will hunt again for whatever slipped past you.
