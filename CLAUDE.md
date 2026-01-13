# Claude Code Sandbox - Agent Instructions

This repo provides a Docker-based sandbox for running Claude Code in isolated per-project containers.

## Key Facts

- **Target platform:** macOS only (uses Colima for SSH agent forwarding)
- **Docker runtime:** Colima required, not Docker Desktop
- **Image name:** `claude-sandbox` (must be built manually)

## Setup Checklist

When helping a user set up this sandbox, verify:

1. **Colima installed and running:** `colima status`
2. **SSH agent forwarding enabled:** Check `~/.colima/default/colima.yaml` has `ssh: forwardAgent: true`
3. **Image built:** `docker images | grep claude-sandbox`
4. **Git configured:** `~/.gitconfig` exists
5. **Claude directory exists:** `~/.claude` exists (created on first Claude Code run)

## Building the Image

The image must be built before first use:

```bash
docker build -t claude-sandbox .
```

Run this from the repo root. If the user has permission issues later (files owned by wrong user), rebuild with their UID/GID:

```bash
docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t claude-sandbox .
```

Build takes 2-3 minutes (downloads Python, Node.js, and packages).

## Common Issues

### "colima ssh" fails or returns empty SSH_AUTH_SOCK
- Colima not running: `colima start`
- SSH forwarding not configured: Edit `~/.colima/default/colima.yaml`, add `ssh: forwardAgent: true`, restart Colima

### Permission errors in container
- UID/GID mismatch. Rebuild image with user's IDs:
  ```bash
  docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t claude-sandbox .
  ```

### Container name conflict
- Remove old container: `sandbox-run --rm <project-name>`

### OAuth login
- Claude Code uses device code flow - it displays a URL and code for the user to open on their host machine's browser. No browser needed in container.

## File Locations

- `sandbox-run` - Main entry script
- `Dockerfile` - Container image definition
- `entrypoint.sh` - Installs Claude Code on container start

## What NOT to Modify

- The `entrypoint.sh` auto-updates Claude Code; don't pin versions unless asked
- SSH agent socket path detection is Colima-specific; don't "fix" for Docker Desktop
