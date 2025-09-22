#!/usr/bin/env bash
set -e
# opcional: log bonitinho
echo "Scenario: Debian"
exec "$(dirname "$0")/test.sh"