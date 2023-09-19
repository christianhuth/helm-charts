## Development

### Development Environment Setup

1. (Optional) Install the [pre-commit](https://pre-commit.com/) hooks

   ```sh
   pip3 install pre-commit
   pre-commit install
   ```

1. (Optional) Setup a KinD cluster with Nginx ingress support

   ```sh
   kind create cluster --config=development/kind-with-ingress-support.yaml
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
   ```

### Development Process

1. Make changes to the charts

1. Bump the version in the changed `Chart.yaml` according to Semantic Versioning (The `ct lint` step will complain if you forget to update the version.)

1. Update the changes annotation in the `Chart.yaml`

1. Update the README.md (execute in the root folder of the chart you changed):

   ```sh
   docker run --rm -v $PWD/../..:/root/workspace ghcr.io/chgl/kube-powertools:latest generate-docs.sh
   ```

1. Update values.schema.json (requires a [Helm-Plugin](https://github.com/karuppiah7890/helm-schema-gen)):
   ```
   helm schema-gen values.yaml > values.schema.json
   ```

1. Commit your changes to the repository. The CI Pipeline will test your changes and package a new release.
