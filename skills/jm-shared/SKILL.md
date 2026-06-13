---
name: jm-shared
description: Internal shared library for the jm workflow — the constitution, the grilling protocol, the close ritual, and the document format templates that the other jm skills read by relative path. Not a user action and not meant to be invoked; it exists so these shared files ship and resolve when installed as a plugin.
user-invocable: false
---

# jm — shared protocols & formats (reference library)

This directory is a **reference library, not a runnable skill.** It holds the documents the
jm working skills read by relative path (`../jm-shared/<file>`):

- `CONSTITUTION.md` — the project's quality bar (copied into a project as `PRINCIPLES.md`).
- `GRILLING.md` — the interrogation protocol used by ideation and discovery.
- `CLOSE-FORMAT.md` — the end-of-session close ritual.
- `VISION-FORMAT.md`, `ROADMAP-FORMAT.md`, `SPEC-FORMAT.md`, `PROGRESS-FORMAT.md`,
  `HANDOFF-FORMAT.md`, `CONTEXT-FORMAT.md`, `ADR-FORMAT.md`, `JOURNAL-FORMAT.md` — the templates
  for the files kept in a project's `.jm/` folder.

There is nothing to run here. The `SKILL.md` exists only so that, when this repo is installed as a
plugin, these shared files are copied into the plugin cache and the sibling skills' relative
references (`../jm-shared/...`) keep resolving.
