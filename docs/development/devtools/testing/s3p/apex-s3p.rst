.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _apex-s3p-label:

.. toctree::
   :maxdepth: 2

Policy APEX PDP component
~~~~~~~~~~~~~~~~~~~~~~~~~

Both the Stability and the Performance tests were executed in a full ONAP OOM deployment in Nordix lab.

Setup Details
+++++++++++++

Deploying ONAP using OOM
------------------------

APEX-PDP along with all policy components are deployed as part of a full ONAP OOM deployment.
At a minimum, the following ONAP components are needed: policy, mariadb-galera, aai, cassandra, aaf, and dmaap.

Before deploying, the values.yaml files are changed to use NodePort instead of ClusterIP for policy-api,
policy-pap, and policy-apex-pdp, so that they are accessible from jmeter::

  policy-apex-pdp              NodePort    10.43.131.43    <none>        6969:31739/TCP
  policy-api                   NodePort    10.43.67.153    <none>        6969:30430/TCP
  policy-pap                   NodePort    10.43.200.57    <none>        6969:30585/TCP

The node ports (31739, 30430 and 30585 above) are used in JMeter.
The HOSTNAMEs for JMeter are set to the IPs returned by running "kubectl get node -o wide"
and to find the applications for each node by running "kubectl describe node <node-name>".

Set up policy-models-simulator
------------------------------

Policy-models-simulator is deployed to use CDS and DMaaP simulators during policy execution.
    Simulator configurations used are available in apex-pdp repository:
      testsuites/apex-pdp-stability/src/main/resources/simulatorConfig/

It is run as a docker image from a node accessible to the kubernetes cluster::

  docker run -d --rm --publish 6680:6680 --publish 31054:3905 \
    --volume "apex-pdp/testsuites/apex-pdp-stability/src/main/resources/simulatorConfig:/opt/app/policy/simulators/etc/mounted" \
    nexus3.onap.org:10001/onap/policy-models-simulator:2.7-SNAPSHOT-latest

The published ports 6680 and 31054 are used in JMeter for CDS and DMaaP simulators.

Creation of VNF & PNF in AAI
----------------------------

In order for APEX-PDP engine to fetch the resource details from AAI during runtime execution, we need to create dummy
VNF & PNF entities in AAI. In a real control loop flow, the entities in AAI will be either created during orchestration
phase or provisioned in AAI separately.

Download & execute the steps in postman collection for creating the entities along with it’s dependencies.
The steps needs to be performed sequentially one after another. And no input is required from user.

:download:`Create VNF & PNF in AAI for Apex S3P  </development/devtools/postman/create-vnf-pnf-aai-for-apex-s3p.postman_collection.json>`

Make sure to skip the delete VNF & PNF steps.

JMeter Tests
------------

Two APEX policies are executed in the APEX-PDP engine, and are triggered by multiple threads during the tests.
Both tests were run via jMeter.

    Stability test script is available in apex-pdp repository:
      testsuites/apex-pdp-stability/src/main/resources/apexPdpStabilityTestPlan.jmx

    Performance test script is available in apex-pdp repository:
      testsuites/performance/performance-benchmark-test/src/main/resources/apexPdpPerformanceTestPlan.jmx

.. Note::
   Policy executions are validated in a stricter fashion during the tests.
   There are test cases where up to 80 events are expected on the DMaaP topic.
   DMaaP simulator is used to keep it simple and avoid any message pickup timing related issues.

Stability Test of APEX-PDP
++++++++++++++++++++++++++

Test Plan
---------

The 72 hours stability test ran the following steps.

Setup Phase
"""""""""""

Policies are created and deployed to APEX-PDP during this phase. Only one thread is in action and this step is done only once.

- **Create Policy onap.policies.apex.Simplecontrolloop** - creates the first APEX policy using policy/api component.
      This is a sample policy used for PNF testing.
- **Create Policy onap.policies.apex.Example** - creates the second APEX policy using policy/api component.
      This is a sample policy used for VNF testing.
- **Deploy Policies** - Deploy both the policies created to APEX-PDP using policy/pap component

Main Phase
""""""""""

Once the policies are created and deployed to APEX-PDP by the setup thread, five threads execute the below tests for 72 hours.

- **Healthcheck** - checks the health status of APEX-PDP
- **Prometheus Metrics** - checks that APEX-PDP is exposing prometheus metrics
- **Test Simplecontrolloop policy success case** - Send a trigger event to *unauthenticated.DCAE_CL_OUTPUT* DMaaP topic.
    If the policy execution is successful, 3 different notification events are sent to *APEX-CL-MGT* topic by each one of the 5 threads.
    So, it is checked if 15 notification messages are received in total on *APEX-CL-MGT* topic with the relevant messages.
- **Test Simplecontrolloop policy failure case** - Send a trigger event with invalid pnfName to *unauthenticated.DCAE_CL_OUTPUT* DMaaP topic.
    The policy execution is expected to fail due to AAI failure response. 2 notification events are expected on *APEX-CL-MGT* topic by a thread in this case.
    It is checked if 10 notification messages are received in total on *APEX-CL-MGT* topic with the relevant messages.
- **Test Example policy success case** - Send a trigger event to *unauthenticated.DCAE_POLICY_EXAMPLE_OUTPUT* DMaaP topic.
    If the policy execution is successful, 4 different notification events are sent to *APEX-CL-MGT* topic by each one of the 5 threads.
    So, it is checked if 20 notification messages are received in total on *APEX-CL-MGT* topic with the relevant messages.
- **Test Example policy failure case** - Send a trigger event with invalid vnfName to *unauthenticated.DCAE_POLICY_EXAMPLE_OUTPUT* DMaaP topic.
    The policy execution is expected to fail due to AAI failure response. 2 notification events are expected on *APEX-CL-MGT* topic by a thread in this case.
    So, it is checked if 10 notification messages are received in total on *APEX-CL-MGT* topic with the relevant messages.
- **Clean up DMaaP notification topic** - DMaaP notification topic which is *APEX-CL-MGT* is cleaned up after each test to make sure that one failure doesn't lead to cascading errors.


Teardown Phase
""""""""""""""

Policies are undeployed from APEX-PDP and deleted during this phase.
Only one thread is in action and this step is done only once after the Main phase is complete.

- **Undeploy Policies** - Undeploy both the policies from APEX-PDP using policy/pap component
- **Delete Policy onap.policies.apex.Simplecontrolloop** - delete the first APEX policy using policy/api component.
- **Delete Policy onap.policies.apex.Example** - delete the second APEX policy also using policy/api component.

Test Configuration
------------------

The following steps can be used to configure the parameters of test plan.

- **HTTP Authorization Manager** - used to store user/password authentication details.
- **HTTP Header Manager** - used to store headers which will be used for making HTTP requests.
- **User Defined Variables** - used to store following user defined parameters.

===================  ===============================================================================
 **Name**            **Description**
===================  ===============================================================================
 HOSTNAME            IP Address or host name to access the components
 PAP_PORT            Port number of PAP for making REST API calls such as deploy/undeploy of policy
 API_PORT            Port number of API for making REST API calls such as create/delete of policy
 APEX_PORT           Port number of APEX for making REST API calls such as healthcheck/metrics
 SIM_HOST            IP Address or hostname running policy-models-simulator
 DMAAP_PORT          Port number of DMaaP simulator for making REST API calls such as reading notification events
 CDS_PORT            Port number of CDS simulator
 wait                Wait time if required after a request (in milliseconds)
 threads             Number of threads to run test cases in parallel
 threadsTimeOutInMs  Synchronization timer for threads running in parallel (in milliseconds)
===================  ===============================================================================

Run Test
--------

The test was run in the background via "nohup", to prevent it from being interrupted:

.. code-block:: bash

    nohup ./apache-jmeter-5.4.3/bin/jmeter.sh -n -t apexPdpStabilityTestPlan.jmx -l stabilityTestResults.jtl

Test Results
------------

**Summary**

Stability test plan was triggered for 72 hours. There were no failures during the 72 hours test.


**Test Statistics**

=======================  =================  ==================  ==================================
**Total # of requests**  **Success %**      **Error %**         **Average time taken per request**
=======================  =================  ==================  ==================================
430397                    100 %             0.00 %              151.694 ms
=======================  =================  ==================  ==================================

.. Note::

   There were no failures during the 72 hours test.

**JMeter Screenshot**

.. image:: apex-s3p-results/apex_stability_jmeter_results.png

**Memory and CPU usage**

The memory and CPU usage can be monitored by running "top" command in the APEX-PDP pod.
A snapshot is taken before and after test execution to monitor the changes in resource utilization.
Prometheus metrics is also collected before and after the test execution.

Memory and CPU usage before test execution:

.. image:: apex-s3p-results/apex_top_before_72h.png

:download:`Prometheus metrics before 72h test  <apex-s3p-results/apex_metrics_before_72h.txt>`

Memory and CPU usage after test execution:

.. image:: apex-s3p-results/apex_top_after_72h.png

:download:`Prometheus metrics after 72h test  <apex-s3p-results/apex_metrics_after_72h.txt>`

Performance Test of APEX-PDP
++++++++++++++++++++++++++++

Introduction
------------

Performance test of APEX-PDP is done similar to the stability test, but in a more extreme manner using higher thread count.

Setup Details
-------------

The performance test is performed on a similar setup as Stability test.


Test Plan
---------

Performance test plan is the same as the stability test plan above except for the few differences listed below.

- Increase the number of threads used in the Main Phase from 5 to 20.
- Reduce the test time to 2 hours.

Run Test
--------

.. code-block:: bash

    nohup ./apache-jmeter-5.4.3/bin/jmeter.sh -n -t apexPdpPerformanceTestPlan.jmx -l perftestresults.jtl


Test Results
------------

Test results are shown as below.

**Test Statistics**

=======================  =================  ==================  ==================================
**Total # of requests**  **Success %**      **Error %**         **Average time taken per request**
=======================  =================  ==================  ==================================
47567                    100 %              0.00 %              163.841 ms
=======================  =================  ==================  ==================================

**JMeter Screenshot**

.. image:: apex-s3p-results/apex_perf_jmeter_results.png

Summary
+++++++

Multiple policies were executed in a multi-threaded fashion for both stability and performance tests.
Both tests ran smoothly without any issues.
