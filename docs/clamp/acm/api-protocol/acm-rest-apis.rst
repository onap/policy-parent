.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _acm-rest-apis-label:

REST APIs for CLAMP Automation Compositions
###########################################


Commissioning API
=================

This API is a CRUD API that allows Automation Composition Type definitions created in a design
environment to be commissioned on the CLAMP runtime. It has endpoints that allow Automation
Composition Types to be created, read, updated, and deleted.

The body of the create and update end points is a TOSCA Service/Topology template that
defines the new or changed Automation Composition Type. The update and delete endpoints take a
reference to the Automation Composition Type. The incoming TOSCA is verified and checked for
referential integrity. On delete requests, a check is made to ensure that no Automation
Composition Instances exist for the Automation Composition Type to be deleted.

.. csv-table::
   :header: "Commissioning API"
   :widths: 10

   `ACM-R Commissioning Swagger <./local-swagger.html#tag/Automation-Composition-Definition>`_


Instantiation API
=================

The instantiation API has two functions:

#. Creation, Reading, Update, and Deletion of Automation Composition Instances.
#. Instantiation and lifecycle management of Automation Composition Instances on participants.

The Instantiation API is used by the CLAMP GUI.

Instantiation Automation Composition Instance CRUD
--------------------------------------------------

This sub API allows for the creation, read, update, and deletion of Automation Composition
Instances. The endpoints for create and update take a JSON body that describes the Automation
Composition Instance. The endpoints for read and delete take a Automation Composition Instance
ID to determine which Automation Composition Instance to act on. For the delete endpoint, a check
is made to ensure that the Automation Composition Instance is not instantiated on participants.

A call to the update endpoint for a Automation Composition Instance follows the semantics described
here: :ref:`4.1 Management of Automation Composition Instance Configurations
<management-acm-instance-configs>`.

.. csv-table::
   :header: "Instantiation API"
   :widths: 10

   `ACM-R Instantiation Swagger <./local-swagger.html#tag/Automation-Composition-Instance>`_


Instantiation Automation Composition Instance Lifecycle Management
------------------------------------------------------------------

This sub API is used to manage the lifecycle of Automation Composition Instances. An Automation
Composition Instance can be in the states described here: :ref:`2.1 Automation Composition Instance
States <acm-instance-states>`. Managing the lifecycle of an Automation Composition Instance amounts
to steering the Automation Composition through its states.

The sub API allows upgrades and downgrades of Automation Composition Instances to be pushed to
participants following the semantics described here: :ref:`4.1 Management of Automation Composition
Instance Configurations <management-acm-instance-configs>`. When the API is used to update the
participants on a Automation Composition Instance, the new/upgraded/downgraded definition of the
Automation Composition is pushed to the participants. Note that the API asks the participants in an
Automation Composition Instance to perform the update, it is the responsibility of the participants
to execute the update and report the result using the protocols described here: :ref:`CLAMP
Participants <clamp-acm-participants>`. The progress and result of an update can be monitored
using the :ref:`Monitoring API <monitoring-api>`.

The sub API also allows a state change of an Automation Composition Instance to be ordered. The
required state of the Automation Composition Instance is pushed to participants in an Automation
Composition Instance using the API. Note that the API asks the participants in an Automation
Composition Instance to perform the state change, it is the responsibility of the participants to
execute the state change and report the result using the protocols described here: :ref:`CLAMP
Participants <clamp-acm-participants>`. The progress and result of a state change can be monitored
using the `Monitoring API <monitoring-api>`.

.. warning::
   The Swagger for the Instantiation Lifecycle Management API will appear here.

.. _monitoring-api:

Monitoring API
==============

The Monitoring API allows the state and statistics of Participants, Automation Composition
Instances and their Automation Composition Elements to be monitored. This API is used by the CLAMP
GUI. The API provides filtering so that specific Participants and Automation Composition Instances
can be retrieved. In addition, the quantity of statistical information to be returned can be
scoped.

.. csv-table::
   :header: "Monitoring API"
   :widths: 10

   `ACM-R Monitoring Swagger <./local-swagger.html#tag/Participant-Monitoring>`_


Pass Through API
================

This API allows information to be passed to Automation Composition Elements in an Automation
Composition.

.. warning::
   The requirements on this API are still under discussion.

.. warning::
   The Swagger for the Pass Through API will appear here.


End of Document
