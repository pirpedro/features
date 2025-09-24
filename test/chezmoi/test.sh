#!/usr/bin/env bash
set -euo pipefail
# Import the devcontainer test lib if available
[ -f dev-container-features-test-lib ] && . dev-container-features-test-lib || true

TARGET_USER="${_REMOTE_USER:-vscode}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

CHEZMOI_BIN="$(bash -lc 'command -v chezmoi || true')"
check "chezmoi installed" test -n "$CHEZMOI_BIN"

check "chezmoi runs with target env" \
bash -lc "HOME='${TARGET_HOME}' USER='${TARGET_USER}' LOGNAME='${TARGET_USER}' \
XDG_DATA_HOME='${TARGET_HOME}/.local/share' XDG_CONFIG_HOME='${TARGET_HOME}/.config' \
'${CHEZMOI_BIN}' --version >/dev/null"

if [ -n "${REPOURL:-}" ]; then
  check "chezmoi doctor (read-only)" \
  bash -lc "HOME='${TARGET_HOME}' XDG_DATA_HOME='${TARGET_HOME}/.local/share' \
  XDG_CONFIG_HOME='${TARGET_HOME}/.config' \
  '${CHEZMOI_BIN}' doctor >/dev/null"
else
  echo "Skipping 'chezmoi doctor' (no repoUrl in scenario)."
fi

# assert it works for the target user too
# su - "$TARGET_USER" -c "chezmoi --version >/dev/null"

# If you want to test init/apply, you can set repoUrl in the scenario
# and then check for a known file created by that repo, e.g.:
# test -f "$TARGET_HOME/.test-chezmoi"

echo "All checks passed."
