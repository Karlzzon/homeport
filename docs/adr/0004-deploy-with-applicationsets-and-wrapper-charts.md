# 0004. Deploy with ApplicationSets and wrapper charts

## Date

2026-11-05

## Context

Adding a component should mean adding a directory, without writing Argo CD manifests by hand. Most components are upstream Helm charts with local values. Some will also need local resources, such as routes. The structure needs to stay small enough to work with daily, and each component needs to be easy to render locally.

## Decision

Each component is a directory with a wrapper chart: a `Chart.yaml` with the upstream chart as a dependency, and a `values.yaml`. A `templates/` directory is added only when a component needs its own resources. Versions are pinned exactly. `Chart.lock` and `charts/` are not committed.

Two ApplicationSets with a Git directory generator create one Application per directory:

- `platform` scans `platform/*` and uses the `platform` project, which allows cluster-scoped resources. It preserves resources when a directory is removed, so removing `platform/argocd/`, for example, cannot delete Argo CD.
- `apps` scans `apps/*` and uses the `apps` project, which only allows `Namespace` as a cluster-scoped resource. It deletes resources when a directory is removed.

The project is hardcoded in each ApplicationSet, so a directory cannot choose its own permissions. See [GitOps](../architecture/gitops.md) for details.

## Alternatives considered

- **No wrapper chart, multi-source Applications instead:** each Application points directly at the upstream chart and reads `values.yaml` from this repository. Values stay flat, but each directory then needs a `config.yaml` with the chart name and version. That file is specific to this repository, so `helm template` cannot render a directory, and version update tools cannot update the version without a custom rule.
- **Rendered manifests with Helmfile:** exact diffs, but adds a tool, generated YAML in the repository and a render step for every change.
- **One Application manifest per component:** simple with few components, but repeats the same boilerplate and scales poorly.
- **One ApplicationSet for everything:** one file less, but needs logic to select the project, which is the decision that should not depend on a directory.

## Consequences

- **Positive:** a new component is two files in a new directory.
- **Positive:** `helm template` works directly on every component, and the same chart is used by `make bootstrap` and by Argo CD.
- **Positive:** `Chart.yaml` is a standard format, so version update tools work without custom configuration.
- **Negative:** values are nested under the dependency name, and misplaced values are silently ignored.
- **Negative:** version pins do not cover chart content, so a chart republished under the same version is not detected.
- **Negative:** the directory name decides the application name, namespace and release name, so exceptions need a change to the template.
- **Negative:** applications sync without ordering. A resource that needs a missing CRD fails until the CRD exists, and is then fixed by automatic retries.
