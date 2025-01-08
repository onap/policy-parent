.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _prometheus-metrics:

Prometheus Metrics support in Policy Framework Components
#########################################################

.. contents::
    :depth: 3

This page explains the prometheus metrics exposed by different Policy Framework components.


1. Context
==========

Collecting application metrics is the first step towards gaining insights into Policy Fwk services and infrastructure from point of view of Availability, Performance, Reliability and Scalability.

The goal of monitoring is to achieve the below operational needs:

1. Monitoring via dashboards: Provide visual aids to display health, key metrics for use by Operations.
2. Alerting: Something is broken, and the issue must be addressed immediately OR, something might break soon, and proactive measures are taken to avoid such a situation.
3. Conducting retrospective analysis: Rich information that is readily available to better troubleshoot issues.
4. Analyzing trends: How fast is the usage growing? How is the incoming traffic like? Helps assess needs for scaling to meet forecasted demands.

The principles outlined in the `Four Golden Signals <https://sre.google/sre-book/monitoring-distributed-systems/#xref_monitoring_golden-signals>`__ developed by Google Site Reliability Engineers has been adopted to define the key metrics for Policy Framework.

- Request Rate: # of requests per second as served by Policy services.
- Event Processing rate: # of requests/events per second as processed by the PDPs.
- Errors: # of those requests/events processed that are failing.
- Latency/Duration: Amount of time those requests take, and for PDPs relevant metrics for event processing times.
- Saturation: Measures the degree of fullness or % utilization of a service emphasizing the resources that are most constrained: CPU, Memory, I/O, custom metrics by domain.


2. Policy Framework Key metrics
===============================

System Metrics common across all Policy components
--------------------------------------------------

These standard metrics are available and exposed via a Prometheus endpoint since Istanbul release and can be categorized as below:

CPU Usage
*********

CPU usage percentage can be derived *"system_cpu_usage"* for springboot applications and *"process_cpu_seconds_total* for non springboot applications using `PromQL <https://prometheus.io/docs/prometheus/latest/querying/basics/>`__ .

Process uptime
**************

The process uptime in seconds is available via *"process_uptime_seconds"* for springboot applications or *"process_start_time_seconds"* otherwise.

Status of the applications is available via the standard *"up"* metric.

JVM memory metrics
******************

These metrics begin with the prefix *"jvm_memory_"*.
There is a lot of data here however, one of the key metric to monitor would be the total heap memory usage, *E.g. sum(jvm_memory_used_bytes{area="heap"})*.

`PromQL <https://prometheus.io/docs/prometheus/latest/querying/basics/>`__ can be leveraged to represent the total or rate of memory usage.

JVM thread metrics
******************

These metrics begin with the prefix *"jvm_threads_"*. Some of the key data to monitor for are:

- *"jvm_threads_live_threads"* (springboot apps), or *"jvm_threads_current"* (non springboot) shows the total number of live threads, including daemon and non-daemon threads
- *"jvm_threads_peak_threads"* (springboot apps), or *"jvm_threads_peak"* (non springboot) shows the peak total number of threads since the JVM started
- *"jvm_threads_states_threads"* (springboot apps), or *"jvm_threads_state"* (non springboot) shows number of threads by thread state

JVM garbage collection metrics
******************************

There are many garbage collection metrics, with prefix *"jvm_gc_"* available to get deep insights into how the JVM is managing memory. They can be broadly categorized into:

- Pause duration *"jvm_gc_pause_"* for springboot applications gives us information about how long GC took. For non springboot application, the collection duration metrics *"jvm_gc_collection_"* provide the same information.
- Memory pool size increase can be assessed using *"jvm_gc_memory_allocated_bytes_total"* and *"jvm_gc_memory_promoted_bytes_total"* for springboot applications.

Average garbage collection time and rate of garbage collection per second are key metrics to monitor.


Key metrics for Policy API
--------------------------

+-------------------------------------+----------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Metric name                         | Metric description                                                                                 | Metric labels                                                                                                                                                         |
+=====================================+====================================================================================================+=======================================================================================================================================================================+
| process_uptime_seconds              | Uptime of policy-api application in seconds.                                                       |                                                                                                                                                                       |
+-------------------------------------+----------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| http_server_requests_seconds_count  | Number of API requests filtered by uri, REST method and response status among other labels         | "exception": any exception string; "method": REST method used; "outcome": response status string; "status": http response status code; "uri": REST endpoint invoked   |
+-------------------------------------+----------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| http_server_requests_seconds_sum    | Time taken for an API request filtered by uri, REST method and response status among other labels  | "exception": any exception string; "method": REST method used; "outcome": response status string; "status": http response status code; "uri": REST endpoint invoked   |
+-------------------------------------+----------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Key metrics for Policy PAP
--------------------------

+-------------------------------------+----------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Metric name                         | Metric description                                                                                 | Metric labels                                                                                                                                                         |
+=====================================+====================================================================================================+=======================================================================================================================================================================+
| process_uptime_seconds              | Uptime of policy-pap application in seconds.                                                       |                                                                                                                                                                       |
+-------------------------------------+----------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| http_server_requests_seconds_count  | Number of API requests filtered by uri, REST method and response status among other labels         | "exception": any exception string; "method": REST method used; "outcome": response status string; "status": http response status code; "uri": REST endpoint invoked   |
+-------------------------------------+----------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| http_server_requests_seconds_sum    | Time taken for an API request filtered by uri, REST method and response status among other labels  | "exception": any exception string; "method": REST method used; "outcome": response status string; "status": http response status code; "uri": REST endpoint invoked   |
+-------------------------------------+----------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| pap_policy_deployments              | Number of TOSCA policy deploy/undeploy operations                                                  | "operation": Possibles values are deploy, undeploy; "status": Deploy/Undeploy status values - SUCCESS, FAILURE, TOTAL                                                 |
+-------------------------------------+----------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Key metrics for APEX-PDP
------------------------

+---------------------------------------------+-------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| Metric name                                 | Metric description                                                                  | Metric labels                                                                                                        |
+=============================================+=====================================================================================+======================================================================================================================+
| process_start_time_seconds                  | Uptime of apex-pdp application in seconds                                           |                                                                                                                      |
+---------------------------------------------+-------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| pdpa_policy_deployments_total               | Number of TOSCA policy deploy/undeploy operations                                   | "operation": Possibles values are deploy, undeploy; "status": Deploy/Undeploy status values - SUCCESS, FAILURE, TOTAL|
+---------------------------------------------+-------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| pdpa_policy_executions_total                | Number of TOSCA policy executions                                                   | "status": Execution status values - SUCCESS, FAILURE, TOTAL"                                                         |
+---------------------------------------------+-------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| pdpa_engine_state                           | State of APEX engine                                                                | "engine_instance_id": ID of the engine thread                                                                        |
+---------------------------------------------+-------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| pdpa_engine_last_start_timestamp_epoch      | Epoch timestamp of the instance when engine was last started to derive uptime from  | "engine_instance_id": ID of the engine thread                                                                        |
+---------------------------------------------+-------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| pdpa_engine_event_executions                | Number of APEX event execution counter per engine thread                            | "engine_instance_id": ID of the engine thread                                                                        |
+---------------------------------------------+-------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| pdpa_engine_average_execution_time_seconds  | Average time taken to execute an APEX policy in seconds                             | "engine_instance_id": ID of the engine thread                                                                        |
+---------------------------------------------+-------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+

Key metrics for XACML PDP
-------------------------

+--------------------------------+---------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Metric name                    | Metric description                                | Metric labels                                                                                                                                                                                                                |
+================================+===================================================+==============================================================================================================================================================================================================================+
| process_start_time_seconds     | Uptime of policy-pap application in seconds.      |                                                                                                                                                                                                                              |
+--------------------------------+---------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| pdpx_policy_deployments_total  | Counts the total number of deployment operations  | "operation": Possible values are deploy, undeploy                                                                                                                                                                            |
+--------------------------------+---------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| pdpx_policy_decisions_total    | Counts the total number of decisions              | "application": Possible values are Monitoring, Guard, Optimization, Naming, Native, Match;                                                                                                                                   |
|                                |                                                   | "status": Possible values are permit, deny, indeterminant, not_applicable                                                                                                                                                    |
+--------------------------------+---------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| logback_appender_total         | Counts the log entries                            | level: Counts on a per log level basis.                                                                                                                                                                                      |
+--------------------------------+---------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Key metrics for Drools PDP
--------------------------

+-----------------------------------------------+-------------------------------------------------------+-------------------------------------------------------+
| Metric name                                   | Metric description                                    |Metric labels                                          |
+===============================================+=======================================================+=======================================================+
| process_start_time_seconds                    | Uptime of policy-drools-pdp component in seconds.     |                                                       |
+-----------------------------------------------+-------------------------------------------------------+-------------------------------------------------------+
| pdpd_policy_deployments_total                 | Count of policy deployments                           | operation: deploy|undeploy, status: SUCCESS|FAILURE   |
+-----------------------------------------------+-------------------------------------------------------+-------------------------------------------------------+
| pdpd_policy_executions_latency_seconds_count  | Count of policy executions                            | controller, controlloop, policy                       |
+-----------------------------------------------+-------------------------------------------------------+-------------------------------------------------------+
| pdpd_policy_executions_latency_seconds_sum    | Count of policy execution latency in seconds          | controller, controlloop, policy                       |
+-----------------------------------------------+-------------------------------------------------------+-------------------------------------------------------+
| logback_appender_total                        | Count of log entries                                  | level                                                 |
+-----------------------------------------------+-------------------------------------------------------+-------------------------------------------------------+

Key metrics for Policy Distribution
-----------------------------------

+------------------------------------+-------------------------------------------------------+
| Metric name                        | Metric description                                    |
+====================================+=======================================================+
| total_distribution_received_count  | Total number of distribution received                 |
+------------------------------------+-------------------------------------------------------+
| distribution_success_count         | Total number of distribution successfully processed   |
+------------------------------------+-------------------------------------------------------+
| distribution_failure_count         | Total number of distribution failures                 |
+------------------------------------+-------------------------------------------------------+
| total_download_received_count      | Total number of download received                     |
+------------------------------------+-------------------------------------------------------+
| download_success_count             | Total number of download successfully processed       |
+------------------------------------+-------------------------------------------------------+
| download_failure_count             | Total number of download failures                     |
+------------------------------------+-------------------------------------------------------+


3. OOM changes to enable prometheus monitoring for Policy Framework
===================================================================

Policy Framework uses ServiceMonitor custom resource definition (CRD) to allow Prometheus to monitor the services it exposes. Label selection is used to determine which services are selected to be monitored.
For label management and troubleshooting refer to the documentation at: `Prometheus operator <https://github.com/prometheus-operator/prometheus-operator/tree/main/Documentation>`__.

`OOM charts <https://github.com/onap/oom/tree/master/kubernetes/policy/components>`__ for policy include ServiceMonitor and properties can be overwritten based on the deployment specifics.
