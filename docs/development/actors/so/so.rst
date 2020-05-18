.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _so-label:

##########
SO Actor
##########

.. contents::
    :depth: 3

Overview of SO Actor
######################
ONAP Policy Framework enables SO as one of the supported actors.  SO uses a REST-based
interface.  However, as requests may not complete right away, a REST-based polling
interface is used to check the status of the request.  The *requestId* is extracted
from the initial response and is appended to the *pathGet* configuration parameter to
generate the URL used to poll for completion.

Each operation supported by the actor is associated with its own java class, which is
responsible for populating the request structure appropriately and sending the request.
Note: the request may be issued via POST, DELETE, etc., depending on the operation.
The operation-specific classes are all derived from the *SoOperation* class, which is,
itself, derived from *HttpOperation*.  The following operations are currently supported:
*VF Module Create*, *VF Module Delete*.


Request
#######

A number of nested structures are populated within the request.  Several of them are
populated with data extracted from the A&AI Custom Query response that is retrieved
using the Target resource ID specified in the *ControlLoopOperationParams*.  The
following table lists the contents of some of the fields that appear within these
structures.

+----------------------------------+---------+----------------------------------------------------------------------+
| Field Name                       |  Type   |                         Description                                  |
+----------------------------------+---------+----------------------------------------------------------------------+
+----------------------------------+---------+----------------------------------------------------------------------+
| top level:                       |         |                                                                      |
+----------------------------------+---------+----------------------------------------------------------------------+
| *operationType*                  | string  |   Inserted by Policy. Name of the operation.                         |
+----------------------------------+---------+----------------------------------------------------------------------+
+----------------------------------+---------+----------------------------------------------------------------------+
| requestDetails:                  |         |                                                                      |
+----------------------------------+---------+----------------------------------------------------------------------+
| requestParameters                |         |   Applicable to *VF Module Create*.                                  |
|                                  |         |   Set by Policy from the *requestParameters* specified in the        |
|                                  |         |   *payload* of the *ControlLoopOperationParams*.                     |
|                                  |         |   The value is treated as a JSON string and decoded into an          |
|                                  |         |   *SoRequestParameters* object that is placed into this field.       |
+----------------------------------+---------+----------------------------------------------------------------------+
| configurationParameters          |         |   Applicable to *VF Module Create*.                                  |
|                                  |         |   Set by Policy from the *configurationParameters* specified in the  |
|                                  |         |   *payload* of the *ControlLoopOperationParams*.                     |
|                                  |         |   The value is treated as a JSON string and decoded into a           |
|                                  |         |   *List* of *Maps* that is placed into this field.                   |
+----------------------------------+---------+----------------------------------------------------------------------+
+----------------------------------+---------+----------------------------------------------------------------------+
| modelInfo:                       |         |   Set by Policy.  Copied from the *target* specified in the          |
|                                  |         |   *ControlLoopOperationParams*.                                      |
+----------------------------------+---------+----------------------------------------------------------------------+
+----------------------------------+---------+----------------------------------------------------------------------+
| cloudConfiguration:              |         |                                                                      |
+----------------------------------+---------+----------------------------------------------------------------------+
| *tenantId*                       | string  |   The ID of the "default" Tenant selected from the A&AI Custom Query |
|                                  |         |   response.                                                          |
+----------------------------------+---------+----------------------------------------------------------------------+
| *lcpCloudRegionId*               | string  |   The ID of the "default" Cloud Region selected from the A&AI Custom |
|                                  |         |   Query response.                                                    |
+----------------------------------+---------+----------------------------------------------------------------------+
+----------------------------------+---------+----------------------------------------------------------------------+
| relatedInstanceList[0]:          |         |   Applicable to *VF Module Create*.                                  |
|                                  |         |   The "default" Service Instance selected from the A&AI Custom Query |
|                                  |         |   response.                                                          |
+----------------------------------+---------+----------------------------------------------------------------------+
+----------------------------------+---------+----------------------------------------------------------------------+
| relatedInstanceList[1]:          |         |   Applicable to *VF Module Create*.                                  |
|                                  |         |   The VNF selected from the A&AI Custom Query                        |
|                                  |         |   response.                                                          |
+----------------------------------+---------+----------------------------------------------------------------------+


Examples
########

Suppose the *ControlLoopOperationParams* were populated as follows:

.. code-block:: bash

        {
            "actor": "SO",
            "operation": "Reroute",
            "target": {
                "modelInvariantId": "2246ebc9-9b9f-42d0-a5e4-0248324fb884",
                "modelName": "VlbCdsSb00..vdns..module-3",
                "modelVersion": "1",
                "modelCustomizationUuid": "3a74410a-6c74-4a32-94b2-71488be6da1a",
                "modelVersionId": "1f94cedb-f656-4ddb-9f55-60ba1fc7d4b1",
                "modelCustomizationId": "3a74410a-6c74-4a32-94b2-71488be6da1a",
                "modelUuid": "1f94cedb-f656-4ddb-9f55-60ba1fc7d4b1",
                "modelInvariantUuid": "2246ebc9-9b9f-42d0-a5e4-0248324fb884"
            },
            "context": {
                "cqdata": {
                    "tenant": {
                        "id": "41d6d38489bd40b09ea8a6b6b852dcbd"
                    },
                    "cloud-region": {
                        "id": "RegionOne"
                    },
                    "service-instance": {
                        "id": "c14e61b5-1ee6-4925-b4a9-b9c8dbfe3f34",
                        "modelInvariantId": "6418bb39-61e1-45fc-a36b-3f211bb846c7",
                        "modelName": "vLB_CDS_SB00_02",
                        "modelVersion": "1.0",
                        "modelVersionId": "d01d9dec-afb6-4a53-bd9e-2eb10ca07a51",
                        "modelUuid": "d01d9dec-afb6-4a53-bd9e-2eb10ca07a51",
                        "modelInvariantUuid": "6418bb39-61e1-45fc-a36b-3f211bb846c7"
                    },
                    "generic-vnf": [
                        {
                            "vnfId": "6636c4d5-f608-4376-b6d8-7977e98cb16d",
                            "vf-modules": [
                                {
                                    "modelInvariantId": "827356a9-cb60-4976-9713-c30b4f850b41",
                                    "modelName": "vLB_CDS_SB00",
                                    "modelVersion": "1.0",
                                    "modelCustomizationUuid": "6478f94b-0b20-4b44-afc0-94e48070586a",
                                    "modelVersionId": "ca3c4797-0cdd-4797-8bec-9a3ce78ac4da",
                                    "modelCustomizationId": "6478f94b-0b20-4b44-afc0-94e48070586a",
                                    "modelUuid": "ca3c4797-0cdd-4797-8bec-9a3ce78ac4da",
                                    "modelInvariantUuid": "827356a9-cb60-4976-9713-c30b4f850b41"
                                }
                            ]
                        }
                    ]
                }
            },
            "payload": {
                "requestParameters": "{\"usePreload\": false}",
                "configurationParameters": "[{\"ip-addr\": \"$.vf-module-topology.vf-module-parameters.param[16].value\", \"oam-ip-addr\": \"$.vf-module-topology.vf-module-parameters.param[30].value\"}]"
            }
        }

An example of a request constructed by the actor using the above parameters, sent to the
SO REST server:

.. code-block:: bash

    {
      "requestDetails": {
        "modelInfo": {
            "modelInvariantId": "2246ebc9-9b9f-42d0-a5e4-0248324fb884",
            "modelType": "vfModule",
            "modelName": "VlbCdsSb00..vdns..module-3",
            "modelVersion": "1",
            "modelCustomizationUuid": "3a74410a-6c74-4a32-94b2-71488be6da1a",
            "modelVersionId": "1f94cedb-f656-4ddb-9f55-60ba1fc7d4b1",
            "modelCustomizationId": "3a74410a-6c74-4a32-94b2-71488be6da1a",
            "modelUuid": "1f94cedb-f656-4ddb-9f55-60ba1fc7d4b1",
            "modelInvariantUuid": "2246ebc9-9b9f-42d0-a5e4-0248324fb884"
        },
        "cloudConfiguration": {
            "tenantId": "41d6d38489bd40b09ea8a6b6b852dcbd",
            "lcpCloudRegionId": "RegionOne"
        },
        "requestInfo": {
          "instanceName": "vfModuleName",
          "source": "POLICY",
          "suppressRollback": false,
          "requestorId": "policy"
        },
        "relatedInstanceList": [
          {
            "relatedInstance": {
                "instanceId": "c14e61b5-1ee6-4925-b4a9-b9c8dbfe3f34",
                "modelInfo": {
                    "modelInvariantId": "6418bb39-61e1-45fc-a36b-3f211bb846c7",
                    "modelType": "service",
                    "modelName": "vLB_CDS_SB00_02",
                    "modelVersion": "1.0",
                    "modelVersionId": "d01d9dec-afb6-4a53-bd9e-2eb10ca07a51",
                    "modelUuid": "d01d9dec-afb6-4a53-bd9e-2eb10ca07a51",
                    "modelInvariantUuid": "6418bb39-61e1-45fc-a36b-3f211bb846c7"
                }
            }
          },
          {
            "relatedInstance": {
                "instanceId": "6636c4d5-f608-4376-b6d8-7977e98cb16d",
                "modelInfo": {
                    "modelInvariantId": "827356a9-cb60-4976-9713-c30b4f850b41",
                    "modelType": "vnf",
                    "modelName": "vLB_CDS_SB00",
                    "modelVersion": "1.0",
                    "modelCustomizationUuid": "6478f94b-0b20-4b44-afc0-94e48070586a",
                    "modelVersionId": "ca3c4797-0cdd-4797-8bec-9a3ce78ac4da",
                    "modelCustomizationId": "6478f94b-0b20-4b44-afc0-94e48070586a",
                    "modelUuid": "ca3c4797-0cdd-4797-8bec-9a3ce78ac4da",
                    "modelInvariantUuid": "827356a9-cb60-4976-9713-c30b4f850b41"
                }
            }
          }
        ],
        "requestParameters": {
            "usePreload": false
        },
        "configurationParameters": [
            {
                "ip-addr": "$.vf-module-topology.vf-module-parameters.param[16].value",
                "oam-ip-addr": "$.vf-module-topology.vf-module-parameters.param[30].value"
            }
        ]
      }
    }

An example response received to the initial request, from the SO REST service:

.. code-block:: bash

        {
            "requestReferences": {
                "requestId": "70f28791-c271-4cae-b090-0c2a359e26d9",
                "instanceId": "68804843-18e0-41a3-8838-a6d90a035e1a",
                "requestSelfLink": "http://so.onap:8080/orchestrationRequests/v7/b789e4e6-0b92-42c3-a723-1879af9c799d"
            }
        }

An example URL used for the "get" (i.e., poll) request subsequently sent to SO:

.. code-block:: bash

        GET https://so.onap:6969/orchestrationRequests/v5/70f28791-c271-4cae-b090-0c2a359e26d9

An example response received to the poll request, when SO has not completed the request:

.. code-block:: bash

    {
        "request": {
            "requestId": "70f28791-c271-4cae-b090-0c2a359e26d9",
            "startTime": "Fri, 15 May 2020 12:12:50 GMT",
            "requestScope": "vfModule",
            "requestType": "scaleOut",
            "requestDetails": {
                "modelInfo": {
                    "modelInvariantId": "2246ebc9-9b9f-42d0-a5e4-0248324fb884",
                    "modelType": "vfModule",
                    "modelName": "VlbCdsSb00..vdns..module-3",
                    "modelVersion": "1",
                    "modelCustomizationUuid": "3a74410a-6c74-4a32-94b2-71488be6da1a",
                    "modelVersionId": "1f94cedb-f656-4ddb-9f55-60ba1fc7d4b1",
                    "modelCustomizationId": "3a74410a-6c74-4a32-94b2-71488be6da1a",
                    "modelUuid": "1f94cedb-f656-4ddb-9f55-60ba1fc7d4b1",
                    "modelInvariantUuid": "2246ebc9-9b9f-42d0-a5e4-0248324fb884"
                },
                "requestInfo": {
                    "source": "POLICY",
                    "instanceName": "vfModuleName",
                    "suppressRollback": false,
                    "requestorId": "policy"
                },
                "relatedInstanceList": [
                    {
                        "relatedInstance": {
                            "instanceId": "c14e61b5-1ee6-4925-b4a9-b9c8dbfe3f34",
                            "modelInfo": {
                                "modelInvariantId": "6418bb39-61e1-45fc-a36b-3f211bb846c7",
                                "modelType": "service",
                                "modelName": "vLB_CDS_SB00_02",
                                "modelVersion": "1.0",
                                "modelVersionId": "d01d9dec-afb6-4a53-bd9e-2eb10ca07a51",
                                "modelUuid": "d01d9dec-afb6-4a53-bd9e-2eb10ca07a51",
                                "modelInvariantUuid": "6418bb39-61e1-45fc-a36b-3f211bb846c7"
                            }
                        }
                    },
                    {
                        "relatedInstance": {
                            "instanceId": "6636c4d5-f608-4376-b6d8-7977e98cb16d",
                            "modelInfo": {
                                "modelInvariantId": "827356a9-cb60-4976-9713-c30b4f850b41",
                                "modelType": "vnf",
                                "modelName": "vLB_CDS_SB00",
                                "modelVersion": "1.0",
                                "modelCustomizationUuid": "6478f94b-0b20-4b44-afc0-94e48070586a",
                                "modelVersionId": "ca3c4797-0cdd-4797-8bec-9a3ce78ac4da",
                                "modelCustomizationId": "6478f94b-0b20-4b44-afc0-94e48070586a",
                                "modelUuid": "ca3c4797-0cdd-4797-8bec-9a3ce78ac4da",
                                "modelInvariantUuid": "827356a9-cb60-4976-9713-c30b4f850b41"
                            }
                        }
                    }
                ],
                "cloudConfiguration": {
                    "tenantId": "41d6d38489bd40b09ea8a6b6b852dcbd",
                    "tenantName": "Integration-SB-00",
                    "cloudOwner": "CloudOwner",
                    "lcpCloudRegionId": "RegionOne"
                },
                "requestParameters": {
                    "usePreload": false
                },
                "configurationParameters": [
                    {
                        "ip-addr": "$.vf-module-topology.vf-module-parameters.param[16].value",
                        "oam-ip-addr": "$.vf-module-topology.vf-module-parameters.param[30].value"
                    }
                ]
            },
            "instanceReferences": {
                "serviceInstanceId": "c14e61b5-1ee6-4925-b4a9-b9c8dbfe3f34",
                "vnfInstanceId": "6636c4d5-f608-4376-b6d8-7977e98cb16d",
                "vfModuleInstanceId": "68804843-18e0-41a3-8838-a6d90a035e1a",
                "vfModuleInstanceName": "vfModuleName"
            },
            "requestStatus": {
                "requestState": "IN_PROGRESS",
                "statusMessage": "FLOW STATUS: Execution of ActivateVfModuleBB has completed successfully, next invoking ConfigurationScaleOutBB (Execution Path progress: BBs completed = 4; BBs remaining = 2). TASK INFORMATION: Last task executed: Call SDNC RESOURCE STATUS: The vf module was found to already exist, thus no new vf module was created in the cloud via this request",
                "percentProgress": 68,
                "timestamp": "Fri, 15 May 2020 12:13:41 GMT"
            }
        }
    }

An example response received to the poll request, when SO has completed the request:

.. code-block:: bash

    {
        "request": {
            "requestId": "70f28791-c271-4cae-b090-0c2a359e26d9",
            "startTime": "Fri, 15 May 2020 12:12:50 GMT",
            "finishTime": "Fri, 15 May 2020 12:14:21 GMT",
            "requestScope": "vfModule",
            "requestType": "scaleOut",
            "requestDetails": {
                "modelInfo": {
                    "modelInvariantId": "2246ebc9-9b9f-42d0-a5e4-0248324fb884",
                    "modelType": "vfModule",
                    "modelName": "VlbCdsSb00..vdns..module-3",
                    "modelVersion": "1",
                    "modelCustomizationUuid": "3a74410a-6c74-4a32-94b2-71488be6da1a",
                    "modelVersionId": "1f94cedb-f656-4ddb-9f55-60ba1fc7d4b1",
                    "modelCustomizationId": "3a74410a-6c74-4a32-94b2-71488be6da1a",
                    "modelUuid": "1f94cedb-f656-4ddb-9f55-60ba1fc7d4b1",
                    "modelInvariantUuid": "2246ebc9-9b9f-42d0-a5e4-0248324fb884"
                },
                "requestInfo": {
                    "source": "POLICY",
                    "instanceName": "vfModuleName",
                    "suppressRollback": false,
                    "requestorId": "policy"
                },
                "relatedInstanceList": [
                    {
                        "relatedInstance": {
                            "instanceId": "c14e61b5-1ee6-4925-b4a9-b9c8dbfe3f34",
                            "modelInfo": {
                                "modelInvariantId": "6418bb39-61e1-45fc-a36b-3f211bb846c7",
                                "modelType": "service",
                                "modelName": "vLB_CDS_SB00_02",
                                "modelVersion": "1.0",
                                "modelVersionId": "d01d9dec-afb6-4a53-bd9e-2eb10ca07a51",
                                "modelUuid": "d01d9dec-afb6-4a53-bd9e-2eb10ca07a51",
                                "modelInvariantUuid": "6418bb39-61e1-45fc-a36b-3f211bb846c7"
                            }
                        }
                    },
                    {
                        "relatedInstance": {
                            "instanceId": "6636c4d5-f608-4376-b6d8-7977e98cb16d",
                            "modelInfo": {
                                "modelInvariantId": "827356a9-cb60-4976-9713-c30b4f850b41",
                                "modelType": "vnf",
                                "modelName": "vLB_CDS_SB00",
                                "modelVersion": "1.0",
                                "modelCustomizationUuid": "6478f94b-0b20-4b44-afc0-94e48070586a",
                                "modelVersionId": "ca3c4797-0cdd-4797-8bec-9a3ce78ac4da",
                                "modelCustomizationId": "6478f94b-0b20-4b44-afc0-94e48070586a",
                                "modelUuid": "ca3c4797-0cdd-4797-8bec-9a3ce78ac4da",
                                "modelInvariantUuid": "827356a9-cb60-4976-9713-c30b4f850b41"
                            }
                        }
                    }
                ],
                "cloudConfiguration": {
                    "tenantId": "41d6d38489bd40b09ea8a6b6b852dcbd",
                    "tenantName": "Integration-SB-00",
                    "cloudOwner": "CloudOwner",
                    "lcpCloudRegionId": "RegionOne"
                },
                "requestParameters": {
                    "usePreload": false
                },
                "configurationParameters": [
                    {
                        "ip-addr": "$.vf-module-topology.vf-module-parameters.param[16].value",
                        "oam-ip-addr": "$.vf-module-topology.vf-module-parameters.param[30].value"
                    }
                ]
            },
            "instanceReferences": {
                "serviceInstanceId": "c14e61b5-1ee6-4925-b4a9-b9c8dbfe3f34",
                "vnfInstanceId": "6636c4d5-f608-4376-b6d8-7977e98cb16d",
                "vfModuleInstanceId": "68804843-18e0-41a3-8838-a6d90a035e1a",
                "vfModuleInstanceName": "vfModuleName"
            },
            "requestStatus": {
                "requestState": "COMPLETE",
                "statusMessage": "STATUS: ALaCarte-VfModule-scaleOut request was executed correctly. FLOW STATUS: Successfully completed all Building Blocks RESOURCE STATUS: The vf module was found to already exist, thus no new vf module was created in the cloud via this request",
                "percentProgress": 100,
                "timestamp": "Fri, 15 May 2020 12:14:21 GMT"
            }
        }
    }


Configuration of the SO Actor
###############################

The following table specifies the fields that should be provided to configure the SO
actor.

=============================== ====================    ==================================================================
Field name                         type                             Description
=============================== ====================    ==================================================================
clientName                        string                  Name of the HTTP client to use to send the request to the
                                                          SO REST server.
timeoutSec                        integer (optional)      Maximum time, in seconds, to wait for a response to be received
                                                          from the REST server.  Defaults to 90s.
path                              string                  URI appended to the URL.  This field only applies to individual
                                                          operations; it does not apply at the actor level.  Note: the
                                                          *path* should not include a leading or trailing slash.
maxGets                           integer (optional)      Maximum number of get/poll requests to make to determine the
                                                          final outcome of the request.  Defaults to 20.
waitSecGet                        integer (optional)      Time, in seconds, to wait between issuing "get" requests.
                                                          Defaults to 20s.
pathGet                           string (optional)       Path to use when polling (i.e., issuing "get" requests).
                                                          Note: this should include a trailing slash, but no leading
                                                          slash.
=============================== ====================    ==================================================================

The individual operations are configured using these same field names.  However, all
of them, except the *path*, are optional, as they inherit their values from the
corresponding actor-level fields.
