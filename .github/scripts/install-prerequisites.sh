#!/bin/bash
# Installs the prerequisites (e.g. operators) of the charts found below the chart search root
# into the current cluster, based on .github/config/prerequisites.yaml.
# Every release is installed once, in its latest version.
#
# Usage: .github/scripts/install-prerequisites.sh [--chart-search-root=<dir>]
#   --chart-search-root   a single chart or a directory containing charts (default: charts)
set -euo pipefail

prerequisites=$(.github/scripts/chart-prerequisites.sh "$@")

declare -A installed=()

while IFS=$'\t' read -r release chart repository namespace; do
    # prerequisites without releases (e.g. charts without operator) yield empty lines
    [[ -n "${release}" ]] || continue
    [[ -n "${installed[${release}]:-}" ]] && continue
    echo "Installing ${chart} from ${repository} as ${release} into namespace ${namespace}"
    helm upgrade --install "${release}" "${chart}" \
        --repo "${repository}" \
        --namespace "${namespace}" \
        --create-namespace \
        --wait \
        --timeout 10m
    installed[${release}]=1
done < <(yq -p=json -oy '.prerequisites[].releases[] | [.release, .chart, .repository, .namespace] | @tsv' <<< "${prerequisites}")

echo "Installed prerequisites: ${!installed[*]}"
