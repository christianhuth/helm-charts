#!/bin/bash
# Adds all Helm repositories configured for chart-testing, so that `helm dependency update`
# can resolve dependencies from https repositories outside of chart-testing as well.
#
# Usage: .github/scripts/add-helm-repos.sh
set -euo pipefail

yq '.["chart-repos"][]' .github/config/chart-testing.yaml | while IFS='=' read -r name url; do
    helm repo add "${name}" "${url}" --force-update
done
