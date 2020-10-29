.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _xacmltutorial-enforcement-label:

Policy XACML - Policy Enforcement Tutorial
##########################################

.. toctree::
   :maxdepth: 3

This tutorial shows how to build Policy Enforcement into your application. Please be sure to clone the
policy repositories before going through the tutorial. See :ref:`policy-development-tools-label` for details.

This tutorial can be found in the XACML PDP repository. `See the tutorial <https://github.com/onap/policy-xacml-pdp/tree/master/tutorials/tutorial-enforcement>`_

Policy Type being Enforced
**************************

For this tutorial, we will be enforcing an Policy Type that inherits from the **onap.policies.Monitoring** Policy Type. This Policy Type is
used by DCAE analytics for configuration purposes. Any inherited Policy Type is automatically supported by the XACML PDP for Decisions.

`See the latest example Policy Type <https://github.com/onap/policy-xacml-pdp/blob/master/tutorials/tutorial-enforcement/src/test/resources/MyAnalytic.yaml>`_

.. code-block:: java
  :caption: Example Policy Type

    tosca_definitions_version: tosca_simple_yaml_1_1_0
    policy_types:
       onap.policies.Monitoring:
          derived_from: tosca.policies.Root
          version: 1.0.0
          name: onap.policies.Monitoring
          description: a base policy type for all policies that govern monitoring provisioning
       onap.policies.monitoring.MyAnalytic:
          derived_from: onap.policies.Monitoring
          type_version: 1.0.0
          version: 1.0.0
          description: Example analytic
          properties:
             myProperty:
                type: string
                required: true

Example Policy
**************

`See the latest example policy <https://github.com/onap/policy-xacml-pdp/blob/master/tutorials/tutorial-enforcement/src/test/resources/MyPolicies.yaml>`_

.. code-block:: java
  :caption: Example Policy

    tosca_definitions_version: tosca_simple_yaml_1_1_0
    topology_template:
       policies:
         -
           policy1:
               type: onap.policies.monitoring.MyAnalytic
               type_version: 1.0.0
               version: 1.0.0
               name: policy1
               metadata:
                 policy-id: policy1
                 policy-version: 1.0.0
               properties:
                 myProperty: value1

Example Decision Requests and Responses
***************************************

For **onap.policies.Montoring** Policy Types, the action used will be **configure**. For **configure** actions, you can specify a resource by **policy-id** or **policy-type**. We recommend using **policy-type**, as a policy-id may not necessarily be deployed. In addition, your application should request all the available policies for your policy-type that your application should be enforcing.

.. code-block:: json
  :caption: Example Decision Request

    {
      "ONAPName": "myName",
      "ONAPComponent": "myComponent",
      "ONAPInstance": "myInstanceId",
      "requestId": "1",
      "action": "configure",
      "resource": {
          "policy-type": "onap.policies.monitoring.MyAnalytic"
      }
    }

The **configure** action will return a payload containing your full policy:

.. code-block: json
  :caption: Example Decision Response
    {
        "policies": {
            "policy1": {
                "type": "onap.policies.monitoring.MyAnalytic",
                "type_version": "1.0.0",
                "properties": {
                    "myProperty": "value1"
                },
                "name": "policy1",
                "version": "1.0.0",
                "metadata": {
                    "policy-id": "policy1",
                    "policy-version": "1.0.0"
                }
            }
        }
    }

Making Decision Call in your Application
****************************************

Your application should be able to do a RESTful API call to the XACML PDP Decision API endpoint. If you have code that does this already, then utilize that to do something similar to the following curl command:

.. code-block: bash
  :caption: Example Decision API REST Call using curl

    curl -k -u https://xacml-pdp:6969/policy/pdpx/v1/decision

If your application does not have REST http client code, you can use some common code available in the policy/common repository for doing HTTP calls.

.. code-block: java
  :caption: Policy Common REST Code Dependency

        <dependency>
            <groupId>org.onap.policy.common</groupId>
            <artifactId>policy-endpoints</artifactId>
            <version>${policy.common.version}</version>
        </dependency>

Also, if your application wants to use common code to serialize/deserialize Decision Requests and Responses, then you can include the following dependency:

.. code-block: java
  :caption: Policy Decision Request and Response Classes

        <dependency>
            <groupId>org.onap.policy.models</groupId>
            <artifactId>policy-models-decisions</artifactId>
            <version>${policy.models.version}</version>
        </dependency>

Responding to Policy Update Notifications
*****************************************

Your application should also be able to respond to Policy Update Notifications that are published on the Dmaap topic POLICY-NOTIFICATION. This is because if a user pushes an updated Policy, your application should be able to dynamically start enforcing that policy without restart.

.. code-block: bash
  :caption: Example Dmaap REST Call using curl

  curl -k -u https://dmaap:3904/events/POLICY-NOTIFICATION/group/id?timeout=5000

If you application does not have Dmaap client code, you can use some available code in policy/common to receive Dmaap events.

To parse the JSON send over the topic, your application can use the following dependency:

.. code-block: java
  :caption: Policy PAP Update Notification Classes

        <dependency>
            <groupId>org.onap.policy.models</groupId>
            <artifactId>policy-models-pap</artifactId>
            <version>${policy.models.version}</version>
        </dependency>
