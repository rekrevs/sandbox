# Claude Code Sandbox

Run Claude Code in isolated Docker containers, one per project.

## Prerequisites

- **macOS** (uses Colima-specific SSH agent forwarding)
- **Colima** as Docker runtime (not Docker Desktop)
- **Git** configured with `~/.gitconfig`

## Setup

### 1. Install Colima

```bash
brew install colima docker
colima start
```

### 2. Enable SSH Agent Forwarding in Colima

Stop Colima and edit its config:

```bash
colima stop
```

Edit `~/.colima/default/colima.yaml` and add:

```yaml
ssh:
  forwardAgent: true
```

Then restart:

```bash
colima start
```

### 3. Build the Sandbox Image

```bash
cd /path/to/this/repo
docker build -t claude-sandbox .
```

### 4. Add to PATH (optional)

```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="/path/to/this/repo:$PATH"
```

## Usage

```bash
# Start or resume a sandbox for a project
sandbox-run ~/repos/my-project

# Mount additional directories (read-only recommended)
sandbox-run ~/repos/my-project -v ~/data:/data:ro

# List all sandbox containers
sandbox-run --list

# Stop a container
sandbox-run --stop my-project

# Remove a container
sandbox-run --rm my-project
```

Inside the container, run `claude` to start Claude Code.

## Authentication

Claude Code supports two authentication methods:

1. **OAuth (Pro/Max subscribers)** - On first run, Claude Code displays a URL and code. Open the URL in your browser and enter the code to authenticate. Credentials are stored in `~/.claude` which persists across container restarts.

2. **API Key** - Set `ANTHROPIC_API_KEY` environment variable before running `sandbox-run`. Useful for pay-per-use API access.

## Optional API Keys

These are passed through if set:

- `ANTHROPIC_API_KEY`
- `OPENAI_API_KEY`
- `GOOGLE_API_KEY` / `GEMINI_API_KEY`
- `MISTRAL_API_KEY`
- `GROQ_API_KEY`
- `COHERE_API_KEY`
- `HUGGINGFACE_API_KEY`
- `REPLICATE_API_TOKEN`

## What's Included

The sandbox image includes:

- Python 3.12 with common packages (pytest, black, ruff, mypy, pandas, numpy, requests, httpx)
- Node.js 20
- Git, curl, jq, ripgrep, fd-find, tree, vim

## File Mounts

| Host | Container | Mode |
|------|-----------|------|
| Project directory | `/workspace` | read-write |
| `~/.claude` | `/home/sandbox/.claude` | read-write |
| `~/.gitconfig` | `/home/sandbox/.gitconfig` | read-only |
| SSH agent socket | `/ssh-agent` | read-write |

## Troubleshooting

### SSH agent not working

Verify SSH forwarding is enabled in Colima:

```bash
colima ssh -- echo \$SSH_AUTH_SOCK
```

Should output something like `/tmp/ssh-xxx/agent.xxx`. If empty, check your `colima.yaml` config.

### Permission denied on files

The container runs as UID/GID 1000. If your host user has different IDs, rebuild the image:

```bash
docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t claude-sandbox .
```

### Container won't start

Check if a container with that name already exists:

```bash
sandbox-run --list
sandbox-run --rm project-name
```
