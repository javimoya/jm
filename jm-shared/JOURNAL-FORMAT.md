# JOURNAL.md format

`.jm/JOURNAL.md` is the project's **append-only narrative history** — one entry per working
session, in order. It is the durable record the per-phase HANDOFF and the ROADMAP changelog don't
keep: it captures *every* session (ideation, discovery, build, audit), including the ones that
produce no phase HANDOFF. `/jm:orient` reads the latest entry to recall "what just happened".

## Structure

Newest entries are appended at the BOTTOM. One entry per session:

```md
# Journal — {Project name}

## {YYYY-MM-DD} — /{skill}: {short title}
- **Did**: {3–8 bullets: what happened; decisions taken (link the SPEC/ADR); spec/code written; problems hit}
- **State change**: {phase NN status X → Y; or "—" if none}
- **Next**: {the one concrete next action — same as the session's breadcrumb}
```

## Rules

- **Append-only. Never edit or delete a prior entry.** History is immutable; a correction is a new
  entry, not a rewrite. This is what lets a future session reconstruct how the project actually
  evolved, missteps included.
- **One entry per working session**, written by the close ritual (`CLOSE-FORMAT.md`) of every working
  skill. `/jm:orient` does no work and writes nothing here.
- **`Next` mirrors the breadcrumb** so the journal and the hand-off never disagree on what comes next.
- **Link, don't duplicate.** Point to the SPEC/ADR/HANDOFF that holds the detail; the journal is the
  index of sessions, not a second copy of their contents.
- **Created lazily** at the first close (the first `/jm:ideate` session), with the
  `# Journal — {name}` header.
