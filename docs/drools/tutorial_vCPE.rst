
.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

*********************************************************
Tutorial: Testing the vCPE use case in a standalone PDP-D
*********************************************************

.. contents::
    :depth: 3


High Level Architecture
^^^^^^^^^^^^^^^^^^^^^^^
The vCPE flow begins with an onset message that is sent from DCAE notifying the PDP-D that an action needs to be taken on a VM/VNF. Once the PDP-D has inserted the onset into drools memory, rules begin to fire to start processing the onset for the vCPE policy that exists in drools memory. If the onset is not enriched with A&AI data, Policy will query A&AI for the VM/VNF data otherwise the PDP-D will get the A&AI data needed directly from the onset. A Guard query is then executed to determine if the action to be taken is allowed. If Guard returns a permit, the PDP-D will then send an APPC Restart recipe request to restart the VM/VNF specified in the request. If APPC is successful then the PDP-D will send a operation success notification on the POLICY-CL-MGT topic. The PDP-D waits for an abatement message to come from DCAE before ending the transaction. Once the abatement is received the PDP-D sends a final success notification and gracefully ends processing the event.

Initial Setup
^^^^^^^^^^^^^

For this tutorial, it is assumed that the set up steps from section
*Using the Control Loop PDP-D docker image for standalone testing* has been followed.

Running the Flow
^^^^^^^^^^^^^^^^

**Step 1:** Deploy the vCPE Operational Policy.

    .. code-block:: bash

       cat pdp-update-vcpe.json
       {
         "policies": [
            {
            "type": "onap.policies.controlloop.Operational",
            "type_version": "1.0.0",
            "properties": {
            "content": "controlLoop%3A%0A%20%20version%3A%202.0.0%0A%20%20controlLoopName%3A%20ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e%0A%20%20trigger_policy%3A%20unique-policy-id-1-restart%0A%20%20timeout%3A%203600%0A%20%20abatement%3A%20false%0A%20%0Apolicies%3A%0A%20%20-%20id%3A%20unique-policy-id-1-restart%0A%20%20%20%20name%3A%20Restart%20the%20VM%0A%20%20%20%20description%3A%0A%20%20%20%20actor%3A%20APPC%0A%20%20%20%20recipe%3A%20Restart%0A%20%20%20%20target%3A%0A%20%20%20%20%20%20type%3A%20VM%0A%20%20%20%20retry%3A%203%0A%20%20%20%20timeout%3A%201200%0A%20%20%20%20success%3A%20final_success%0A%20%20%20%20failure%3A%20final_failure%0A%20%20%20%20failure_timeout%3A%20final_failure_timeout%0A%20%20%20%20failure_retries%3A%20final_failure_retries%0A%20%20%20%20failure_exception%3A%20final_failure_exception%0A%20%20%20%20failure_guard%3A%20final_failure_guard"
            },
            "name": "operational.restart",
            "version": "1.0.0"
            }
          ],
          "messageName": "PDP_UPDATE",
          "requestId": "a7a32d3b-37b4-4fb7-9322-b90c6a6fe365",
          "timestampMs": 1556125347251,
          "name": "8a9e0c256c59",                               # note this is the hostname
          "pdpGroup": "controlloop",
          "pdpSubgroup": "drools"
       }

       http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/POLICY-PDP-PAP/events @pdp-update-vcpe.json Content-Type:'text/plain'

       telemetry                                                # verify
       > get controllers/usecases/drools/facts/usecases/controlloops
       > get controllers/usecases/drools/facts/usecases/controlloops/ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e

**Step 2:** Inject a simulated *ONSET* message.

    .. code-block:: bash

       cat dcae.vcpe.onset.json
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

       http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/DCAE_TOPIC/switches/activation     # activate noop source

       http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/DCAE_TOPIC/events @dcae.vcpe.onset.json Content-Type:'text/plain'  # send onset

**NOTE:** The simulated onset is enriched with A&AI data. The PDP-D will not make an A&AI query since the data needed can be extracted from the onset.

Now check the facts in memory, there should be 8 objects present. Two timers exist to put a time limit on the operation and on the overall control loop (in the case of retries or policy chaining). The event and it's associated manager and operation manager are also present in memory. A lock on the target entity is inserted to ensure no other events try to take action on the VM/VNF that is currently processing.

The network log will be used to monitor the activity coming in and out of the PDP-D. This log is located at *$POLICY_LOGS/network.log*. This will show the notifications that the PDP-D sends out at different stages of processing. The order of successful processing begins with an ACTIVE notification to show that the onset was acknowledged and the operation is beginning transit.

    .. image:: Tut_vCPE_policy_active.JPG

Once the event is in the ACTIVE state, the PDP-D consults Guard to determine if this operation should be allowed, a series of operation notifications are sent for starting the Guard query, obtaining a PERMIT or DENY, and beginning the operation.

    .. image:: Tut_vCPE_guard_not_queried.JPG

|

    .. image:: Tut_vCPE_guard_result.JPG

|

    .. image:: Tut_vCPE_policy_operation.JPG

**Step 3:** Inject an APPC response in the APPC-LCM-WRITE topic

    .. code-block:: bash

       cat appc.lcm.success.json
       {
         "body": {
           "output": {
             "common-header": {
               "timestamp": "2017-08-25T21:06:23.037Z",
               "api-ver": "5.00",
               "originator-id": "664be3d2-6c12-4f4b-a3e7-c349acced200",
               "request-id": "664be3d2-6c12-4f4b-a3e7-c349acced200",
               "sub-request-id": "1",
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

       http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/APPC-LCM-WRITE/switches/activation   # activate noop source

       http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/APPC-LCM-WRITE/events @appc.lcm.success.json Content-Type:'text/plain'

    .. image:: Tut_vCPE_inject_appc_response.JPG

The network log will show the PDP-D sent an operation success notification.

    .. image:: Tut_vCPE_policy_operation_success.JPG

Once the transaction has completed, a final success notification is sent from the PDP-D.

    .. image:: Tut_vCPE_policy_final_success.JPG

After processing there should only be 2 facts left in memory.

End of Document
