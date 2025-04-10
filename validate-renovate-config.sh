#!/bin/bash

docker run --rm -v "$(pwd):/usr/src/app" renovate/renovate renovate-config-validator --strict
