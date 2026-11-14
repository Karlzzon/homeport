# Documentation

## Architecture

- [GitOps](architecture/gitops.md)

## Runbooks

- [Bootstrap](runbooks/bootstrap.md)
- [Teardown](runbooks/teardown.md)

## Architecture decisions

Significant decisions are recorded as Architecture Decision Records in [`adr/`](adr/).

| ADR | Title |
|---|---|
| [0001](adr/0001-record-architecture-decisions.md) | Record architecture decisions |
| [0002](adr/0002-run-k3s-with-k3d.md) | Run k3s with k3d |
| [0003](adr/0003-use-argo-cd-for-gitops.md) | Use Argo CD for GitOps |
| [0004](adr/0004-deploy-with-applicationsets-and-wrapper-charts.md) | Deploy with ApplicationSets and wrapper charts (superseded by 0008) |
| [0005](adr/0005-render-manifests-on-demand.md) | Render manifests on demand |
| [0006](adr/0006-use-make-as-task-runner.md) | Use Make as task runner |
| [0007](adr/0007-pin-k3s-to-the-newest-commonly-supported-version.md) | Pin k3s to the newest commonly supported version |
| [0008](adr/0008-deploy-components-and-shared-crds-with-applicationsets.md) | Deploy components and shared CRDs with ApplicationSets |
| [0009](adr/0009-route-traffic-with-gateway-api-and-traefik.md) | Route traffic with Gateway API and Traefik |
