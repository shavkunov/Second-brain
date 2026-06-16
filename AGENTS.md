# AGENTS.md

Authoritative project doc. Any agent opening this repo should read this file alone and understand the project, where to make changes, and what conventions to follow.

## What this repo is

**Second Brain** is a framework-agnostic knowledge base structure and two agent skills (`kb-read` + `kb-write`) that give AI agents a consistent way to store, navigate, and maintain project knowledge across sessions.

- Two skills: read-only (`kb-read`) and write (`kb-write`)
- One init script: `scripts/init-kb.sh` scaffolds a `kb/` directory in any project
- Zero runtime dependencies: pure markdown + bash
- Works with: Hermes Agent, Claude Code, Codex or any agent that reads markdown

## Repo layout

```
second-brain/
├── README.md                   Public-facing: short overview, one Mermaid diagram, quick start
├── docs/
│   └── protocol.md             Extended protocol: update matrix, lifecycle, principles
├── AGENTS.md                   This file. Authoritative project doc.
├── CHANGELOG.md                Per-version release notes. Keep-a-Changelog format.
├── LICENSE                     MIT.
├── skills/
│   ├── kb-read/                Read skill
│   │   ├── SKILL.md            Skill definition
│   │   └── references/
│   │       └── read-workflow.md  Deep dive: navigation order, fallback strategies
│   └── kb-write/               Write skill
│       ├── SKILL.md            Skill definition
│       ├── references/
│       │   ├── update-rules.md   When and how to update each file
│       │   └── pitfalls.md       Common mistakes in KB maintenance
│       └── templates/          Starter templates copied into new KBs
│           ├── map.md
│           ├── current.md
│           ├── technical.md
│           ├── runbook.md
│           ├── decisions.md
│           ├── history.md
│           └── links.md
├── scripts/
│   ├── init-kb.sh             Scaffold a kb/ directory in any project
│   └── install-skills.sh      Copy kb-read + kb-write to an agent skills directory
└── tests/
    └── init-kb.test.sh        Verify init-kb.sh creates correct structure
```

## What ships vs what doesn't

- **Ships to consumers**: everything under `skills/` + `scripts/init-kb.sh` + `scripts/install-skills.sh`
- **Repo-only**: `README.md`, `CHANGELOG.md`, `LICENSE`, `AGENTS.md`, `tests/`

## How the skills work

### kb-read (one paragraph)

When invoked, the agent reads `kb/map.md` to locate the relevant project section, then reads `current.md` for what's true now, and drills into `technical.md`, `runbook.md`, `decisions.md`, `history.md`, or `links.md` as needed. The skill enforces: never invent facts, never skip map.md, signal when knowledge is stale.

### kb-write (one paragraph)

When invoked after a task, the agent determines what changed and updates **all relevant files** — not just the obvious one. A bug fix means `current.md` (status), `decisions.md` (why this fix), `history.md` (what was broken), and possibly `runbook.md` (new operational command). Old facts move to `history.md` before new facts go into `current.md`. If new files are created, `map.md` is updated. The skill enforces: integrate, don't dump.

## The KB structure (the core product)

Every project using Second Brain gets a `kb/` directory:

```
kb/
├── map.md              # Navigation index — START HERE
├── README.md           # How this KB is organized
└── <project>/
    ├── current.md      # What's true right now
    ├── technical.md    # How it works
    ├── runbook.md      # How to run it
    ├── decisions.md    # Why it's this way
    ├── history.md      # What used to be true (or history/ for large projects)
    └── links.md        # Cross-project dependencies
```

### The 6-file contract

| File | Contains | Must be | Must not be |
|------|----------|---------|-------------|
| `current.md` | Active, actionable knowledge | Short, scannable, true right now | Historical detail, speculation |
| `technical.md` | Architecture, API, models, formats | Complete enough to understand internals | Operational commands, rationale |
| `runbook.md` | Commands, env vars, ports, procedures | Copy-paste ready | Architectural explanations |
| `decisions.md` | What was decided, why, alternatives considered | Each decision self-contained | Implementation details |
| `history.md` | Old approaches, dead ends, past incidents | Chronological | Current operating knowledge |
| `links.md` | Dependencies, integrations, shared components | Bidirectional (both projects reference each other) | Duplicate of current.md content |

### history.md vs history/

- `history.md` (single file) — for projects with moderate history. Sections are `## Month Year: Title`.
- `history/` (directory) — for projects with extensive history. Files named `NNN-slug.md`.

Use `history.md` by default. Switch to `history/` only when the single file exceeds ~500 lines. Document which variant in `map.md`.

## Making changes

### Editing skills

Edit `skills/kb-read/SKILL.md`, `skills/kb-write/SKILL.md`, or files under `references/` and `templates/`.

After editing:

1. **Test the init script** — `bash tests/init-kb.test.sh` (should pass all assertions)
2. **Verify templates render** — manually inspect that each template in `skills/kb-write/templates/` is valid markdown
3. **Bump version** in `CHANGELOG.md`
4. **Commit, push**

### Adding a new template

1. Create the template file in `skills/kb-write/templates/`
2. Update `scripts/init-kb.sh` to copy the new template
3. Update `tests/init-kb.test.sh` to verify the new file is created
4. Update this AGENTS.md's "The 6-file contract" table if it's a new file type

### Editing scripts only

No version bump needed for script-only fixes. Just commit + push.

## Conventions

- **Skill names**: `kb-read` and `kb-write` (lowercase, hyphenated)
- **KB directory**: always `kb/` at project root (configurable via `KB_ROOT` env var in init script)
- **Language**: templates and docs are in English by default. Translating the protocol to another language is a fork-level decision.
- **Markdown**: standard CommonMark. No wiki-links, no shortcodes, no tool-specific syntax.
- **No trailing whitespace** in templates. Enforced by `.gitattributes`.

## Gotchas

- **Skills don't replace the KB.** Skills define the *process* (how to read/write). The KB contains the *knowledge* (what's known). Both are needed.
- **One update = multiple files.** The most common mistake is updating only `current.md` after a change. See `skills/kb-write/references/pitfalls.md`.
- **Stale KB is worse than no KB.** An outdated `current.md` actively misleads. When code and docs diverge, update docs immediately.
- **`map.md` must be exhaustive.** Any file not in `map.md` is effectively invisible.
- **Implementation notes ≠ KB.** Chronological work logs belong in the repo root (`implementation_notes.md`), not in `kb/`. KB = what's known. Notes = what was done.
