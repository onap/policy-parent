.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _pdpd-engine-label:

PDP-D Engine
############

.. contents::
    :depth: 2

Overview
========

The PDP-D Core Engine provides an infrastructure and services for `drools <https://www.drools.org/>`_
based applications in the context of Policies and ONAP.

A PDP-D supports applications by means of *controllers*. A *controller* is a named grouping of
resources. These typically include references to communication endpoints, maven artifact
coordinates, and *coders* for message mapping.

*Controllers* use *communication endpoints* to interact with remote networked entities typically
using kafka messaging or http.

PDP-D Engine capabilities can be extended via *features*. Integration with other
Policy Framework components (API, PAP, and PDP-X) is through one of them (*feature-lifecycle*).

The PDP-D Engine infrastructure provides mechanisms for data migration, diagnostics, and application
management.

Software
========

Source Code repositories
~~~~~~~~~~~~~~~~~~~~~~~~

The PDP-D software is mainly located in the `policy/drools repository <https://git.onap.org/policy/drools-pdp>`_
with the *communication endpoints* software residing in the
`policy/common repository <https://git.onap.org/policy/common>`_ and Tosca policy models in the
`policy/models repository <https://git.onap.org/policy/models>`_.

Docker Image
~~~~~~~~~~~~

Check the *drools-pdp* `released versions <https://github.com/onap/policy-parent/tree/master/integration/src/main/resources/release>`_
page for the latest versions. At the time of this writing *3.0.1* is the latest version.

.. code-block:: bash

    docker pull nexus3.onap.org:10001/onap/policy-drools:3.0.1

A container instantiated from this image will run under the non-privileged *policy* account.

The PDP-D root directory is located at the */opt/app/policy* directory (or *$POLICY_HOME*), with the
exception of the *$HOME/.m2* which contains the local maven repository.
The PDP-D configuration resides in the following directories:

- **/opt/app/policy/config**: (*$POLICY_HOME/config* or *$POLICY_CONFIG*) contains *engine*,
  *controllers*, and *endpoint* configuration.
- **/home/policy/.m2**: (*$HOME/.m2*) maven repository configuration.
- **/opt/app/policy/etc/**: (*$POLICY_HOME/etc*) miscellaneous configuration such as certificate stores.

The following command can be used to explore the directory layout.

.. code-block:: bash

    docker run --rm -it nexus3.onap.org:10001/onap/policy-drools:3.0.0 -- bash

Communication Endpoints
=======================

PDP-D supports the following networked infrastructures. This is also referred to as
*communication infrastructures* in the source code.

- Kafka
- NOOP
- Http Servers
- Http Clients

The source code is located at
`the policy-endpoints module <https://git.onap.org/policy/common/tree/policy-endpoints>`_
in the *policy/commons* repository.

These network resources are *named* and typically have a *global* scope, therefore typically visible
to the PDP-D engine (for administration purposes), application *controllers*, and *features*.

Kafka and NOOP are message-based communication infrastructures, hence the terminology of
source and sinks, to denote their directionality into or out of the *controller*, respectively.

An endpoint can either be *managed* or *unmanaged*.  The default for an endpoint is to be *managed*,
meaning that they are globally accessible by name, and managed by the PDP-D engine.
*Unmanaged* topics are used when neither global visibility, or centralized PDP-D management is
desired. The software that uses *unmanaged* topics is responsible for their lifecycle management.

Kafka Topics
~~~~~~~~~~~~~~~

Typically, a *managed* topic configuration is stored in the *<topic-name>-topic.properties* files.

For example, the
`dcae_topic-topic.properties <https://git.onap.org/policy/drools-applications/tree/controlloop/common/feature-controlloop-management/src/main/feature/config/DCAE_TOPIC-topic.properties>`_ is defined as

.. code-block:: bash

    kafka.source.topics=dcae_topic
    kafka.source.topics.dcae_topic.effectiveTopic=${env:dcae_topic}
    kafka.source.topics.dcae_topic.servers=${env:KAFKA_SERVERS}
    kafka.source.topics.dcae_topic.consumerGroup=${env:DCAE_CONSUMER_GROUP}
    kafka.source.topics.dcae_topic.https=false

In this example, the generic name of the *source* topic is *dcae_topic*. This is known as the
*canonical* name. The actual *topic* used in communication exchanges in a physical lab is contained
in the *$dcae_topic* environment variable. This environment variable is usually set up by *devops*
on a per installation basis to meet the needs of each lab spec.

In the previous example, *dcae_topic* is a source-only topic.

Sink topics are similarly specified but indicating that are sink endpoints from the perspective of
the *controller*. For example, the *appc-cl* topic is configured as:

.. code-block:: bash

    kafka.source.topics=appc-cl
    kafka.sink.topics=appc-cl

    kafka.source.topics.appc-cl.servers=${env:KAFKA_SERVERS}
    kafka.source.topics.appc-cl.https=false

    kafka.sink.topics.appc-cl.servers=${env:KAFKA_SERVERS}
    kafka.sink.topics.appc-cl.https=false

Although not shown in these examples, additional configuration options are available such as
*user name*, *password*, *security keys*, *consumer group* and *consumer instance*.


NOOP Endpoints
~~~~~~~~~~~~~~

NOOP (no-operation) endpoints are messaging endpoints that don't have any network attachments.
They are used for testing convenience.
To convert the dcae_topic-topic.properties to a *NOOP* endpoint, simply replace the *kafka* prefix
with *noop*:

.. code-block:: bash

    noop.source.topics=dcae_topic
    noop.source.topics.dcae_topic.effectiveTopic=${env:dcae_topic}

HTTP Clients
~~~~~~~~~~~~

HTTP Clients are typically stored in files following the naming convention:
*<name>-http-client.properties* convention.

One such example is the
`AAI HTTP Client <https://git.onap.org/policy/drools-applications/tree/controlloop/common/feature-controlloop-management/src/main/feature/config/AAI-http-client.properties>`_:

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

HTTP Servers are stored in files that follow a similar naming convention
*<name>-http-server.properties*. The following is an example of a server named *CONFIG*, getting
most of its configuration from environment variables.

.. code-block:: bash

    http.server.services=CONFIG

    http.server.services.CONFIG.host=${envd:TELEMETRY_HOST}
    http.server.services.CONFIG.port=7777
    http.server.services.CONFIG.userName=${envd:TELEMETRY_USER}
    http.server.services.CONFIG.password=${envd:TELEMETRY_PASSWORD}
    http.server.services.CONFIG.restPackages=org.onap.policy.drools.server.restful
    http.server.services.CONFIG.managed=false
    http.server.services.CONFIG.swagger=true
    http.server.services.CONFIG.https=false

*Endpoints* configuration resides in the *$POLICY_HOME/config* (or *$POLICY_CONFIG*) directory in a
container.

Controllers
===========

*Controllers* are the means for the PDP-D to run *applications*. Controllers are defined in
*<name>-controller.properties* files.

For example, see the
`usecases controller configuration <https://git.onap.org/policy/drools-applications/tree/controlloop/common/feature-controlloop-usecases/src/main/feature/config/usecases-controller.properties>`_.

This configuration file has two sections: *a)* application maven coordinates, and *b)* endpoint
references and coders.

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
`usecases DRL <https://git.onap.org/policy/drools-applications/tree/controlloop/common/controller-usecases/src/main/resources/usecases.drl>`_
file (there may be more than one DRL file included).

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

The DRL in conjunction with the dependent java libraries in the kjar
`pom <https://git.onap.org/policy/drools-applications/tree/controlloop/common/controller-usecases/pom.xml>`_
realizes the application's function. For instance, it realizes the vFirewall, vCPE, and vDNS use
cases in ONAP.

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

The *usecases-controller.properties* configuration also contains a mix of source (of incoming
controller traffic) and sink (of outgoing controller traffic) configuration. This configuration also
contains specific filtering and mapping rules for incoming and outgoing messages known as *coders*.

.. code-block:: bash

    ...
    kafka.source.topics=dcae_topic,appc-cl,appc-lcm-write,sdnr-cl-rsp
    kafka.sink.topics=appc-cl,appc-lcm-read,policy-cl-mgt,sdnr-cl,dcae_cl_rsp

    kafka.source.topics.appc-lcm-write.events=org.onap.policy.appclcm.AppcLcmMessageWrapper
    kafka.source.topics.appc-lcm-write.events.org.onap.policy.appclcm.AppcLcmMessageWrapper.filter=[?($.type == 'response')]
    kafka.source.topics.appc-lcm-write.events.custom.gson=org.onap.policy.appclcm.util.Serialization,gson

    kafka.sink.topics.appc-cl.events=org.onap.policy.appc.Request
    kafka.sink.topics.appc-cl.events.custom.gson=org.onap.policy.appc.util.Serialization,gsonPretty
    ...

In this example, the *coders* specify that incoming messages reference *appc-lcm-write*, that have a
field called *type* under the root JSON object with value *response* are allowed into the
*controller* application. In this case, the incoming message is converted into an object (fact) of
type *org.onap.policy.appclcm.AppcLcmMessageWrapper*. The *coder* has attached a custom
implementation provided by the *application* with class
*org.onap.policy.appclcm.util.Serialization*. Note that the *coder* filter is expressed in JSONPath
notation.

Note that not all the communication endpoint references need to be explicitly referenced within the
*controller* configuration file. For example, *Http clients* do not. The reasons are historical, as
the PDP-D was initially intended to only communicate through messaging-based protocols such as UEB
or DMaaP in asynchronous unidirectional mode. The introduction of *Http* with synchronous
bi-directional communication with remote endpoints made it more convenient for the application to
manage each network exchange. UEB and DMaaP have been replaced by Kafka messaging since Kohn release.

*Controllers* configuration resides in the *$POLICY_HOME/config* (or *$POLICY_CONFIG*) directory in
a container.

Other Configuration Files
~~~~~~~~~~~~~~~~~~~~~~~~~

There are other types of configuration files that *controllers* can use, for example *.environment*
files that provides a means to share data across applications. The
`controlloop.properties.environment <https://git.onap.org/policy/drools-applications/tree/controlloop/common/feature-controlloop-management/src/main/feature/config/controlloop.properties.environment>`_
is one such example.


Tosca Policies
==============

PDP-D supports Tosca Policies through the *feature-lifecycle*. The *PDP-D* receives its policy set
from the *PAP*. A policy conforms to its Policy Type specification. Policy Types and policy creation
is done by the *API* component. Policy deployments are orchestrated by the *PAP*.

All communication between *PAP* and PDP-D is over the Kafka *policy-pdp-pap* topic.

Native Policy Types
~~~~~~~~~~~~~~~~~~~

The PDP-D Engine supports two (native) Tosca policy types by means of the *lifecycle* feature:

- *onap.policies.native.drools.Controller*
- *onap.policies.native.drools.Artifact*

These types can be used to dynamically deploy or undeploy application *controllers*,
assign policy types, and upgrade or downgrade their attached maven artifact versions.

For instance, an
`example native controller <https://git.onap.org/policy/drools-pdp/tree/feature-lifecycle/src/test/resources/tosca-policy-native-controller-example.json>`_
policy is shown below.

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
                                    "topicName": "dcae_topic",
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
                                    "topicName": "appc-cl",
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

The actual application coordinates are provided with a policy of type
onap.policies.native.drools.Artifact, see the
`example native artifact <https://git.onap.org/policy/drools-pdp/tree/feature-lifecycle/src/test/resources/tosca-policy-native-artifact-example.json>`_

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

The PDP-D also recognizes Tosca Operational Policies, although it needs an application *controller*
that understands them to execute them. These are:

- *onap.policies.controlloop.operational.common.Drools*

A minimum of one application *controller* that supports these capabilities must be installed in
order to honor the *operational policy types*. One such controller is the *usecases* controller
residing in the
`policy/drools-applications <https://git.onap.org/policy/drools-applications>`_ repository.

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
`kmodule.xml <https://git.onap.org/policy/drools-applications/tree/controlloop/common/controller-usecases/src/main/resources/META-INF/kmodule.xml>`_.    One advantage of this approach is that the PDP-D would only
commit to execute policies against these policy types if a supporting controller is up and running.

.. code-block:: bash

    <kmodule xmlns="http://www.drools.org/xsd/kmodule">
        <kbase name="onap.policies.controlloop.operational.common.Drools" equalsBehavior="equality"
               packages="org.onap.policy.controlloop">
            <ksession name="usecases"/>
        </kbase>
    </kmodule>

Software Architecture
=====================

PDP-D is divided into 2 layers:

- core (`policy-core <https://git.onap.org/policy/drools-pdp/tree/policy-core>`_)
- management (`policy-management <https://git.onap.org/policy/drools-pdp/tree/policy-management>`_)

Core Layer
~~~~~~~~~~

The core layer directly interfaces with the *drools* libraries with 2 main abstractions:

* `PolicyContainer <https://git.onap.org/policy/drools-pdp/tree/policy-core/src/main/java/org/onap/policy/drools/core/PolicyContainer.java>`_, and
* `PolicySession <https://git.onap.org/policy/drools-pdp/tree/policy-core/src/main/java/org/onap/policy/drools/core/PolicySession.java>`_.

Policy Container and Sessions
"""""""""""""""""""""""""""""

The *PolicyContainer* abstracts the drools *KieContainer*, while a *PolicySession* abstracts a
drools *KieSession*. PDP-D uses stateful sessions in active mode (*fireUntilHalt*) (please visit the
`drools <https://www.drools.org/>`_ website for additional documentation).

Management Layer
~~~~~~~~~~~~~~~~

The management layer manages the PDP-D and builds on top of the *core* capabilities.

PolicyEngine
""""""""""""

The PDP-D `PolicyEngine <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/system/PolicyEngine.java>`_ is the top abstraction and abstracts away the PDP-D and all the
resources it holds. The reader looking at the source code can start looking at this component in a
top-down fashion. Note that the *PolicyEngine* abstraction should not be confused with the software
in the *policy/engine* repository, there is no relationship whatsoever other than in the naming.

The *PolicyEngine* represents the PDP-D, holds all PDP-D resources, and orchestrates activities
among those.

The *PolicyEngine* manages applications via the `PolicyController <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/system/PolicyController.java>`_ abstractions in the base code.  The
relationship between the *PolicyEngine* and *PolicyController* is one to many.

The *PolicyEngine* holds other global resources such as a *thread pool*, *policies validator*,
*telemetry* server, and *unmanaged* topics for administration purposes.

The *PolicyEngine* has interception points that allow
`*features* <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/features/PolicyEngineFeatureApi.java>`_
to observe and alter the default *PolicyEngine* behavior.

The *PolicyEngine* implements the `*Startable* <https://git.onap.org/policy/common/tree/capabilities/src/main/java/org/onap/policy/common/capabilities/Startable.java>`_ and `*Lockable* <https://git.onap.org/policy/common/tree/capabilities/src/main/java/org/onap/policy/common/capabilities/Lockable.java>`_ interfaces.   These operations
have a cascading effect on the resources the *PolicyEngine* holds, as it is the top level entity,
thus affecting *controllers* and *endpoints*. These capabilities are intended to be used for
extensions, for example active/standby multi-node capabilities. This programmability is exposed via
the *telemetry* API, and *feature* hooks.

Configuration
^^^^^^^^^^^^^

*PolicyEngine* related configuration is located in the
`engine.properties <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/server/config/engine.properties>`_,
and `engine-system.properties <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/server/config/engine.properties>`_.

The *engine* configuration files reside in the *$POLICY_CONFIG* directory.

PolicyController
""""""""""""""""

A *PolicyController* represents an application. Each
`PolicyController <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/system/PolicyController.java>`_ has an instance of a
has an instance of a
`DroolsController <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/system/PolicyController.java>`_.
The *PolicyController* provides the means to group application specific resources into a single
unit. Such resources include the application's *maven coordinates*, *endpoint references*, and
*coders*.

A *PolicyController* uses a *DroolsController* to interface with the *core* layer (*PolicyContainer*
and *PolicySession*).

The relationship between the *PolicyController* and the *DroolsController* is one-to-one.
The *DroolsController* currently supports 2 implementations, the
`MavenDroolsController <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/controller/internal/MavenDroolsController.java>`_, and the
`NullDroolsController <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/controller/internal/NullDroolsController.java>`_.
The *DroolsController*'s polymorphic behavior depends on whether a maven artifact is attached to the
controller or not.

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

`TopicListener <https://git.onap.org/policy/common/tree/message-bus/src/main/java/org/onap/policy/common/message/bus/event/TopicListener.java>`_
and `other listeners <https://git.onap.org/policy/common/tree/policy-endpoints/src/main/java/org/onap/policy/common/endpoints/listeners>`_
, can be used in conjunction with features for additional capabilities.

Using Maven-Drools applications
"""""""""""""""""""""""""""""""

Maven-based drools applications can run any arbitrary functionality structured with rules and java
logic.

Recommended Flow
""""""""""""""""

Whenever possible it is suggested that PDP-D related operations flow through the *PolicyEngine*
downwards in a top-down manner. This imposed order implies that all the feature hooks are always
invoked in a deterministic fashion. It is also a good mechanism to safeguard against deadlocks.

Telemetry Extensions
""""""""""""""""""""

It is recommended to *features* (extensions) to offer a diagnostics REST API to integrate with the
telemetry API. This is done by placing JAX-RS files under the package
*org.onap.policy.drools.server.restful*. The root context path for all the telemetry services is
*/policy/pdp/engine*.

Features
========

*Features* is an extension mechanism for the PDP-D functionality. Features can be toggled on and off.
A feature is composed of:

- Java libraries.
- Scripts and configuration files.

Java Extensions
~~~~~~~~~~~~~~~

Additional functionality can be provided in the form of java libraries that hook into the
*PolicyEngine*, *PolicyController*, *DroolsController*, and *PolicySession* interception points to
observe or alter the PDP-D logic.

See the Feature APIs available in the
`management <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/java/org/onap/policy/drools/features>`_
and
`core  <https://git.onap.org/policy/drools-pdp/tree/policy-core/src/main/java/org/onap/policy/drools/core/PolicySessionFeatureApi.java>`_ layers.

The convention used for naming these extension modules are *api-<name>* for interfaces,
and *feature-<name>* for the actual java extensions.

Configuration Items
~~~~~~~~~~~~~~~~~~~

Installation items such as scripts, SQL, maven artifacts, and configuration files.

The reader can refer to the `policy/drools-pdp repository <https://git.onap.org/policy/drools-pdp>`_
and the `policy/drools-applications repository <https://git.onap.org/policy/drools-applications>`_
repository for miscellaneous feature implementations.

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

The `features <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/server-gen/bin/features>`_
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

The Healthcheck feature provides reports used to verify the health of *PolicyEngine.manager* in
addition to the construction, operation, and deconstruction of HTTP server/client objects.

When enabled, the feature takes as input a properties file named "*feature-healtcheck.properties*.
This file should contain configuration properties necessary for the construction of HTTP client and
server objects.

Upon initialization, the feature first constructs HTTP server and client objects using the
properties from its properties file. A healthCheck operation is then triggered. The logic of the
healthCheck verifies that *PolicyEngine.manager* is alive, and iteratively tests each HTTP server
object by sending HTTP GET requests using its respective client object. If a server returns a"200
OK" message, it is marked as "healthy" in its individual report. Any other return code results in an
"unhealthy" report.

After the testing of the server objects has completed, the feature returns a single consolidated
report.

Lifecycle
"""""""""

The "lifecycle" feature enables a PDP-D to work with the architectural framework introduced in the
Dublin release.

The lifecycle feature maintains three states: TERMINATED, PASSIVE, and ACTIVE.
The PAP interacts with the lifecycle feature to put a PDP-D in PASSIVE or ACTIVE states.
The PASSIVE state allows for Tosca Operational policies to be deployed.
Policy execution is enabled when the PDP-D transitions to the ACTIVE state.

This feature can coexist side by side with the legacy mode of operation that pre-dates the Dublin
release.

Distributed Locking
"""""""""""""""""""

The Distributed Locking Feature provides locking of resources across a pool of PDP-D hosts. The list
of locks is maintained in a database, where each record includes a resource identifier, an owner
identifier, and an expiration time. Typically, a drools application will unlock the resource when
it's operation completes. However, if it fails to do so, then the resource will be automatically
released when the lock expires, thus preventing a resource from becoming permanently locked.

Other features
~~~~~~~~~~~~~~

The following features have been contributed to the *policy/drools-pdp* but are either unnecessary
or have not been thoroughly tested:

.. toctree::
   :maxdepth: 1

   feature_pooling.rst
   feature_testtransaction.rst
   feature_nolocking.rst

Data Migration
==============

PDP-D data used to be migrated across releases with its own db-migrator until Kohn release. Since
Oslo, the main policy database manager,
`db-migrator <https://git.onap.org/policy/docker/tree/policy-db-migrator/src/main/docker/db-migrator>`_
has been in use.

The migration occurs when different release data is detected. *db-migrator* will look under the
*$POLICY_HOME/etc/db/migration* for databases and SQL scripts to migrate.

.. code-block:: bash

    $POLICY_HOME/etc/db/migration/<schema-name>/sql/<sql-file>

where *<sql-file>* is of the form:

.. code-block:: bash

    <VERSION>-<pdp|feature-name>[-description](.upgrade|.downgrade).sql

More information on DB Migrator, check :ref:`Policy DB Migrator <policy-db-migrator-label>` page.


Maven Repositories
==================

The drools libraries in the PDP-D uses maven to fetch rules artifacts and software dependencies.

The default *settings.xml* file specifies the repositories to search. This configuration can be
overwritten with a custom copy that would sit in a mounted configuration directory. See an example
of the OOM override
`settings.xml <https://github.com/onap/oom/blob/master/kubernetes/policy/components/policy-drools-pdp/resources/configmaps/settings.xml>`_.

The default ONAP installation of the *control loop* child image *onap/policy-pdpd-cl:3.0.1* is
*OFFLINE*. In this configuration, the *rules* artifact and the *dependencies* retrieves all the
artifacts from the local maven repository. Of course, this requires that the maven dependencies are
preloaded in the local repository for it to work.

An offline configuration requires two items:

- *OFFLINE* environment variable set to true.
- override *settings.xml* customization, see
  `settings.xml <https://github.com/onap/oom/blob/master/kubernetes/policy/components/policy-drools-pdp/resources/configmaps/settings.xml>`_.

The default mode in the *onap/policy-drools:3.0.1* is ONLINE instead.

In *ONLINE* mode, the *controller* initialization can take a significant amount of time.

The Policy ONAP installation includes a *nexus* repository component that can be used to host any
arbitrary artifacts that an PDP-D application may require. The following environment variables
configure its location:

.. code-block:: bash

    SNAPSHOT_REPOSITORY_ID=policy-nexus-snapshots
    SNAPSHOT_REPOSITORY_URL=http://nexus:8080/nexus/content/repositories/snapshots/
    RELEASE_REPOSITORY_ID=policy-nexus-releases
    RELEASE_REPOSITORY_URL=http://nexus:8080/nexus/content/repositories/releases/
    REPOSITORY_OFFLINE=false

The *deploy-artifact* tool is used to deploy artifacts to the local or remote maven repositories. It
also allows for dependencies to be installed locally. The *features* tool invokes it when artifacts
are to be deployed as part of a feature. The tool can be useful for developers to test a new
application in a container.

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
    healthcheck            3.0.1           enabled
    distributed-locking    3.0.1           enabled
    lifecycle              3.0.1           enabled
    controlloop-management 3.0.1           enabled
    controlloop-utils      3.0.1           enabled
    controlloop-trans      3.0.1           enabled
    controlloop-usecases   3.0.1           enabled


It contains 3 sections:

- *PDP-D* running status
- *features* applied

The *start* and *stop* commands are useful for developers testing functionality on a docker
container instance.

Telemetry Shell
===============

*PDP-D* offers an ample set of REST APIs to debug, introspect, and change state on a running PDP-D.
This is known as the *telemetry* API. The *telemetry* shell wraps these APIs for shell-like access
using `http-prompt <http://http-prompt.com/>`_.

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

Both the PDP-D *onap/policy-drools* and *onap/policy-pdpd-cl* images can be used without other
components.

There are 2 types of configuration data provided to the container:

1. environment variables.
2. configuration files and shell scripts.

Environment variables
~~~~~~~~~~~~~~~~~~~~~

As it was shown in the *controller* and *endpoint* sections, PDP-D configuration can rely on
environment variables. In a container environment, these variables are set up by the user in the
host environment.

Configuration Files and Shell Scripts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PDP-D is very flexible in its configuration.

The following file types are recognized when mounted under */tmp/policy-install/config*.

These are the configuration items that can reside externally and override the default configuration:

- **settings.xml** if working with external nexus repositories.
- **standalone-settings.xml** if an external *policy* nexus repository is not available.
- ***.conf** files containing environment variables.   This is an alternative to use environment
  variables, as these files will be sourced in before the PDP-D starts.
- **features*.zip** to load any arbitrary feature not present in the image.
- ***.pre.sh** scripts that will be executed before the PDP-D starts.
- ***.post.sh** scripts that will be executed after the PDP-D starts.
- **policy-keystore** to override the default PDP-D java keystore.
- **policy-truststore** to override the default PDP-D java truststore.
- ***.properties** to override or add any properties file for the PDP-D, this includes *controller*,
  *endpoint*, *engine* or *system* configurations.
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

    # PDP-D configuration channel

    PDPD_CONFIGURATION_TOPIC=PDPD-CONFIGURATION
    PDPD_CONFIGURATION_API_KEY=
    PDPD_CONFIGURATION_API_SECRET=
    PDPD_CONFIGURATION_CONSUMER_GROUP=
    PDPD_CONFIGURATION_CONSUMER_INSTANCE=
    PDPD_CONFIGURATION_PARTITION_KEY=

    # PAP-PDP configuration channel

    POLICY_PDP_PAP_TOPIC=policy-pdp-pap
    POLICY_PDP_PAP_API_KEY=
    POLICY_PDP_PAP_API_SECRET=


Note that *SQL_HOST*, and *REPOSITORY* are empty, so the PDP-D does not attempt to integrate with
those components.

Configuration
~~~~~~~~~~~~~

Bring up the PDP-D
~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    docker run --rm -p 9696:9696 -v ${PWD}/config:/tmp/policy-install/config --env-file ${PWD}/env/env.conf -it --name PDPD -h pdpd nexus3.onap.org:10001/onap/policy-drools:3.0.1

To run the container in detached mode, add the *-d* flag.

Note that in this command, we are opening the *9696* telemetry API port to the outside world, the
config directory (where the *noop.pre.sh* customization script resides) is mounted as
/tmp/policy-install/config, and the customization environment variables (*env/env.conf*) are passed
into the container.

To open a shell into the PDP-D:

.. code-block:: bash

    docker exec -it pdp-d bash

Once in the container, run tools such as *telemetry*, *policy* to look at the system state:

To run the *telemetry shell* and other tools from the host:

.. code-block:: bash

    docker exec -it PDPD bash -c "/opt/app/policy/bin/telemetry"
    docker exec -it PDPD bash -c "/opt/app/policy/bin/policy status"

Controlled instantiation of the PDP-D
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sometimes a developer may want to start and stop the PDP-D manually:

.. code-block:: bash

   # start a bash

   docker run --rm -p 9696:9696 -v ${PWD}/config:/tmp/policy-install/config --env-file ${PWD}/env/env.conf -it --name PDPD -h pdpd nexus3.onap.org:10001/onap/policy-drools:3.0.1 bash

   # use this command to start policy applying host customizations from /tmp/policy-install/config

   pdpd-entrypoint.sh vmboot

   # or use this command to start policy without host customization

   policy start

   # at any time use the following command to stop the PDP-D

   policy stop

   # and this command to start the PDP-D back again

   policy start

Running PDP-D with docker compose
=================================

*docker-compose* can be used to test the PDP-D with other components.
Refer to the docker usage documentation at
`policy-docker <https://github.com/onap/policy-docker/tree/master/compose>`_

Other examples
~~~~~~~~~~~~~~

The reader can also look at the `policy/docker repository <https://github.com/onap/policy-docker/tree/master/csit>`_.
More specifically, these directories have examples of other PDP-D configurations:

* `plans <https://github.com/onap/policy-docker/tree/master/compose>`_: startup & teardown scripts.
* `scripts <https://github.com/onap/policy-docker/blob/master/compose/compose.yaml>`_: docker-compose file.
* `tests <https://github.com/onap/policy-docker/blob/master/csit/resources/tests/drools-pdp-test.robot>`_: test plan.

Configuring the PDP-D in an OOM Kubernetes installation
=======================================================

The `PDP-D OOM chart <https://github.com/onap/oom/tree/master/kubernetes/policy/components/policy-drools-pdp>`_
can be customized at the following locations:

* `values.yaml <https://github.com/onap/oom/blob/master/kubernetes/policy/components/policy-drools-pdp/values.yaml>`_: custom values for your installation.
* `configmaps <https://github.com/onap/oom/tree/master/kubernetes/policy/components/policy-drools-pdp/resources/configmaps>`_: place in this directory any configuration extensions or overrides to customize the PDP-D that does not contain sensitive information.
* `secrets <https://github.com/onap/oom/tree/master/kubernetes/policy/components/policy-drools-pdp/resources/secrets>`_: place in this directory any configuration extensions or overrides to customize the PDP-D that does contain sensitive information.

The same customization techniques described in the docker sections for PDP-D, fully apply here, by
placing the corresponding files or scripts in these two directories.

End of Document
