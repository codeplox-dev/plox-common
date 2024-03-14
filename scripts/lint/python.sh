#!/usr/bin/env bash

set -euo pipefail

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "${script_dir}/../common.sh"

###
# Check that a given src/test directory passes code linting checks.
#
# Side effects:
#    * Sends commit status check at CODE_LINT_CHECK with results.
###
lint(){ local src_dir="${1-src}" test_dir="${2-test}"
    local rc=0

    # Requires standard project layout; all must have symlinked common ruff
    # config to root repo's ruff.toml
        ruff check --config "${src_dir}/../ruff.toml" "${src_dir}" "${test_dir}" || rc=$?
        ruff format --config "${src_dir}/../ruff.toml" --check "${src_dir}" "${test_dir}" || rc=$?

    if [[ "${CI-}" != "true" ]]; then
        exit $rc
    fi

    if [[ "${rc}" == "0" ]]; then
        send_commit_status "success" "${CODE_LINT_CHECK_DESC}" "${CODE_LINT_CHECK}"
    else
        send_commit_status "failure" "FAIL: Ensure 'ruff check src test' returns successful." "${CODE_LINT_CHECK_DESC}" "${CODE_LINT_CHECK}"
    fi

    if [[ "${rc}" != "0" ]]; then
        print_err "Linting failed."
        exit 1
    fi
}
