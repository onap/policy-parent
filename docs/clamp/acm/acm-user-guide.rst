.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (c) Nordix Foundation.  All rights reserved.

.. _acm-user-guide-label:

ACM user guide
##############

.. contents::
    :depth: 4

This guide helps the user to define their own composition definitions and explains the procedure to execute them via the
Clamp Automation Composition Management Framework. This guide briefly talks about the commissioning, instantiation and
deployment steps once the composition definitions are created.

Defining a composition
======================

A composition can be created in yaml/json format as per the TOSCA standard. Please refer to the below section to understand
the Tosca fundamental concepts and how an Automation Composition definition can be realised in the TOSCA.


.. toctree::
   :maxdepth: 2

   defining-acms

HowTo: My First Automation Composition
======================================

An example scenario is considered where we have a microservice that can be installed with a helm chart in kubernetes and
configured via REST api to perform some operation.This functionality can be realised as a composition in Tosca standard.
The various sections of the composition definition includes:

Data Types:
-----------
The user can define their own data types to be used in the composition definition. In this use case, we are defining three data types as follows.

onap.datatypes.ToscaConceptIdentifier:
  This is a composite data type that holds two key value pairs in it. This type is used as an identifier for automation
  element types and participant types.This holds two string properties "name" and "version" and hence this data type can
  be used for creating the other composition element ids.

onap.datatypes.clamp.acm.httpAutomationCompositionElement.RestRequest:
  The rest api request for configuring the microservice can use the RestRequest datatype for defining the request in TOSCA.
  This holds the string properties "httpMethod", "path", "body" and an integer property "expectedResponse" for defining
  the rest request.

  Note that the "restRequestId" property which is of type "onap.datatypes.ToscaConceptIdentifier" that was defined in the
  previous step.

onap.datatypes.clamp.acm.httpAutomationCompositionElement.ConfigurationEntity:
  This data type holds a list of rest requests in case a microservice requires more than one rest request for configuration.
  This holds the "configurationEntityId" which is of type "onap.datatypes.ToscaConceptIdentifier" and "restSequence" property
  to hold the list of "onap.datatypes.clamp.acm.httpAutomationCompositionElement.RestRequest"


.. literalinclude:: files/acm-datatypes.yaml
   :language: yaml


Node Types:
-----------
A Node Type is a reusable entity that defines the type of one or more Node Templates.
An Interface Type is a reusable entity that describes a set of operations that can be used to interact with or manage a
node or relationship in a TOSCA topology. The actual acm elements will be created under the Node templates deriving from
these node types. We are going to define the following element types for ACM:

org.onap.policy.clamp.acm.Participant:
  This is a participant element type to define various participants in ACM. It holds the string property "provider".

org.onap.policy.clamp.acm.AutomationCompositionElement:
  This node type defines the primitive Automation composition element type that includes various common properties for all
  the ACM elements.
  Here we are defining various timeout properties and startPhase parameter that are common for all the AC elements.

  Note: This node type value should not be changed as the ACM framework identifies the AC elements based on this type.

org.onap.policy.clamp.acm.K8SMicroserviceAutomationCompositionElement:
  This node type is used to define AC elements that are associated with kubernetes operations. It is further derived from the
  "org.onap.policy.clamp.acm.AutomationCompositionElement" type and hence supports its common properties and also includes
  additional properties related to helm charts.
  We are going to create kubernetes AC elements of this type, under the Node templates.

org.onap.policy.clamp.acm.HttpAutomationCompositionElement:
  Node type for AC elements associated with REST operations. It is derived from the "org.onap.policy.clamp.acm.AutomationCompositionElement"
  type and hence supports its common properties and also supports additional properties for REST operation.
  We are going to create a REST AC element of this type, under the Node templates.

org.onap.policy.clamp.acm.AutomationComposition:
  Primitive node type for defining Automation composition definitions that comprises one or more AC elements in it.
  The AC definition of this type will be created under the Node templates.

  Note: This node type value should not be changed as the ACM framework identifies the AC definitions based on this type.

.. literalinclude:: files/acm-nodetypes.yaml
   :language: yaml

Node Templates:
---------------
A Node Template specifies the occurrence of a manageable software component as part of an application's topology model
which is defined in a TOSCA Service Template. We create the actual participants and AC elements involved in this use case
under the node templates.
There are no element properties supplied at this point since it will be provided by the user during the instantiation.

org.onap.k8s.acm.K8SAutomationCompositionParticipant:
  A kubernetes participant element that processes the kubernetes AC elements in the composition.
  This element is of node type "org.onap.policy.clamp.acm.Participant"

onap.policy.clamp.ac.element.K8S_AutomationCompositionElement:
  An AC element for kubernetes helm chart installation of the microservice derived from the node type
  "org.onap.policy.clamp.acm.K8SMicroserviceAutomationCompositionElement".
  The common element properties are provided with values as part of commissioning the definition.

org.onap.policy.clamp.acm.HttpParticipant:
  A http participant element that processes the REST AC elements in the composition.
  This element is of type "org.onap.policy.clamp.acm.Participant"

onap.policy.clamp.ac.element.Http_AutomationCompositionElement:
 An AC element for REST operation in the microservice derived from the node type
 "org.onap.policy.clamp.acm.HttpAutomationCompositionElement".
 The common element properties startPhase and timeout are provided with values as part of commissioning the definition.

onap.policy.clamp.ac.element.AutomationCompositionDefinition:
 The actual Automation Composition definition that comprises the list of AC elements mapped to it.
 This element is of node type "org.onap.policy.clamp.acm.AutomationComposition"

.. literalinclude:: files/acm-nodetemplates.yaml
   :language: yaml

Completed tosca template :download:`click here <files/acm-tosca.yaml>`

Once the Tosca template definition is created, the ACM workflow can be executed to create and deploy the compositions.
Please refer the following section for running ACM workflow.

ACM workflow
============

ACM framework exposes REST interfaces for creating and deploying the user defined compositions. In this section, the
TOSCA template created in the previous step can be commissioned, and then AC instances can be created and deployed for
the same.

This section assumes that the user has read about the ACM APIs and Protocols documentation and understands the ACM
operations on a high level before proceeding with the workflow.


Prerequisites:
  - ACM components including acm-runtime, required participants (http and kubernetes in this case) and Dmaap/kafka clients are deployed in docker or kubernetes environment.
  - Kubernetes and Helm are installed.
  - Chartmuseum server is installed to host the acelement microservice helm chart. (`Procedure to install chartmuseum <https://wiki.onap.org/display/DW/Microk8s+and+helm+setup+in+Ubuntu>`_.)
  - The helm chart for ACM test microservice is available in the policy/clamp repository that can be cloned locally and uploaded to the chartmuseum using helm push.(`AC element helm chart <https://github.com/onap/policy-clamp/tree/master/examples/src/main/resources/clamp/acm/acelement-helm>`_.)

Please refer the `ACM swagger document <https://raw.githubusercontent.com/onap/policy-clamp/master/runtime-acm/src/main/resources/openapi/openapi.yaml>`_. for REST API information for all the ACM operations.
This section guides through the various steps involved in executing the ACM workflow for deploying the test microservice element.

Commissioning the AC definition
-------------------------------
Commissioning refers to storing the composition definition on the ACM database. The created tosca template is posted as a request payload.

.. code-block:: bash

  Invoke a POST request 'http://policy_runtime_ip:port/onap/policy/clamp/acm/v2/compositions'

This returns a 202 response on the successful creation of the composition definition.

Note:
  The rest response returns the compositionId on a successful creation that requires to be used in the subsequent requests.

Prime AC definitions
--------------------
Priming associates the AC elements with suitable participants and sends the corresponding AC element information to the participants.

.. code-block:: bash

  Invoke a PUT request 'http://policy_runtime_ip:port/onap/policy/clamp/acm/v2/compositions/${compositionId}'

Request payload

.. literalinclude:: files/AC-priming.json
   :language: json

This returns a 202 response on a successful priming.

Instantiate AutomationComposition
---------------------------------
Instantiation refers to creating an AC instance on the database by initialising the element properties for each element in the composition.
These values requires to be provided by the user as per their use case requirement. In this case, we are passing the helm chart information
of the test microservice for the Ac element "onap.policy.clamp.ac.element.K8S_AutomationCompositionElement" which will be processed and installed
by the kubernetes participant on a deployment request.

Similarly the REST request data that are to be executed on the microservice will be passed on for the http AC element "onap.policy.clamp.ac.element.Http_AutomationCompositionElement"
which will be executed by the http participant. Please refer to the properties of the elements in the json payload.

Note:
  In this scenario, the kubernetes element requires to be invoked first to install the helm chart and then the http element needs to be invoked to configure the microservice.
  This is achieved by using the "startPhase" property on the AC element properties. The elements with the startPhase value defined are executed on a sequence starting from the least value to the higher value.
  Each element in the request payload is assigned with a uniques UUID which will be automatically generated by the GUI in the upcoming releases.

.. code-block:: bash

  Invoke a POST request
  'http://policy_runtime_ip:port/onap/policy/clamp/acm/v2/compositions/${compositionId}/instances'

The compositionId retrieved from the previous step should be updated in the request body. This returns a 201 response on a successful instantiation.
This also returns the instanceId in the response that can be used in the subsequent requests.

Request payload

.. literalinclude:: files/AC-instantiation.json
   :language: json

Deploy AC instance
------------------
Once the AC instance is created, the user can deploy the instance which in turn activates the corresponding participants to execute the intended operations.
In this case, the kubernetes participant will be installing the test microservice helm chart on the kubernetes cluster and the http participant will be
executing the REST requests on the microservice endpoints.

.. code-block:: bash

  Invoke a PUT request
  'http://policy_runtime_ip:port/onap/policy/clamp/acm/v2/compositions/${compositionId}/instances/${instanceId}'

This returns a 202 response on a successful deploy order request. The elements will be in "DEPLOYING" state until the completion and then the state of
the elements are updated to "DEPLOYED"
The current status of the deployment can be fetched through the following endpoint.

.. code-block:: bash

  Invoke a GET request
  'http://policy_runtime_ip:port/onap/policy/clamp/acm/v2/compositions/${compositionId}/instances/${instanceId}'

Request payload

.. literalinclude:: files/AC-deploy.json
   :language: json

Note:
  The user can further implement the admin states 'LOCK' and 'UNLOCK' on the participants to further cascade the deployment operations.
  If these states are implemented, then a subsequent request to LOCK and UNLOCK requires to be triggered following the deployment.

Once all the AC elements are deployed, there should be a test microservice pod running on the kubernetes cluster which is
configured to send events on the kafka by the http participant. This can be verified on the test microservice application logs.
The AC instances can also be undeployed and deleted by the user.

UnDeploy AutomationComposition
------------------------------
The AC instances can be undeployed from the system by the participants.

.. code-block:: bash

  Invoke a PUT request
  'http://policy_runtime_ip:port/onap/policy/clamp/acm/v2/compositions/${compositionId}/instances/${instanceId}'

This returns a 202 response on successful deploy order request.

Request payload

.. literalinclude:: files/AC-undeploy.json
   :language: json

Uninstantiate AC instance
-------------------------
This deletes the AC instance from the database including all the element properties that are initialised.

.. code-block:: bash

  Invoke a DELETE request
  'http://policy_runtime_ip:port/onap/policy/clamp/acm/v2/compositions/${compositionId}/instances/${instanceId}'

This returns 200 on successful deletion of the instance.

Deprime Ac defintions
---------------------
Once the AC instance is deleted, it can be deprimed from the participants to be safely deleted from the database.

.. code-block:: bash

  Invoke a PUT request 'http://policy_runtime_ip:port/onap/policy/clamp/acm/v2/compositions/${compositionId}'

This returns a 202 response on a successful operation.

Request payload

.. literalinclude:: files/AC-depriming.json
   :language: json

Delete AC defintion
-------------------
The AC definitions can be deleted if there are no instances are running and it is not primed to the participants.

.. code-block:: bash

  Invoke a DELETE request 'http://policy_runtime_ip:port/onap/policy/clamp/acm/v2/compositions/${compositionId}'

This return a 200 response on a successful deletion operation.