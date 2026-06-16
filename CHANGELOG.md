# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] — 2026-06-16

### Added
- Initial release of Knowledge Protocol.
- `kb-read` skill: read-only access to knowledge bases with structured navigation workflow.
- `kb-write` skill: write access with "Integrate, don't dump" principle and multi-file update rules.
- `init-kb.sh` script: scaffold a `kb/` directory in any project.
- Templates for all 6 KB files: map.md, current.md, technical.md, runbook.md, decisions.md, history.md, links.md.
- References: read-workflow.md, update-rules.md, pitfalls.md.
- AGENTS.md: authoritative project doc for AI agents.
- Tests for init-kb.sh.

### Design decisions
- 6-file structure per project (current, technical, runbook, decisions, history, links).
- `map.md` as mandatory navigation entry point.
- Separation of current vs historical knowledge.
- Implementation notes separate from KB (chronological vs structural).
- `history.md` as single file by default; `history/` directory for large projects.
