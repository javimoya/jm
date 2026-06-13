# CONTEXT.md format (glossary)

`CONTEXT.md` lives at `.jm/CONTEXT.md`. It is **only a glossary** of the project's ubiquitous
language: what each domain term means. It is **not** a spec, a scratch pad, or a place for
implementation decisions (those are ADRs). Keep it totally free of implementation detail.

## Structure

```md
# {Context name}

{One or two sentences on what this context is and why it exists.}

## Language

**Order**:
{One or two sentences describing the term.}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, receipt

**Customer**:
A person or organization that places orders.
_Avoid_: User, buyer, account
```

## Rules

- **Be opinionated.** When several words exist for the same concept, pick the best one and list the
  rest under `_Avoid_`.
- **Tight definitions.** One or two sentences max. Define what something IS, not what it does.
- **Only terms specific to this project's domain.** General programming concepts (timeouts, error
  types, utility patterns) don't belong even if the project uses them heavily. Before adding one: is
  this a concept unique to this context, or general programming? Only the former belongs.
- **Group terms under subheadings** when natural clusters emerge. If they all belong to one cohesive
  area, a flat list is fine.

## Single vs multiple contexts

**Single context (most projects):** one `.jm/CONTEXT.md`.

**Multiple contexts:** a `.jm/CONTEXT-MAP.md` lists the contexts, where they live, and how they
relate:

```md
# Context map

## Contexts
- [Ordering](./contexts/ordering/CONTEXT.md) — receives and tracks customer orders
- [Billing](./contexts/billing/CONTEXT.md) — generates invoices and processes payments

## Relationships
- **Ordering → Billing**: Ordering emits `OrderPlaced`; Billing consumes it to invoice
- **Ordering ↔ Billing**: shared types `CustomerId` and `Money`
```

Inference: if `CONTEXT-MAP.md` exists, read it to find the contexts; if only a `CONTEXT.md` exists,
single context; if neither exists, create it lazily when the first term is resolved. With multiple
contexts, infer which one the current topic relates to; if unclear, ask.
