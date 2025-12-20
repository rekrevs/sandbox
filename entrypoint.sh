#!/bin/bash
set -e

# Configure npm to use user-local directory for global packages (enables auto-update)
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"
mkdir -p "$HOME/.npm-global"

# Persist PATH for interactive shell
if ! grep -q 'npm-global' "$HOME/.bashrc" 2>/dev/null; then
    echo 'export NPM_CONFIG_PREFIX="$HOME/.npm-global"' >> "$HOME/.bashrc"
    echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> "$HOME/.bashrc"
fi

# Install/update Claude Code to latest (only if not already current)
if ! command -v claude &> /dev/null; then
    echo "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code@latest --silent 2>/dev/null
else
    # Update in background to not slow down startup
    (npm install -g @anthropic-ai/claude-code@latest --silent 2>/dev/null &)
fi

echo "Claude sandbox ready. Run 'claude' to start Claude Code."
echo ""

exec bash
