.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _clamp-acm-participant-intermediary:

Participant Intermediary
########################

The CLAMP Participant Intermediary is a common library in ONAP, which does common message and
state handling for participant implementations. It provides a Java API, which participant
implementations implement to receive and send messages to the CLAMP runtime and to handle
Automation Composition Element state.

Terminology
-----------
- Broadcast message: a message for all participants (participantId=null)
- Message to a participant: a message only for a participant (participantId properly filled)
- MessageSender: a class that takes care of sending messages from participant-intermediary
- GUI: graphical user interface, Postman or a Front-End Application
- Message Broker: supported message Broker are DMaap and Strimzi-Kafka

Inbound messages to participants
--------------------------------
- PARTICIPANT_REGISTER_ACK: received as a response from clamp-acm runtime server as an acknowledgement to ParticipantRegister message sent from a participant
- PARTICIPANT_DEREGISTER_ACK: received as a response from clamp-acm runtime server as an acknowledgement to ParticipantDeregister message sent from a participant
- AUTOMATION_COMPOSITION_STATE_CHANGE: a message received from clamp-acm runtime server for a state change of clamp-acm
- AUTOMATION_COMPOSITION_DEPLOY: a message received from clamp-acm runtime server for a clamp-acm deploy with clamp-acm instances
- PARTICIPANT_PRIME: a message received from clamp-acm runtime server for a participant update with tosca definitions of clamp-acm
- PARTICIPANT_STATUS_REQ: A status request received from clamp-acm runtime server to send an immediate ParticipantStatus from all participants
- PROPERTIES_UPDATE: a message received from clamp-acm runtime server for updating the Ac instance property values
- PARTICIPANT_RESTART: a message received from clamp-acm runtime server with tosca definitions and the Ac instances to handle restarting

Outbound messages
-----------------
- PARTICIPANT_REGISTER: is sent by a participant during startup
- PARTICIPANT_DEREGISTER: is sent by a participant during shutdown
- PARTICIPANT_STATUS: is sent by a participant as heartbeat with the status and health of a participant
- AUTOMATIONCOMPOSITION_STATECHANGE_ACK: is an acknowledgement sent by a participant as a response to AutomationCompositionStateChange
- AUTOMATION_COMPOSITION_DEPLOY_ACK: is an acknowledgement sent by a participant as a response to AutomationCompositionDeploy
- PARTICIPANT_PRIME_ACK: is an acknowledgement sent by a participant as a response to ParticipantPrime

Design of a PARTICIPANT_REGISTER message
----------------------------------------
- A participant starts and send a PARTICIPANT_REGISTER message with participantId and Supported Element Definition Types
- in AC-runtime ParticipantRegisterListener collects the message from Message Broker
- if participant is not present in DB, it saves participant reference with status ON_LINE to DB
- It triggers the execution to send a PARTICIPANT_REGISTER_ACK message to the participant registered
- if participant is present in DB and there are AC Definitions related to the Participant, 
  it triggers the execution to send a PARTICIPANT_RESTART message to the participant restarted 

Design of a PARTICIPANT_DEREGISTER message
------------------------------------------
- A participant is going to close and undeploys all AC-elements and send a PARTICIPANT_DEREGISTER message
- in AC-runtime, ParticipantDeregisterListener collects the message from Message Broker
- It saves participant reference with status OFF_LINE to DB
- It triggers the execution to send a PARTICIPANT_DEREGISTER_ACK message to the participant deregistered
- Participant is not monitored.

Prime of an Automation Composition Definition Type
--------------------------------------------------
- AC-runtime assigns the AC Definition to the participants based of Supported Element Definition Type by participant
- it triggers the execution to send a broadcast PARTICIPANT_PRIME message
- the message is built by ParticipantPrimePublisher using Tosca Service Template data (to fill the list of ParticipantDefinition)
- Participant-intermediary will receive a PARTICIPANT_PRIME message and stores the Tosca Service Template data on ParticipantHandler

DePrime of an Automation Composition Definition Type
----------------------------------------------------
- AC-runtime triggers the execution to send a broadcast PARTICIPANT_PRIME message
- the message is built by ParticipantPrimePublisher with an empty list of ParticipantDefinition
- Participant-intermediary will receive a PARTICIPANT_PRIME message and deletes the Tosca Service Template data on ParticipantHandler

Design of "issues automation composition commands to automation compositions" - case UNDEPLOYED to DEPLOYED
-----------------------------------------------------------------------------------------------------------
- AUTOMATION_COMPOSITION_DEPLOY message with instantiation details and DEPLOY order state is sent to participants
- Participant-intermediary validates the current deployState change
- Participant-intermediary will receive AUTOMATION_COMPOSITION_DEPLOY message and sends the details of AutomationCompositionElements to participants
- Each participant performs its designated job of deployment by interacting with respective frameworks

Design of "issues automation composition commands to automation compositions" - case DEPLOYED to UNDEPLOYED
-----------------------------------------------------------------------------------------------------------
- AUTOMATION_COMPOSITION_STATE_CHANGE message with instantiation details and UNDEPLOY order state is sent to participants
- Participant-intermediary validates the current deployState change
- Participant-intermediary will receive AUTOMATION_COMPOSITION_STATE_CHANGE message and sends AC-element details to participants
- Each participant performs its designated job of undeployment by interacting with respective frameworks


Update of an Automation Composition Instance
--------------------------------------------
- AC-runtime updates the instance properties of the deployed Ac instances
- it triggers the execution to send a broadcast PROPERTIES_UPDATE message
- the message is built by AcElementPropertiesPublisher using the REST request payload (to fill the list of elements with the updated property values)
- Participant-intermediary will receive a PROPERTIES_UPDATE message and stores the updated values of the elements on ParticipantHandler

Design of "issues automation composition commands to automation compositions" - case LOCKED to UNLOCKED
-------------------------------------------------------------------------------------------------------
- AUTOMATION_COMPOSITION_STATE_CHANGE message with instantiation details and UNLOCK order state is sent to participants
- Participant-intermediary validates the current lockState change
- Participant-intermediary will receive AUTOMATION_COMPOSITION_STATE_CHANGE message

Design of "issues automation composition commands to automation compositions" - case UNLOCKED to LOCKED
-------------------------------------------------------------------------------------------------------
- AUTOMATION_COMPOSITION_STATE_CHANGE message with instantiation details and LOCK order state is sent to participants
- Participant-intermediary validates the current lockState change

Design of Delete - case UNDEPLOYED to DELETED
---------------------------------------------
- AUTOMATION_COMPOSITION_STATE_CHANGE message with instantiation details and DELETE order state is sent to participants
- Participant-intermediary validates the current deployState change
- Participant-intermediary will receive AUTOMATION_COMPOSITION_STATE_CHANGE message and sends AC-element details to participants
- Each participant performs its designated job of removing instantiation data if not done in undeployment
- Participant-intermediary will remove instantiation data

Design of a PARTICIPANT_STATUS_REQ message
------------------------------------------
- AC-runtime triggers the execution to send a broadcast PARTICIPANT_STATUS_REQ message or to send it to a specific participant
- the message is built by ParticipantStatusReqPublisher
- Participant-intermediary will receive a PARTICIPANT_STATUS_REQ message

Design of a PARTICIPANT_STATUS message
--------------------------------------
- A participant sends a scheduled PARTICIPANT_STATUS message or in response to a PARTICIPANT_STATUS_REQ message
- This message will hold the state and healthStatus of all the participants running actively
- PARTICIPANT_STATUS message holds a special attribute to return Tosca definitions, this attribute is populated only in response to PARTICIPANT_STATUS_REQ

Design of a AUTOMATION_COMPOSITION_DEPLOY_ACK message
-----------------------------------------------------
- A participant sends AUTOMATION_COMPOSITION_DEPLOY_ACK message in response to a AUTOMATION_COMPOSITION_DEPLOY message.
- For each AC-elements moved to the ordered state as indicated by the AUTOMATION_COMPOSITION_DEPLOY
- AutomationCompositionUpdateAckListener in AC-runtime collects the messages from Message Broker
- It checks the deployStatus of all automation composition elements
- It updates the AC-instance in DB accordingly

Design of a AUTOMATIONCOMPOSITION_STATECHANGE_ACK message
---------------------------------------------------------
- A participant sends AUTOMATIONCOMPOSITION_STATECHANGE_ACK message in response to a AUTOMATIONCOMPOSITION_STATECHANGE message.
- For each AC-elements moved to the ordered state as indicated by the AUTOMATIONCOMPOSITION_STATECHANGE
- AutomationCompositionStateChangeAckListener in AC-runtime collects the messages from Message Broker
- It checks the deployStatus/lockStatus of all automation composition elements
- It updates the AC-instance in DB accordingly
