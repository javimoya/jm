# jm

**Build big things with [Claude Code](https://claude.com/claude-code), one phase at a time, without quietly cutting scope or losing track of where you left off.**

`jm` is a small Claude Code plugin: a handful of *slash commands* that take a vague idea and turn it into a finished, robust product. It works by splitting the work into **phases**, building each one to a high bar in its own clean session, and writing all the project state to disk, so any fresh session can pick up exactly where the last one stopped.

It's opinionated on purpose. Its prime directive:

> **The final product is complete and robust to the agreed bar. Nothing gets silently dropped. It either becomes more work, or it's written down as a deliberate, approved boundary.**

Once installed, the commands live under the `jm` namespace: `/jm:ideate`, `/jm:discover`, `/jm:build`, `/jm:audit`, `/jm:orient`, `/jm:wrap`.

---

## Why

Building something big with an AI agent usually falls apart in a few predictable ways.

**The idea was never sharpened.** Agents are eager to please: hand one a fuzzy idea and it starts coding on its own assumptions, so you only discover the mismatch once it has built the wrong thing.

**Scope quietly shrinks.** "I'll stub this for now," "v1 is fine," "good enough," and the thing you end up with is full of holes.

**Context rots.** One long session drifts off, forgets what you decided an hour ago, and the quality drops.

**You lose your place.** You come back the next day and neither you nor the agent can remember where things stood.

`jm` handles each of these as a method rather than a model:

- **Adversarial grilling** before any code: it diverges first — bringing options, prior art, and out-of-the-box ideas you hadn't considered — then interrogates you one question at a time, each with its recommended answer, until the idea is sharp and testable. Think of it as a supercharged take on the well-known [`grill-me`](https://github.com/mattpocock/skills/blob/main/skills/productivity/grill-me/SKILL.md) skill, woven through `/jm:ideate` and `/jm:discover` — and it always checks in before it stops, proposing fresh angles worth exploring rather than going quiet.
- A **constitution** that bans cuts and turns "later" into "a new phase" instead of a quiet deletion.
- **Phases**: vertical slices, each one built and verified in its own fresh session with clean context.
- A **`.jm/` folder** in your repo that holds the single source of truth. Any new session rebuilds the full picture by reading it.

---

## Quick start

In Claude Code:

```
/plugin marketplace add javimoya/jm
/plugin install jm@jm
```

Then, from inside the folder of the project you want to build, run:

```
/jm:ideate      # turn your idea into a vision + a roadmap of phases
```

Every step ends with a one-line breadcrumb that tells you exactly what to run next.

> Stuck, or coming back after a break? Run **`/jm:orient`**. It reads your project and tells you where you are and what to do next, and it changes nothing.

> Don't want to use the plugin system? See **[Alternative install](#alternative-install-without-the-plugin)** below.

---

## How it works

```mermaid
flowchart LR
    I["/jm:ideate<br/>vision + roadmap"] --> D["/jm:discover<br/>phase spec"]
    D --> B["/jm:build<br/>implement + tests"]
    B --> A["/jm:audit<br/>fresh-eyes review"]
    A -- PASS --> D
    A -- FAIL --> B
    O(["/jm:orient<br/>where am I?"]) -.-> D
    O -.-> B
    O -.-> A
```

You work through a project one phase at a time. A phase is a vertical slice, something you can actually run and look at, and it goes through three stages. Each stage runs in its own clean Claude session, so use `/clear` between them to keep the context sharp.

1. **Discover** (`/jm:discover`) questions you until the phase is a precise, testable spec.
2. **Build** (`/jm:build`) implements that spec to the highest bar, with real tests, and checkpoints as it goes.
3. **Audit** (`/jm:audit`) is an independent, fresh-eyes review that hunts for shortcuts and can fail the phase, which sends it back to build.

`/jm:ideate` runs once at the start, and again later when you want to add features. `/jm:orient` is your GPS at any point.

---

## The skills

| Command | Role | When you run it |
|---|---|---|
| **`/jm:ideate`** | Ideation and kickoff. Produces the vision and the roadmap of phases. Also extends a project that's already underway with new features. | Starting a project, or adding a big new idea. |
| **`/jm:discover`** | Turns one roadmap phase into a testable SPEC (acceptance criteria, deliverable, task plan). | At the start of each phase. |
| **`/jm:build`** | Implements the phase's SPEC to the highest bar, one task at a time, with tests. | After the SPEC is approved. |
| **`/jm:audit`** | Independent fresh-eyes audit. PASS closes the phase; FAIL sends it back. | After a phase is built. |
| **`/jm:orient`** | Read-only GPS. Works out where you are and what's next. Changes nothing. | Any time you're lost or returning. |
| **`/jm:wrap`** | On-demand checkpoint. Cuts the session you're in the middle of, carving in-progress work into a follow-up task (or saving open questions and partial findings), so nothing is lost. | Mid-build or mid-discover, when context degrades or you want to pause. |

---

## What it creates: the `.jm/` folder

Everything the workflow knows lives in a `.jm/` folder at the root of your project. This is the durable memory that lets clean sessions hand work off to each other:

```
.jm/
├── PRINCIPLES.md      # the constitution (the quality bar), copied at kickoff
├── VISION.md          # the complete destination: what "done and perfect" means
├── ROADMAP.md         # the canonical state: phases, status, dependencies, blocked memory
├── RUNBOOK.md         # the pinned run/verify commands (full suite, deliverable, destructive paths)
├── CONTEXT.md         # a glossary of your project's domain terms
├── JOURNAL.md         # append-only history: one entry per work session
├── adr/               # Architecture Decision Records (the "why" behind big calls)
└── phases/
    └── NN-slug/
        ├── SPEC.md      # the phase's testable contract (criteria with typed evidence)
        ├── PROGRESS.md  # build checkpoint: provenance, which task is next, where to resume
        └── HANDOFF.md   # what was built + how to verify + append-only audit history
```

Commit this folder alongside your code. Anyone (you tomorrow, a teammate, a fresh agent) can run `/jm:orient` and carry on.

---

## The phase lifecycle

Each phase moves through a strict state machine, tracked in `ROADMAP.md`:

```
pending → discovering → spec-ready → implementing → auditing → done
```

- `blocked` is a first-class pause for an external wall you can't clear yourself — a missing credential, a third party, a product decision only you can make. jm proposes it and you confirm; it's never a way to quietly defer buildable work, and it can't touch a `done` phase. It remembers where it came from, why, and what has to happen to unblock — and unblocking puts the phase back exactly where it was.
- The only step backward is `auditing → implementing`: an audit **FAIL**, which turns each finding into a concrete remediation task you can track.

This is what lets the skills route themselves: run `/jm:build` on a phase that isn't ready and it stops and points you to `/jm:discover`.

---

## The rules that make it work

These are enforced by `PRINCIPLES.md` (the constitution) and by the skills themselves.

- **Decompose, don't drop, or set an explicit boundary.** If something is "for later," it becomes a new phase or task. If it's genuinely out of scope, it goes into the VISION as a recorded, approved boundary. It never just disappears.
- **Verify before you claim.** A per-project `RUNBOOK.md` pins the exact full-suite command so build and audit measure the same thing. Record a baseline before you start, run the real deliverable before you call it done, and let an independent fresh-eyes audit confirm each criterion. Every attempt is kept in an append-only history.
- **Own only what you changed.** Builds record their base commit and the tree's pre-existing dirty paths, so your own uncommitted work never gets reverted or blamed on a phase.
- **Clean context per step.** Each stage runs in a fresh session and hands off through `.jm/`, so quality never degrades inside a bloated session.
- **Resumable everywhere.** Long discovery sessions and long builds can be cut partway through and continued; open questions and "where to resume" get written down. Run **`/jm:wrap`** to checkpoint on demand the moment the context starts to degrade.

---

## Managing the plugin

```
/plugin marketplace update jm     # pull the latest version
/plugin                           # open the menu to enable/disable/uninstall
/plugin marketplace remove jm     # remove the marketplace entirely
```

Developing locally? Point the marketplace at your checkout instead of GitHub:

```
/plugin marketplace add /path/to/jm
/plugin install jm@jm
```

---

## Alternative install (without the plugin)

The plugin install above is the recommended path. If you'd rather skip the plugin system, `install.sh` copies the commands into `~/.claude/commands/jm/` and the shared library into `~/.claude/jm-shared/`, which gives you the same `/jm:ideate` … `/jm:orient` commands as the plugin:

```bash
git clone https://github.com/javimoya/jm.git
cd jm
./install.sh          # copy into ~/.claude
./uninstall.sh        # remove again
```

Safe to re-run: any existing manual install gets backed up to `*.bak.<timestamp>` first. This route doesn't auto-update, so re-run `./install.sh` after a `git pull`.

### Requirements

- [Claude Code](https://claude.com/claude-code), via the CLI, desktop app, or IDE extension.
- The commands inherit your session's model (`model: inherit`) and never auto-invoke (`disable-model-invocation: true`). Tune `model:` and `effort:` in any `commands/*.md` to taste.

---

## Customizing

- `jm` is the command namespace (so `/jm:build` and friends); `.jm/` is the state folder inside your projects.
- It's all plain Markdown. Open any `commands/<name>.md` or the `jm-shared/*-FORMAT.md` templates and change the wording, the bar, or the document formats to fit your team.

---

## FAQ

**Is this a library or framework I import?** No. It's a set of Markdown instructions that steer Claude Code. There's no runtime and nothing to import.

**Does it work for any language or stack?** Yes, it's stack-agnostic. The skills talk about specs, tests, and deliverables; you bring the language.

**Do I have to use all of them?** The four working skills form the loop (ideate → discover → build → audit). `/jm:orient` (GPS) and `/jm:wrap` (checkpoint) are optional but handy.

**Why clean sessions and `/clear` between steps?** Long sessions degrade. Each step is sized to fit one fresh session, and the `.jm/` files carry the state across, so you're always working with a sharp context.

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for what changed in each version.

## License

MIT, see [LICENSE](LICENSE).