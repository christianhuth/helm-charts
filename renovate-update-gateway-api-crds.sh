#!/bin/bash

set -euo pipefail

[[ "${#}" == "3" ]] || {
    echo "Please give the update type, the old gateway-api version and the new gateway-api version as only arguments"
    exit 3
}

UPDATE_TYPE="$1"
GW_VERSION_OLD="$2"
GW_VERSION_NEW="$3"

CHART_DIR="charts/gateway-api-crds"
STANDARD_DIR="${CHART_DIR}/charts/standard"
EXPERIMENTAL_DIR="${CHART_DIR}/charts/experimental"

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

# Renders a CRD body: drops the yq document-separator line and injects the
# (conditional) resource-policy annotation include.
render_body() {
  local file="$1"
  sed '1{/^---$/d}' "${file}" \
    | awk '{ print } /^  annotations:$/ { print "{{- include \"gateway-api-crds.resourcePolicyAnnotation\" $ }}" }'
}

# Insert two lines (a "-- description" helm-docs comment, then the key)
# right after an existing line in a values.yaml. yq's headComment/footComment
# operators don't reliably place a comment *before* a freshly-appended map
# key (it ends up attached to whatever follows instead), so this is done as
# plain text insertion.
insert_after_line() {
  local pattern="$1" text="$2" file="$3"
  awk -v pat="${pattern}" -v txt="${text}" '{ print } $0 ~ pat { print txt }' "${file}" >"${file}.tmp"
  mv "${file}.tmp" "${file}"
}

# Regenerates one subchart's templates/crds/ from scratch (single body per
# kind, no channel conditional -- each subchart is exactly one channel now)
# and adds (never removes) values.yaml crds.* keys for newly-introduced
# kinds. Regenerating templates/crds/ from scratch every run is what makes
# upstream additions/removals of CRD kinds safe to handle without diffing.
regenerate_subchart() {
  local subchart_dir="$1" channel="$2"

  rm -rf "${subchart_dir}/templates/crds"
  mkdir -p "${subchart_dir}/templates/crds"

  mapfile -t plurals < <(ls "${WORKDIR}/split/${channel}" | sed 's/\.yml$//' | sort -u)

  for plural in "${plurals[@]}"; do
    { echo "{{- if .Values.crds.${plural} }}"
      render_body "${WORKDIR}/split/${channel}/${plural}.yml"
      echo "{{- end }}"
    } >"${subchart_dir}/templates/crds/${plural}.yaml"
  done

  local prev_plural=""
  for plural in "${plurals[@]}"; do
    if yq -e ".crds | has(\"${plural}\")" "${subchart_dir}/values.yaml" >/dev/null 2>&1; then
      prev_plural="${plural}"
      continue
    fi

    kind="$(yq '.spec.names.kind' "${WORKDIR}/split/${channel}/${plural}.yml")"
    echo "New CRD kind detected in ${channel}: ${plural} (${kind}) -- adding to values.yaml (default true)"

    new_lines="  # -- Installs the ${kind} CRD.
  ${plural}: true"
    if [[ -z "${prev_plural}" ]]; then
      insert_after_line "^crds:" "${new_lines}" "${subchart_dir}/values.yaml"
    else
      insert_after_line "^  ${prev_plural}: " "${new_lines}" "${subchart_dir}/values.yaml"
    fi
    prev_plural="${plural}"
  done
}

regenerate_subchart "${STANDARD_DIR}" standard
regenerate_subchart "${EXPERIMENTAL_DIR}" experimental

# Bump the chart version (semver, independent from the appVersion). Parent
# and both subcharts always move in lockstep -- the parent's
# dependencies[].version must stay compatible with each subchart's own
# Chart.yaml version, or Helm silently stops condition-gating that subchart
# instead of erroring.
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

for dir in "${CHART_DIR}" "${STANDARD_DIR}" "${EXPERIMENTAL_DIR}"; do
  sed -i "s/^version:.*/version: ${CHART_VERSION_NEW}/g" "${dir}/Chart.yaml"
  sed -i "s/^appVersion:.*/appVersion: \"${GW_VERSION_NEW}\"/g" "${dir}/Chart.yaml"
done

# keep the parent's dependency version pins in lockstep with the subcharts
yq -i "(.dependencies[] | select(.name == \"standard\" or .name == \"experimental\").version) = \"${CHART_VERSION_NEW}\"" \
  "${CHART_DIR}/Chart.yaml"

# repoint the parent's vendored source links at the new release tag
sed -i "s#/releases/download/${GW_VERSION_OLD}/#/releases/download/${GW_VERSION_NEW}/#g" "${CHART_DIR}/Chart.yaml"

# replace changes annotation for artifacthub in the parent Chart.yaml
changes=$"- kind: changed\n  description: Gateway API CRDs to ${GW_VERSION_NEW}\n"
yq eval ".annotations.\"artifacthub.io/changes\" = \"${changes}\"" -i "${CHART_DIR}/Chart.yaml"

# refresh Chart.lock / dependency state (no-op network-wise: both
# dependencies have no `repository:`, so this only verifies charts/<name>
# exists locally and re-locks -- see internal/resolver/resolver.go)
helm dependency update "${CHART_DIR}"

# update CHANGELOG.md
.github/generate-chart-changelogs.sh
