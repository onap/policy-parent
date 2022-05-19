.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _clamp-policy-upgrade-label:

TOSCA Policy Testing Upgrade
############################

.. contents::
    :depth: 4

1 - Istanbul
============


**Step 1:** Clone Policy Clamp

.. code-block:: bash

    git clone "https://gerrit.onap.org/r/policy/clamp"

**Step 2:** Change Master Branch to Istanbul

.. code-block:: bash

    git checkout -b origin/istanbul

**Step 3:** Run Maven Clean Install

.. code-block:: bash

    mvn clean install

**Step 3:** Create the Database by going to /clamp/runtime/extra/bin-for-dev

.. code-block:: bash

    ./start-db.sh test

**Step 4:** Start Clamp Runtime by going to /clamp/runtime/extra/bin-for-dev

.. code-block:: bash

    ./start-backend.sh

**Step 5:** Start Control Loop Runtime by going to /clamp/runtime-controlloop

.. code-block:: bash

    java -jar target/policy-clamp-runtime-controlloop-6.1.5-SNAPSHOT

**Step 6:** Open up Postman and import the following collections

    `Download <collections/Control Loop Istanbul.postman_collection.json>`_

**Step 7:** Open up the folder Control Loop Istanbul/Commissioning

    Select POST Commission Tosca Service Template and run it.

    *- Should receive the following result*

.. code-block:: json
    :linenos:

    {
        "errorDetails": null,
        "affectedInstanceProperties": [
            {
                "name": "PMSH_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_MonitoringPolicyControlLoopElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.sample.GenericK8s_ControlLoopDefinition",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.database.PMSH_K8SMicroserviceControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.database.Local_K8SMicroserviceControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.policy.controlloop.PolicyControlLoopParticipant",
                "version": "2.3.1"
            },
            {
                "name": "org.onap.controlloop.HttpControlLoopParticipant",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.domain.database.Http_PMSHMicroserviceControlLoopElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_OperationalPolicyControlLoopElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.database.Local_K8SMicroserviceControlLoopElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_MonitoringPolicyControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.DerivedPolicyControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.k8s.controlloop.K8SControlLoopParticipant",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.domain.pmsh.DerivedDerivedPolicyControlLoopElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_OperationalPolicyControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.sample.GenericK8s_ControlLoopDefinition_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.policy.controlloop.PolicyControlLoopParticipant_Instance1",
                "version": "2.3.1"
            },
            {
                "name": "org.onap.k8s.controlloop.K8SControlLoopParticipant_Instance1",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.controlloop.HttpControlLoopParticipant_Instance1",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.domain.pmsh.DerivedDerivedPolicyControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.database.Http_PMSHMicroserviceControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.database.PMSH_K8SMicroserviceControlLoopElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.DerivedPolicyControlLoopElement",
                "version": "1.2.3"
            }
        ]
    }

**Step 8:** To try out other endpoints try out the other postman collections inside commission folder

**Step 9:** To decommission the Tosca Service Template Select DELETE Tosca Service Template

    *- Should receive the following result*

.. code-block:: json
    :linenos:

    {
        "errorDetails": null,
        "affectedControlLoopDefinitions": [
            {
                "name": "ToscaServiceTemplateSimple",
                "version": "1.0.0"
            }
        ]
    }

**Step 10:** For Instance Properties select the following folder in postman Control Loop Istanbul/Instantiation

    Select POST Instance Properties

    *- Should receive the following result*

.. code-block:: json
    :linenos:

    {
        "errorDetails": null,
        "affectedInstanceProperties": [
            {
                "name": "PMSH_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_MonitoringPolicyControlLoopElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.sample.GenericK8s_ControlLoopDefinition",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.database.PMSH_K8SMicroserviceControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.database.Local_K8SMicroserviceControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.policy.controlloop.PolicyControlLoopParticipant",
                "version": "2.3.1"
            },
            {
                "name": "org.onap.controlloop.HttpControlLoopParticipant",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.domain.database.Http_PMSHMicroserviceControlLoopElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_OperationalPolicyControlLoopElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.database.Local_K8SMicroserviceControlLoopElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_MonitoringPolicyControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.DerivedPolicyControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.k8s.controlloop.K8SControlLoopParticipant",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.domain.pmsh.DerivedDerivedPolicyControlLoopElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_OperationalPolicyControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.sample.GenericK8s_ControlLoopDefinition_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.policy.controlloop.PolicyControlLoopParticipant_Instance1",
                "version": "2.3.1"
            },
            {
                "name": "org.onap.k8s.controlloop.K8SControlLoopParticipant_Instance1",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.controlloop.HttpControlLoopParticipant_Instance1",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.domain.pmsh.DerivedDerivedPolicyControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.database.Http_PMSHMicroserviceControlLoopElement_Instance1",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.database.PMSH_K8SMicroserviceControlLoopElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.DerivedPolicyControlLoopElement",
                "version": "1.2.3"
            }
        ]
    }

**Step 11:** To try out other endpoints try out the other postman collections inside Instantiation folder

**Step 12:** To delete Instance properties select DELETE Instance Properties

    *- Should receive the following result*

.. code-block:: json
    :linenos:

    {
        "errorDetails": null,
        "affectedControlLoops": [
            {
                "name": "PMSH_Instance1",
                "version": "1.2.3"
            }
        ]
    }

**Step 13:** For monitoring endpoints go to Control Loop Istanbul/Monitoring folder

2 - Jakarta
===========


**Step 1:** Clone Policy Clamp

.. code-block:: bash

    git clone "https://gerrit.onap.org/r/policy/clamp"

**Step 2:** Change Master Branch to Jakarta

.. code-block:: bash

    git checkout -b origin/jackarta

**Step 3:** Run Maven Clean Install

.. code-block:: bash

    mvn clean install

**Step 3:** Create the Database by going to /clamp/runtime/extra/bin-for-dev

.. code-block:: bash

    ./start-db.sh test

**Step 4:** Start Clamp Runtime by going to /clamp/runtime/extra/bin-for-dev

.. code-block:: bash

    ./start-backend.sh

**Step 5:** Start Automation Composition Runtime by going to /clamp/runtime-acm

.. code-block:: bash

    java -jar target/policy-clamp-runtime-acm-6.3.0-SNAPSHOT.jar

**Step 6:** Open up Postman and import the following collections

    `Download <collections/Automation Composition Jakarta.postman_collection.json>`_

**Step 7:** Open up the folder Automation Composition Jakarta/Commissioning

    Select POST Commission Tosca Service Template and run it.

    *- Should receive the following result*

.. code-block:: json
    :linenos:

    {
        "errorDetails": null,
        "affectedAutomationCompositionDefinitions": [
            {
                "name": "org.onap.domain.database.Http_PMSHMicroserviceAutomationCompositionElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.database.PMSH_K8SMicroserviceAutomationCompositionElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_MonitoringPolicyAutomationCompositionElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_OperationalPolicyAutomationCompositionElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.sample.GenericK8s_AutomationCompositionDefinition",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.policy.clamp.acm.HttpParticipant",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.policy.clamp.acm.KubernetesParticipant",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.policy.clamp.acm.PolicyParticipant",
                "version": "2.3.1"
            }
        ]
    }

**Step 8:** To try out other endpoints try out the other postman collections inside commission folder

**Step 9:** To decommission the Tosca Service Template Select DELETE Tosca Service Template

    *- Should receive the following result*

.. code-block:: json
    :linenos:

    {
        "errorDetails": null,
        "affectedAutomationCompositionDefinitions": [
            {
                "name": "ToscaServiceTemplateSimple",
                "version": "1.0.0"
            }
        ]
    }

**Step 10:** For Instance Properties select the following folder in postman Automation Composition Jackarta/Instantiation

    Select POST Instance Properties

    *- Should receive the following result*

.. code-block:: json
    :linenos:

    {
        "errorDetails": null,
        "affectedInstanceProperties": [
            {
                "name": "ATT",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.domain.sample.GenericK8s_AutomationCompositionDefinition",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.policy.clamp.acm.PolicyParticipant",
                "version": "2.3.1"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_OperationalPolicyAutomationCompositionElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_MonitoringPolicyAutomationCompositionElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.policy.clamp.acm.HttpParticipant",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.policy.clamp.acm.KubernetesParticipant-ATT",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.policy.clamp.acm.KubernetesParticipant",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.domain.database.Http_PMSHMicroserviceAutomationCompositionElement-ATT",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_OperationalPolicyAutomationCompositionElement-ATT",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.database.Http_PMSHMicroserviceAutomationCompositionElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.database.PMSH_K8SMicroserviceAutomationCompositionElement-ATT",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.pmsh.PMSH_MonitoringPolicyAutomationCompositionElement-ATT",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.policy.clamp.acm.PolicyParticipant-ATT",
                "version": "2.3.1"
            },
            {
                "name": "org.onap.policy.clamp.acm.HttpParticipant-ATT",
                "version": "2.3.4"
            },
            {
                "name": "org.onap.domain.database.PMSH_K8SMicroserviceAutomationCompositionElement",
                "version": "1.2.3"
            },
            {
                "name": "org.onap.domain.sample.GenericK8s_AutomationCompositionDefinition-ATT",
                "version": "1.2.3"
            }
        ]
    }

**Step 11:** To try out other endpoints try out the other postman collections inside Instantiation folder

**Step 12:** To delete Instance properties select DELETE Instance Properties

    *- Should receive the following result*

.. code-block:: json
    :linenos:

    {
        "errorDetails": null,
        "affectedAutomationCompositionDefinitions": [
            {
                "name": "ToscaServiceTemplateSimple",
                "version": "1.0.0"
            }
        ]
    }

**Step 13:** For monitoring endpoints go to Automation Composition Jakarta/Monitoring folder

