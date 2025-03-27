.. This work is licensed under a Creative Commons Attribution 4.0 International License.

OPA-PDP high level architecture
*******************************

.. contents::
    :depth: 3

Software Architecture
^^^^^^^^^^^^^^^^^^^^^

      .. container:: sectionbody

         .. container:: imageblock

            .. container:: content

               |OPA PDP Architecture|

            .. container:: title

               Figure 1. OPA PDP Architecture

         .. container:: ulist

            - **KafkaListener/Producer**: This component listens for incoming PDP_UPDATE and PDP_STATE_CHANGE messages from PAP. OPA PDP sends PDP_STATUS messages to PAP via Producer.
            - **OPA PDP Engine**: The Go application that decodes base64 TOSCA policies and handles the deployment and undeployment of policies into the OPA SDK.

            .. container:: ulist

               - Msg Processor: Handles incoming PDP_UPDATE and PDP_STATE_CHANGE messages from PAP.
               - PDP STATE: Maintains PDP State Active or Passive.
               - Policy Map: In Memory Cache that holds the Map of names of policies,policy keys and data keys  deployed.
               - Metrics: Handles statistics of number of policies deployed,success and failure counts and other metrics.

            - **OPA SDK**: An Open Source OPA Go library component that stores data and policies in memory and manages the policies.
            - **REST Interface**: Exposes APIs for decision-execution, dynamic data updates, fetch statistics, and health checks.

OPA PDP And PolicyFramework Interaction
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

      .. container:: sectionbody

         .. container:: paragraph

            OPA-PDP will handles all messages that PAP sends similar to other PDPs.Following are functionalities supported.

            .. container:: ulist

               - Registration
               - Handle PDP_UPDATE
               - Handle PDP_STATE_CHANGE
               - Send Heartbeat Messages
               - Deploy Policy
               - Undeploy Policy

         .. container:: paragraph

            Once OPA-PDP is up it will send “Registration”( PDP_STATUS)  message to PAP.Some of the information included in the message are:

         .. container:: ulist

            - pdpType the type of the PDP opa .
            - pdpGroup to which the PDP should belong to  **opaGroup**.
            - state the initial state of the PDP which is PASSIVE.
            - healthy whether the PDP is “HEALTHY” or not.
            - name a name that is unique to the PDP instance  for e.g. **opa-f849384c-dd78-4016-a7b5-1c660fb6ee0e**

         .. literalinclude:: resources/registration_message.json
            :language: JSON
            :caption: Regsitration Message

         .. container:: paragraph

            Upon receiving the registration message PAP sends a PDP_UPDATE message along with the **pdpHeartbeatIntervalMs**, which specifies the time interval at which PDPs should send heartbeats to the PAP. The OPA-PDP starts a timer to send heartbeat messages periodically. Additionally, the OPA-PDP sends a PDP_STATUS response to the PDP_UPDATE message.

         .. literalinclude:: resources/response_to_pdp_update.json
            :language: JSON
            :caption: Example PDP_STATUS response  to PDP_UPDATE

         .. container:: paragraph

            PAP sends a PDP_STATE_CHANGE message to change the state of PDPs from PASSIVE to ACTIVE. After registration, PAP makes a PDP ACTIVE by default. OPA-PDP handles the state change, updates its state accordingly, and sends a PDP_STATUS response. When a PDP becomes ACTIVE .In the ACTIVE state, OPA-PDP is ready to receive decision requests.

         .. literalinclude:: resources/response_to_pdp_state_change.json
            :language: JSON
            :caption: Example PDP_STATUS response  to PDP_STATE_CHANGE

Deploy OPA policy
^^^^^^^^^^^^^^^^^

      .. container:: sectionbody

         .. container:: paragraph

            After receiving the PDP_UPDATE message to deploy policies on Kafka, the OPA PDP will perform the following steps:

         .. container:: ulist

            - Parse the message
            - Extract policy
            - Perform base64 decoding
            - Validate Rego syntax of decoded policy
            - validate json format of decoded policy
            - validate constraints

.. note::
         .. container:: ulist

            -  Policy key should start with policyname.
            -  Datakey should start with node.policyname.
            -  The package name in rego file and policy key should be same.
            -  Policy naming rules are validated.


UnDeploy OPA policy
^^^^^^^^^^^^^^^^^^^

      .. container:: sectionbody

         .. container:: paragraph

            After receiving the PDP_UPDATE message to undeploy policies on Kafka, the OPA PDP will perform the following steps:

         .. container:: ulist

            - Parse the message
            - Check policy exists
            - Remove data from OPA SDK
            - Remove policy from OPA SDK



.. container::
   :name: footer

   .. container::
      :name: footer-text

      1.0.0-SNAPSHOT
      Last updated 2025-03-27 16:04:24 IST

.. |OPA PDP Architecture| image:: images/OPA-PDP.drawio.svg
   :width: 700px
   :height: 300px