#!/usr/bin/env bash
set -e
# opcional: log bonitinho
echo "Scenario: Alpine"
exec "$(dirname "$0")/test.sh"