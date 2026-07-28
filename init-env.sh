#!/usr/bin/env bash

############
# SETTINGS #
############
set -o errexit
set -o nounset
set -o pipefail

###########
# GLOBALS #
###########
readonly ENV_FILE="${ENV_FILE:-.env}"
readonly EXAMPLE_FILE="${EXAMPLE_FILE:-.env.example}"

#############
# FUNCTIONS #
#############
indent_error() {
    local error_message

    if ! error_message=$("$@" 2>&1); then
        printf "\n  %s\n" "$error_message" >&2
        exit 1
    fi
}

########
# MAIN #
########
printf "Ensuring non-existence of environment file... "
if [[ -f "$ENV_FILE" ]]; then
    printf "\n  ERROR: '%s' already exists.\n" "$ENV_FILE" >&2
    exit 1
fi
printf "Done!\n"

printf "\nEnsuring existence of example environment file... "
if [[ ! -f "$EXAMPLE_FILE" ]]; then
    printf "\n  ERROR: '%s' not found.\n" "$EXAMPLE_FILE" >&2
    exit 1
fi
printf "Done!\n"

printf "\nProceeding with secrets generation... "
indent_error cp "$EXAMPLE_FILE" "$ENV_FILE"
indent_error sed --in-place "s/^SEARXNG_SECRET=.*/SEARXNG_SECRET=$(openssl rand -hex 32)/" "$ENV_FILE"
printf "Done!\n"
