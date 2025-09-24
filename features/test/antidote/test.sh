#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'antidote' Feature.
#
# This test can be run with the following command:
#
#    devcontainer features test \ 
#                   --features antidote   \
#                   --remote-user root \
#                   --skip-scenarios   \
#                   --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
#                   /workspaces/features

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Detect target user/home (aligns with common-utils)
TARGET_USER="${_REMOTE_USER:-vscode}"
TARGET_HOME="$(eval echo ~${TARGET_USER})"
ZDOTDIR="${ZDOTDIR:-$TARGET_HOME}"

check "zsh is installed" bash -lc "command -v zsh"
check "antidote dir exists" test -d "${ZDOTDIR}/.antidote"
check "antidote script exists" test -f "${ZDOTDIR}/.antidote/antidote.zsh"
check "plugins file exists" test -f "${ZDOTDIR}/.zsh_plugins.txt"
check "bundle exists" test -f "${ZDOTDIR}/.zsh_plugins.zsh"
check ".zshrc contains antidote block" grep -q "## BEGIN: antidote" "${ZDOTDIR}/.zshrc"

# Can source bundle in zsh
check "plugins can be sourced" \
  bash -lc "HOME='${TARGET_HOME}' ZDOTDIR='${ZDOTDIR}' zsh -lc 'source \"${ZDOTDIR}/.zsh_plugins.zsh\"'"

# Report results
reportResults