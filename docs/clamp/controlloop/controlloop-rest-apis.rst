.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _controlloop-rest-apis-label:

REST APIs for CLAMP Control Loops
#################################


Commissioning API
=================

This API is a CRUD API that allows Control Loop Type definitions created in a design
environment to be commissioned on the CLAMP runtime. It has endpoints that allow Control
Loop Types to be created, read, updated, and deleted.

The body of the create and update end points is a TOSCA Service/Topology template that
defines the new or changed Control Loop Type. The update and delete endpoints take a
reference to the Control Loop Type. The incoming TOSCA is verified and checked for
referential integrity. On delete requests, a check is made to ensure that no Control
Loop Instances exist for the Control Loop Type to be deleted.

:download:`Download Policy Control Loop Commissioning API Swagger  <swagger/controlloop-comissioning.json.json>`

.. swaggerv2doc:: swagger/controlloop-comissioning.json


Instantiation API
=================

The instantiation API has two functions:

#. Creation, Reading, Update, and Deletion of Control Loop Instances.
#. Instantiation and lifecycle management of Control Loop Instances on participants

The Instantiation API is used by the CLAMP GUI.

Instantiation Control Loop Instance CRUD
----------------------------------------

This sub API allows for the creation, read, update, and deletion of Control Loop Instances.
The endpoints for create and update take a JSON body that describes the Control Loop Instance.
The endpoints for read and delete take a Control Loop Instance ID to determine which Control
Loop Instance to act on. For the delete endpoint, a check is made to ensure that the Control
Loop Instance is not instantiated on participants.

A call to the update endpoint for a Control Loop Instance follow the semantics described here:
`4.1 Management of Control Loop Instance Configurations <management-cl-instance-configs>`.

:download:`Download Policy Control Loop Instantiation API Swagger  <swagger/controlloop-instantiation.json>`

.. swaggerv2doc:: swagger/controlloop-instantiation.json


Instantiation Control Loop Instance Lifecycle Management
--------------------------------------------------------

This sub API is used to manage the life cycle of Control Loop Instances. A Control Loop Instance
can be in the states described here: `2.1 Control Loop Instance States <controlloop-instance-states>`.
Managing the life cycle of a Control Loop Instance amounts to steering the Control Loop through
its states.

The sub API allows upgrades and downgrades of Control Loop Instances to be pushed to participants
following the semantics described here: `4.1 Management of Control Loop Instance Configurations
<management-cl-instance-configs>`. When the API is used to update the participants on a Control
Loop Instance, the new/upgraded/downgraded definition of the Control Loop is pushed to the
participants. Note that the API asks the participants in a Control Loop Instance to perform the
update, it is the responsibility of the participants to execute the update and report the result
using the protocols described here: `CLAMP Participants <#>`_. The progress and result of an update
can be monitored using the `Monitoring API <monitoring-api>`.

The sub API also allows a state change of a Control Loop Instance to be ordered. The required state
of the Control Loop Instance is pushed to participants in a Control Loop Instance using the API.
Note that the API asks the participants in a Control Loop Instance to perform the state change, it
is the responsibility of the participants to execute the state change and report the result using
the protocols described here: CLAMP Participants. The progress and result of a state change can be
monitored using the `Monitoring API <monitoring-api>`.

.. warning::
   The Swagger for the Instantiation Lifecycle Management API will appear here.

.. _monitoring-api:

Monitoring API
==============

The Monitoring API allows the state and statistics of Participants, Control Loop Instances and their Control Loop Elements to be monitored. This API is used by the CLAMP GUI. The API provides filtering so that specific Participants and Control Loop Instances can be retrieved. In addition, the quantity of statistical information to be returned can be scoped.

:download:`Download Policy Control Loop Monitoring API Swagger  <swagger/controlloop-monitoring.json>`

.. swaggerv2doc:: swagger/controlloop-monitoring.json

Pass Through API
================

This API allows information to be passed to Control Loop Elements in a control loop.

.. warning::
   The requirements on this API are still under discussion.

.. warning::
   The Swagger for the Pass Through API will appear here.


Participant Standalone API
==========================

This API allows a Participant to run in standalone mode and to run standalone Control Loop Elements.

Kubernetes participant can also be deployed as a standalone application and provides REST end points
for onboarding helm charts to its local chart storage, installing and uninstalling of helm charts to
a kubernetes cluster. It also allows to configure a remote repository in kubernetes participant for
installing helm charts. User can onboard a helm chart along with the overrides yaml file, the chart
gets stored in to the local chart directory of kubernetes participant. The onboarded charts can be
installed, uninstalled. The GET API fetches all the available helm charts from the chart storage.

:download:`Download Policy Control Loop Participant Standalone API Swagger  <swagger/k8sparticipant.json>`

.. swaggerv2doc:: swagger/k8sparticipant.json


Participant Simulator API
=========================

This API allows a Participant Simulator to be started and run for test purposes.

:download:`Download Policy Participant Simulator API Swagger  <swagger/participant-sim.json>`

.. swaggerv2doc:: swagger/participant-sim.json

End of Document
