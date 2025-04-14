#!/bin/bash

apt update

apt install -y yq

yq --version

runuser -u ubuntu renovate
