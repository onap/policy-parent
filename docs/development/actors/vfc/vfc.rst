.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _vfc-label:

##########
VFC Actor
##########

.. contents::
    :depth: 3

Overview of VFC Actor
######################
ONAP Policy Framework enables VFC as one of the supported actors.

.. note::
  There has not been any support given to the Policy Framework project for the VFC Actor
  in several releases. Thus, the code and information provided is to the best of the
  knowledge of the team. If there are any questions or problems, please consult the VFC
  Project to help provide guidance.

VFC uses a REST-based
interface.  However, as requests may not complete right away, a REST-based polling
interface is used to check the status of the request.  The *jobId* is extracted
from each response and is appended to the *pathGet* configuration parameter to
generate the URL used to poll for completion.

Each operation supported by the actor is associated with its own java class, which is
responsible for populating the request structure appropriately and sending the request.
The operation-specific classes are all derived from the *VfcOperation* class, which is,
itself, derived from *HttpOperation*.  The following operations are currently supported:

- Restart


Request
#######

A number of nested structures are populated within the request.  Several of them are
populated from items found within the A&AI "enrichment" data provided by DCAE with
the ONSET event.  The following table lists the contents of some of the fields that
appear within these structures.

+----------------------------------+---------+----------------------------------------------------------------------+
| Field Name                       |  Type   |                         Description                                  |
+----------------------------------+---------+----------------------------------------------------------------------+
+----------------------------------+---------+----------------------------------------------------------------------+
| top level:                       |         |                                                                      |
+----------------------------------+---------+----------------------------------------------------------------------+
| *requestId*                      | string  |   Inserted by Policy. Maps to the UUID sent by DCAE i.e. the ID      |
|                                  |         |   used throughout the closed loop lifecycle to identify a request.   |
+----------------------------------+---------+----------------------------------------------------------------------+
| *nsInstanceId*                   | string  |   Set by Policy, using the                                           |
|                                  |         |   "service-instance.service-instance-id" property                    |
|                                  |         |   found within the enrichment data.                                  |
+----------------------------------+---------+----------------------------------------------------------------------+
+----------------------------------+---------+----------------------------------------------------------------------+
| healVnfData:                     |         |                                                                      |
+----------------------------------+---------+----------------------------------------------------------------------+
| *cause*                          | string  |   Set by Policy to the name of the operation.                        |
+----------------------------------+---------+----------------------------------------------------------------------+
| *vnfInstanceId*                  | string  |   Set by Policy, using the                                           |
|                                  |         |   "generic-vnf.vnf-id" property                                      |
|                                  |         |   found within the enrichment data.                                  |
+----------------------------------+---------+----------------------------------------------------------------------+
+----------------------------------+---------+----------------------------------------------------------------------+
| additionalParams:                |         |                                                                      |
+----------------------------------+---------+----------------------------------------------------------------------+
| *action*                         |         |   Set by Policy to the name of the operation.                        |
+----------------------------------+---------+----------------------------------------------------------------------+
+----------------------------------+---------+----------------------------------------------------------------------+
| actionvminfo:                    |         |                                                                      |
+----------------------------------+---------+----------------------------------------------------------------------+
| *vmid*                           | string  |   Set by Policy, using the                                           |
|                                  |         |   "vserver.vserver-id" property                                      |
|                                  |         |   found within the enrichment data.                                  |
+----------------------------------+---------+----------------------------------------------------------------------+
| *vmname*                         | string  |   Set by Policy, using the                                           |
|                                  |         |   "vserver.vserver-name" property                                    |
|                                  |         |   found within the enrichment data.                                  |
+----------------------------------+---------+----------------------------------------------------------------------+


Examples
########

Suppose the *ControlLoopOperationParams* were populated as follows:

.. code-block:: bash

        {
            TBD
        }

An example of a request constructed by the actor using the above parameters, sent to the
VFC REST server:

.. code-block:: bash

        {
            TBD
        }

An example response received to the initial request, from the VFC REST service:

.. code-block:: bash

        {
            TBD
        }

An example URL used for the "get" (i.e., poll) request subsequently sent to VFC:

.. code-block:: bash

        TBD

An example response received to the poll request, when VFC has not completed the request:

.. code-block:: bash

        {
            TBD
        }

An example response received to the poll request, when VFC has completed the request:

.. code-block:: bash

        {
            TBD
        }


Configuration of the VFC Actor
###############################

The following table specifies the fields that should be provided to configure the VFC
actor.

=============================== ====================    ==================================================================
Field name                         type                             Description
=============================== ====================    ==================================================================
clientName                        string                  Name of the HTTP client to use to send the request to the
                                                          VFC REST server.
timeoutSec                        integer (optional)      Maximum time, in seconds, to wait for a response to be received
                                                          from the REST server.  Defaults to 90s.
=============================== ====================    ==================================================================

The individual operations are configured using these same field names.  However, all
of them are optional, as they inherit their values from the
corresponding actor-level fields.  The following additional fields are specified at
the individual operation level.

=============================== ====================    ===================================================================
Field name                         type                             Description
=============================== ====================    ===================================================================
path                              string                  URI appended to the URL.  Note: this
                                                          should not include a leading or trailing slash.
maxGets                           integer (optional)      Maximum number of get/poll requests to make to determine the
                                                          final outcome of the request.  Defaults to 0 (i.e., no polling).
waitSecGet                        integer                 Time, in seconds, to wait between issuing "get" requests.
                                                          Defaults to 20s.
pathGet                           string                  Path to use when polling (i.e., issuing "get" requests).
                                                          Note: this should include a trailing slash, but no leading
                                                          slash.
=============================== ====================    ===================================================================
