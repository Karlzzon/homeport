# 0002. Run k3s with k3d

## Date

2026-11-04

## Context

The platform runs on a single laptop with about 13.5 GiB of usable memory. It should be quick to tear down and rebuild, support multi-node behaviour such as scheduling and node drains, and leave the host system largely untouched.

## Decision

Run k3s in Docker with k3d, using one server and two agents. The cluster is defined in `cluster/k3d.yaml`, with the k3s image pinned. The Kubernetes API and the HTTP and HTTPS ports are bound to `127.0.0.1` only.

## Alternatives considered

- **k3s directly on the host:** lowest overhead, but limited to one node in practice. The k3s documentation recommends disabling the host firewall, and removal affects the host.
- **k3s in virtual machines:** the most realistic option and allows in-place upgrades, but each VM costs memory and rebuilds are slower. It also needs a provisioning layer.
- **Three servers with embedded etcd:** shows high availability, but adds overhead without real resilience, because all nodes share one machine.

## Consequences

- **Positive:** a cold start takes under a minute, and a rebuild with cached images about 40 seconds. Teardown leaves no containers, networks or volumes behind.
- **Positive:** an idle cluster uses about 1.1 GiB of memory, which leaves room for platform services.
- **Positive:** the whole cluster definition is a single file in version control.
- **Negative:** k3s cannot be upgraded in place. An upgrade means changing the image and recreating the cluster, so all state must be reproducible from Git.
- **Negative:** all nodes share the host kernel and memory, so extra agents add scheduling scenarios, not capacity.
- **Negative:** Docker is required, and membership of the `docker` group is effectively root access on the host.
