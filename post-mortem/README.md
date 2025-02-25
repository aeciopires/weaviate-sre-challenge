# post-mortem

<!-- TOC -->

- [post-mortem](#post-mortem)
- [Post-Mortem Analysis: Vault dependency incident](#post-mortem-analysis-vault-dependency-incident)
  - [Executive Summary](#executive-summary)
  - [Timeline of Events](#timeline-of-events)
  - [Root Cause Analysis](#root-cause-analysis)
  - [Impact](#impact)
  - [Resolution and Remediation](#resolution-and-remediation)
  - [Lessons Learned](#lessons-learned)
  - [Conclusion](#conclusion)

<!-- TOC -->

> ATTENTION!!! This post mortem is based on a false situation... or not. 😃 😂

# Post-Mortem Analysis: Vault dependency incident

Date: February 25, 2025
Incident ID: AECIO-2025-02-25-001

## Executive Summary

On February 25, 2025, our production [EKS cluster](https://aws.amazon.com/eks/) experienced unexpected downtime affecting over 164 microservices. The root cause was traced to the recreation of [spot nodes](https://aws.amazon.com/ec2/spot) which led to a timing issue: microservices pods started before [Hashicorp Vault](https://www.hashicorp.com/en/products/vault), a critical dependency responsible for secret management. This sequencing error resulted in authentication and configuration failures across several services. Immediate remediation involved migrating from spot nodes to [on-demand nodes](https://www-techtarget-com.translate.goog/searchaws/definition/Amazon-EC2-instances) and instituting a [PodDisruptionBudget (PDB)](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets) for Vault, thereby preventing similar issues in the future.

## Timeline of Events

    08:00 UTC: Initial alert received regarding service authentication failures.
    
    08:01 UTC: Monitoring confirmed widespread issues across microservices; logs indicated Vault was not yet available.
    
    08:05 UTC: All microservice pods were recreated to resolve issues more quickly before further investigation.
    
    08:10 UTC: Investigation initiated; verification of node creation dates revealed recent recreation events on spot instances.
    
    08:18 UTC: Root cause identified: spot node recreation caused microservices to restart before Vault was available.
    
    22:00 UTC: Emergency maintenance window commenced; manual intervention began draining old nodes.
    
    22:05 UTC: All critical pods, including Vault, rescheduled onto on-demand nodes.
    
    23:45 UTC: Full service restoration confirmed; no further downtime observed.

## Root Cause Analysis

- **Node Volatility**: The use of spot instances introduced inherent instability. When spot nodes were recreated, their unpredictable lifecycle led to an incorrect pod startup sequence. 
- **Dependency Mismanagement**: Microservices relying on Vault attempted to initialize before Vault pods were up and running, resulting in authentication failures.
- **Lack of Safeguards**: Absence of a PodDisruptionBudget for Vault meant there was no enforced minimum availability, exacerbating the issue during node disruptions.
- **Low failure tolerations to spot nodes**: the applications do not have failure tolerances to spot nodes. The increase of costs using on-demand nodes is necessary.

## Impact

- **Service Downtime**: 10 minutes of outage affected over 164 microservices, leading to service degradation and potential revenue impact.   
- **Operational Disruption**: Increased workload for the incident response team and a surge in customer support tickets.
- **Cost Implications**: Migration to on-demand nodes led to increased operational costs, albeit with improved reliability.

## Resolution and Remediation

- **Migration to On-Demand Nodes**:
  - Transitioned the cluster from spot to on-demand nodes during a controlled maintenance window.
  - Ensured that node volatility was eliminated, leading to predictable pod scheduling.

- **Implementation of PodDisruptionBudget (PDB)**:
    - Configured a PDB for Vault to enforce a minimum number of available Vault pods during maintenance or unexpected disruptions.
    - This configuration ensures that critical services like Vault maintain high availability.

## Lessons Learned

- **Risk vs. Cost Trade-Off**:
  - The cost savings from spot instances must be carefully balanced against the risk to critical service reliability. For critical components like Vault, stability is paramount.

- **Resilience Through Configuration**:
  - The proactive use of PodDisruptionBudgets can safeguard against similar incidents in the future by ensuring that key services remain available even during node maintenance or disruptions.

## Conclusion

This incident highlighted the delicate balance between cost optimization and service reliability. By moving to on-demand nodes and implementing a robust PDB for Vault, we have mitigated the risk of similar downtime. Moving forward, our focus will be on enhancing our dependency management strategies and monitoring capabilities to ensure high availability across all critical services.
