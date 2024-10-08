# priority-classes

A Helm chart for creating Priority Classes. Already comes with some bundled classes.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/priority-classes
```

## Introduction

This chart installs [Priority Classes](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/priority-classes
```

These commands deploy the bundled Priority Classes on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key              | Type   | Default                          | Description                                            |
| ---------------- | ------ | -------------------------------- | ------------------------------------------------------ |
| fullnameOverride | string | `""`                             | String to fully override `"priority-classes.fullname"` |
| nameOverride     | string | `""`                             | Provide a name in place of `priority-classes`          |
| priorityClasses  | list   | see [values.yaml](./values.yaml) | List of Priority Classes to be created                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/priority-classes
```
