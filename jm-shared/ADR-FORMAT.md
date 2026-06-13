# ADR format (decisions)

ADRs live in `.jm/adr/` with sequential numbering: `0001-slug.md`, `0002-slug.md`, etc. Create
the `.jm/adr/` directory lazily — only when the first ADR is needed.

## Template

```md
# {Short title of the decision}

{1-3 sentences: what's the context, what did we decide, and why.}
```

That's it. An ADR can be a single paragraph. The value is in recording *that* a decision was made and
*why* — not in filling out sections.

## Optional sections

Only when they add real value (most ADRs won't need them):
- **Status** (`proposed | accepted | deprecated | superseded by ADR-NNNN`) — useful when revisited.
- **Options considered** — only when the rejected alternatives are worth remembering.
- **Consequences** — only when non-obvious downstream effects need calling out.

## Numbering
Scan `.jm/adr/` for the highest existing number and increment by one.

## When to offer an ADR

All three must be true:
1. **Hard to reverse** — changing your mind later carries real cost.
2. **Surprising without context** — a future reader will look at the code and wonder "why on earth
   did they do it this way?".
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for
   specific reasons.

If it's easy to reverse, skip it (you'll just reverse it). If it's not surprising, nobody will wonder
why. If there was no real alternative, there's nothing to record beyond "we did the obvious thing".

### What qualifies
- **Architectural shape.** "Monorepo." "Write model is event-sourced, read model projected into
  Postgres."
- **Integration patterns between contexts.** "Ordering and Billing communicate via domain events, not
  synchronous HTTP."
- **Technology choices that carry lock-in.** Database, message bus, auth provider, deploy target. Not
  every library — just the ones that would take a quarter to swap out.
- **Boundary and scope decisions.** "Customer data is owned by the Customer context; others reference
  it by ID only." The explicit no-s are as valuable as the yes-s.
- **Deliberate deviations from the obvious path.** "Manual SQL instead of an ORM because X." Anything
  where a reasonable reader would assume the opposite — it stops the next engineer from "fixing" what
  was deliberate.
- **Constraints not visible in the code.** "We can't use AWS due to compliance." "Responses must be
  under 200ms because of the partner contract."
- **Rejected alternatives when the rejection is non-obvious.** If you weighed GraphQL and picked REST
  for subtle reasons, record it — or someone will propose GraphQL again in six months.
