#!/bin/bash

# Generic Variables
OS=linux
ARCH=amd64

# Install gomplate
GOMPLATE_VERSION="v4.3.1"
curl -o /usr/local/bin/gomplate -sSL https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_${OS}-${ARCH}
chmod 755 /usr/local/bin/gomplate
gomplate --help

# Install wget
apt update && apt install -y wget

# Install yq
YQ_VERSION="v4.43.1"
wget -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_${OS}_${ARCH}
chmod +x /usr/local/bin/yq
yq --version  # sanity check

runuser -u ubuntu renovate
