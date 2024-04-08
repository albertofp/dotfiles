## Current problems:
- not clear how it works, not very well documented
- not reproducible
- communication between teams is different
- hard to maintain (huge dockerfile -> should be multiple separate containers)


## Goals:
- decompose diffusion-design pipeline into multiple containers
- ability to deal with variable computation load
- track experiments -> good data provenance
- low level enough for easy customization, high level enough for easy use
    - some sort of easy to use, well documented API
    - third party app to extend Kubeflow dashboard 

