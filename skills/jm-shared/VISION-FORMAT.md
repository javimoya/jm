# VISION.md format

`.jm/VISION.md` is the project's north star, produced by `/jm:ideate`. It states the complete
destination — not an MVP. Stable; changes rarely.

## Structure

```md
# Vision — {Project name}

## Problem / opportunity
{The real problem we solve or the opportunity we chase. Concrete, not generic.}

## For whom
{Who uses it. If there are several user types, name them.}

## What it is — and what it is NOT
- **It is**: {essence in 2-3 sentences}
- **It is not**: {explicit out-of-scope boundaries — by product decision, not by effort}

## "Done and perfect" (global definition of done)
{What the complete, robust, perfect product looks like. The bar everything is measured against.}

## Quality bar and non-negotiables
{Cross-cutting requirements no phase may lower. Numbers where they exist.}

## Unknowns / risks
{What we don't know yet and will have to discover.}
```

## Rules

- **Describe the destination, not an MVP.** "Done and perfect" is the bar everything is measured
  against; make it concrete enough to actually measure against.
- **Non-negotiables must be checkable.** A quality bar nobody can verify is decoration. If there are
  numbers (latency, etc.), put them.
- **Product intent, not architecture.** No implementation detail here; technical decisions live in
  ADRs, the ubiquitous language in `CONTEXT.md`.
- **"It is not" is load-bearing.** Explicit product-scope boundaries (decided by product, never by
  effort) prevent drift.
- **Stable.** If something big changes here, the ROADMAP almost certainly needs revisiting.
