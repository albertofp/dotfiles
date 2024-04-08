# Github runners

## Context

Pushing to github triggers [actions](https://docs.github.com/en/actions), which can run tests, linting, build artifacts, deploy etc

These workflows need to run on a server.  Github offers some with no config needed, but they don't have GPU and are not customizeable

## Goal

Set up our own GH action runners on Azure to run our CICD pipeline.  They should be:

* Autoscaling: scale up/down based on necessity to save on compute
* Fast: pipeline should run reasonably fast and runners should work in parallel if needed
* Self sustaining: minimize/eliminate need for manual intervention

## Options

### Actions-runner-controller (ARC)

[Github Repo](https://github.com/actions/actions-runner-controller)
[Docs on Github](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/quickstart-for-actions-runner-controller)

* Orchestrates and scales self-hosted runners on a k8s cluster
* Can create a separate namespace just for this

### Individual VMs

An option is to provision one or multiple VMs, install and run the scripts

* Potentially less up front work
* More manual maintenance
* More expensive

### VM Scale set

Azure offers a service called [Virtual Machine Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview), to dynamically provision VMs

* Middle ground between VMs and K8s
