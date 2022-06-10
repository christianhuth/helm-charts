#!/bin/bash
set -euo pipefail

CHART_DIR=charts

for dir in "$CHART_DIR"/*; do
    if test ! -f "${dir}/Chart.yaml"; then
        echo "Skipping over ${dir}"
        continue
    fi

    CHART_NAME=$(basename "$dir")

    echo "Generating CHANGELOG.md for ${CHART_NAME}"

    cat "$dir/Chart.yaml" |
        yq e '.annotations["artifacthub.io/changes"]' - |                                                 # extract the changes annotation, which is a YAML array
        yq -o json e '.' - |                                                                              # convert the YAML array to a JSON array
        jq 'group_by(.kind) | to_entries | map({key: .value[0].kind, value: .value})' - |                 # group the JSON array by their 'kind' - ie. the type of change
        gomplate -d chart="$dir/Chart.yaml" -d changes=stdin:///in.json -f .github/CHANGELOG.md.gotmpl >"$dir/CHANGELOG.md" # use the JSON above as input to render the changelog

done
