#!/bin/bash

apt update

apt install -y yq

runuser -u ubuntu renovate
