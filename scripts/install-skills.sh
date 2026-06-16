#!/usr/bin/env bash
# install-skills.sh — Copy kb-read and kb-write skills to an agent skills directory.
#
# Usage:
#   bash install-skills.sh hermes|claude|codex
#   bash install-skills.sh /path/to/skills

set -euo pipefail

REPO_URL="https://github.com/shavkunov/second-brain"
TARGET=""

usage() {
    echo "Usage: bash install-skills.sh <target>" >&2
    echo "" >&2
    echo "Targets:" >&2
    echo "  hermes   ~/.hermes/skills/" >&2
    echo "  claude   ~/.claude/skills/" >&2
    echo "  codex    ~/.codex/skills/" >&2
    echo "  <path>   Custom skills directory" >&2
    exit 1
}

if [[ $# -ne 1 ]]; then
    usage
fi

case "$1" in
    hermes) TARGET="$HOME/.hermes/skills" ;;
    claude) TARGET="$HOME/.claude/skills" ;;
    codex)  TARGET="$HOME/.codex/skills" ;;
    -h|--help) usage ;;
    *)      TARGET="$1" ;;
esac

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/../skills"
TMP=""

if [[ ! -d "$SKILLS_SRC/kb-read" ]]; then
    TMP="$(mktemp -d)"
    trap '[[ -n "$TMP" ]] && rm -rf "$TMP"' EXIT
    git clone --depth 1 "$REPO_URL" "$TMP/kp"
    SKILLS_SRC="$TMP/kp/skills"
fi

mkdir -p "$TARGET"
cp -R "$SKILLS_SRC/kb-read" "$TARGET/"
cp -R "$SKILLS_SRC/kb-write" "$TARGET/"

echo "Installed kb-read and kb-write to: $TARGET"
