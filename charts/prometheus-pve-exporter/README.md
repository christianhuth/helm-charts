# prometheus-pve-exporter

## TL;DR;

```console
helm repo add christianknell https://charts.knell.it
helm install my-release christianknell/prometheus-pve-exporter
```

## Introduction

A Prometheus exporter for [Proxmox Virtual Environment](https://proxmox.com/en/proxmox-ve) metrics.

This chart bootstraps a [PVE Exporter](https://github.com/prometheus-pve/prometheus-pve-exporter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://charts.knell.it
helm install my-release christianknell/prometheus-pve-exporter
```

These commands deploy prometheus-pve-exporter on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Relabel Configuration

Add the following to your prometheus configuration:

```yaml
scrape_configs:
  - job_name: 'pve'
    static_configs:
      - targets:
        - 192.168.1.2  # Proxmox VE node.
        - 192.168.1.3  # Proxmox VE node.
    metrics_path: /pve
    params:
      module: [default]
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: prometheus-pve-exporter:9221  # PVE exporter service.
```

The following tables list the configurable parameters of the prometheus-pve-exporter chart and their default values.

FIXME

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/prometheus-pve-exporter
```