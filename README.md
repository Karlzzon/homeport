# homeport

A k3s platform that runs on a laptop and is managed through GitOps. It can be torn down and rebuilt from this repository.

The name is a nautical nod to Kubernetes, Greek for "helmsman".

> **Status:** Early development. The cluster runs and Argo CD manages itself from this repository. No other platform services are deployed yet.

## Goals

- **Reproducible:** the whole platform is rebuilt from declarative configuration.
- **Easy to extend:** adding an application means adding a directory.
- **Documented:** every significant choice is recorded with its reasoning.

## Technology

| Purpose | Tool |
|---|---|
| Kubernetes distribution | [k3s](https://k3s.io/) |
| Local cluster runtime | [k3d](https://k3d.io/) |
| GitOps | [Argo CD](https://argo-cd.readthedocs.io/) |
| Traffic routing | [Gateway API](https://gateway-api.sigs.k8s.io/) |
| Secret scanning | [gitleaks](https://github.com/gitleaks/gitleaks) |

## Quickstart

Requires Docker, k3d, kubectl, Helm and `make`. See the [bootstrap runbook](docs/runbooks/bootstrap.md).

```bash
make up          # create the cluster
make bootstrap   # install Argo CD and hand over to GitOps
make status      # check nodes and pods
make down        # delete the cluster
```

## Documentation

See the [documentation index](docs/README.md).
