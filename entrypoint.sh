#!/bin/bash
set -e

# Install/update Claude Code to latest (only if not already current)
if ! command -v claude &> /dev/null; then
    echo "Installing Claude Code..."
    sudo npm install -g @anthropic-ai/claude-code@latest --silent 2>/dev/null
else
    # Update in background to not slow down startup
    (sudo npm install -g @anthropic-ai/claude-code@latest --silent 2>/dev/null &)
fi

echo "Claude sandbox ready. Run 'claude' to start Claude Code."
echo ""

exec bash
