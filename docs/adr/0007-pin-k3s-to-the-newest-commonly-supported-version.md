# 0007. Pin k3s to the newest commonly supported version

## Date

2026-11-14

## Context

The cluster ran k3s v1.37.2, the current release in the stable channel. Certificate management and traffic routing are added next, with cert-manager and Traefik. cert-manager 1.21 is the latest release line and supports Kubernetes 1.33 to 1.36. No release that supports 1.37 has been published. Argo CD 3.6 and Traefik 3.7 both support 1.36.

## Decision

Pin the k3s image to `rancher/k3s:v1.36.6-k3s1`, the latest patch release of the newest minor version that every platform component supports. Move to a newer minor version only when all components list it as supported.

## Alternatives considered

- **Stay on 1.37 with cert-manager outside its supported range:** would probably work, but a fault could not be told apart from a version mismatch, and the combination is untested upstream.
- **Stay on 1.37 and postpone certificates:** keeps the newest Kubernetes version, but blocks TLS until cert-manager publishes a compatible release.

## Consequences

- **Positive:** every component runs inside its documented support matrix.
- **Positive:** the rule for choosing a Kubernetes version is explicit, so an upgrade starts with a check of each component's support matrix.
- **Negative:** the cluster is one minor version behind the stable channel.
- **Negative:** changing the version means recreating the cluster, as described in [ADR 0002](0002-run-k3s-with-k3d.md).
- **Negative:** k3s 1.37 adds a packaged component, `gateway-api-crd`, that 1.36 does not have. The upgrade must decide whether to keep or disable it.
