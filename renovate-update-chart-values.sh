#!/bin/bash

set -o pipefail

[[ "${#}" == "4" ]] || {
    echo "Please give the chart name, the update type, the old version and the new version of the dependency as only arguments"
    exit 3
}

CHART="$1"
UPDATE_TYPE="$2"
DEP_VERSION_OLD="$3"
DEP_VERSION_NEW="$4"

echo "Old version is ${DEP_VERSION_OLD}"
major="$(echo "${DEP_VERSION_OLD}" | cut -d. -f1)"
minor="$(echo "${DEP_VERSION_OLD}" | cut -d. -f2)"
patch="$(echo "${DEP_VERSION_OLD}" | cut -d. -f3)"

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
  patch="$(( patch + 1))"
fi

NEW_VERSION="${major}.${minor}.${patch}"
echo "New version is ${NEW_VERSION}"

# change appVersion in Chart.yaml
sed -i "s/^appVersion:.*/appVersion: ${NEW_VERSION}/g" "charts/${CHART}/Chart.yaml"

# replace changes annotation for artifacthub in Chart.yaml
changes=$"- kind: changed\n  description: appVersion to ${DEP_VERSION_NEW}\n"
yq eval ".annotations.\"artifacthub.io/changes\" = \"${changes}\"" -i charts/${CHART}/Chart.yaml

# change image tag in values.yaml
sed -i "s/${DEP_VERSION_OLD}/${DEP_VERSION_NEW}/g" "charts/${CHART}/values.yaml"

# change image tag in values.schema.json
sed -i "s/${DEP_VERSION_OLD}/${DEP_VERSION_NEW}/g" "charts/${CHART}/values.schema.json"

# change image tag in README.md
sed -i "s/${DEP_VERSION_OLD}/${DEP_VERSION_NEW}/g" "charts/${CHART}/README.md"

# update CHANGELOG.md
.github/generate-chart-changelogs.sh
