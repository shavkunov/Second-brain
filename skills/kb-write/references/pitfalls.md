# KB Maintenance Pitfalls

## Pitfall 1: Updating only one file

**The most common mistake.** After discovering a bug or making a change, you update only `current.md`. But knowledge is interconnected — a bug fix affects decisions, history, and possibly the runbook.

**Fix:** After every update, ask: "What other files does this change affect?" Then update them all. See `update-rules.md` for the full matrix.

**Why it matters:** If you update only `current.md`, knowledge is smeared across files and a future session won't find full context. If you update only `decisions.md`, it's unclear whether the decision is still active.

## Pitfall 2: Overwriting without archiving

You discover that port 8080 changed to 9090. You update `current.md` with the new port. But you deleted the old value — now there's no record of when it changed or why.

**Fix:** Before writing new knowledge to `current.md`, move the old version to `history.md`. Always.

**Pattern:**
1. Find the old fact in `current.md`
2. Cut it
3. Paste into `history.md` with a date
4. Write the new fact into `current.md`

## Pitfall 3: Letting the KB go stale

The KB says there are 5 API endpoints. The code has 12. The difference grew gradually over weeks. Now the KB is worse than useless — it's misleading.

**Fix:** Whenever you spot a discrepancy between code and KB, fix the KB immediately. Don't schedule it, don't note it for later. The cost of a stale KB compounds over time.

**Detection signs:**
- Endpoint/module counts don't match code
- Mentioned branches/ports/URLs no longer exist
- Entire modules are missing from the KB
- `current.md` hasn't been updated in weeks on an active project

## Pitfall 4: Orphan files

You create a new `performance.md` in the project folder but forget to add it to `map.md`. Now it exists but is invisible — no one will find it.

**Fix:** Any time you create a new file in the KB, update `map.md` in the same operation. No exceptions.

## Pitfall 5: Duplicating instead of referencing

The same architectural diagram appears in `current.md`, `technical.md`, and `decisions.md`. Now when the architecture changes, you have to update it in three places — and you'll miss one.

**Fix:** Each piece of knowledge has one canonical home. Other files reference it, not duplicate it.

- Architecture lives in `technical.md`. `current.md` says "see technical.md for architecture."
- Decisions live in `decisions.md`. `current.md` says "auth migration decided — see decisions.md."
- The exception is `history.md`, which should be self-contained (future readers may not have the `current.md` it references).

## Pitfall 6: Mixing implementation notes with knowledge

You start writing "today I fixed the auth bug" into `current.md`. That's a work log, not knowledge.

**Fix:** Chronological work logs go in `implementation_notes.md` in the repo root. The KB contains persistent knowledge — what's known, not what happened today.

- `implementation_notes.md` = what was done and when (chronological)
- `kb/` = what's known and why (structural)

## Pitfall 7: Writing essays instead of bullets

`current.md` grows into a narrative document that tells a story instead of stating facts. It becomes hard to scan and hard to update.

**Fix:** `current.md` is bullet points under themed sections. Keep each bullet to 1-2 lines. If you need more than 2 lines, the detail belongs in `technical.md` or `decisions.md`.

## Pitfall 8: Forgetting to update after code review

Code review reveals architectural changes, new modules, changed contracts, dead code. You fix the code but don't update the KB. Next session starts with stale context.

**Fix:** After every code review, update at minimum `technical.md` (architecture) and `current.md` (refactor status, open issues).

## Pitfall 9: Treating `history.md` as a trash can

You move everything you don't need anymore to `history.md` without structure. It becomes an unsearchable dump.

**Fix:** Historical entries should be self-contained and searchable. Use the template:
- What happened (1-2 lines)
- Why it happened (1-2 lines)
- What we learned (1-2 lines)
- When (date)

If using `history/` directory, name files descriptively: `015-auth-migration.md`, not `015-update.md`.
