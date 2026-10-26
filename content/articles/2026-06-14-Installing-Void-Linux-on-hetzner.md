---
title: "Installing k3s with cilium"
date: 2026-06-14
---

## Installing k3s

K3s uses Flannel for pod networking by default. Install K3s without Flannel so Cilium can handle networking instead.

This command also disables kube-proxy and the built-in network policy controller, since Cilium will take over those roles. ServiceLB and Traefik are disabled to leave load balancing and ingress setup for later.

```sh 
curl -sfL https://get.k3s.io | sh -s - \
  --flannel-backend=none \
  --disable-kube-proxy \
  --disable-network-policy \
  --disable=servicelb \
  --disable=traefik
```

Copy the K3s configuration to `~/.kube/config` so tools such as `kubectl` and the Cilium CLI can connect to the cluster. The `~/.kube` directory must already exist.

```sh
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
```

## Installing cilium cli

Here, I use the Cilium CLI to install Cilium. You can also install it with Helm.

Download version `v0.20.1` of the CLI for Linux on AMD64:

```sh
curl -Lo cilium.tar.gz https://github.com/cilium/cilium-cli/releases/download/v0.20.1/cilium-linux-amd64.tar.gz
```

Extract the downloaded archive to get the `cilium` binary:

```sh
tar xzvf cilium.tar.gz
```

Move the binary to `/usr/local/bin` so you can run `cilium` from any directory. This requires permission to write to `/usr/local/bin`.

```sh
mv cilium /usr/local/bin/
```

## Installing cilium on k3s

Install Cilium version `1.20.2` in the cluster. The pod address pool is set to `10.42.0.0/16`, and `kubeProxyReplacement` enables Cilium to handle service traffic in place of kube-proxy.

The API server address is set explicitly to `127.0.0.1:6443`. This assumes you are running the command on the K3s server and the API is reachable there.

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

Check the status of Cilium's components and look for any reported errors:

```sh 
cilium status
```
