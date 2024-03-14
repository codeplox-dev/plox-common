#!/usr/bin/env bash

set -euo pipefail

GH_HEADER="X-GitHub-Api-Version: 2022-11-28"

BASE_CI_CONTEXT="plox"

CODE_LINT_CHECK_DESC="Ensure all code files appropriately formatted."
CODE_LINT_CHECK="code-lint"
