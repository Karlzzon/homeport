# 0008. Deploy components and shared CRDs with ApplicationSets

## Date

2026-11-14

## Context

Adding a component should mean adding a directory, without writing Argo CD manifests by hand. Most components are upstream Helm charts with local values. Some also need local resources, such as routes. The structure needs to stay small enough to work with daily, and each component needs to be easy to render locally.

[ADR 0004](0004-deploy-with-applicationsets-and-wrapper-charts.md) covered this with a wrapper chart per directory and two ApplicationSets. It did not cover APIs that are shared between components. Gateway API is the first: its CRDs are used by more than one component, are published upstream as plain manifests without a Helm chart, and contain only cluster-scoped resources. Deleting a CRD also deletes every resource of that kind in the cluster.

## Decision

Each component is a directory with a wrapper chart: a `Chart.yaml` with the upstream chart as a dependency, and a `values.yaml`. A `templates/` directory is added only when a component needs its own resources. Plain manifests are deployed the same way, in the `templates/` directory of a chart. Versions are pinned exactly. `Chart.lock` and `charts/` are not committed.

CRDs follow their owner:

- CRDs that belong to one component are installed by that component's chart.
- CRDs for an API that no single component owns are a directory of their own in `crds/`. The directory holds a `kustomization.yaml` that references the upstream manifests at a pinned Git tag.

Kustomize is used only to fetch upstream manifests that have no Helm chart. Overlays and patches are not used.

Three ApplicationSets with a Git directory generator create one Application per directory:

- `platform` scans `platform/*` and uses the `platform` project, which allows cluster-scoped resources. It preserves resources when a directory is removed, so removing `platform/argocd/`, for example, cannot delete Argo CD.
- `apps` scans `apps/*` and uses the `apps` project, which only allows `Namespace` as a cluster-scoped resource. It deletes resources when a directory is removed.
- `crds` scans `crds/*` and uses the `platform` project. It sets no namespace, does not prune, and preserves resources when a directory is removed.

`platform` and `apps` accept only Helm charts. In `crds`, Argo CD detects the build tool from the content of the directory, so Kustomize is a convention there. The project is hardcoded in each ApplicationSet, so a directory cannot choose its own permissions. See [GitOps](../architecture/gitops.md) for details.

## Alternatives considered

- **No wrapper chart, multi-source Applications instead:** each Application points directly at the upstream chart and reads `values.yaml` from this repository. Values stay flat, but each directory then needs a `config.yaml` with the chart name and version. That file is specific to this repository, so `helm template` cannot render a directory, and version update tools cannot update the version without a custom rule.
- **Shared CRDs as an extra source in the component that uses them:** keeps related resources in one Application, but ties a shared API to the lifecycle of one component. The Argo CD documentation also advises against using multiple sources to group resources.
- **Shared CRDs in `platform/`, with any build tool allowed:** one ApplicationSet less, but the wrapper chart rule becomes a convention that nothing enforces, and each CRD directory gets an empty namespace.
- **CRD manifests copied into a wrapper chart:** rendering does not depend on the upstream repository, but the repository gains thousands of lines that are not written here and must be copied again for every upgrade.
- **Rendered manifests with Helmfile:** exact diffs, but adds a tool, generated YAML in the repository and a render step for every change.
- **One Application manifest per component:** simple with few components, but repeats the same boilerplate and scales poorly.
- **One ApplicationSet for everything:** fewer files, but needs logic to select the project, which is the decision that should not depend on a directory.

## Consequences

- **Positive:** a new component is two files in a new directory, and a new shared API is one file.
- **Positive:** `helm template` works directly on every chart, and `kubectl kustomize` on every directory in `crds/`. The same chart is used by `make bootstrap` and by Argo CD.
- **Positive:** `Chart.yaml` is a standard format, so version update tools work without custom configuration.
- **Positive:** a shared API is upgraded on its own schedule and stays in place when a component that uses it is replaced.
- **Positive:** removing a file or a directory in `crds/` cannot delete a CRD, or the resources that depend on it.
- **Negative:** values are nested under the dependency name, and misplaced values are silently ignored.
- **Negative:** version pins do not cover content. A chart republished under the same version, or a moved Git tag, is not detected.
- **Negative:** the directory name decides the application name, namespace and release name, so exceptions need a change to the template.
- **Negative:** applications sync without ordering. A resource that needs a missing CRD fails until the CRD exists, and is then fixed by automatic retries.
- **Negative:** rendering a directory in `crds/` requires that the upstream repository is reachable.
- **Negative:** removing a shared CRD from the cluster is a manual step.
- **Negative:** on k3s 1.37 and later, the packaged `gateway-api-crd` component must be disabled, or two sources manage the same CRDs.
