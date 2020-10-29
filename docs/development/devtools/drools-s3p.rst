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

    #!/bin/bash
    bash -c "features enable controlloop-utils"

Stability Test of Policy PDP-D
******************************

The 72 hour stability test happened in parallel with the stability run of the API component.

Worker Node performance
=======================

The VM named onap-k8s-09 was monitored for the duration of the 72 hours
stability run.  The table below show the usage ranges:

.. code-block:: bash

    NAME          CPU(cores)   CPU%
    onap-k8s-09   <=1214m      <=20%

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

    ./jmeter -n -t /home/ubuntu/drools-applications/testsuites/stability/src/main/resources/frankfurt/s3p.jmx  -l /home/ubuntu/jmeter_result/jmeter.jtl -e -o /home/ubuntu/jmeter_result > /dev/null 2>&1

The results were computed by taking the ellapsed time from the audit.log
(this log reports all end to end transactions, marking the start, end, and
ellapsed times).

The count reflects the number of successful transactions as expected in the
use case, as well as the average, standard deviation, and max/min.   An histogram
of the response times have been added as a visual indication on the most common
transaction times.

vCPE Success scenario
=====================

ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e:

.. code-block:: bash

    Max: 4323 ms, Min: 143 ms, Average: 380 ms [samples taken for average: 260628]

.. image:: images/ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e.png


vCPE Failure scenario
=====================

ControlLoop-vCPE-Fail:

.. code-block:: bash

   Max: 3723 ms, Min: 148 ms, Average: 671 ms [samples taken for average: 87888]

.. image:: images/ControlLoop-vCPE-Fail.png

vDNS Success scenario
=====================

ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3:

.. code-block:: bash

   Max: 6437 ms, Min: 19 ms, Average: 165 ms [samples taken for average: 59259]

.. image:: images/ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3.png

vDNS Failure scenario
=====================

ControlLoop-vDNS-Fail:

.. code-block:: bash

    Max: 1176 ms, Min: 4 ms, Average: 5 ms [samples taken for average: 340810]

.. image:: images/ControlLoop-vDNS-Fail.png

vFirewall Success scenario
==========================

ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a:

.. code-block:: bash

    Max: 4016 ms, Min: 177 ms, Average: 644 ms [samples taken for average: 36460]

.. image:: images/ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a.png
