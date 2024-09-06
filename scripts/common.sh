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

    print_info "'${GITHUB_ACTIONS}' || '${GITHUB_REF_NAME}' || '${GH_PR_NUMBER}'"
    if [[ "${GITHUB_ACTIONS:-}" == "" ]]; then
        exit 0
    fi

    if [[ "${GH_PR_NUMBER}" != "" ]]; then
        print_info 'Detected github ref_name as PR candidate, returning yes'
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

    print_info "Checking PR ${pr_number} for labels..."

    if [[ "$(gh api "repos/${GITHUB_REPOSITORY}/pulls/$GH_PR_NUMBER" --jq '.labels.[].name' | tr '\n' ' ')" == *"${label}"* ]]; then
        echo "y"
    else
        print_info "Did not detect ${label} on current PR"
        echo "n"
    fi
}
