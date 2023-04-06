.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _acm-rest-apis-label:

REST APIs for CLAMP Automation Compositions
###########################################


Commissioning API
=================

This API is a CRUD API that allows **Automation Composition Type** definitions, created in a design
environment, to be commissioned on the CLAMP runtime. It has endpoints that allow Automation
Composition Types to be created, read, updated, and deleted.

The body of the *create* and *update* endpoints is a TOSCA Service/Topology template that
defines the new or changed Automation Composition Type. The *update* and *delete* endpoints take a
UUID reference to the Automation Composition Type. The incoming TOSCA is verified and checked for
referential integrity. On *delete* requests, a check is made to ensure that no Automation
Composition Instances exist for the Automation Composition Type to be deleted.
An endpoint is used for *priming* or *depriming* an Automation Composition Definition, and it sends
the Automation Composition Element Types to the participants.
:ref:`More info here<clamp-runtime-acm>`.

.. csv-table::
   :header: "Commissioning API"
   :widths: 10 

   `ACM-R Commissioning Swagger <./local-swagger.html#tag/Automation-Composition-Definition>`_


Instantiation API
=================

The instantiation API has two functions:

#. Creation, Reading, Update, and Deletion of Automation Composition Instances.
#. Instantiation and lifecycle management of Automation Composition Instances on participants.

Instantiation Automation Composition Instance CRUD
--------------------------------------------------

This API allows for the creation, read, update, and deletion of Automation Composition
Instances. The endpoints for *create* and *update* take a JSON body that describes the Automation
Composition Instance and needs the UUID of the Automation Composition Type. 
The endpoints for *read* and *delete* take a Automation Composition Type
UUID to determine which Automation Composition Type to act on, and if specified the UUID of the
Automation Composition Instance.
For the *delete* endpoint it needs both the UUID of the Automation Composition Type and UUID of the
Automation Composition Instance, and a check is made to ensure that the Automation Composition Instance
is not instantiated on participants.

A call to the update endpoint for a Automation Composition Instance follows the semantics described
here: :ref:`Issues AC instance to change status<clamp-runtime-acm>`.

The endpoint to issue Automation Composition Instances to change status is used to manage the lifecycle of Automation Composition Instances. An Automation
Composition Instance can be in the states described here: :ref:`2.1 Automation Composition Instance
States <acm-instance-states>`. Managing the lifecycle of an Automation Composition Instance amounts
to steering the Automation Composition through its states.

The API allows upgrades and downgrades of Automation Composition Instances to be pushed to
participants following the semantics described here: :ref:`4.1 Management of Automation Composition
Instance Configurations <management-acm-instance-configs>`.

When the API is used to update the participants on a Automation Composition Instance,
the new/upgraded/downgraded definition of the
Automation Composition is pushed to the participants. Note that the API asks the participants in an
Automation Composition Instance to perform the update, it is the responsibility of the participants
to execute the update and report the result using the protocols described here: :ref:`CLAMP
Participants <clamp-acm-participants>`. The progress and result of an update can be monitored
using the :ref:`Monitoring API <monitoring-api>`.

The API also allows a state change of an Automation Composition Instance to be ordered. The
required state of the Automation Composition Instance is pushed to participants in an Automation
Composition Instance using the API. Note that the API asks the participants in an Automation
Composition Instance to perform the state change, it is the responsibility of the participants to
execute the state change and report the result using the protocols described here: :ref:`CLAMP
Participants <clamp-acm-participants>`. The progress and result of a state change can be monitored
using the `Monitoring API <monitoring-api>`.

.. csv-table::
   :header: "Instantiation API"
   :widths: 10

   `ACM-R Instantiation Swagger <./local-swagger.html#tag/Automation-Composition-Instance>`_

.. _monitoring-api:

Monitoring API
==============

The Monitoring API allows the information and status of *Participants*, *Automation Composition
Instances* and their *Automation Composition Elements* to be monitored, via an hearthbeat report.
The API provides filtering so that specific Participants and Automation Composition Instances
can be retrieved.

.. csv-table::
   :header: "Monitoring API"
   :widths: 10

   `ACM-R Monitoring Swagger <./local-swagger.html#tag/Participant-Monitoring>`_

End of Document
