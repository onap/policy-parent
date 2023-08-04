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

Hence the new participants has to have this Participant Intermediary module as a dependency and should:

* Configure SpringBoot to scan the components located into the package "org.onap.policy.clamp.acm.participant.intermediary".
* Implement the following interfaces from the Participant Intermediary.
* Provide the following mandatory properties in order to make the participant work in synchronisation with ACM-runtime.

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
  undeploying, locking, unlocking , deleting, updating, priming, depriming requests that are coming from the ACM-runtime.
  The methods are as follows.

.. code-block:: java

  1. void undeploy(UUID automationCompositionId, UUID automationCompositionElementId) throws PfModelException;
  2. void deploy(UUID automationCompositionId, AcElementDeploy element, Map<String, Object> inProperties) throws PfModelException;
  3. void lock(UUID automationCompositionId, UUID automationCompositionElementId) throws PfModelException;
  4. void unlock(UUID automationCompositionId, UUID automationCompositionElementId) throws PfModelException;
  5. void delete(UUID automationCompositionId, UUID automationCompositionElementId) throws PfModelException;
  6. void update(UUID automationCompositionId, AcElementDeploy element, Map<String, Object> inProperties) throws PfModelException;
  7. void prime(UUID compositionId, List<AutomationCompositionElementDefinition> elementDefinitionList) throws PfModelException;
  8. void deprime(UUID compositionId) throws PfModelException;
  9. void handleRestartComposition(UUID compositionId, List<AutomationCompositionElementDefinition> elementDefinitionList, AcTypeState state) throws PfModelException;
  10. void handleRestartInstance(UUID automationCompositionId, AcElementDeploy element, Map<String, Object> properties, DeployState deployState, LockState lockState) throws PfModelException;

These method from the interface are implemented independently as per the user requirement. These methods after handling the
appropriate requests should also invoke the intermediary's publisher apis to notify the ACM-runtime with the acknowledgement events.

ParticipantParameters:
  Every participant should implement a properties class that contains the values of all Intermediary parameter properties.
  This class implements the method getIntermediaryParameters that returns 'ParticipantIntermediaryParameters' object. The method is as follows.

.. code-block:: java

  ParticipantIntermediaryParameters getIntermediaryParameters()


APIs to invoke
--------------
ParticipantIntermediaryApi:
  The participant intermediary api has the following methods that can be invoked from the participant for the following purposes.

  #. The requested operations are completed in the handler class and the ACM-runtime needs to be notified.
  #. Collect all instances data.
  #. Send out Properties to ACM-runtime.

  The methods are as follows:

This following method is invoked to update the AC element state after each operation is completed in the participant.

.. code-block:: java

  1.  void updateAutomationCompositionElementState(UUID automationCompositionId, UUID elementId, DeployState deployState, LockState lockState, StateChangeResult stateChangeResult, String message);
  2.  Map<UUID, AutomationComposition> getAutomationCompositions();
  3.  AutomationComposition getAutomationComposition(UUID automationCompositionId);
  4.  AutomationCompositionElement getAutomationCompositionElement(UUID automationCompositionId, UUID elementId);
  5.  Map<UUID, Map<ToscaConceptIdentifier, AutomationCompositionElementDefinition>> getAcElementsDefinitions();
  6.  Map<ToscaConceptIdentifier, AutomationCompositionElementDefinition> getAcElementsDefinitions(UUID compositionId);
  7.  AutomationCompositionElementDefinition getAcElementDefinition(UUID compositionId, ToscaConceptIdentifier elementId);
  8.  void sendAcDefinitionInfo(UUID compositionId, ToscaConceptIdentifier elementId, Map<String, Object> outProperties);
  9.  void updateCompositionState(UUID compositionId, AcTypeState state, StateChangeResult stateChangeResult, String message);
  10.  void sendAcElementInfo(UUID automationCompositionId, UUID elementId, String useState, String operationalState, Map<String, Object> outProperties);

In/Out composition Properties
-----------------------------
  The 'Common Properties' could be created or updated by ACM-runtime. Participants will receive that Properties during priming events.

  The 'Out Properties' could be created or updated by participants. ACM-runtime will receive that Properties during ParticipantStatus event.
  The participant can trigger this event using the method sendAcDefinitionInfo.

  Is allowed to the participant to read all In/Out Properties of all compositions handled by the participant using the method getAcElementsDefinitions.
  The following code is an example how to update the property 'myProperty' and send to ACM-runtime:

.. code-block:: java

  var acElement = intermediaryApi.getAcElementDefinition(compositionId, elementId);
  var outProperties = acElement.getOutProperties();
  outProperties.put("myProperty", myProperty);
  intermediaryApi.sendAcDefinitionInfo(compositionId, elementId, outProperties);

In/Out instance Properties
--------------------------
  The 'In Properties' could be created or updated by ACM-runtime. Participants will receive that Properties during deploy and update events.

  The 'Out Properties' could be created or updated by participants. ACM-runtime will receive that Properties during ParticipantStatus event.
  The participant can trigger this event using the method sendAcElementInfo.
  The 'useState' and 'operationalState' can be used as well.

  Is allowed to the participant to read all In/Out Properties and state of all instances handled by the participant using the method getAutomationCompositions.
  The following code is an example how to update the property 'myProperty' and send to ACM-runtime:

.. code-block:: java

  var acElement = intermediaryApi.getAutomationCompositionElement(automationCompositionId, elementId);
  var outProperties = acElement.getOutProperties();
  outProperties.put("myProperty", myProperty);
  intermediaryApi.sendAcElementInfo(automationCompositionId, elementId, acElement.getUseState(), acElement.getOperationalState(), outProperties);

Restart scenario
----------------
  Restart methods handle the scenario when participant shut down and restart.
  The method handleRestartComposition will be called for each composition and will be present the 'state' at the time the participant shut down.
  The method handleRestartInstance will be called for each instance element and will be present the 'deployState' and the 'lockState' at the time the participant shut down.

In ONAP, the following participants are already implemented in java spring boot for various requirements. The maven modules
can be referred here:

  * `HTTP participant <https://github.com/onap/policy-clamp/tree/master/participant/participant-impl/participant-impl-http>`_.
  * `Kubernetes participant <https://github.com/onap/policy-clamp/tree/master/participant/participant-impl/participant-impl-kubernetes>`_.
  * `Policy participant <https://github.com/onap/policy-clamp/tree/master/participant/participant-impl/participant-impl-policy>`_.
  * `A1PMS participant <https://github.com/onap/policy-clamp/tree/master/participant/participant-impl/participant-impl-a1pms>`_.
  * `Kserve participant <https://github.com/onap/policy-clamp/tree/master/participant/participant-impl/participant-impl-kserve>`_.

Example of Implementation
-------------------------

This following code is an example of My First Participant:
  * Application
  * Parameters
  * Handler

The Application class is configured to add the "org.onap.policy.clamp.acm.participant.intermediary" package in SpringBoot component scanning.

.. code-block:: java

  @SpringBootApplication
  @ComponentScan({
    "org.onap.policy.clamp.acm.participant.myfirstparticipant",
    "org.onap.policy.clamp.acm.participant.intermediary"
  })
  @ConfigurationPropertiesScan("org.onap.policy.clamp.acm.participant.myfirstparticipant.parameters")
  public class MyFirstParticipantApplication {

    public static void main(String[] args) {
      SpringApplication.run(Application.class, args);
    }
  }

The Participant Parameters class implements the mandatory interface ParticipantParameters.
It could contains additional parameters.

.. code-block:: java

  @Validated
  @Getter
  @Setter
  @ConfigurationProperties(prefix = "participant")
  public class ParticipantSimParameters implements ParticipantParameters {

    @NotBlank
    private String myparameter;

    @NotNull
    @Valid
    private ParticipantIntermediaryParameters intermediaryParameters;
  }

The following example shows the topic parameters and the additional 'myparameter'.

.. code-block:: bash

  participant:
    myparameter: my parameter
    intermediaryParameters:
      reportingTimeIntervalMs: 120000
      description: Participant Description
      participantId: 101c62b3-8918-41b9-a747-d21eb79c6c90
      clampAutomationCompositionTopics:
        topicSources:
          - topic: POLICY-ACRUNTIME-PARTICIPANT
            servers:
              - ${topicServer:localhost}
            topicCommInfrastructure: dmaap
            fetchTimeout: 15000
        topicSinks:
          - topic: POLICY-ACRUNTIME-PARTICIPANT
            servers:
              - ${topicServer:localhost}
            topicCommInfrastructure: dmaap
      participantSupportedElementTypes:
        -
          typeName: org.onap.policy.clamp.acm.MyFirstAutomationCompositionElement
          typeVersion: 1.0.0


The following example shows the Handler implementation and how could be the implemented the mandatory notifications.

.. code-block:: java

  @Component
  @RequiredArgsConstructor
  public class MyFirstAcElementHandler implements AutomationCompositionElementListener {

    private final ParticipantIntermediaryApi intermediaryApi;

    @Override
    public void deploy(UUID automationCompositionId, AcElementDeploy element, Map<String, Object> properties)
            throws PfModelException {

        // TODO deploy process

        if (isDeploySuccess()) {
            intermediaryApi.updateAutomationCompositionElementState(automationCompositionId, element.getId(),
                    DeployState.DEPLOYED, null, StateChangeResult.NO_ERROR, "Deployed");
        } else {
            intermediaryApi.updateAutomationCompositionElementState(automationCompositionId, element.getId(),
                    DeployState.UNDEPLOYED, null, StateChangeResult.FAILED, "Deploy failed!");
        }
    }

    @Override
    public void undeploy(UUID automationCompositionId, UUID automationCompositionElementId) throws PfModelException {
        LOGGER.debug("undeploy call");

        // TODO undeploy process

        if (isUndeploySuccess()) {
            intermediaryApi.updateAutomationCompositionElementState(automationCompositionId,
                    automationCompositionElementId, DeployState.UNDEPLOYED, null, StateChangeResult.NO_ERROR,
                    "Undeployed");
        } else {
            intermediaryApi.updateAutomationCompositionElementState(automationCompositionId,
                    automationCompositionElementId, DeployState.DEPLOYED, null, StateChangeResult.FAILED,
                    "Undeploy failed!");
        }
    }

    @Override
    public void lock(UUID automationCompositionId, UUID automationCompositionElementId) throws PfModelException {

        // TODO lock process

        if (isLockSuccess()) {
            intermediaryApi.updateAutomationCompositionElementState(automationCompositionId,
                    automationCompositionElementId, null, LockState.LOCKED, StateChangeResult.NO_ERROR, "Locked");
        } else {
            intermediaryApi.updateAutomationCompositionElementState(automationCompositionId,
                    automationCompositionElementId, null, LockState.UNLOCKED, StateChangeResult.FAILED, "Lock failed!");
        }
    }

    @Override
    public void unlock(UUID automationCompositionId, UUID automationCompositionElementId) throws PfModelException {

        // TODO unlock process

        if (isUnlockSuccess()) {
            intermediaryApi.updateAutomationCompositionElementState(automationCompositionId,
                    automationCompositionElementId, null, LockState.UNLOCKED, StateChangeResult.NO_ERROR, "Unlocked");
        } else {
            intermediaryApi.updateAutomationCompositionElementState(automationCompositionId,
                    automationCompositionElementId, null, LockState.LOCKED, StateChangeResult.FAILED, "Unlock failed!");
        }
    }

    @Override
    public void delete(UUID automationCompositionId, UUID automationCompositionElementId) throws PfModelException {

        // TODO delete process

        if (isDeleteSuccess()) {
            intermediaryApi.updateAutomationCompositionElementState(automationCompositionId,
                    automationCompositionElementId, DeployState.DELETED, null, StateChangeResult.NO_ERROR, "Deleted");
        } else {
            intermediaryApi.updateAutomationCompositionElementState(automationCompositionId,
                    automationCompositionElementId, DeployState.UNDEPLOYED, null, StateChangeResult.FAILED,
                    "Delete failed!");
        }
    }

    @Override
    public void update(UUID automationCompositionId, AcElementDeploy element, Map<String, Object> properties)
            throws PfModelException {

        // TODO update process

        if (isUpdateSuccess()) {
            intermediaryApi.updateAutomationCompositionElementState(automationCompositionId, element.getId(),
                    DeployState.DEPLOYED, null, StateChangeResult.NO_ERROR, "Updated");
        } else {
            intermediaryApi.updateAutomationCompositionElementState(automationCompositionId, element.getId(),
                    DeployState.DEPLOYED, null, StateChangeResult.FAILED, "Update failed!");
        }
    }

    @Override
    public void prime(UUID compositionId, List<AutomationCompositionElementDefinition> elementDefinitionList)
            throws PfModelException {

        // TODO prime process

        if (isPrimeSuccess()) {
            intermediaryApi.updateCompositionState(compositionId, AcTypeState.PRIMED, StateChangeResult.NO_ERROR,
                    "Primed");
        } else {
            intermediaryApi.updateCompositionState(compositionId, AcTypeState.COMMISSIONED, StateChangeResult.FAILED,
                    "Prime failed!");
        }
    }

    @Override
    public void deprime(UUID compositionId) throws PfModelException {

        // TODO deprime process

        if (isDeprimeSuccess()) {
            intermediaryApi.updateCompositionState(compositionId, AcTypeState.COMMISSIONED, StateChangeResult.NO_ERROR,
                    "Deprimed");
        } else {
            intermediaryApi.updateCompositionState(compositionId, AcTypeState.PRIMED, StateChangeResult.FAILED,
                    "Deprime failed!");
        }
    }


    @Override
    public void handleRestartComposition(UUID compositionId,
            List<AutomationCompositionElementDefinition> elementDefinitionList, AcTypeState state)
            throws PfModelException {

        switch (state) {
            case PRIMING:
                prime(compositionId, elementDefinitionList);
                break;

            case DEPRIMING:
                // TODO restart process

                deprime(compositionId);
                break;

            default:
                // TODO restart process

                intermediaryApi.updateCompositionState(compositionId, state, StateChangeResult.NO_ERROR, "Restarted");
        }
    }

    @Override
    public void handleRestartInstance(UUID automationCompositionId, AcElementDeploy element,
            Map<String, Object> properties, DeployState deployState, LockState lockState) throws PfModelException {

         // TODO restart process

        if (DeployState.DEPLOYING.equals(deployState)) {
            deploy(automationCompositionId, element, properties);
            return;
        }
        if (DeployState.UNDEPLOYING.equals(deployState)) {
            undeploy(automationCompositionId, element.getId());
            return;
        }
        if (DeployState.UPDATING.equals(deployState)) {
            update(automationCompositionId, element, properties);
            return;
        }
        if (DeployState.DELETING.equals(deployState)) {
            delete(automationCompositionId, element.getId());
            return;
        }
        if (LockState.LOCKING.equals(lockState)) {
            lock(automationCompositionId, element.getId());
            return;
        }
        if (LockState.UNLOCKING.equals(lockState)) {
            unlock(automationCompositionId, element.getId());
            return;
        }
        intermediaryApi.updateAutomationCompositionElementState(automationCompositionId, element.getId(),
                deployState, lockState, StateChangeResult.NO_ERROR, "Restarted");
    }


