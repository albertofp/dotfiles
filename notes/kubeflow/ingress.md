# Securing KF Network Traffic

![Architecture](./kubeflow-default-ingress.png)

Might be useful:
[Article](https://www.intel.com/content/www/us/en/developer/articles/technical/build-secure-kubeflow-pipelines-on-microsoft-azure.html)

VPN Gateway / Virtual Network Gateway Docs:
[MS Learn](https://learn.microsoft.com/en-us/azure/vpn-gateway/howto-point-to-site-multi-auth)

VPN Client:
[MS Learn](https://learn.microsoft.com/en-us/azure/vpn-gateway/openvpn-azure-ad-client)

Internal Load Balancer:
[Docs](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)
[MS Learn](https://learn.microsoft.com/en-us/azure/aks/internal-lb?tabs=set-service-annotations)

## Proposed solution:

User -> VPN -> Private Network -> Kubeflow

![Proposed Solution](./cinference-vpn.png)

## TODO:

- [ ] Configure VPN connections
- [ ] Generate Certificates
- [ ] Test Workflow
- [ ] Create and configure Internal Load Balancer
- [ ] Create/modify Kubernetes manifests to integrate LB with `istio-ingressgateway`
- [ ] Write Documentation for setup & workflow
