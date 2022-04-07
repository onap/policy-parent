.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _clamp-acm-policy-framework-participant:

The CLAMP Policy Framework Participant
######################################

.. contents::
    :depth: 3

Automation Composition Elements in the Policy Framework Participant are configured using TOSCA metadata defined for the Policy Automation Composition Element type.

The Policy Framework participant receives messages through participant-intermediary common code, and handles them by invoking REST APIs towards policy-framework.

For example, When a AutomationCompositionUpdate message is received by policy participant, it contains full ToscaServiceTemplate describing all components participating in an automation composition. When the automation composition element state changed from UNINITIALIZED to PASSIVE, the Policy-participant triggers the creation of policy-types and policies in Policy-Framework.

When the state changes from PASSIVE to UNINITIALIZED, Policy-Participant deletes the policies, policy-types by invoking REST APIs towards the policy-framework.

Run Policy Framework Participant command line using Maven
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8082"

Run Policy Framework Participant command line using Jar
+++++++++++++++++++++++++++++++++++++++++++++++++++++++

java -jar -Dserver.port=8082 -DtopicServer=localhost target/policy-clamp-participant-impl-policy-6.1.2-SNAPSHOT.jar

Distributing Policies
+++++++++++++++++++++

The Policy Framework participant uses the Policy PAP API to deploy and undeploy policies.

When a Policy Framework Automation Composition Element changes from state UNINITIALISED to state PASSIVE, the policy is deployed. When it changes from state PASSIVE to state UNINITIALISED, the policy is undeployed.

The PDP group to which the policy should be deployed is specified in the Automation Composition Element metadata, see the Policy Automation Composition Element type definition. If the PDP group specified for policy deployment does not exist, an error is reported.

The PAP Policy Status API and Policy Deployment Status API are used to retrieve data to report on the deployment status of policies in Participant Status messages.

The PDP Statistics API is used to get statistics for statistics report from the Policy Framework Participant back to the CLAMP runtime.

Policy Type and Policy References
+++++++++++++++++++++++++++++++++

The Policy Framework uses the policyType and policyId properties defined in the Policy Automation Composition Element type references to specify what policy type and policy should be used by a Policy Automation Composition Element.

The Policy Type and Policy specified in the policyType and policyId reference must of course be available in the Policy Framework in order for them to be used in Automation Composition instances. In some cases, the Policy Type and/or the Policy may be already loaded in the Policy Framework. In other cases, the Policy Framework participant must load the Policy Type and/or policy.

Policy Type References
**********************

The Policy Participant uses the following steps for Policy Type References:

#. The Policy Participant reads the Policy Type ID from the policyType property specified for the Automation Composition Element.

#. It checks if a Policy Type with that Policy Type ID has been specified in the ToscaServiceTemplateFragment field in
   the AutomationCompositionElement definition in the AutomationCompositionUpdate message, see :ref:`clampacm-participant-protocol-label`.

  #. If the Policy Type has been specified, the Participant stores the Policy Type in the Policy framework. If the
     Policy Type is successfully stored, execution proceeds, otherwise an error is reported.

  #. If the Policy Type has not been specified, the Participant checks that the Policy Type is already in the Policy
     framework. If the Policy Type already exists, execution proceeds, otherwise an error is reported.

Policy References
*****************

The Policy Participant uses the following steps for Policy References:

#. The Policy Participant reads the Policy ID from the policyId property specified for the Automation Composition Element.

#. It checks if a Policy with that Policy ID has been specified in the ToscaServiceTemplateFragment field in the
   AutomationCompositionElement definition in the AutomationCompositionUpdate message, :ref:`clampacm-participant-protocol-label`.

  #. If the Policy has been specified, the Participant stores the Policy in the Policy framework. If the Policy is
     successfully stored, execution proceeds, otherwise an error is reported.

  #. If the Policy has not been specified, the Participant checks that the Policy is already in the Policy framework. If
     the Policy already exists, execution proceeds, otherwise an error is reported.