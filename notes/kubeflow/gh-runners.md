# Github runners

## Context

Pushing to github triggers [actions](https://docs.github.com/en/actions), which can run tests, linting, build artifacts, deploy etc

These workflows need to run on a server.  Github offers some with no config needed, but they don't have GPU and are not customizeable

## Goal

Set up our own GH action runners on Azure to run our CICD pipeline.  They should be:

* Autoscaling: scale up/down based on necessity to save on compute
