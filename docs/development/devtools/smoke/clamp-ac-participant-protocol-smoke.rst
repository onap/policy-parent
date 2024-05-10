.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. _clamp-participant-protocol-smoke-tests:

CLAMP Participant Protocol Smoke Tests
--------------------------------------

1. Introduction
***************

The CLAMP Automation Composition Participant protocol is an asynchronous protocol that is used by the CLAMP runtime
to coordinate life cycle management of Automation Composition instances.
This document will serve as a guide to do smoke tests on the different use cases that are involved when
working with the Participant protocol and outline how they operate.
It will also show a developer how to set up their environment for carrying out smoke tests on the participants.

2. Setup Guide
**************

This section will show the developer how to set up their environment to start testing participants with some
instructions on how to carry out the tests. There are several prerequisites. Note that this guide is written by a
Linux user - although the majority of the steps show will be exactly the same in Windows or other systems.

2.1 Prerequisites
=================

- Java 17
- Docker
- Maven 3.9
- Git
- Refer to this guide for basic environment setup `Setting up dev environment <https://wiki.onap.org/display/DW/Setting+Up+Your+Development+Environment>`_

2.2 Setting up the components
=============================

- Automation Composition runtime component docker image is started and running.
- Participant docker images policy-clamp-ac-pf-ppnt, policy-clamp-ac-http-ppnt, policy-clamp-ac-k8s-ppnt are started and running.
- Kafka/Zookeeper for communication between components.
- mariadb docker container for policy and clampacm database.
- policy-api for communication between policy participant and policy-framework

In this setup guide, we will be setting up all the components technically required for a working convenient
dev environment. We will not be setting up all the participants - we will setup only the policy participant as an
example.

2.2.1 MariaDB Setup
===================

We will be using Docker to run our mariadb instance. It will have a total of two databases running in it.

- clampacm: the policy-clamp-runtime-acm db
- policyadmin: the policy-api db

3. Running Tests of protocol dialogues
**************************************

loop type definitions and common property values for participant types.

In this section, we will run through the functionalities mentioned at the start of this document is section 1. Each functionality will be tested and we will confirm that they were carried out successfully. There is a tosca service template that can be used for this test
:download:`Tosca Service Template <tosca/tosca-for-gui-smoke-tests.yaml>`

3.1 Participant Registration
============================

Action: Bring up the participant

Test result:

- Observe PARTICIPANT_REGISTER going from participant to runtime
- Observe PARTICIPANT_REGISTER_ACK going from runtime to participant
- Observe PARTICIPANT_PRIME going from runtime to participant

3.2 Participant Deregistration
==============================

Action: Bring down the participant
Test result:

- Observe PARTICIPANT_DEREGISTER going from participant to runtime
- Observe PARTICIPANT_DEREGISTER_ACK going from runtime to participant

3.3 Participant Priming
=======================

When an automation composition definition is primed, the portion of the Automation Composition Type Definition and Common Property values for the participants
of each participant type mentioned in the Automation Composition Definition are sent to the participants.
Action: Invoke a REST API to prime acm type definitions and set values of common properties

Test result:

- Observe PARTICIPANT_PRIME going from runtime to participant with acm type definitions and common property values for participant types
- Observe that the acm type definitions and common property values for participant types are stored on ParticipantHandler
- Observe PARTICIPANT_PRIME_ACK going from runtime to participant

3.4 Participant DePriming
=========================

When an automation composition is de-primed, the portion of the Automation Composition Type Definition and Common Property values for the participants
of each participant type mentioned in the Automation Composition Definition are deleted on participants.
Action: Invoke a REST API to deprime acm type definitions

Test result:

- If acm instances exist in runtime database, return a response for the REST API with error response saying "Cannot decommission acm type definition"
- If no acm instances exist in runtime database, Observe PARTICIPANT_PRIME going from runtime to participant with definitions as null
- Observe that the acm type definitions and common property values for participant types are removed on ParticipantHandler
- Observe PARTICIPANT_PRIME_ACK going from runtime to participant

3.5 Automation Composition Instance
===================================

Automation Composition Instance handles creation, change, and deletion of automation composition instances on participants.
Action: Trigger acm instantiation from GUI

Test result:

- Observe that the acm instances and respective property values for participant are stored on AutomationCompositionHandler
- Observe that the acm deploy state is UNDEPLOYED

3.6 Automation Composition deploy state change to DEPLOYED
==========================================================

Automation Composition Update handles creation, change, and deletion of automation compositions on participants.
Action: Change deploy state of the acm to DEPLOYED

Test result:

- Observe AUTOMATION_COMPOSITION_DEPLOY going from runtime to participant
- Observe that the AutomationCompositionElements deploy state is DEPLOYED
- Observe that the acm deploy state is DEPLOYED
- Observe AUTOMATION_COMPOSITION_DEPLOY_ACK going from participant to runtime

3.7 Automation Composition lock state change to UNLOCK
======================================================

Action: Change lock state of the acm to UNLOCK

Test result:

- Observe AUTOMATION_COMPOSITION_STATE_CHANGE going from runtime to participant
- Observe that the AutomationCompositionElements lock state is UNLOCK
- Observe that the acm state is UNLOCK
- Observe AUTOMATION_COMPOSITION_STATE_CHANGE_ACK going from participant to runtime

3.8 Automation Composition lock state change to LOCK
====================================================

Action: Change lock state of the acm to LOCK

Test result:

- Observe AUTOMATION_COMPOSITION_STATE_CHANGE going from runtime to participant
- Observe that the AutomationCompositionElements lock state is LOCK
- Observe that the acm lock state is LOCK
- Observe AUTOMATION_COMPOSITION_STATE_CHANGE_ACK going from participant to runtime

3.9 Automation Composition deploy state change to UNDEPLOYED
============================================================

Action: Change deploy state of the acm to UNDEPLOYED

Test result:

- Observe AUTOMATION_COMPOSITION_STATE_CHANGE going from runtime to participant
- Observe that the AutomationCompositionElements deploy state is UNDEPLOYED
- Observe that the acm deploy state is UNDEPLOYED
- Observe that the AutomationCompositionElements undeploy the instances from respective frameworks
- Observe that the automation composition instances are removed from participants
- Observe AUTOMATION_COMPOSITION_STATE_CHANGE_ACK going from participant to runtime

3.10 Automation Composition monitoring and reporting
====================================================

This dialogue is used as a heartbeat mechanism for participants, to monitor the status of Automation Composition Elements, and to gather statistics on automation compositions. The ParticipantStatus message is sent periodically by each participant. The reporting interval for sending the message is configurable
Action: Bring up participant

Test result:

- Observe that PARTICIPANT_STATUS message is sent from participants to runtime in a regular interval
- Trigger a PARTICIPANT_STATUS_REQ from runtime and observe a PARTICIPANT_STATUS message with tosca definitions of automation composition type definitions sent
  from all the participants to runtime

This concluded the required smoke tests

