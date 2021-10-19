.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. _clamp-gui-controlloop-smoke-tests:
CLAMP Participant Protocol Smoke Tests
---------------------------
1. Introduction
***************
The CLAMP Control Loop Participant protocol is an asynchronous protocol that is used by the CLAMP runtime 
to coordinate life cycle management of Control Loop instances.
This document will serve as a guide to do smoke tests on the different usecases that are involved when 
working with the Participant protocol and outline how they operate. 
It will also show a developer how to set up their environment for carrying out smoke tests on the participants.

2. Setup Guide
**************
This section will show the developer how to set up their environment to start testing participants with some instruction on how to carry out the tests. There are a number of prerequisites. Note that this guide is written by a Linux user - although the majority of the steps show will be exactly the same in Windows or other systems.

2.1 Prerequisites
=================
- Java 11
- Docker
- Maven 3
- Git
- Refer to this guide for basic environment setup `Setting up dev environment <https://wiki.onap.org/display/DW/Setting+Up+Your+Development+Environment>`_

2.2 Setting up the components
=============================
- Controlloop runtime component docker image is started and running.
- Participant docker images policy-clamp-cl-pf-ppnt, policy-clamp-cl-http-ppnt, policy-clamp-cl-k8s-ppnt are started and running.
- Dmaap simulator for communication between components.
- mariadb docker container for policy and controlloop database.
- policy-api for communication between policy participant and policy-framework
In this setup guide, we will be setting up all the components technically required for a working convenient dev environment. We will not be setting up all of the participants - we will setup only the policy participant as an example.

2.2.1 MariaDB Setup
===================
We will be using Docker to run our mariadb instance. It will have a total of two databases running in it.
- controlloop: the runtime-controlloop db
- policyadmin: the policy-api db

3. Running Tests of protocol dialogues
**************************************
lloop type definitions and common property values for participant types
In this section, we will run through the functionalities mentioned at the start of this document is section 1. Each functionality will be tested and we will confirm that they were carried out successfully. There is a tosca service template that can be used for this test
:download:`Tosca Service Template <tosca/tosca-for-gui-smoke-tests.yaml>`

3.1 Participant Registration
============================
Action: Bring up the participant
Test result: 
- Observe PARTICIPANT_REGISTER going from participant to runtime
- Observe PARTICIPANT_REGISTER_ACK going from runtime to participant
- Observe PARTICIPANT_UPDATE going from runtime to participant

3.2 Participant Deregistration
==============================
Action: Bring down the participant
Test result: 
- Observe PARTICIPANT_DEREGISTER going from participant to runtime
- Observe PARTICIPANT_DEREGISTER_ACK going from runtime to participant

3.3 Participant Priming
=======================
When a control loop is primed, the portion of the Control Loop Type Definition and Common Property values for the participants 
of each participant type mentioned in the Control Loop Definition are sent to the participants.
Action: Invoke a REST API to prime controlloop type definitions and set values of common properties
Test result: 
- Observe PARTICIPANT_UPDATE going from runtime to participant with controlloop type definitions and common property values for participant types
- Observe that the controlloop type definitions and common property values for participant types are stored on ParticipantHandler
- Observe PARTICIPANT_UPDATE_ACK going from runtime to participant

3.4 Participant DePriming
=========================
When a control loop is de-primed, the portion of the Control Loop Type Definition and Common Property values for the participants
of each participant type mentioned in the Control Loop Definition are deleted on participants.
Action: Invoke a REST API to deprime controlloop type definitions
Test result: 
- If controlloop instances exist in runtime database, return a response for the REST API with error response saying "Cannot decommission controlloop type definition"
- If no controlloop instances exist in runtime database, Observe PARTICIPANT_UPDATE going from runtime to participant with definitions as null
- Observe that the controlloop type definitions and common property values for participant types are removed on ParticipantHandler
- Observe PARTICIPANT_UPDATE_ACK going from runtime to participant

3.5 Control Loop Update
=======================
Control Loop Update handles creation, change, and deletion of control loops on participants.
Action: Trigger controlloop instantiation from GUI
Test result: 
- Observe CONTROL_LOOP_UPDATE going from runtime to participant
- Observe that the controlloop type instances and respective property values for participant types are stored on ControlLoopHandler
- Observe that the controlloop state is UNINITIALISED
- Observe CONTROL_LOOP_UPDATE_ACK going from participant to runtime

3.6 Control Loop state change to PASSIVE
========================================
Control Loop Update handles creation, change, and deletion of control loops on participants.
Action: Change state of the controlloop to PASSIVE
Test result: 
- Observe CONTROL_LOOP_STATE_CHANGE going from runtime to participant
- Observe that the ControlLoopElements state is PASSIVE
- Observe that the controlloop state is PASSIVE
- Observe CONTROL_LOOP_STATE_CHANGE_ACK going from participant to runtime

3.7 Control Loop state change to RUNNING
========================================
Control Loop Update handles creation, change, and deletion of control loops on participants.
Action: Change state of the controlloop to RUNNING
Test result: 
- Observe CONTROL_LOOP_STATE_CHANGE going from runtime to participant
- Observe that the ControlLoopElements state is RUNNING
- Observe that the controlloop state is RUNNING
- Observe CONTROL_LOOP_STATE_CHANGE_ACK going from participant to runtime

3.8 Control Loop state change to PASSIVE
========================================
Control Loop Update handles creation, change, and deletion of control loops on participants.
Action: Change state of the controlloop to PASSIVE
Test result: 
- Observe CONTROL_LOOP_STATE_CHANGE going from runtime to participant
- Observe that the ControlLoopElements state is PASSIVE
- Observe that the controlloop state is PASSIVE
- Observe CONTROL_LOOP_STATE_CHANGE_ACK going from participant to runtime

3.9 Control Loop state change to UNINITIALISED
==============================================
Control Loop Update handles creation, change, and deletion of control loops on participants.
Action: Change state of the controlloop to UNINITIALISED
Test result: 
- Observe CONTROL_LOOP_STATE_CHANGE going from runtime to participant
- Observe that the ControlLoopElements state is UNINITIALISED
- Observe that the controlloop state is UNINITIALISED
- Observe that the ControlLoopElements undeploy the instances from respective frameworks
- Observe that the control loop instances are removed from participants
- Observe CONTROL_LOOP_STATE_CHANGE_ACK going from participant to runtime

3.10 Control Loop monitoring and reporting
==========================================
This dialogue is used as a heartbeat mechanism for participants, to monitor the status of Control Loop Elements, and to gather statistics on control loops. The ParticipantStatus message is sent periodically by each participant. The reporting interval for sending the message is configurable
Action: Bring up participant
Test result:
- Observe that PARTICIPANT_STATUS message is sent from participants to runtime in a regular interval
- Trigger a PARTICIPANT_STATUS_REQ from runtime and observe a PARTICIPANT_STATUS message with tosca definitions of control loop type definitions sent
from all the participants to runtime

This concluded the required smoke tests

