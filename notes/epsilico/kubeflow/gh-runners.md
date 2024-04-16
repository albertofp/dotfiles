# Github Runners

## Context

Pushing to github triggers [actions](https://docs.github.com/en/actions), which can run tests, linting, build artifacts, deploy etc

These workflows need to run on a server.  Github offers some with no config needed, but they don't have GPU and are not customizeable

## Goal

Set up our own GH action runners on Azure to run our CICD pipeline.  They should be:

* Autoscaling: scale up/down based on necessity to save on compute
* Fast: pipeline should run reasonably fast and runners should work in parallel if needed
* Self sustaining: minimize/eliminate need for manual intervention

## Actions-runner-controller (ARC)

[ARC Repository](https://github.com/actions/actions-runner-controller)

[Docs](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/quickstart-for-actions-runner-controller)

Collection of Kubernetes resources that allows us to use nodes on our cluster to run GitHub actions.
Available as [Helm](https://helm.sh/) charts that we can configure and apply.

* Orchestrates and scales self-hosted runners on a k8s cluster
* Can create separate namespaces just for this (`arc-systems` and `arc-runners`)

All relevant files will be in the `flow/k8s/ghrunners` directory

## Implementation

* Node pool with taints (so, by default, nothing unrelated can be scheduled here)
```bash
❯ kubectl get node aks-ghrunners-71216688-vmss000000 -o json | jq '.spec.taints'
[
  {
    "effect": "NoSchedule",
    "key": "github",
    "value": "true"
  }
]
```
* Configuration: `actions-runner-controller/values.yml` and `gha-runner-scale-set/values.yml`
* Tolerations (so actions runner related resources can be scheduled on these nodes)
```yaml
# gha-runner-scale-set/values.yml
    nodeSelector:
      github-runner: "true"
    tolerations: 
      - key: "github"
        operator: "Equal"
        value: "true"
        effect: "NoSchedule"
```
* Helm install ARC + GHA runner scale-set

`ghrunners-helminstall.sh` was used to install both helm charts.  It also includes creation of the necessary namespaces and a secret to connect to the GitHub app that authenticates the communication between the GitHub repository and the Kubernetes cluster.

The private key is not committed to the repository and should be stored in 1Password.

```bash
❯ cat ghrunners-helminstall.sh
#!/bin/bash
# https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/quickstart-for-actions-runner-controller

# Don't commit actual secrets to the repo, these are placeholders
# and must be replaced before running the script
# Secret name must match with the value passed in ./gha-runner-scale-set/values.yaml
NAMESPACE_SCALESET="arc-runners"
NAMESPACE_CONTROLLER="arc-systems"
INSTALLATION_NAME="arc-runner-set"

helm install arc \
    --namespace "${NAMESPACE_CONTROLLER}" \
    --create-namespace \
    -f ./actions-runner-controller/values.yaml \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller


helm install "${INSTALLATION_NAME}" \
    --namespace "${NAMESPACE_SCALESET}" \
    --create-namespace \
    -f ./gha-runner-scale-set/values.yaml \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set

kubectl create secret generic github-app-secret \
  --namespace="${NAMESPACE_SCALESET}" \
  --from-literal=github_app_id=872253 \
  --from-literal=github_app_installation_id=49460681 \
  --from-literal=github_app_private_key="$(cat ./private-key.pem)"
```


```bash
❯ helm list -A -f "arc"
NAME          	NAMESPACE  	REVISION	UPDATED                              	STATUS  	CHART                                	APP VERSION
arc           	arc-systems	1       	2024-04-10 14:22:12.172785 +0200 CEST	deployed	gha-runner-scale-set-controller-0.9.0	0.9.0      
arc-runner-set	arc-runners	21      	2024-04-15 13:56:22.466506 +0200 CEST	deployed	gha-runner-scale-set-0.9.0           	0.9.0    
```
