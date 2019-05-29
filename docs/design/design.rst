.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _design-label:

Policy Design and Development
#############################

.. contents::
    :depth: 3

This document describes the design principles that should be used to write, deploy, and run policies of various types
using the Policy Framework. It explains the APIs that are available for Policy Framework users. It provides copious
examples to illustrate policy design and API usage.

1 Introduction
==============

The figure below shows the Artifacts (Blue) in the ONAP Policy Framework, the Activities (Yellow) that manipulate them,
and important components (Salmon) that interact with them. The Policy Framework is fully TOSCA compliant, and uses
TOSCA to model policies. Please see the :ref:`TOSCA Policy Primer <tosca-label>` page for an introduction to TOSCA
policy concepts.

.. image:: images/APIsInPolicyFramework.svg

TOSCA defines the concept of a *PolicyType*, the definition of a type of policy that can be applied to a service. It
also defines the concept of a *Policy*, an instance of a *PolicyType*. In the Policy Framework, we handle and manage
these TOSCA definitions and tie them to real implementations of policies that can run on PDPs.

The diagram above outlines how this is achieved. Each TOSCA *PolicyType* must have a corresponding *PolicyTypeImpl* in
the Policy Framework. The TOSCA *PolicyType* definition can be used to create a TOSCA *Policy* definition, either
directly by the Policy Framework, by CLAMP, or by some other system. Once the *Policy* artifact exists, it can be used
together with the *PolicyTypeImpl* artifact to create a *PolicyImpl* artifact. A *PolicyImpl* artifact is an executable
policy implementation that can run on a PDP.

The TOSCA *PolicyType* artifact defines the external characteristics of the policy; defining its properties, the types
of entities it acts on, and its triggers.  A *PolicyTypeImpl* artifact is an XACML, Drools, or APEX implementation of
that policy definition. *PolicyType* and *PolicyTypeImpl* artifacts may be preloaded, may be loaded manually, or may be
created using the Lifecycle API. Alternatively, *PolicyType* definitions may be loaded over the Lifecycle API for
preloaded *PolicyTypeImpl* artifacts. A TOSCA *PolicyType* artifact can be used by clients (such as CLAMP or CLI tools)
to create, parse, serialize, and/or deserialize an actual Policy.

The TOSCA *Policy* artifact is used internally by the Policy Framework, or is input by CLAMP or other systems. This
artifact specifies the values of the properties for the policy and specifies the specific entities the policy acts on.
Policy Design uses the TOSCA *Policy* artifact and the *PolicyTypeImpl* artifact to create an executable *PolicyImpl*
artifact. 

2 ONAP Policy Types
===================

Policy Type Design manages TOSCA *PolicyType* artifacts and their *PolicyTypeImpl* implementations.

A TOSCA *PolicyType* may ultimately be defined by the modeling team but for now are defined by the Policy Framework
project. Various editors and GUIs are available for creating *PolicyTypeImpl* implementations. However, systematic
integration of *PolicyTypeImpl* implementation is outside the scope of the ONAP Dublin release.

The *PolicyType* definitions and implementations listed below are preloaded and are always available for use in the 
Policy Framework.

====================================== ===============================================================================
**Policy Type**                        **Description**
====================================== ===============================================================================
onap.policies.Monitoring               Overarching model that supports Policy driven DCAE microservice components used
                                       in a Control Loops
onap.policies.controlloop.Operational  Used to support actor/action operational policies for control loops
onap.policies.controlloop.Guard        Control Loop guard policies for policing control loops
onap.policies.controlloop.Coordination Control Loop Coordination policies to assist in coordinating multiple control
                                       loops at runtime
====================================== ===============================================================================

2.1 Policy Type: onap.policies.Monitoring
-----------------------------------------

This is a base Policy Type that supports Policy driven DCAE microservice components used in a Control Loops. The
implementation of this Policy Type is developed using the XACML PDP to support question/answer Policy Decisions during
runtime for the DCAE Policy Handler.

.. code-block:: yaml
  :caption: Base Policy Type definition for onap.policies.Monitoring
  :linenos:

  tosca_definitions_version: tosca_simple_yaml_1_0_0
  topology_template:
    policy_types:
      - onap.policies.Monitoring:
          derived_from: tosca.policies.Root
          version: 1.0.0
          description: a base policy type for all policies that govern monitoring provision

The *PolicyTypeImpl* implementation of the *onap.policies.Montoring* Policy Type is generic to support definition of
TOSCA *PolicyType* artifacts in the Policy Framework using the Policy Type Design API. Therefore many TOSCA *PolicyType*
artifacts will use the same *PolicyTypeImpl* implementation with different property types and towards different targets.
This allows dynamically generated DCAE microservice component Policy Types to be created at Design Time.

DCAE microservice components can generate their own TOSCA *PolicyType* using TOSCA-Lab Control Loop guard policies in
SDC (Stretch Goal) or can do so manually. See `How to generate artefacts for SDC catalog using Tosca Lab Tool
<https://wiki.onap.org/display/DW/How+to+generate+artefacts+for+SDC+catalog+using+Tosca+Lab+Tool>`__
for details on TOSCA-LAB in SDC. For Dublin, the DCAE team is defining the manual steps required to build policy models
`Onboarding steps for DCAE MS through SDC/Policy/CLAMP (Dublin)
<https://wiki.onap.org/pages/viewpage.action?pageId=60883710>`__.

.. note::
  For Dublin, microservice Policy Types will be preloaded into the SDC platform and be available as a Normative. The
  policy framework will preload support for those microservice Monitoring policy types.

.. code-block:: yaml
  :caption: Example PolicyType *onap.policies.monitoring.MyDCAEComponent* derived from *onap.policies.Monitoring*
  :linenos:

  tosca_definitions_version: tosca_simple_yaml_1_0_0
  policy_types:
    - onap.policies.Monitoring:
        derived_from: tosca.policies.Root
        version: 1.0.0
        description: a base policy type for all policies that govern monitoring provision
    - onap.policies.monitoring.MyDCAEComponent:
        derived_from: onap.policies.Monitoring
        version: 1.0.0
        properties:
          mydcaecomponent_policy:
          type: map
          description: The Policy Body I need
          entry_schema:
          type: onap.datatypes.monitoring.mydatatype

  data_types:
    - onap.datatypes.monitoring.MyDataType:
      derived_from: tosca.datatypes.Root
      properties:
        my_property_1:
        type: string
        description: A description of this property
        constraints:
          - valid_values:
            - value example 1
            - value example 2

For more examples of monitoring policy type definitions, please refer to the examples in the `ONAP policy-models gerrit
repository <https://github.com/onap/policy-models/tree/master/models-examples/src/main/resources/policytypes>`__. 

2.2 Policy Type: onap.policies.controlloop.Operational 
------------------------------------------------------

This policy type is used to support actor/action operational policies for control loops. There are two types of
implementations for this policy type

1. Drools implementations that supports runtime Control Loop actions taken on components such as SO/APPC/VFC/SDNC/SDNR
2. Implementations using APEX to support Control Loops.

.. note::
  For Dublin, this policy type will ONLY be used for the Policy Framework to distinguish the policy type as operational.

.. code-block:: yaml
  :caption: Base Policy Type definition for onap.policies.controlloop.Operational
  :linenos:

  tosca_definitions_version: tosca_simple_yaml_1_0_0
  policy_types:
    - onap.policies.controlloop.Operational:
        derived_from: tosca.policies.Root
        version: 1.0.0
        description: Operational Policy for Control Loops

Applications should use the following Content-Type when creating onap.policies.controlloop.Operational policies:
.. code-block::

  Content-Type: "application/yaml"

2.2.1 Operational Policy Type Schema for Drools
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For Dublin Drools will still support the Casablanca YAML definition of an Operational Policy for Control Loops.

Please use the the `YAML Operational Policy format
<https://github.com/onap/policy-models/blob/master/models-interactions/model-yaml/README-v2.0.0.md>`__.

2.2.2 Operational Policy Type Schema for APEX
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The operational Policy Type schema for APEX extends the base operational Policy Type schema. This Policy Type allows
parameters specific to the APEX PDP to be specified as a TOSCA policy. See `this sample APEX policy type definition
<https://github.com/onap/integration-csit/blob/master/tests/policy/apex-pdp/data/onap.policies.controlloop.operational.Apex.json>`__.

2.3 Policy Type: onap.policies.controlloop.Guard
------------------------------------------------

This policy type is the the type definition for Control Loop guard policies for frequency limiting, blacklisting and
min/max guards to help protect runtime Control Loop Actions from doing harm to the network. This policy type is
developed using the XACML PDP to support question/answer Policy Decisions during runtime for the Drools and APEX
onap.controlloop.Operational policy type implementations.

.. code-block:: yaml
  :caption: Base Policy Type definition for onap.policies.controlloop.Guard
  :linenos:

  tosca_definitions_version: tosca_simple_yaml_1_0_0
  policy_types:
    - onap.policies.controlloop.Guard:
        derived_from: tosca.policies.Root
        version: 1.0.0
        description: Guard Policy for Control Loops Operational Policies

As with the *onap.policies.Monitoring* policy type, the *PolicyTypeImpl* implementation of the
*onap.policies.controlloop.Guard* Policy Type is generic to support definition of TOSCA *PolicyType* artifacts in the
Policy Framework using the Policy Type Design API.

.. note::
  For Dublin, only the following derived Policy Type definitions below are preloaded in the Policy Framework. However,
  the creation of policies will still support the payload from Casablanca.

Guard policy type definitions for *FrequencyLimiter*, *BlackList*, and  *MinMax* are available in the `ONAP
policy-models gerrit repository
<https://github.com/onap/policy-models/tree/master/models-examples/src/main/resources/policytypes>`__. 


End of Document

