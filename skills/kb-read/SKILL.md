---
name: kb-read
description: "Read-only access to a Second Brain knowledge base. Start with map.md → current.md → technical.md → history/. Never invent facts. Skills do NOT replace the KB."
triggers:
  - read the knowledge base
  - find information about the project
  - what is known about
  - current knowledge
  - how does X work
---

# Second Brain — Read

## When to use

Before starting ANY task with code, read the knowledge base first. The KB contains context that would otherwise require hours of code archaeology.

## Workflow

```
map.md → project folder → current.md → [technical.md | runbook.md | decisions.md | history.md | links.md]
```

1. **Read `kb/map.md`** — navigation index for all projects
2. **Identify the project** — find the relevant project folder
3. **Read `current.md`** — what's true right now
4. **Drill down as needed:**
   - `technical.md` — architecture, API, models, data formats
   - `runbook.md` — commands, env vars, ports, startup procedures
   - `decisions.md` — what was decided and why
   - `history.md` (or `history/`) — old approaches, past incidents, dead ends
   - `links.md` — dependencies on other projects
5. **Follow cross-references** — `links.md` may point to other project folders

## Rules

- **Never invent facts.** If the KB doesn't contain the information, say "not found in knowledge base."
- **Never skip `map.md`.** It's the entry point for a reason.
- **Signal stale knowledge.** If what you read in `current.md` contradicts what you see in code, warn the user and offer to update via `kb-write`.
- **Skills do NOT replace the KB.** This skill defines the process (how to read). The KB contains the knowledge (what's known). Both are needed.
- **Check `history/` structure.** Some projects use a single `history.md`, others use a `history/` directory with numbered files. Check `map.md` for which variant.

## When to stop reading

- You have enough context to proceed with the task → stop
- `current.md` is empty or clearly outdated → warn, proceed with code inspection
- The project folder doesn't exist yet → the KB hasn't been initialized; suggest running `init-kb.sh`
