#!/bin/bash
# Syncs the shared named templates in .github/templates/ into the charts found below the chart search root.
#
# The templates required by a chart are determined by its prerequisites in .github/config/prerequisites.yaml.
# Required templates are copied to charts/<chart>/templates/ and kept identical to the master,
# copies no longer required are removed.
#
# Usage: .github/scripts/sync-shared-templates.sh [--chart-search-root=<dir>]
#   --chart-search-root   a single chart or a directory containing charts (default: charts)
set -euo pipefail

TEMPLATES_DIR=".github/templates"

prerequisites=$(.github/scripts/chart-prerequisites.sh "$@")

while read -r line; do
    [[ -n "${line}" ]] || continue
    chart=$(yq -p=json -oy '.chart' <<< "${line}")
    required=$(yq -p=json -oy '.prerequisites[].template | select(. != null)' <<< "${line}")

    for template in ${required}; do
        master="${TEMPLATES_DIR}/${template}"
        copy="${chart}/templates/${template}"
        [[ -f "${master}" ]] || { echo "Template ${master} required by ${chart} does not exist" >&2; exit 1; }
        if ! cmp -s "${master}" "${copy}"; then
            echo "Syncing ${master} to ${copy}"
            cp "${master}" "${copy}"
        fi
    done

    for master in "${TEMPLATES_DIR}"/*.tpl; do
        template=$(basename "${master}")
        copy="${chart}/templates/${template}"
        if [[ -f "${copy}" ]] && ! grep -qxF "${template}" <<< "${required}"; then
            echo "Removing ${copy}, as it is no longer required"
            rm "${copy}"
        fi
    done
done <<< "${prerequisites}"
