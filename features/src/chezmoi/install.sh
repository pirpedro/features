#!/usr/bin/env sh
set -eu
# ---------- Helpers ----------
log() { printf '%s\n' "[chezmoi] $*"; }
fatal() { printf '%s\n' "[chezmoi] ERROR: $*" >&2; exit 1; }

# Options passed by the Feature
REPO_URL="${REPOURL:-}"
BRANCH="${BRANCH:-}"
APPLY="${APPLY:-true}"
USE_LOGIN="${USELOGINSHELL:-true}"

# Resolve target user/home (provided by common-utils)
TARGET_USER="${_REMOTE_USER:-}"
[ -n "$TARGET_USER" ] && [ "$TARGET_USER" != "root" ] || \
  fatal "No non-root target user detected (_REMOTE_USER='$TARGET_USER'). Add common-utils before this feature."

TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6 || true)"
[ -n "$TARGET_HOME" ] || fatal "Could not resolve home for '$TARGET_USER'."

# Require git (from the official git feature). No fallback install by design.
GIT_BIN="$(command -v git || true)"
[ -n "$GIT_BIN" ] || fatal "git not found. Ensure ghcr.io/devcontainers/features/git is included before this feature."

# ---------- Install chezmoi binary ----------
# Use official installer to place chezmoi in /usr/local/bin
# Ref: https://www.chezmoi.io/install/
log "Installing chezmoi binary via official installer..."
# shellcheck disable=SC2016
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin >/dev/null

CHEZMOI_BIN="$(command -v chezmoi || true)"
[ -n "$CHEZMOI_BIN" ] || fatal "chezmoi install failed (binary not found)."

log "Installed: $($CHEZMOI_BIN --version 2>/dev/null || echo unknown)"

# ---------- Optional: init/apply from repo ----------
if [ -n "$REPO_URL" ]; then
  log "Preparing chezmoi init for user '$TARGET_USER' from repo: $REPO_URL"

  # Build init command (use absolute binaries to avoid PATH issues in login shells)
  INIT_CMD="$CHEZMOI_BIN init"
  [ -n "$BRANCH" ] && INIT_CMD="$INIT_CMD --branch '$BRANCH'"
  [ "$APPLY" = "true" ] && INIT_CMD="$INIT_CMD --apply"
  INIT_CMD="$INIT_CMD '$REPO_URL'"

  # For Alpine and some bases, the login shell PATH may miss /usr/local/bin.
  # Provide an explicit PATH that includes the chezmoi/git locations.
  SAFE_PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

  if [ "$USE_LOGIN" = "true" ]; then
    log "Running init/apply in a login shell (PATH sanitized) ..."
    su - "$TARGET_USER" -c "export PATH='$SAFE_PATH'; '$GIT_BIN' --version >/dev/null 2>&1 || exit 1; $INIT_CMD"
  else
    log "Running init/apply in a non-login shell ..."
    su "$TARGET_USER" -c "export PATH='$SAFE_PATH'; '$GIT_BIN' --version >/dev/null 2>&1 || exit 1; $INIT_CMD"
  fi

  log "chezmoi init/apply completed for '$TARGET_USER'."
else
  log "No repoUrl provided. Skipping chezmoi init."
fi

# Final info
log "Done."
