#!/bin/bash
# Prints the prerequisites from .github/config/prerequisites.yaml applying to each chart found below
# the chart search root. Charts nested in other charts (local subcharts) are skipped.
#
# Output: one JSON object per chart and line, e.g.
#   {"chart":"charts/headwind-mdm","prerequisites":[{"name":"cloudnative-pg",...}]}
#
# Usage: .github/scripts/chart-prerequisites.sh [--chart-search-root=<dir>]
#   --chart-search-root   a single chart or a directory containing charts (default: charts)
set -euo pipefail

REGISTRY=".github/config/prerequisites.yaml"
CHART_SEARCH_ROOT="charts"

while [[ "${#}" -gt 0 ]]; do
    case "$1" in
        --chart-search-root=*) CHART_SEARCH_ROOT="${1#*=}" ;;
        --chart-search-root) CHART_SEARCH_ROOT="$2"; shift ;;
        *) echo "Unknown argument: $1" >&2; exit 3 ;;
    esac
    shift
done

[[ -d "${CHART_SEARCH_ROOT}" ]] || { echo "Chart search root ${CHART_SEARCH_ROOT} does not exist" >&2; exit 3; }

# find all charts below the search root, skipping charts nested in other charts
charts=()
while read -r chart; do
    for parent in "${charts[@]}"; do
        [[ "${chart}" == "${parent}"/* ]] && continue 2
    done
    charts+=("${chart}")
done < <(find "${CHART_SEARCH_ROOT%/}" -name Chart.yaml -printf '%h\n' | sort)

for chart in "${charts[@]}"; do
    # shellcheck disable=SC2016 # the expression is evaluated by yq, not by the shell
    CHART="${chart}" REGISTRY="${REGISTRY}" yq -o=json -I=0 '
        (.dependencies // []) as $deps
        | {"chart": strenv(CHART), "prerequisites": [load(strenv(REGISTRY)).prerequisites[]
            | select(.always == true or (.dependency as $d | $deps | any_c(.name == $d.name and .repository == $d.repository)))]}
    ' "${chart}/Chart.yaml"
done
