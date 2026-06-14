# Grilling protocol (shared)

This is the interrogation method used by `/jm:ideate` and `/jm:discover`. The goal is to **reach a sharp,
shared understanding before writing any code** — squeezing what is still vague out of the user's head
and forcing precision.

## How to grill

- **Interrogate relentlessly** about every aspect of the work until you both hold the same mental
  picture. Walk the decision tree branch by branch, resolving dependencies between decisions one at a
  time (decision A constrains B; settle A first).
- **One question at a time.** Wait for the answer before continuing. No batteries of questions.
- **For every question, give your recommended answer** and why, plus the alternatives you weighed and
  why they lose — lead with the recommendation. A question without a recommendation is work you're
  pushing back onto the user.
- **If a question can be answered by exploring, explore** the code and docs instead of asking. Don't
  ask what you can find out yourself.
- Use the harness's question tool for clean forks, but always leave the door open to free-form
  answers: the best answers often don't fit a menu.

## During the session

### Sharpen fuzzy language
When the user uses a vague or overloaded term, propose a precise canonical term. *"You're saying
'account' — do you mean the Customer or the User? Those are different things."* When a term is
resolved, **update `CONTEXT.md` right there** (format in `CONTEXT-FORMAT.md`); don't batch it.

### Challenge against the glossary
If the user uses a term that conflicts with the language already fixed in `CONTEXT.md`, call it out at
once. *"Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"*

### Stress-test with concrete scenarios
When you discuss domain or design relationships, invent specific scenarios that probe edge cases and
force precision about the boundaries between concepts. *"What if an order arrives with no line items?
What if the partial payment exceeds the total?"*

### Cross-reference with code
When the user states how something works, check whether the code agrees. On a contradiction, surface
it: *"Your code cancels whole Orders, but you just said partial cancellation is possible — which is
true?"*

### Bring what the user hasn't thought of (especially in ideation)
Don't just collect the user's ideas. Add divergence: design alternatives, prior art, approaches from
other domains, risks they haven't seen, and "have you considered X?". **In ideation, push laterally**:
propose possible features, capabilities, and out-of-the-box ideas the user hasn't named — angles from
adjacent products and other domains — to open up areas they haven't contemplated, not just refine the
ones already in their head. **Diverge first** (generate and contrast options), **then converge** (grill
until it's nailed down).

### Confirm before you stop questioning
When you think you've worked through the questions you planned, **don't silently move on** to writing.
Turn back to the user: name the areas you have *not* yet probed and **propose concrete ones worth
opening** — unexplored features or scenarios, edge cases, integrations, non-functional concerns,
failure modes — then ask whether to dig into any of them or wrap up the questioning. Keep offering
until the user chooses to stop; only then proceed to write/close. This checkpoint is mandatory, not a
courtesy: the user decides when questioning ends, not the running-out of your list.

### ADRs with judgment
Offer to record a decision as an ADR **only** when all three are true (see `ADR-FORMAT.md`): hard to
reverse, surprising without context, and the result of a real trade-off. If one is missing, no ADR.

## The anti-scope-cut bar applies here too
Grilling is **never** a tool for reducing scope. If something "for later" surfaces during the
interrogation, it is not dropped — it follows the constitution's three moves (`CONSTITUTION.md`,
`CAPTURE.md`): a **new phase** in the ROADMAP, a later **task**, or — when it belongs to an
already-planned `pending` phase — a **seed in `.jm/NOTES.md` targeting that phase's `slug`**. That last
case is the one to watch: deferring a known piece of scope to a later phase is **sequencing, not a
boundary**, and a `NOTES.md` seed is the *only* record re-read when that phase is later discovered
(`/jm:discover` §1 reads it, §5 folds it). Recording such a deferral only as an "out of scope" line in
the SPEC or a `JOURNAL.md` note is a silent drop — neither is read at the target phase's discovery.
Grilling defines the complete product at the agreed bar; it only decides *order*, never lowers the
*what*.
