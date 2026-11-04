# Teardown

Removes the cluster and everything in it. Nothing outside Git is preserved.

## Steps

1. Delete the cluster.

   ```bash
   make down
   ```

2. Verify the result.

   ```bash
   k3d cluster list
   docker ps -a --filter name=k3d-
   ```

   Neither command should list `homeport`. Downloaded images remain in Docker, which makes the next start faster.
