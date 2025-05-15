#!/bin/bash

# install pre-commit hooks
pre-commit install --install-hooks

# set up autocompletion
TEMP_COMPLETION_FOLDER="${HOME}/bash_completion.d"
COMPLETION_FOLDER="/etc/bash_completion.d"
mkdir -p ${TEMP_COMPLETION_FOLDER}
BINARIES=("ct" "minikube")
for binary in "${BINARIES[@]}"
do
    $binary completion bash > ${TEMP_COMPLETION_FOLDER}/$binary
    sudo mv ${TEMP_COMPLETION_FOLDER}/$binary ${COMPLETION_FOLDER}/$binary
    source ${COMPLETION_FOLDER}/$binary
done

# start minikube
minikube start --addons=ingress --cpus=4 --memory=8g --profile=helm-charts-development
minikube profile helm-charts-development

# configure git
git config --global user.email "christian@knell.it"
git config --global user.name "christianhuth"

echo 'eval $(ssh-agent -s) && ssh-add ~/.ssh/*.opk.openssh' >> ~/.bashrc
