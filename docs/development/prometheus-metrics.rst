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

Deployment Counts
+++++++++++++++++

-  updateDeploySuccessCount(): Updates the number of successful deploys.
-  updateDeployFailureCount(): Updates the number of failed deploys.
-  updateUndeploySuccessCount(): Updates the number of successful undeploys.
-  updateUndeployFailureCount(): Updates the number of failed undeploys.

Decision Counts
+++++++++++++++

-  updatePermitDecisionsCount(): Updates the number of permit decisions.
-  updateDenyDecisionsCount(): Updates the number of deny decisions.
-  updateIndeterminantDecisionsCount(): Updates the number of indeterminant decisions.
-  updateNotApplicableDecisionsCount(): Updates the number of not applicable decisions.
