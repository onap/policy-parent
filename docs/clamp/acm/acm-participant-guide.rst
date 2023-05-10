.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (c) Nordix Foundation.  All rights reserved.

.. _acm-participant-guide-label:

Participant developer guide
###########################

.. contents::
    :depth: 4

The ACM runtime delegates the user requests to the participants for performing the actual operations.
Hence the participant module in ACM is implemented adhering to a list of ACM protocols along with their own functional logic.
It works in a contract with the Participant Intermediary module for communicating with ACM-R.
This guide explains the design considerations for a new participant implementation in ACM.

Please refer the following section for a detailed understanding of Inbound and outbound messages a participant interacts with.

.. toctree::
   :maxdepth: 2

   design-impl/participants/participants

Design considerations for a participant
---------------------------------------

In ONAP, the ACM-runtime and participant modules are implemented in Java spring boot. The participant Intermediary module
which is added as a maven dependency to the participants has the default implementations available for listening the kafka
events coming in from the ACM-runtime, process them and delegate them to the appropriate handler class. Similarly the
Intermediary module also has the publisher class implementations for publishing events back from the participants to the ACM-runtime.

Hence the new participants has to have this Participant Intermediary module as a dependency and should implement the following
interfaces from the Participant Intermediary. It should also be provided with the following mandatory properties in order to make the participant
work in synchronisation with ACM-runtime.

The participant application should be provided with the following Intermediary parameter values in the application properties
and the same is configured for the 'ParticipantIntermediaryParameters' object in the code.

1. participantId - A unique participant UUID that is used by the runtime to identify the participant.
2. ReportingTimeIntervalMs - Time inertval the participant should report the status/heartbeat to the runtime.
3. clampAutomationCompositionTopics - This property takes in the kafka topic names and servers for the intermediary module to use.
   These values should be provided for both source and sink configs. The following example shows the topic parameters set for using DMaap.

.. code-block:: bash

    clampAutomationCompositionTopics:
          topicSources:
            -
              topic: POLICY-ACRUNTIME-PARTICIPANT
              servers:
                - ${topicServer:localhost}
              topicCommInfrastructure: dmaap
              fetchTimeout: 15000
          topicSinks:
            -
              topic: POLICY-ACRUNTIME-PARTICIPANT
              servers:
                - ${topicServer:localhost}
              topicCommInfrastructure: dmaap

4. participantSupportedElementTypes - This property takes a list of typeName and typeVersion fields to define the types of AC elements the participant deals with.
   These are user defined name and version and the same should be defined for the AC elements that are included in the TOSCA based AC definitions.

.. code-block:: bash

    participantSupportedElementTypes:
      -
        typeName: org.onap.policy.clamp.acm.PolicyAutomationCompositionElement
        typeVersion: 1.0.0

Interfaces to Implement
-----------------------
AutomationCompositionElementListener:
  Every participant should implement a handler class that implements the AutomationCompositionElementListener interface
  from the Participant Intermediary. The intermediary listener class listens for the incoming events from the ACM-runtime
  and invoke the handler class implementations for various operations. This class implements the methods for deploying,
  undeploying, locking, unlocking , getting UseState, getting OperationalState requests that are coming from the ACM-runtime.
  The methods are as follows.

.. code-block:: bash

  1. void undeploy(UUID automationCompositionId, UUID automationCompositionElementId) throws PfModelException;
  2. void deploy(UUID automationCompositionId, AcElementDeploy element, Map<String, Object> properties) throws PfModelException;
  3. default void lock(UUID automationCompositionId, UUID automationCompositionElementId) throws PfModelException;
  4. default void unlock(UUID automationCompositionId, UUID automationCompositionElementId) throws PfModelException;

These method from the interface are implemented independently as per the user requirement. These methods after handling the
appropriate requests should also invoke the intermediary's publisher apis to notify the ACM-runtime with the acknowledgement events.

APIs to invoke
--------------
ParticipantIntermediaryApi:
  The participant intermediary api has the following methods that can be invoked from the participant for the following purposes.
  1. The requested operations are completed in the handler class and the ACM-runtime needs to be notified.
  2. To register the participant with the ACM-runtime during the startup.

  The methods are as follows:

  This following method is invoked to register the handler class that is implemented specific to the participant.

.. code-block:: bash

  void registerAutomationCompositionElementListener(AutomationCompositionElementListener automationCompositionElementListener);

This following method is invoked to update the AC element state after each operation is completed in the participant.

.. code-block:: bash

  void updateAutomationCompositionElementState(UUID automationCompositionId, UUID id, DeployState newState,LockState lockState);


In ONAP, the following participants are already implemented in java spring boot for various requirements. The maven modules
can be referred here

  `HTTP participant <https://github.com/onap/policy-clamp/tree/master/participant/participant-impl/participant-impl-http>`_.
  `Kubernetes participant <https://github.com/onap/policy-clamp/tree/master/participant/participant-impl/participant-impl-kubernetes>`_.
  `Policy participant <https://github.com/onap/policy-clamp/tree/master/participant/participant-impl/participant-impl-policy>`_.
  `A1PMS participant <https://github.com/onap/policy-clamp/tree/master/participant/participant-impl/participant-impl-a1pms>`_.
  `Kserve participant <https://github.com/onap/policy-clamp/tree/master/participant/participant-impl/participant-impl-kserve>`_.






