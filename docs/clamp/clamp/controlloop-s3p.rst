.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _controlloop-s3p-label:

.. toctree::
   :maxdepth: 2

Policy Clamp Controlloop component
~~~~~~~~~~~~~~~~~~~~

Both the Performance and the Stability tests were executed by performing requests
against controlloop components installed as docker images in local environment.

Setup Details
+++++++++++++

- Controlloop runtime component docker image is started and running.
- Participant docker images policy-clamp-cl-pf-ppnt, policy-clamp-cl-http-ppnt, policy-clamp-cl-k8s-ppnt are started and running.
- Dmaap simulator for communication between components.
- mariadb docker container for policy and controlloop database.
- policy-api for communication between policy participant and policy-framework
- Both tests were run via jMeter, which was installed on a separate VM.

Stability Test of Controlloop components
++++++++++++++++++++++++++++++++++++++++

Test Plan
---------
The 72 hours stability test ran the following steps sequentially in a single threaded loop.

- **Create Policy defaultDomain** - creates an operational policy using policy/api component
- **Delete Policy sampleDomain** - deletes the operational policy sampleDomain using policy/api component
- **Commission Contorlloop definition** - commissions the controlloop definition in runtime
- **Instantiate controlloop** - Instantiate the controlloop towards participants
- **Check controlloop state** - check the current state of controlloop
- **Change State to PASSIVE** - change the state of the controlloop to PASSIVE
- **Check controlloop state** - check the current state of controlloop
- **Change State to UNINITIALISED** - change the state of the controloop to UNINITIALISED
- **Check controlloop state** - check the current state of controlloop
- **Delete instantiated controlloop** - delete the instantiated controlloop from all participants
- **Delete ControlLoop Definition** - delete the controlloop definition on runtime

The following steps can be used to configure the parameters of test plan.

- **HTTP Authorization Manager** - used to store user/password authentication details.
- **HTTP Header Manager** - used to store headers which will be used for making HTTP requests.
- **User Defined Variables** -  used to store following user defined parameters.

===========   ===================================================================
 **Name**      **Description**
===========   ===================================================================
 RUNTIME_HOST IP Address or host name of controlloop runtime component
 RUNTIME_PORT Port number of controlloop runtime components for making REST API calls
 POLICY_PARTICIPANT_HOST IP Address or host name of policy participant
 POLICY_PARTICIPANT_HOST_PORT Port number of policy participant
===========   ===================================================================

The test was run in the background via "nohup", to prevent it from being interrupted:

.. code-block:: bash

    nohup ./jMeter/apache-jmeter-5.2.1/bin/jmeter -n -t stability.jmx -l testresults.jtl

Test Results
------------

**Summary**

Stability test plan was triggered for 72 hours.

.. Note::

              .. container:: paragraph

                  The assertions of state changes are not completely taken care of, as the stability is ran with controlloop componenets
                  alone, and not including complete policy framework deployment, which makes it difficult for actual state changes from
                  PASSIVE to RUNNING etc to happen.

**Test Statistics**

=======================  =================  ==================  ==================================
**Total # of requests**  **Success %**      **Error %**         **Average time taken per request**
=======================  =================  ==================  ==================================
99992                    100.00 %           0.00 %              192 ms
=======================  =================  ==================  ==================================

**Controloop component Setup**

================ =======================                            ==================                              ==========================
**CONTAINER ID**  **IMAGE**                                             **PORTS**                                     **NAMES**
================ =======================  ==================        ==================================              ==========================
 a9cb0cd103cf   onap/policy-clamp-cl-runtime:latest                     6969/tcp                                      policy-clamp-cl-runtime
 886e572b8438   onap/policy-clamp-cl-pf-ppnt:latest                     6973/tcp                                      policy-clamp-cl-pf-ppnt
 035707b1b95f   nexus3.onap.org:10001/onap/policy-api:latest            6969/tcp                                      policy-api
 d34204f95ff3   onap/policy-clamp-cl-http-ppnt:latest                   6971/tcp                                      policy-clamp-cl-http-ppnt
 4470e608c9a8   onap/policy-clamp-cl-k8s-ppnt:latest                    6972/tcp, 8083/tcp                            policy-clamp-cl-k8s-ppnt
 62229d46b79c   nexus3.onap.org:10001/onap/policy-models-simulator:latest 3905/tcp, 6666/tcp, 6668-6670/tcp, 6680/tcp simulator
 efaf0ca5e1f0   nexus3.onap.org:10001/mariadb:10.5.8                    3306/tcp                                      mariadb
=======================  =================  ==================  ======================================              ===========================

.. Note::

              .. container:: paragraph

                  There were no failures during the 72 hours test.

**JMeter Screenshot**

.. image:: images/controlloop_stability_jmeter.PNG

**JMeter Screenshot**

.. image:: images/controlloop_stability_table.PNG

**Memory and CPU usage**

The memory and CPU usage can be monitored by running "docker stats" command. A snapshot is taken before and after test execution to monitor the changes in resource utilization.

Memory and CPU usage before test execution:

.. image:: images/Stability_before_stats.PNG

Memory and CPU usage after test execution:

.. image:: images/Stability_after_stats.PNG


Performance Test of Controlloop components
++++++++++++++++++++++++++++++++++++++++++

Introduction
------------

Performance test of Controlloop components has the goal of testing the min/avg/max processing time and rest call throughput for all the requests with multiple requests at the same time.

Setup Details
-------------

The performance test is performed on a similar setup as Stability test. The JMeter VM will be sending a large number of REST requests to the runtime component and collecting the statistics.


Test Plan
---------

Performance test plan is the same as the stability test plan above except for the few differences listed below.

- Increase the number of threads up to 5 (simulating 5 users' behaviours at the same time).
- Reduce the test time to 2 hours.

Run Test
--------

Running/Triggering the performance test will be the same as the stability test. That is, launch JMeter pointing to corresponding *.jmx* test plan. The *RUNTIME_HOST*, *RUNTIME_PORT*, *POLICY_PARTICIPANT_HOST*, *POLICY_PARTICIPANT_HOST_PORT* are already set up in *.jmx*

.. code-block:: bash

    nohup ./jMeter/apache-jmeter-5.2.1/bin/jmeter -n -t performance.jmx -l testresults.jtl

Once the test execution is completed, execute the below script to get the statistics:

.. code-block:: bash

    $ cd ./clamp/testsuites/performance/src/main/resources/testplans
    $ ./results.sh resultTree.log

Test Results
------------

Test results are shown as below.

**Test Statistics**

=======================  =================  ==================  ==================================
**Total # of requests**  **Success %**      **Error %**         **Average time taken per request**
=======================  =================  ==================  ==================================
13809                    100 %              0.00 %              206 ms
=======================  =================  ==================  ==================================

**Controloop component Setup**

================ =======================                            ==================                              ==========================
**CONTAINER ID**  **IMAGE**                                             **PORTS**                                     **NAMES**
================ =======================  ==================        ==================================              ==========================
 a9cb0cd103cf   onap/policy-clamp-cl-runtime:latest                     6969/tcp                                      policy-clamp-cl-runtime
 886e572b8438   onap/policy-clamp-cl-pf-ppnt:latest                     6973/tcp                                      policy-clamp-cl-pf-ppnt
 035707b1b95f   nexus3.onap.org:10001/onap/policy-api:latest            6969/tcp                                      policy-api
 d34204f95ff3   onap/policy-clamp-cl-http-ppnt:latest                   6971/tcp                                      policy-clamp-cl-http-ppnt
 4470e608c9a8   onap/policy-clamp-cl-k8s-ppnt:latest                    6972/tcp, 8083/tcp                            policy-clamp-cl-k8s-ppnt
 62229d46b79c   nexus3.onap.org:10001/onap/policy-models-simulator:latest 3905/tcp, 6666/tcp, 6668-6670/tcp, 6680/tcp simulator
 efaf0ca5e1f0   nexus3.onap.org:10001/mariadb:10.5.8                    3306/tcp                                      mariadb
=======================  =================  ==================  ======================================              ===========================

**JMeter Screenshot**

.. image:: images/cl-s3p-performance-result-jmeter.PNG
