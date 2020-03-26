
.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

*********************************************************
Tutorial: Testing the vDNS Use Case in a standalone PDP-D
*********************************************************

.. contents::
    :depth: 3

// TODO update with new vDNS example and tests used in drools-applications

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

        cat pdp-update-vdns.json
        {
          "policies": [
             {
             "type": "onap.policies.controlloop.Operational",
             "type_version": "1.0.0",
             "properties": {
             "content": "controlLoop%3A%0A%20%20version%3A%202.0.0%0A%20%20controlLoopName%3A%20ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3%0A%20%20services%3A%0A%20%20%20%20-%20serviceName%3A%20d4738992-6497-4dca-9db9%0A%20%20%20%20%20%20serviceInvariantUUID%3A%20dc112d6e-7e73-4777-9c6f-1a7fb5fd1b6f%0A%20%20%20%20%20%20serviceUUID%3A%202eea06c6-e1d3-4c3a-b9c4-478c506eeedf%0A%20%20trigger_policy%3A%20unique-policy-id-1-scale-up%0A%20%20timeout%3A%2060%0A%20%0Apolicies%3A%0A%20%20-%20id%3A%20unique-policy-id-1-scale-up%0A%20%20%20%20name%3A%20Create%20a%20new%20VF%20Module%0A%20%20%20%20description%3A%0A%20%20%20%20actor%3A%20SO%0A%20%20%20%20recipe%3A%20VF%20Module%20Create%0A%20%20%20%20target%3A%0A%20%20%20%20%20%20type%3A%20VFMODULE%0A%20%20%20%20%20%20modelInvariantId%3A%2090b793b5-b8ae-4c36-b10b-4b6372859d3a%0A%20%20%20%20%20%20modelVersionId%3A%202210154d-e61a-4d7f-8fb9-0face1aee3f8%0A%20%20%20%20%20%20modelName%3A%20SproutScalingVf..scaling_sprout..module-1%0A%20%20%20%20%20%20modelVersion%3A%201%0A%20%20%20%20%20%20modelCustomizationId%3A%203e2d67ad-3495-4732-82f6-b0b872791fff%0A%20%20%20%20payload%3A%0A%20%20%20%20%20%20requestParameters%3A%20%27%7B%22usePreload%22%3Atrue%2C%22userParams%22%3A%5B%5D%7D%27%0A%20%20%20%20%20%20configurationParameters%3A%20%27%5B%7B%22ip-addr%22%3A%22%24.vf-module-topology.vf-module-parameters.param%5B9%5D%22%2C%22oam-ip-addr%22%3A%22%24.vf-module-topology.vf-module-parameters.param%5B16%5D%22%2C%22enabled%22%3A%22%24.vf-module-topology.vf-module-parameters.param%5B23%5D%22%7D%5D%27%0A%20%20%20%20retry%3A%200%0A%20%20%20%20timeout%3A%2030%0A%20%20%20%20success%3A%20final_success%0A%20%20%20%20failure%3A%20final_failure%0A%20%20%20%20failure_timeout%3A%20final_failure_timeout%0A%20%20%20%20failure_retries%3A%20final_failure_retries%0A%20%20%20%20failure_exception%3A%20final_failure_exception%0A%20%20%20%20failure_guard%3A%20final_failure_guard%0A"
             },
             "name": "operational.scaleout",
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

        http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/POLICY-PDP-PAP/events @pdp-update-vdns.json Content-Type:'text/plain'

        telemetry
        > get controllers/usecases/drools/facts/usecases/controlloops
        > get controllers/usecases/drools/facts/usecases/controlloops/ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3

**Step 2:** Inject a simulated *ONSET* message.

    .. code-block:: bash

        cat dcae.vdns.onset.json
        {
          "closedLoopControlName": "ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3",
          "closedLoopAlarmStart": 1484677482204798,
          "closedLoopEventClient": "DCAE_INSTANCE_ID.dcae-tca",
          "closedLoopEventStatus": "ONSET",
          "requestID": "e4f95e0c-a013-4530-8e59-c5c5f9e539b6",
          "target_type": "VNF",
          "target": "vserver.vserver-name",
          "AAI": {
            "vserver.is-closed-loop-disabled": "false",
            "vserver.prov-status": "ACTIVE",
            "vserver.vserver-name": "dfw1lb01lb01"
          },
          "from": "DCAE",
          "version": "1.0.2"
        }

        http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/DCAE_TOPIC/switches/activation    # activate noop source

        http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/DCAE_TOPIC/events @dcae.vdns.onset.json Content-Type:'text/plain'   # send onset

The network log can be used to monitor the PDP-D network input/output operations. This log is located at *$POLICY_LOGS/network.log*.  The log file will show interactions with the AAI and SO simulator to fulfill the flow.  Once the transaction has completed, a final success notification will be recorded in this file.

    .. code-block:: bash

        {
          "AAI": {
            "vserver.prov-status": "ACTIVE",
            "vserver.is-closed-loop-disabled": "false",
            "vserver.vserver-name": "dfw1lb01lb01"
          },
          "closedLoopAlarmStart": 1484677482204798,
          "closedLoopControlName": "ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3",
          "version": "1.0.2",
          "requestId": "e4f95e0c-a013-4530-8e59-c5c5f9e539b6",
          "closedLoopEventClient": "DCAE_INSTANCE_ID.dcae-tca",
          "targetType": "VNF",
          "target": "vserver.vserver-name",
          "from": "policy:usecases",
          "policyScope": "onap.policies.controlloop.Operational:1.0.0",
          "policyName": "operational.scaleout.EVENT.MANAGER",
          "policyVersion": "1.0.0",
          "notification": "FINAL: SUCCESS",
          "notificationTime": "2019-06-24 20:52:16.370000+00:00",
          "history": [
            {
              "actor": "SO",
              "operation": "VF Module Create",
              "target": "Target [type=VFMODULE, resourceId=null]",
              "start": 1561409536125,
              "end": 1561409536368,
              "subRequestId": "1",
              "outcome": "Success",
              "message": "200 Success"
            }
          ]
        }

End of Document
