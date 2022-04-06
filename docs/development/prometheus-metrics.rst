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

The Prometheus metric counters for XACML-PDP can be found in the XacmlPdpStatisticsManager.

pdpx_policy_deployments_total
+++++++++++++++++++++++++++++

-  "deploy": Counts the number of successful or failed deploys.
-  "undeploy": Counts the number of successful or failed undeploys.

pdpx_policy_decisions_total
+++++++++++++++++++++++++++

-  "permit": Counts the number of permit decisions.
-  "deny": Counts the number of deny decisions.
-  "indeterminant": Counts the number of indeterminant decisions.
-  "not_applicable": Counts the number of not applicable decisions.
