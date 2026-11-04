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

3. Verify the result.

   ```bash
   make status
   curl -i http://127.0.0.1/
   ```

   All three nodes should be `Ready`, and all pods `Running` or `Completed`. The `curl` command should return `404` from Traefik, because no routes exist yet.

## Known behaviour

The `helm-install-traefik` pod usually restarts once during startup, and the job then completes. No action is needed.
