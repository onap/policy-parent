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

The Prometheus metric counters for XACML-PDP can be found in the XacmlPdpStatisticsManager. Updates
are done in the "pdpx" Prometheus namespace.

pdpx_policy_deployments_total
+++++++++++++++++

-  DEPLOY_OPERATION: Updates the number of successful or failed deploys.
-  UNDEPLOY_OPERATION: Updates the number of successful or failed undeploys.

pdpx_policy_decisions_total
+++++++++++++++

-  PERMIT_OPERATION: Updates the number of permit decisions.
-  DENY_OPERATION: Updates the number of deny decisions.
-  INDETERMINANT_OPERATION: Updates the number of indeterminant decisions.
-  NOT_APPLICABLE_OPERATION: Updates the number of not applicable decisions.
