.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _drools-s3p-label:

.. toctree::
   :maxdepth: 2

Policy Drools PDP component
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Both the Performance and the Stability tests were executed against a default ONAP installation in the PFPP tenant, from an independent VM running the jmeter tool to inject the load.

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

The oom/kubernetes/policy/charts/drools/resources/configmaps/base.conf was
modified as follows:

.. code-block:: bash

    --- a/kubernetes/policy/charts/drools/resources/configmaps/base.conf
    +++ b/kubernetes/policy/charts/drools/resources/configmaps/base.conf
    @@ -85,27 +85,27 @@ DMAAP_SERVERS=message-router

    # AAI

    -AAI_HOST=aai.{{.Release.Namespace}}
    -AAI_PORT=8443
    +AAI_HOST=localhost
    +AAI_PORT=6666
    AAI_CONTEXT_URI=

    # MSO

    -SO_HOST=so.{{.Release.Namespace}}
    -SO_PORT=8080
    -SO_CONTEXT_URI=onap/so/infra/
    -SO_URL=https://so.{{.Release.Namespace}}:8080/onap/so/infra
    +SO_HOST=localhost
    +SO_PORT=6667
    +SO_CONTEXT_URI=
    +SO_URL=https://localhost:6667/

    # VFC

    -VFC_HOST=
    -VFC_PORT=
    +VFC_HOST=localhost
    +VFC_PORT=6668
    VFC_CONTEXT_URI=api/nslcm/v1/

    # SDNC

    -SDNC_HOST=sdnc.{{.Release.Namespace}}
    -SDNC_PORT=8282
    +SDNC_HOST=localhost
    +SDNC_PORT=6670
    SDNC_CONTEXT_URI=restconf/operations/

The AAI actor had to be modified to disable https to talk to the AAI simulator.

.. code-block:: bash

    ~/oom/kubernetes/policy/charts/drools/resources/configmaps/AAI-http-client.properties

    http.client.services=AAI

    http.client.services.AAI.managed=true
    http.client.services.AAI.https=false
    http.client.services.AAI.host=${envd:AAI_HOST}
    http.client.services.AAI.port=${envd:AAI_PORT}
    http.client.services.AAI.userName=${envd:AAI_USERNAME}
    http.client.services.AAI.password=${envd:AAI_PASSWORD}
    http.client.services.AAI.contextUriPath=${envd:AAI_CONTEXT_URI}

The SO actor had to be modified similarly.

.. code-block:: bash

    oom/kubernetes/policy/charts/drools/resources/configmaps/SO-http-client.properties:

    http.client.services=SO

    http.client.services.SO.managed=true
    http.client.services.SO.https=false
    http.client.services.SO.host=${envd:SO_HOST}
    http.client.services.SO.port=${envd:SO_PORT}
    http.client.services.SO.userName=${envd:SO_USERNAME}
    http.client.services.SO.password=${envd:SO_PASSWORD}
    http.client.services.SO.contextUriPath=${envd:SO_CONTEXT_URI}

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

The VM named onap-k8s-07 was monitored for the duration of the two parallel
stability runs.  The table below show the usage ranges:

.. code-block:: bash

    NAME          CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
    onap-k8s-07   <=1374m      <=20%  <=10643Mi       <=66%

PDP-D performance
=================

The PDP-D uses a small configuration:

.. code-block:: bash

  small:
    limits:
      cpu: 1
      memory: 4Gi
    requests:
      cpu: 100m
      memory: 1Gi

In practicality, this corresponded to an allocated 3.75G heap for the JVM based.

The PDP-D was monitored during the run and stayed below the following ranges:

.. code-block:: bash

    NAME           CPU(cores)   MEMORY(bytes)
    dev-drools-0   <=142m         684Mi

Garbage collection was monitored without detecting any significant degradation.

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

    jmeter -n -t /home/ubuntu/jhh/s3p.jmx > /dev/null 2>&1

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

    count    155246.000000
    mean        269.894226
    std          64.556282
    min         133.000000
    50%         276.000000
    max        1125.000000


.. image:: images/ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e.png


vCPE Failure scenario
=====================

ControlLoop-vCPE-Fail:

.. code-block:: bash

    ControlLoop-vCPE-Fail :
    count    149621.000000
    mean        280.483522
    std          67.226550
    min         134.000000
    50%         279.000000
    max        5394.000000


.. image:: images/ControlLoop-vCPE-Fail.png

vDNS Success scenario
=====================

ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3:

.. code-block:: bash

    count    293000.000000
    mean         21.961792
    std           7.921396
    min          15.000000
    50%          20.000000
    max         672.000000


.. image:: images/ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3.png

vDNS Failure scenario
=====================

ControlLoop-vDNS-Fail:

.. code-block:: bash

    count    59357.000000
    mean      3010.261267
    std         76.599948
    min          0.000000
    50%       3010.000000
    max       3602.000000


.. image:: images/ControlLoop-vDNS-Fail.png

vFirewall Success scenario
==========================

ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a:

.. code-block:: bash

    count    175401.000000
    mean        184.581251
    std          35.619075
    min         136.000000
    50%         181.000000
    max        3972.000000


.. image:: images/ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a.png




