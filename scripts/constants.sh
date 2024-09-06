#!/usr/bin/env bash

set -euo pipefail

GH_API_VERS="X-GitHub-Api-Version:2022-11-28"
GH_ACCEPT_HEADER="Accept: application/vnd.github+json"

BASE_CI_CONTEXT="plox"

CODE_LINT_CHECK_DESC="Ensure all code files appropriately formatted."
CODE_LINT_CHECK="code-lint"
