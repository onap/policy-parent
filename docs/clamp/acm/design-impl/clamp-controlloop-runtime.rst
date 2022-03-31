.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _clamp-controlloop-runtime:

The CLAMP Control Loop Runtime
##############################

.. contents::
    :depth: 3


This article explains how CLAMP Control Loop Runtime is implemented.

Terminology
***********
- Broadcast message: a message for all participants (participantId=null and participantType=null)
- Message to a participant: a message only for a participant (participantId and participantType properly filled)
- ThreadPoolExecutor: ThreadPoolExecutor executes the given task, into SupervisionAspect class is configured to execute tasks in ordered manner, one by one
- Spring Scheduling: into SupervisionAspect class, the @Scheduled annotation invokes "schedule()" method every "runtime.participantParameters.heartBeatMs" milliseconds with a fixed delay
- MessageIntercept: "@MessageIntercept" annotation is used into SupervisionHandler class to intercept "handleParticipantMessage" method calls using spring aspect oriented programming
- GUI: graphical user interface, Postman or a Front-End Application

Design of Rest Api
******************

Create of a Control Loop Type
+++++++++++++++++++++++++++++
- GUI calls POST "/commission" endpoint with a Control Loop Type Definition (Tosca Service Template) as body
- CL-runtime receives the call by Rest-Api (CommissioningController)
- It saves to DB the Tosca Service Template using PolicyModelsProvider
- if there are participants registered, it triggers the execution to send a broadcast PARTICIPANT_UPDATE message
- the message is built by ParticipantUpdatePublisher using Tosca Service Template data (to fill the list of ParticipantDefinition)

Delete of a Control Loop Type
+++++++++++++++++++++++++++++
- GUI calls DELETE "/commission" endpoint
- CL-runtime receives the call by Rest-Api (CommissioningController)
- if there are participants registered, CL-runtime triggers the execution to send a broadcast PARTICIPANT_UPDATE message
- the message is built by ParticipantUpdatePublisher with an empty list of ParticipantDefinition
- It deletes the Control Loop Type from DB

Create of a Control Loop
++++++++++++++++++++++++
- GUI calls POST "/instantiation" endpoint with a Control Loop as body
- CL-runtime receives the call by Rest-Api (InstantiationController)
- It validates the Control Loop
- It saves the Control Loop to DB
- Design of an update of a Control Loop
- GUI calls PUT "/instantiation" endpoint with a Control Loop as body
- CL-runtime receives the call by Rest-Api (InstantiationController)
- It validates the Control Loop
- It saves the Control Loop to DB

Delete of a Control Loop
++++++++++++++++++++++++
- GUI calls DELETE "/instantiation" endpoint
- CL-runtime receives the call by Rest-Api (InstantiationController)
- It checks that Control Loop is in UNINITIALISED status
- It deletes the Control Loop from DB

"issues control loop commands to control loops"
+++++++++++++++++++++++++++++++++++++++++++++++

case **UNINITIALISED to PASSIVE**

- GUI calls "/instantiation/command" endpoint with PASSIVE as orderedState
- CL-runtime checks if participants registered are matching with the list of control Loop Element
- It updates control loop and control loop elements to DB (orderedState = PASSIVE)
- It validates the status order issued
- It triggers the execution to send a broadcast CONTROL_LOOP_UPDATE message
- the message is built by ControlLoopUpdatePublisher using Tosca Service Template data and ControlLoop data. (with startPhase = 0)
- It updates control loop and control loop elements to DB (state = UNINITIALISED2PASSIVE)

case **PASSIVE to UNINITIALISED**

- GUI calls "/instantiation/command" endpoint with UNINITIALISED as orderedState
- CL-runtime checks if participants registered are matching with the list of control Loop Element
- It updates control loop and control loop elements to DB (orderedState = UNINITIALISED)
- It validates the status order issued
- It triggers the execution to send a broadcast CONTROL_LOOP_STATE_CHANGE message
- the message is built by ControlLoopStateChangePublisher with controlLoopId
- It updates control loop and control loop elements to DB (state = PASSIVE2UNINITIALISED)

case **PASSIVE to RUNNING**

- GUI calls "/instantiation/command" endpoint with RUNNING as orderedState
- CL-runtime checks if participants registered are matching with the list of control Loop Element.
- It updates control loop and control loop elements to DB (orderedState = RUNNING)
- It validates the status order issued
- It triggers the execution to send a broadcast CONTROL_LOOP_STATE_CHANGE message
- the message is built by ControlLoopStateChangePublisher with controlLoopId
- It updates control loop and control loop elements to DB (state = PASSIVE2RUNNING)

case **RUNNING to PASSIVE**

- GUI calls "/instantiation/command" endpoint with UNINITIALISED as orderedState
- CL-runtime checks if participants registered are matching with the list of control Loop Element
- It updates control loop and control loop elements to db (orderedState = RUNNING)
- It validates the status order issued
- It triggers the execution to send a broadcast CONTROL_LOOP_STATE_CHANGE message
- the message is built by ControlLoopStateChangePublisher with controlLoopId
- It updates control loop and control loop elements to db (state = RUNNING2PASSIVE)

StartPhase
**********
The startPhase is particularly important in control loop update and control loop state changes because sometime the user wishes to control the order in which the state changes in Control Loop Elements in a control loop.

How to define StartPhase
++++++++++++++++++++++++
StartPhase is defined as shown below in the Definition of TOSCA fundamental Control Loop Types yaml file.

.. code-block:: YAML

  startPhase:
    type: integer
    required: false
    constraints:
    - greater-or-equal: 0
    description: A value indicating the start phase in which this control loop element will be started, the
                 first start phase is zero. Control Loop Elements are started in their start_phase order and stopped
                 in reverse start phase order. Control Loop Elements with the same start phase are started and
                 stopped simultaneously
    metadata:
      common: true

The "common: true" value in the metadata of the startPhase property identifies that property as being a common property.
This property will be set on the CLAMP GUI during control loop commissioning.
Example where it could be used:

.. code-block:: YAML

  org.onap.domain.database.Http_PMSHMicroserviceControlLoopElement:
    # Consul http config for PMSH.
    version: 1.2.3
    type: org.onap.policy.clamp.controlloop.HttpControlLoopElement
    type_version: 1.0.1
    description: Control loop element for the http requests of PMSH microservice
    properties:
      provider: ONAP
      participant_id:
        name: HttpParticipant0
        version: 1.0.0
      participantType:
        name: org.onap.k8s.controlloop.HttpControlLoopParticipant
        version: 2.3.4
      uninitializedToPassiveTimeout: 180
      startPhase: 1

How StartPhase works
++++++++++++++++++++
In state changes from UNITITIALISED → PASSIVE, control loop elements are started in increasing order of their startPhase.

Example with Http_PMSHMicroserviceControlLoopElement with startPhase to 1 and PMSH_K8SMicroserviceControlLoopElement with startPhase to 0

- CL-runtime sends a broadcast CONTROL_LOOP_UPDATE message to all participants with startPhase = 0
- participant receives the CONTROL_LOOP_UPDATE message and runs to PASSIVE state (only CL elements defined as startPhase = 0)
- CL-runtime receives CONTROL_LOOP_UPDATE_ACT messages from participants and set the state (from the CL element of the message) to PASSIVE
- CL-runtime calculates that all CL elements with startPhase = 0 are set to proper state and sends a broadcast CONTROL_LOOP_UPDATE message with startPhase = 1
- participant receives the CONTROL_LOOP_UPDATE message and runs to PASSIVE state (only CL elements defined as startPhase = 1)
- CL-runtime calculates that all CL elements are set to proper state and set CL to PASSIVE

In that scenario the message CONTROL_LOOP_UPDATE has been sent two times.

Design of managing messages
***************************

PARTICIPANT_REGISTER
++++++++++++++++++++
- A participant starts and send a PARTICIPANT_REGISTER message
- ParticipantRegisterListener collects the message from DMaap
- if not present, it saves participant reference with status UNKNOWN to DB
- if is present a Control Loop Type, it triggers the execution to send a PARTICIPANT_UPDATE message to the participant registered (message of Priming)
- the message is built by ParticipantUpdatePublisher using Tosca Service Template data (to fill the list of ParticipantDefinition)
- It triggers the execution to send a PARTICIPANT_REGISTER_ACK message to the participant registered
- MessageIntercept intercepts that event, if PARTICIPANT_UPDATE message has been sent, it will be add a task to handle PARTICIPANT_REGISTER in SupervisionScanner
- SupervisionScanner starts the monitoring for participantUpdate

PARTICIPANT_UPDATE_ACK
++++++++++++++++++++++
- A participant sends PARTICIPANT_UPDATE_ACK message in response to a PARTICIPANT_UPDATE message
- ParticipantUpdateAckListener collects the message from DMaap
- MessageIntercept intercepts that event and adds a task to handle PARTICIPANT_UPDATE_ACK in SupervisionScanner
- SupervisionScanner removes the monitoring for participantUpdate
- It updates the status of the participant to DB

PARTICIPANT_STATUS
++++++++++++++++++
- A participant sends a scheduled PARTICIPANT_STATUS message
- ParticipantStatusListener collects the message from DMaap
- MessageIntercept intercepts that event and adds a task to handle PARTICIPANT_STATUS in SupervisionScanner
- SupervisionScanner clears and starts the monitoring for participantStatus

CONTROLLOOP_UPDATE_ACK
++++++++++++++++++++++
- A participant sends CONTROLLOOP_UPDATE_ACK message in response to a CONTROLLOOP_UPDATE  message. It will send a CONTROLLOOP_UPDATE_ACK - for each CL-elements moved to the ordered state as indicated by the CONTROLLOOP_UPDATE
- ControlLoopUpdateAckListener collects the message from DMaap
- It checks the status of all control loop elements and checks if the control loop is primed
- It updates the CL to DB if it is changed
- MessageIntercept intercepts that event and adds a task to handle a monitoring execution in SupervisionScanner

CONTROLLOOP_STATECHANGE_ACK
+++++++++++++++++++++++++++
Design of a CONTROLLOOP_STATECHANGE_ACK is similar to the design for CONTROLLOOP_UPDATE_ACK

Design of monitoring execution in SupervisionScanner
****************************************************
Monitoring is designed to process the follow operations:

- to determine the next startPhase in a CONTROLLOOP_UPDATE message
- to update CL state: in a scenario that "ControlLoop.state" is in a kind of transitional state (example UNINITIALISED2PASSIVE), if all  - CL-elements are moved properly to the specific state, the "ControlLoop.state" will be updated to that and saved to DB
- to retry CONTROLLOOP_UPDATE/CONTROL_LOOP_STATE_CHANGE messages. if there is a CL Element not in the proper state, it will retry a broadcast message
- to retry PARTICIPANT_UPDATE message to the participant in a scenario that CL-runtime do not receive PARTICIPANT_UPDATE_ACT from it
- to send PARTICIPANT_STATUS_REQ to the participant in a scenario that CL-runtime do not receive PARTICIPANT_STATUS from it

The solution Design of retry, timeout, and reporting for all Participant message dialogues are implemented into the monitoring execution.

- Spring Scheduling inserts the task to monitor retry execution into ThreadPoolExecutor
- ThreadPoolExecutor executes the task
- a message will be retry if CL-runtime do no receive Act message before MaxWaitMs milliseconds

Design of Exception handling
****************************
GlobalControllerExceptionHandler
++++++++++++++++++++++++++++++++
If error occurred during the Rest Api call, CL-runtime responses with a proper status error code and a JSON message error.
This class is implemented to intercept and handle ControlLoopException, PfModelException and PfModelRuntimeException if they are thrown during the Rest Ali calls.
All of those classes must implement ErrorResponseInfo that contains message error and status response code.
So the Exception is converted in JSON message.

RuntimeErrorController
++++++++++++++++++++++
If wrong end-point is called or an Exception not intercepted by GlobalControllerExceptionHandler, CL-runtime responses with a proper status error code and a JSON message error.
This class is implemented to redirect the standard Web error page to a JSON message error.
Typically that happen when a wrong end-point is called, but also could be happen for not authorized call, or any other Exception not intercepted by GlobalControllerExceptionHandler.

Handle version and "X-ONAP-RequestID"
*************************************
RequestResponseLoggingFilter class handles version and "X-ONAP-RequestID" during a Rest-Api call; it works as a filter, so intercepts the Rest-Api and adds to the header those information.

Media Type Support
******************
CL-runtime Rest Api supports **application/json**, **application/yaml** and **text/plain** Media Types. The configuration is implemented in CoderHttpMesageConverter.

application/json
++++++++++++++++
JSON format is a standard for Rest Api. For the conversion from JSON to Object and vice-versa will be used **org.onap.policy.common.utils.coder.StandardCoder**.

application/yaml
++++++++++++++++
YAML format is a standard for Control Loop Type Definition. For the conversion from YAML to Object and vice-versa will be used **org.onap.policy.common.utils.coder.StandardYamlCoder**.

text/plain
++++++++++
Text format is used by Prometheus. For the conversion from Object to String  will be used **StringHttpMessageConverter**.
