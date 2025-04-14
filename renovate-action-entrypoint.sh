#!/bin/bash

# Install yq
YQ_VERSION="v4.43.1"
wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -O /usr/local/bin/yq
chmod +x /usr/local/bin/yq
yq --version  # sanity check

runuser -u ubuntu renovate
