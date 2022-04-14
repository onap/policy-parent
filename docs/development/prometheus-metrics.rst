.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _prometheus-metrics:

Prometheus Metrics support in Policy Framework Components
#########################################################

.. contents::
    :depth: 3

This page explains the prometheus metrics exposed by different Policy Framework components.

XACML-PDP
*********

The following Prometheus metric counters are present in the current release:

- pdpx_policy_deployments_total counts the total number of deployment operations.
- pdpx_policy_decisions_total counts the total number of decisions.

pdpx_policy_deployments_total
+++++++++++++++++++++++++++++

This counter supports the following labels:

-  "deploy": Counts the number of successful or failed deploys.
-  "undeploy": Counts the number of successful or failed undeploys.

pdpx_policy_decisions_total
+++++++++++++++++++++++++++

This counter supports the following labels:

-  "permit": Counts the number of permit decisions.
-  "deny": Counts the number of deny decisions.
-  "indeterminant": Counts the number of indeterminant decisions.
-  "not_applicable": Counts the number of not applicable decisions.
