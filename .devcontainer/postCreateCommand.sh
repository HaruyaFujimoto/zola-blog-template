#!/bin/bash

set -euo pipefail

# 通常は devcontainer.json の remoteEnv で通るが、手で実行したときのために設定しておく
export PATH="$HOME/.local/bin:$PATH"

# git
# macOS からの bind mount (virtiofs) は、書き込み直後の約1秒間 /workspace が root 所有に見え、
# git が "dubious ownership" で失敗する。所有者は固定されておらず UID 調整では直らないので、
# このパスに限って所有者チェックを外す
if ! git config --global --get-all safe.directory | grep -qxF /workspace; then
  git config --global --add safe.directory /workspace
fi

# claude-code
# 更新頻度が高くバージョンを固定したくないので、feature ではなく公式インストーラで入れる

echo "install claude-code"

curl -fsSL https://claude.ai/install.sh | bash

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
