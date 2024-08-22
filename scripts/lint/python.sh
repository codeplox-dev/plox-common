#!/usr/bin/env bash

set -euo pipefail

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "${script_dir}/../common.sh"

###
# Check that a given src/test directory passes code linting checks.
###
lint(){ local src_dir="${1-src}" test_dir="${2-test}"
    local rc=0

    # Requires standard project layout; all must have symlinked common ruff
    # config to root repo's ruff.toml
    ruff check --config "${src_dir}/../ruff.toml" "${src_dir}" "${test_dir}" || rc=$?
    ruff format --config "${src_dir}/../ruff.toml" --check "${src_dir}" "${test_dir}" || rc=$?

    if [[ "${rc}" != "0" ]]; then
        print_err "Linting failed."
    fi

    exit $rc
}
