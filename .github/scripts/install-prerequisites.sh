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

values=$(mktemp)
trap 'rm -f "${values}"' EXIT

while read -r entry; do
    release=$(yq -p=json '.release' <<< "${entry}")
    [[ -n "${installed[${release}]:-}" ]] && continue
    chart=$(yq -p=json '.chart' <<< "${entry}")
    repository=$(yq -p=json '.repository' <<< "${entry}")
    namespace=$(yq -p=json '.namespace' <<< "${entry}")
    yq -p=json -oy '.values // {}' <<< "${entry}" > "${values}"
    # OCI registries are referenced by the chart URL, as helm does not support --repo for them
    if [[ "${repository}" == oci://* ]]; then
        source=("${repository%/}/${chart}")
    else
        source=("${chart}" --repo "${repository}")
    fi
    echo "Installing ${chart} from ${repository} as ${release} into namespace ${namespace}"
    helm upgrade --install "${release}" "${source[@]}" \
        --namespace "${namespace}" \
        --create-namespace \
        --values "${values}" \
        --wait \
        --timeout 10m
    installed[${release}]=1
done < <(yq -p=json -o=json -I=0 -N '.prerequisites[] | (.releases // [])[]' <<< "${prerequisites}")

echo "Installed prerequisites: ${!installed[*]}"
