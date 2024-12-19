# Development

## Development Environment Setup

1. (Optional) Install the [pre-commit](https://pre-commit.com/) hooks

  ```console
  pip3 install pre-commit
  pre-commit install --install-hooks
  ```

1. (Optional) Setup a minikube cluster with Nginx ingress support

  ```console
  minikube start --addons=ingress --cpus=4 --memory=8g --profile=helm-charts-development
  minikube profile helm-charts-development
  ```

## Development Process

1. Make changes to the charts

1. Bump the version in the changed `Chart.yaml` according to Semantic Versioning (The `ct lint` step will complain if you forget to update the version.)

1. Update the changes annotation in the `Chart.yaml`

1. Update the README.md (execute in the root folder of the chart you changed):

   ```console
   docker run --rm -v $PWD/../..:/root/workspace ghcr.io/chgl/kube-powertools:latest helm-docs --chart-search-root=charts
   ```

1. Update values.schema.json (requires a [Helm-Plugin](https://github.com/karuppiah7890/helm-schema-gen)):

   ```console
   helm schema-gen values.yaml > values.schema.json
   ```

1. Commit your changes to the repository. The CI Pipeline will test your changes and package a new release.
