# Securing KF Network Traffic

![Architecture](./kubeflow-default-ingress.png)

Might be useful:
[Article](https://www.intel.com/content/www/us/en/developer/articles/technical/build-secure-kubeflow-pipelines-on-microsoft-azure.html)

VPN Gateway / Virtual Network Gateway:
![Azure Docs](https://learn.microsoft.com/en-us/azure/vpn-gateway/howto-point-to-site-multi-auth)

## Proposed solution:

User -> VPN -> Private Network -> Kubeflow

![Proposed Solution](./cinference-vpn.png)
