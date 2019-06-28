#!/usr/bin/env zsh

set -o errexit   # exit on fail
set -o pipefail  # catch errors in pipelines
set -o nounset   # exit on undeclared variable
# set -o xtrace    # trace execution

# Folders containing `.zshrc`
FOLDERS_WITH_ZSHRC=$(
    cd "${0:a:h}"
    find * \( -name .zshrc -o -name zshrc.zsh \) -type f -exec dirname {} \;
)

# A fuzzy finder available
if command -v fzy > /dev/null; then
    FUZZY_FINDER=fzy
elif command -v fzf > /dev/null; then
    FUZZY_FINDER=fzf
else
    echo 'No supported fuzzy finder found. Exiting!'
    exit 1
fi

# Folder to load, chosen by user
FOLDER=$(${FUZZY_FINDER} <<< ${FOLDERS_WITH_ZSHRC})

# Build an image
FOLDER_LOWERCASE="${(L)FOLDER}"
docker build \
    --build-arg FOLDER="${FOLDER}" \
    --build-arg TERM="${TERM}" \
    -t "zplg-configs/${FOLDER_LOWERCASE}" \
    "${0:a:h}"

# Run a container
docker run -ti --rm "zplg-configs/${FOLDER_LOWERCASE}" env TERM="${TERM}" zsh
