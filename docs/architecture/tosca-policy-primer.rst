.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _tosca-label:

TOSCA Policy Primer
-------------------

.. contents::
    :depth: 2

This page gives a short overview of how Policy is modelled in the
`TOSCA Simple Profile in YAML <http://docs.oasis-open.org/tosca/TOSCA-Simple-Profile-YAML/v1.1/TOSCA-Simple-Profile-YAML-v1.1.pdf>`__.

TOSCA defines three concepts for Policy: Policy Type, Policy, and Trigger.

.. image:: images/ToscaPolicyStructure.png
   :width: 800

Policy Type
~~~~~~~~~~~

A Policy Type is used to specify the types of policies that may be used in a service. The parameter definitions
for a policy of this type, the entity types to which it applies, and what triggers policies of this type may be
specified.


The types of policies that are used in a service are defined in the policy_types section of the TOSCA service template
as a Policy Type. More formally, TOSCA  defines a Policy Type as an artifact that "defines a type of requirement that
affects or governs an application or service’s topology at  some stage of its life cycle, but is not explicitly part of
the topology itself". In the definition of a Policy Type in TOSCA, you specify:

* its properties, which define the type of configuration parameters that the policy takes
* its targets, which define the node types and/or groups to which the policy type applies
* its triggers, which specify the conditions in which policies of this type are fired

Policy
~~~~~~

A Policy is used to specify the actual instances of policies that are used in a service. The parameter values of the
policy and the actual entities to which it applies may be specified.

The policies that are used in a service are defined in the policies section of the TOSCA topology template as a Policy.
More formally, TOSCA  defines a Policy as an artifact that "defines a policy that can be associated with a TOSCA
topology or top-level entity definition". In the definition of a Policy in TOSCA, you specify:

* its properties, which define the values of the configuration parameters that the policy takes
* its targets, which define the node types and/or group types to which the policy type applies

Note that policy triggers are specified on the Policy Type definition and are not specified on the Policy itself.

Trigger
~~~~~~~

A Trigger defines an event, condition, and action that is used to initiate execution of a policy associated with it.
The definition of the Trigger allows specification of the type of events to trigger on, the filters on those events,
conditions and constraints for trigger firing, the action to perform on triggering, and various other parameters.

The triggers that are used in a service are defined as reusable modules in the TOSCA service template as a Trigger.
More formally, TOSCA  defines a Trigger as an artifact that "defines the event, condition and action that is used to
“trigger” a policy it is associated with". In the definition of a Trigger in TOSCA, you specify:

* its event_type, which defines the name of the event that fires the policy
* its schedule, which defines the time interval in which the trigger is active
* its target_filter, which defines specific filters for firing such as specific characteristics of the nodes or
relations for which the trigger should or should not fire
* its condition, which defines extra conditions on the incoming event for firing the trigger
* its constraint, which defines extra conditions on the incoming event for not firing the trigger
* its period, which defines the period to use for evaluating conditions and constraints
* its evaluations, which defines the number of evaluations that must be performed over the period to assert the
condition or constraint exists
* its method, the method to use for evaluation of conditions and constraints
* its action, the workflow or operation to invoke when the trigger fires

Note that how a Trigger actually works with a Policy is not clear from the specification.

End of Document

