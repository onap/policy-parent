.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _clamp-pairwise-testing-label:

.. toctree::
   :maxdepth: 2

CLAMP <-> SDC
~~~~~~~~~~~~~~

The pairwise testing is executed against a default ONAP installation in the OOM.
It briefly states the procedure to design an Automation Composition starting from service creation,
adding the required ONAP component artifacts, policy and properties in the composition phase of SDC
and finally distributing it to the CLAMP for Commissioning.
SDC provides an interface for distributing the modeled services to the run time components.

The instructions below will enable to design an Automation Composition. There are different phases to the design:

Step 1: Design an automation composition template and associate it to a Service, the template represents the theoretical flow of the ACM.

Step 2: Generate a deployment artifact that can be ingested by the Policy Framework

Step 3: Distribute the automation composition to CLAMP, the csar is distributed to CLAMP over Dmaap

Step 4: Policy Distribution will internally call Automation Composition Commissioning rest endpoint

Step 5: Service Template is commissioned in CLAMP, and can be followed by Instantiation and state changes.

General Setup
*************

The kubernetes installation allocated all policy components across multiple worker node VMs.
The worker VM hosting the policy components has the following spec:

- 16GB RAM
- 8 VCPU
- 160GB Ephemeral Disk

The ONAP components used during the pairwise tests are:

- CLAMP automation composition runtime, policy participant, kubernetes participant.
- SDC for running SDC components.
- DMaaP for the communication between Automation Composition runtime and participants.
- Policy Framework components for instantiation and commissioning of automation compositions.

Helpful instruction page on bringing SDC and PORTAL setup on an OOM deployment https://wiki.onap.org/display/DW/Deploy+OOM+and+SDC+%28or+ONAP%29+on+a+single+VM+with+microk8s+-+Honolulu+Setup

Testing procedure
*****************

The test set focused on the following use cases:

- Design of participants and automation composition elements
- Design of Automation Composition template including the above designed participants and automation composition element templates.
- Distribution of designed template along with other artifacts as a csar to policy-distribution
- Commissioning of template in automation composition runtime.

Configuration changes
*********************

Following are certain configuration changes required/cross-checked
1. policy-distribution configuration should include toscaAutomationCompositionDecoderConfiguration
File: kubernetes/policy/components/policy-distribution/resources/config/config.json

   - Automation composition decoders and forwards should be present. Reference: `Sample Configuration <json/pd_config.json>`

Design of participants and automation composition elements:
-----------------------------------------------------------
Different participants and automation composition elements are created in SDC dashboard with the models available for automation composition.

SDC provides a graphical interface for onboarding/designing resources (such as VNFs, PNFs, CNFs) and designing services composed of such resources

- Create as many participants as needed to present in the automation composition
- Select VF, provide name of the participant. Choose Model as AUTOMATION COMPOSTIION and Category as Participant.

  .. image:: images/sdc_create_participant.png

- Create as many automation composition elements as needed to present in the automation composition
- Select VF, provide name of the automation composition element. Choose Model as AUTOMATION COMPOSTIION and Category as AutomationComposition Element.

  .. image:: images/sdc_create_element.png

- Add properties as required for an automation composition element
- Add any properties where input is needed in Inputs tab.

  .. image:: images/sdc_element_props.png

- Create an automation composition
- Select Service, provide name of the automation composition. Choose Model as AUTOMATION COMPOSTIION and Category as AutomationComposition.

  .. image:: images/sdc_create_acm.png

- SDC Composition tab
- Drag and Drop the previously created participants and automation composition elements into the Compistion pane.
- Drag and Drop the policies that needs to be added to the service template.

  .. image:: images/sdc_compose_acm.png

- For a pre validation, Tosca artifacts can be downloaded and verified

  .. image:: images/sdc_tosca.png

- From SDC dashboard, perform a distribution of the automation composition

  .. image:: images/sdc_distribute.png

- An Automation Composition is created by commissioning a Tosca template with Automation Composition definitions.
    This commissioned tosca service template can be further used from Policy-GUI for instantiating the Automation Composition with the state "UNINITIALISED".

- Instantiate the commissioned Automation Composition definitions from the Policy Gui under 'Instantiation Management'.

  .. image:: images/create-instance.png

-  Verification: The automation composition is created with default state "UNINITIALISED" without errors.

  .. image:: images/ac-instantiation.png

