#!/bin/bash

# Generic Variables
OS=linux
ARCH=amd64

# Install gomplate
GOMPLATE_VERSION="v4.3.0"
curl -o /usr/local/bin/gomplate -sSL https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_${OS}-${ARCH}
chmod 755 /usr/local/bin/gomplate

runuser -u ubuntu renovate
