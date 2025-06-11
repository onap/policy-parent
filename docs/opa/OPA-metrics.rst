.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

OPA PDP Metrics Overview
************************

This document provides a high-level overview of the metrics and statistics functionality implemented in the `policy-opa-pdp` service. The purpose of this module is to collect, manage, and expose operational metrics related to policy decisions and data handling within the OPA PDP (Policy Decision Point) system.

.. contents::
    :depth: 3

Purpose
^^^^^^^

      .. container:: sectionbody

         .. container:: paragraph

            The metrics module is designed to:
 
            - Track the success and failure of policy decisions.
            - Monitor deployment and undeployment operations.
            - Record dynamic data update outcomes.
            - Provide real-time statistics for observability and monitoring.
            - Integrate with Prometheus for metric collection and visualization.

Key Features
^^^^^^^^^^^^

      .. container:: sectionbody

         .. container:: paragraph

            1. **Metric Counters**
             - The system maintains internal counters for:
                - Decision successes and failures
                - Deployment and undeployment outcomes
                - Dynamic data update results
                - Total number of policies
                - General error occurrences

                .. csv-table::
                   :header: "/statistics"
                   :widths: 10

                   `Statistics Swagger <./local-swagger.html#tag/OPAPDPDecisionControllerv1>`_

            2. **Prometheus Integration**
             - The `policy-opa-pdp` service exposes several Prometheus-compatible metrics to support observability and performance monitoring. These metrics are automatically registered and can be scraped by Prometheus for visualization and alerting.
             - Below are some example metrics exposed by the service:
                 .. csv-table::
                    :header: "/metrics"
                    :widths: 10

                    `Prometheus Metrics <https://docs.onap.org/projects/onap-policy-parent/en/latest/development/prometheus-metrics.html#>`__.

.. container::
   :name: footer

   .. container::
      :name: footer-text

      1.0.0-SNAPSHOT
      Last updated 2025-03-27 16:04:24 IST
