#!/usr/bin/env bash

# shellcheck disable=all
set -euo pipefail

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "${script_dir}/../common.sh"


publish(){
    if [[ "${GITHUB_ACTIONS:-}" == "" || "$(is_part_of_active_pr)" == "n" ]]; then
        poetry publish ${PYPI_ALIAS} -vv
        return
    fi

    if [[ "$(is_label_present publish-test-build)" == "y" ]]; then
        poetry publish ${PYPI_ALIAS} -vv
    else
        echo "Detected part of PR but did not detect 'publish-test-build' PR label"
        echo "To publish a test version of this packge, add the 'publish-test-build' label"
        echo "and re-run the publish check."
    fi
}
