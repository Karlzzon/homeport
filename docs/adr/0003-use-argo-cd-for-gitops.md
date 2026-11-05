# 0003. Use Argo CD for GitOps

## Date

2026-11-05

## Context

The cluster is rebuilt often, and k3s cannot be upgraded in place (see [ADR 0002](0002-run-k3s-with-k3d.md)). All state must therefore be reproducible from Git. Manual changes in the cluster should not survive, and the current state of each component should be easy to inspect.

## Decision

Use Argo CD as the GitOps controller. Argo CD is installed once with Helm by `make bootstrap`, which also applies a root application. After that, Argo CD manages itself and everything else from Git, with automated sync, pruning and self-healing.

## Alternatives considered

- **Flux:** a mature CNCF graduated GitOps controller, and a good fit for this kind of cluster, although it offers no clear advantage here that outweighs existing experience with Argo CD.
- **Helm and kubectl from the Makefile:** no extra components, but nothing corrects drift, and the cluster state depends on who ran what.
- **Argo CD not managing itself:** simpler at first, but Argo CD would then be the one component not controlled from Git.

## Consequences

- **Positive:** the cluster converges on what is in Git, and manual changes are reverted.
- **Positive:** a rebuild from a deleted cluster to a synced cluster takes about two minutes.
- **Positive:** the web interface shows sync and health for every component.
- **Negative:** Argo CD uses about 435 MiB of memory after its first sync, before any other workloads exist.
- **Negative:** Argo CD discovers changes by polling Git. Changes do not appear immediately.
- **Negative:** the Argo CD version limits which Kubernetes versions can be used, so the two must be upgraded together.
