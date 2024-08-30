
.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _pdpd-apps-label:

PDP-D Applications
##################

.. contents::
    :depth: 2

Overview
========

PDP-D applications uses the PDP-D Engine middleware to provide domain specific services.
See :ref:`pdpd-engine-label` for the description of the PDP-D infrastructure.

At this time *Control Loops* are the only type of applications supported.

*Control Loop* applications must support the following *Policy Type*:

- **onap.policies.controlloop.operational.common.Drools** (Tosca Compliant Operational Policies)

Software
========

Source Code repositories
~~~~~~~~~~~~~~~~~~~~~~~~

The PDP-D Applications software resides on the `policy/drools-applications <https://git.onap.org/policy/drools-applications>`__ repository.    The actor libraries introduced in the *frankfurt* release reside in
the `policy/models repository <https://git.onap.org/policy/models>`__.

At this time, the *control loop* application is the only application supported in ONAP.
All the application projects reside under the
`controlloop directory <https://git.onap.org/policy/drools-applications/tree/controlloop>`__.

Docker Image
~~~~~~~~~~~~

See the *drools-applications*
`released versions <https://wiki.onap.org/display/DW/Policy+Framework+Project%3A+Component+Versions>`__
for the latest images:

.. code-block:: bash

    docker pull onap/policy-pdpd-cl:3.0.0

At the time of this writing *3.0.0* is the latest version.

The *onap/policy-pdpd-cl* image extends the *onap/policy-drools* image with
the *usecases* controller that realizes the *control loop* application.

Usecases Controller
===================

The `usecases <https://git.onap.org/policy/drools-applications/tree/controlloop/common/controller-usecases>`__
controller is the *control loop* application in ONAP.

There are three parts in this controller:

* The `drl rules <https://git.onap.org/policy/drools-applications/tree/controlloop/common/controller-usecases/src/main/resources/usecases.drl>`__.
* The `kmodule.xml <https://git.onap.org/policy/drools-applications/tree/controlloop/common/controller-usecases/src/main/resources/META-INF/kmodule.xml>`__.
* The `dependencies <https://git.onap.org/policy/drools-applications/tree/controlloop/common/controller-usecases/pom.xml>`__.

The `kmodule.xml` specifies only one session, and declares in the *kbase* section the two operational policy types that
it supports.

The Usecases controller relies on the new Actor framework to interact with remote
components, part of a control loop transaction.   The reader is referred to the
*Policy Platform Actor Development Guidelines* in the documentation for further information.

Operational Policy Types
========================

The *usecases* controller supports the following policy type:

- *onap.policies.controlloop.operational.common.Drools*.

The *onap.policies.controlloop.operational.common.Drools*
is the Tosca compliant policy type introduced in *frankfurt*.

The Tosca Compliant Operational Policy Type is defined at the
`onap.policies.controlloop.operational.common.Drools <https://git.onap.org/policy/models/tree/models-examples/src/main/resources/policytypes/onap.policies.controlloop.operational.common.Drools.yaml>`__.

An example of a Tosca Compliant Operational Policy can be found
`here <https://git.onap.org/policy/models/tree/models-examples/src/main/resources/policies/vDNS.policy.operational.input.tosca.json>`__.

Policy Chaining
===============

The *usecases* controller supports chaining of multiple operations inside a Tosca Operational Policy. The next operation can be chained based on the result/output from an operation.
The possibilities available for chaining are:

- *success: chain after the result of operation is success*
- *failure: chain after the result of operation is failure due to issues with controller/actor*
- *failure_timeout: chain after the result of operation is failure due to timeout*
- *failure_retries: chain after the result of operation is failure after all retries*
- *failure_exception: chain after the result of operation is failure due to exception*
- *failure_guard: chain after the result of operation is failure due to guard not allowing the operation*

An example of policy chaining for VNF can be found
`here <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vFirewall.cds.policy.operational.chaining.yaml>`__.

An example of policy chaining for PNF can be found
`here <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/pnf.cds.policy.operational.chaining.yaml>`__.

Features
========

Since the PDP-D Control Loop Application image was created from the PDP-D Engine one (*onap/policy-drools*),
it inherits all features and functionality.

The enabled features in the *onap/policy-pdpd-cl* image are:

- **distributed locking**: distributed resource locking.
- **healthcheck**: healthcheck.
- **lifecycle**: enables the lifecycle APIs.
- **controlloop-trans**: control loop transaction tracking.
- **controlloop-management**: generic controller capabilities.
- **controlloop-usecases**: new *controller* introduced in the guilin release to realize the ONAP use cases.


Control Loops Transaction (controlloop-trans)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It tracks Control Loop Transactions and Operations.   These are recorded in
the *$POLICY_LOGS/audit.log* and *$POLICY_LOGS/metrics.log*, and accessible
through the telemetry APIs.

Control Loops Management (controlloop-management)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It installs common control loop application resources, and provides
telemetry API extensions.   *Actor* configurations are packaged in this
feature.

Usecases Controller (controlloop-usecases)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It is the *guilin* release implementation of the ONAP use cases.
It relies on the new *Actor* model framework to carry out a policy's
execution.


Utilities (controlloop-utils)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enables *actor simulators* for testing purposes.

Offline Mode
============

The default ONAP installation in *onap/policy-pdpd-cl:1.8.2* is *OFFLINE*.
In this configuration, the *rules* artifact and the *dependencies* are all in the local
maven repository.   This requires that the maven dependencies are preloaded in the local
repository.

An offline configuration requires two configuration items:

- *OFFLINE* environment variable set to true (see `values.yaml <https://git.onap.org/oom/tree/kubernetes/policy/values.yaml>`__.
- override of the default *settings.xml* (see
  `settings.xml <https://git.onap.org/oom/tree/kubernetes/policy/components/policy-drools-pdp/resources/configmaps/settings.xml>`__) override.

Running the PDP-D Control Loop Application in a single container
================================================================

Environment File
~~~~~~~~~~~~~~~~

First create an environment file (in this example *env.conf*) to configure the PDP-D.

.. code-block:: bash

    # SYSTEM software configuration

    POLICY_HOME=/opt/app/policy
    POLICY_LOGS=/var/log/onap/policy/pdpd
    KEYSTORE_PASSWD=Pol1cy_0nap
    TRUSTSTORE_PASSWD=Pol1cy_0nap

    # Telemetry credentials

    TELEMETRY_PORT=9696
    TELEMETRY_HOST=0.0.0.0
    TELEMETRY_USER=demo@people.osaaf.org
    TELEMETRY_PASSWORD=demo123456!

    # nexus repository

    SNAPSHOT_REPOSITORY_ID=
    SNAPSHOT_REPOSITORY_URL=
    RELEASE_REPOSITORY_ID=
    RELEASE_REPOSITORY_URL=
    REPOSITORY_USERNAME=
    REPOSITORY_PASSWORD=
    REPOSITORY_OFFLINE=true

    MVN_SNAPSHOT_REPO_URL=
    MVN_RELEASE_REPO_URL=

    # Relational (SQL) DB access

    SQL_HOST=
    SQL_USER=
    SQL_PASSWORD=

    # AAF

    AAF=false
    AAF_NAMESPACE=org.onap.policy
    AAF_HOST=aaf.api.simpledemo.onap.org

    # PDP-D DMaaP configuration channel

    PDPD_CONFIGURATION_TOPIC=PDPD-CONFIGURATION
    PDPD_CONFIGURATION_API_KEY=
    PDPD_CONFIGURATION_API_SECRET=
    PDPD_CONFIGURATION_CONSUMER_GROUP=
    PDPD_CONFIGURATION_CONSUMER_INSTANCE=
    PDPD_CONFIGURATION_PARTITION_KEY=

    # PAP-PDP configuration channel

    POLICY_PDP_PAP_TOPIC=POLICY-PDP-PAP
    POLICY_PDP_PAP_GROUP=defaultGroup

    # Symmetric Key for encoded sensitive data

    SYMM_KEY=

    # Healthcheck Feature

    HEALTHCHECK_USER=demo@people.osaaf.org
    HEALTHCHECK_PASSWORD=demo123456!

    # Pooling Feature

    POOLING_TOPIC=POOLING

    # PAP

    PAP_HOST=
    PAP_USERNAME=
    PAP_PASSWORD=

    # PAP legacy

    PAP_LEGACY_USERNAME=
    PAP_LEGACY_PASSWORD=

    # PDP-X

    PDP_HOST=localhost
    PDP_PORT=6669
    PDP_CONTEXT_URI=pdp/api/getDecision
    PDP_USERNAME=policy
    PDP_PASSWORD=password
    GUARD_DISABLED=true

    # DCAE DMaaP

    DCAE_TOPIC=unauthenticated.DCAE_CL_OUTPUT
    DCAE_SERVERS=localhost
    DCAE_CONSUMER_GROUP=dcae.policy.shared

    # AAI

    AAI_HOST=localhost
    AAI_PORT=6666
    AAI_CONTEXT_URI=
    AAI_USERNAME=policy
    AAI_PASSWORD=policy

    # SO

    SO_HOST=localhost
    SO_PORT=6667
    SO_CONTEXT_URI=
    SO_URL=https://localhost:6667/
    SO_USERNAME=policy
    SO_PASSWORD=policy

    # VFC

    VFC_HOST=localhost
    VFC_PORT=6668
    VFC_CONTEXT_URI=api/nslcm/v1/
    VFC_USERNAME=policy
    VFC_PASSWORD=policy

    # SDNC

    SDNC_HOST=localhost
    SDNC_PORT=6670
    SDNC_CONTEXT_URI=restconf/operations/

Configuration
~~~~~~~~~~~~~

features.pre.sh
"""""""""""""""

We can enable the *controlloop-utils* and disable the *distributed-locking* feature to avoid using the database.

.. code-block:: bash

    #!/bin/bash -x

    bash -c "/opt/app/policy/bin/features disable distributed-locking"
    bash -c "/opt/app/policy/bin/features enable controlloop-utils"

active.post.sh
""""""""""""""

The *active.post.sh* script makes the PDP-D active.

.. code-block:: bash

    #!/bin/bash -x

    bash -c "http --verify=no -a ${TELEMETRY_USER}:${TELEMETRY_PASSWORD} PUT https://localhost:9696/policy/pdp/engine/lifecycle/state/ACTIVE"

Actor Properties
""""""""""""""""

In the *guilin* release, some *actors* configurations need to be overridden to support *http* for compatibility
with the *controlloop-utils* feature.

AAI-http-client.properties
""""""""""""""""""""""""""

.. code-block:: bash

    http.client.services=AAI

    http.client.services.AAI.managed=true
    http.client.services.AAI.https=false
    http.client.services.AAI.host=${envd:AAI_HOST}
    http.client.services.AAI.port=${envd:AAI_PORT}
    http.client.services.AAI.userName=${envd:AAI_USERNAME}
    http.client.services.AAI.password=${envd:AAI_PASSWORD}
    http.client.services.AAI.contextUriPath=${envd:AAI_CONTEXT_URI}

SDNC-http-client.properties
"""""""""""""""""""""""""""

.. code-block:: bash

    http.client.services=SDNC

    http.client.services.SDNC.managed=true
    http.client.services.SDNC.https=false
    http.client.services.SDNC.host=${envd:SDNC_HOST}
    http.client.services.SDNC.port=${envd:SDNC_PORT}
    http.client.services.SDNC.userName=${envd:SDNC_USERNAME}
    http.client.services.SDNC.password=${envd:SDNC_PASSWORD}
    http.client.services.SDNC.contextUriPath=${envd:SDNC_CONTEXT_URI}

VFC-http-client.properties
""""""""""""""""""""""""""

.. code-block:: bash

    http.client.services=VFC

    http.client.services.VFC.managed=true
    http.client.services.VFC.https=false
    http.client.services.VFC.host=${envd:VFC_HOST}
    http.client.services.VFC.port=${envd:VFC_PORT}
    http.client.services.VFC.userName=${envd:VFC_USERNAME}
    http.client.services.VFC.password=${envd:VFC_PASSWORD}
    http.client.services.VFC.contextUriPath=${envd:VFC_CONTEXT_URI:api/nslcm/v1/}

settings.xml
""""""""""""

The *standalone-settings.xml* file is the default maven settings override in the container.

.. code-block:: bash

    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

        <offline>true</offline>

        <profiles>
            <profile>
                <id>policy-local</id>
                <repositories>
                    <repository>
                        <id>file-repository</id>
                        <url>file:${user.home}/.m2/file-repository</url>
                        <releases>
                            <enabled>true</enabled>
                            <updatePolicy>always</updatePolicy>
                        </releases>
                        <snapshots>
                            <enabled>true</enabled>
                            <updatePolicy>always</updatePolicy>
                        </snapshots>
                    </repository>
                </repositories>
            </profile>
        </profiles>

        <activeProfiles>
            <activeProfile>policy-local</activeProfile>
        </activeProfiles>

    </settings>

Bring up the PDP-D Control Loop Application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    docker run --rm -p 9696:9696 -v ${PWD}/config:/tmp/policy-install/config --env-file ${PWD}/env/env.conf -it --name PDPD -h pdpd nexus3.onap.org:10001/onap/policy-pdpd-cl:1.6.4

To run the container in detached mode, add the *-d* flag.

Note that we are opening the *9696* telemetry API port to the outside world, mounting the *config* host directory,
and setting environment variables.

To open a shell into the PDP-D:

.. code-block:: bash

    docker exec -it pdp-d bash

Once in the container, run tools such as *telemetry*, *db-migrator*, *policy* to look at the system state:

.. code-block:: bash

    docker exec -it PDPD bash -c "/opt/app/policy/bin/telemetry"
    docker exec -it PDPD bash -c "/opt/app/policy/bin/policy status"
    docker exec -it PDPD bash -c "/opt/app/policy/bin/db-migrator -s ALL -o report"

Controlled instantiation of the PDP-D Control Loop Appplication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sometimes a developer may want to start and stop the PDP-D manually:

.. code-block:: bash

   # start a bash

   docker run --rm -p 9696:9696 -v ${PWD}/config:/tmp/policy-install/config --env-file ${PWD}/env/env.conf -it --name PDPD -h pdpd nexus3.onap.org:10001/onap/policy-pdpd-cl:1.6.4 bash

   # use this command to start policy applying host customizations from /tmp/policy-install/config

   pdpd-cl-entrypoint.sh vmboot

   # or use this command to start policy without host customization

   policy start

   # at any time use the following command to stop the PDP-D

   policy stop

   # and this command to start the PDP-D back again

   policy start

Scale-out use case testing
==========================

First step is to create the *operational.scaleout* policy.

policy.vdns.json
~~~~~~~~~~~~~~~~

.. code-block:: bash

    {
      "type": "onap.policies.controlloop.operational.common.Drools",
      "type_version": "1.0.0",
      "name": "operational.scaleout",
      "version": "1.0.0",
      "metadata": {
        "policy-id": "operational.scaleout"
      },
      "properties": {
        "id": "ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3",
        "timeout": 60,
        "abatement": false,
        "trigger": "unique-policy-id-1-scale-up",
        "operations": [
          {
            "id": "unique-policy-id-1-scale-up",
            "description": "Create a new VF Module",
            "operation": {
              "actor": "SO",
              "operation": "VF Module Create",
              "target": {
                "targetType": "VFMODULE",
                "entityIds": {
                  "modelInvariantId": "e6130d03-56f1-4b0a-9a1d-e1b2ebc30e0e",
                  "modelVersionId": "94b18b1d-cc91-4f43-911a-e6348665f292",
                  "modelName": "VfwclVfwsnkBbefb8ce2bde..base_vfw..module-0",
                  "modelVersion": 1,
                  "modelCustomizationId": "47958575-138f-452a-8c8d-d89b595f8164"
                }
              },
              "payload": {
                "requestParameters": "{\"usePreload\":true,\"userParams\":[]}",
                "configurationParameters": "[{\"ip-addr\":\"$.vf-module-topology.vf-module-parameters.param[9]\",\"oam-ip-addr\":\"$.vf-module-topology.vf-module-parameters.param[16]\",\"enabled\":\"$.vf-module-topology.vf-module-parameters.param[23]\"}]"
              }
            },
            "timeout": 20,
            "retries": 0,
            "success": "final_success",
            "failure": "final_failure",
            "failure_timeout": "final_failure_timeout",
            "failure_retries": "final_failure_retries",
            "failure_exception": "final_failure_exception",
            "failure_guard": "final_failure_guard"
          }
        ]
      }
    }

To provision the *scale-out policy*, issue the following command:

.. code-block:: bash

    http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" https://localhost:9696/policy/pdp/engine/lifecycle/policies @usecases/policy.vdns.json

Verify that the policy shows with the telemetry tools:

.. code-block:: bash

    docker exec -it PDPD bash -c "/opt/app/policy/bin/telemetry"
    > get /policy/pdp/engine/lifecycle/policies
    > get /policy/pdp/engine/controllers/usecases/drools/facts/usecases/controlloops


dcae.vdns.onset.json
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    {
      "closedLoopControlName": "ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3",
      "closedLoopAlarmStart": 1463679805324,
      "closedLoopEventClient": "microservice.stringmatcher",
      "closedLoopEventStatus": "ONSET",
      "requestID": "c7c6a4aa-bb61-4a15-b831-ba1472dd4a65",
      "target_type": "VNF",
      "target": "vserver.vserver-name",
      "AAI": {
        "vserver.is-closed-loop-disabled": "false",
        "vserver.prov-status": "ACTIVE",
        "vserver.vserver-name": "OzVServer"
      },
      "from": "DCAE",
      "version": "1.0.2"
    }

To initiate a control loop transaction, simulate a DCAE ONSET to Policy:

.. code-block:: bash

    http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/DCAE_TOPIC/events @dcae.vdns.onset.json Content-Type:'text/plain'

This will trigger the scale out control loop transaction that will interact with the *SO*
simulator to complete the transaction.

Verify in *$POLICY_LOGS/network.log* that a *FINAL: SUCCESS* notification is sent over the POLICY-CL-MGT channel.
An entry in the *$POLICY_LOGS/audit.log* should indicate successful completion as well.

vCPE use case testing
=====================

First step is to create the *operational.restart* policy.

policy.vcpe.json
~~~~~~~~~~~~~~~~

.. code-block:: bash

    {
      "type": "onap.policies.controlloop.operational.common.Drools",
      "type_version": "1.0.0",
      "name": "operational.restart",
      "version": "1.0.0",
      "metadata": {
        "policy-id": "operational.restart"
      },
      "properties": {
        "id": "ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e",
        "timeout": 300,
        "abatement": false,
        "trigger": "unique-policy-id-1-restart",
        "operations": [
          {
            "id": "unique-policy-id-1-restart",
            "description": "Restart the VM",
            "operation": {
              "actor": "APPC",
              "operation": "Restart",
              "target": {
                "targetType": "VNF"
              }
            },
            "timeout": 240,
            "retries": 0,
            "success": "final_success",
            "failure": "final_failure",
            "failure_timeout": "final_failure_timeout",
            "failure_retries": "final_failure_retries",
            "failure_exception": "final_failure_exception",
            "failure_guard": "final_failure_guard"
          }
        ]
      }
    }

To provision the *operational.restart policy* issue the following command:

.. code-block:: bash

    http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" https://localhost:9696/policy/pdp/engine/lifecycle/policies @usecases/policy.vcpe.json

Verify that the policy shows with the telemetry tools:

.. code-block:: bash

    docker exec -it PDPD bash -c "/opt/app/policy/bin/telemetry"
    > get /policy/pdp/engine/lifecycle/policies
    > get /policy/pdp/engine/controllers/usecases/drools/facts/usecases/controlloops


dcae.vcpe.onset.json
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    {
      "closedLoopControlName": "ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e",
      "closedLoopAlarmStart": 1463679805324,
      "closedLoopEventClient": "DCAE_INSTANCE_ID.dcae-tca",
      "closedLoopEventStatus": "ONSET",
      "requestID": "664be3d2-6c12-4f4b-a3e7-c349acced200",
      "target_type": "VNF",
      "target": "generic-vnf.vnf-id",
      "AAI": {
        "vserver.is-closed-loop-disabled": "false",
        "vserver.prov-status": "ACTIVE",
        "generic-vnf.vnf-id": "vCPE_Infrastructure_vGMUX_demo_app"
      },
      "from": "DCAE",
      "version": "1.0.2"
    }

To initiate a control loop transaction, simulate a DCAE ONSET to Policy:

.. code-block:: bash

    http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/DCAE_TOPIC/events @dcae.vcpe.onset.json Content-Type:'text/plain'

This will spawn a vCPE control loop transaction in the PDP-D.  Policy will send a *restart* message over the
*APPC-LCM-READ* channel to APPC and wait for a response.

Verify that you see this message in the network.log by looking for *APPC-LCM-READ* messages.

Note the *sub-request-id* value from the restart message in the *APPC-LCM-READ* channel.

Replace *REPLACEME* in the *appc.vcpe.success.json* with this sub-request-id.

appc.vcpe.success.json
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    {
      "body": {
        "output": {
          "common-header": {
            "timestamp": "2017-08-25T21:06:23.037Z",
            "api-ver": "5.00",
            "originator-id": "664be3d2-6c12-4f4b-a3e7-c349acced200",
            "request-id": "664be3d2-6c12-4f4b-a3e7-c349acced200",
            "sub-request-id": "REPLACEME",
            "flags": {}
          },
          "status": {
            "code": 400,
            "message": "Restart Successful"
          }
        }
      },
      "version": "2.0",
      "rpc-name": "restart",
      "correlation-id": "664be3d2-6c12-4f4b-a3e7-c349acced200-1",
      "type": "response"
    }


Send a simulated APPC response back to the PDP-D over the *APPC-LCM-WRITE* channel.

.. code-block:: bash

    http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/APPC-LCM-WRITE/events @appc.vcpe.success.json  Content-Type:'text/plain'

Verify in *$POLICY_LOGS/network.log* that a *FINAL: SUCCESS* notification is sent over the *POLICY-CL-MGT* channel,
and an entry is added to the *$POLICY_LOGS/audit.log* indicating successful completion.

vFirewall use case testing
==========================

First step is to create the *operational.modifyconfig* policy.

policy.vfw.json
~~~~~~~~~~~~~~~

.. code-block:: bash

    {
      "type": "onap.policies.controlloop.operational.common.Drools",
      "type_version": "1.0.0",
      "name": "operational.modifyconfig",
      "version": "1.0.0",
      "metadata": {
        "policy-id": "operational.modifyconfig"
      },
      "properties": {
        "id": "ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a",
        "timeout": 300,
        "abatement": false,
        "trigger": "unique-policy-id-1-modifyConfig",
        "operations": [
          {
            "id": "unique-policy-id-1-modifyConfig",
            "description": "Modify the packet generator",
            "operation": {
              "actor": "APPC",
              "operation": "ModifyConfig",
              "target": {
                "targetType": "VNF",
                "entityIds": {
                  "resourceID": "bbb3cefd-01c8-413c-9bdd-2b92f9ca3d38"
                }
              },
              "payload": {
                "streams": "{\"active-streams\": 5 }"
              }
            },
            "timeout": 240,
            "retries": 0,
            "success": "final_success",
            "failure": "final_failure",
            "failure_timeout": "final_failure_timeout",
            "failure_retries": "final_failure_retries",
            "failure_exception": "final_failure_exception",
            "failure_guard": "final_failure_guard"
          }
        ]
      }
    }


To provision the *operational.modifyconfig policy*, issue the following command:

.. code-block:: bash

    http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" https://localhost:9696/policy/pdp/engine/lifecycle/policies @usecases/policy.vfw.json

Verify that the policy shows with the telemetry tools:

.. code-block:: bash

    docker exec -it PDPD bash -c "/opt/app/policy/bin/telemetry"
    > get /policy/pdp/engine/lifecycle/policies
    > get /policy/pdp/engine/controllers/usecases/drools/facts/usecases/controlloops


dcae.vfw.onset.json
~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    {
      "closedLoopControlName": "ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a",
      "closedLoopAlarmStart": 1463679805324,
      "closedLoopEventClient": "microservice.stringmatcher",
      "closedLoopEventStatus": "ONSET",
      "requestID": "c7c6a4aa-bb61-4a15-b831-ba1472dd4a65",
      "target_type": "VNF",
      "target": "generic-vnf.vnf-name",
      "AAI": {
        "vserver.is-closed-loop-disabled": "false",
        "vserver.prov-status": "ACTIVE",
        "generic-vnf.vnf-name": "fw0002vm002fw002",
        "vserver.vserver-name": "OzVServer"
      },
      "from": "DCAE",
      "version": "1.0.2"
    }


To initiate a control loop transaction, simulate a DCAE ONSET to Policy:

.. code-block:: bash

    http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/DCAE_TOPIC/events @dcae.vfw.onset.json Content-Type:'text/plain'

This will spawn a vFW control loop transaction in the PDP-D.  Policy will send a *ModifyConfig* message over the
*APPC-CL* channel to APPC and wait for a response.  This can be seen by searching the network.log for *APPC-CL*.

Note the *SubRequestId* field in the *ModifyConfig* message in the *APPC-CL* topic in the network.log

Send a simulated APPC response back to the PDP-D over the *APPC-CL* channel.
To do this, change the *REPLACEME* text in the *appc.vcpe.success.json* with this *SubRequestId*.

appc.vcpe.success.json
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    {
      "CommonHeader": {
        "TimeStamp": 1506051879001,
        "APIver": "1.01",
        "RequestID": "c7c6a4aa-bb61-4a15-b831-ba1472dd4a65",
        "SubRequestID": "REPLACEME",
        "RequestTrack": [],
        "Flags": []
      },
      "Status": {
        "Code": 400,
        "Value": "SUCCESS"
      },
      "Payload": {
        "generic-vnf.vnf-id": "f17face5-69cb-4c88-9e0b-7426db7edddd"
      }
    }

.. code-block:: bash

    http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/APPC-CL/events @appc.vcpe.success.json Content-Type:'text/plain'

Verify in *$POLICY_LOGS/network.log* that a *FINAL: SUCCESS* notification is sent over the POLICY-CL-MGT channel,
and an entry is added to the *$POLICY_LOGS/audit.log* indicating successful completion.


Running PDP-D Control Loop Application with other components
============================================================

The reader can also look at the `policy/docker repository <https://github.com/onap/policy-docker/tree/master/csit>`__.
More specifically, these directories have examples of other PDP-D Control Loop configurations:

* `plans <https://github.com/onap/policy-docker/tree/master/compose>`__: startup & teardown scripts.
* `scripts <https://github.com/onap/policy-docker/blob/master/compose/compose.yml>`__: docker-compose file.
* `tests <https://github.com/onap/policy-docker/blob/master/csit/resources/tests/drools-applications-test.robot>`__: test plan.

Additional information
======================

For additional information, please see the
`Drools PDP Development and Testing (In Depth) <https://wiki.onap.org/display/DW/2020-08+Frankfurt+Tutorials>`__ page.


