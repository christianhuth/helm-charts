#!/bin/bash

# install pre-commit hooks
pre-commit install --install-hooks

# set up autocompletion
TEMP_COMPLETION_FOLDER="${HOME}/bash_completion.d"
COMPLETION_FOLDER="/etc/bash_completion.d"
mkdir -p ${TEMP_COMPLETION_FOLDER}
BINARIES=("ct")
for binary in "${BINARIES[@]}"
do
    $binary completion bash > ${TEMP_COMPLETION_FOLDER}/$binary
    sudo mv ${TEMP_COMPLETION_FOLDER}/$binary ${COMPLETION_FOLDER}/$binary
done
