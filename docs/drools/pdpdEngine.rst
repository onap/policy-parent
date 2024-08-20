.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _pdpd-engine-label:

PDP-D Engine
############

.. contents::
    :depth: 2

Overview
========

The PDP-D Core Engine provides an infrastructure and services for `drools <https://www.drools.org/>`__ based applications
in the context of Policies and ONAP.

A PDP-D supports applications by means of *controllers*.   A *controller* is a named
grouping of resources.   These typically include references to communication endpoints,
maven artifact coordinates, and *coders* for message mapping.

*Controllers* use *communication endpoints* to interact
with remote networked entities typically using messaging (dmaap or ueb),
or http.

PDP-D Engine capabilities can be extended via *features*.   Integration with other
Policy Framework components (API, PAP, and PDP-X) is through one of them (*feature-lifecycle*).

The PDP-D Engine infrastructure provides mechanisms for data migration, diagnostics, and application management.

Software
========

Source Code repositories
~~~~~~~~~~~~~~~~~~~~~~~~

The PDP-D software is mainly located in the `policy/drools repository <https://git.onap.org/policy/drools-pdp>`__ with the *communication endpoints* software residing in the `policy/common repository <https://git.onap.org/policy/common>`__ and Tosca policy models in the `policy/models repository <https://git.onap.org/policy/models>`__.

Docker Image
~~~~~~~~~~~~

Check the *drools-pdp* `released versions <https://wiki.onap.org/display/DW/Policy+Framework+Project%3A+Component+Versions>`__ page for the latest versions.
At the time of this writing *1.8.2* is the latest version.

.. code-block:: bash

    docker pull onap/policy-drools:1.8.2

A container instantiated from this image will run under the non-priviledged *policy* account.

The PDP-D root directory is located at the */opt/app/policy* directory (or *$POLICY_HOME*), with the
exception of the *$HOME/.m2* which contains the local maven repository.
The PDP-D configuration resides in the following directories:

- **/opt/app/policy/config**: (*$POLICY_HOME/config* or *$POLICY_CONFIG*) contains *engine*, *controllers*, and *endpoint* configuration.
- **/home/policy/.m2**: (*$HOME/.m2*) maven repository configuration.
- **/opt/app/policy/etc/**: (*$POLICY_HOME/etc*) miscellaneous configuration such as certificate stores.

The following command can be used to explore the directory layout.

.. code-block:: bash

    docker run --rm -it nexus3.onap.org:10001/onap/policy-drools:1.8.2 -- bash

Communication Endpoints
=======================

PDP-D supports the following networked infrastructures.   This is also referred to as
*communication infrastructures* in the source code.

- DMaaP
- UEB
- NOOP
- Http Servers
- Http Clients

The source code is located at
`the policy-endpoints module <https://git.onap.org/policy/common/tree/policy-endpoints>`__
in the *policy/commons* repository.

These network resources are *named* and typically have a *global* scope, therefore typically visible to
the PDP-D engine (for administration purposes), application *controllers*,
and *features*.

DMaaP, UEB, and NOOP are message-based communication infrastructures, hence the terminology of
source and sinks, to denote their directionality into or out of the *controller*, respectively.

An endpoint can either be *managed* or *unmanaged*.  The default for an endpoint is to be *managed*,
meaning that they are globally accessible by name, and managed by the PDP-D engine.
*Unmanaged* topics are used when neither global visibility, or centralized PDP-D management is desired.
The software that uses *unmanaged* topics is responsible for their lifecycle management.

DMaaP Endpoints
~~~~~~~~~~~~~~~

These are messaging enpoints that use DMaaP as the communication infrastructure.

Typically, a *managed* endpoint configuration is stored in the *<topic-name>-topic.properties* files.

For example, the
`DCAE_TOPIC-topic.properties <https://git.onap.org/policy/drools-applications/tree/controlloop/common/feature-controlloop-management/src/main/feature/config/DCAE_TOPIC-topic.properties>`__ is defined as

.. code-block:: bash

    dmaap.source.topics=DCAE_TOPIC

    dmaap.source.topics.DCAE_TOPIC.effectiveTopic=${env:DCAE_TOPIC}
    dmaap.source.topics.DCAE_TOPIC.servers=${env:DMAAP_SERVERS}
    dmaap.source.topics.DCAE_TOPIC.consumerGroup=${env:DCAE_CONSUMER_GROUP}
    dmaap.source.topics.DCAE_TOPIC.https=true

In this example, the generic name of the *source* endpoint
is *DCAE_TOPIC*.  This is known as the *canonical* name.
The actual *topic* used in communication exchanges in a physical lab is contained
in the *$DCAE_TOPIC* environment variable.   This environment variable is usually
set up by *devops* on a per installation basis to meet the needs of each
lab spec.

In the previous example, *DCAE_TOPIC* is a source-only topic.

Sink topics are similarly specified but indicating that are sink endpoints
from the perspective of the *controller*.  For example, the *APPC-CL* topic
is configured as

.. code-block:: bash

    dmaap.source.topics=APPC-CL
    dmaap.sink.topics=APPC-CL

    dmaap.source.topics.APPC-CL.servers=${env:DMAAP_SERVERS}
    dmaap.source.topics.APPC-CL.https=true

    dmaap.sink.topics.APPC-CL.servers=${env:DMAAP_SERVERS}
    dmaap.sink.topics.APPC-CL.https=true

Although not shown in these examples, additional configuration options are available such as *user name*,
*password*, *security keys*, *consumer group* and *consumer instance*.

UEB Endpoints
~~~~~~~~~~~~~

Similary, UEB endpoints are messaging endpoints, similar to the DMaaP ones.

For example, the
`DCAE_TOPIC-topic.properties <https://git.onap.org/policy/drools-applications/tree/controlloop/common/feature-controlloop-management/src/main/feature/config/DCAE_TOPIC-topic.properties>`__ can be converted to an *UEB* one, by replacing the
*dmaap* prefix with *ueb*.  For example:

.. code-block:: bash

    ueb.source.topics=DCAE_TOPIC

    ueb.source.topics.DCAE_TOPIC.effectiveTopic=${env:DCAE_TOPIC}
    ueb.source.topics.DCAE_TOPIC.servers=${env:DMAAP_SERVERS}
    ueb.source.topics.DCAE_TOPIC.consumerGroup=${env:DCAE_CONSUMER_GROUP}
    ueb.source.topics.DCAE_TOPIC.https=true

NOOP Endpoints
~~~~~~~~~~~~~~

NOOP (no-operation) endpoints are messaging endpoints that don't have any network attachments.
They are used for testing convenience.
To convert the
`DCAE_TOPIC-topic.properties <https://git.onap.org/policy/drools-applications/tree/controlloop/common/feature-controlloop-management/src/main/feature/config/DCAE_TOPIC-topic.properties>`__ to a *NOOP* endpoint, simply replace the *dmaap* prefix with *noop*:

.. code-block:: bash

    noop.source.topics=DCAE_TOPIC
    noop.source.topics.DCAE_TOPIC.effectiveTopic=${env:DCAE_TOPIC}

HTTP Clients
~~~~~~~~~~~~

HTTP Clients are typically stored in files following the naming convention: *<name>-http-client.properties* convention.
One such example is
the `AAI HTTP Client <https://git.onap.org/policy/drools-applications/tree/controlloop/common/feature-controlloop-management/src/main/feature/config/AAI-http-client.properties>`__:

.. code-block:: bash

    http.client.services=AAI

    http.client.services.AAI.managed=true
    http.client.services.AAI.https=true
    http.client.services.AAI.host=${envd:AAI_HOST}
    http.client.services.AAI.port=${envd:AAI_PORT}
    http.client.services.AAI.userName=${envd:AAI_USERNAME}
    http.client.services.AAI.password=${envd:AAI_PASSWORD}
    http.client.services.AAI.contextUriPath=${envd:AAI_CONTEXT_URI}

HTTP Servers
~~~~~~~~~~~~

HTTP Servers are stored in files that follow a similar naming convention *<name>-http-server.properties*.
The following is an example of a server named *CONFIG*, getting most of its configuration from
environment variables.

.. code-block:: bash

    http.server.services=CONFIG

    http.server.services.CONFIG.host=${envd:TELEMETRY_HOST}
    http.server.services.CONFIG.port=7777
    http.server.services.CONFIG.userName=${envd:TELEMETRY_USER}
    http.server.services.CONFIG.password=${envd:TELEMETRY_PASSWORD}
    http.server.services.CONFIG.restPackages=org.onap.policy.drools.server.restful
    http.server.services.CONFIG.managed=false
    http.server.services.CONFIG.swagger=true
    http.server.services.CONFIG.https=true
    http.server.services.CONFIG.aaf=${envd:AAF:false}

*Endpoints* configuration resides in the *$POLICY_HOME/config* (or *$POLICY_CONFIG*) directory in a container.

Controllers
===========

*Controllers* are the means for the PDP-D to run *applications*.   Controllers are
defined in *<name>-controller.properties* files.

For example, see the
`usecases controller configuration <https://git.onap.org/policy/drools-applications/tree/controlloop/common/feature-controlloop-usecases/src/main/feature/config/usecases-controller.properties>`__.

This configuration file has two sections: *a)* application maven coordinates, and *b)* endpoint references and coders.

Maven Coordinates
~~~~~~~~~~~~~~~~~

The coordinates section (*rules*) points to the *controller-usecases* *kjar* artifact.
It is the *brain* of the control loop application.

.. code-block:: bash

    controller.name=usecases

    rules.groupId=${project.groupId}
    rules.artifactId=controller-usecases
    rules.version=${project.version}
    .....

This *kjar* contains the
`usecases DRL <https://git.onap.org/policy/drools-applications/tree/controlloop/common/controller-usecases/src/main/resources/usecases.drl>`__ file (there may be more than one DRL file included).

.. code-block:: bash

    ...
    rule "NEW.TOSCA.POLICY"
        when
            $policy : ToscaPolicy()
        then

        ...

        ControlLoopParams params = ControlLoopUtils.toControlLoopParams($policy);
        if (params != null) {
            insert(params);
        }
    end
    ...

The DRL in conjuction with the dependent java libraries in the kjar
`pom <https://git.onap.org/policy/drools-applications/tree/controlloop/common/controller-usecases/pom.xml>`__
realizes the application's function.  For intance, it realizes the
vFirewall, vCPE, and vDNS use cases in ONAP.

.. code-block:: bash

    ..
    <dependency>
        <groupId>org.onap.policy.models.policy-models-interactions.model-actors</groupId>
        <artifactId>actor.appclcm</artifactId>
        <version>${policy.models.version}</version>
        <scope>provided</scope>
    </dependency>
    ...

Endpoints References and Coders
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The *usecases-controller.properties* configuration also contains a mix of
source (of incoming controller traffic) and sink (of outgoing controller traffic)
configuration.  This configuration also contains specific
filtering and mapping rules for incoming and outgoing dmaap messages
known as *coders*.

.. code-block:: bash

    ...
    dmaap.source.topics=DCAE_TOPIC,APPC-CL,APPC-LCM-WRITE,SDNR-CL-RSP
    dmaap.sink.topics=APPC-CL,APPC-LCM-READ,POLICY-CL-MGT,SDNR-CL,DCAE_CL_RSP


    dmaap.source.topics.APPC-LCM-WRITE.events=org.onap.policy.appclcm.AppcLcmDmaapWrapper
    dmaap.source.topics.APPC-LCM-WRITE.events.org.onap.policy.appclcm.AppcLcmDmaapWrapper.filter=[?($.type == 'response')]
    dmaap.source.topics.APPC-LCM-WRITE.events.custom.gson=org.onap.policy.appclcm.util.Serialization,gson

    dmaap.sink.topics.APPC-CL.events=org.onap.policy.appc.Request
    dmaap.sink.topics.APPC-CL.events.custom.gson=org.onap.policy.appc.util.Serialization,gsonPretty
    ...

In this example, the *coders* specify that incoming messages over the DMaaP endpoint
reference *APPC-LCM-WRITE*, that have a field called *type* under the root JSON object with
value *response* are allowed into the *controller* application.  In this case, the incoming
message is converted into an object (fact) of type *org.onap.policy.appclcm.AppcLcmDmaapWrapper*.
The *coder* has attached a custom implementation provided by the *application* with class
*org.onap.policy.appclcm.util.Serialization*.  Note that the *coder* filter is expressed in JSONPath notation.

Note that not all the communication endpoint references need to be explicitly referenced within the
*controller* configuration file.  For example, *Http clients* do not.
The reasons are historical, as the PDP-D was initially intended to only communicate
through messaging-based protocols such as UEB or DMaaP in asynchronous unidirectional mode.
The introduction of *Http* with synchronous bi-directional communication with remote endpoints made
it more convenient for the application to manage each network exchange.

*Controllers* configuration resides in the *$POLICY_HOME/config* (or *$POLICY_CONFIG*) directory in a container.

Other Configuration Files
~~~~~~~~~~~~~~~~~~~~~~~~~

There are other types of configuration files that *controllers* can use, for example *.environment* files
that provides a means to share data across applications.   The
`controlloop.properties.environment <https://git.onap.org/policy/drools-applications/tree/controlloop/common/feature-controlloop-management/src/main/feature/config/controlloop.properties.environment>`__ is one such example.


Tosca Policies
==============

PDP-D supports Tosca Policies through the *feature-lifecycle*.    The *PDP-D* receives its policy set
from the *PAP*.    A policy conforms to its Policy Type specification.
Policy Types and policy creation is done by the *API* component.
Policy deployments are orchestrated by the *PAP*.

All communication between *PAP* and PDP-D is over the DMaaP *POLICY-PDP-PAP* topic.

Native Policy Types
~~~~~~~~~~~~~~~~~~~

The PDP-D Engine supports two (native) Tosca policy types by means of the *lifecycle*
feature:

- *onap.policies.native.drools.Controller*
- *onap.policies.native.drools.Artifact*

These types can be used to dynamically deploy or undeploy application *controllers*,
assign policy types, and upgrade or downgrade their attached maven artifact versions.

For instance, an
`example native controller <https://git.onap.org/policy/drools-pdp/tree/feature-lifecycle/src/test/resources/tosca-policy-native-controller-example.json>`__ policy is shown below.

.. code-block:: bash

    {
        "tosca_definitions_version": "tosca_simple_yaml_1_0_0",
        "topology_template": {
            "policies": [
                {
                    "example.controller": {
                        "type": "onap.policies.native.drools.Controller",
                        "type_version": "1.0.0",
                        "version": "1.0.0",
                        "name": "example.controller",
                        "metadata": {
                            "policy-id": "example.controller"
                        },
                        "properties": {
                            "controllerName": "lifecycle",
                            "sourceTopics": [
                                {
                                    "topicName": "DCAE_TOPIC",
                                    "events": [
                                        {
                                            "eventClass": "java.util.HashMap",
                                            "eventFilter": "[?($.closedLoopEventStatus == 'ONSET')]"
                                        },
                                        {
                                            "eventClass": "java.util.HashMap",
                                            "eventFilter": "[?($.closedLoopEventStatus == 'ABATED')]"
                                        }
                                    ]
                                }
                            ],
                            "sinkTopics": [
                                {
                                    "topicName": "APPC-CL",
                                    "events": [
                                        {
                                            "eventClass": "java.util.HashMap",
                                            "eventFilter": "[?($.CommonHeader && $.Status)]"
                                        }
                                    ]
                                }
                            ],
                            "customConfig": {
                                "field1" : "value1"
                            }
                        }
                    }
                }
            ]
        }
    }

The actual application coordinates are provided with a policy of type onap.policies.native.drools.Artifact,
see the `example native artifact <https://git.onap.org/policy/drools-pdp/tree/feature-lifecycle/src/test/resources/tosca-policy-native-artifact-example.json>`__

.. code-block:: bash

    {
        "tosca_definitions_version": "tosca_simple_yaml_1_0_0",
        "topology_template": {
            "policies": [
                {
                    "example.artifact": {
                        "type": "onap.policies.native.drools.Artifact",
                        "type_version": "1.0.0",
                        "version": "1.0.0",
                        "name": "example.artifact",
                        "metadata": {
                            "policy-id": "example.artifact"
                        },
                        "properties": {
                            "rulesArtifact": {
                                "groupId": "org.onap.policy.drools.test",
                                "artifactId": "lifecycle",
                                "version": "1.0.0"
                            },
                            "controller": {
                                "name": "lifecycle"
                            }
                        }
                    }
                }
            ]
        }
    }

Operational Policy Types
~~~~~~~~~~~~~~~~~~~~~~~~

The PDP-D also recognizes Tosca Operational Policies, although it needs an
application *controller* that understands them to execute them.   These are:

- *onap.policies.controlloop.operational.common.Drools*

A minimum of one application *controller* that supports these capabilities
must be installed in order to honor the *operational policy types*.
One such controller is the *usecases* controller residing in the
`policy/drools-applications <https://git.onap.org/policy/drools-applications>`__
repository.

Controller Policy Type Support
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Note that a *controller* may support other policy types. A controller may declare them
explicitly in a native *onap.policies.native.drools.Controller* policy.

.. code-block:: bash

    "customConfig": {
        "controller.policy.types" : "policy.type.A"
    }

The *controller* application could declare its supported policy types in the *kjar*.
For example, the *usecases controller* packages this information in the
`kmodule.xml <https://git.onap.org/policy/drools-applications/tree/controlloop/common/controller-usecases/src/main/resources/META-INF/kmodule.xml>`__.    One advantage of this approach is that the PDP-D would only
commit to execute policies against these policy types if a supporting controller is up and running.

.. code-block:: bash

    <kmodule xmlns="http://jboss.org/kie/6.0.0/kmodule">
        <kbase name="onap.policies.controlloop.operational.common.Drools" default="false" equalsBehavior="equality"/>
        <kbase name="onap.policies.controlloop.Operational" equalsBehavior="equality"
               packages="org.onap.policy.controlloop" includes="onap.policies.controlloop.operational.common.Drools">
            <ksession name="usecases"/>
        </kbase>
    </kmodule>

Software Architecture
=====================

PDP-D is divided into 2 layers:

- core (`policy-core <https://git.onap.org/policy/drools-pdp/tree/policy-core>`__)
- management (`policy-management <https://git.onap.org/policy/drools-pdp/tree/policy-management>`__)

Core Layer
~~~~~~~~~~

The core layer directly interfaces with the *drools* libraries with 2 main abstractions:

* `PolicyContainer <https://git.onap.org/policy/drools-pdp/tree/policy-core/src/main/java/org/onap/policy/drools/core/PolicyContainer.java>`__, and
* `PolicySession <https://git.onap.org/policy/drools-pdp/tree/policy-core/src/main/java/org/onap/policy/drools/core/PolicySession.java>`__.

Policy Container and Sessions
"""""""""""""""""""""""""""""

The *PolicyContainer* abstracts the drools *KieContainer*, while a *PolicySession* abstracts a drools *KieSession*.
PDP-D uses stateful sessions in active mode (*fireUntilHalt*) (please visit the `drools <https://www.drools.org/>`__
website for additional documentation).

Management Layer
~~~~~~~~~~~~~~~~

The management layer manages the PDP-D and builds on top of the *core* capabilities.

PolicyEngine
""""""""""""

The PDP-D `PolicyEngine <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/system/PolicyEngine.java>`__ is the top abstraction and abstracts away the PDP-D and all the
resources it holds.   The reader looking at the source code can start looking at this component
in a top-down fashion.   Note that the *PolicyEngine* abstraction should not be confused with the
sofware in the *policy/engine* repository, there is no relationship whatsoever other than in the naming.

The *PolicyEngine* represents the PDP-D, holds all PDP-D resources, and orchestrates activities among those.

The *PolicyEngine* manages applications via the `PolicyController <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/system/PolicyController.java>`__ abstractions in the base code.  The
relationship between the *PolicyEngine* and *PolicyController* is one to many.

The *PolicyEngine* holds other global resources such as a *thread pool*, *policies validator*, *telemetry* server,
and *unmanaged* topics for administration purposes.

The *PolicyEngine* has interception points that allow
`*features* <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/features/PolicyEngineFeatureApi.java>`__
to observe and alter the default *PolicyEngine* behavior.

The *PolicyEngine* implements the `*Startable* <https://git.onap.org/policy/common/tree/capabilities/src/main/java/org/onap/policy/common/capabilities/Startable.java>`__ and `*Lockable* <https://git.onap.org/policy/common/tree/capabilities/src/main/java/org/onap/policy/common/capabilities/Lockable.java>`__ interfaces.   These operations
have a cascading effect on the resources the *PolicyEngine* holds, as it is the top level entity, thus
affecting *controllers* and *endpoints*.   These capabilities are intended to be used for extensions,
for example active/standby multi-node capabilities.   This programmability is
exposed via the *telemetry* API, and *feature* hooks.

Configuration
^^^^^^^^^^^^^

*PolicyEngine* related configuration is located in the
`engine.properties <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/server/config/engine.properties>`__,
and `engine-system.properties <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/server/config/engine.properties>`__.

The *engine* configuration files reside in the *$POLICY_CONFIG* directory.

PolicyController
""""""""""""""""

A *PolicyController* represents an application.   Each *PolicyController* has an instance of a
`DroolsController <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/system/PolicyController.java>`__.   The *PolicyController* provides the means to group application specific resources
into a single unit.  Such resources include the application's *maven coordinates*, *endpoint references*, and *coders*.

A *PolicyController* uses a
`DroolsController <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/controller/DroolsController.java>`__ to interface with the *core* layer (*PolicyContainer* and *PolicySession*).

The relationship between the *PolicyController* and the *DroolsController* is one-to-one.
The *DroolsController* currently supports 2 implementations, the
`MavenDroolsController <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/controller/internal/MavenDroolsController.java>`__, and the
`NullDroolsController <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/controller/internal/NullDroolsController.java>`__.
The *DroolsController*'s polymorphic behavior depends on whether a maven artifact is attached to the controller or not.

Configuration
^^^^^^^^^^^^^

The *controllers* configuration resides in the *$POLICY_CONFIG* directory.

Programmability
~~~~~~~~~~~~~~~

PDP-D is programmable through:

- Features and Event Listeners.
- Maven-Drools applications.

Using Features and Listeners
""""""""""""""""""""""""""""

Features hook into the interception points provided by the the *PDP-D* main entities.

*Endpoint Listeners*, see `here <https://git.onap.org/policy/common/tree/policy-endpoints/src/main/java/org/onap/policy/common/endpoints/event/comm/TopicListener.java>`__
and `here <https://git.onap.org/policy/common/tree/policy-endpoints/src/main/java/org/onap/policy/common/endpoints/listeners>`__, can be used in conjuction with features for additional capabilities.

Using Maven-Drools applications
"""""""""""""""""""""""""""""""

Maven-based drools applications can run any arbitrary functionality structured with rules and java logic.

Recommended Flow
""""""""""""""""

Whenever possible it is suggested that PDP-D related operations flow through the
*PolicyEngine* downwards in a top-down manner.  This imposed order implies that
all the feature hooks are always invoked in a deterministic fashion.   It is also
a good mechanism to safeguard against deadlocks.

Telemetry Extensions
""""""""""""""""""""

It is recommended to *features* (extensions) to offer a diagnostics REST API
to integrate with the telemetry API.   This is done by placing JAX-RS files under
the package *org.onap.policy.drools.server.restful*.   The root context path
for all the telemetry services is */policy/pdp/engine*.

Features
========

*Features* is an extension mechanism for the PDP-D functionality.
Features can be toggled on and off.
A feature is composed of:

- Java libraries.
- Scripts and configuration files.

Java Extensions
~~~~~~~~~~~~~~~

Additional functionality can be provided in the form of java libraries that hook into the
*PolicyEngine*, *PolicyController*, *DroolsController*, and *PolicySession* interception
points to observe or alter the PDP-D logic.

See the Feature APIs available in the
`management <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/features>`__
and
`core  <https://git.onap.org/policy/drools-pdp/tree/policy-core/src/main/java/org/onap/policy/drools/core/PolicySessionFeatureApi.java>`__ layers.

The convention used for naming these extension modules are *api-<name>* for interfaces,
and *feature-<name>* for the actual java extensions.

Configuration Items
~~~~~~~~~~~~~~~~~~~

Installation items such as scripts, SQL, maven artifacts, and configuration files.

The reader can refer to the `policy/drools-pdp repository <https://git.onap.org/policy/drools-pdp>`__
and the <https://git.onap.org/policy/drools-applications>`__ repository for miscellaneous feature
implementations.

Layout
""""""

A feature is packaged in a *feature-<name>.zip* and has this internal layout:

.. code-block:: bash

    # #######################################################################################
    # Features Directory Layout:
    #
    # $POLICY_HOME/
    #   L─ features/
    #        L─ <feature-name>*/
    #            L─ [config]/
    #            |   L─ <config-file>+
    #            L─ [bin]/
    #            |   L─ <bin-file>+
    #            L─ lib/
    #            |   L─ [dependencies]/
    #            |   |   L─ <dependent-jar>+
    #            │   L─ feature/
    #            │       L─ <feature-jar>
    #            L─ [db]/
    #            │   L─ <db-name>/+
    #            │       L─ sql/
    #            │           L─ <sql-scripts>*
    #            L─ [artifacts]/
    #                L─ <artifact>+
    #            L─ [install]
    #                L─ [enable]
    #                L─ [disable]
    #                L─ [other-directories-or-files]
    #
    # notes:  [] = optional , * = 0 or more , + = 1 or more
    #   <feature-name> directory without "feature-" prefix.
    #   [config]       feature configuration directory that contains all configuration
    #                  needed for this features
    #   [config]/<config-file>  preferably named with "feature-<feature-name>" prefix to
    #                  precisely match it against the exact features, source code, and
    #                  associated wiki page for configuration details.
    #   [bin]       feature bin directory that contains helper scripts for this feature
    #   [bin]/<executable-file>  preferably named with "feature-<feature-name>" prefix.
    #   lib            jar libraries needed by this features
    #   lib/[dependencies]  3rd party jar dependencies not provided by base installation
    #                  of pdp-d that are necessary for <feature-name> to operate
    #                  correctly.
    #   lib/feature    the single feature jar that implements the feature.
    #   [db]           database directory, if the feature contains sql.
    #   [db]/<db-name> database to which underlying sql scripts should be applied.
    #                  ideally, <db-name> = <feature-name> so it is easily to associate
    #                  the db data with a feature itself.   In addition, since a feature is
    #                  a somewhat independent isolated unit of functionality,the <db-name>
    #                  database ideally isolates all its data.
    #   [db]/<db-name>/sql  directory with all the sql scripts.
    #   [db]/<db-name>/sql/<sql-scripts>  for this feature, sql
    #                  upgrade scripts should be suffixed with ".upgrade.sql"
    #                  and downgrade scripts should be suffixed with ".downgrade.sql"
    #   [artifacts]    maven artifacts to be deployed in a maven repository.
    #   [artifacts]/<artifact>  maven artifact with identifiable maven coordinates embedded
    #                  in the artifact.
    #   [install]      custom installation directory where custom enable or disable scripts
    #                  and other free form data is included to be used for the enable and
    #                  and disable scripts.
    #   [install]/[enable] enable script executed when the enable operation is invoked in
    #                  the feature.
    #   [install]/[disable] disable script executed when the disable operation is invoked in
    #                  the feature.
    #   [install]/[other-directories-or-files] other executables, or data that can be used
    #                  by the feature for any of its operations.   The content is determined
    #                  by the feature designer.
    # ########################################################################################

The `features <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/server-gen/bin/features>`__
is the tool used for administration purposes:

.. code-block:: bash

		Usage:  features status
		            Get enabled/disabled status on all features
		        features enable <feature> ...
		            Enable the specified feature
		        features disable <feature> ...
		            Disable the specified feature
		        features install [ <feature> | <file-name> ] ...
		            Install the specified feature
		        features uninstall <feature> ...
		            Uninstall the specified feature

Features available in the Docker image
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The only enabled feature in the *onap/policy-drools* image is:

- **lifecycle**: enables the lifecycle capability to integrate with the Policy Framework components.

The following features are included in the image but disabled.

- **distributed locking**: distributed resource locking.
- **healthcheck**: basic PDP-D Engine healthcheck.

Healthcheck
"""""""""""

The Healthcheck feature provides reports used to verify the health of *PolicyEngine.manager* in addition to the construction, operation, and deconstruction of HTTP server/client objects.

When enabled, the feature takes as input a properties file named "*feature-healtcheck.properties*.
This file should contain configuration properties necessary for the construction of HTTP client and server objects.

Upon initialization, the feature first constructs HTTP server and client objects using the properties
from its properties file. A healthCheck operation is then triggered. The logic of the healthCheck verifies
that *PolicyEngine.manager* is alive, and iteratively tests each HTTP server object by sending HTTP GET
requests using its respective client object. If a server returns a "200 OK" message, it is marked as "healthy"
in its individual report. Any other return code results in an "unhealthy" report.

After the testing of the server objects has completed, the feature returns a single consolidated report.

Lifecycle
"""""""""

The "lifecycle" feature enables a PDP-D to work with the architectural framework introduced in the
Dublin release.

The lifecycle feature maintains three states: TERMINATED, PASSIVE, and ACTIVE.
The PAP interacts with the lifecycle feature to put a PDP-D in PASSIVE or ACTIVE states.
The PASSIVE state allows for Tosca Operational policies to be deployed.
Policy execution is enabled when the PDP-D transitions to the ACTIVE state.

This feature can coexist side by side with the legacy mode of operation that pre-dates the Dublin release.

Distributed Locking
"""""""""""""""""""

The Distributed Locking Feature provides locking of resources across a pool of PDP-D hosts.
The list of locks is maintained in a database, where each record includes a resource identifier,
an owner identifier, and an expiration time.  Typically, a drools application will unlock the resource
when it's operation completes.  However, if it fails to do so, then the resource will be automatically
released when the lock expires, thus preventing a resource from becoming permanently locked.

Other features
~~~~~~~~~~~~~~

The following features have been contributed to the *policy/drools-pdp* but are either
unnecessary or have not been thoroughly tested:

.. toctree::
   :maxdepth: 1

   feature_activestdbymgmt.rst
   feature_controllerlogging.rst
   feature_eelf.rst
   feature_mdcfilters.rst
   feature_pooling.rst
   feature_sesspersist.rst
   feature_statemgmt.rst
   feature_testtransaction.rst
   feature_nolocking.rst

Data Migration
==============

PDP-D data is migrated across releases with the
`db-migrator <https://git.onap.org/policy/docker/tree/policy-db-migrator/src/main/docker/db-migrator>`__.

The migration occurs when different release data is detected. *db-migrator* will look under the
*$POLICY_HOME/etc/db/migration* for databases and SQL scripts to migrate.

.. code-block:: bash

    $POLICY_HOME/etc/db/migration/<schema-name>/sql/<sql-file>

where *<sql-file>* is of the form:

.. code-block:: bash

    <VERSION>-<pdp|feature-name>[-description](.upgrade|.downgrade).sql

The db-migrator tool syntax is

.. code-block:: bash

    syntax: db-migrator
    	 -s <schema-name>
    	 [-b <migration-dir>]
    	 [-f <from-version>]
    	 [-t <target-version>]
    	 -o <operations>

    	 where <operations>=upgrade|downgrade|auto|version|erase|report

    Configuration Options:
    	 -s|--schema|--database:  schema to operate on ('ALL' to apply on all)
    	 -b|--basedir: overrides base DB migration directory
    	 -f|--from: overrides current release version for operations
    	 -t|--target: overrides target release to upgrade/downgrade

    Operations:
    	 upgrade: upgrade operation
    	 downgrade: performs a downgrade operation
    	 auto: autonomous operation, determines upgrade or downgrade
    	 version: returns current version, and in conjunction if '-f' sets the current version
    	 erase: erase all data related <schema> (use with care)
    	 report: migration detailed report on an schema
    	 ok: is the migration status valid

See the
`feature-distributed-locking sql directory <https://git.onap.org/policy/docker/tree/policy-db-migrator/src/main/docker/config/pooling/sql>`__
for an example of upgrade/downgrade scripts.

The following command will provide a report on the upgrade or downgrade activies:

.. code-block:: bash

    db-migrator -s ALL -o report

For example in the official guilin delivery:

.. code-block:: bash

    policy@dev-drools-0:/tmp/policy-install$ db-migrator -s ALL -o report
    +---------+---------+
    | name    | version |
    +---------+---------+
    | pooling | 1811    |
    +---------+---------+
    +-------------------------------------+-----------+---------+---------------------+
    | script                              | operation | success | atTime              |
    +-------------------------------------+-----------+---------+---------------------+
    | 1804-distributedlocking.upgrade.sql | upgrade   | 1       | 2020-05-22 19:33:09 |
    | 1811-distributedlocking.upgrade.sql | upgrade   | 1       | 2020-05-22 19:33:09 |
    +-------------------------------------+-----------+---------+---------------------+

In order to use the *db-migrator* tool, the system must be configured with a database.

.. code-block:: bash

    SQL_HOST=mariadb

Maven Repositories
==================

The drools libraries in the PDP-D uses maven to fetch rules artifacts and software dependencies.

The default *settings.xml* file specifies the repositories to search.   This configuration
can be overriden with a custom copy that would sit in a mounted configuration
directory.  See an example of the OOM override
`settings.xml <https://github.com/onap/oom/blob/master/kubernetes/policy/components/policy-drools-pdp/resources/configmaps/settings.xml>`_.

The default ONAP installation of the *control loop* child image *onap/policy-pdpd-cl:1.6.4* is *OFFLINE*.
In this configuration, the *rules* artifact and the *dependencies* retrieves all the artifacts from the local
maven repository.   Of course, this requires that the maven dependencies are preloaded in the local
repository for it to work.

An offline configuration requires two items:

- *OFFLINE* environment variable set to true.
- override *settings.xml* customization, see
  `settings.xml <https://github.com/onap/oom/blob/master/kubernetes/policy/components/policy-drools-pdp/resources/configmaps/settings.xml>`_.

The default mode in the *onap/policy-drools:1.6.3* is ONLINE instead.

In *ONLINE* mode, the *controller* initialization can take a significant amount of time.

The Policy ONAP installation includes a *nexus* repository component that can be used to host any arbitrary
artifacts that an PDP-D application may require.
The following environment variables configure its location:

.. code-block:: bash

    SNAPSHOT_REPOSITORY_ID=policy-nexus-snapshots
    SNAPSHOT_REPOSITORY_URL=http://nexus:8080/nexus/content/repositories/snapshots/
    RELEASE_REPOSITORY_ID=policy-nexus-releases
    RELEASE_REPOSITORY_URL=http://nexus:8080/nexus/content/repositories/releases/
    REPOSITORY_OFFLINE=false

The *deploy-artifact* tool is used to deploy artifacts to the local or remote maven repositories.
It also allows for dependencies to be installed locally.  The *features* tool invokes it when artifacts are
to be deployed as part of a feature.   The tool can be useful for developers to test a new application
in a container.

.. code-block:: bash

    syntax: deploy-artifact
    	 [-f|-l|-d]
    	 -s <custom-settings>
    	 -a <artifact>

    Options:
    	 -f|--file-repo: deploy in the file repository
    	 -l|--local-repo: install in the local repository
    	 -d|--dependencies: install dependencies in the local repository
    	 -s|--settings: custom settings.xml
    	 -a|--artifact: file artifact (jar or pom) to deploy and/or install

AAF
===

Policy can talk to AAF for authorization requests.   To enable AAF set
the following environment variables:

.. code-block:: bash

    AAF=true
    AAF_NAMESPACE=org.onap.policy
    AAF_HOST=aaf-locate.onap

By default AAF is disabled.

Policy Tool
===========

The *policy* tool can be used to stop, start, and provide status on the PDP-D.

.. code-block:: bash

    syntax: policy [--debug] status|start|stop

The *status* option provides generic status of the system.

.. code-block:: bash

    [drools-pdp-controllers]
     L []: Policy Management (pid 408) is running
    	0 cron jobs installed.

    [features]
    name                   version         status
    ----                   -------         ------
    healthcheck            1.6.3           enabled
    distributed-locking    1.6.3           enabled
    lifecycle              1.6.3           enabled
    controlloop-management 1.6.4           enabled
    controlloop-utils      1.6.4           enabled
    controlloop-trans      1.6.4           enabled
    controlloop-usecases   1.6.4           enabled

    [migration]
    pooling: OK @ 1811

It contains 3 sections:

- *PDP-D* running status
- *features* applied
- Data migration status on a per database basis.

The *start* and *stop* commands are useful for developers testing functionality on a docker container instance.

Telemetry Shell
===============

*PDP-D* offers an ample set of REST APIs to debug, introspect, and change state on a running PDP-D.   This is known as the
*telemetry* API.   The *telemetry* shell wraps these APIs for shell-like access using
`http-prompt <http://http-prompt.com/>`__.

.. code-block:: bash

    policy@dev-drools-0:~$ telemetry
    Version: 1.0.0
    https://localhost:9696/policy/pdp/engine> get controllers
    HTTP/1.1 200 OK
    Content-Length: 13
    Content-Type: application/json
    Date: Thu, 04 Jun 2020 01:07:38 GMT
    Server: Jetty(9.4.24.v20191120)

    [
        "usecases"
    ]

    https://localhost:9696/policy/pdp/engine> exit
    Goodbye!
    policy@dev-drools-0:~$


Other tools
===========

Refer to the *$POLICY_HOME/bin/* directory for additional tooling.

PDP-D Docker Container Configuration
====================================

Both the PDP-D *onap/policy-drools* and *onap/policy-pdpd-cl* images can be used without other components.

There are 2 types of configuration data provided to the container:

1. environment variables.
2. configuration files and shell scripts.

Environment variables
~~~~~~~~~~~~~~~~~~~~~

As it was shown in the *controller* and *endpoint* sections, PDP-D configuration can rely
on environment variables.   In a container environment, these variables are set up by the user
in the host environment.

Configuration Files and Shell Scripts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PDP-D is very flexible in its configuration.

The following file types are recognized when mounted under */tmp/policy-install/config*.

These are the configuration items that can reside externally and override the default configuration:

- **settings.xml** if working with external nexus repositories.
- **standalone-settings.xml** if an external *policy* nexus repository is not available.
- ***.conf** files containing environment variables.   This is an alternative to use environment variables,
  as these files will be sourced in before the PDP-D starts.
- **features*.zip** to load any arbitrary feature not present in the image.
- ***.pre.sh** scripts that will be executed before the PDP-D starts.
- ***.post.sh** scripts that will be executed after the PDP-D starts.
- **policy-keystore** to override the default PDP-D java keystore.
- **policy-truststore** to override the default PDP-D java truststore.
- **aaf-cadi.keyfile** to override the default AAF CADI Key generated by AAF.
- ***.properties** to override or add any properties file for the PDP-D, this includes *controller*, *endpoint*,
  *engine* or *system* configurations.
- **logback*.xml** to override the default logging configuration.
- ***.xml** to override other .xml configuration that may be used for example by an *application*.
- ***.json** *json* configuration that may be used by an *application*.


Running PDP-D with a single container
=====================================

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
    POLICY_PDP_PAP_API_KEY=
    POLICY_PDP_PAP_API_SECRET=

    # DMaaP

    DMAAP_SERVERS=localhost

Note that *SQL_HOST*, and *REPOSITORY* are empty, so the PDP-D does not attempt
to integrate with those components.

Configuration
~~~~~~~~~~~~~

In order to avoid the noise in the logs that relate to dmaap configuration, a startup script (*noop.pre.sh*) is added
to convert *dmaap* endpoints to *noop* in the host directory to be mounted.

noop.pre.sh
"""""""""""

.. code-block:: bash

    #!/bin/bash -x

    sed -i "s/^dmaap/noop/g" $POLICY_HOME/config/*.properties


active.post.sh
""""""""""""""

To put the controller directly in active mode at initialization, place an *active.post.sh* script under the
mounted host directory:

.. code-block:: bash

    #!/bin/bash -x

    bash -c "http --verify=no -a ${TELEMETRY_USER}:${TELEMETRY_PASSWORD} PUT https://localhost:9696/policy/pdp/engine/lifecycle/state/ACTIVE"

Bring up the PDP-D
~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    docker run --rm -p 9696:9696 -v ${PWD}/config:/tmp/policy-install/config --env-file ${PWD}/env/env.conf -it --name PDPD -h pdpd nexus3.onap.org:10001/onap/policy-drools:1.6.3

To run the container in detached mode, add the *-d* flag.

Note that in this command, we are opening the *9696* telemetry API port to the outside world, the config directory
(where the *noop.pre.sh* customization script resides) is mounted as /tmp/policy-install/config,
and the customization environment variables (*env/env.conf*) are passed into the container.

To open a shell into the PDP-D:

.. code-block:: bash

    docker exec -it pdp-d bash

Once in the container, run tools such as *telemetry*, *db-migrator*, *policy* to look at the system state:

To run the *telemetry shell* and other tools from the host:

.. code-block:: bash

    docker exec -it PDPD bash -c "/opt/app/policy/bin/telemetry"
    docker exec -it PDPD bash -c "/opt/app/policy/bin/policy status"
    docker exec -it PDPD bash -c "/opt/app/policy/bin/db-migrator -s ALL -o report"

Controlled instantiation of the PDP-D
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sometimes a developer may want to start and stop the PDP-D manually:

.. code-block:: bash

   # start a bash

   docker run --rm -p 9696:9696 -v ${PWD}/config:/tmp/policy-install/config --env-file ${PWD}/env/env.conf -it --name PDPD -h pdpd nexus3.onap.org:10001/onap/policy-drools:1.6.3 bash

   # use this command to start policy applying host customizations from /tmp/policy-install/config

   pdpd-entrypoint.sh vmboot

   # or use this command to start policy without host customization

   policy start

   # at any time use the following command to stop the PDP-D

   policy stop

   # and this command to start the PDP-D back again

   policy start

Running PDP-D with nexus and mariadb
====================================

*docker-compose* can be used to test the PDP-D with other components.   This is an example configuration
that brings up *nexus*, *mariadb* and the PDP-D (*docker-compose-pdp.yml*)

docker-compose-pdp.yml
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    version: '3'
    services:
       mariadb:
          image: mariadb:10.2.25
          container_name: mariadb
          hostname: mariadb
          command: ['--lower-case-table-names=1', '--wait_timeout=28800']
          env_file:
             - ${PWD}/db/db.conf
          volumes:
             - ${PWD}/db:/docker-entrypoint-initdb.d
          ports:
             - "3306:3306"
       nexus:
          image: sonatype/nexus:2.14.8-01
          container_name: nexus
          hostname: nexus
          ports:
             - "8081:8081"
       drools:
          image: nexus3.onap.org:10001/onap/policy-drools:1.6.3
          container_name: drools
          depends_on:
             - mariadb
             - nexus
          hostname: drools
          ports:
             - "9696:9696"
          volumes:
             - ${PWD}/config:/tmp/policy-install/config
          env_file:
             - ${PWD}/env/env.conf

with *${PWD}/db/db.conf*:

db.conf
~~~~~~~

.. code-block:: bash

    MYSQL_ROOT_PASSWORD=secret
    MYSQL_USER=policy_user
    MYSQL_PASSWORD=policy_user

and *${PWD}/db/db.sh*:

db.sh
~~~~~

.. code-block:: bash

    for db in support onap_sdk log migration operationshistory10 pooling policyadmin operationshistory
    do
    	mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" --execute "CREATE DATABASE IF NOT EXISTS ${db};"
    	mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" --execute "GRANT ALL PRIVILEGES ON \`${db}\`.* TO '${MYSQL_USER}'@'%' ;"
    done

    mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" --execute "FLUSH PRIVILEGES;"

env.conf
~~~~~~~~

The environment file *env/env.conf* for *PDP-D* can be set up with appropriate variables to point to the *nexus* instance
and the *mariadb* database:

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

    SNAPSHOT_REPOSITORY_ID=policy-nexus-snapshots
    SNAPSHOT_REPOSITORY_URL=http://nexus:8081/nexus/content/repositories/snapshots/
    RELEASE_REPOSITORY_ID=policy-nexus-releases
    RELEASE_REPOSITORY_URL=http://nexus:8081/nexus/content/repositories/releases/
    REPOSITORY_USERNAME=admin
    REPOSITORY_PASSWORD=admin123
    REPOSITORY_OFFLINE=false

    MVN_SNAPSHOT_REPO_URL=https://nexus.onap.org/content/repositories/snapshots/
    MVN_RELEASE_REPO_URL=https://nexus.onap.org/content/repositories/releases/

    # Relational (SQL) DB access

    SQL_HOST=mariadb
    SQL_USER=policy_user
    SQL_PASSWORD=policy_user

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
    POLICY_PDP_PAP_API_KEY=
    POLICY_PDP_PAP_API_SECRET=

    # DMaaP

    DMAAP_SERVERS=localhost

prepare.pre.sh
~~~~~~~~~~~~~~

A pre-start script *config/prepare.pres.sh"can be added the custom config directory
to prepare the PDP-D to activate the distributed-locking feature (using the database)
and to use "noop" topics instead of *dmaap* topics:

.. code-block:: bash

    #!/bin/bash

    bash -c "/opt/app/policy/bin/features enable distributed-locking"
    sed -i "s/^dmaap/noop/g" $POLICY_HOME/config/*.properties

active.post.sh
~~~~~~~~~~~~~~

A post-start script *config/active.post.sh* can place PDP-D in *active* mode at initialization:

    .. code-block:: bash

    bash -c "http --verify=no -a ${TELEMETRY_USER}:${TELEMETRY_PASSWORD} PUT <http|https>://localhost:9696/policy/pdp/engine/lifecycle/state/ACTIVE"

Bring up the PDP-D, nexus, and mariadb
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To bring up the containers:

.. code-block:: bash

    docker-compose -f docker-compose-pdpd.yaml up -d

To take it down:

.. code-block:: bash

    docker-compose -f docker-compose-pdpd.yaml down -v

Other examples
~~~~~~~~~~~~~~

The reader can also look at the `policy/docker repository <https://github.com/onap/policy-docker/tree/master/csit>`__.
More specifically, these directories have examples of other PDP-D configurations:

* `plans <https://github.com/onap/policy-docker/tree/master/compose>`__: startup & teardown scripts.
* `scripts <https://github.com/onap/policy-docker/blob/master/compose/docker-compose.yml>`__: docker-compose file.
* `tests <https://github.com/onap/policy-docker/blob/master/csit/resources/tests/drools-pdp-test.robot>`__: test plan.

Configuring the PDP-D in an OOM Kubernetes installation
=======================================================

The `PDP-D OOM chart <https://github.com/onap/oom/tree/master/kubernetes/policy/components/policy-drools-pdp>`__ can be
customized at the following locations:

* `values.yaml <https://github.com/onap/oom/blob/master/kubernetes/policy/components/policy-drools-pdp/values.yaml>`__: custom values for your installation.
* `configmaps <https://github.com/onap/oom/tree/master/kubernetes/policy/components/policy-drools-pdp/resources/configmaps>`__: place in this directory any configuration extensions or overrides to customize the PDP-D that does not contain sensitive information.
* `secrets <https://github.com/onap/oom/tree/master/kubernetes/policy/components/policy-drools-pdp/resources/secrets>`__: place in this directory any configuration extensions or overrides to customize the PDP-D that does contain sensitive information.

The same customization techniques described in the docker sections for PDP-D, fully apply here, by placing the corresponding
files or scripts in these two directories.

Additional information
======================

For additional information, please see the
`Drools PDP Development and Testing (In Depth) <https://wiki.onap.org/display/DW/2020-08+Frankfurt+Tutorials>`__ page.
