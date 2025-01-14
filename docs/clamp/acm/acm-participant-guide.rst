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
   These values should be provided for both source and sink configs.
   (**Note**: In order to avoid a connection to Kafka when Unit Tests are running, set topicCommInfrastructure: NOOP in properties file for tests).
   The following example shows the topic parameters set for using Kafka.

.. code-block:: bash

  intermediaryParameters:
    topics:
      operationTopic: policy-acruntime-participant
      syncTopic: acm-ppnt-sync
    clampAutomationCompositionTopics:
          topicSources:
            -
              topic: ${participant.intermediaryParameters.topics.operationTopic}
              servers:
                - ${topicServer:localhost}:9092
              topicCommInfrastructure: kafka
              fetchTimeout: 15000
              additionalProps:
                group.id: policy-clamp-ac-name
            -
              topic: ${participant.intermediaryParameters.topics.syncTopic}
              servers:
                - ${topicServer:localhost}:9092
              topicCommInfrastructure: kafka
              fetchTimeout: 15000
          topicSinks:
            -
              topic: ${participant.intermediaryParameters.topics.operationTopic}
              servers:
                - ${topicServer:localhost}:9092
              topicCommInfrastructure: kafka

4. participantSupportedElementTypes - This property takes a list of typeName and typeVersion fields to define the types of AC elements the participant deals with.
   These are user defined name and version and the same should be defined for the AC elements that are included in the TOSCA based AC definitions.

.. code-block:: bash

    participantSupportedElementTypes:
      -
        typeName: org.onap.policy.clamp.acm.PolicyAutomationCompositionElement
        typeVersion: 1.0.0

Kafka Healthcheck
-----------------

Optionally is possible to add a Kafka Healthcheck by configuration. That feature is responsible of starting the Kafka configuration.
If Kafka is not up and Kafka Healthcheck is not enable, Kafka messages configuration will fail.
This feature check Kafka by an admin connection and if Kafka is up, it will start the Kafka messages configuration,
but if Kafka is not up yet, it will retry this check later.

Kafka Healthcheck supports the topics check and it could be enabled by configuration (using topicValidation parameter).
Usually topics are getting created when first message happen, so in that scenario, topicValidation should be set as false.
In different environment, the two topics will be created manually by a script with specific permissions. So Kafka could be up,
but the Kafka messages configuration could be fail because the two topics are not get created yet.
So in that scenario, topicValidation should be set as true, and if topics are not created yet, Healthcheck will retry that check later.

For backward compatibility if Kafka Healthcheck is not configured, it will be disabled and Kafka messages configuration will start as normal.

The following example shows the Kafka Healthcheck configuration.

.. code-block:: bash

  intermediaryParameters:
    topicValidation: true
    clampAdminTopics:
      servers:
        - ${topicServer:kafka:9092}
      topicCommInfrastructure: kafka
      fetchTimeout: 15000
    topics:
      operationTopic: policy-acruntime-participant
      syncTopic: acm-ppnt-sync
    ........


Interfaces to Implement
-----------------------
AutomationCompositionElementListener:
  Every participant should implement a handler class that implements the AutomationCompositionElementListener interface
  from the Participant Intermediary. The intermediary listener class listens for the incoming events from the ACM-runtime
  and invoke the handler class implementations for various operations. This class implements the methods for deploying,
  undeploying, locking, unlocking, deleting, updating, preparing, reviewing, migrating, migrationPrechecking, priming, depriming requests that are coming from the ACM-runtime.
  The methods are as follows.

.. code-block:: java

  1. void deploy(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;
  2. void undeploy(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;
  3. void lock(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;
  4. void unlock(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;
  5. void delete(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;
  6. void update(CompositionElementDto compositionElement, InstanceElementDto instanceElement, InstanceElementDto instanceElementUpdated) throws PfModelException;
  7. void prime(CompositionDto composition) throws PfModelException;
  8. void deprime(CompositionDto composition) throws PfModelException;
  9. void migrate(CompositionElementDto compositionElement, CompositionElementDto compositionElementTarget, InstanceElementDto instanceElement, InstanceElementDto instanceElementMigrate, int stage) throws PfModelException;
  10. void migratePrecheck(CompositionElementDto compositionElement, CompositionElementDto compositionElementTarget, InstanceElementDto instanceElement, InstanceElementDto instanceElementMigrate) throws PfModelException;
  11. void review(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;
  12. void prepare(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;

These method from the interface are implemented independently as per the user requirement. These methods after handling the
appropriate requests should also invoke the intermediary's publisher apis to notify the ACM-runtime with the acknowledgement events.

ParticipantParameters:
  Every participant should implement a properties class that contains the values of all Intermediary parameter properties.
  This class implements the method getIntermediaryParameters that returns 'ParticipantIntermediaryParameters' object. The method is as follows.

.. code-block:: java

  ParticipantIntermediaryParameters getIntermediaryParameters()


Abstract class AcElementListenerV3
----------------------------------
This abstract class is introduced to help to maintain the java backward compatibility with AutomationCompositionElementListener from new releases.
Any new functionality in the future will be wrapped by this class.

**Note**: this class needs intermediaryApi and it should be passed by constructor. It is declared as protected and can be used.
Default implementation are supported for the methods: lock, unlock, update, migrate, delete, prime, deprime, migratePrecheck, review and prepare.


Methods: deploy, undeploy, lock, unlock, delete, review and prepare
  compositionElement:
    ======================  =======================================
     **field**                       **description**
    ======================  =======================================
     compositionId           composition definition Id
     elementDefinitionId     composition definition element Id
     inProperties            composition definition in-properties
     outProperties           composition definition out-properties
    ======================  =======================================
  instanceElement:
    ==============================  ===========================
     **field**                       **description**
    ==============================  ===========================
     instanceId                      instance id
     elementId                       instance element id
     toscaServiceTemplateFragment    policies and policy types
     inProperties                    instance in-properties
      outProperties                  instance out-properties
    ==============================  ===========================

Method: update
  compositionElement:
    ======================  =======================================
     **field**                       **description**
    ======================  =======================================
     compositionId           composition definition Id
     elementDefinitionId     composition definition element Id
     inProperties            composition definition in-properties
     outProperties           composition definition out-properties
    ======================  =======================================
  instanceElement:
    ==============================  ================================================
     **field**                       **description**
    ==============================  ================================================
     instanceId                      instance id
     elementId                       instance element id
     toscaServiceTemplateFragment
     inProperties                    instance in-properties **(before the update)**
      outProperties                  instance out-properties
    ==============================  ================================================
  instanceElementUpdated:
    ==============================  ======================================
     **field**                       **description**
    ==============================  ======================================
     instanceId                      instance id
     elementId                       instance element id
     toscaServiceTemplateFragment
     inProperties                    instance in-properties **(updated)**
     outProperties                   instance out-properties
    ==============================  ======================================

Methods: prime, deprime
  composition:
    ======================  ===================================================================
     **field**                       **description**
    ======================  ===================================================================
     compositionId           composition definition Id
     inProperties            composition definition in-properties for each definition element
     outProperties           composition definition out-properties for each definition element
    ======================  ===================================================================

Method: migratePrecheck
  compositionElement:
    ======================  =====================================================
     **field**                       **description**
    ======================  =====================================================
     compositionId           composition definition Id
     elementDefinitionId     composition definition element Id
     inProperties            composition definition in-properties
     outProperties           composition definition out-properties
     state                   element state: PRESENT, NOT_PRESENT, REMOVED, NEW
    ======================  =====================================================
  compositionElementTarget:
    ======================  =====================================================
     **field**                       **description**
    ======================  =====================================================
     compositionId           composition definition target Id
     elementDefinitionId     composition definition target element Id
     inProperties            composition definition target in-properties
     outProperties           composition definition target out-properties
     state                   element state: PRESENT, NOT_PRESENT, REMOVED, NEW
    ======================  =====================================================
  instanceElement:
    ==============================  ===================================================
     **field**                       **description**
    ==============================  ===================================================
     instanceId                      instance id
     elementId                       instance element id
     toscaServiceTemplateFragment
     inProperties                    instance in-properties **(before the migration)**
     outProperties                   instance out-properties
     state                           element state: PRESENT, NOT_PRESENT, REMOVED, NEW
    ==============================  ===================================================
  instanceElementMigrate:
    ==============================  ====================================================
     **field**                       **description**
    ==============================  ====================================================
     instanceId                      instance id
     elementId                       instance element id
     toscaServiceTemplateFragment
     inProperties                    instance in-properties **(updated)**
     outProperties                   instance out-properties
     state                           element state: PRESENT, NOT_PRESENT, REMOVED, NEW
    ==============================  ====================================================

Method: migrate
  compositionElement:
    ======================  =====================================================
     **field**                       **description**
    ======================  =====================================================
     compositionId           composition definition Id
     elementDefinitionId     composition definition element Id
     inProperties            composition definition in-properties
     outProperties           composition definition out-properties
     state                   element state: PRESENT, NOT_PRESENT, REMOVED, NEW
    ======================  =====================================================
  compositionElementTarget:
    ======================  =====================================================
     **field**                       **description**
    ======================  =====================================================
     compositionId           composition definition target Id
     elementDefinitionId     composition definition target element Id
     inProperties            composition definition target in-properties
     outProperties           composition definition target out-properties
     state                   element state: PRESENT, NOT_PRESENT, REMOVED, NEW
    ======================  =====================================================
  instanceElement:
    ==============================  ===================================================
     **field**                       **description**
    ==============================  ===================================================
     instanceId                      instance id
     elementId                       instance element id
     toscaServiceTemplateFragment
     inProperties                    instance in-properties **(before the migration)**
     outProperties                   instance out-properties
     state                           element state: PRESENT, NOT_PRESENT, REMOVED, NEW
    ==============================  ===================================================
  instanceElementMigrate:
    ==============================  ====================================================
     **field**                       **description**
    ==============================  ====================================================
     instanceId                      instance id
     elementId                       instance element id
     toscaServiceTemplateFragment
     inProperties                    instance in-properties **(updated)**
     outProperties                   instance out-properties
     state                           element state: PRESENT, NOT_PRESENT, REMOVED, NEW
    ==============================  ====================================================
  stage:
    the stage of the migration that the participant has to execute


Abstract class AcElementListenerV2
----------------------------------
This abstract class is introduced to help to maintain temporarily the java backward compatibility with AutomationCompositionElementListener implemented in 8.0.0 version.
So developers can decide to align to new functionality later. Any new functionality in the future will be wrapped by this class.

The Abstract class AcElementListenerV2 supports the follow methods.

.. code-block:: java

  1. void deploy(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;
  2. void undeploy(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;
  3. void lock(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;
  4. void unlock(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;
  5. void delete(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;
  6. void update(CompositionElementDto compositionElement, InstanceElementDto instanceElement, InstanceElementDto instanceElementUpdated) throws PfModelException;
  7. void prime(CompositionDto composition) throws PfModelException;
  8. void deprime(CompositionDto composition) throws PfModelException;
  9. void migrate(CompositionElementDto compositionElement, CompositionElementDto compositionElementTarget, InstanceElementDto instanceElement, InstanceElementDto instanceElementMigrate) throws PfModelException;
  10. void migratePrecheck(CompositionElementDto compositionElement, CompositionElementDto compositionElementTarget, InstanceElementDto instanceElement, InstanceElementDto instanceElementMigrate) throws PfModelException;
  11. void review(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;
  12. void prepare(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException;

**Note**: this class needs intermediaryApi and it should be passed by constructor. It is declared as protected and can be used.
Default implementation are supported for the methods: lock, unlock, update, migrate, delete, prime, deprime, migratePrecheck, review and prepare.


Methods: deploy, undeploy, lock, unlock, delete, review and prepare
  compositionElement:
    ======================  =======================================
     **field**                       **description**
    ======================  =======================================
     compositionId           composition definition Id
     elementDefinitionId     composition definition element Id
     inProperties            composition definition in-properties
     outProperties           composition definition out-properties
    ======================  =======================================
  instanceElement:
    ==============================  ===========================
     **field**                       **description**
    ==============================  ===========================
     instanceId                      instance id
     elementId                       instance element id
     toscaServiceTemplateFragment    policies and policy types
     inProperties                    instance in-properties
      outProperties                  instance out-properties
    ==============================  ===========================

Method: update
  compositionElement:
    ======================  =======================================
     **field**                       **description**
    ======================  =======================================
     compositionId           composition definition Id
     elementDefinitionId     composition definition element Id
     inProperties            composition definition in-properties
     outProperties           composition definition out-properties
    ======================  =======================================
  instanceElement:
    ==============================  ================================================
     **field**                       **description**
    ==============================  ================================================
     instanceId                      instance id
     elementId                       instance element id
     toscaServiceTemplateFragment
     inProperties                    instance in-properties **(before the update)**
      outProperties                  instance out-properties
    ==============================  ================================================
  instanceElementUpdated:
    ==============================  ======================================
     **field**                       **description**
    ==============================  ======================================
     instanceId                      instance id
     elementId                       instance element id
     toscaServiceTemplateFragment
     inProperties                    instance in-properties **(updated)**
     outProperties                   instance out-properties
    ==============================  ======================================

Methods: prime, deprime
  composition:
    ======================  ===================================================================
     **field**                       **description**
    ======================  ===================================================================
     compositionId           composition definition Id
     inProperties            composition definition in-properties for each definition element
     outProperties           composition definition out-properties for each definition element
    ======================  ===================================================================

Method: migrate and migratePrecheck
  compositionElement:
    ======================  =======================================
     **field**                       **description**
    ======================  =======================================
     compositionId           composition definition Id
     elementDefinitionId     composition definition element Id
     inProperties            composition definition in-properties
     outProperties           composition definition out-properties
    ======================  =======================================
  compositionElementTarget:
    ======================  ==============================================
     **field**                       **description**
    ======================  ==============================================
     compositionId           composition definition target Id
     elementDefinitionId     composition definition target element Id
     inProperties            composition definition target in-properties
     outProperties           composition definition target out-properties
    ======================  ==============================================
  instanceElement:
    ==============================  ===================================================
     **field**                       **description**
    ==============================  ===================================================
     instanceId                      instance id
     elementId                       instance element id
     toscaServiceTemplateFragment
     inProperties                    instance in-properties **(before the migration)**
     outProperties                   instance out-properties
    ==============================  ===================================================
  instanceElementMigrate:
    ==============================  ======================================
     **field**                       **description**
    ==============================  ======================================
     instanceId                      instance id
     elementId                       instance element id
     toscaServiceTemplateFragment
     inProperties                    instance in-properties **(updated)**
     outProperties                   instance out-properties
    ==============================  ======================================


Abstract class AcElementListenerV1
----------------------------------
This abstract class is introduced to help to maintain temporarily the java backward compatibility with AutomationCompositionElementListener implemented in 7.1.0 version.
So developers can decide to align to new functionality later. Any new functionality in the future will be wrapped by this class.

The Abstract class AcElementListenerV1 supports the follow methods.

.. code-block:: java

  1. void undeploy(UUID instanceId, UUID elementId) throws PfModelException;
  2. void deploy(UUID instanceId, AcElementDeploy element, Map<String, Object> inProperties) throws PfModelException;
  3. void lock(UUID instanceId, UUID elementId) throws PfModelException;
  4. void unlock(UUID instanceId, UUID elementId) throws PfModelException;
  5. void delete(UUID instanceId, UUID elementId) throws PfModelException;
  6. void update(UUID instanceId, AcElementDeploy element, Map<String, Object> inProperties) throws PfModelException;
  7. void prime(UUID compositionId, List<AutomationCompositionElementDefinition> elementDefinitionList) throws PfModelException;
  8. void deprime(UUID compositionId) throws PfModelException;
  9. void migrate(UUID instanceId, AcElementDeploy element, UUID compositionTargetId, Map<String, Object> properties) throws PfModelException;

**Note**: this class needs intermediaryApi and it should be passed by constructor. It is declared as protected and can be used.
Default implementation are supported for the methods: lock, unlock, update, migrate, delete, prime, deprime, migratePrecheck, review and prepare.

Un example of AutomationCompositionElementHandler implemented in 7.1.0 version and how to use AcElementListenerV1 abstract class:

.. code-block:: java

  @Component
  @RequiredArgsConstructor
  public class AutomationCompositionElementHandler implements AutomationCompositionElementListener {

    private final ParticipantIntermediaryApi intermediaryApi;
    private final otherService otherService;
    ..............................
  }

  @Component
  public class AutomationCompositionElementHandler extends AcElementListenerV1 {

    private final OtherService otherService;

    public AutomationCompositionElementHandler(ParticipantIntermediaryApi intermediaryApi, OtherService otherService) {
        super(intermediaryApi);
        this.otherService = otherService;
    }
    ..............................
  }



A second example:

.. code-block:: java

  @Component
  public class AutomationCompositionElementHandler implements AutomationCompositionElementListener {

    @Autowired
    private ParticipantIntermediaryApi intermediaryApi;

    @Autowired
    private otherService otherService;
    ..............................
  }

  @Component
  public class AutomationCompositionElementHandler extends AcElementListenerV1 {

    @Autowired
    private otherService otherService;

    public AutomationCompositionElementHandler(ParticipantIntermediaryApi intermediaryApi) {
        super(intermediaryApi);
    }
    ..............................
  }


APIs to invoke
--------------
ParticipantIntermediaryApi:
  The participant intermediary api has the following methods that can be invoked from the participant for the following purposes.

  #. The requested operations are completed in the handler class and the ACM-runtime needs to be notified.
  #. Collect all instances data.
  #. Send out Properties to ACM-runtime.

  The methods are as follows:

This following methods could be invoked to fetch data during each operation in the participant.

.. code-block:: java

  1.  Map<UUID, AutomationComposition> getAutomationCompositions();
  2.  AutomationComposition getAutomationComposition(UUID instanceId);
  3.  AutomationCompositionElement getAutomationCompositionElement(UUID instanceId, UUID elementId);
  4.  Map<UUID, Map<ToscaConceptIdentifier, AutomationCompositionElementDefinition>> getAcElementsDefinitions();
  5.  Map<ToscaConceptIdentifier, AutomationCompositionElementDefinition> getAcElementsDefinitions(UUID compositionId);
  6.  AutomationCompositionElementDefinition getAcElementDefinition(UUID compositionId, ToscaConceptIdentifier elementId);

This following methods are invoked to update the outProperties during each operation in the participant.

.. code-block:: java

  1.  void sendAcDefinitionInfo(UUID compositionId, ToscaConceptIdentifier elementId, Map<String, Object> outProperties);
  2.  void sendAcElementInfo(UUID instanceId, UUID elementId, String useState, String operationalState, Map<String, Object> outProperties);

This following methods are invoked to update the AC element state or AC element definition state after each operation is completed in the participant.

.. code-block:: java

  1.  void updateAutomationCompositionElementState(UUID instanceId, UUID elementId, DeployState deployState, LockState lockState, StateChangeResult stateChangeResult, String message);
  2.  void updateCompositionState(UUID compositionId, AcTypeState state, StateChangeResult stateChangeResult, String message);
  3.  void updateAutomationCompositionElementStage(UUID instance, UUID elementId, StateChangeResult stateChangeResult, int stage, String message);

In/Out composition Properties
-----------------------------
The 'Common Properties' could be created or updated by ACM-runtime.
Participants will receive that Properties during priming and deprime events by CompositionDto class.

.. code-block:: java

  @Override
  public void prime(CompositionDto composition) throws PfModelException {
      for (var entry : composition.inPropertiesMap().entrySet()) {
          var elementDefinitionId = entry.getKey();
          var inProperties = entry.getValue();
          .......
      }
      .......
  }

Participants will receive the Properties related to the element definition by CompositionElementDto class.

.. code-block:: java

  @Override
  public void deploy(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException {
      var inCompositionProperties = compositionElement.inProperties();
      .......
  }

The 'Out Properties' could be created or updated by participants. ACM-runtime will receive that Properties during ParticipantStatus event.
The participant can trigger this event using the method sendAcDefinitionInfo.

Participants will receive that outProperties during priming and deprime events by CompositionDto class.

.. code-block:: java

  @Override
  public void deprime(CompositionDto composition) throws PfModelException {
      for (var entry : composition.outPropertiesMap().entrySet()) {
          var elementDefinitionId = entry.getKey();
          var outProperties = entry.getValue();
          .......
      }
      .......
  }

Participants will receive the outProperties related to the element definition by CompositionElementDto class.

.. code-block:: java

  @Override
  public void deploy(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException {
      var outCompositionProperties = compositionElement.outProperties();
      .......
  }

Is allowed to the participant to read all In/Out Properties of all compositions handled by the participant using the method getAcElementsDefinitions.
The following code is an example how to update the property 'myProperty' and send to ACM-runtime:

.. code-block:: java

  var acElement = intermediaryApi.getAcElementDefinition(compositionId, elementDefinitionId);
  var outProperties = acElement.getOutProperties();
  outProperties.put("myProperty", myProperty);
  intermediaryApi.sendAcDefinitionInfo(compositionId, elementDefinitionId, outProperties);

In/Out instance Properties
--------------------------
  The 'In/Out Properties' are stored into the instance elements, so each element has its own In/Out Properties.

  The 'In Properties' could be created or updated by ACM-runtime. Participants will receive that Properties during deploy and update events.

  The 'Out Properties' could be created or updated by participants. ACM-runtime will receive that Properties during ParticipantStatus event.
  The participant can trigger this event using the method sendAcElementInfo. The 'useState' and 'operationalState' can be used as well.
  The 'Out Properties' could be **cleaned**:

  * by the participant using the method sendAcElementInfo
  * by intermediary automatically during deleting of the instance
  * by an update when the instance is in UNDEPLOYED state (changing the elementId)

  The 'Out Properties' will be **not cleaned** by intermediary:

  * during DEPLOIYNG (Out Properties will be take from last changes matching by elementId)
  * during UNDEPLOING
  * during LOCKING/UNLOCKING
  * during UPDATING/MIGRATING/PREPARE/REVIEW/MIGRATION_PRECHECKING

Participants will receive the in/out instance Properties related to the element by InstanceElementDto class.

.. code-block:: java

  @Override
  public void deploy(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException {
      var inProperties = instanceElement.inProperties();
      var outProperties = instanceElement.outProperties();
      .......
  }

Is allowed to the participant to read all In/Out Properties and state of all instances handled by the participant using the method getAutomationCompositions.
The following code is an example how to update the property 'myProperty' and send to ACM-runtime:

.. code-block:: java

  var acElement = intermediaryApi.getAutomationCompositionElement(instanceId, elementId);
  var outProperties = acElement.getOutProperties();
  outProperties.put("myProperty", myProperty);
  intermediaryApi.sendAcElementInfo(instanceId, elementId, acElement.getUseState(), acElement.getOperationalState(), outProperties);

**Note**: In update and migrate Participants will receive the instance Properties before the merge (instanceElement) and the instance Properties merged (instanceElementUpdated / instanceElementMigrate).

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
      topics:
        operationTopic: policy-acruntime-participant
        syncTopic: acm-ppnt-sync
      reportingTimeIntervalMs: 120000
      description: Participant Description
      participantId: 101c62b3-8918-41b9-a747-d21eb79c6c90
      clampAutomationCompositionTopics:
        topicSources:
          - topic: ${participant.intermediaryParameters.topics.operationTopic}
            servers:
              - ${topicServer:localhost}:9092
            topicCommInfrastructure: kafka
            fetchTimeout: 15000
            additionalProps:
              group.id: policy-clamp-my-first-ptn
          - topic: ${participant.intermediaryParameters.topics.syncTopic}
            servers:
              - ${topicServer:localhost}:9092
            topicCommInfrastructure: kafka
            fetchTimeout: 15000
        topicSinks:
          - topic: ${participant.intermediaryParameters.topics.operationTopic}
            servers:
              - ${topicServer:localhost}:9092
            topicCommInfrastructure: kafka
      participantSupportedElementTypes:
        -
          typeName: org.onap.policy.clamp.acm.MyFirstAutomationCompositionElement
          typeVersion: 1.0.0


The following example shows the Handler implementation and how could be the implemented the mandatory notifications.

.. code-block:: java

  @Component
  public class AutomationCompositionElementHandler extends AcElementListenerV3 {

    @Override
    public void deploy(CompositionElementDto compositionElement, InstanceElementDto instanceElement)
            throws PfModelException {

        // TODO deploy process

        if (isDeploySuccess()) {
            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.DEPLOYED, null, StateChangeResult.NO_ERROR,
                "Deployed");
        } else {
            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.UNDEPLOYED, null, StateChangeResult.FAILED,
                "Deploy failed!");
        }
    }

    @Override
    public void undeploy(CompositionElementDto compositionElement, InstanceElementDto instanceElement)
            throws PfModelException {

        // TODO undeploy process

        if (isUndeploySuccess()) {
            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.UNDEPLOYED, null, StateChangeResult.NO_ERROR,
                    "Undeployed");
        } else {
            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.DEPLOYED, null, StateChangeResult.FAILED,
                    "Undeploy failed!");
        }
    }

    @Override
    public void lock(CompositionElementDto compositionElement, InstanceElementDto instanceElement)
            throws PfModelException {

        // TODO lock process

        if (isLockSuccess()) {
            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), null, LockState.LOCKED, StateChangeResult.NO_ERROR, "Locked");
        } else {
            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), null, LockState.UNLOCKED, StateChangeResult.FAILED, "Lock failed!");
        }
    }

    @Override
    public void unlock(CompositionElementDto compositionElement, InstanceElementDto instanceElement)
            throws PfModelException {

        // TODO unlock process

        if (isUnlockSuccess()) {
            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), null, LockState.UNLOCKED, StateChangeResult.NO_ERROR, "Unlocked");
        } else {
            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), null, LockState.LOCKED, StateChangeResult.FAILED, "Unlock failed!");
        }
    }

    @Override
    public void delete(CompositionElementDto compositionElement, InstanceElementDto instanceElement)
            throws PfModelException {

        // TODO delete process

        if (isDeleteSuccess()) {
            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.DELETED, null, StateChangeResult.NO_ERROR, "Deleted");
        } else {
            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.UNDEPLOYED, null, StateChangeResult.FAILED,
                "Delete failed!");
        }
    }

    @Override
    public void update(CompositionElementDto compositionElement, InstanceElementDto instanceElement,
            InstanceElementDto instanceElementUpdated) throws PfModelException {

        // TODO update process

        if (isUpdateSuccess()) {
            intermediaryApi.updateAutomationCompositionElementState(
                instanceElement.instanceId(), instanceElement.elementId(),
                DeployState.DEPLOYED, null, StateChangeResult.NO_ERROR, "Updated");
        } else {
            intermediaryApi.updateAutomationCompositionElementState(
                instanceElement.instanceId(), instanceElement.elementId(),
                DeployState.DEPLOYED, null, StateChangeResult.FAILED, "Update failed!");
        }
    }

    @Override
    public void migrate(CompositionElementDto compositionElement, CompositionElementDto compositionElementTarget,
            InstanceElementDto instanceElement, InstanceElementDto instanceElementMigrate, int stage)
            throws PfModelException

        switch (instanceElementMigrate.state()) {
            case NEW -> // TODO new element scenario
            case REMOVED -> // TODO element remove scenario
            default ->  // TODO migration process
        }

        if (isMigrateSuccess()) {
            if (isStageCompleted()) {
                intermediaryApi.updateAutomationCompositionElementState(
                    instanceElement.instanceId(), instanceElement.elementId(),
                    DeployState.DEPLOYED, null, StateChangeResult.NO_ERROR, "Migrated");
            } else {
                intermediaryApi.updateAutomationCompositionElementStage(
                    instanceElement.instanceId(), instanceElement.elementId(),
                    StateChangeResult.NO_ERROR, nextStage, "stage " + stage + " Migrated");
            }
        } else {
            intermediaryApi.updateAutomationCompositionElementState(
                instanceElement.instanceId(), instanceElement.elementId(),
                DeployState.DEPLOYED, null, StateChangeResult.FAILED, "Migrate failed!");
        }
    }

    @Override
    public void migratePrecheck(UUID instanceId, UUID elementId) throws PfModelException {

        // TODO migration Precheck process

        intermediaryApi.updateAutomationCompositionElementState(
            instanceElement.instanceId(), instanceElement.elementId(),
            DeployState.DEPLOYED, null, StateChangeResult.NO_ERROR, "Migration precheck completed");
    }

    @Override
    public void prepare(UUID instanceId, UUID elementId) throws PfModelException {

        // TODO prepare process

        intermediaryApi.updateAutomationCompositionElementState(
            instanceElement.instanceId(), instanceElement.elementId(),
            DeployState.UNDEPLOYED, null, StateChangeResult.NO_ERROR, "Prepare completed");
    }

    @Override
    public void review(UUID instanceId, UUID elementId) throws PfModelException {

        // TODO review process

        intermediaryApi.updateAutomationCompositionElementState(
            instanceElement.instanceId(), instanceElement.elementId(),
            DeployState.DEPLOYED, null, StateChangeResult.NO_ERROR, "Review completed");
    }

    @Override
    public void prime(CompositionDto composition) throws PfModelException {

        // TODO prime process

        if (isPrimeSuccess()) {
            intermediaryApi.updateCompositionState(composition.compositionId(),
                AcTypeState.PRIMED, StateChangeResult.NO_ERROR, "Primed");
        } else {
            intermediaryApi.updateCompositionState(composition.compositionId(),
                AcTypeState.COMMISSIONED, StateChangeResult.FAILED, "Prime failed!");
        }
    }

    @Override
    public void deprime(CompositionDto composition) throws PfModelException {

        // TODO deprime process

        if (isDeprimeSuccess()) {
            intermediaryApi.updateCompositionState(composition.compositionId(), AcTypeState.COMMISSIONED,
                StateChangeResult.NO_ERROR, "Deprimed");
        } else {
            intermediaryApi.updateCompositionState(composition.compositionId(), AcTypeState.PRIMED,
                StateChangeResult.FAILED, "Deprime failed!");
        }
    }


Allowed state from the participant perspective
----------------------------------------------

+------------+--------------+---------------------+-------------------------+
| **Action** | **state**    |   **stChResult**    | **Description**         |
+------------+--------------+---------------------+-------------------------+
|            | PRIMED       |   NO_ERROR          | Prime is completed      |
+   Prime    +--------------+---------------------+-------------------------+
|            | COMMISSIONED |   FAILED            | Prime is failed         |
+------------+--------------+---------------------+-------------------------+
|            | COMMISSIONED |   NO_ERROR          | Deprime is completed    |
+  Deprime   +--------------+---------------------+-------------------------+
|            | PRIMED       |   FAILED            | Deprime is failed       |
+------------+--------------+---------------------+-------------------------+

+------------------+-----------------+---------------+----------------+----------------------------------+
| **Action**       | **deployState** | **lockState** | **stChResult** | **Description**                  |
+------------------+-----------------+---------------+----------------+----------------------------------+
|                  |  DEPLOYED       |               |  NO_ERROR      |  Deploy is completed             |
+ Deploy           +-----------------+---------------+----------------+----------------------------------+
|                  |  UNDEPLOYED     |               |  FAILED        |  Deploy is failed                |
+------------------+-----------------+---------------+----------------+----------------------------------+
|                  |  UNDEPLOYED     |               |  NO_ERROR      |  Undeploy is completed           |
| Undeploy         +-----------------+---------------+----------------+----------------------------------+
|                  |  DEPLOYED       |               |  FAILED        |  Undeploy is failed              |
+------------------+-----------------+---------------+----------------+----------------------------------+
|                  |                 |  LOCKED       |  NO_ERROR      |  Lock is completed               |
+ Lock             +-----------------+---------------+----------------+----------------------------------+
|                  |                 |  UNLOCKED     |  FAILED        |  Lock is failed                  |
+------------------+-----------------+---------------+----------------+----------------------------------+
|                  |                 |  UNLOCKED     |  NO_ERROR      |  Unlock is completed             |
+ Unlock           +-----------------+---------------+----------------+----------------------------------+
|                  |                 |  LOCKED       |  FAILED        |  Unlock is failed                |
+------------------+-----------------+---------------+----------------+----------------------------------+
|                  |  DEPLOYED       |               |  NO_ERROR      |  Update is completed             |
| Update           +-----------------+---------------+----------------+----------------------------------+
|                  |  DEPLOYED       |               |  FAILED        |  Update is failed                |
+------------------+-----------------+---------------+----------------+----------------------------------+
|                  |  DEPLOYED       |               |  NO_ERROR      |  Migration is completed          |
+ Migrate          +-----------------+---------------+----------------+----------------------------------+
|                  |  DEPLOYED       |               |  FAILED        |  Migration is failed             |
+------------------+-----------------+---------------+----------------+----------------------------------+
| Migrate Precheck |  DEPLOYED       |               |  NO_ERROR      |  Migration-precheck is completed |
+------------------+-----------------+---------------+----------------+----------------------------------+
| Prepare          |  UNDEPLOYED     |               |  NO_ERROR      |  Prepare is completed            |
+------------------+-----------------+---------------+----------------+----------------------------------+
| Review           |  DEPLOYED       |               |  NO_ERROR      |  Review is completed             |
+------------------+-----------------+---------------+----------------+----------------------------------+
|                  |  DELETED        |               |  NO_ERROR      |  Delete is completed             |
| Delete           +-----------------+---------------+----------------+----------------------------------+
|                  |  UNDEPLOYED     |               |  FAILED        |  Delete is failed                |
+------------------+-----------------+---------------+----------------+----------------------------------+


AC Element states in failure scenarios
--------------------------------------

During the execution of any state change order, there is always a possibility of failures or exceptions that can occur in the participant.
This can be tackled by the followed approaches.

The participant implementation can handle the exception and revert back the appropriate AC element state, by invoking the
'updateAutomationCompositionElementState' api from the participant intermediary.

Alternatively, the participant can simply throw a PfModelException from its implementation which will be handled by the participant intermediary.
The intermediary handles this exception and rolls back the AC element to its previous state with the appropriate stateChange Result.
Please refer the following table for the state change reversion that happens in the participant intermediary for the AC elements.

================== ==================
**Error Scenario** **State Reverted**
================== ==================
Prime fails        Commissoned

Deprime fails      Primed

Deploy fails       Undeployed

Undeploy fails     Deployed

Update fails       Deployed

Delete fails       Undeployed

Lock fails         Unlocked

Unlock fails       Locked

Migrate fails      Deployed
================== ==================

Considering the above mentioned behavior of the participant Intermediary, it is the responsibility of the developer to tackle the
error scenarios in the participant with the suitable approach.

Handle states and failure scenarios from the participant perspective
--------------------------------------------------------------------

It is important to make distinction between the state of the instance/element flow, and the state of the application/configuration involved.
A deployed element means that a participant has completed a deploy action, and should not be confused with a deployed application.
Example with two elements:

1. an instance is deployed, so the two elements are DEPLOYED
2. user calls undeploy command (ACM-R sets all element as DEPLOYING)
3. participant executes the first instance element with success and sends UNDEPLOYED state
4. participant executes the second instance element with fail and sends DEPLOYED state
5. user calls undeploy command again (ACM-R sets all element as DEPLOYING)
6. participant does not know that the application related to the first element is already UNDEPLOYED when the flow state is UNDEPLOYING

There are some contexts in a failure scenario that the participant need to know the state of the deployed application.
From participant side, using "outProperties" it could be possible to handle custom states that better suit whit the context.

Example of a participant that deploy/undeploy applications.
The following Java code shows how to implement deploy and undeploy that avoid to repeat the action already executed.

.. code-block:: java

    @Override
    public void deploy(CompositionElementDto compositionElement, InstanceElementDto instanceElement)
        throws PfModelException {

        if ("DEPLOYED".equals(instanceElement.outProperties().get("state"))) {
            // deploy process already done
            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.DEPLOYED, null, StateChangeResult.NO_ERROR,
                "Already Deployed");
            return;
        }

        // deployment process
        .......................................
        .......................................
        // end of the deployment process

        if (isDeploySuccess()) {
            instanceElement.outProperties().put("state", "DEPLOYED");
            intermediaryApi.sendAcElementInfo(instanceElement.instanceId(), instanceElement.elementId(),
                null, null, instanceElement.outProperties());

            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.DEPLOYED, null, StateChangeResult.NO_ERROR, "Deployed");
        } else {
            instanceElement.outProperties().put("state", "UNDEPLOYED");
            intermediaryApi.sendAcElementInfo(instanceElement.instanceId(), instanceElement.elementId(),
                null, null, instanceElement.outProperties());

            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.UNDEPLOYED, null, StateChangeResult.FAILED, "Deploy failed!");
        }
    }

    @Override
    public void undeploy(CompositionElementDto compositionElement, InstanceElementDto instanceElement)
        throws PfModelException {

        if ("DEPLOYED".equals(instanceElement.outProperties().get("state"))) {
            // undeploy process already done

            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.UNDEPLOYED, null, StateChangeResult.NO_ERROR,
                "Already Undeployed");
            return;
        }

        // undeployment process
        .......................................
        .......................................
        // end of the undeployment process

        if (isUndeploySuccess()) {
            instanceElement.outProperties().put("state", "UNDEPLOYED");
            intermediaryApi.sendAcElementInfo(instanceElement.instanceId(), instanceElement.elementId(),
                null, null, instanceElement.outProperties());

            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.UNDEPLOYED, null, StateChangeResult.NO_ERROR, "Undeployed");
        } else {
            instanceElement.outProperties().put("state", "DEPLOYED");
            intermediaryApi.sendAcElementInfo(instanceElement.instanceId(), instanceElement.elementId(),
                null, null, instanceElement.outProperties());

            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.DEPLOYED, null, StateChangeResult.FAILED, "Undeploy failed!");
        }
    }


Example of a participant that make configurations.
The following Java code shows how to implement deploy and undeploy that needs a clean up and repeat the action.
The state of the configuration will saved in outProperties.

.. code-block:: java

    @Override
    public void deploy(CompositionElementDto compositionElement, InstanceElementDto instanceElement) throws PfModelException {

        if ("DEPLOYED".equals(instanceElement.outProperties().get("state"))) {
            // clean up deployment

        } else if ("DEPLOYING".equals(state) || "UNDEPLOYING".equals(state)) {
            // check and clean up

        }

        // deployment process
        instanceElement.outProperties().put("state", "DEPLOYING");
        intermediaryApi.sendAcElementInfo(instanceElement.instanceId(), instanceElement.elementId(),
            null, null, instanceElement.outProperties());

        .......................................
        .......................................
        // end of the deployment process

        if (isDeploySuccess()) {
            instanceElement.outProperties().put("state", "DEPLOYED");
            intermediaryApi.sendAcElementInfo(instanceElement.instanceId(), instanceElement.elementId(),
                null, null, instanceElement.outProperties());

            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.DEPLOYED, null, StateChangeResult.NO_ERROR, "Deployed");
        } else {
            instanceElement.outProperties().put("state", "UNDEPLOYED");
            intermediaryApi.sendAcElementInfo(instanceElement.instanceId(), instanceElement.elementId(),
                null, null, instanceElement.outProperties());

            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.UNDEPLOYED, null, StateChangeResult.FAILED, "Deploy failed!");
        }
    }

    @Override
    public void undeploy(CompositionElementDto compositionElement, InstanceElementDto instanceElement)
        throws PfModelException {

        if ("UNDEPLOYED".equals(instanceElement.outProperties().get("state"))) {
            // clean up undeployment

        } else if ("DEPLOYING".equals(state) || "UNDEPLOYING".equals(state)) {
            // check and clean up

        }

        // undeployment process
        instanceElement.outProperties().put("state", "UNDEPLOYING");
        intermediaryApi.sendAcElementInfo(instanceElement.instanceId(), instanceElement.elementId(),
            null, null, instanceElement.outProperties());

        .......................................
        .......................................
        // end of the undeployment process

        if (isUndeploySuccess()) {
            instanceElement.outProperties().put("state", "UNDEPLOYED");
            intermediaryApi.sendAcElementInfo(instanceElement.instanceId(), instanceElement.elementId(),
                null, null, instanceElement.outProperties());

            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.UNDEPLOYED, null, StateChangeResult.NO_ERROR, "Undeployed");
        } else {
            instanceElement.outProperties().put("state", "DEPLOYED");
            intermediaryApi.sendAcElementInfo(instanceElement.instanceId(), instanceElement.elementId(),
                null, null, instanceElement.outProperties());

            intermediaryApi.updateAutomationCompositionElementState(instanceElement.instanceId(),
                instanceElement.elementId(), DeployState.DEPLOYED, null, StateChangeResult.FAILED, "Undeploy failed!");
        }
    }


*In all suggestions shown before we have used labels as "DEPLOY", "UNDEPLOY", "DEPLOYING", "UNDEPLOYING" but the developer can change them as better suit with the context of the participant.*

