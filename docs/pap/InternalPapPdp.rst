.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _pap-pdp-label:

The Internal Policy Framework PAP-PDP API
#########################################

.. contents::
    :depth: 3

This page describes the API between the PAP and PDPs. The APIs in this section are used for internal
communication in the Policy Framework, using Kafka as messaging system. The APIs are NOT supported for
use by components outside the Policy Framework and are subject to revision and change at any time.

There are three messages on the API:

1. PDP_STATUS: PDP→PAP, used by PDPs to report to the PAP

2. PDP_UPDATE: PAP→PDP, used by the PAP to update the policies running on PDPs, triggers a PDP_STATUS
   message with the result of the PDP_UPDATE operation

3. PDP_STATE_CHANGE: PAP→PDP, used by the PAP to change the state of PDPs, triggers a PDP_STATUS message
   with the result of the PDP_STATE_CHANGE operation


The fields in the table below are valid on API calls:

=============================== ======== ======== ======== =====================================================
**Field**                       **PDP    **PDP    **PDP    **Comment**
                                STATUS** UPDATE** STATE
                                                  CHANGE**
=============================== ======== ======== ======== =====================================================
(message_name)                  M        M        M        pdp_status, pdp_update, pdp_state_change, or
                                                           pdp_health_check
name                            M        M        M        The name of the PDP, for state changes and health
                                                           checks, the PDP group and subgroup can be used to
                                                           specify the scope of the operation
pdpType                         M        N/A      N/A      The type of the PDP, currently xacml, drools, or apex
state                           M        N/A      M        The administrative state of the PDP group: PASSIVE,
                                                           SAFE, TEST, ACTIVE, or TERMINATED
healthy                         M        N/A      N/A      The result of the latest health check on the PDP:
                                                           HEALTHY/NOT_HEALTHY/TEST_IN_PROGRESS
description                     O        O        N/A      The description of the PDP
pdpGroup                        M        M        C        The PDP group to which the PDP belongs, the PDP group
                                                           and subgroup can be used to specify the scope of the
                                                           operation
pdpSubgroup                     O        M        C        The PDP subgroup to which the PDP belongs, the PDP
                                                           group and subgroup can be used to specify the scope
                                                           of the operation
source                          N/A      M        M        The source of the message
policies                        M        N/A      N/A      The list of policies running on the PDP
policiesToBeDeployed            N/A      M        N/A      The list of policies to be deployed on the PDP
policiesToBeUndeployed          N/A      M        N/A      The list of policies to be undeployed from the PDP
->(name)                        O        M        N/A      The name of a TOSCA policy running on the PDP
->policy_type                   O        M        N/A      The TOSCA policy type of the policyWhen a PDP starts,
                                                           it commences periodic sending of *PDP_STATUS*
                                                           messages. The PAP receives these messages
                                                           and acts in whatever manner is appropriate.
->policy_type_version           O        M        N/A      The version of the TOSCA policy type of the policy
->properties                    O        M        N/A      The properties of the policy for the XACML, Drools,
                                                           or APEX PDP for details
                                                           Pod
properties                      O        N/A      N/A      Other properties specific to the PDP
statistics                      O        N/A      N/A      Statistics on policy execution in the PDP
->policyDeployCount             M        N/A      N/A      The number of policies deployed into the PDP
->policyDeploySuccessCount      M        N/A      N/A      The number of policies successfully deployed into
                                                           the PDP
->policyDeployFailCount         M        N/A      N/A      The number of policies deployed into the PDP where
                                                           the deployment failed
->policyUndeployCount           M        N/A      N/A      The number of policies undeployed from the PDP
->policyUndeploySuccessCount    M        N/A      N/A      The number of policies successfully undeployed from
                                                           the PDP
->policyUndeployFailCount       M        N/A      N/A      The number of policies undeployed from the PDP where
                                                           the undeployment failed
->policyExecutedCount           M        N/A      N/A      The number of policy executions on the PDP
->policyExecutedSuccessCount    M        N/A      N/A      The number of policy executions on the PDP that
                                                           completed successfully
->policyExecutedFailCount       M        N/A      N/A      The number of policy executions on the PDP that
                                                           failed
response                        O        N/A      N/A      The response to the last operation that the PAP
                                                           executed on the PDP
->responseTo                    M        N/A      N/A      The PAP to PDP message to which this is a response
->responseStatus                M        N/A      N/A      SUCCESS or FAIL
->responseMessage               O        N/A      N/A      Message giving further information on the successful
                                                           or failed operation
=============================== ======== ======== ======== =====================================================

YAML is used for illustrative purposes in the examples in this section. JSON (application/json) is used as the content
type in the implementation of this API.

1 PAP API for PDPs
==================
The purpose of this API is for PDPs to provide heartbeat, status, health, and statistical information to Policy
Administration. There is a single *PDP_STATUS* message on this API. PDPs send this message to the PAP using the
*POLICY_PDP_PAP* topic. The PAP listens on this topic for messages.

When a PDP starts, it commences periodic sending of *PDP_STATUS* messages. The PAP receives these messages and
acts in whatever manner is appropriate. *PDP_UPDATE* and *PDP_STATE_CHANGE* operations trigger a
*PDP_STATUS* message as a response.

The *PDP_STATUS* message is used for PDP heartbeat monitoring. A PDP sends a *PDP_STATUS* message with a state of
*TERMINATED* when it terminates normally. If a *PDP_STATUS* message is not received from a PDP periodically or in
response to a pdp_update or pdp-state_change message in a certain configurable time, then the PAP
assumes the PDP has failed.

A PDP may be preconfigured with its PDP group, PDP subgroup, and policies. If the PDP group, subgroup, or any policy
sent to the PAP in a *PDP_STATUS* message is unknown to the PAP, the PAP locks the PDP in state PASSIVE.

.. code-block:: yaml
  :caption: PDP_STATUS message from an XACML PDP running control loop policies
  :linenos:

  pdp_status:
    pdpType: xacml
    state: ACTIVE
    healthy: HEALTHY
    description: XACML PDP running control loop policies
    policies:
      - name: SDNC_Policy.ONAP_NF_NAMING_TIMESTAMP
        version: 1.0.0
      - name: onap.policies.controlloop.guard.frequencylimiter.EastRegion
        version: 1.0.0
      - name: onap.policies.controlloop.guard.blacklist.eastRegion
        version: 1.0.0
      - name: .policies.controlloop.guard.minmax.eastRegion
        version: 1.0.0
    messageName: PDP_STATUS
    requestId: 5551bd1b-4020-4fc5-95b7-b89c80a337b1
    timestampMs: 1633534472002
    name: xacml-23d33c2a-8715-43a8-ade5-5923fc0f185c
    pdpGroup: defaultGroup
    pdpSubgroup: xacml


.. code-block:: yaml
  :caption: PDP_STATUS message from a Drools PDP running control loop policies
  :linenos:

  pdp_status:
    pdpType: drools
    state: ACTIVE
    healthy: HEALTHY
    description: Drools PDP running control loop policies
    policies:
      - name: onap.controllloop.operational.drools.vcpe.EastRegion
        version: 1.0.0
      - name: onap.controllloop.operational.drools.vfw.EastRegion
        version: 1.0.0
    instance: drools_2
    deployment_instance_info:
      node_address: drools_2_pod
      # Other deployment instance info
    response:
      responseTo: 52117e25-f416-45c7-a955-83ed929d557f
      responseStatus: SUCCESSSS
    messageName: PDP_STATUS
    requestId: 52117e25-f416-45c7-a955-83ed929d557f
    timestampMs: 1633355052181
    name: drools-8819a672-57fd-4e74-ad89-aed1a64e1837
    pdpGroup: defaultGroup
    pdpSubgroup: drools

.. code-block:: yaml
  :caption: PDP_STATUS message from an APEX PDP running control loop policies
  :linenos:

    pdpType: apex
    state: ACTIVE
    healthy: HEALTHY
    description: Pdp status response message for PdpUpdate
    policies:
      - name: onap.controllloop.operational.apex.bbs.EastRegion
        version: 1.0.0
    response:
      responseTo: 679fad9b-abbf-4b9b-971c-96a8372ec8af
      responseStatus: SUCCESS
      responseMessage: >-
        Apex engine started. Deployed policies are:
        onap.policies.apex.sample.Salecheck:1.0.0
    messageName: PDP_STATUS
    requestId: 932c17b0-7ef9-44ec-be58-f17e104e7d5d
    timestampMs: 1633435952217
    name: apex-d0610cdc-381e-4aae-8e99-3f520c2a50db
    pdpGroup: defaultGroup
    pdpSubgroup: apex


.. code-block:: yaml
  :caption: PDP_STATUS message from an XACML PDP running monitoring policies
  :linenos:

  pdp_status:
    pdpType: xacml
    state: ACTIVE
    healthy: HEALTHY
    description: XACML PDP running control loop policies
    policies:
      - name: SDNC_Policy.ONAP_NF_NAMING_TIMESTAMP
        version: 1.0.0
      - name: onap.scaleout.tca:message
        version: 1.0.0
    messageName: PDP_STATUS
    requestId: 5551bd1b-4020-4fc5-95b7-b89c80a337b1
    timestampMs: 1633534472002
    name: xacml-23d33c2a-8715-43a8-ade5-5923fc0f185c
    pdpGroup: onap.pdpgroup.Monitoring
    pdpSubgroup: xacml


2 PDP API for PAPs
==================

The purpose of this API is for the PAP to load and update policies on PDPs and to change the state of PDPs.
The PAP sends *PDP_UPDATE* and *PDP_STATE_CHANGE* messages to PDPs using the *POLICY_PAP_PDP* topic.
PDPs listen on this topic for messages.

The PAP can set the scope of *PDP_STATE_CHANGE* message:

-  PDP Group: If a PDP group is specified in a message, then the PDPs in that PDP group respond to the message and all
   other PDPs ignore it.

-  PDP Group and subgroup: If a PDP group and subgroup are specified in a message, then only the PDPs of that subgroup
   in the PDP group respond to the message and all other PDPs ignore it.

-  Single PDP: If the name of a PDP is specified in a message, then only that PDP responds to the message and all other
   PDPs ignore it.


2.1 PDP Update
--------------

The *PDP_UPDATE* operation allows the PAP to modify the PDP with information such as policiesToBeDeployed/Undeployed,
the interval to send heartbeats, subgroup etc.

The following examples illustrate how the operation is used.

.. code-block:: yaml
  :caption: PDP_UPDATE message to upgrade XACML PDP control loop policies to version 1.0.1
  :linenos:

  pdp_update:
    source: pap-6e46095a-3e12-4838-912b-a8608fc93b51
    pdpHeartbeatIntervalMs: 120000
    policiesToBeDeployed:
      - type: onap.policies.Naming
        type_version: 1.0.0
        properties:
          # Omitted for brevity
        name: onap.policies.controlloop.guard.frequencylimiter.EastRegion
        version: 1.0.1
        metadata:
          policy-id: onap.policies.controlloop.guard.frequencylimiter.EastRegion
          policy-version: 1.0.1
    messageName: PDP_UPDATE
    requestId: cbfb9781-da6c-462f-9601-8cf8ca959d2b
    timestampMs: 1633466294898
    name: xacml-23d33c2a-8715-43a8-ade5-5923fc0f185c
    description: XACML PDP running control loop policies, Upgraded
    pdpGroup: defaultGroup
    pdpSubgroup: xacml


.. code-block:: yaml
  :caption: PDP_UPDATE message to a Drools PDP to add an extra control loop policy
  :linenos:

  pdp_update:
    source: pap-0674bd0c-0862-4b72-abc7-74246fd11a79
    pdpHeartbeatIntervalMs: 120000
    policiesToBeDeployed:
      - type: onap.controllloop.operational.drools.vFW
        type_version: 1.0.0
        properties:
          # Omitted for brevity
        name: onap.controllloop.operational.drools.vfw.WestRegion
        version: 1.0.0
        metadata:
          policy-id: onap.controllloop.operational.drools.vfw.WestRegion
          policy-version: 1.0.0
    messageName: PDP_UPDATE
    requestId: e91c4515-86db-4663-b68e-e5179d0b000e
    timestampMs: 1633355039004
    name: drools-8819a672-57fd-4e74-ad89-aed1a64e1837
    description: Drools PDP running control loop policies, extra policy added
    pdpGroup: defaultGroup
    pdpSubgroup: drools


.. code-block:: yaml
  :caption: PDP_UPDATE message to an APEX PDP to remove a control loop policy
  :linenos:

  pdp_update:
    source: pap-56c8531d-5376-4e53-a820-6973c62bfb9a
    pdpHeartbeatIntervalMs: 120000
    policiesToBeDeployed:
      - type: onap.policies.native.Apex
        type_version: 1.0.0
        properties:
          # Omitted for brevity
        name: onap.controllloop.operational.apex.bbs.WestRegion
        version: 1.0.0
        metadata:
          policy-id: onap.controllloop.operational.apex.bbs.WestRegion
          policy-version: 1.0.0
    messageName: PDP_UPDATE
    requestId: 3534e54f-4432-4c68-81c8-a6af07e59fb2
    timestampMs: 1632325037040
    name: apex-45c6b266-a5fa-4534-b22c-33c2f9a45d02
    pdpGroup: defaultGroup
    pdpSubgroup: apex

2.2 PDP State Change
--------------------

The *PDP_STATE_CHANGE* operation allows the PAP to order state changes on PDPs in PDP groups and subgroups. The
following examples illustrate how the operation is used.

.. code-block:: yaml
  :caption: Change the state of Drools PDP to ACTIVE
  :linenos:

  pdp_state_change:
    source: pap-6e46095a-3e12-4838-912b-a8608fc93b51
    state: ACTIVE
    messageName: PDP_STATE_CHANGE
    requestId: 7d422be6-5baa-4316-9649-09e18301b5a8
    timestampMs: 1633466294899
    name: drools-23d33c2a-8715-43a8-ade5-5923fc0f185c
    pdpGroup: defaultGroup
    pdpSubgroup: drools

.. code-block:: yaml
  :caption: Change the state of all XACML PDPs to ACTIVE
  :linenos:

  pdp_state_change:
    source: pap-6e46095a-3e12-4838-912b-a8608fc93b51
    state: ACTIVE
    messageName: PDP_STATE_CHANGE
    requestId: 7d422be6-5baa-4316-9649-09e18301b5a8
    timestampMs: 1633466294899
    name: xacml-23d33c2a-8715-43a8-ade5-5923fc0f185c
    pdpGroup: defaultGroup
    pdpSubgroup: xacml

.. code-block:: yaml
  :caption: Change the state of APEX PDP to passive
  :linenos:

  pdp_state_change:
    source: pap-e6272159-e1a3-4777-860a-19c47a14cc00
    state: PASSIVE
    messageName: PDP_STATE_CHANGE
    requestId: 60d9a724-ebf3-4434-9da4-caac9c515a2c
    timestampMs: 1633528747518
    name: apex-a3c58a9e-af72-436c-b46f-0c6f31032ca5
    pdpGroup: defaultGroup
    pdpSubgroup: apex
