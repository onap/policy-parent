.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _drools-s3p-label:

.. toctree::
   :maxdepth: 2

Policy Drools PDP component
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Both the Performance and the Stability tests were executed against a default ONAP installation in the policy-k8s tenant in the windriver lab, from an independent VM running the jmeter tool to inject the load.

General Setup
*************

The kubernetes installation allocated all policy components in the same worker node VM and some additional ones.
The worker VM hosting the policy components has the following spec:

- 16GB RAM
- 8 VCPU
- 160GB Ephemeral Disk

The standalone VM designated to run jmeter has the same configuration.  The jmeter JVM
was instantiated with a max heap configuration of 12G.

The drools-pdp container uses the default JVM memory settings from a default OOM installation:

.. code-block:: bash

    VM settings:
        Max. Heap Size (Estimated): 989.88M
        Using VM: OpenJDK 64-Bit Server VM


Other ONAP components used during the stability tests are:

- Policy XACML PDP to process guard queries for each transaction.
- DMaaP to carry PDP-D and jmeter initiated traffic to complete transactions.
- Policy API to create (and delete at the end of the tests) policies for each
  scenario under test.
- Policy PAP to deploy (and undeploy at the end of the tests) policies for each scenario under test.

The following components are simulated during the tests.

- SO actor for the vDNS use case.
- APPC responses for the vCPE and vFW use cases.
- AAI to answer queries for the use cases under test.

In order to avoid interferences with the APPC component while running the tests,
the APPC component was disabled.

SO, and AAI actors were simulated within the PDP-D JVM by enabling the
feature-controlloop-utils before running the tests.

PDP-D Setup
***********

The kubernetes charts were modified previous to the installation with
the changes below.

The feature-controlloop-utils was started by adding the following script:

.. code-block:: bash

    oom/kubernetes/policy/charts/drools/resources/configmaps/features.pre.sh:

    #!/bin/sh
    sh -c "features enable controlloop-utils"

Stability Test of Policy PDP-D
******************************

PDP-D performance
=================

The test set focused on the following use cases:

- vCPE
- vDNS
- vFirewall

For 72 hours the following 5 scenarios ran in parallel:

- vCPE success scenario
- vCPE failure scenario (failure returned by simulated APPC recipient through DMaaP).
- vDNS success scenario.
- vDNS failure scenario.
- vFirewall success scenario.

Five threads ran in parallel, one for each scenario.   The transactions were initiated
by each jmeter thread group.   Each thread initiated a transaction, monitored the transaction, and
as soon as the transaction ending was detected, it initiated the next one, so back to back with no
pauses.

All transactions completed successfully as it was expected in each scenario, with no failures.

The command executed was

.. code-block:: bash

    ./jmeter -n -t /home/ubuntu/drools-applications/testsuites/stability/src/main/resources/s3p.jmx  -l /home/ubuntu/jmeter_result/jmeter.jtl -e -o /home/ubuntu/jmeter_result > /dev/null 2>&1

The results were computed by monitoring the statistics REST endpoint accessible through the telemetry shell or APIs.


vCPE Success scenario
=====================

ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e:

.. code-block:: bash

    # Times are in milliseconds

    # Previous to the run, there was 1 failure as a consequence of testing
    # the flows before the stability load was initiated.   There was
    # an additional failure encountered during the execution.

    "ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e": {
        "policyExecutedCount": 161328,
        "policyExecutedSuccessCount": 161326,
        "totalElapsedTime": 44932780,
        "averageExecutionTime": 278.5181741545175,
        "birthTime": 1616092087842,
        "lastStart": 1616356511841,
        "lastExecutionTime": 1616356541972,
        "policyExecutedFailCount": 2
    }


vCPE Failure scenario
=====================

ControlLoop-vCPE-Fail:

.. code-block:: bash

    # Times are in milliseconds

    "ControlLoop-vCPE-Fail": {
        "policyExecutedCount": 250172,
        "policyExecutedSuccessCount": 0,
        "totalElapsedTime": 63258856,
        "averageExecutionTime": 252.8614553187407,
        "birthTime": 1616092143137,
        "lastStart": 1616440688824,
        "lastExecutionTime": 1616440689010,
        "policyExecutedFailCount": 250172
    }

vDNS Success scenario
=====================

ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3:

.. code-block:: bash

    # Times are in milliseconds

    "ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3": {
        "policyExecutedCount": 235438,
        "policyExecutedSuccessCount": 235438,
        "totalElapsedTime": 37564263,
        "averageExecutionTime": 159.550552587093,
        "birthTime": 1616092578063,
        "lastStart": 1616356511253,
        "lastExecutionTime": 1616356511653,
        "policyExecutedFailCount": 0
    }

vDNS Failure scenario
=====================

ControlLoop-vDNS-Fail:

.. code-block:: bash

    # Times are in milliseconds

    "ControlLoop-vDNS-Fail": {
        "policyExecutedCount": 2754574,
        "policyExecutedSuccessCount": 0,
        "totalElapsedTime": 14396495,
        "averageExecutionTime": 5.22639616869977,
        "birthTime": 1616092659237,
        "lastStart": 1616440696444,
        "lastExecutionTime": 1616440696444,
        "policyExecutedFailCount": 2754574
    }


vFirewall Success scenario
==========================

ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a:

.. code-block:: bash

    # Times are in milliseconds

    # Previous to the run, there were 2 failures as a consequence of testing
    # the flows before the stability load was initiated.   There was
    # an additional failure encountered during the execution.

    "ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a": {
        "policyExecutedCount": 145197,
        "policyExecutedSuccessCount": 145194,
        "totalElapsedTime": 33100249,
        "averageExecutionTime": 227.96785746261975,
        "birthTime": 1616092985229,
        "lastStart": 1616356511732,
        "lastExecutionTime": 1616356541972,
        "policyExecutedFailCount": 3
    }
