.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _clamp-controlloop-participant-intermediary:

Participant Intermediary
########################

The CLAMP Participant Intermediary is a common library in ONAP, which does common message and
state handling for participant implementations. It provides a Java API, which participant
implementations implement to receive and send messages to the CLAMP runtime and to handle
Control Loop Element state.

Terminology
-----------
- Broadcast message: a message for all participants (participantId=null and participantType=null)
- Message to a participant: a message only for a participant (participantId and participantType properly filled)
- MessageSender: a class that takes care of sending messages from participant-intermediary
- GUI: graphical user interface, Postman or a Front-End Application

Inbound messages to participants
--------------------------------
- PARTICIPANT_REGISTER_ACK: received as a response from controlloop runtime server as an acknowledgement to ParticipantRegister message sent from a participant
- PARTICIPANT_DEREGISTER_ACK: received as a response from controlloop runtime server as an acknowledgement to ParticipantDeregister message sent from a participant
- CONTROL_LOOP_STATE_CHANGE: a message received from controlloop runtime server for a state change of controlloop
- CONTROL_LOOP_UPDATE: a message received from controlloop runtime server for a controlloop update with controlloop instances
- PARTICIPANT_UPDATE: a message received from controlloop runtime server for a participant update with tosca definitions of controlloop
- PARTICIPANT_STATUS_REQ: A status request received from controlloop runtime server to send an immediate ParticipantStatus from all participants

Outbound messages
-----------------
- PARTICIPANT_REGISTER: is sent by a participant during startup
- PARTICIPANT_DEREGISTER: is sent by a participant during shutdown
- PARTICIPANT_STATUS: is sent by a participant as heartbeat with the status and health of a participant
- CONTROLLOOP_STATECHANGE_ACK: is an acknowledgement sent by a participant as a response to ControlLoopStateChange
- CONTROLLOOP_UPDATE_ACK: is an acknowledgement sent by a participant as a response to ControlLoopUpdate
- PARTICIPANT_UPDATE_ACK: is an acknowledgement sent by a participant as a response to ParticipantUpdate

Design of a PARTICIPANT_REGISTER message
----------------------------------------
- A participant starts and send a PARTICIPANT_REGISTER message
- ParticipantRegisterListener collects the message from DMaap
- if participant is not present in DB, it saves participant reference with status UNKNOWN to DB
- if participant is present in DB, it triggers the execution to send a PARTICIPANT_UPDATE message to the participant registered (message of Priming)
- the message is built by ParticipantUpdatePublisher using Tosca Service Template data (to fill the list of ParticipantDefinition)
- It triggers the execution to send a PARTICIPANT_REGISTER_ACK message to the participant registered
- MessageIntercept intercepts that event, if PARTICIPANT_UPDATE message has been sent, it will be add a task to handle PARTICIPANT_REGISTER in SupervisionScanner
- SupervisionScanner starts the monitoring for participantUpdate

Design of a PARTICIPANT_DEREGISTER message
------------------------------------------
- A participant starts and send a PARTICIPANT_DEREGISTER message
- ParticipantDeregisterListener collects the message from DMaap
- if participant is not present in DB, do nothing
- if participant is present in DB, it triggers the execution to send a PARTICIPANT_UPDATE message to the participant registered (message of DePriming)
- the message is built by ParticipantUpdatePublisher using Tosca Service Template data as null
- ParticipantHandler removes the tosca definitions stored
- It triggers the execution to send a PARTICIPANT_DEREGISTER_ACK message to the participant registered
- Participant is not monitored.

Design of a creation of a Control Loop Type
-------------------------------------------
- If there are participants registered with CL-runtime, it triggers the execution to send a broadcast PARTICIPANT_UPDATE message
- the message is built by ParticipantUpdatePublisher using Tosca Service Template data (to fill the list of ParticipantDefinition)
- Participant-intermediary will receive a PARTICIPANT_UDPATE message and stores the Tosca Service Template data on ParticipantHandler

Design of a deletion of a Control Loop Type
-------------------------------------------
- if there are participants registered, CL-runtime triggers the execution to send a broadcast PARTICIPANT_UPDATE message
- the message is built by ParticipantUpdatePublisher with an empty list of ParticipantDefinition
- It deletes the Control Loop Type from DB
- Participant-intermediary will receive a PARTICIPANT_UDPATE message and deletes the Tosca Service Template data on ParticipantHandler

Design of a creation of a Control Loop
--------------------------------------
- CONTROL_LOOP_UPDATE message with instantiation details and UNINITIALISED state is sent to participants
- Participant-intermediary validates the current state change
- Participant-intermediary will recieve CONTROL_LOOP_UPDATE message and sends the details of ControlLoopElements to participants
- Each participant performs its designated job of deployment by interacting with respective frameworks

Design of a deletion of a Control Loop
--------------------------------------
- CONTROL_LOOP_STATE_CHANGE message with UNINITIALISED state is sent to participants
- Participant-intermediary validates the current state change
- Participant-intermediary will recieve CONTROL_LOOP_STATE_CHANGE message and sends the details of ControlLoopElements to participants
- Each participant performs its designated job of undeployment by interacting with respective frameworks

Design of "issues control loop commands to control loops" - case UNINITIALISED to PASSIVE
-----------------------------------------------------------------------------------------
- CONTROL_LOOP_STATE_CHANGE message with state changed from UNINITIALISED to PASSIVE is sent to participants
- Participant-intermediary validates the current state change
- Participant-intermediary will recieve CONTROL_LOOP_STATE_CHANGE message and sends the details of state change to participants
- Each participant performs its designated job of state change by interacting with respective frameworks

Design of "issues control loop commands to control loops" - case PASSIVE to UNINITIALISED
-----------------------------------------------------------------------------------------
- CONTROL_LOOP_STATE_CHANGE message with state changed from PASSIVE to UNINITIALISED is sent to participants
- Participant-intermediary validates the current state change
- Participant-intermediary will recieve CONTROL_LOOP_STATE_CHANGE message and sends the details of state change to participants
- Each participant performs its designated job of state change by interacting with respective frameworks

Design of "issues control loop commands to control loops" - case PASSIVE to RUNNING
-----------------------------------------------------------------------------------
- CONTROL_LOOP_STATE_CHANGE message with state changed from PASSIVE to RUNNING is sent to participants
- Participant-intermediary validates the current state change
- Participant-intermediary will recieve CONTROL_LOOP_STATE_CHANGE message and sends the details of state change to participants
- Each participant performs its designated job of state change by interacting with respective frameworks

Design of "issues control loop commands to control loops" - case RUNNING to PASSIVE
-----------------------------------------------------------------------------------
- CONTROL_LOOP_STATE_CHANGE message with state changed from RUNNING to PASSIVE is sent to participants
- Participant-intermediary validates the current state change
- Participant-intermediary will recieve CONTROL_LOOP_STATE_CHANGE message and sends the details of state change to participants
- Each participant performs its designated job of state change by interacting with respective frameworks

Design of a PARTICIPANT_STATUS message
--------------------------------------
- A participant sends a scheduled PARTICIPANT_STATUS message
- This message will hold the state and healthStatus of all the participants running actively
- PARTICIPANT_STATUS message holds a special attribute to return Tosca definitions, this attribute is populated only in response to PARTICIPANT_STATUS_REQ

Design of a CONTROLLOOP_UPDATE_ACK message
------------------------------------------
- A participant sends CONTROLLOOP_UPDATE_ACK message in response to a CONTROLLOOP_UPDATE message.
- For each CL-elements moved to the ordered state as indicated by the CONTROLLOOP_UPDATE
- ControlLoopUpdateAckListener in CL-runtime collects the messages from DMaap
- It checks the status of all control loop elements and checks if the control loop is primed
- It updates the controlloop in DB accordingly

Design of a CONTROLLOOP_STATECHANGE_ACK is similar to the design for CONTROLLOOP_UPDATE_ACK
