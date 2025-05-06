#!/usr/bin/env bash

# shellcheck disable=all
set -euo pipefail

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "${script_dir}/../common.sh"


publish(){
    if [[ "${GITHUB_ACTIONS:-}" == "" || "$(is_default_branch)" == "y" ]]; then
        uv publish --index pypi -vv
        return
    else
        print_info "${BRANCH_NAME} != default (${DEFAULT_BRANCH}), not publishing"
    fi

    if [[ "$(is_label_present publish-test-build)" == "y" ]]; then
        uv publish --index testpypi -vv
    else
        print_info "Detected part of PR but did not detect 'publish-test-build' PR label"
        print_info "To publish a test version of this packge, add the 'publish-test-build' label"
        print_info "and re-run the publish check."
    fi
}
