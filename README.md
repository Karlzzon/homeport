# homeport

A k3s platform that runs on a laptop and is managed through GitOps. It can be torn down and rebuilt from this repository.

The name is a nautical nod to Kubernetes, Greek for "helmsman".

> **Status:** Early development. The cluster is not built yet. See [the documentation](docs/README.md) for decisions made so far.

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

## Documentation

See the [documentation index](docs/README.md).
