#!/usr/bin/env sh
set -eu

# Detect distro
. /etc/os-release 2>/dev/null || true
ID_LIKE="${ID_LIKE:-$ID}"

case "$ID_LIKE" in
  *alpine*)
    apk add --no-cache openssh-client >/dev/null
    ;;
  *debian*|*ubuntu*)
    apt-get update -y >/dev/null
    apt-get install -y --no-install-recommends openssh-client >/dev/null
    rm -rf /var/lib/apt/lists/* ;;
  *fedora*|*rhel*|*centos*)
    dnf install -y openssh-clients >/dev/null ;;
  *)
    echo "[ssh-client] WARN: unknown distro '$ID' ('$ID_LIKE'). Trying generic names..."
    (apk add --no-cache openssh-client 2>/dev/null ||
     apt-get update -y && apt-get install -y --no-install-recommends openssh-client 2>/dev/null ||
     dnf install -y openssh-clients 2>/dev/null) || {
       echo "[ssh-client] ERROR: could not install ssh client."; exit 1; }
    ;;
esac

# Prepare ~/.ssh for the target user
USER_NAME="${_REMOTE_USER:-vscode}"
HOME_DIR="$(getent passwd "$USER_NAME" | cut -d: -f6 || echo "/home/$USER_NAME")"
install -d -m 700 "$HOME_DIR/.ssh"
chown -R "$USER_NAME:$USER_NAME" "$HOME_DIR/.ssh"

# Hint if agent socket not mounted
if [ ! -S "/ssh-agent" ] && [ "${SSH_AUTH_SOCK:-}" != "/ssh-agent" ]; then
  echo "[ssh-client] Note: mount your host ssh-agent and set SSH_AUTH_SOCK=/ssh-agent."
fi

echo "[ssh-client] openssh client installed. Try: ssh -T git@github.com"
