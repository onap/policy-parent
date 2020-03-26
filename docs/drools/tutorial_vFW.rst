
.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

****************************************************
Tutorial: Testing the vFW flow in a standalone PDP-D
****************************************************

.. contents::
    :depth: 3

// TODO update with new vFW example and tests used in drools-applications

High Level Architecture
^^^^^^^^^^^^^^^^^^^^^^^
The vFW flow begins with an onset message that is sent from DCAE notifying the PDP-D that an action needs to be taken on a VNF. Once the PDP-D has inserted the onset into drools memory, rules begin to fire to start processing the onset for the vFW policy that exists in drools memory. If the onset is not enriched with A&AI data, Policy will query A&AI for the VNF data otherwise the PDP-D will get the A&AI data needed directly from the onset. Then an A&AI named query is executed on the source VNF entity from the onset to find the target VNF entity that the PDP-D will take action on. Once the target entity is retrieved from A&AI, a Guard query is executed to determine if the action to be taken is allowed. If Guard returns a permit, the PDP-D will then send an APPC ModifyConfig recipe request to modify pg-streams as specified in the request payload. If APPC is successful then the PDP-D will send a final success notification on the POLICY-CL-MGT topic and gracefully end processing the event.

Initial Setup
^^^^^^^^^^^^^

For this tutorial, it is assumed that the set up steps from section
*Using the Control Loop PDP-D docker image for standalone testing* has been followed.

Running the Flow
^^^^^^^^^^^^^^^^

**Step 1:** Deploy the vFW Operational Policy.

   .. code-block:: bash

       cat pdp-update-vfw.json
        {
          "policies": [
             {
             "type": "onap.policies.controlloop.Operational",
             "type_version": "1.0.0",
             "properties": {
             "content": "controlLoop%3A%0A++++version%3A+2.0.0%0A++++controlLoopName%3A+ControlLoop-vFirewall-135835e3-eed7-497a-83ab-8c315f37fa4a%0A++++trigger_policy%3A+unique-policy-id-1-modifyConfig%0A++++timeout%3A+1200%0A++++abatement%3A+false%0Apolicies%3A%0A++++-+id%3A+unique-policy-id-1-modifyConfig%0A++++++name%3A+modify_packet_gen_config%0A++++++description%3A%0A++++++actor%3A+APPC%0A++++++recipe%3A+ModifyConfig%0A++++++target%3A%0A++++++++++resourceID%3A+Eace933104d443b496b8.nodes.heat.vpg%0A++++++++++type%3A+VNF%0A++++++payload%3A%0A++++++++++streams%3A+%27%7B%22active-streams%22%3A5%7D%27%0A++++++retry%3A+0%0A++++++timeout%3A+300%0A++++++success%3A+final_success%0A++++++failure%3A+final_failure%0A++++++failure_timeout%3A+final_failure_timeout%0A++++++failure_retries%3A+final_failure_retries%0A++++++failure_exception%3A+final_failure_exception%0A++++++failure_guard%3A+final_failure_guard%0A"
             },
             "name": "operational.modifyconfig",
             "version": "1.0.0"
             }
           ],
           "messageName": "PDP_UPDATE",
           "requestId": "a7a32d3b-37b4-4fb7-9322-b90c6a6fe365",
           "timestampMs": 1556125347251,
           "name": "pdpd",
           "pdpGroup": "controlloop",
           "pdpSubgroup": "drools"
        }

        http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/POLICY-PDP-PAP/events @pdp-update-vfw.json Content-Type:'text/plain'

        telemetry
        > get controllers/usecases/drools/facts/usecases/controlloops
        > get controllers/usecases/drools/facts/usecases/controlloops/ControlLoop-vFirewall-135835e3-eed7-497a-83ab-8c315f37fa4a

**Step 2:** Inject a simulated *ONSET* message.

    .. code-block:: bash

       cat dcae.vfw.onset.json
        {
          "closedLoopControlName": "ControlLoop-vFirewall-135835e3-eed7-497a-83ab-8c315f37fa4a",
          "closedLoopAlarmStart": 1463679805324,
          "closedLoopEventClient": "microservice.stringmatcher",
          "closedLoopEventStatus": "ONSET",
          "requestID": "c7c6a4aa-bb61-4a15-b831-ba1472dd4a65",
          "target_type": "VNF",
          "target": "generic-vnf.vnf-id",
          "AAI": {
            "generic-vnf.is-closed-loop-disabled": "false",
            "generic-vnf.prov-status": "ACTIVE",
            "generic-vnf.vnf-id": "fw0002vm002fw002"
          },
          "from": "DCAE",
          "version": "1.0.2"
        }

        # activate NOOP sources

        http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/DCAE_TOPIC/switches/activation

        http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/APPC-CL/switches/activation

        http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/DCAE_TOPIC/events @dcae.vfw.onset.json Content-Type:'text/plain'  # send onset

Using the telemetry API, a simulated onset can be injected by the user.
For demo purposes, this is the simulated onset that will be used:

    .. image:: Tut_vFW_simulated_onset.JPG

**NOTE:** The onset that gets injected has to have a closedLoopControlName that matches
the pushed policy's closedLoopControlName.

There should be 8 objects present. Two timers exist to put a time limit on the operation and on
the overall control loop (in the case of retries or policy chaining).
The event and it's associated manager and operation manager are also present in memory.
A lock on the target entity is inserted to ensure no other events try to take action on
the VNF that is currently processing.

The network log will be used to monitor the activity coming in and out of the PDP-D.
This log is located at *$POLICY_HOME/logs/network.log*.
This will show the notifications that the PDP-D sends out at different stages of processing.
The order of successful processing begins with an ACTIVE notification to show that the onset
was acknowledged and the operation is beginning transit.

    .. image:: Tut_vFW_policy_active.JPG

Next a query will be sent to A&AI to get information on the VNF specified from the onset. The picture below shows the query going OUT of the PDP-D and the response coming IN.

**NOTE:** Policy does A&AI queries for VNF information when the onset is not enriched with A&AI data. In this example only the generic-vnf.vnf-name was provided so a query to A&AI is necessary to retrieve data that is needed in the APPC request.

    .. image:: Tut_vFW_aai_get.JPG

For the vFW use case, the source entity reported in the onset message may not be the target entity that the APPC operation takes action on. To determine the true target entity, an A&AI named query is performed. The request is shown in the network log.

    .. image:: Tut_vFW_aai_named_query_request.JPG

The response is also displayed in the network log.

    .. image:: Tut_vFW_aai_named_query_response.JPG

Once the target entity is found, the PDP-D consults Guard to determine if this operation should be allowed, a series of operation notifications are sent for starting the Guard query, obtaining a PERMIT or DENY, and beginning the operation.

    .. image:: Tut_vFW_policy_guard_start.JPG

|

    .. image:: Tut_vFW_policy_guard_result.JPG

|

    .. image:: Tut_vFW_policy_operation_start.JPG

**Step 3:** Inject an APPC response in the APPC-CL topic

A simulated APPC response will be injected to the APPC-CL topic.

    .. code-block:: bash

       cat appc.legacy.success.json
        {
          "CommonHeader": {
            "TimeStamp": 1506051879001,
            "APIver": "1.01",
            "RequestID": "c7c6a4aa-bb61-4a15-b831-ba1472dd4a65",
            "SubRequestID": "1",
            "RequestTrack": [],
            "Flags": []
          },
          "Status": {
            "Code": 400,
            "Value": "SUCCESS"
          },
          "Payload": {
            "streams": {
              "active-streams": 5.0
            },
            "generic-vnf.vnf-id": "7da01f3d-1e1f-374f-b049-f6385fe8d067"
          }
        }

        http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/APPC-CL/switches/activation   # activate noop source

       http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/APPC-CL/events @appc.legacy.success.json Content-Type:'text/plain'

The network log will show the PDP-D sent an operation success notification.

    .. image:: Tut_vFW_policy_operation_success.JPG

Then a final success notification is sent.

    .. image:: Tut_vFW_policy_final_success.JPG

After processing there should only be 2 facts left in memory.

End of Document
