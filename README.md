# Kubernetes Helm Charts

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/christianknell)](https://artifacthub.io/packages/search?repo=christianknell)

These charts are provided as-is with no warranties.

## Usage

[Helm](https://helm.sh) must be installed to use the charts, please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```shell
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
```

You can then run `helm search repo christianknell` to see the charts.

## License

[MIT License](./LICENSE).

## List of available Charts

| Chart name                                                  | Image source                                                                                | Description                                                                                                                                                |
|-------------------------------------------------------------|---------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [baserow](./charts/baserow)                                 | [baserow/backend](https://hub.docker.com/r/baserow/backend), [baserow/web-frontend](https://hub.docker.com/r/baserow/web-frontend) | [Baserow is an open source no-code database and Airtable alternative.](https://baserow.io)                          |
| [etcd-defrag](./charts/etcd-defrag)                         | [bitnami/etcd](https://hub.docker.com/r/bitnami/etcd)                                       | [Runs a defragmentation CronJob for ETCD](https://etcd.io/docs/latest/op-guide/maintenance/#defragmentation)                                               |
| [headwind-mdm](./charts/headwind-mdm)                       | [headwindmdm/hmdm](https://hub.docker.com/r/headwindmdm/hmdm)                               | [Headwind MDM is an open source mobile device management software for Android](https://h-mdm.com)                                                          |
| [kubedoom](./charts/kubedoom)                               | [storax/kubedoom](https://ghcr.io/storax/kubedoom)                                          | [Kill pods inside your Kubernetes cluster by shooting them in Doom!](https://github.com/storax/kubedoom)                                                          |
| [kube-ops-view](./charts/kube-ops-view)                     | [hjacobs/kube-ops-view](https://hub.docker.com/r/hjacobs/kube-ops-view)                     | [Kubernetes Operational View is a read-only system dashboard for multiple K8s clusters](https://codeberg.org/hjacobs/kube-ops-view)                        |
| [kutt](./charts/kutt)                                       | [kutt/kutt](https://hub.docker.com/r/kutt/kutt)                                             | [Kutt is a free modern URL shortener](https://kutt.it)                                                                                                     |
| [netcupscp-exporter](./charts/netcupscp-exporter)           | [mrueg/netcupscp-exporter](https://ghcr.io/mrueg/netcupscp-exporter)                        | [Prometheus Exporter for Netcup Server Control Panel (SCP)](https://github.com/mrueg/netcupscp-exporter)                                                   |
| [node-access](./charts/node-access)                         | [busybox](https://hub.docker.com/_/busybox)                                                 | Deploy workload to gain direct access to the host of the Kubernetes cluster                                                                                |
| [passbolt-ha](./charts/passbolt-ha)                         | [see Chart.yaml](./charts/passbolt-ha/Chart.yaml)                                           | Passbolt with MySQL and ProxySQL for HA                                                                                                                    |
| [polr](./charts/polr)                                       | [ajanvier/polr](https://hub.docker.com/r/ajanvier/polr)                                     | [Polr is a quick, modern, and open-source link shortener](https://polrproject.org)                                                                         |
| [popeye](./charts/popeye)                                   | [derailed/popeye](https://hub.docker.com/r/derailed/popeye)                                 | [A Kubernetes Cluster Sanitizer](https://popeyecli.io)                                                                                                     |
| [priority-classes](./charts/priority-classes)               | none                                                                                        | A Helm chart for creating Priority Classes. Already comes with some bundled classes.                                                                       |
| [prometheus-pve-exporter](./charts/prometheus-pve-exporter) | [prompve/prometheus-pve-exporter](https://hub.docker.com/r/prompve/prometheus-pve-exporter) | [Prometheus Exporter for Proxmox VE](https://github.com/prometheus-pve/prometheus-pve-exporter)                                                            |
| [promlens](./charts/promlens)                               | [prom/promlens](https://hub.docker.com/r/prom/promlens)                                     | [PromLens is a tool that makes learning and using PromQL easier and more productive](https://promlens.com)                                                 |
| [proxysql](./charts/proxysql)                               | [proxysql/proxysql](https://hub.docker.com/r/proxysql/proxysql)                             | [ProxySQL is a high performance, high availability, protocol aware proxy for MySQL and forks (like Percona Server and MariaDB)](https://www.proxysql.com)  |
| [proxyweb](./charts/proxyweb)                               | [proxyweb/proxyweb](https://hub.docker.com/r/proxyweb/proxyweb)                             | [Open Source Web Interface for ProxySQL](https://github.com/edmodo/proxyweb)                                                                               |
| [shlink-backend](./charts/shlink-backend)                   | [shlinkio/shlink](https://hub.docker.com/r/shlinkio/shlink)                                 | [A self-hosted and PHP-based URL shortener application with CLI and REST interfaces](https://shlink.io)                                                    |
| [shlink-web](./charts/shlink-web)                           | [shlinkio/shlink-web-client](https://hub.docker.com/r/shlinkio/shlink-web-client)           | [A ReactJS-based progressive web application for Shlink.](https://app.shlink.io)                                                                           |
| [skooner](./charts/skooner)                                 | [skooner-k8s/skooner](https://ghcr.io/skooner-k8s/skooner)                                  | [Simple Kubernetes real-time dashboard and management](https://skooner.io)                                                                                 |
| [sloop](./charts/sloop)                                     | [salesforce/sloop](https://ghcr.io/salesforce/sloop)                                        | [Kubernetes History Visualization](https://github.com/salesforce/sloop)                                                                                    |
| [syncserver](./charts/syncserver)                           | [mozilla/syncserver](https://hub.docker.com/r/mozilla/syncserver)                           | [Firefox Sync Server](https://github.com/mozilla-services/syncserver)                                                                                      |
| [typo3](./charts/typo3)                                     | [martinhelmich/typo3](https://hub.docker.com/r/martinhelmich/typo3)                         | [TYPO3 is a Professional, Flexible Content Management System](https://typo3.org)                                                                           |
| [umami](./charts/umami)                                     | [umami-software/umami](https://ghcr.io/umami-software/umami)                                | [Umami is a simple, fast, privacy-focused alternative to Google Analytics.](https://umami.is)                                                              |
