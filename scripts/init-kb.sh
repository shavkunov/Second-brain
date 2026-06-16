#!/usr/bin/env bash
# init-kb.sh — Scaffold a Second Brain knowledge base in any project.
#
# Usage:
#   bash init-kb.sh /path/to/project [--name "Project Name"]
#
# Creates a kb/ directory with the standard 6-file structure.

set -euo pipefail

# --- Args ---
PROJECT_DIR=""
PROJECT_NAME=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        -*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            if [[ -z "$PROJECT_DIR" ]]; then
                PROJECT_DIR="$1"
            else
                echo "Unexpected argument: $1" >&2
                exit 1
            fi
            shift
            ;;
    esac
done

if [[ -z "$PROJECT_DIR" ]]; then
    echo "Usage: bash init-kb.sh /path/to/project [--name \"Project Name\"]" >&2
    exit 1
fi

if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "Error: directory does not exist: $PROJECT_DIR" >&2
    exit 1
fi

# Derive project name from directory if not provided
if [[ -z "$PROJECT_NAME" ]]; then
    PROJECT_NAME="$(basename "$PROJECT_DIR")"
fi

# Slugify: lowercase, replace non-alphanumeric with hyphens
SLUG="$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-//;s/-$//')"

# --- Resolve script directory (to find templates) ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/../skills/kb-write/templates"

# Fall back to relative path if run from repo root
if [[ ! -d "$TEMPLATE_DIR" ]]; then
    TEMPLATE_DIR="$(cd "$SCRIPT_DIR" && pwd)/skills/kb-write/templates"
fi

# --- Create KB structure ---
KB_DIR="$PROJECT_DIR/kb"
PROJECT_KB="$KB_DIR/$SLUG"

echo "Initializing Second Brain in: $KB_DIR"
echo "Project: $PROJECT_NAME (slug: $SLUG)"

# Create directories
mkdir -p "$PROJECT_KB"

# Copy templates, substituting <Project Name> and <project-name>
for template in map.md current.md technical.md runbook.md decisions.md history.md links.md; do
    target=""
    if [[ "$template" == "map.md" ]]; then
        target="$KB_DIR/map.md"
    elif [[ "$template" == "links.md" ]]; then
        target="$PROJECT_KB/links.md"
    else
        target="$PROJECT_KB/$template"
    fi

    if [[ -f "$TEMPLATE_DIR/$template" ]]; then
        sed -e "s/<Project Name>/$PROJECT_NAME/g" \
            -e "s/<project-name>/$SLUG/g" \
            "$TEMPLATE_DIR/$template" > "$target"
    else
        # Template not found — create minimal version
        echo "# $PROJECT_NAME — ${template%.md}" > "$target"
        echo "" >> "$target"
        echo "<!-- Fill in during your first kb-write session. -->" >> "$target"
    fi

    echo "  Created: ${target#$PROJECT_DIR/}"
done

# Create README.md for the KB
cat > "$KB_DIR/README.md" << EOF
# Knowledge Base — $PROJECT_NAME

Structured knowledge following [Second Brain](https://github.com/shavkunov/second-brain).

## Structure

\`\`\`
kb/
├── map.md              # Navigation — START HERE
├── README.md           # This file
└── $SLUG/
    ├── current.md      # What's true right now
    ├── technical.md    # How it works
    ├── runbook.md      # How to run it
    ├── decisions.md    # Why it's this way
    ├── history.md      # What used to be true
    └── links.md        # Cross-project dependencies
\`\`\`

## How to work with this KB

- **Reading:** Start with \`map.md\`, then drill into project folders.
- **Writing:** Update all relevant files after every change. See the kb-write skill.
- **Principle:** Integrate, don't dump. Every note must be reachable from \`map.md\`.

**Entry point:** → [map.md](map.md)
EOF

echo "  Created: kb/README.md"

# Add kb/ to .gitignore if it doesn't exist (it shouldn't be ignored — KB is committed)
# Actually, KB should be committed. Let's just add a .gitkeep to ensure the directory is tracked.
touch "$PROJECT_KB/.gitkeep"

echo ""
echo "✓ Knowledge base initialized at: $KB_DIR"
echo ""
echo "Next steps:"
echo "  1. Fill in $SLUG/current.md with current project knowledge"
echo "  2. Fill in $SLUG/technical.md with architecture details"
echo "  3. Fill in $SLUG/runbook.md with startup commands"
echo "  4. Update kb/map.md if you add more project sections"
echo "  5. Commit the kb/ directory to your project's repo"
