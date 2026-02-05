.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

CLAMP Policy Participant Smoke Tests
------------------------------------

1. Introduction
***************

The Smoke testing of the policy participant is executed in a local CLAMP/Policy environment. The CLAMP-ACM interfaces interact with the Policy Framework to perform actions based on the state of the policy participant. The goal of the Smoke tests is the ensure that CLAMP Policy Participant and Policy Framework work together as expected.
All applications will be running by console, so they need to run with different ports. Configuration files should be changed accordingly.

+------------------------------+------------+
| Application                  |    Port    |
+==============================+============+
| Postgres                     |    5432    |
+------------------------------+------------+
| Zookeeper                    |    2181    |
+------------------------------+------------+
| Kafka                        | 29092/9092 |
+------------------------------+------------+
| policy-api                   |    6968    |
+------------------------------+------------+
| policy-pap                   |    6970    |
+------------------------------+------------+
| policy-clamp-runtime-acm     |    6969    |
+------------------------------+------------+
| onap/policy-clamp-ac-pf-ppnt |    8085    |
+------------------------------+------------+


2. Setup Guide
**************

This section will show the developer how to set up their environment to start testing in GUI with some instruction on how to carry out the tests. There are several prerequisites. Note that this guide is written by a Linux user - although the majority of the steps show will be exactly the same in Windows or other systems.

2.1 Prerequisites
=================

- Java 21
- Maven 3.9
- Git
- Refer to this guide for basic environment setup `Setting up dev environment <https://wiki.onap.org/display/DW/Setting+Up+Your+Development+Environment>`_

2.2 Cloning CLAMP automation composition and all dependency
===========================================================

Run the below commands to clone the required CLAMP automation composition and all modules:

.. code-block:: bash

    cd ~/git
    git clone https://gerrit.onap.org/r/policy/clamp clamp
    git clone https://gerrit.onap.org/r/policy/api api
    git clone https://gerrit.onap.org/r/policy/pap pap


Execution of the commands above results in the following directory hierarchy in your *~/git* directory:

    *  ~/git
    *  ~/git/api
    *  ~/git/clamp
    *  ~/git/pap


2.3 Building CLAMP automation composition and all dependency
============================================================

**Step 1:** Setting datasource.url, hibernate.ddl-auto and server.port in policy-api.
In the api repo, you should find the file 'main/src/main/resources/application.yaml'. This file may need to be altered as below:

.. literalinclude:: files/api-application.yaml
   :language: yaml


**Step 2:** Setting datasource.url, server.port, and api http client in policy-pap.
In the pap repo, you should find the file 'main/src/main/resources/application.yaml'. This file may need to be altered as below:

.. literalinclude:: files/pap-application.yaml
   :language: yaml


**Step 3:** Optionally, for a completely clean build, remove the ONAP built modules from your local repository.

    .. code-block:: bash

        rm -fr ~/.m2/repository/org/onap


**Step 4:** You can now build the Policy framework.

Build java artifacts and docker images:

    .. code-block:: bash

       cd ~/git/clamp
       mvn clean install -P docker -DskipTests
       cd ~/git/api
       mvn clean install -P docker -DskipTests
       cd ~/git/pap
       mvn clean install -P docker -DskipTests


2.4 Setting up the components
=============================

2.4.1 Postgres and Kafka Setup
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We will be using Docker to run our Postgres instance` and Zookeeper/Kafka. It will have a total of two databases running in Postgres.

- clampacm: the policy-clamp-runtime-acm db
- policyadmin: the policy-api db

**Step 1:** Create the *db-pg.conf* and *db-pg.sh* files in the directory *~/git*.

.. literalinclude:: files/db-pg.conf
   :language: yaml

.. literalinclude:: files/db-pg.sh
   :language: yaml


**Step 2:** Create the *wait_for_port.sh* file in a directory *~/git* with execution permission.

.. literalinclude:: files/wait_for_port.sh
   :language: sh


**Step 3:** Create the '*docker-compose.yaml*' using following code:

.. literalinclude:: files/docker-compose-policy.yaml
   :language: yaml


**Step 4:** Run the docker composition:

   .. code-block:: bash

      cd ~/git/
      docker compose up


2.4.2 Policy API
^^^^^^^^^^^^^^^^

In the policy-api repo, navigate to the "/main" directory. You can then run the following command to start the policy api:

.. code-block:: bash

    mvn spring-boot:run


2.4.3 Policy PAP
^^^^^^^^^^^^^^^^

In the policy-pap repo, navigate to the "/main" directory. You can then run the following command to start the policy pap:

.. code-block:: bash

    mvn spring-boot:run

2.4.4 ACM Runtime
^^^^^^^^^^^^^^^^^

To start the clampacm runtime we need to go the "runtime-acm" directory in the clamp repo. You can then run the following command to start the clampacm runtime:

.. code-block:: bash

    cd ~/git/clamp/runtime-acm
    java -DRUNTIME_USER=runtimeUser -DRUNTIME_PASSWORD=zb\!XztG34 \
         -DSQL_HOST=localhost -DSQL_PORT=5432 -DSQL_USER=policy_user -DSQL_PASSWORD=policy_user \
         -DKAFKA_SERVER=localhost:29092 -DTOPIC_COMM_INFRASTRUCTURE=kafka \
         -jar target/policy-clamp-runtime-acm-9.0.1-SNAPSHOT.jar

2.4.5 ACM Policy Participant
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To start the policy participant we need to go to the "participant/participant-impl/participant-impl-policy" directory in the clamp repo. You can then run the following command to start the policy-participant:

.. code-block:: bash

    cd ~/git/clamp/participant/participant-impl/participant-impl-policy
    java -Dserver.port=8084 -DkafkaServer=localhost:29092 -DtopicCommInfrastructure=kafka \
         -jar target/policy-clamp-participant-impl-policy-9.0.1-SNAPSHOT.jar

3. Testing Procedure
====================

3.1 Testing Outline
^^^^^^^^^^^^^^^^^^^

To perform the Smoke testing of the policy-participant we will be verifying the behaviours of the participant when the ACM changes state. The scenarios are:

- UNDEPLOYED to DEPLOYED: participant creates policies and policyTypes specified in the ToscaServiceTemplate using policy-api and deploys the policies using pap.
- LOCK to UNLOCK: participant changes lock state to UNLOCK. No operation performed.
- UNLOCK to LOCK: participant changes lock state to LOCK. No operation performed.
- DEPLOYED to UNDEPLOYED: participant undeploys deployed policies and deletes policies and policyTypes which have been created.

3.2 Testing Steps
^^^^^^^^^^^^^^^^^

Creation of AC Definition:
**************************
An AC Definition is created by commissioning a Tosca template.
Using postman, commission a TOSCA template using the following template:

:download:`Tosca Service Template <tosca/tosca_service_template_pptnt_smoke.yaml>`

To verify this, we check that the AC Definition has been created and is in state COMMISSIONED.

    .. image:: images/pol-part-clampacm-get-composition.png

Priming AC Definition:
**********************
The AC Definition state is changed from COMMISSIONED to PRIMED using postman:

.. code-block:: json

    {
        "primeOrder": "PRIME"
    }


To verify this, we check that the AC Definition has been primed.

    .. image:: images/pol-part-clampacm-get-primed-composition.png


Creation of AC Instance:
************************
Using postman, instance the AC definition using the following template:

:download:`Instantiate ACM <json/instantiation_pptnt_smoke.json>`

To verify this, we check that the AC Instance has been created and is in state UNDEPLOYED.

    .. image:: images/pol-part-clampacm-creation-ver.png

Creation and deploy of policies and policyTypes:
************************************************
The AC Instance deploy state is changed from UNDEPLOYED to DEPLOYED using postman:

.. code-block:: json

    {
        "deployOrder": "DEPLOY"
    }

This state change will trigger the creation of policies and policyTypes using the policy-api and the deployment of the policies specified in the ToscaServiceTemplate.
To verify this we will check, using policy-api endpoints, that the onap.policies.native.apex.ac.element policy, which is specified in the service template, has been created.

    .. image:: images/pol-part-clampacm-ac-policy-ver.png

And we will check that the apex onap.policies.native.apex.ac.element policy has been deployed to the defaultGroup. We check this using pap:

    .. image:: images/pol-part-clampacm-ac-deploy-ver.png

Undeployment and deletion of policies and policyTypes:
******************************************************
The ACM STATE is changed from DEPLOYED to UNDEPLOYED using postman:

.. code-block:: json

    {
        "deployOrder": "UNDEPLOY"
    }

This state change will trigger the undeployment of the onap.policies.native.apex.ac.element policy which was deployed previously and the deletion of the previously created policies and policyTypes.
To verify this we do a PdpGroup Query as before and check that the onap.policies.native.apex.ac.element policy has been undeployed and removed from the defaultGroup:

    .. image:: images/pol-part-clampacm-ac-undep-ver.png


As before, we can check that the Test Policy policyType is not found this time and likewise for the onap.policies.native.apex.ac.element policy:

    .. image:: images/pol-part-clampacm-test-policy-nf.png
