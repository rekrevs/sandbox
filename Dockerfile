FROM python:3.12-bookworm

# Common tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    jq \
    ripgrep \
    fd-find \
    tree \
    less \
    vim-tiny \
    openssh-client \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Node.js for Claude Code
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Common Python libs
RUN pip install --no-cache-dir \
    requests \
    httpx \
    numpy \
    pandas \
    pyyaml \
    toml \
    python-dotenv \
    pytest \
    black \
    ruff \
    mypy \
    ipython

# Create non-root user with sudo access
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID sandbox && \
    useradd -m -u $UID -g $GID -s /bin/bash sandbox && \
    echo "sandbox ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up directories
RUN mkdir -p /workspace /home/sandbox/.claude && \
    chown -R sandbox:sandbox /workspace /home/sandbox

USER sandbox
WORKDIR /workspace

# Entrypoint
COPY --chown=sandbox:sandbox entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
