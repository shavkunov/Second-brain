# Read Workflow — Deep Dive

## Navigation order

The KB is designed for progressive disclosure. Each level adds detail:

```
Level 0: map.md           → Where is everything?
Level 1: current.md       → What's true right now?
Level 2: technical.md     → How does it work?
Level 2: runbook.md       → How do I run it?
Level 2: decisions.md     → Why is it this way?
Level 3: history.md       → What used to be true?
Level 3: links.md         → What else is affected?
```

## Reading strategies

### Quick context (most common)

```
map.md → current.md → done
```

Use when: you need enough context to start working, and the task is straightforward.

### Deep understanding

```
map.md → current.md → technical.md → decisions.md → done
```

Use when: you need to understand architecture before making changes.

### Operational task

```
map.md → current.md → runbook.md → done
```

Use when: you need to run, deploy, or debug something.

### Debugging a known issue

```
map.md → current.md → history.md → links.md → done
```

Use when: something is broken and you need to understand what changed.

### Cross-project impact

```
map.md → links.md → [other project]/current.md → [other project]/technical.md
```

Use when: a change in one project might affect another.

## Fallback strategies

### KB doesn't exist yet

1. Tell the user the project has no KB
2. Suggest running `init-kb.sh` to create one
3. Proceed with code inspection — don't block on KB absence

### `current.md` is empty

The KB exists but hasn't been populated. Read `technical.md` and `runbook.md` if they have content. Otherwise, proceed with code inspection and offer to populate the KB via `kb-write`.

### Knowledge contradicts code

This is the most important case:

1. **Trust the code.** Code is the source of truth.
2. **Warn the user.** "The KB says X, but the code shows Y. The KB may be stale."
3. **Offer to update.** Invoke `kb-write` to fix the discrepancy.
4. **Don't silently ignore the KB.** Stale knowledge is a signal that maintenance is needed.

### Can't find a project folder

1. Check `map.md` — maybe it's listed under a different name
2. Check `links.md` in related projects — maybe it's referenced there
3. If truly missing, the project hasn't been added to the KB yet

## What NOT to do

- **Don't read every file every time.** Start shallow, go deeper only as needed.
- **Don't assume the KB is complete.** It's a living document, not a spec.
- **Don't treat the KB as executable.** Commands in `runbook.md` may be outdated — verify before running.
- **Don't copy KB content into your context window wholesale.** Read selectively based on the task.
