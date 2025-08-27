# Kubernetes Helm Charts

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/christianhuth)](https://artifacthub.io/packages/search?repo=christianhuth)

These charts are provided as-is with no warranties.

## Usage

[Helm](https://helm.sh) must be installed to use the charts, please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```shell
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
```

You can then run `helm search repo christianhuth` to see the current list of available charts.

## License

[MIT License](./LICENSE)

## List of available Charts

| Chart name                                                    | Image source                                                                                                                           | Description                                                                                                                                                |
|---------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [argocd-metrics-server](./charts/argocd-metrics-server)       | [argoprojlabs/argocd-extension-metrics](https://quay.io/argoprojlabs/argocd-extension-metrics)                                         | [The ArgoCD Metrics Server connects to Prometheus and displays Metrics in the ArgoCD UI.](https://github.com/argoproj-labs/argocd-extension-metrics)       |
| [audiobookshelf](./charts/audiobookshelf)                     | [advplyr/audiobookshelf](https://hub.docker.com/r/advplyr/audiobookshelf)                                                              | [Self-hosted audiobook and podcast server.](https://www.audiobookshelf.org/)                                                                               |
| [baserow](./charts/baserow)                                   | [baserow/backend](https://hub.docker.com/r/baserow/backend), [baserow/web-frontend](https://hub.docker.com/r/baserow/web-frontend)     | [Baserow is an open source no-code database and Airtable alternative.](https://baserow.io)                                                                 |
| [cluster-api-visualizer](./charts/cluster-api-visualizer)     | [jont828/cluster-api-visualizer](https://ghcr.io/jont828/cluster-api-visualizer)                                                       | [Multicluster resource visualization tool for Cluster API.](https://github.com/Jont828/cluster-api-visualizer)                                             |
| [countly](./charts/countly)                                   | [countly/api](https://hub.docker.com/r/countly/api), [countly/frontend](https://hub.docker.com/r/countly/frontend)                     | [Countly is a product analytics platform.](https://countly.com)                                                                                            |
| [dns-exporter](./charts/dns-exporter)                         | [tykling/dns_exporter](https://hub.docker.com/r/tykling/dns_exporter)                                                                  | [A multi-target Prometheus exporter with an exclusive focus on DNS monitoring.](https://github.com/tykling/dns_exporter)                                   |
| [dnsbl-exporter](./charts/dnsbl-exporter)                     | [luzilla/dnsbl_exporter](https://ghcr.io/luzilla/dnsbl_exporter)                                                                       | [Prometheus compatible exporter to query DNSBLs/RBLs.](https://github.com/Luzilla/dnsbl_exporter)                                                          |
| [etcd-defrag](./charts/etcd-defrag)                           | [coreos/etcd](https://quay.io/repository/coreos/etcd)                                                                                  | [Runs a defragmentation CronJob for ETCD](https://etcd.io/docs/latest/op-guide/maintenance/#defragmentation)                                               |
| [freshrss](./charts/freshrss)                                 | [freshrss/freshrss](https://hub.docker.com/r/freshrss/freshrss)                                                                        | [FreshRSS is a self-hosted RSS feed aggregator.](https://freshrss.org/)                                                                                    |
| [github-exporter](./charts/github-exporter)                   | [githubexporter/github-exporter](https://hub.docker.com/r/githubexporter/github-exporter)                                              | [Prometheus Exporter for generating GitHub Metrics](https://github.com/githubexporter/github-exporter)                                                     |
| [goldpinger](./charts/goldpinger)                             | [bloomberg/goldpinger](https://hub.docker.com/r/bloomberg/goldpinger)                                                                  | [Debugging tool for Kubernetes which tests and displays connectivity between nodes in the cluster. ](https://github.com/bloomberg/goldpinger)              |
| [headwind-mdm](./charts/headwind-mdm)                         | [headwindmdm/hmdm](https://hub.docker.com/r/headwindmdm/hmdm)                                                                          | [Headwind MDM is an open source mobile device management software for Android](https://h-mdm.com)                                                          |
| [kube-ops-view](./charts/kube-ops-view)                       | [hjacobs/kube-ops-view](https://hub.docker.com/r/hjacobs/kube-ops-view)                                                                | [Kubernetes Operational View is a read-only system dashboard for multiple K8s clusters](https://codeberg.org/hjacobs/kube-ops-view)                        |
| [kubedoom](./charts/kubedoom)                                 | [storax/kubedoom](https://ghcr.io/storax/kubedoom)                                                                                     | [Kill pods inside your Kubernetes cluster by shooting them in Doom!](https://github.com/storax/kubedoom)                                                   |
| [kubenav](./charts/kubenav)                                   | none                                                                                                                                   | [Bootstraps RBAC rules for kubenav](https://github.com/kubenav/kubenav)                                                                                    |
| [kubevirt-manager](./charts/kubevirt-manager)                 | [kubevirtmanager/kubevirt-manager](https://hub.docker.com/r/kubevirtmanager/kubevirt-manager)                                          | [KubeVirt Web UI to manage the lifecycle of Virtual Machines and more](https://kubevirt-manager.io)                                                        |
| [kutt](./charts/kutt)                                         | [kutt/kutt](https://hub.docker.com/r/kutt/kutt)                                                                                        | [Kutt is a free modern URL shortener](https://kutt.it)                                                                                                     |
| [mailcow-exporter](./charts/mailcow-exporter)                 | [mailcow/prometheus-exporter](https://ghcr.io/mailcow/prometheus-exporter)                                                             | [Prometheus exporter for information about a mailcow instance](https://github.com/mailcow/prometheus-exporter)                                             |
| [maildev](./charts/maildev)                                   | [maildev/maildev](https://hub.docker.com/r/maildev/maildev)                                                                            | [SMTP server & web interface for viewing and testing emails during development.](https://maildev.github.io/maildev/)                                       |
| [netcupscp-exporter](./charts/netcupscp-exporter)             | [mrueg/netcupscp-exporter](https://ghcr.io/mrueg/netcupscp-exporter)                                                                   | [Prometheus Exporter for Netcup Server Control Panel (SCP)](https://github.com/mrueg/netcupscp-exporter)                                                   |
| [nextcloud-exporter](./charts/nextcloud-exporter)             | [xperimental/nextcloud-exporter](https://docker.io/xperimental/prometheus-exporter)                                                    | [Prometheus exporter for Nextcloud servers](https://github.com/xperimental/nextcloud-exporter)                                                             |
| [node-access](./charts/node-access)                           | [busybox](https://hub.docker.com/_/busybox)                                                                                            | Deploy workload to gain direct access to the host of the Kubernetes cluster                                                                                |
| [passbolt-ha](./charts/passbolt-ha)                           | [see Chart.yaml](./charts/passbolt-ha/Chart.yaml)                                                                                      | Passbolt with MySQL and ProxySQL for HA                                                                                                                    |
| [polr](./charts/polr)                                         | [ajanvier/polr](https://hub.docker.com/r/ajanvier/polr)                                                                                | [Polr is a quick, modern, and open-source link shortener](https://polrproject.org)                                                                         |
| [popeye](./charts/popeye)                                     | [derailed/popeye](https://hub.docker.com/r/derailed/popeye)                                                                            | [A Kubernetes Cluster Sanitizer](https://popeyecli.io)                                                                                                     |
| [priority-classes](./charts/priority-classes)                 | none                                                                                                                                   | A Helm chart for creating Priority Classes. Already comes with some bundled classes.                                                                       |
| [prometheus-pve-exporter](./charts/prometheus-pve-exporter)   | [prompve/prometheus-pve-exporter](https://hub.docker.com/r/prompve/prometheus-pve-exporter)                                            | [Prometheus Exporter for Proxmox VE](https://github.com/prometheus-pve/prometheus-pve-exporter)                                                            |
| [promlens](./charts/promlens)                                 | [prom/promlens](https://hub.docker.com/r/prom/promlens)                                                                                | [PromLens is a tool that makes learning and using PromQL easier and more productive](https://promlens.com)                                                 |
| [proxysql](./charts/proxysql)                                 | [proxysql/proxysql](https://hub.docker.com/r/proxysql/proxysql)                                                                        | [ProxySQL is a high performance, high availability, protocol aware proxy for MySQL and forks (like Percona Server and MariaDB)](https://www.proxysql.com)  |
| [shlink-backend](./charts/shlink-backend)                     | [shlinkio/shlink](https://hub.docker.com/r/shlinkio/shlink)                                                                            | [A self-hosted and PHP-based URL shortener application with CLI and REST interfaces](https://shlink.io)                                                    |
| [shlink-web](./charts/shlink-web)                             | [shlinkio/shlink-web-client](https://hub.docker.com/r/shlinkio/shlink-web-client)                                                      | [A ReactJS-based progressive web application for Shlink.](https://app.shlink.io)                                                                           |
| [skooner](./charts/skooner)                                   | [skooner-k8s/skooner](https://ghcr.io/skooner-k8s/skooner)                                                                             | [Simple Kubernetes real-time dashboard and management](https://skooner.io)                                                                                 |
| [sloop](./charts/sloop)                                       | [salesforce/sloop](https://ghcr.io/salesforce/sloop)                                                                                   | [Kubernetes History Visualization](https://github.com/salesforce/sloop)                                                                                    |
| [squest](./charts/squest)                                     | [hewlettpackardenterprise/squest](quay.io/hewlettpackardenterprise/squest)                                                             | [Service request portal on top of Ansible Tower/AWX](https://github.com/HewlettPackard/squest)                                                             |
| [syncserver](./charts/syncserver)                             | [mozilla/syncserver](https://hub.docker.com/r/mozilla/syncserver)                                                                      | [Firefox Sync Server](https://github.com/mozilla-services/syncserver)                                                                                      |
| [syncstorage-rs](./charts/syncstorage-rs)                     | [porelli/firefox-sync](https://github.com/porelli/firefox-sync/pkgs/container/firefox-sync)                                            | [Mozilla Sync Storage](https://github.com/mozilla-services/syncstorage-rs)                                                                                 |
| [tenant-namespace](./charts/tenant-namespace)                 | none                                                                                                                                   | Bootstraps a Namespace in a Multi-Tenancy setup                                                                                                            |
| [typo3](./charts/typo3)                                       | [martinhelmich/typo3](https://hub.docker.com/r/martinhelmich/typo3)                                                                    | [TYPO3 is a Professional, Flexible Content Management System](https://typo3.org)                                                                           |
| [umami](./charts/umami)                                       | [umami-software/umami](https://ghcr.io/umami-software/umami)                                                                           | [Umami is a simple, fast, privacy-focused alternative to Google Analytics.](https://umami.is)                                                              |

## Development

### Using a Dev Container

The easiest way to contribute is using the provided Dev Container.

### Using your local environment

#### Creating the necessary prerequisites

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

#### Development Process

1. Make changes to the desired Chart

1. Bump the version in the changed `Chart.yaml` according to Semantic Versioning

1. Update the changes annotation in the `Chart.yaml`

1. Commit your changes to the repository. The CI Pipeline will test your changes. Create a Merge Request.
