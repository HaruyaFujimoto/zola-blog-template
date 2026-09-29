#!/usr/bin/env bash
set -e

# install zola specific version
ZOLA_VERSION=v0.23.6
ARCH=$(uname -m)

curl -sL -o /tmp/zola.tar.gz \
  "https://github.com/getzola/zola/releases/download/${ZOLA_VERSION}/zola-${ZOLA_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz"
tar xzf /tmp/zola.tar.gz -C /tmp
sudo install -m 755 /tmp/zola /usr/local/bin/zola
rm -f /tmp/zola.tar.gz /tmp/zola

# install claude-code
curl -fsSL https://claude.ai/install.sh | bash
# export PATH="$HOME/.local/bin:$PATH"

# install playwright MCP
claude mcp add playwright npx @playwright/mcp@latest
