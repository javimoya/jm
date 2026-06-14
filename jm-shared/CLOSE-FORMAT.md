# Close ritual (shared)

The end-of-session ritual every **working** skill (`/jm:ideate`, `/jm:discover`, `/jm:build`,
`/jm:audit`) runs before it stops — whether the session finished its goal or is being cut mid-way.
`/jm:orient` does no work and does not run it. Running the same ritual everywhere is what keeps the
ROADMAP, the JOURNAL, and the breadcrumb from drifting apart between clean sessions.

## The ritual (in order)

1. **Persist the skill's own artifacts.** Whatever this skill owns is written and consistent on disk:
   the ROADMAP status table, and (as applicable) the SPEC, `PROGRESS.md`, `HANDOFF.md`, or
   `RUNBOOK.md`. A cut session persists its partial state too (e.g. discovery's "Open questions",
   build's "where to resume").
2. **Update the ROADMAP.** The `status` of the active phase reflects reality, and any structural
   change (add / split / reorder / block) has its dated line in the `## Structural changelog`
   (`ROADMAP-FORMAT.md`). A `block` also records `From` / `Reason` / `Unblock when` in the
   `## Blocked phases` section; unblocking restores `From` exactly and deletes the block.
3. **Append a JOURNAL entry.** Add one entry to `.jm/JOURNAL.md` per `JOURNAL-FORMAT.md`
   (create the file on the first close). Append-only — never edit a prior entry.
4. **Emit the breadcrumb.** End with the skill's one-line breadcrumb: *where you are in the big
   picture + what's next + which skill to continue with*. The JOURNAL's `Next` must match it.

## Commit (the user's call)

Committing is **not** part of the ritual. Per the repo's `CLAUDE.md`, commit only when the user asks.
If they have, commit the touched files with a short imperative message after step 4; otherwise leave
the tree as is and let the breadcrumb stand. Never auto-commit, push, or take any outward action here.

## Cut sessions (wrap-up)

If the session is stopping before its goal (the user said "wrap up", or context is filling): finish
the smallest safe unit, persist the partial state (step 1), set `status` coherently, and make the
breadcrumb and the JOURNAL `Next` name the **exact** resume point — the next task, or the next open
question. Cutting early and handing off cleanly always beats pushing a degraded session.
