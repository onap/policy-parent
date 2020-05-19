.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

###########
GUARD Actor
###########

.. contents::
    :depth: 3

Overview of GUARD Actor
#######################

Within ONAP Policy Framework, a GUARD is typically an implicit check performed at the
start of each operation and is performed by making a REST call to the XACML-PDP.
Previously, the request was built, and the REST call made, by the application.  However,
Guard checks have now been implemented using the new Actor framework.

Currently, there is a single operation, *Decision*, which is implemented by the java
class, *GuardOperation*.  This class is derived from *HttpOperation*.


Request
#######

A number of the request fields are populated from values specified in the
actor/operation's configuration parameters (e.g., "onapName").  Additional fields
are specified below.

Request ID
**********

The "requestId" field is set to a UUID.


Resource
********

The "resource" field is populated with a *Map* containing a single item, "guard".  The
value of the item is set to the contents of the *payload* specified within the
*ControlLoopOperationParams*.


Examples
########

Suppose the *ControlLoopOperationParams* were populated as follows:

.. code-block:: bash

        {
            "actor": "GUARD",
            "operation": "Decision",
            "payload": {
              "actor": "SO",
              "operation": "VF Module Create",
              "target": "OzVServer",
              "requestId": "c7c6a4aa-bb61-4a15-b831-ba1472dd4a65",
              "clname": "ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3",
              "vfCount": 2
            }
        }

An example of a request constructed by the actor using the above parameters, sent to the
GUARD REST server:

.. code-block:: bash

        {
          "ONAPName": "Policy",
          "ONAPComponent": "Drools PDP",
          "ONAPInstance": "Usecases",
          "requestId": "90ee99d2-f2d8-4d90-b162-605203c30180",
          "action": "guard",
          "resource": {
            "guard": {
              "actor": "SO",
              "operation": "VF Module Create",
              "target": "OzVServer",
              "requestId": "c7c6a4aa-bb61-4a15-b831-ba1472dd4a65",
              "clname": "ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3",
              "vfCount": 2
            }
          }
        }


An example response received from the GUARD REST service:

.. code-block:: bash

        {
            "status": "Permit",
            "advice": {},
            "obligations": {},
            "policies": {}
        }


Configuration of the GUARD Actor
################################

The following table specifies the fields that should be provided to configure the GUARD
actor.

=============================== =====================    ==================================================================
Field name                         type                             Description
=============================== =====================    ==================================================================
clientName                        string                  Name of the HTTP client to use to send the request to the
                                                          GUARD REST server.
timeoutSec                        integer (optional)      Maximum time, in seconds, to wait for a response to be received
                                                          from the REST server.  Defaults to 90s.
path                              string                  URI appended to the URL.  This field only applies to individual
                                                          operations; it does not apply at the actor level.  Note: the
                                                          *path* should not include a leading or trailing slash.
onapName                          string                  ONAP Name (e.g., "Policy")
onapComponent                     string                  ONAP Component (e.g., "Drools PDP")
onapInstance                      string                  ONAP Instance (e.g., "Usecases")
action                            string (optional)       Used to populate the "action" request field.
                                                          Defaults to "guard".
disabled                          boolean (optional)      **True**, to disable guard checks, **false** otherwise.
                                                          Defaults to *false*.
=============================== =====================    ==================================================================

The individual operations are configured using these same field names. However, all
of them, except the path, are optional, as they inherit their values from the
corresponding actor-level fields.
