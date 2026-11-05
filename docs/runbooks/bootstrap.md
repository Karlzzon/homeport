# Bootstrap

Creates the cluster from nothing.

## Prerequisites

- [Docker](https://docs.docker.com/engine/install/), running, with your user able to reach it
- [k3d](https://k3d.io/) 5.9.0
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/) 4
- [gitleaks](https://github.com/gitleaks/gitleaks)
- `make`
- Ports 80, 443 and 6443 free on `127.0.0.1`

## Steps

1. Enable the pre-commit hook. This is needed once per clone.

   ```bash
   make hooks
   ```

2. Create the cluster. This also adds the `k3d-homeport` context to your kubeconfig and switches to it.

   ```bash
   make up
   ```

3. Install Argo CD and hand over to GitOps. This installs the chart in `platform/argocd/` with Helm, then applies `bootstrap/root-app.yaml`. From that point Argo CD manages itself and everything else from Git.

   ```bash
   make bootstrap
   ```

4. Verify the result.

   ```bash
   make status
   kubectl get applications -n argocd
   curl -i http://127.0.0.1/
   ```

   All three nodes should be `Ready`, and all pods `Running` or `Completed`. The applications `root` and `argocd` should be `Synced` and `Healthy`. The `curl` command should return `404` from Traefik, because no routes exist yet.

5. Optional: open the Argo CD web interface at <https://127.0.0.1:8080>. The certificate is self-signed. Log in as `admin` with the generated password.

   ```bash
   kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
   kubectl port-forward -n argocd svc/argocd-server 8080:443
   ```

## Make targets

| Target | What it does |
|---|---|
| `make hooks` | Enables the pre-commit hook in `.githooks/`. Needed once per clone. |
| `make up` | Creates the cluster from `cluster/k3d.yaml` and waits for all nodes to be `Ready`. |
| `make bootstrap` | Installs Argo CD with Helm and applies the root application. Safe to run again. |
| `make status` | Shows the cluster, its nodes and all pods. |
| `make down` | Deletes the cluster. See the [teardown runbook](teardown.md). |

`make bootstrap` downloads the Argo CD chart to `platform/argocd/charts/` and generates `Chart.lock`. Both are ignored by Git and can be deleted at any time. After a version change in `Chart.yaml`, delete `charts/` before running `make bootstrap` again.

## Known behaviour

The `helm-install-traefik` pod usually restarts once during startup, and the job then completes. No action is needed.
