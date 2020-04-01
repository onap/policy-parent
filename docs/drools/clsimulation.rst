
.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

**********************************************************
Control Loop Simulation and Injection of Messages Overview
**********************************************************

.. contents::
    :depth: 2

This section will cover how to interact with the PDP-D using telemetry commands. This assumes that you have a PDP-D running to interact with. Take a look at the page "Methods to run PDP-D" if you do not have a PDP-D running for testing purposes.

Telemetry
^^^^^^^^^
The username and password for the Telemetry commands are in *${POLICY_HOME}/config/engine.properties*.
If you are using Eclipse, the credentials can be found in the file **install-drools/src/files/base.conf** within the "drools-pdp" repository.
The environment variables $TELEMETRY_USER and $TELEMETRY_PASSWORD will also have the credentials if they have already been set.

Recall you can use the command "docker exec -it drools bash" to get the PDP-D running with Docker.

    .. code-block:: bash

      docker exec -it drools bash

Your terminal should now look similar to "policy@drools:/<path>". This indicates you are in the drools docker container. If you run "policy status" the controller should be running.

    .. image:: img/docker/policyStatus.png

To enter the telemetry subshell, use the command "telemetry".

    .. code-block:: bash

      telemetry

Use the "exit" command to exit the telemetry subshell. The terminal will now go back to the docker container.

    .. code-block:: bash

      exit

    .. image:: img/docker/credentials.png

Injecting messages:
-------------------

To inject messages, use the following command.  The injected message will look as if it came in from the specified topic and will be processed accordingly.

Use the command:

    .. code-block:: bash

        http --verify=no --default-scheme=https -a <userName>:<password> PUT :9696/policy/pdp/engine/topics/sources/<comm>/<topic>/events @<onsetFile> Content-Type:"text/plain"

The equivalent "curl" version:

    .. code-block:: bash

        curl --insecure --silent --user <userName>:<password> -X PUT --header "Content-Type: text/plain" --data @<onsetFile> https://localhost:9696/policy/pdp/engine/topics/sources/<comm>/<topic>/events

Note: you may have to replace "https" with "http" depending on how you are running the drools-pdp.

The <comm> is a messaging communication infrastructure in an ONAP installation. Depending on how a topic has been defined in the configuration, the <comm> is either "dmaap", "ueb", or "noop".
The default messaging communication infrastructure is "dmaap".

The <topic> is a specific topic name used to send and/or receive information. There are two types of topics:

1. **source** topics (Example: dmaap.source.topics=APPC-LCM-WRITE or dmaap.source.topics=APPC-CL)

2. **sink** topics (Example: dmaap.sink.topics=APPC-LCM-READ or dmaap.sink.topics=APPC-CL)

You can extract <comm> and <topic> from the following example:
Example: dmaap.sink.topics=APPC-LCM-READ

1. <comm>=dmaap

2. <topic>=APPC-LCM-READ

The onset is a json file that contains the data to inject as the onset.  The data contained depends on the use case. This is an example for the vFirewall usecase:

    .. code-block:: json
       :caption: vFirewall_Sample_Onset

        {
            "closedLoopControlName": "ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a",
            "closedLoopAlarmStart": 1463679805324,
            "closedLoopEventClient": "microservice.stringmatcher",
            "closedLoopEventStatus": "ONSET",
            "requestID": "c7c6a4aa-bb61-4a15-b831-ba1472dd4a65",
            "target_type": "VNF",
            "target": "generic-vnf.vnf-name",
            "AAI": {
                "vserver.is-closed-loop-disabled": "false",
                "vserver.prov-status": "ACTIVE",
                "generic-vnf.vnf-name": "fw0002vm002fw002",
                "vserver.vserver-name": "OzVServer"
            },
            "from": "DCAE",
            "version": "1.0.2"
        }

Getting Information
-------------------

To get the name(s) of the active controller(s), use:

    .. code-block:: bash

        curl --insecure --silent --user <username>:<password> -X GET https://localhost:9696/policy/pdp/engine/controllers | python -m json.tool

        # Example output when running PDP-D with Docker:

        policy@drools:/opt/app/policy/config$ echo $TELEMETRY_USER

        demo@people.osaaf.org

        policy@drools:/opt/app/policy/config$ echo $TELEMETRY_PASSWORD

        demo123456!

        policy@drools:/opt/app/policy/config$ curl --insecure --silent --user demo@people.osaaf.org:demo123456! -X GET https://localhost:9696/policy/pdp/engine/controllers | python -m json.tool
        [
            "frankfurt",
            "usecases"
        ]

To check the facts currently in working memory, use the following command.

    .. code-block:: bash

        curl --insecure --silent --user <username>:<password> -X GET https://localhost:9696/policy/pdp/engine/controllers/<controllerName>/drools/facts | python -m json.tool

        # Example output:

        policy@drools:/opt/app/policy/config$ curl --insecure --silent --user demo@people.osaaf.org:demo123456! -X GET https://localhost:9696/policy/pdp/engine/controllers/frankfurt/drools/facts/ | python -m json.tool
        {
            "frankfurt": 0
        }
        policy@drools:/opt/app/policy/config$ curl --insecure --silent --user demo@people.osaaf.org:demo123456! -X GET https://localhost:9696/policy/pdp/engine/controllers/usecases/drools/facts/ | python -m json.tool
        {
            "usecases": 0
        }

To get additional information about the controller, use:

    .. code-block:: bash

        curl --insecure --silent --user <username>:<password> -X GET https://localhost:9696/policy/pdp/engine/controllers/<controllerName> | python -m json.tool

        # Example output:

        policy@drools:/opt/app/policy/config$ curl --insecure --silent --user demo@people.osaaf.org:demo123456! -X GET https://localhost:9696/policy/pdp/engine/controllers/frankfurt/ | python -m json.tool
        {
            "alive": true,
            "name": "frankfurt",
            "topicSinks": [
                {
                    "effectiveTopic": "APPC-CL",
                    "topicCommInfrastructure": "NOOP",
                    "servers": [
                        "NOOP"
                    ],
                    "alive": true,
                    "topic": "APPC-CL",
                    "recentEvents": [],
                    "locked": false
                },
                {
                    "effectiveTopic": "APPC-LCM-READ",
                    "topicCommInfrastructure": "NOOP",
                    "servers": [
                        "NOOP"
                    ],
                    "alive": true,
                    "topic": "APPC-LCM-READ",
                    "recentEvents": [],
                    "locked": false
                },
                {
                    "effectiveTopic": "POLICY-CL-MGT",
                    "topicCommInfrastructure": "NOOP",
                    "servers": [
                        "NOOP"
                    ],
                    "alive": true,
                    "topic": "POLICY-CL-MGT",
                    "recentEvents": [],
                    "locked": false
                },
                {
                    "effectiveTopic": "SDNR-CL",
                    "topicCommInfrastructure": "NOOP",
                    "servers": [
                        "NOOP"
                    ],
                    "alive": true,
                    "topic": "SDNR-CL",
                    "recentEvents": [],
                    "locked": false
                },
                {
                    "effectiveTopic": "DCAE_CL_RSP",
                    "topicCommInfrastructure": "NOOP",
                    "servers": [
                        "NOOP"
                    ],
                    "alive": true,
                    "topic": "DCAE_CL_RSP",
                    "recentEvents": [],
                    "locked": false
                }
            ],
            "drools": {
                "sessions": [
                    "frankfurt"
                ],
                "alive": true,
                "brained": true,
                "groupId": "org.onap.policy.drools-applications.controlloop.common",
                "recentSourceEvents": [],
                "version": "1.6.0",
                "modelClassLoaderHash": -1185895883,
                "baseDomainNames": [
                    "onap.policies.controlloop.operational.common.Drools",
                    "onap.policies.controlloop.Operational"
                ],
                "artifactId": "controller-frankfurt",
                "recentSinkEvents": [],
                "sessionCoordinates": [
                    "org.onap.policy.drools-applications.controlloop.common:controller-frankfurt:1.6.0:frankfurt"
                ],
                "locked": false
            },
            "policyTypes": [
                {
                    "name": "onap.policies.controlloop.operational.common.Drools",
                    "version": "1.0.0"
                },
                {
                    "name": "onap.policies.controlloop.Operational",
                    "version": "1.0.0"
                }
            ],
            "locked": false,
            "topicSources": [
                {
                    "effectiveTopic": "DCAE_TOPIC",
                    "topicCommInfrastructure": "NOOP",
                    "servers": [
                        "NOOP"
                    ],
                    "alive": false,
                    "topic": "DCAE_TOPIC",
                    "recentEvents": [],
                    "locked": false
                },
                {
                    "effectiveTopic": "APPC-CL",
                    "topicCommInfrastructure": "NOOP",
                    "servers": [
                        "NOOP"
                    ],
                    "alive": false,
                    "topic": "APPC-CL",
                    "recentEvents": [],
                    "locked": false
                },
                {
                    "effectiveTopic": "APPC-LCM-WRITE",
                    "topicCommInfrastructure": "NOOP",
                    "servers": [
                        "NOOP"
                    ],
                    "alive": false,
                    "topic": "APPC-LCM-WRITE",
                    "recentEvents": [],
                    "locked": false
                },
                {
                    "effectiveTopic": "SDNR-CL-RSP",
                    "topicCommInfrastructure": "NOOP",
                    "servers": [
                        "NOOP"
                    ],
                    "alive": false,
                    "topic": "SDNR-CL-RSP",
                    "recentEvents": [],
                    "locked": false
                }
            ]
        }

Within the telemetry subshell, it is easy to get information. Simply navigate to a specific directory using "cd". Use the "get" command to get information. This is a shorter alternatve to using the "curl" requests as shown above.

To get information about the engine:

    .. image:: img/docker/getEngine.png

To list the names of the active controllers:

    .. image:: img/docker/getControllers.png

To get information about the specific "frankfurt" controller:

    .. image:: img/docker/getFrankfurt.png

To get information about the PDP-D environment:

    .. image:: img/docker/getEnvironment.png

To get a list of features that are currently enabled:

    .. image:: img/docker/getFeatures.png

Simulators
^^^^^^^^^^

Currently, there are 4 supported simulators: A&AI, SO, vFC, and guard.  When they are up, they are accessed via localhost on the following ports:

1. A&AI - localhost:6666

2. SO - localhost:6667

3. vFC - localhost:6668

4. guard - localhost:6669


They all respond with hard-coded values representing their various success messages except for with certain inputs.  For the A&AI simulator, if the value being queried with a “GET” query is “getFail” the simulator returns an exception message, if the value being queried in a “GET” query is “disableClosedLoop” the simulator returns a response with the value of “is-closed-loop-disabled” set to true, and if the value being queried in a named query is “error” the response from the simulator is A&AI’s failure message.

The other simulator that can return multiple responses is the guard simulator, and that returns a deny response if the closed loop control name passed in is “denyGuard”.

Using the Simulators
--------------------

To check the status of the simulators, run the command: "*policy status*".  If the feature "controlloop-utils" is enabled, the simulators are being used, otherwise, they are not.

**Turning on the simulators**

    - First, make sure the controller is off by running the command “*policy stop*”.
    - Then turn the feature on with the command “*features enable controlloop-utils*”.
    - Finally restart the controller by running “*policy start*”.
    - Run “*features status*” again and the *feature controlloop-utils* will be **enabled**.

**Turning the simulators off**

    - First, make sure the controller is off by running the command “*policy stop*”.
    - Then turn the feature off with the command “*features disable controlloop-utils*”.
    - Finally restart the controller by running “*policy start*”.
    - Run “*features status*” again and the *feature controlloop-utils* will be **disabled**.

**For Junits**

    For Junits, the package *org.onap.policy.simulators* is needed.  In the Util class, there are six methods to start the six different simulators: *buildAaiSim()*, *buildSoSim()*, *buildVfcSim()*, *buildGuardSim()*, *buildSdnc()*, and *buildDmaap()*.  Once the method is called, the simulator should be up and waiting to respond to requests.  To bring down the simulators, call *HttpServletServer.factory.destroy()*.

Sample Responses
^^^^^^^^^^^^^^^^

A&AI
--------

    .. code-block:: bash
       :caption: vnf-GET-response

        {
         "vnf-id": vnfId, // vnfId will be the vnfId you query on.  If you query on a vnfName, the id will be "error" if the name is "error", "5e49ca06-2972-4532-9ed4-6d071588d792" otherwise
         "vnf-name": vnfName, // vnfName will be the vnfName you query on.  If you query on a vnfId, the name will be "USUCP0PCOIL0110UJRT01"
         "vnf-type": "RT",
         "service-id": "d7bb0a21-66f2-4e6d-87d9-9ef3ced63ae4",
         "equipment-role": "UCPE",
         "orchestration-status": "created",
         "management-option": "ATT",
         "ipv4-oam-address": "32.40.68.35",
         "ipv4-loopback0-address": "32.40.64.57",
         "nm-lan-v6-address": "2001:1890:e00e:fffe::1345",
         "management-v6-address": "2001:1890:e00e:fffd::36",
         "in-maint": false,
         "prov-status":"ACTIVE",
         "is-closed-loop-disabled": isDisabled, // isDisabled will be true if the vnf name/Id you query on is disableClosedLoop, false otherwise
         "resource-version": "1493389458092",
         "relationship-list": {
          "relationship": [{
           "related-to": "service-instance",
           "related-link": "/aai/v11/business/customers/customer/1610_Func_Global_20160817084727/service-subscriptions/service-subscription/uCPE-VMS/service-instances/service-instance/USUCP0PCOIL0110UJZZ01",
           "relationship-data": [{
            "relationship-key": "customer.global-customer-id",
            "relationship-value": "1610_Func_Global_20160817084727"
           }, {
            "relationship-key": "service-subscription.service-type",
            "relationship-value": "uCPE-VMS"
           }, {
            "relationship-key": "service-instance.service-instance-id",
            "relationship-value": "USUCP0PCOIL0110UJZZ01"
           }],
           "related-to-property": [{
            "property-key": "service-instance.service-instance-name"
           }]
          }, {
           "related-to": "vserver",
           "related-link": "/aai/v11/cloud-infrastructure/cloud-regions/cloud-region/att-aic/AAIAIC25/tenants/tenant/USUCP0PCOIL0110UJZZ01%3A%3AuCPE-VMS/vservers/vserver/3b2558f4-39d8-40e7-bfc7-30660fb52c45",
           "relationship-data": [{
            "relationship-key": "cloud-region.cloud-owner",
            "relationship-value": "att-aic"
           }, {
            "relationship-key": "cloud-region.cloud-region-id",
            "relationship-value": "AAIAIC25"
           }, {
            "relationship-key": "tenant.tenant-id",
            "relationship-value": "USUCP0PCOIL0110UJZZ01::uCPE-VMS"
           }, {
            "relationship-key": "vserver.vserver-id",
            "relationship-value": "3b2558f4-39d8-40e7-bfc7-30660fb52c45"
           }],
           "related-to-property": [{
            "property-key": "vserver.vserver-name",
            "property-value": "USUCP0PCOIL0110UJZZ01-vsrx"
           }]
          }]
         }


    .. code-block:: bash
       :caption: vnf-GET-fail

        // This is returned if you query on the value "getFail"
        {
         "requestError": {
          "serviceException": {
           "messageId": "SVC3001",
           "text": "Resource not found for %1 using id %2 (msg=%3) (ec=%4)",
           "variables": ["GET", "network/generic-vnfs/generic-vnf/getFail", "Node Not Found:No Node of type generic-vnf found at network/generic-vnfs/generic-vnf/getFail", "ERR.5.4.6114"]
          }
         }
        }


    .. code-block:: bash
       :caption: vserver-GET-response

        {
         "vserver": [{
          "vserver-id": "d0668d4f-c25e-4a1b-87c4-83845c01efd8",
          "vserver-name": vserverName, // The value you query on
          "vserver-name2": "vjunos0",
          "vserver-selflink": "https://aai-ext1.test.att.com:8443/aai/v7/cloud-infrastructure/cloud-regions/cloud-region/att-aic/AAIAIC25/tenants/tenant/USMSO1SX7NJ0103UJZZ01%3A%3AuCPE-VMS/vservers/vserver/d0668d4f-c25e-4a1b-87c4-83845c01efd8",
          "in-maint": false,
          "prov-status":"ACTIVE",
          "is-closed-loop-disabled": isDisabled, // True if the vserverName is "disableClosedLoop", false otherwise
          "resource-version": "1494001931513",
          "relationship-list": {
           "relationship": [{
            "related-to": "generic-vnf",
            "related-link": "/aai/v11/network/generic-vnfs/generic-vnf/e1a41e99-4ede-409a-8f9d-b5e12984203a",
            "relationship-data": [{
             "relationship-key": "generic-vnf.vnf-id",
             "relationship-value": "e1a41e99-4ede-409a-8f9d-b5e12984203a"
            }],
            "related-to-property": [{
             "property-key": "generic-vnf.vnf-name",
             "property-value": "USMSO1SX7NJ0103UJSW01"
            }]
           }, {
            "related-to": "pserver",
            "related-link": "/aai/v11/cloud-infrastructure/pservers/pserver/USMSO1SX7NJ0103UJZZ01",
            "relationship-data": [{
             "relationship-key": "pserver.hostname",
             "relationship-value": "USMSO1SX7NJ0103UJZZ01"
            }],
            "related-to-property": [{
             "property-key": "pserver.pserver-name2"
            }]
           }]
          }
         }]
        }


    .. code-block:: bash
       :caption: vserver-GET-error

        // This is returned if you query on the value "getFail"
        {
         "requestError": {
          "serviceException": {
           "messageId": "SVC3001",
           "text": "Resource not found for %1 using id %2 (msg=%3) (ec=%4)",
           "variables": ["GET", "nodes/vservers", "Node Not Found:No Node of type generic-vnf found at nodes/vservers", "ERR.5.4.6114"]
          }
         }
        }


    .. code-block:: bash
       :caption: vnf-NamedQuery-response

        {
          "inventory-response-item": [
            {
              "model-name": "service-instance",
              "generic-vnf": {
                "vnf-id": "vnfId",  //vnfId will be the vnfId you query on
                "vnf-name": "ZRDM2MMEX39",
                "vnf-type": "vMME Svc Jul 14/vMME VF Jul 14 1",
                "service-id": "a9a77d5a-123e-4ca2-9eb9-0b015d2ee0fb",
                "prov-status": "ACTIVE",
                "in-maint": false,
                "is-closed-loop-disabled": false,
                "resource-version": "1503082370097",
                "model-invariant-id": "82194af1-3c2c-485a-8f44-420e22a9eaa4",
                "model-version-id": "46b92144-923a-4d20-b85a-3cbd847668a9"
              },
              "extra-properties": {
                "extra-property": []
              },
              "inventory-response-items": {
                "inventory-response-item": [
                  {
                    "model-name": "service-instance",
                    "service-instance": {
                      "service-instance-id": "37b8cdb7-94eb-468f-a0c2-4e3c3546578e",
                      "service-instance-name": "Changed Service Instance NAME",
                      "resource-version": "1503082993532",
                      "model-invariant-id": "82194af1-3c2c-485a-8f44-420e22a9eaa4",
                      "model-version-id": "46b92144-923a-4d20-b85a-3cbd847668a9"
                    },
                    "extra-properties": {
                      "extra-property": []
                    },
                    "inventory-response-items": {
                      "inventory-response-item": [
                        {
                          "model-name": "pnf",
                          "generic-vnf": {
                            "vnf-id": "pnfVnfId",   // pnfVnfId is UUID generated from ${pnfVnfName}
                            "vnf-name": "pnfVnfName",   // pnfVnfName is pnf-test-${vnfId}
                            "vnf-type": "vMME Svc Jul 14/vMME VF Jul 14 1",
                            "service-id": "a9a77d5a-123e-4ca2-9eb9-0b015d2ee0fb",
                            "in-maint": false,
                            "is-closed-loop-disabled": false,
                            "resource-version": "1504013830207",
                            "model-invariant-id": "862b25a1-262a-4961-bdaa-cdc55d69785a",
                            "model-version-id": "e9f1fa7d-c839-418a-9601-03dc0d2ad687"
                          },
                          "extra-properties": {
                            "extra-property": []
                          }
                        },
                        {
                          "model-name": "service-instance",
                          "generic-vnf": {
                            "vnf-id": "serviceInstanceVnfId",   // serviceInstanceVnfId is UUID generated from ${serviceInstanceVnfName}
                            "vnf-name": "serviceInstanceVnfName",   // serviceInstanceVnfName is service-instance-test-${vnfId}
                            "vnf-type": "vMME Svc Jul 14/vMME VF Jul 14 1",
                            "service-id": "a9a77d5a-123e-4ca2-9eb9-0b015d2ee0fb",
                            "in-maint": false,
                            "is-closed-loop-disabled": false,
                            "resource-version": "1504014833841",
                            "model-invariant-id": "Eace933104d443b496b8.nodes.heat.vpg",
                            "model-version-id": "46b92144-923a-4d20-b85a-3cbd847668a9"
                          },
                          "extra-properties": {
                            "extra-property": []
                          }
                        }
                      ]
                    }
                  }
                ]
              }
            }
          ]
        }


    .. code-block:: bash
       :caption: vserver-NamedQuery-response

        {
          "inventory-response-item": [
            {
              "vserver": {
                "vserver-id": "6ed3642c-f7a1-4a7c-9290-3d51fe1531eb",
                "vserver-name": "zdfw1lb01lb02",
                "vserver-name2": "zdfw1lb01lb02",
                "prov-status": "ACTIVE",
                "vserver-selflink": "http://10.12.25.2:8774/v2.1/41d6d38489bd40b09ea8a6b6b852dcbd/servers/6ed3642c-f7a1-4a7c-9290-3d51fe1531eb",
                "in-maint": false,
                "is-closed-loop-disabled": false,
                "resource-version": "1510606403522"
              },
              "extra-properties": {
                "extra-property": []
              },
              "inventory-response-items": {
                "inventory-response-item": [
                  {
                    "model-name": "vLoadBalancer",
                    "generic-vnf": {
                      "vnf-id": "db373a8d-f7be-4d02-8ac8-6ca4c305d144",
                      "vnf-name": "Vfmodule_vLB1113",
                      "vnf-type": "vLoadBalancer-1106/vLoadBalancer 0",
                      "service-id": "66f157fc-4148-4880-95f5-e120677e98d1",
                      "prov-status": "PREPROV",
                      "in-maint": false,
                      "is-closed-loop-disabled": false,
                      "resource-version": "1510604011851",
                      "model-invariant-id": "cee050ed-92a5-494f-ab04-234307a846dc",
                      "model-version-id": "fd65becc-6b2c-4fe8-ace9-cc29db9a3da2"
                    },
                    "extra-properties": {
                      "extra-property": [
                        {
                          "property-name": "model-ver.model-version-id",
                          "property-value": "fd65becc-6b2c-4fe8-ace9-cc29db9a3da2"
                        },
                        {
                          "property-name": "model-ver.model-name",
                          "property-value": "vLoadBalancer"
                        },
                        {
                          "property-name": "model.model-type",
                          "property-value": "resource"
                        },
                        {
                          "property-name": "model.model-invariant-id",
                          "property-value": "cee050ed-92a5-494f-ab04-234307a846dc"
                        },
                        {
                          "property-name": "model-ver.model-version",
                          "property-value": "1.0"
                        }
                      ]
                    },
                    "inventory-response-items": {
                      "inventory-response-item": [
                        {
                          "model-name": "vLoadBalancer-1106",
                          "service-instance": {
                            "service-instance-id": "3b12f31f-8f2d-4f5c-b875-61ff1194b941",
                            "service-instance-name": "vLoadBalancer-1113",
                            "resource-version": "1510603936425",
                            "model-invariant-id": "1321d60d-f7ff-4300-96c2-6bf0b3268b7a",
                            "model-version-id": "732d4692-4b97-46f9-a996-0b3339e88c50"
                          },
                          "extra-properties": {
                            "extra-property": [
                              {
                                "property-name": "model-ver.model-version-id",
                                "property-value": "732d4692-4b97-46f9-a996-0b3339e88c50"
                              },
                              {
                                "property-name": "model-ver.model-name",
                                "property-value": "vLoadBalancer-1106"
                              },
                              {
                                "property-name": "model.model-type",
                                "property-value": "service"
                              },
                              {
                                "property-name": "model.model-invariant-id",
                                "property-value": "1321d60d-f7ff-4300-96c2-6bf0b3268b7a"
                              },
                              {
                                "property-name": "model-ver.model-version",
                                "property-value": "1.0"
                              }
                            ]
                          }
                        },
                        {
                          "model-name": "Vloadbalancer..base_vlb..module-0",
                          "vf-module": {
                            "vf-module-id": "e6b3e3eb-34e1-4c00-b8c1-2a4fbe479b12",
                            "vf-module-name": "Vfmodule_vLB1113-1",
                            "heat-stack-id": "Vfmodule_vLB1113-1/3dd6d900-772f-4fcc-a0cb-e250ab2bb4db",
                            "orchestration-status": "active",
                            "is-base-vf-module": true,
                            "resource-version": "1510604612557",
                            "model-invariant-id": "6d760188-9a24-451a-b05b-e08b86cb94f2",
                            "model-version-id": "93facad9-55f2-4fe0-9574-814c2bc2d071"
                          },
                          "extra-properties": {
                            "extra-property": [
                              {
                                "property-name": "model-ver.model-version-id",
                                "property-value": "93facad9-55f2-4fe0-9574-814c2bc2d071"
                              },
                              {
                                "property-name": "model-ver.model-name",
                                "property-value": "Vloadbalancer..base_vlb..module-0"
                              },
                              {
                                "property-name": "model.model-type",
                                "property-value": "resource"
                              },
                              {
                                "property-name": "model.model-invariant-id",
                                "property-value": "6d760188-9a24-451a-b05b-e08b86cb94f2"
                              },
                              {
                                "property-name": "model-ver.model-version",
                                "property-value": "1"
                              }
                            ]
                          }
                        },
                        {
                          "model-name": "Vloadbalancer..dnsscaling..module-1",
                          "vf-module": {
                            "vf-module-id": "dummy_db373a8d-f7be-4d02-8ac8-6ca4c305d144",
                            "vf-module-name": "dummy_db373a8d-f7be-4d02-8ac8-6ca4c305d144",
                            "is-base-vf-module": false,
                            "resource-version": "1510610079687",
                            "model-invariant-id": "356a1cff-71f2-4086-9980-a2927ce11c1c",
                            "model-version-id": "6b93d804-cfc8-4be3-92cc-9336d135859a"
                          },
                          "extra-properties": {
                            "extra-property": [
                              {
                                "property-name": "model-ver.model-version-id",
                                "property-value": "6b93d804-cfc8-4be3-92cc-9336d135859a"
                              },
                              {
                                "property-name": "model-ver.model-name",
                                "property-value": "Vloadbalancer..dnsscaling..module-1"
                              },
                              {
                                "property-name": "model.model-type",
                                "property-value": "resource"
                              },
                              {
                                "property-name": "model.model-invariant-id",
                                "property-value": "356a1cff-71f2-4086-9980-a2927ce11c1c"
                              },
                              {
                                "property-name": "model-ver.model-version",
                                "property-value": "1"
                              }
                            ]
                          }
                        },
                        {
                          "model-name": "Vloadbalancer..dnsscaling..module-1",
                          "vf-module": {
                            "vf-module-id": "my_module_db373a8d-f7be-4d02-8ac8-6ca4c305d144",
                            "vf-module-name": "my_module_1",
                            "is-base-vf-module": false,
                            "resource-version": "1510610079687",
                            "model-invariant-id": "356a1cff-71f2-4086-9980-a2927ce11c1c",
                            "model-version-id": "6b93d804-cfc8-4be3-92cc-9336d135859a"
                          },
                          "extra-properties": {
                            "extra-property": [
                              {
                                "property-name": "model-ver.model-version-id",
                                "property-value": "6b93d804-cfc8-4be3-92cc-9336d135859a"
                              },
                              {
                                "property-name": "model-ver.model-name",
                                "property-value": "Vloadbalancer..dnsscaling..module-1"
                              },
                              {
                                "property-name": "model.model-type",
                                "property-value": "resource"
                              },
                              {
                                "property-name": "model.model-invariant-id",
                                "property-value": "356a1cff-71f2-4086-9980-a2927ce11c1c"
                              },
                              {
                                "property-name": "model-ver.model-version",
                                "property-value": "1"
                              }
                            ]
                          }
                        },
                        {
                          "model-name": "Vloadbalancer..dnsscaling..module-1",
                          "vf-module": {
                            "vf-module-id": "my_module_db373a8d-f7be-4d02-8ac8-6ca4c305d144",
                            "vf-module-name": "my_module_2",
                            "is-base-vf-module": false,
                            "resource-version": "1510610079687",
                            "model-invariant-id": "356a1cff-71f2-4086-9980-a2927ce11c1c",
                            "model-version-id": "6b93d804-cfc8-4be3-92cc-9336d135859a"
                          },
                          "extra-properties": {
                            "extra-property": [
                              {
                                "property-name": "model-ver.model-version-id",
                                "property-value": "6b93d804-cfc8-4be3-92cc-9336d135859a"
                              },
                              {
                                "property-name": "model-ver.model-name",
                                "property-value": "Vloadbalancer..dnsscaling..module-1"
                              },
                              {
                                "property-name": "model.model-type",
                                "property-value": "resource"
                              },
                              {
                                "property-name": "model.model-invariant-id",
                                "property-value": "356a1cff-71f2-4086-9980-a2927ce11c1c"
                              },
                              {
                                "property-name": "model-ver.model-version",
                                "property-value": "1"
                              }
                            ]
                          }
                        }
                      ]
                    }
                  },
                  {
                    "tenant": {
                      "tenant-id": "41d6d38489bd40b09ea8a6b6b852dcbd",
                      "tenant-name": "Integration-SB-00",
                      "resource-version": "1509587770200"
                    },
                    "extra-properties": {
                      "extra-property": []
                    },
                    "inventory-response-items": {
                      "inventory-response-item": [
                        {
                          "cloud-region": {
                            "cloud-owner": "CloudOwner",
                            "cloud-region-id": "RegionOne",
                            "cloud-region-version": "v1",
                            "resource-version": "1509587770092"
                          },
                          "extra-properties": {
                            "extra-property": []
                          }
                        }
                      ]
                    }
                  }
                ]
              }
            }
          ]
        }


    .. code-block:: bash
       :caption: NamedQuery-error

        // This is returned if you query the value "error"
        {
         "requestError": {
          "serviceException": {
           "messageId": "SVC3001",
           "text": "Resource not found for %1 using id %2 (msg=%3) (ec=%4)",
           "variables": ["POST Search", "getNamedQueryResponse", "Node Not Found:No Node of type generic-vnf found for properties", "ERR.5.4.6114"]
          }
         }
        }


SO
------

    .. code-block:: bash
       :caption: SO-response

        {
         "requestReferences": {
          "requestId":"3e074e0e-5468-48f2-9226-51039d30fe5d"    // randomly generated UUID
          },
          "request": {
           "requestId":"a8f58372-aab2-45b8-9d36-c7a42e701c29",  // randomly generated UUID
           "requestStatus": {
            "percentProgress":0,
            "requestState":"COMPLETE",
            "wasRolledBack":false
           }
          }
         }
        }



vFC
-------

    .. code-block:: bash
       :caption: vFC-POST-response

        {
         "jobId": "1"
        }


    .. code-block:: bash
       :caption: vFC-GET-response

        {
         "jobId": jobId, //The jod id that you query
         "responseDescriptor": {
          "progress": "40",
          "status": "finished",
          "statusDescription": "OMC VMs are decommissioned in VIM",
          "errorCode": null,
          "responseId": 101,
          "responseHistoryList": [{
           "progress": "40",
           "status": "proccessing",
           "statusDescription": "OMC VMs are decommissioned in VIM",
           "errorCode": null,
           "responseId": "1"
          }, {
           "progress": "41",
           "status": "proccessing",
           "statusDescription": "OMC VMs are decommissioned in VIM",
           "errorCode": null,
           "responseId": "2"
          }]
         }
        }


GUARD
---------

    .. code-block:: bash
       :caption: permit-response

        {
         "decision": "PERMIT",
         "details": "Decision Permit. OK!"
        }


    .. code-block:: bash
       :caption: deny-response

        // This is returned if the closed loop name is denyGuard
        {
         "decision": "DENY",
         "details": "Decision Deny. You asked for it"
        }


End of Document
