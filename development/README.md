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

1. Mount the folder in the [kube-powertools](https://github.com/chgl/kube-powertools) container to easily run linters and checks

   ```sh
   docker run --rm -it -v $PWD:/usr/src/app ghcr.io/chgl/kube-powertools:latest
   ```

1. Run chart-testing and the `chart-powerlint.sh` script to lint the chart

   ```sh
   ct lint --config .github/ct/ct.yaml && chart-powerlint.sh
   ```

1. (Optional) View the results of the [polaris audit check](https://github.com/FairwindsOps/polaris) in your browser

   ```sh
   $ docker run --rm -it -p 9090:8080 -v $PWD:/usr/src/app ghcr.io/chgl/kube-powertools:latest
   bash-5.0: helm template charts/prometheus-pve-exporter/ | polaris dashboard --config .polaris.yaml --audit-path -
   ```

   You can now open your browser at <http://localhost:9090> and see the results and recommendations.

1. Run `generate-docs.sh` to auto-generate an updated README

   ```sh
   generate-docs.sh
   ```

1. Bump the version in the changed Chart.yaml according to SemVer (The `ct lint` step above will complain if you forget to update the version.)

1. Exit Docker-Container:
   ```
   exit
   ```

1. Update values.schema.json:
   ```
   helm schema-gen values.yaml > values.schema.json
   ```
