# Update Rules — When and How to Update Each File

## Decision matrix

| Event | current.md | technical.md | decisions.md | history.md | runbook.md | map.md |
|---|---|---|---|---|---|---|
| New feature added | + exists, status | + API, models | — | — | + how to use | if new module |
| Bug found & fixed | + status, fix | + root cause | + why this fix | + chronology | + diagnostic cmd | — |
| Architecture changed | + new structure | + updated diagram | + why change | + old architecture | — | — |
| Decision made | + consequence | + if affects API | + full decision | — | — | — |
| Decision reversed | + new direction | + implications | + new + old rationale | + old decision | — | — |
| New module/endpoint | + module exists | + API | — | — | + how to invoke | + if new file |
| Dependency changed | + new dep | + integration detail | + why switch | + old dep | + new commands | — |
| Config/env changed | + current config | — | + why change | + old config | + new values | — |
| Operational incident | + status note | — | — | + incident report | + new procedure | — |
| Performance finding | + benchmark | + bottleneck | + optimization rationale | + before state | — | — |

## Per-file update rules

### current.md

**Add when:** something became true that wasn't before.
**Remove when:** something is no longer true → move to `history.md` first.
**Format:** bullet points under themed sections. Keep it scannable.

Good:
```markdown
## API
- Auth endpoint moved from `/v1/auth` to `/v2/auth` (2024-03)
- Rate limit: 100 req/min per API key
```

Bad:
```markdown
## API
The auth endpoint used to be at /v1/auth but we moved it to /v2/auth in March because
the old endpoint didn't support OAuth2 and the team decided... (long explanation)
```

The long explanation belongs in `decisions.md` or `history.md`. `current.md` states what's true, not why.

### technical.md

**Add when:** a new component, API endpoint, data model, or integration is introduced.
**Update when:** an existing component's interface or behavior changes.
**Remove when:** a component is deleted → move description to `history.md`.

Structure by domain: Architecture, API, Data Models, Integrations, Error Handling.

### decisions.md

**Add when:** a deliberate choice is made between alternatives.
**Never remove.** Decisions are append-only. If a decision is reversed, add a new entry that references the old one.

Format per decision:
```markdown
### Decision: [Title]
- **Date:** YYYY-MM-DD
- **Context:** What was the situation
- **Options considered:** A, B, C
- **Chosen:** B
- **Rationale:** Why B
- **Reversed:** (leave blank, or add date + reference if reversed later)
```

### history.md

**Add when:** knowledge moves from `current.md` because it's no longer true.
**Never remove from history.** Even dead ends are valuable — they prevent re-exploration.

Two formats:

**Single file** (default):
```markdown
# History

## March 2024: Auth endpoint migration
- **What:** Moved from /v1/auth to /v2/auth
- **Why:** OAuth2 support, token refresh
- **Lesson:** v1 clients need migration guide
```

**Directory** (for large projects, files named `NNN-slug.md`):
```markdown
# Auth endpoint migration
- Date: 2024-03-15
- Status: resolved
- ...
```

### runbook.md

**Add when:** a new operational procedure is discovered or needed.
**Update when:** commands, env vars, or ports change.
**Test when possible:** commands in runbook should be copy-paste runnable.

### links.md

**Add when:** a new cross-project dependency is introduced.
**Update when:** dependency direction or nature changes.
**Format:** bidirectional — both projects should reference each other.

## The "don't just update one file" rule

This is the single most important rule in KB maintenance. A partial update is worse than no update because it creates inconsistency.

**Scenario:** You discover that the API rate limit changed from 100 to 200 req/min.

| File | What to update |
|---|---|
| `current.md` | Rate limit value |
| `technical.md` | Rate limiting implementation if it changed |
| `decisions.md` | Why the limit was raised |
| `history.md` | Old limit + when it changed |
| `runbook.md` | Only if rate limit testing commands exist |

If you update only `current.md`, a future session reading `technical.md` still sees the old value. The KB becomes self-contradictory.
