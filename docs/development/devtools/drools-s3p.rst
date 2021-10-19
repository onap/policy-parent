.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _drools-s3p-label:

.. toctree::
   :maxdepth: 2

Policy Drools PDP component
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Both the Performance and the Stability tests were executed against an ONAP installation in the policy-k8s tenant
in the windriver lab, from an independent VM running the jmeter tool to inject the load.

General Setup
*************

The installation runs the following components in a single VM:

- AAF
- AAI
- DMAAP
- POLICY

The VM has the following hardware spec:

- 126GB RAM
- 12 VCPUs
- 155GB Ephemeral Disk

Jmeter is run from a different VM with the following configuration:

- 16GB RAM
- 8 VCPUs
- 155GB Ephemeral Disk

The drools-pdp container uses the JVM memory settings from a default OOM installation.

Other ONAP components exercised during the stability tests were:

- Policy XACML PDP to process guard queries for each transaction.
- DMaaP to carry PDP-D and jmeter initiated traffic to complete transactions.
- Policy API to create (and delete at the end of the tests) policies for each
  scenario under test.
- Policy PAP to deploy (and undeploy at the end of the tests) policies for each scenario under test.

The following components are simulated during the tests.

- SO actor for the vDNS use case.
- APPC responses for the vCPE and vFW use cases.
- AAI to answer queries for the use cases under test.

SO, and AAI actors were simulated within the PDP-D JVM by enabling the
feature-controlloop-utils before running the tests.

PDP-D Setup
***********

The kubernetes charts were modified previous to the installation
to add the following script that enables the controlloop-utils feature:

.. code-block:: bash

    oom/kubernetes/policy/charts/drools/resources/configmaps/features.pre.sh:

    #!/bin/sh
    sh -c "features enable controlloop-utils"

Stability Test of Policy PDP-D
******************************

PDP-D performance
=================

The tests focused on the following use cases:

- vCPE
- vDNS
- vFirewall

For 72 hours the following 5 scenarios ran in parallel:

- vCPE success scenario
- vCPE failure scenario (failure returned by simulated APPC recipient through DMaaP).
- vDNS success scenario.
- vDNS failure scenario (failure by introducing in the DCAE ONSET a non-existant vserver-name reference).
- vFirewall success scenario.

Five threads ran in parallel, one for each scenario, back to back with no pauses.   The transactions were initiated
by each jmeter thread group.   Each thread initiated a transaction, monitored the transaction, and
as soon as the transaction ending was detected, it initiated the next one.

JMeter was run in a docker container with the following command:

.. code-block:: bash

    docker run --interactive --tty --name jmeter --rm --volume $PWD:/jmeter -e VERBOSE_GC="" egaillardon/jmeter-plugins --nongui --testfile s3p.jmx --loglevel WARN

The results were accessed by using the telemetry API to gather statistics:


vCPE Success scenario
=====================

ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e:

.. code-block:: bash

    # Times are in milliseconds

    Control Loop Name: ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e
    Number of Transactions Executed: 114007
    Number of Successful Transactions: 112727
    Number of Failure Transactions: 1280
    Average Execution Time: 434.9942021103967 ms.


vCPE Failure scenario
=====================

ControlLoop-vCPE-Fail:

.. code-block:: bash

    # Times are in milliseconds

    Control Loop Name: ControlLoop-vCPE-Fail
    Number of Transactions Executed: 114367
    Number of Successful Transactions: 114367 (failure transactions are expected)
    Number of Failure Transactions: 0         (success transactions are not expected)
    Average Execution Time: 433.61750330077734 ms.


vDNS Success scenario
=====================

ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3:

.. code-block:: bash

    # Times are in milliseconds

    Control Loop Name: ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3
    Number of Transactions Executed: 237512
    Number of Successful Transactions: 229532
    Number of Failure Transactions: 7980
    Average Execution Time: 268.028794334602 ms.


vDNS Failure scenario
=====================

ControlLoop-vDNS-Fail:

.. code-block:: bash

    # Times are in milliseconds

    Control Loop Name: ControlLoop-vDNS-Fail
    Number of Transactions Executed: 1957987
    Number of Successful Transactions: 1957987 (failure transactions are expected)
    Number of Failure Transactions: 0         (success transactions are not expected)
    Average Execution Time: 39.369322166081794


vFirewall Success scenario
==========================

ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a:

.. code-block:: bash

    # Times are in milliseconds

    Control Loop Name: ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a
    Number of Transactions Executed: 120308
    Number of Successful Transactions: 118895
    Number of Failure Transactions: 1413
    Average Execution Time: 394.8609236293513 ms.


Commentary
==========

There has been a degradation of performance observed in this release
when compared with the previous one.
Approximately 1% of transactions were not completed as expected for
some use cases.   Average Execution Times are extended as well.
The unexpected results seem to point in the direction of the
interactions of the distributed locking feature with the database.
These areas as well as the conditions for the test need to be investigated
further.

.. code-block:: bash

    # Common pattern in the audit.log for unexpected transaction completions

    a8d637fc-a2d5-49f9-868b-5b39f7befe25||ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a|
    policy:usecases:[org.onap.policy.drools-applications.controlloop.common:controller-usecases:1.9.0:usecases]|
    2021-10-12T19:48:02.052+00:00|2021-10-12T19:48:02.052+00:00|0|
    null:operational.modifyconfig.EVENT.MANAGER.FINAL:1.0.0|dev-policy-drools-pdp-0|
    ERROR|400|Target Lock was lost|||VNF.generic-vnf.vnf-name||dev-policy-drools-pdp-0||
    dev-policy-drools-pdp-0|microservice.stringmatcher|
    {vserver.prov-status=ACTIVE, vserver.is-closed-loop-disabled=false,
    generic-vnf.vnf-name=fw0002vm002fw002, vserver.vserver-name=OzVServer}||||
    INFO|Session org.onap.policy.drools-applications.controlloop.common:controller-usecases:1.9.0:usecases|

    # The "Target Lock was lost" is a common message error in the unexpected results.


END-OF-DOCUMENT

