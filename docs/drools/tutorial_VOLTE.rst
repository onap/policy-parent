
.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

**********************************************************
Tutorial: Testing the VOLTE Use Case in a standalone PDP-D
**********************************************************

.. contents::
    :depth: 3

In this tutorial we will test the vDNS flow in a standalone PDP-D docker container.

Initial Setup
^^^^^^^^^^^^^

It is assumed that the set up steps from section
*Using the Control Loop PDP-D docker image for standalone testing* has been followed for
this tutorial.

Running the Flow
^^^^^^^^^^^^^^^^

**Step 1:** Deploy the vDNS Operational Policy.

    .. code-block:: bash

        cat pdp-update-volte.json
        {
          "policies": [
             {
             "type": "onap.policies.controlloop.Operational",
             "type_version": "1.0.0",
             "properties": {
             "content": "controlLoop%3A%0A%20%20version%3A%202.0.0%0A%20%20controlLoopName%3A%20ControlLoop-VOLTE-2179b738-fd36-4843-a71a-a8c24c70c55b%0A%20%20trigger_policy%3A%20unique-policy-id-1-restart%0A%20%20timeout%3A%203600%0A%20%20abatement%3A%20false%0A%0Apolicies%3A%0A%20%20-%20id%3A%20unique-policy-id-1-restart%0A%20%20%20%20name%3A%20Restart%20the%20VM%0A%20%20%20%20description%3A%0A%20%20%20%20actor%3A%20VFC%0A%20%20%20%20recipe%3A%20Restart%0A%20%20%20%20target%3A%0A%20%20%20%20%20%20type%3A%20VM%0A%20%20%20%20retry%3A%203%0A%20%20%20%20timeout%3A%201200%0A%20%20%20%20success%3A%20final_success%0A%20%20%20%20failure%3A%20final_failure%0A%20%20%20%20failure_timeout%3A%20final_failure_timeout%0A%20%20%20%20failure_retries%3A%20final_failure_retries%0A%20%20%20%20failure_exception%3A%20final_failure_exception%0A%20%20%20%20failure_guard%3A%20final_failure_guard%0A"
             },
             "name": "operational.volte",
             "version": "1.0.0"
             }
           ],
           "messageName": "PDP_UPDATE",
           "requestId": "a7a32d3b-37b4-4fb7-9322-b90c6a6fe365",
           "timestampMs": 1556125347251,
           "name": "PDPDcl",
           "pdpGroup": "controlloop",
           "pdpSubgroup": "drools"
        }

        http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/POLICY-PDP-PAP/events @pdp-update-volte.json Content-Type:'text/plain'

        telemetry
        > get controllers/usecases/drools/facts/usecases/controlloops
        > get controllers/usecases/drools/facts/usecases/controlloops/ControlLoop-VOLTE-2179b738-fd36-4843-a71a-a8c24c70c55b

**Step 2:** Inject a simulated *ONSET* message.

    .. code-block:: bash

        cat dcae.volte.onset.json
        {
            "closedLoopControlName": "ControlLoop-VOLTE-2179b738-fd36-4843-a71a-a8c24c70c55b",
            "closedLoopAlarmStart": 1484677482204798,
            "closedLoopEventClient": "DCAE.HolmesInstance",
            "closedLoopEventStatus": "ONSET",
            "requestID": "97964e10-686e-4790-8c45-bdfa61df770f",
            "target_type": "VM",
            "target": "vserver.vserver-name",
            "AAI": {
                "vserver.is-closed-loop-disabled": "false",
                "vserver.prov-status": "ACTIVE",
                "vserver.vserver-name": "dfw1lb01lb01",
                "service-instance.service-instance-id" : "vserver-name-16102016-aai3255-data-11-1",
                "generic-vnf.vnf-id" : "vnf-id-16102016-aai3255-data-11-1",
                "generic-vnf.vnf-name" : "vnf-name-16102016-aai3255-data-11-1"
            },
            "from": "DCAE",
            "version": "1.0.2"
        }

        http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/POLICY-PDP-PAP/events @dcae.volte.onset.json Content-Type:'text/plain'

The network log can be used to monitor the PDP-D network input/output operations.
This log is located at *$POLICY_LOGS/network.log*.
The log file will show interactions with the AAI and SO simulator to fulfill the flow.
Once the transaction has completed, a final success notification will be recorded in this file.

End of Document
