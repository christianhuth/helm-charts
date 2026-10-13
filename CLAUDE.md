# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a collection of Kubernetes Helm charts maintained by christianhuth. Charts are published to https://charts.christianhuth.de and indexed on Artifact Hub.

## Development Commands

### Linting and Validation

```bash
# Run pre-commit hooks (includes helm-docs, helm-schema, markdownlint, changelog generation)
pre-commit run --all-files

# Lint a specific chart with chart-testing
ct lint --config .github/config/chart-testing.yaml --charts charts/<chart-name>

# Run helm lint on a chart
helm dependency update charts/<chart-name>
helm lint charts/<chart-name>

# Validate chart manifests against Kubernetes schemas
helm plugin install https://github.com/jtyr/kubeconform-helm  # if not installed
helm dependency update charts/<chart-name>
helm kubeconform --config .github/config/chart-kubeconform.yaml charts/<chart-name>
```

### Unit Testing

```bash
# Install helm-unittest plugin (if not installed)
helm plugin install https://github.com/helm-unittest/helm-unittest.git

# Run unit tests for a chart
helm dependency update charts/<chart-name>
helm unittest charts/<chart-name>
```

### Integration Testing

```bash
# Test chart installation in a kind cluster
ct install --config .github/config/chart-testing.yaml --charts charts/<chart-name>
```

### Local Development with Minikube

```bash
# Set up minikube cluster
minikube start --addons=ingress --cpus=4 --memory=8g --profile=helm-charts-development
minikube profile helm-charts-development

# Install a chart for testing (use values-dev.yaml if available)
helm dependency update charts/<chart-name>
helm install <release-name> charts/<chart-name> -f charts/<chart-name>/values-dev.yaml
```

## Chart Structure

Each chart in `charts/` follows this structure:
- `Chart.yaml` - Chart metadata, dependencies, and artifacthub.io annotations including change log
- `values.yaml` - Default configuration values
- `values.schema.json` - Auto-generated JSON schema (via helm-schema pre-commit hook)
- `README.md` - Auto-generated documentation (via helm-docs pre-commit hook)
- `README.md.gotmpl` - Template for README generation
- `templates/` - Kubernetes manifest templates
- `templates/_helpers.tpl` - Template helper functions
- `values-dev.yaml` - (optional) Values for local development/testing

## Making Changes to a Chart

1. Edit the chart files as needed
2. Bump the version in `Chart.yaml` following semver
3. Update the `artifacthub.io/changes` annotation in `Chart.yaml` with change entries:
   ```yaml
   artifacthub.io/changes: |
     - kind: added|changed|fixed|security|deprecated|removed
       description: Description of change
   ```
4. Run `pre-commit run --all-files` to regenerate README.md, values.schema.json, and CHANGELOG.md
5. Commit changes - CI pipeline will run linting, kubeconform validation, unit tests, and installation tests

## CI Pipeline

The chart pipeline (`.github/workflows/chart-pipeline.yml`) runs on changes to `charts/`:
1. **Preparation** - Detect changed charts
2. **Linting** - artifacthub lint, chart-testing lint, helm lint
3. **Kubeconform** - Validate rendered manifests against Kubernetes schemas
4. **Unit Testing** - Run helm-unittest tests
5. **Testing** - Install charts in kind cluster
6. **Releasing** - (main branch only) Package and release charts

## Key Dependencies

Databases are being migrated from Bitnami subcharts to operator-managed databases. The operator itself is never a dependency; charts depend on the upstream chart that only renders the custom resource, aliased to the database type:
- PostgreSQL: `cluster` from https://cloudnative-pg.github.io/charts (alias `postgresql`), operator: CloudNativePG
- MariaDB: `mariadb-cluster` from https://helm.mariadb.com/mariadb-operator (alias `mariadb`), operator: mariadb-operator

Pattern for charts using them (see `headwind-mdm` and `syncstorage-rs`):
- `templates/_postgresql.tpl` / `templates/_mariadb.tpl`: shared named templates (`christianhuth.<db>.*`) taking the subchart context. Never edit the copies, edit the masters in `.github/templates/`; `.github/scripts/sync-shared-templates.sh` (pre-commit hook) copies them into every chart requiring them and removes copies no longer required.
- `templates/_dependencies.tpl`: chart-specific interface (`<chart>.database.*`) that dispatches between the bundled database and `externalDatabase.*`. Deployments only use this interface.
- No inline passwords for bundled databases: the operator generates them or an existing Secret is referenced through the upstream values.
- `values.yaml` defaults to 3 instances; `ci/*-values.yaml` reduces them to 1.

Prerequisites of charts (operators, CRD charts) are registered in `.github/config/prerequisites.yaml`, either for charts with a given dependency or for all charts (`always: true`). Each entry lists the Helm releases to install and optionally the shared template a chart needs. Supporting a new upstream CR chart only requires a new entry there. The scripts in `.github/scripts/` take `--chart-search-root=<dir>` (a single chart or a directory of charts, default `charts`):
- `chart-prerequisites.sh`: prints the prerequisites applying to each chart (JSON lines)
- `install-prerequisites.sh`: installs them into the current cluster (used by CI before `ct install`)
- `sync-shared-templates.sh`: syncs the required shared templates into the charts

Chart repos used by CI are configured in `.github/config/chart-testing.yaml` (`chart-repos`) and added outside of chart-testing via `.github/scripts/add-helm-repos.sh`.
