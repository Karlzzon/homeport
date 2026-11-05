# 0005. Render manifests on demand

## Date

2026-11-05

## Context

A one-line chart version change can change many lines in the resulting manifests, and that effect is not visible in the Git diff of `Chart.yaml`. Committing rendered manifests makes the effect visible, but adds generated files and a render step to every change.

## Decision

Rendered manifests are not committed. Argo CD renders charts when it syncs. The effect of a change is checked locally before pushing, with `helm template` and `kubectl diff`.

Make targets for these commands, `make render` and `make diff`, are planned but do not exist yet. They will be added together with the first application in `apps/`.

## Alternatives considered

- **Rendered manifests committed by a script or CI:** exact diffs in Git, but large generated files and a pipeline that must render every update.
- **Argo CD Source Hydrator:** handles the same pattern inside Argo CD, but it is a beta feature, and it needs an extra component with write access to Git.
- **`argocd-diff-preview` in pull requests:** shows rendered diffs without committing them, but requires a pull request workflow, which this repository does not use.

## Consequences

- **Positive:** the repository contains only hand-written files.
- **Positive:** a version update is a one-line change.
- **Negative:** Git history does not show the rendered result of a change.
- **Negative:** the local check is a manual step, and nothing enforces it.
- **Negative:** local rendering can differ slightly from Argo CD, which knows the cluster version and available APIs.
