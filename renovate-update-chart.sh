#!/bin/bash

set -o pipefail

[[ "${#}" == "4" ]] || {
    echo "Please give the chart name, the update type, dependency name and the new version of the dependency as only arguments"
    exit 3
}

CHART="$1"
UPDATE_TYPE="$2"
DEP_NAME="$3"
DEP_VERSION_NEW="$4"

version="$(awk '/^version:/ {print $2}' "charts/${CHART}/Chart.yaml")"
echo "Old version is ${version}"
major="$(echo "${version}" | cut -d. -f1)"
minor="$(echo "${version}" | cut -d. -f2)"
patch="$(echo "${version}" | cut -d. -f3)"

if [[ "${UPDATE_TYPE}" =~ (major|replacement) ]]
then
  major="$(( major + 1 ))"
  minor=0
  patch=0
elif [[ "${UPDATE_TYPE}" =~ 'minor' ]]
then
  minor="$(( minor + 1 ))"
  patch=0
else
  # this means updates of type patch or pinDigest
  patch="$(( patch + 1 ))"
fi

newversion="${major}.${minor}.${patch}"
echo "New version is ${newversion}"

# change version in Chart.yaml
sed -i "s/^version:.*/version: ${newversion}/g" "charts/${CHART}/Chart.yaml"

# change version in CHANGELOG.md
sed -i "0,/^## [0-9]\+\(\.[0-9]\+\)*$/s/^## [0-9]\+\(\.[0-9]\+\)*$/## $newVersion/" "charts/${CHART}/CHANGELOG.md"
