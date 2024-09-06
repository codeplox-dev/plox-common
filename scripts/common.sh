#!/usr/bin/env bash

set -euo pipefail

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "${script_dir}/constants.sh"


###
# Print a message with an info prefix to stderr.
###
print_info(){
    printf "+++ INFO +++ %s\n" "$*" >&2;
}

###
# Print a message with an error prefix to stderr.
###
print_err(){
    printf "+++ ERROR +++ %s\n" "$*" >&2;
}

###
# Print a banner message to stderr.
###
print_func_banner(){ local funcname="${1}"
    printf "============================ Inside: %s ============================\n" "${funcname}" >&2;
}

###
# Check whether the current commit/branch is part of a pull request.
###
is_part_of_active_pr(){
    print_func_banner "${FUNCNAME[0]}"

    if [[ "${GITHUB_ACTIONS:-}" == "" ]]; then
        exit 0
    fi

    if [[ "${GITHUB_REF_NAME}" == *"/merge"* ]]; then
        echo "y"
    else
        echo "n"
    fi
}


is_label_present(){ local label="${1}"
    local pr_number

    if [[ "$(is_part_of_active_pr)" == "n" ]]; then
        echo "n"
        return
    fi

    pr_number=$(cut -d/ -f1 <<< "${GITHUB_REF_NAME}")

    if [[ "$(gh api "repos/${GITHUB_REPOSITORY}/pulls/$pr_number" --jq '.labels.[].name' | tr '\n' ' ')" == *"${label}"* ]]; then
        echo "y"
    else
        echo "n"
    fi
}
