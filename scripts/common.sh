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
# Send a message as a commit status check to the CI commit.
#
# Side effects:
#    * Posts a new commit check at <context> with contents <desc> and status <status>
###
send_commit_status(){ local status="${1}" desc="${2}" context="${3}"
    print_func_banner "${FUNCNAME[0]}"
    local action_url="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}"

    case "${status}" in
        error|failure|pending|success)
            ;;
        *)
            echo "ERR - commit status must be one of [error|failure|pending|success]"
            exit 1
            ;;
    esac

    curl -sS -X POST \
        -H "${GH_HEADER}" \
        -H "Authorization: Bearer ${GH_TOK}" \
        "${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}/statuses/${GITHUB_SHA}" \
        -d '{"state":"'"${status}"'","target_url": "'"${action_url}"'", "description":"'"${desc}"'","context":"'"${BASE_CONTEXT}/${context}"'"}' &>/d
ev/null
}
