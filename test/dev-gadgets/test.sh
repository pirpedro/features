#!/usr/bin/env bash
set -euo pipefail
[ -f dev-container-features-test-lib ] && . dev-container-features-test-lib || true

TARGET_USER="${_REMOTE_USER:-vscode}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
SAFE_PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# 1) git/ssh presentes
check "git installed"  bash -lc "command -v git >/dev/null"
check "ssh installed"  bash -lc "command -v ssh >/dev/null"

# 2) rodar git com ambiente do usuário (sem su)
GIT_BIN="$(bash -lc 'command -v git')"
check "git runs in target env (no su)" \
bash -lc "HOME='${TARGET_HOME}' USER='${TARGET_USER}' LOGNAME='${TARGET_USER}' PATH='${SAFE_PATH}' '${GIT_BIN}' --version >/dev/null"

# 3) ~/.ssh preparado (700 e dono correto)
check "~/.ssh exists" test -d "${TARGET_HOME}/.ssh"
SSH_MODE="$(stat -c '%a' "${TARGET_HOME}/.ssh")"
check "~/.ssh mode is 700" test "$SSH_MODE" = "700"
SSH_UID="$(stat -c '%u' "${TARGET_HOME}/.ssh")"; SSH_GID="$(stat -c '%g' "${TARGET_HOME}/.ssh")"
EXP_UID="$(id -u "$TARGET_USER")";           EXP_GID="$(id -g "$TARGET_USER")"
check "~/.ssh owner ok" test "$SSH_UID" = "$EXP_UID" -a "$SSH_GID" = "$EXP_GID"

# 4) PATH seguro inclui /usr/local/bin (especial p/ Alpine)
check "safe PATH works" \
bash -lc "PATH='${SAFE_PATH}'; command -v git >/dev/null && command -v ssh >/dev/null"

# 5) (opcional) sem rede: exercitar um clone local 'file://'
#    cria um bare repo em /tmp e clona para um diretório do alvo (em /tmp também)
check "local file:// clone works (no network)" bash -lc "
  set -e
  PATH='${SAFE_PATH}'
  rm -rf /tmp/ggad_bare /tmp/ggad_work
  mkdir -p /tmp/ggad_work
  git init --bare /tmp/ggad_bare >/dev/null
  HOME='${TARGET_HOME}' USER='${TARGET_USER}' LOGNAME='${TARGET_USER}' \
    git -C /tmp clone --quiet file:///tmp/ggad_bare /tmp/ggad_work
  test -d /tmp/ggad_work/.git
"

# 6) (opcional) se sua feature definir algo global (ex.: safe.directory p/ /workspaces)
#    valide sem escrever no ~/.gitconfig (read-only check)
# check "safe.directory set" bash -lc "! git config --global --get-all safe.directory >/dev/null || true"

reportResults
