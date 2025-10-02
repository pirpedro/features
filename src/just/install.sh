#!/usr/bin/env sh
set -eu

TARGET_USER="${_REMOTE_USER:-}"

if [ -z "$TARGET_USER" ] || [ "$TARGET_USER" = "root" ]; then
  echo "ERROR: No non-root target user detected (_REMOTE_USER=[$_REMOTE_USER])."
  echo "       Add common-utils (installZsh=true) BEFORE this feature, or pass a username env to the build."
  exit 1
fi

if ! id -u "$TARGET_USER" >/dev/null 2>&1; then
  echo "ERROR: The specified remote user '$TARGET_USER' does not exist. Ensure common-utils ran first or set _REMOTE_USER. Aborting antidote installation."
  exit 1
fi

TARGET_HOME=$(eval echo "~$TARGET_USER")


# Options passed by the Feature
JUSTFILE="${JUSTFILE:-false}"
DESTINATION="${DESTINATION:-$TARGET_HOME/.local/bin}"

mkdir -p "$DESTINATION"

su - "$TARGET_USER" -c "curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to $DESTINATION"

if [ "$JUSTFILE" = "true" ]; then
  if [ ! -f "$TARGET_HOME/.config/just/Justfile" ]; then
    mkdir -p "$TARGET_HOME/.config/just"
    curl -o "$TARGET_HOME/.config/just/Justfile" -sSLf "https://raw.githubusercontent.com/pirpedro/dev-gadgets/master/templates/base/Justfile"
    echo "[just] justfile copied to $TARGET_HOME/.config/just/Justfile"
  else
    echo "[just] justfile option is true but exists a justfile in ~/.config/just/"
  fi
fi