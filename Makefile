CLUSTER := homeport
CONFIG := cluster/k3d.yaml

.PHONY: up down status hooks bootstrap

up:
	k3d cluster create --config $(CONFIG)
	kubectl wait --for=condition=Ready nodes --all --timeout=120s

down:
	k3d cluster delete $(CLUSTER)

status:
	k3d cluster list $(CLUSTER)
	kubectl get nodes
	kubectl get pods -A

hooks:
	git config core.hooksPath .githooks

bootstrap:
	helm upgrade --install argocd platform/argocd --namespace argocd --create-namespace --dependency-update --wait --timeout 5m
	kubectl apply -f bootstrap/root-app.yaml
