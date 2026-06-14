---
description: Checkpoints and hands off the working session you're in the middle of — when context is degrading or you want to pause — without losing anything in progress. Detects what was running from the ROADMAP status and runs that command's own cut-path (build carves the remainder into a follow-up task; discover saves its open questions; audit saves partial findings; ideate persists the partial vision/roadmap), then the shared close ritual and a breadcrumb naming the exact resume point. Use it mid-/jm:build, /jm:discover, /jm:audit, or /jm:ideate instead of stopping abruptly; then /clear and continue in a fresh session.
model: inherit
effort: xhigh
disable-model-invocation: true
---

# /jm:wrap — Checkpoint and hand off the session in progress

You are being asked to **stop the current working session early** — context is degrading, or the user
wants to pause — and hand off cleanly so **nothing in progress is lost**. You do **not** start new
work: you bring what's underway to a safe resting point, persist it, and run the close ritual. You
work in the project directory (cwd); state lives in `<cwd>/.jm/`. This command runs the **same
cut-path the working commands already define** (`CLOSE-FORMAT.md` → "Cut sessions") — it invents no
new ritual.

## 0. Precondition — what's in flight?
Read the active phase's `status` in `.jm/ROADMAP.md` (and glance at the live conversation for what you
were doing). The `status` tells you which command was running and how to cut:
- `implementing` → you were in `/jm:build`. Cut per **`build.md` §5**.
- `discovering` → you were in `/jm:discover`. Cut per **`discover.md`** (the "Open questions" queue).
- `auditing` → you were in `/jm:audit`. Persist partial findings into the `HANDOFF.md` draft.
- **mid-`/jm:ideate`** (no phase rows yet, or VISION/ROADMAP being drafted) → persist the partial
  VISION/ROADMAP.
- **Nothing in flight** (`pending` / `spec-ready` / `done`, a clean tree, or no `.jm/`): there is
  nothing to checkpoint. Say so and route to `/jm:orient`. Don't manufacture work.

## 1. Reach the smallest safe unit (start nothing new)
Finish only the minimum needed to leave a coherent, **known-good** state — never a half-broken tree
(`.jm/PRINCIPLES.md` → "Safety and reversibility"). If one of **your own** in-flight changes can't be
completed safely, **revert just that change** rather than leave it broken; the resume note will say to
redo it. **Never** revert the pre-existing dirty paths recorded in PROGRESS, and never use
`git reset`/`clean`/`checkout -- .` to "get clean" — that destroys the user's work. Do not begin the
next task, question, or check.

## 2. Persist the partial state (delegate — don't re-invent)
Persist exactly what the active command owns, following that command's own checkpoint rule:
- **build** (`implementing`): carve the remainder of the current task into a **new follow-up task**
  (in `PROGRESS.md` and the SPEC's task plan) and record **where to resume** — file:line / next
  concrete step — per `${CLAUDE_PLUGIN_ROOT}/jm-shared/PROGRESS-FORMAT.md`. `status` stays `implementing`.
- **discover** (`discovering`): write the partial SPEC and keep the **"Open questions (working)"**
  list current, next question first. `status` stays `discovering`.
- **audit** (`auditing`): write the findings checked so far into the `HANDOFF.md` draft and note what
  is still unverified. `status` stays `auditing` (no verdict — wrapping is not a PASS/FAIL).
- **ideate**: make `VISION.md` / `ROADMAP.md` consistent with whatever was decided so far; leave any
  new phases `pending`.

## Close — ritual + breadcrumb
Run the close ritual (`${CLAUDE_PLUGIN_ROOT}/jm-shared/CLOSE-FORMAT.md`, the **"Cut sessions"** path): the
artifacts above are persisted, the ROADMAP `status` is coherent, append a `JOURNAL.md` entry, then
emit the breadcrumb. The breadcrumb and the JOURNAL's `Next` must name the **exact** resume point and
the command to continue with:
- build: *"Phase {NN} build checkpointed; remainder carved into task {N+1} ({where to resume}).
  Continue with `/clear` + `/jm:build`."*
- discover: *"Phase {NN} discovery checkpointed; {K} open questions left, next is '{question}'.
  Continue with `/clear` + `/jm:discover`."*
- audit: *"Phase {NN} audit paused; checked {X}, still to verify {Y}. Continue with `/clear` +
  `/jm:audit`."*
- ideate: *"Ideation checkpointed; {what's decided}, {what's open}. Continue with `/clear` +
  `/jm:ideate`."*

Then stop, so the user can `/clear` and resume in a fresh session.
