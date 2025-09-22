#!/usr/bin/env bash
set -e
# opcional: log bonitinho
echo "Scenario: Ubuntu"
exec "$(dirname "$0")/test.sh"