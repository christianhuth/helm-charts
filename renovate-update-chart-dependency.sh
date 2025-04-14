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

newVersion="${major}.${minor}.${patch}"
echo "New version is ${newVersion}"

# change version in Chart.yaml
sed -i "s/^version:.*/version: ${newVersion}/g" "charts/${CHART}/Chart.yaml"

# replace changes annotation for artifacthub in Chart.yaml
changes=$"- kind: changed\n  description: dependency of ${DEP_NAME} to ${DEP_VERSION_NEW}\n"
yq eval ".annotations.\"artifacthub.io/changes\" = \"${changes}\"" -i charts/${CHART}/Chart.yaml

# update CHANGELOG.md
cat >> charts/${CHART}/CHANGELOG.md <<EOL

# ${CHART}

## ${NEW_VERSION}

### Changed

- dependency to ${DEP_NAME} to ${DEP_VERSION_NEW}

EOL
