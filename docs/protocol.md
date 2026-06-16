# Second Brain — deep dive

Extended reference. The [README](../README.md) is the quick overview; skills and templates are the operational source of truth.

## Update matrix

**One event → multiple files.** A bug fix is not just a `current.md` entry.

| What happened | current | technical | decisions | history | runbook |
|---|---|---|---|---|---|
| Bug found & fixed | + status, fix | + root cause | + why this fix | + chronology | + diagnostic cmd |
| Architecture changed | + new structure | + updated diagram | + why change | + old architecture | — |
| New module added | + module exists | + API | — | — | + how to run |
| Decision reversed | + new direction | + implications | + new + old rationale | + old decision | — |
| Operational incident | + status note | — | — | + incident report | + new procedure |

Full per-event rules: [`skills/kb-write/references/update-rules.md`](../skills/kb-write/references/update-rules.md).

Updating only `current.md` is the #1 mistake — other files go stale and the KB contradicts itself.

## Knowledge lifecycle

Before overwriting `current.md`, move the old fact to `history.md`. Never delete without archiving.

## Principles

1. **Current ≠ historical** — `current.md` is only what's true right now. Obsolete facts move to `history.md` first.
2. **One update touches all relevant files** — see the matrix above. Partial updates create inconsistency.
3. **Stale knowledge is worse than missing knowledge** — fix drift between code and docs immediately.
4. **Map is the entry point** — every file must be reachable from `map.md`.
5. **Knowledge ≠ chronicle** — work logs live in `implementation_notes.md` at the repo root, not in `kb/`.

## Common mistakes

See [`skills/kb-write/references/pitfalls.md`](../skills/kb-write/references/pitfalls.md) for all nine pitfalls with fixes.
