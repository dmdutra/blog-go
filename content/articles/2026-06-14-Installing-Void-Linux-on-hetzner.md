---
title: "Installing k3s with cilium"
date: 2026-06-14
---

## Installing k3s

The k3s use flannel as CNI. To use cilium we will init k3s without flannel.

```sh 
curl -sfL https://get.k3s.io | sh -s - \
  --flannel-backend=none \
  --disable-kube-proxy \
  --disable-network-policy \
  --disable=servicelb \
  --disable=traefik
```

Copy config to ~/.kube/config

```sh
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
```

## Installing cilium cli

I will install cilium using the CLI, but, it's possible using Helm.

```sh
curl -Lo cilium.tar.gz https://github.com/cilium/cilium-cli/releases/download/v0.20.1/cilium-linux-amd64.tar.gz
```

```sh
tar xzvf cilium.tar.gz
```

```sh
mv cilium /usr/local/bin/
```

## Installing cilium on k3s

```sh
cilium install \
  --set ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16" \
  --set kubeProxyReplacement=true \
  --version 1.20.2 \
  --set k8sServiceHost=127.0.0.1 \
  --set k8sServicePort=6443 \
  --version 1.20.2

```

## Check

```sh 
cilium status

```
```
