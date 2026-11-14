# 0009. Route traffic with Gateway API and Traefik

## Date

2026-11-14

## Context

The cluster needs one entry point for HTTP traffic. k3d publishes ports 80 and 443 on `127.0.0.1` and forwards them to the nodes.

k3s bundles Traefik as a packaged component. Its version follows the k3s release, and it is configured through a `HelmChartConfig` resource instead of a chart in this repository. It serves the Ingress API by default. The Kubernetes project has frozen the Ingress API and develops Gateway API as its successor.

## Decision

Disable the Traefik bundled with k3s, and install Traefik from its upstream Helm chart as `platform/traefik/`, like any other platform component.

Use Gateway API as the only routing API:

- Traefik runs with the Gateway API provider only. The Ingress and IngressRoute providers are disabled, and no `IngressClass` is created.
- The chart creates the GatewayClass `traefik` and one shared Gateway, `traefik-gateway`, in the `traefik` namespace.
- The Gateway accepts routes from all namespaces, so each application keeps its `HTTPRoute` in its own namespace.
- The Gateway API CRDs are installed separately, as described in [ADR 0008](0008-deploy-components-and-shared-crds-with-applicationsets.md).

The Gateway has an HTTP listener only. An HTTPS listener is added together with certificate management.

## Alternatives considered

- **The Traefik bundled with k3s:** nothing to install, but its version cannot be chosen independently of k3s, and its configuration does not follow the wrapper chart pattern.
- **The Ingress API:** widely known and simple, but frozen, and anything beyond basic routing needs controller-specific annotations.
- **Traefik IngressRoute resources:** give access to every Traefik feature, but tie all routing configuration to one controller.
- **Another Gateway API controller, such as Envoy Gateway:** routes would look the same, but Traefik is the controller that k3s ships and documents, and it runs as a single pod.
- **Routes only from labelled namespaces:** stricter, but namespaces are created by Argo CD without labels, so every application would need an extra step. This is left for the work on security and policy.

## Consequences

- **Positive:** routing is written against a standard API, so routes do not change if the controller is replaced.
- **Positive:** the Traefik version is pinned in Git and upgraded independently of k3s.
- **Positive:** there is one way to route traffic in the cluster.
- **Positive:** Traefik uses about 27 MiB of memory when idle.
- **Negative:** Traefik features outside Gateway API, such as middlewares, are not available until the IngressRoute provider is enabled.
- **Negative:** any namespace can attach a route to the shared Gateway and claim any hostname.
- **Negative:** the chart installs 25 CRDs, of which 15 belong to Traefik Hub and are not used.
- **Negative:** Traefik needs the Gateway API CRDs from another application. On a new cluster its first sync fails and is retried, which adds to the bootstrap time.
- **Negative:** the Traefik version and the Gateway API version must match, so the two are upgraded together.
