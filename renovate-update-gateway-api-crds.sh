#!/bin/bash

set -euo pipefail

[[ "${#}" == "3" ]] || {
    echo "Please give the update type, the old gateway-api version and the new gateway-api version as only arguments"
    exit 3
}

UPDATE_TYPE="$1"
GW_VERSION_OLD="$2"
GW_VERSION_NEW="$3"

CHART="gateway-api-crds"
CHART_DIR="charts/${CHART}"

echo "Old gateway-api version is ${GW_VERSION_OLD}"
echo "New gateway-api version is ${GW_VERSION_NEW}"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

# Download both channel bundles for the new release
for channel in standard experimental; do
  curl -sSfL -o "${WORKDIR}/${channel}-install.yaml" \
    "https://github.com/kubernetes-sigs/gateway-api/releases/download/${GW_VERSION_NEW}/${channel}-install.yaml"
done

# Split each channel bundle into one file per CRD (named by spec.names.plural)
for channel in standard experimental; do
  mkdir -p "${WORKDIR}/split/${channel}"
  yq -s "\"${WORKDIR}/split/${channel}/\" + (select(.kind == \"CustomResourceDefinition\") | .spec.names.plural)" \
    "${WORKDIR}/${channel}-install.yaml"
done

# Discover the union of CRD plural names across both channels. Never hardcode
# this list -- it must reflect whatever upstream ships in this release.
mapfile -t PLURALS < <(
  { ls "${WORKDIR}/split/standard" 2>/dev/null; ls "${WORKDIR}/split/experimental" 2>/dev/null; } \
    | sed 's/\.yml$//' | sort -u
)

# Renders one channel's CRD body: drops the yq document-separator line and
# injects the (conditional) resource-policy annotation include.
render_body() {
  local file="$1"
  sed '1{/^---$/d}' "${file}" \
    | awk '{ print } /^  annotations:$/ { print "{{- include \"gateway-api-crds.resourcePolicyAnnotation\" $ }}" }'
}

# Regenerate templates/crds/ from scratch every run -- this is what makes
# upstream additions/removals of CRD kinds safe to handle without diffing.
rm -rf "${CHART_DIR}/templates/crds"
mkdir -p "${CHART_DIR}/templates/crds"

for plural in "${PLURALS[@]}"; do
  STANDARD_FILE="${WORKDIR}/split/standard/${plural}.yml"
  EXPERIMENTAL_FILE="${WORKDIR}/split/experimental/${plural}.yml"
  OUT_FILE="${CHART_DIR}/templates/crds/${plural}.yaml"

  {
    echo "{{- if .Values.crds.${plural} }}"
    if [[ -f "${STANDARD_FILE}" && -f "${EXPERIMENTAL_FILE}" ]]; then
      # Present in both channels, but schemas can differ between them.
      echo "{{- if eq .Values.channel \"experimental\" }}"
      render_body "${EXPERIMENTAL_FILE}"
      echo "{{- else }}"
      render_body "${STANDARD_FILE}"
      echo "{{- end }}"
    elif [[ -f "${EXPERIMENTAL_FILE}" ]]; then
      # Experimental-channel-only kind.
      echo "{{- if eq .Values.channel \"experimental\" }}"
      render_body "${EXPERIMENTAL_FILE}"
      echo "{{- end }}"
    else
      render_body "${STANDARD_FILE}"
    fi
    echo "{{- end }}"
  } >"${OUT_FILE}"
done

# Insert two lines (a "-- description" helm-docs comment, then the key)
# right after an existing line in values.yaml. yq's headComment/footComment
# operators don't reliably place a comment *before* a freshly-appended map
# key (it ends up attached to whatever follows instead), so this is done as
# plain text insertion.
insert_after_line() {
  local pattern="$1" text="$2" file="$3"
  awk -v pat="${pattern}" -v txt="${text}" '{ print } $0 ~ pat { print txt }' "${file}" >"${file}.tmp"
  mv "${file}.tmp" "${file}"
}

# Add values.yaml crds.* keys for newly-introduced CRD kinds, with a
# helm-docs "-- description" comment so they show up in the generated README.
# Never remove a key for a kind that disappeared upstream -- that's a manual,
# changelog-noted step, since users may already have that key set in their
# own values. PLURALS is sorted, and so is the existing crds: block, so each
# new key is inserted right after the previous plural in iteration order.
PREV_PLURAL=""
for plural in "${PLURALS[@]}"; do
  if yq -e ".crds | has(\"${plural}\")" "${CHART_DIR}/values.yaml" >/dev/null 2>&1; then
    PREV_PLURAL="${plural}"
    continue
  fi

  STANDARD_FILE="${WORKDIR}/split/standard/${plural}.yml"
  EXPERIMENTAL_FILE="${WORKDIR}/split/experimental/${plural}.yml"
  if [[ -f "${STANDARD_FILE}" ]]; then
    KIND="$(yq '.spec.names.kind' "${STANDARD_FILE}")"
    NOTE=""
  else
    KIND="$(yq '.spec.names.kind' "${EXPERIMENTAL_FILE}")"
    NOTE=" Experimental channel only."
  fi
  echo "New CRD kind detected: ${plural} (${KIND}) -- adding to values.yaml (default true)"

  NEW_LINES="  # -- Installs the ${KIND} CRD.${NOTE}
  ${plural}: true"
  if [[ -z "${PREV_PLURAL}" ]]; then
    insert_after_line "^crds:" "${NEW_LINES}" "${CHART_DIR}/values.yaml"
  else
    insert_after_line "^  ${PREV_PLURAL}: " "${NEW_LINES}" "${CHART_DIR}/values.yaml"
  fi
  PREV_PLURAL="${plural}"
done

# Bump the chart version (semver, independent from the appVersion)
CHART_VERSION_OLD="$(awk '/^version:/ {print $2}' "${CHART_DIR}/Chart.yaml")"
CHART_VERSION_MAJOR="$(echo "${CHART_VERSION_OLD}" | cut -d. -f1)"
CHART_VERSION_MINOR="$(echo "${CHART_VERSION_OLD}" | cut -d. -f2)"
CHART_VERSION_PATCH="$(echo "${CHART_VERSION_OLD}" | cut -d. -f3)"

if [[ "${UPDATE_TYPE}" =~ (major|replacement) ]]; then
  CHART_VERSION_MAJOR="$(( CHART_VERSION_MAJOR + 1 ))"
  CHART_VERSION_MINOR=0
  CHART_VERSION_PATCH=0
elif [[ "${UPDATE_TYPE}" =~ 'minor' ]]; then
  CHART_VERSION_MINOR="$(( CHART_VERSION_MINOR + 1 ))"
  CHART_VERSION_PATCH=0
else
  CHART_VERSION_PATCH="$(( CHART_VERSION_PATCH + 1 ))"
fi

CHART_VERSION_NEW="${CHART_VERSION_MAJOR}.${CHART_VERSION_MINOR}.${CHART_VERSION_PATCH}"
echo "New chart version is ${CHART_VERSION_NEW}"

# change version/appVersion in Chart.yaml
sed -i "s/^version:.*/version: ${CHART_VERSION_NEW}/g" "${CHART_DIR}/Chart.yaml"
sed -i "s/^appVersion:.*/appVersion: \"${GW_VERSION_NEW}\"/g" "${CHART_DIR}/Chart.yaml"

# repoint the vendored source links at the new release tag
sed -i "s#/releases/download/${GW_VERSION_OLD}/#/releases/download/${GW_VERSION_NEW}/#g" "${CHART_DIR}/Chart.yaml"

# replace changes annotation for artifacthub in Chart.yaml
changes=$"- kind: changed\n  description: Gateway API CRDs to ${GW_VERSION_NEW}\n"
yq eval ".annotations.\"artifacthub.io/changes\" = \"${changes}\"" -i "${CHART_DIR}/Chart.yaml"

# update CHANGELOG.md
.github/generate-chart-changelogs.sh
