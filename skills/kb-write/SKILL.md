---
name: kb-write
description: "Write access to a Knowledge Protocol knowledge base. Update and create notes. Principle: Integrate, don't dump."
triggers:
  - save knowledge
  - update the knowledge base
  - record a decision
  - add a note
---

# Knowledge Base — Write

## Core principle

**Integrate, don't dump.** Every note must be reachable through `map.md`. Every update must touch all relevant files, not just the obvious one.

## When to write

- After completing a task — update `current.md` if anything changed
- After making a decision — record in `decisions.md`
- After discovering new knowledge — add to `current.md` or `technical.md`
- When knowledge becomes stale — move old to `history.md`, write new to `current.md`

## Where to write

| Type of knowledge | File | Rule |
|---|---|---|
| What's true right now | `current.md` | Short, actionable, scannable |
| How it works | `technical.md` | Architecture, API, models, data formats |
| How to run it | `runbook.md` | Commands, env vars, ports |
| Why it's this way | `decisions.md` | What was decided, alternatives, tradeoffs |
| What used to be true | `history.md` or `history/` | Old approaches, past incidents, dead ends |
| What depends on what | `links.md` | Cross-project dependencies |

## Update process

1. Find existing note via `map.md`
2. Determine: update existing or create new
3. Update content (reference, don't duplicate)
4. If a new file was created → add/update entry in `map.md`
5. If information became stale → move old to `history.md`, write new to `current.md`

## Mandatory: update ALL relevant files

When you discover or change something, update **every file that's affected** — not just the obvious one:

| What happened | current.md | technical.md | decisions.md | history.md | runbook.md |
|---|---|---|---|---|---|
| Bug found & fixed | + status, fix | + root cause detail | + why this fix | + chronology | + new diagnostic command |
| Architecture changed | + new structure | + updated diagram/API | + why the change | + old architecture | — |
| New module added | + module exists | + module API | — | — | + how to run it |
| Decision reversed | + new direction | + implications | + new decision + old rationale | + old decision | — |
| Operational lesson | + operational note | — | — | + incident report | + new command/procedure |

**Why this matters:** If you update only `current.md`, knowledge is smeared across files and a future session won't find full context. If you update only `decisions.md`, it's unclear whether the decision is still active.

## Current vs historical

- **Current** (`current.md`): true right now, affects how you work
- **Historical** (`history.md` or `history/`): no longer affects current work

**Test:** "If I deleted this, would it change how I approach a task today?" → Yes = current. No = historical.

When knowledge becomes stale, **move the old version to `history.md` before writing the new version to `current.md`**. Never overwrite without archiving.

## After code review

Code review often reveals architectural changes not reflected in the KB: new modules, changed contracts, duplicated code, dead imports. After review:

- `technical.md` — updated architecture, new/changed services
- `current.md` — refactor status, open issues

## After bug fix

When a bug from a tracker is confirmed fixed in code, reflect it in `current.md` explicitly. Otherwise a future session wastes time diagnosing a stale bug report.

Record: what was broken, what was fixed, where the tests are, status = FIXED.

## After significant operational event

Update `current.md` with operational status and `runbook.md` with any new diagnostic commands or procedures discovered during the incident.

## Stale KB detection

**Stale knowledge is worse than missing knowledge** — it actively misleads. When you spot drift between code and KB, update the KB immediately. Don't schedule it.

Signs of staleness:
- Endpoint/module counts in KB don't match code
- Mentioned branches/ports/URLs no longer exist
- Entire modules are missing from the KB

## Implementation notes (separate from KB)

Besides the KB, maintain `implementation_notes.md` in the **root of each repository** — a chronological work log with dates. This does NOT duplicate the KB: KB = what's known and why, notes = what was done and when.

**Format:**
```markdown
# Implementation Notes

## [YYYY-MM-DD] — Brief task description
- **What was done**: ...
- **Decisions**: ...
- **Lessons**: ...
- **Files**: ...
```

**Rules:**
- New entry = new date. Multiple tasks per day = separate subheadings.
- Don't duplicate KB content — reference it.
- Implementation notes = chronicle of work; KB = persistent knowledge.

## Completion checklist

After every task:

1. [ ] Updated all relevant KB files (current, technical, decisions, history, runbook)
2. [ ] Added entry to `implementation_notes.md` in repo root
3. [ ] If task spans multiple repos → wrote notes in each
4. [ ] If new files were created → updated `map.md`
