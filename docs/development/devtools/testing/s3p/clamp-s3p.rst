.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _acm-s3p-label:

.. toctree::
   :maxdepth: 2

Policy Clamp Automation Composition
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Both the Performance and the Stability tests were executed by performing requests
against acm components installed as docker images in local environment. These tests we all
performed on a Ubuntu VM with 32GB of memory, 16 CPU and 50GB of disk space.


ACM Deployment
++++++++++++++

In an effort to allow the execution of the s3p tests to be as close to automatic as possible,
a script will be executed that will perform the following:

- Install of a microk8s kubernetes environment
- Bring up the policy components
- Checks that the components are successfully up and running before proceeding
- Install Java 17
- Install Jmeter locally and configure it
- Specify whether you want to run stability or performance tests


The remainder of this document outlines how to run the tests and the test results

Common Setup
++++++++++++
The common setup for performance and stability tests is now automated - being carried out by a script in- **testsuites/run-s3p-test.sh**.

Clone the policy-clamp repo to access the test scripts

.. code-block:: sh

    git clone https://gerrit.onap.org/r/policy/clamp

Stability Test of acm components
++++++++++++++++++++++++++++++++

Test Plan
---------
The 72 hours stability test ran the following steps sequentially in a single threaded loop.

- **Commission Automation Composition Definitions** - Commissions the ACM Definitions
- **Register Participants** - Registers the presence of participants in the acm database
- **Prime AC definition** - Primes the AC Definition to the participants
- **Instantiate acm** - Instantiate the acm instance
- **DEPLOY the ACM instance** - change the state of the acm to DEPLOYED
- **Check instance state** - check the current state of instance and that it is DEPLOYED
- **UNDEPLOY the ACM instance** - change the state of the ACM to UNDEPLOYED
- **Check instance state** - check the current state of instance and that it is UNDEPLOYED
- **Delete instance** - delete the instance from all participants and ACM db
- **DEPRIME ACM definitions** - DEPRIME ACM definitions from participants
- **Delete ACM Definition** - delete the ACM definition on runtime

This runs for 72 hours. Test results are present in the **testsuites/automated-performance/s3pTestResults.jtl**
directory. Logs are present for jmeter in **testsuites/automated-performance/jmeter.log** and
**testsuites/automated-performance/nohup.out**

Run Test
--------

The code in the setup section also serves to run the tests. Just one execution needed to do it all.

.. code-block:: sh

    ./run-s3p-test.sh run stability

Once the test execution is completed, the results are present in the **automate-performance/s3pTestResults.jtl** file.

This file can be imported into the Jmeter GUI for visualization. The below results are tabulated from the GUI.

Test Results
------------

**Summary**

Stability test plan was triggered for 72 hours.

**Test Statistics**

=======================  =================  ==================  ==================================
**Total # of requests**  **Success %**      **Error %**         **Average time taken per request**
=======================  =================  ==================  ==================================
261852                    100.00 %           0.00 %              387.126 ms
=======================  =================  ==================  ==================================

**ACM component Setup**

==============================================  ==================================================================  ====================
**NAME**                                        **IMAGE**                                                            **PORT**
==============================================  ==================================================================  ====================
 zookeeper-deployment-7ff87c7fcc-ptkwv          confluentinc/cp-zookeeper:latest                                     2181/TCP
 kafka-deployment-5c87d497b-2jv27               confluentinc/cp-kafka:latest                                         9092/TCP
 policy-models-simulator-6947667bdc-v4czs       nexus3.onap.org:10001/onap/policy-models-simulator:latest            3904:30904/TCP
 prometheus-f66f97b6-rknvp                      nexus3.onap.org:10001/prom/prometheus:latest                         9090:30909/TCP
 mariadb-galera-0                               nexus3.onap.org:10001/bitnami/mariadb-galera:10.5.8                  3306/TCP
 policy-apex-pdp-0                              nexus3.onap.org:10001/onap/policy-apex-pdp:3.1.3-SNAPSHOT            6969:30001/TCP
 policy-clamp-ac-http-ppnt-7d747b5d98-4phjf     nexus3.onap.org:10001/onap/policy-clamp-ac-http-ppnt7.1.3-SNAPSHOT   8084/TCP
 policy-clamp-ac-sim-ppnt-97f487577-4p7ks       nexus3.onap.org:10001/onap/policy-clamp-ac-sim-ppnt7.1.3-SNAPSHOT    6969/TCP
 policy-clamp-ac-k8s-ppnt-6bbd86bbc6-csknn      nexus3.onap.org:10001/onap/policy-clamp-ac-k8s-ppnt7.1.3-SNAPSHOT    8083:30443/TCP
 policy-clamp-ac-pf-ppnt-5fcbbcdb6c-twkxw       nexus3.onap.org:10001/onap/policy-clamp-ac-pf-ppnt7.1.3-SNAPSHOT     6969:30008/TCP
 policy-clamp-runtime-acm-66b5d6b64-4gnth       nexus3.onap.org:10001/onap/policy-clamp-runtime-acm7.1.3-SNAPSHOT    6969:30007/TCP
 policy-pap-f7899d4cd-7m898                     nexus3.onap.org:10001/onap/policy-pap:3.1.3-SNAPSHOT                 6969:30003/TCP
 policy-api-7f7d995b4-ckb84                     nexus3.onap.org:10001/onap/policy-api:3.1.3-SNAPSHOT                 6969:30002/TCP
==============================================  ==================================================================  ====================



.. Note::

              .. container:: paragraph

                  There were no failures during the 72 hours test.

**JMeter Screenshot**

.. image:: clamp-s3p-results/acm_stability_jmeter.png

**JMeter Screenshot**

.. image:: clamp-s3p-results/acm_stability_table.png


Performance Test of acm components
++++++++++++++++++++++++++++++++++

Introduction
------------

Performance test of acm components has the goal of testing the min/avg/max processing time and rest call throughput for all the requests with multiple requests at the same time.

Setup Details
-------------

We can setup the environment and execute the tests like this from the **clamp/testsuites** directory

.. code-block:: sh

    ./run-s3p-test.sh run performance

Test results are present in the **testsuites/automate-performance/s3pTestResults.jtl**
directory. Logs are present for jmeter in **testsuites/automate-performance/jmeter.log** and
**testsuites/automated-performance/nohup.out**

Test Plan
---------

The Performance test ran the following steps sequentially by 5 threaded users. Any user will create 100 compositions/instances.

- **SetUp** - SetUp Thread Group
   - **Register Participants** - Registers the presence of participants in the acm database
- **AutomationComposition Test Flow** - flow by 5 threaded users.
   - **Creation and Deploy** - Creates 100 Compositions and Instances
      - **Commission Automation Composition Definitions** - Commissions the ACM Definitions
      - **Prime AC definition** - Primes the AC Definition to the participants
      - **Instantiate acm** - Instantiate the acm instance
      - **DEPLOY the ACM instance** - change the state of the acm to DEPLOYED
      - **Check instance state** - check the current state of instance and that it is DEPLOYED
   - **Get participants** - fetch all participants
   - **Get compositions** - fetch all compositions
   - **Undeploy and Delete** - Deletes instances and Compositions created before
      - **UNDEPLOY the ACM instance** - change the state of the ACM to UNDEPLOYED
      - **Check instance state** - check the current state of instance and that it is UNDEPLOYED
      - **Delete instance** - delete the instance from all participants and ACM db
      - **DEPRIME ACM definitions** - DEPRIME ACM definitions from participants
      - **Delete ACM Definition** - delete the ACM definition on runtime

Run Test
--------

The code in the setup section also serves to run the tests. Just one execution needed to do it all.

.. code-block:: sh

    ./run-s3p-test.sh run performance

Once the test execution is completed, the results are present in the **automate-performance/s3pTestResults.jtl** file.

This file can be imported into the Jmeter GUI for visualization. The below results are tabulated from the Jmeter GUI.

Test Results
------------

Test results are shown as below.

**Test Statistics**

=======================  =================  ==================  ==================================
**Total # of requests**  **Success %**      **Error %**         **Average time taken per request**
=======================  =================  ==================  ==================================
8624                     100 %              0.00 %              1296.8 ms
=======================  =================  ==================  ==================================

**ACM component Setup**

==============================================  ==================================================================  ====================
**NAME**                                        **IMAGE**                                                            **PORT**
==============================================  ==================================================================  ====================
 zookeeper-deployment-7ff87c7fcc-5svgw          confluentinc/cp-zookeeper:latest                                     2181/TCP
 kafka-deployment-5c87d497b-hmbhc               confluentinc/cp-kafka:latest                                         9092/TCP
 policy-models-simulator-6947667bdc-crcwq       nexus3.onap.org:10001/onap/policy-models-simulator:latest            3904:30904/TCP
 prometheus-f66f97b6-24dvx                      nexus3.onap.org:10001/prom/prometheus:latest                         9090:30909/TCP
 mariadb-galera-0                               nexus3.onap.org:10001/bitnami/mariadb-galera:10.5.8                  3306/TCP
 policy-apex-pdp-0                              nexus3.onap.org:10001/onap/policy-apex-pdp:3.1.3-SNAPSHOT            6969:30001/TCP
 policy-clamp-ac-sim-ppnt-97f487577-pn56t       nexus3.onap.org:10001/onap/policy-clamp-ac-sim-ppnt7.1.3-SNAPSHOT    6969/TCP
 policy-clamp-ac-http-ppnt-7d747b5d98-qjjlv     nexus3.onap.org:10001/onap/policy-clamp-ac-http-ppnt7.1.3-SNAPSHOT   8084/TCP
 policy-clamp-ac-k8s-ppnt-6bbd86bbc6-ffbz2      nexus3.onap.org:10001/onap/policy-clamp-ac-k8s-ppnt7.1.3-SNAPSHOT    8083:30443/TCP
 policy-clamp-ac-pf-ppnt-5fcbbcdb6c-vmsnv       nexus3.onap.org:10001/onap/policy-clamp-ac-pf-ppnt7.1.3-SNAPSHOT     6969:30008/TCP
 policy-clamp-runtime-acm-66b5d6b64-6vjl5       nexus3.onap.org:10001/onap/policy-clamp-runtime-acm7.1.3-SNAPSHOT    6969:30007/TCP
 policy-pap-f7899d4cd-8sjk9                     nexus3.onap.org:10001/onap/policy-pap:3.1.3-SNAPSHOT                 6969:30003/TCP
 policy-api-7f7d995b4-dktdw                     nexus3.onap.org:10001/onap/policy-api:3.1.3-SNAPSHOT                 6969:30002/TCP
==============================================  ==================================================================  ====================

**JMeter Screenshot**

.. image:: clamp-s3p-results/acm_performance_jmeter.png
