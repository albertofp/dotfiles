# Onboarding Action Plan — Reliability & PI Process
**Due: 30 June 2026**

This plan translates the four onboarding objectives into concrete, checkable tasks, grounded in JET's actual tooling (`cpseu-docs`, `helm-core`, Karpenter, KEDA, ScaleOps, Datadog, PagerDuty) and open Jira work the team is actively tracking.

---

## Objective 1: Develop Service-Level Objectives (SLOs)

Know the SLOs for at least one key platform service, including availability, latency, and error rate metrics.

### Context
CPS-EU uses the four golden signals (traffic, latency, errors, saturation) as the monitoring baseline (`cpseu-docs/docs/best_practices/monitoring.md`). Alert thresholds in `helm-core/releases/05-prometheus-operator/prometheus-operator/templates/rules/` are the closest thing to formalised SLOs today — kube-apiserver latency > 1s, KEDA scaler latency > 5s, Karpenter node registration failures. There is no single SLO doc yet, which makes this a real gap you can own.

**Relevant open tickets:**
- [CPS-3956](https://justeattakeaway.atlassian.net/browse/CPS-3956) — KSM Single-Replica Monitoring and HA Implementation (`Needs Scoping`, unassigned)
- [CPS-4175](https://justeattakeaway.atlassian.net/browse/CPS-4175) — Verify monitoring of Istio in JETC clusters (`Needs Scoping`, unassigned)
- [CPS-4134](https://justeattakeaway.atlassian.net/browse/CPS-4134) — Add tags for eks-node-monitoring-agent (`Needs Scoping`, unassigned)
- [CPS-1643](https://justeattakeaway.atlassian.net/browse/CPS-1643) — Network: Monitoring and Alerts for AWS quotas LB utilization (`On Deck`, assigned Vasudhar)

### Actions

- [ ] Read the CPS-EU monitoring best practices: `~/github/cpseu-docs/docs/best_practices/monitoring.md`
- [ ] Read the Karpenter alerting table in `~/github/cpseu-docs/docs/services/karpenter/index.md` — understand the three Prometheus alerts (node registration, NodePool capacity, unschedulable nodes) and their thresholds
- [ ] Browse all Prometheus alert rules in `~/github/helm-core/releases/05-prometheus-operator/prometheus-operator/templates/rules/` — `kube-apiserver.yaml` (latency > 1s) and `keda.yaml` (scaler latency > 5s) are concrete SLO expressions
- [ ] Open the [Karpenter Datadog Dashboard](https://app.datadoghq.eu/dashboard/jga-ytt-myk/karpenter) and record actual current values for availability, latency, and error rate
- [ ] Open the [KEDA Overview Dashboard](https://app.datadoghq.eu/dash/integration/1333/keda-overview) and do the same for KEDA
- [ ] Ask your buddy whether a written SLO document exists for any platform service (check Confluence and Backstage first)
- [ ] Pick up [CPS-3956](https://justeattakeaway.atlassian.net/browse/CPS-3956) (unassigned, Needs Scoping) — scoping this ticket requires understanding what HA and availability targets should look like for KSM, which is directly the SLO exercise
- [ ] **Deliverable**: Write a short doc (add to `cpseu-docs`) formalising the SLO for one service — target availability %, latency p95 target, error rate budget, and how each is measured in Datadog/Prometheus. File it as part of [CPS-3956](https://justeattakeaway.atlassian.net/browse/CPS-3956) or as a standalone task.

---

## Objective 2: Enhance Node Autoscaling Efficiency

Optimize Kubernetes cluster autoscaling, reducing response time to workload spikes by 30%.

### Context
JET uses **Karpenter** for node autoscaling (Cluster Autoscaler is `enabled: false` in `__common/values.yaml`), **KEDA** for pod-level event-driven scaling, and **ScaleOps** for CPU/memory request rightsizing. Production Karpenter is on v1.6.3; SBX/QA/STG are on v1.9.0. There are two active epics and a cluster of unassigned spikes directly in scope.

**Relevant open tickets:**
- [CPS-2672](https://justeattakeaway.atlassian.net/browse/CPS-2672) — **Epic**: Implement Karpenter for OneEKS to Enhance Autoscaling and Cost Efficiency (`In Progress`, Yasin Lachini) — the parent epic; ask to be assigned subtasks
- [CPS-4650](https://justeattakeaway.atlassian.net/browse/CPS-4650) — **[Spike]** Investigate Karpenter disruption and consolidation behaviour across production clusters (`Needs Scoping`, **unassigned**) — directly relevant to 30% response-time improvement
- [CPS-4151](https://justeattakeaway.atlassian.net/browse/CPS-4151) — Investigate Pod Density Saturation & Implement Permanent Karpenter Fix for DaemonSet Scheduling (`Needs Scoping`, **unassigned**)
- [CPS-3799](https://justeattakeaway.atlassian.net/browse/CPS-3799) — Karpenter Production Clusters: Cost Optimization & Fix Observed Challenges (`Blocked`, Mohamed Ehab) — understand why it's blocked; may unblock with fresh eyes
- [CPS-4112](https://justeattakeaway.atlassian.net/browse/CPS-4112) — Integrate ScaleOps with Karpenter for Optimized Multi-Layer Autoscaling in OneEKS (`Needs Scoping`, **unassigned**)
- [CPS-2657](https://justeattakeaway.atlassian.net/browse/CPS-2657) — **Epic**: KEDA Advanced Multi-Dimension and Context-Aware Autoscaling (`In Progress`, Houman Moallemi) — ask Houman about open sub-tasks
- [CPS-4675](https://justeattakeaway.atlassian.net/browse/CPS-4675) — Reduce sensitivity/false positive KEDA alerts for KedaScaledObjectErrors (`Needs Scoping`, **unassigned**) — a well-scoped, self-contained contribution
- [CPS-4044](https://justeattakeaway.atlassian.net/browse/CPS-4044) — **Epic**: ScaleOps Enhancement and Optimization Expansion (`In Progress`, Murugan Uikattan) — ask Murugan for unassigned subtasks
- [CPS-4074](https://justeattakeaway.atlassian.net/browse/CPS-4074) — Karpenter NodeOverlays to Include DataDog Agent Costs in SBX/QA/STG (`Waiting For Review`, Lian Zhen Yang) — review this PR to understand NodeOverlay mechanics

### Actions

- [ ] Read `~/github/cpseu-docs/docs/services/karpenter/index.md`, `keda.md`, and `scaleops.md` end-to-end
- [ ] Review the Karpenter version matrix — production is on v1.6.3 vs STG v1.9.0. Understand what features (NodeOverlay, spot-to-spot consolidation, Helm-managed CRDs) are blocked by this gap
- [ ] Read [CPS-3799](https://justeattakeaway.atlassian.net/browse/CPS-3799) in detail to understand the current production challenges. Talk to Mohamed Ehab about what's blocking it.
- [ ] Pick up [CPS-4650](https://justeattakeaway.atlassian.net/browse/CPS-4650) (unassigned spike): investigate Karpenter disruption and consolidation in production — this is the most direct path to the "30% improvement" objective and is already framed as a research task
- [ ] Pick up or co-own [CPS-4675](https://justeattakeaway.atlassian.net/browse/CPS-4675) (unassigned): tune the `KedaScaledObjectErrors` alert threshold — a concrete, bounded task with clear before/after metrics
- [ ] Review the [CPS-4074](https://justeattakeaway.atlassian.net/browse/CPS-4074) PR (Waiting For Review) for Karpenter NodeOverlay — reviewing a PR counts as contribution and builds knowledge
- [ ] Access the [ScaleOps UI](https://justeattakeaway.scaleops.com/) and identify the top over/under-provisioned workloads in `euw1-pdv-prd-5`
- [ ] Review `~/github/helm-core/releases/85-overprovisioning/` — understand when cluster overprovisioning headroom is used and why it's disabled by default
- [ ] **Deliverable**: Deliver [CPS-4650](https://justeattakeaway.atlassian.net/browse/CPS-4650) — the spike output (a written investigation with before/after latency data from Datadog) is your primary performance review artifact for this objective. Title it with a measured improvement claim.

---

## Objective 3: Understand and Implement Proactive Resource Request Limits

Define and enforce resource request and limit policies for at least 80% of all pods in EKS.

### Context
ScaleOps automatically right-sizes CPU/memory requests across all clusters. Kyverno enforces namespace-level policies. `OptimizeMemoryRequest` and `OptimizeCPURequest` Prometheus alerts fire when actual usage is below 20% of requests for > 1 day. The DORA quarterly capacity review (`cpseu-docs/docs/runbooks/scaling.md`) is the formal process. There are open tickets around ScaleOps coverage and workload exclusion management.

**Relevant open tickets:**
- [CPS-4044](https://justeattakeaway.atlassian.net/browse/CPS-4044) — **Epic**: ScaleOps Enhancement and Optimization Expansion (`In Progress`, Murugan Uikattan) — parent for resource rightsizing work
- [CPS-4047](https://justeattakeaway.atlassian.net/browse/CPS-4047) — Create and Publish ScaleOps Runbook (`Needs Scoping`, **unassigned**) — a well-defined documentation task you can own end-to-end
- [CPS-4350](https://justeattakeaway.atlassian.net/browse/CPS-4350) — Discuss with teams which workloads need to be excluded from ScaleOps (`Needs Scoping`, Yurii Hrunyk) — directly about resource policy coverage
- [CPS-4064](https://justeattakeaway.atlassian.net/browse/CPS-4064) — **[Spike]** Investigate ScaleOps workload policy for overriding core service resource limits (`Needs Scoping`, **unassigned**)
- [CPS-3996](https://justeattakeaway.atlassian.net/browse/CPS-3996) — WIP: Allowing ScaleOps to Dynamically Raise Memory Limits for OOM Healing (`Needs Scoping`, **unassigned**)
- [CPS-3288](https://justeattakeaway.atlassian.net/browse/CPS-3288) — Remove resource quotas from core namespaces (`Needs Scoping`, unassigned)
- [CPS-2548](https://justeattakeaway.atlassian.net/browse/CPS-2548) — DORA compliance (`Needs Scoping`, unassigned) — connect with the DORA capacity review process
- [CPS-4025](https://justeattakeaway.atlassian.net/browse/CPS-4025) — Proactive Alert for HPA Configuration Exceeding Namespace Quotas (`In Review`, Pouyeh Banijamali) — relevant to resource quota monitoring; review this

### Actions

- [ ] Read `~/github/cpseu-docs/docs/runbooks/scaling.md` — understand the quarterly DORA capacity review and the 40% headroom target
- [ ] Read `~/github/cpseu-docs/docs/services/kyverno.md` — understand `Policy` vs `ClusterPolicy` scope
- [ ] Read the `OptimizeMemoryRequest`/`OptimizeCPURequest` alert definitions: `~/github/helm-core/releases/05-prometheus-operator/prometheus-operator/templates/rules/optimize-request.yaml`
- [ ] Review [CPS-4025](https://justeattakeaway.atlassian.net/browse/CPS-4025) (In Review) — Proactive Alert for HPA Exceeding Namespace Quotas; understand the approach and leave a review comment
- [ ] Access the [ScaleOps UI](https://justeattakeaway.scaleops.com/) and measure the current % of pods with `scaleops.sh/managed=true` in `euw1-pdv-prd-5`. Record the baseline.
- [ ] Run: `kubectl get pods -l scaleops.sh/managed=true --all-namespaces | wc -l` vs total pods — cross-check the UI number
- [ ] Talk to Yurii Hrunyk about [CPS-4350](https://justeattakeaway.atlassian.net/browse/CPS-4350) (workload exclusions) — understanding what is excluded and why is part of understanding the 80% target
- [ ] Pick up [CPS-4047](https://justeattakeaway.atlassian.net/browse/CPS-4047) (unassigned): write the ScaleOps runbook — this is a well-scoped documentation task that requires you to deeply understand the resource management process, and produces a durable artifact
- [ ] **Deliverable**: Deliver [CPS-4047](https://justeattakeaway.atlassian.net/browse/CPS-4047) — a published ScaleOps runbook in `cpseu-docs` covering setup, how to audit coverage, how to handle exclusions, and troubleshooting. This directly demonstrates ownership of the resource limits objective.
- [ ] **Deliverable**: Participate in the DORA quarterly capacity review (connect with [CPS-2548](https://justeattakeaway.atlassian.net/browse/CPS-2548)) and produce a ticket with before/after headroom numbers for at least one CPS-EU service.

---

## Objective 4: Understand How Post-Mortems Are Carried Out

Participate in a post-mortem to understand the PI process and learn from Production Issues.

### Context
CPS-EU follows JET's global PI process (`cpseu-docs/docs/incident_management/index.md`). PIs are raised via `#soc`, tracked in Jira, and the on-call engineer attends the Production Meeting. There is an open epic ([CPS-3340](https://justeattakeaway.atlassian.net/browse/CPS-3340)) specifically for improving DR and incident processes, with three unassigned subtasks — this is the direct entry point.

**Relevant open tickets:**
- [CPS-3340](https://justeattakeaway.atlassian.net/browse/CPS-3340) — **Epic**: Core Platform Services: Optimized DR and Incidents Process (`To Do`, **unassigned**) — the goal is "minimise recovery time" through updated documentation and procedures
- [CPS-3343](https://justeattakeaway.atlassian.net/browse/CPS-3343) — Review if all CPS-EU components have runbooks (`Needs Scoping`, **unassigned**) — a concrete audit task under the epic above
- [CPS-3342](https://justeattakeaway.atlassian.net/browse/CPS-3342) — DR Plan Documentation Update (`Needs Scoping`, **unassigned**)
- [CPS-3341](https://justeattakeaway.atlassian.net/browse/CPS-3341) — Assessment and Update of Current DR Plan (`Needs Scoping`, **unassigned**)

### Actions

- [ ] Read `~/github/cpseu-docs/docs/incident_management/index.md` and the full [PI process slide deck](https://docs.google.com/presentation/d/1E30keMawAsZU9OXaCog7kyTy6Yc9uWT2gKPZxtNTaq0/)
- [ ] Read `~/github/cpseu-docs/docs/team/responsibilities.md` — understand the KIR role, escalation policy, and < 15 min response time expectation
- [ ] Read the DR runbooks: `~/github/cpseu-docs/docs/incident_management/Disaster Recovery/eks.md` and `consul.md`
- [ ] Monitor the alert channels in `cpseu-docs/docs/team/definitions.md` (`#alerts-cps-pagerduty`, `#alerts-cps-alertmanager-prod`, `#eks-production`) during your first weeks
- [ ] Shadow a KIR shift as soon as possible — ask your buddy to arrange this
- [ ] Review at least two past PI tickets in Jira (search `project = CPS AND issuetype = "Production Issue"`) — note the quality of root cause analysis and corrective actions
- [ ] Review [CPS-2401](https://justeattakeaway.atlassian.net/browse/CPS-2401) — understand the SOX compliance requirements for emergency bypasses (ruleset disable, manager review within one week)
- [ ] Pick up [CPS-3343](https://justeattakeaway.atlassian.net/browse/CPS-3343) (unassigned): audit which CPS-EU components have runbooks vs. which are missing them — this is a bounded research task that requires reading across the entire service catalogue and is a meaningful onboarding activity
- [ ] Pick up [CPS-3341](https://justeattakeaway.atlassian.net/browse/CPS-3341) + [CPS-3342](https://justeattakeaway.atlassian.net/browse/CPS-3342) (both unassigned): assess and update the DR plan — directly relevant to post-mortem quality since a good DR plan reduces PI impact
- [ ] **Deliverable**: When a PI occurs, volunteer to write or co-write the PI ticket (impact, timeline, root cause, corrective actions). This is the primary objective artifact.
- [ ] **Deliverable**: Deliver [CPS-3343](https://justeattakeaway.atlassian.net/browse/CPS-3343) — a published runbook audit, identifying gaps and either filling them or creating follow-up tickets for each gap. This demonstrates you understand the PI process deeply enough to improve it.

---

## Quick Reference: Key Links

| Resource | URL / Path |
|----------|------------|
| CPS-EU Docs (local) | `~/github/cpseu-docs/docs/` |
| helm-core (local) | `~/github/helm-core/` |
| Jira Operational Board | https://justeattakeaway.atlassian.net/jira/software/c/projects/CPS/boards/4188 |
| Jira Sprint Board | https://justeattakeaway.atlassian.net/jira/software/c/projects/CPS/boards/4141 |
| Backstage | https://backstage.eu-west-1.production.jet-internal.com/ |
| ScaleOps UI | https://justeattakeaway.scaleops.com/ |
| Karpenter Datadog Dashboard | https://app.datadoghq.eu/dashboard/jga-ytt-myk/karpenter |
| KEDA Overview Dashboard | https://app.datadoghq.eu/dash/integration/1333/keda-overview |
| PI Process Slide Deck | https://docs.google.com/presentation/d/1E30keMawAsZU9OXaCog7kyTy6Yc9uWT2gKPZxtNTaq0/ |
| OneEKS Advanced Scaling Docs | https://backstage.eu-west-1.production.jet-internal.com/docs/default/concept/oneeks/tasks/run-applications/advanced-scaling/ |
| PlatformMetadata | https://github.je-labs.com/metadata/PlatformMetadata |
| GitHub Enterprise | https://github.je-labs.com/ |

---

## Performance Review Artifacts Checklist

Each item maps to a real open Jira ticket or a verifiable output you can point to by name:

| Artifact | Objective | Jira Anchor |
|----------|-----------|-------------|
| SLO definition doc for one platform service (Karpenter or KSM) in `cpseu-docs` | Obj 1 | [CPS-3956](https://justeattakeaway.atlassian.net/browse/CPS-3956) |
| Delivered investigation spike: Karpenter disruption/consolidation in production, with Datadog before/after | Obj 2 | [CPS-4650](https://justeattakeaway.atlassian.net/browse/CPS-4650) |
| KEDA alert tuning: reduced false-positive rate for `KedaScaledObjectErrors` | Obj 2 | [CPS-4675](https://justeattakeaway.atlassian.net/browse/CPS-4675) |
| Published ScaleOps runbook in `cpseu-docs` (setup, coverage audit, exclusions, troubleshooting) | Obj 3 | [CPS-4047](https://justeattakeaway.atlassian.net/browse/CPS-4047) |
| DORA quarterly capacity review ticket with before/after headroom numbers | Obj 3 | [CPS-2548](https://justeattakeaway.atlassian.net/browse/CPS-2548) |
| Runbook audit: list of CPS-EU components missing runbooks + gap-fill PRs | Obj 4 | [CPS-3343](https://justeattakeaway.atlassian.net/browse/CPS-3343) |
| Co-authored PI ticket write-up (impact / root cause / corrective actions) | Obj 4 | next PI during onboarding period |
