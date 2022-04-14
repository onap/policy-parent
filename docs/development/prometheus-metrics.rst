.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _prometheus-metrics:

Monitoring Policy Framework Components via Prometheus
#####################################################

.. contents::
    :depth: 3

This page explains the prometheus metrics exposed by different Policy Framework components.

1. Context
==========
Collecting application metrics is the first step towards gaining insights into Policy Fwk services and infrastructure from point of view of Availability, Performance, Reliability and Scalability.

The goal of monitoring is to achieve the below operational needs:

1. Monitoring via dashboards: Provide visual aids to display health, key metrics for use by OPS.
2. Alerting: Something is broken, and the issue must be addressed immediately OR, something might break soon, and proactive measures are taken to avoid such a situation.
3. Conducting retrospective analysis: Rich information that is readily available to better troubleshoot issues.
4. Analyzing trends: How fast is it the usage growing? How is the incoming traffic like? Helps assess needs for scaling to meet forecasted demands.

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
The process uptime in seconds is available via *"process_uptime_seconds"*.

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

+-------------------------------------+-------------------------------------------------------------------------------------------------------------------+
| Metric name                         | Metric description                                                                                                |
+=====================================+===================================================================================================================+
| process_uptime_seconds              | Uptime of policy-api application in seconds.                                                                      |
+-------------------------------------+-------------------------------------------------------------------------------------------------------------------+
| http_server_requests_seconds_count  | A measure of success and failure counters. Total number of API requests by uri, REST method and response status   |
+-------------------------------------+-------------------------------------------------------------------------------------------------------------------+
| http_server_requests_seconds_sum    | A measure of latency. Time taken for an API request by uri, REST method and response status                       |
+-------------------------------------+-------------------------------------------------------------------------------------------------------------------+

Key metrics for Policy PAP
--------------------------
+-------------------------------------+-------------------------------------------------------------------------------------------------------------------+
| Metric name                         | Metric description                                                                                                |
+=====================================+===================================================================================================================+
| process_uptime_seconds              | Uptime of policy-pap application in seconds.                                                                      |
+-------------------------------------+-------------------------------------------------------------------------------------------------------------------+
| http_server_requests_seconds_count  | A measure of success and failure counters. Total number of API requests by uri, REST method and response status   |
+-------------------------------------+-------------------------------------------------------------------------------------------------------------------+
| http_server_requests_seconds_sum    | A measure of latency. Time taken for an API request by uri, REST method and response status                       |
+-------------------------------------+-------------------------------------------------------------------------------------------------------------------+
| pap_policy_deployments              | Custom counter for TOSCA policy deploy/undeploy operation by status.                                                   |
+-------------------------------------+-------------------------------------------------------------------------------------------------------------------+

Key metrics for APEX-PDP
------------------------

+---------------------------------------------+-----------------------------------------------------------------------------------------------------------+
| Metric name                                 | Metric description                                                                                        |
+=============================================+===========================================================================================================+
| process_start_time_seconds                  | Uptime of apex-pdp application in seconds                                                                 |
+---------------------------------------------+-----------------------------------------------------------------------------------------------------------+
| pdpa_policy_deployments_total               | Counter for TOSCA policy deploy/undeploy operation by status.                                             |
+---------------------------------------------+-----------------------------------------------------------------------------------------------------------+
| pdpa_policy_executions_total                | Counter for TOSCA policy execution by status.                                                             |
+---------------------------------------------+-----------------------------------------------------------------------------------------------------------+
| pdpa_engine_state                           | State of APEX engine                                                                                      |
+---------------------------------------------+-----------------------------------------------------------------------------------------------------------+
| pdpa_engine_last_start_timestamp_epoch      | Epoch timestamp of the instance when engine was last started to derive uptime from                        |
+---------------------------------------------+-----------------------------------------------------------------------------------------------------------+
| pdpa_engine_event_executions                | Counter for APEX event execution counter per engine thread                                                |
+---------------------------------------------+-----------------------------------------------------------------------------------------------------------+
| pdpa_engine_average_execution_time_seconds  | Average time taken to execute an APEX policy in seconds                                                   |
+---------------------------------------------+-----------------------------------------------------------------------------------------------------------+
| pdpa_engine_last_execution_time*            | Time taken to execute the last APEX policy in seconds represented as a histogram as a measure of latency  |
+---------------------------------------------+-----------------------------------------------------------------------------------------------------------+

Key metrics for Drools PDP
--------------------------

Key metrics for XACML PDP
-------------------------

Key metrics for Policy Distribution
-----------------------------------
