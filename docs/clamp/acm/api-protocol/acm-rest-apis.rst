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

:download:`Download Policy Automation Composition Commissioning API Swagger  <swagger/acm-comissioning.json>`

.. swaggerv2doc:: swagger/acm-comissioning.json


Instantiation API
=================

The instantiation API has two functions:

#. Creation, Reading, Update, and Deletion of Automation Composition Instances.
#. Instantiation and lifecycle management of Automation Composition Instances on participants

The Instantiation API is used by the CLAMP GUI.

Instantiation Automation Composition Instance CRUD
--------------------------------------------------

This sub API allows for the creation, read, update, and deletion of Automation Composition Instances.
The endpoints for create and update take a JSON body that describes the Automation Composition Instance.
The endpoints for read and delete take a Automation Composition Instance ID to determine which Automation
Composition Instance to act on. For the delete endpoint, a check is made to ensure that the Automation
Composition Instance is not instantiated on participants.

A call to the update endpoint for a Automation Composition Instance follow the semantics described here:
`4.1 Management of Automation Composition Instance Configurations <management-cl-instance-configs>`.

:download:`Download Policy Automation Composition Instantiation API Swagger  <swagger/acm-instantiation.json>`

.. swaggerv2doc:: swagger/acm-instantiation.json


Instantiation Automation Composition Instance Lifecycle Management
------------------------------------------------------------------

This sub API is used to manage the life cycle of Automation Composition Instances. A Automation Composition Instance
can be in the states described here: `2.1 Automation Composition Instance States <acm-instance-states>`.
Managing the life cycle of a Automation Composition Instance amounts to steering the Automation Composition through
its states.

The sub API allows upgrades and downgrades of Automation Composition Instances to be pushed to participants
following the semantics described here: `4.1 Management of Automation Composition Instance Configurations
<management-cl-instance-configs>`. When the API is used to update the participants on a Automation
Composition Instance, the new/upgraded/downgraded definition of the Automation Composition is pushed to the
participants. Note that the API asks the participants in a Automation Composition Instance to perform the
update, it is the responsibility of the participants to execute the update and report the result
using the protocols described here: `CLAMP Participants <#>`_. The progress and result of an update
can be monitored using the `Monitoring API <monitoring-api>`.

The sub API also allows a state change of a Automation Composition Instance to be ordered. The required state
of the Automation Composition Instance is pushed to participants in a Automation Composition Instance using the API.
Note that the API asks the participants in a Automation Composition Instance to perform the state change, it
is the responsibility of the participants to execute the state change and report the result using
the protocols described here: CLAMP Participants. The progress and result of a state change can be
monitored using the `Monitoring API <monitoring-api>`.

.. warning::
   The Swagger for the Instantiation Lifecycle Management API will appear here.

.. _monitoring-api:

Monitoring API
==============

The Monitoring API allows the state and statistics of Participants, Automation Composition Instances and their Automation Composition Elements to be monitored. This API is used by the CLAMP GUI. The API provides filtering so that specific Participants and Automation Composition Instances can be retrieved. In addition, the quantity of statistical information to be returned can be scoped.

:download:`Download Policy Automation Composition Monitoring API Swagger  <swagger/acm-monitoring.json>`

.. swaggerv2doc:: swagger/acm-monitoring.json

Pass Through API
================

This API allows information to be passed to Automation Composition Elements in a automation composition.

.. warning::
   The requirements on this API are still under discussion.

.. warning::
   The Swagger for the Pass Through API will appear here.


Participant Standalone API
==========================

This API allows a Participant to run in standalone mode and to run standalone Automation Composition Elements.

Kubernetes participant can also be deployed as a standalone application and provides REST end points
for onboarding helm charts to its local chart storage, installing and uninstalling of helm charts to
a kubernetes cluster. It also allows to configure a remote repository in kubernetes participant for
installing helm charts. User can onboard a helm chart along with the overrides yaml file, the chart
gets stored in to the local chart directory of kubernetes participant. The onboarded charts can be
installed, uninstalled. The GET API fetches all the available helm charts from the chart storage.

:download:`Download Policy Automation Composition Participant Standalone API Swagger  <swagger/k8sparticipant.json>`

.. swaggerv2doc:: swagger/k8sparticipant.json


Participant Simulator API
=========================

This API allows a Participant Simulator to be started and run for test purposes.

:download:`Download Policy Participant Simulator API Swagger  <swagger/participant-sim.json>`

.. swaggerv2doc:: swagger/participant-sim.json

End of Document
