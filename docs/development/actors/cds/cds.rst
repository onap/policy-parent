.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

CDS actor support in Policy
###########################

.. contents::
    :depth: 4

1. Overview of CDS Actor support in Policy
==========================================
ONAP Policy Framework now enables Controller Design Studio (CDS) as one of the supported actors.
This allows the users to configure Operational Policy to use CDS as an actor to remedy a situation.

Behind the scene, when an incoming event is received and validated against rules, Policy uses gRPC to trigger
the CBA (Controller Blueprint Archive: CDS artifact) as configured in the operational policy and providing CDS
with all the input parameters that is required to execute the chosen CBA.

2. Objective
============
The goal of the user guide is to clarify the contract between Policy and CDS so that a CBA developer can respect
this input contract towards CDS when implementing the CBA.

3. Contract between Policy and CDS
==================================
Policy upon receiving an incoming event from DCAE fires the rules and decides which actor to trigger.
If the CDS actor is the chosen, Policy triggers the CBA execution using gRPC.

The parameters required for the execution of a CBA are internally handled by Policy.
It makes uses of the incoming event, the operational policy configured and AAI lookup to build the CDS request payload.

3.1 CDS Blueprint Execution Payload format as invoked by Policy
---------------------------------------------------------------
Below are the details of the contract established between Policy and CDS to enable the automation of a remediation
action within the scope of a closed loop usecase in ONAP.

The format of the input payload for CDS follows the below guidelines, hence a CBA developer must consider this when
implementing the CBA logic.
For the sake of simplicity a JSON payload is used instead of a gRPC payload and each attribute of the child-nodes
is documented.

3.1.1 CommonHeader
******************

The "commonHeader" field in the CBA execute payload is built by policy.

=============================== =========== ================================================================
   "commonHeader" field name       type                             Description
=============================== =========== ================================================================
subRequestId                      string      Generated by Policy. Is a UUID and used internally by policy.
requestId                         string      Inserted by Policy. Maps to the UUID sent by DCAE i.e. the ID
                                              used throughout the closed loop lifecycle to identify a request.
originatorId                      string      Generated by Policy and fixed to "POLICY"
=============================== =========== ================================================================

3.1.2 ActionIdentifiers
***********************

The "actionIdentifiers" field uniquely identifies the CBA and the workflow to execute.

==================================== =========== =============================================================
   "actionIdentifiers" field name       type                         Description
==================================== =========== =============================================================
mode                                   string      Inserted by Policy and fixed to "sync" presently.
blueprintName                          string      Inserted by Policy. Maps to the attribute that holds the
                                                   blueprint-name in the operational policy configuration.
blueprintVersion                       string      Inserted by Policy. Maps to the attribute that holds the
                                                   blueprint-version in the operational policy configuration.
actionName                             string      Inserted by Policy. Maps to the attribute that holds the
                                                   action-name in the operational policy configuration.
==================================== =========== =============================================================

3.1.3 Payload
*************

The "payload" JSON node is generated by Policy for the action-name specified in the "actionIdentifiers" field
which is eventually supplied through the operational policy configuration as indicated above.

3.1.3.1 Action request object
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The "$actionName-request" object is generated by CDS for the action-name specified in the "actionIdentifiers" field.

The "$actionName-request" object contains:

* a field called "resolution-key" which CDS uses to store the resolved parameters into the CDS context
* a child node object called "$actionName-properties" which holds a map of all the parameters that serve
  as inputs to the CBA. It presently holds the below information:

  * all the AAI enriched attributes
  * additional parameters embedded in the Control Loop Event format which is sent by DCAE (analytics application).
  * any static information supplied through operational policy configuration which is not specific to an event
    but applies across all the events.

The data description for the action request object fields is as below:

- Resolution-key

===================================== =========== ======================================================================
   "$actionName-request" field name      type                                Description
===================================== =========== ======================================================================
resolution-key                          string      Generated by Policy. Is a UUID, generated each time CBA execute
                                                    request is invoked.
===================================== =========== ======================================================================

- Action properties object

======================================== =============== ===============================================================
   "$actionName-properties" field name        type                               Description
======================================== =============== ===============================================================
[$aai_node_type.$aai_attribute]              map             Inserted by Policy after performing AAI enrichment.
                                                             Is a map that contains AAI parameters for the target and
                                                             conforms to the notation: $aai_node_type.$aai_attribute.
                                                             E.g. for PNF the map looks like below.

                                                                       .. code-block:: json

                                                                         {
                                                                           "pnf.equip-vendor":"Vendor-A",
                                                                           "pnf.ipaddress-v4-oam":"10.10.10.10",
                                                                           "pnf.in-maint":false,
                                                                           "pnf.pnf-ipv4-address":"3.3.3.3",
                                                                           "pnf.resource-version":"1570746989505",
                                                                           "pnf.nf-role":"ToR DC101",
                                                                           "pnf.equip-type":"Router",
                                                                           "pnf.equip-model":"model-123456",
                                                                           "pnf.frame-id":"3",
                                                                           "pnf.pnf-name":"demo-pnf"
                                                                         }
data                                        json object       Inserted by Policy. Maps to the static payload supplied
                                            OR string         through operational policy configuration. Used to hold
                                                              any static information which applies across all the
                                                              events as described above. If the value of the data
                                                              field is a valid JSON string it is converted to a JSON
                                                              object, else will be retained as a string.
[$additionalEventParams]                     map              Inserted by Policy. Maps to the map of
                                                              additionalEvent parameters embedded into the
                                                              Control Loop Event message from DCAE.
======================================== =============== ===============================================================



3.1.4 Summing it up: CBA execute payload generation as done by Policy
*********************************************************************

Putting all the above information together below is the REST equivalent of the CDS blueprint execute gRPC request
generated by Policy.

REST equivalent of the gRPC request from Policy to CDS to execute a CBA.

.. code-block:: bash

    curl -X POST \
      'http://{{ip}}:{{port}}/api/v1/execution-service/process' \
      -H 'Authorization: Basic Y2NzZGthcHBzOmNjc2RrYXBwcw==' \
      -H 'Content-Type: application/json' \
      -H 'cache-control: no-cache' \
      -d '{
        "commonHeader":{
            "subRequestId":"{generated_by_policy}",
            "requestId":"{req_id_from_DCAE}",
            "originatorId":"POLICY"
        },
        "actionIdentifiers":{
            "mode":"sync",
            "blueprintName":"{blueprint_name_from_operational_policy_config}",
            "blueprintVersion":"{blueprint_version_from_operational_policy_config}",
            "actionName":"{blueprint_action_name_from_operational_policy_config}"
        },
        "payload":{
            "$actionName-request":{
                "resolution-key":"{generated_by_policy}",
                "$actionName-properties":{
                    "$aai_node_type.$aai_attribute_1":"",
                    "$aai_node_type.$aai_attribute_2":"",
                    .........
                    "data":"{static_payload_data_from_operational_policy_config}",
                    "$additionalEventParam_1":"",
                    "$additionalEventParam_2":"",
                    .........
                }
            }
        }
    }'

3.1.5 Examples
**************

Sample CBA execute request generated by Policy for PNF target type when "data" field is a string:

.. code-block:: bash

    curl -X POST \
      'http://{{ip}}:{{port}}/api/v1/execution-service/process' \
      -H 'Authorization: Basic Y2NzZGthcHBzOmNjc2RrYXBwcw==' \
      -H 'Content-Type: application/json' \
      -H 'cache-control: no-cache' \
      -d '{
        "commonHeader":{
            "subRequestId":"14384b21-8224-4055-bb9b-0469397db801",
            "requestId":"d57709fb-bbec-491d-a2a6-8a25c8097ee8",
            "originatorId":"POLICY"
        },
        "actionIdentifiers":{
            "mode":"sync",
            "blueprintName":"PNF-demo",
            "blueprintVersion":"1.0.0",
            "actionName":"reconfigure-pnf"
        },
        "payload":{
            "reconfigure-pnf-request":{
                "resolution-key":"8338b828-51ad-4e7c-ac8b-08d6978892e2",
                "reconfigure-pnf-properties":{
                    "pnf.equip-vendor":"Vendor-A",
                    "pnf.ipaddress-v4-oam":"10.10.10.10",
                    "pnf.in-maint":false,
                    "pnf.pnf-ipv4-address":"3.3.3.3",
                    "pnf.resource-version":"1570746989505",
                    "pnf.nf-role":"ToR DC101",
                    "pnf.equip-type":"Router",
                    "pnf.equip-model":"model-123456",
                    "pnf.frame-id":"3",
                    "pnf.pnf-name":"demo-pnf",
                    "data": "peer-as=64577",
                    "peer-group":"demo-peer-group",
                    "neighbor-address":"4.4.4.4"
                }
            }
        }
    }'

Sample CBA execute request generated by Policy for VNF target type when "data" field is a valid JSON string:

.. code-block:: bash

    curl -X POST \
      'http://{{ip}}:{{port}}/api/v1/execution-service/process' \
      -H 'Authorization: Basic Y2NzZGthcHBzOmNjc2RrYXBwcw==' \
      -H 'Content-Type: application/json' \
      -H 'cache-control: no-cache' \
      -d '{
        "commonHeader":{
            "subRequestId":"14384b21-8224-4055-bb9b-0469397db801",
            "requestId":"d57709fb-bbec-491d-a2a6-8a25c8097ee8",
            "originatorId":"POLICY"
        },
        "actionIdentifiers":{
            "mode":"sync",
            "blueprintName":"vFW-CDS",
            "blueprintVersion":"1.0.0",
            "actionName":"config-deploy"
        },
        "payload":{
            "config-deploy-request":{
                "resolution-key":"6128eb53-0eac-4c79-855c-ff56a7b81141",
                "config-deploy-properties":{
                    "service-instance.service-instance-id":"40004db6-c51f-45b0-abab-ea4156bae422",
                    "generic-vnf.vnf-id":"8d09e3bd-ae1d-4765-b26e-4a45f568a092",
                    "data":{
                        "active-streams":"7"
                    }
                }
            }
        }
    }'

4. Operational Policy configuration to use CDS as an actor
==========================================================

TODO: Update the documentation once Operational Policy is made TOSCA compliant as per:
https://wiki.onap.org/display/DW/TOSCA+Compliant+Policy+Types

Until then below is how to configure the Operational Policy to use CDS as an actor using the Policy API.

For integration testing use CLAMP UI to configure the Operational Policy

4.1 Background
--------------
For detailed description of the Operational Policy YAML specification refer to:

* https://gerrit.onap.org/r/gitweb?p=policy/drools-applications.git;a=blob;f=controlloop/common/policy-yaml/README-v2.0.0.md;h=eadaf658a52eac0d0cf6603025ef8b4c760f553b;hb=refs/heads/master
* https://wiki.onap.org/display/DW/Control+Loop+Operational+Policy

4.2 Control Loop Operational Policy YAML to use the CDS actor
-------------------------------------------------------------

Below is a template for configuring the Operational Policy to use CDS as an actor.

.. code-block:: bash

    controlLoop:
      version: 2.0.0
      controlLoopName: {{Unique ID for the Control Loop, must match one of the IDs defined in the list of policies below}}
      trigger_policy: {{ID of operation policy defined below to specify which policy to trigger first}}
      timeout: {{Overall timeout for the Control loop Operational policy}}
      abatement: false
    policies:
      - id: {{ID of the Operation policy}}
        name: {{Name of the Operation policy}}
        description: {{Description of the Operation policy}}
        actor: {{Identifies the actor of choice for remediation, in this case: CDS}}
        recipe: {{Identifies the CDS action-name}}
        target:
          resourceID: {{SDC resource ID: E.g. modelInvariant ID of the vFW generic VNF; empty for PNF}}
          type: {{Identifies the type of target, possible values: VNF, PNF}}
        payload:
          artifact_name: {{Name of the blueprint to execute if CDS is the actor}}
          artifact_version: {{Version of the blueprint to execute if CDS is the actor}}
          mode: async
          data: {{Additional static data required by the blueprint if CDS is the actor}}
        retry: 0
        timeout: {{Timeout in seconds for the actor to perform the operation}}
        success: final_success
        failure: final_failure
        failure_timeout: final_failure_timeout
        failure_retries: final_failure_retries
        failure_exception: final_failure_exception
        failure_guard: final_failure_guard

E.g. Sample Operational Policy YAML for vFW usecase:

.. code-block:: bash

    controlLoop:
      version: 2.0.0
      controlLoopName: ControlLoop-vFirewall-7e4fbe9c-d612-4ec5-bbf8-605aeabdb677
      trigger_policy: unique-policy-id-1-modifyConfig
      timeout: 60
      abatement: false
    policies:
      - id: unique-policy-id-1-modifyConfig
        name: modifyconfig-cds-actor
        description:
        actor: CDS
        recipe: modify-config
        target:
          resourceID: 7e4fbe9c-d612-4ec5-bbf8-605aeabdb677
          type: VNF
        payload:
          artifact_name: vFW-CDS
          artifact_version: 1.0.0
          data: '{"active-streams":"7"}'
        retry: 0
        timeout: 30
        success: final_success
        failure: final_failure
        failure_timeout: final_failure_timeout
        failure_retries: final_failure_retries
        failure_exception: final_failure_exception
        failure_guard: final_failure_guard

4.3 API to configure the Control Loop Operational policy
--------------------------------------------------------

Once the YAML is built, we need to encode it in order to embed it into the payload to configure the operational policy.
Assuming the YAML is saved into a file by name "policy.yaml", use the below script to encode the spaces and tabs:

.. code-block:: bash

    #!/usr/env/bin python3
    import urllib
    with open('policy.yaml') as f:
      v = f.read()
    v = urllib.quote_plus(v)
    print(v)

The encoded YAML data from the above step needs to be substituted into the following payload template to create
the operational policy.

Note: In the below rest endpoint, the hostname points to K8S service "policy-api" and internal port 6969.

.. code-block:: bash

    curl -X POST \
      https://{$POLICY_API_URL}:{$POLICY_API_SERVICE_PORT}/policy/api/v1/policytypes/onap.policies.controlloop.Operational/versions/1.0.0/policies \
      -H 'Authorization: Basic aGVhbHRoY2hlY2s6emIhWHp0RzM0' \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json' \
      -d '{
      "policy-id" : "operational.modifyconfig",
      "content" : "$encoded_yaml_data"
    }'

The response to this rest endpoint returns something like below:

.. code-block:: bash

    {
        "policy-id": "operational.modifyconfig",
        "policy-version": "1",
        "content": "$data"
    }

To run the below request, for policy-version use the response above into the format "${policy-version_from_last_call}.0.0")
Note: In the rest endpoint URI, the hostname points to the service "policy-pap" and internal port 6969.

.. code-block:: bash

    curl -X POST \
      https://{$POLICY_PAP_URL}:{$POLICY_PAP_SERVICE_PORT}/policy/pap/v1/pdps/policies \
      -H 'Authorization: Basic aGVhbHRoY2hlY2s6emIhWHp0RzM0' \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json' \
      -d '{
      "policies": [
        {
          "policy-id": "operational.modifyconfig",
          "policy-version": "1.0.0"
        }
      ]
    }'

To view the configured policies use the below REST API.

.. code-block:: bash

    curl -X GET \
      https://{$POLICY_API_URL}:{$POLICY_API_SERVICE_PORT}/policy/api/v1/policytypes/onap.policies.controlloop.Operational/versions/1.0.0/policies/operational.modifyconfig \
      -H 'Authorization: Basic aGVhbHRoY2hlY2s6emIhWHp0RzM0' \
      -H 'Content-Type: application/json' \
