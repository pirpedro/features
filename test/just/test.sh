#!/usr/bin/env bash
set -euo pipefail
[ -f dev-container-features-test-lib ] && . dev-container-features-test-lib || true

TARGET_USER="${_REMOTE_USER:-vscode}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
SAFE_PATH="${TARGET_HOME}/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# 2) PATH seguro inclui /usr/local/bin (especial p/ Alpine)
check "just installed for user in safe PATH works" \
  bash -lc "HOME='${TARGET_HOME}' USER='${TARGET_USER}' PATH='${SAFE_PATH}' command -v just >/dev/null"

check "just version works" \
bash -lc "HOME='${TARGET_HOME}' USER='${TARGET_USER}' PATH='${SAFE_PATH}' just --version | grep -E 'just [0-9]+\.[0-9]+\.[0-9]+'"

check "Justfile copied to ~/.config/just/Justfile" \
test -f "${TARGET_HOME}/.config/just/Justfile"

reportResults
