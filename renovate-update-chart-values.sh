#!/bin/bash

set -o pipefail

[[ "${#}" == "4" ]] || {
    echo "Please give the chart name, the update type, the old version and the new version of the Image as only arguments"
    exit 3
}

CHART="$1"
UPDATE_TYPE="$2"
IMAGE_VERSION_OLD="$3"
IMAGE_VERSION_NEW="$4"

CHART_VERSION_OLD="$(awk '/^version:/ {print $2}' "charts/${CHART}/Chart.yaml")"
echo "Old versions are:"
echo "Chart: ${CHART_VERSION_OLD}"
echo "Image: ${IMAGE_VERSION_OLD}"

CHART_VERSION_MAJOR="$(echo "${CHART_VERSION_OLD}" | cut -d. -f1)"
CHART_VERSION_MINOR="$(echo "${CHART_VERSION_OLD}" | cut -d. -f2)"
CHART_VERSION_PATCH="$(echo "${CHART_VERSION_OLD}" | cut -d. -f3)"

IMAGE_VERSION_MAJOR="$(echo "${IMAGE_VERSION_OLD}" | cut -d. -f1)"
IMAGE_VERSION_MINOR="$(echo "${IMAGE_VERSION_OLD}" | cut -d. -f2)"
IMAGE_VERSION_PATCH="$(echo "${IMAGE_VERSION_OLD}" | cut -d. -f3)"

if [[ "${UPDATE_TYPE}" =~ (major|replacement) ]]
then
  CHART_VERSION_MAJOR="$(( CHART_VERSION_MAJOR + 1 ))"
  CHART_VERSION_MINOR=0
  CHART_VERSION_PATCH=0
  IMAGE_VERSION_MAJOR="$(( IMAGE_VERSION_MAJOR + 1 ))"
  IMAGE_VERSION_MINOR=0
  IMAGE_VERSION_PATCH=0
elif [[ "${UPDATE_TYPE}" =~ 'minor' ]]
then
  CHART_VERSION_MINOR="$(( CHART_VERSION_MINOR + 1 ))"
  CHART_VERSION_PATCH=0
  IMAGE_VERSION_MINOR="$(( IMAGE_VERSION_MINOR + 1 ))"
  IMAGE_VERSION_PATCH=0
else
  CHART_VERSION_PATCH="$(( CHART_VERSION_PATCH + 1))"
  IMAGE_VERSION_PATCH="$(( IMAGE_VERSION_PATCH + 1))"
fi

CHART_VERSION_NEW="${CHART_VERSION_MAJOR}.${CHART_VERSION_MINOR}.${CHART_VERSION_PATCH}"
IMAGE_VERSION_NEW="${IMAGE_VERSION_MAJOR}.${IMAGE_VERSION_MINOR}.${IMAGE_VERSION_PATCH}"
echo "New versions are:"
echo "Chart: ${CHART_VERSION_NEW}"
echo "Image: ${IMAGE_VERSION_NEW}"

# change version in Chart.yaml
sed -i "s/^version:.*/version: ${CHART_VERSION_NEW}/g" "charts/${CHART}/Chart.yaml"

# change appVersion in Chart.yaml
sed -i "s/^appVersion:.*/appVersion: \"${IMAGE_VERSION_NEW}\"/g" "charts/${CHART}/Chart.yaml"

# replace changes annotation for artifacthub in Chart.yaml
changes=$"- kind: changed\n  description: appVersion to ${IMAGE_VERSION_NEW}\n"
yq eval ".annotations.\"artifacthub.io/changes\" = \"${changes}\"" -i charts/${CHART}/Chart.yaml

# change image tag in values.yaml
sed -i "s/${IMAGE_VERSION_OLD}/${IMAGE_VERSION_NEW}/g" "charts/${CHART}/values.yaml"

# change image tag in values.schema.json
sed -i "s/${IMAGE_VERSION_OLD}/${IMAGE_VERSION_NEW}/g" "charts/${CHART}/values.schema.json"

# change image tag in README.md
sed -i "s/${IMAGE_VERSION_OLD}/${IMAGE_VERSION_NEW}/g" "charts/${CHART}/README.md"

# update CHANGELOG.md
.github/generate-chart-changelogs.sh
