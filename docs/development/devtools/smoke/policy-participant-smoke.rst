.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

CLAMP Policy Participant Smoke Tests
------------------------------------

1. Introduction
***************

The Smoke testing of the policy participant is executed in a local CLAMP/Policy environment. The CLAMP-ACM interfaces interact with the Policy Framework to perform actions based on the state of the policy participant. The goal of the Smoke tests is the ensure that CLAMP Policy Participant and Policy Framework work together as expected.
All applications will be running by console, so they need to run with different ports. Configuration files should be changed accordingly.

+------------------------------+------+
| Application                  | port |
+==============================+======+
| MariDB                       | 3306 |
+------------------------------+------+
| DMaaP simulator              | 3904 |
+------------------------------+------+
| policy-api                   | 6968 |
+------------------------------+------+
| policy-pap                   | 6970 |
+------------------------------+------+
| policy-clamp-runtime-acm     | 6969 |
+------------------------------+------+
| onap/policy-clamp-ac-pf-ppnt | 8085 |
+------------------------------+------+


2. Setup Guide
**************

This section will show the developer how to set up their environment to start testing in GUI with some instruction on how to carry out the tests. There are several prerequisites. Note that this guide is written by a Linux user - although the majority of the steps show will be exactly the same in Windows or other systems.

2.1 Prerequisites
=================

- Java 11
- Maven 3
- Git
- Refer to this guide for basic environment setup `Setting up dev environment <https://wiki.onap.org/display/DW/Setting+Up+Your+Development+Environment>`_

2.2 Assumptions
===============

- You are accessing the policy repositories through gerrit
- You are using "git review".

The following repositories are required for development in this project. These repositories should be present on your machine and you should run "mvn clean install" on all of them so that the packages are present in your .m2 repository.

- policy/parent
- policy/common
- policy/models
- policy/clamp
- policy/api
- policy/pap

In this setup guide, we will be setting up all the components technically required for a working convenient dev environment.

2.3 Setting up the components
=============================

2.3.1 MariaDB Setup
^^^^^^^^^^^^^^^^^^^

We will be using Docker to run our mariadb instance. It will have a total of two databases running in it.

- clampacm: the policy-clamp-runtime-acm db
- policyadmin: the policy-api db

A sql such as the one below can be used to build the SQL initialization. Create the *mariadb.sql* file in a directory *PATH_DIRECTORY*.

    .. code-block:: SQL

       create database clampacm;
       CREATE USER 'policy'@'%' IDENTIFIED BY 'P01icY';
       GRANT ALL PRIVILEGES ON clampacm.* TO 'policy'@'%';
       CREATE DATABASE `policyadmin`;
       CREATE USER 'policy_user'@'%' IDENTIFIED BY 'policy_user';
       GRANT ALL PRIVILEGES ON policyadmin.* to 'policy_user'@'%';
       FLUSH PRIVILEGES;


Execution of the command above results in the creation and start of the *mariadb-smoke-test* container.

    .. code-block:: bash

       docker run --name mariadb-smoke-test  \
        -p 3306:3306 \
        -e MYSQL_ROOT_PASSWORD=my-secret-pw  \
        --mount type=bind,source=PATH_DIRECTORY/mariadb.sql,target=/docker-entrypoint-initdb.d/data.sql \
        -d mariadb:10.10.2 \
        --lower-case-table-names=1

This will setup the two databases needed. The database will be exposed locally on port 3306.

2.3.2 DMAAP Simulator
^^^^^^^^^^^^^^^^^^^^^

For convenience, a dmaap simulator has been provided in the policy/models repository. To start the simulator, you can do the following:

#. Navigate to models-sim/policy-models-simulators in the policy/models repository.
#. Add a configuration file to src/test/resources with the following contents:

.. code-block:: json

    {
       "dmaapProvider":{
          "name":"DMaaP simulator",
          "topicSweepSec":900
       },
       "restServers":[
          {
             "name":"DMaaP simulator",
             "providerClass":"org.onap.policy.models.sim.dmaap.rest.DmaapSimRestControllerV1",
             "host":"localhost",
             "port":3904,
             "https":false
          }
       ]
    }

3. You can then start dmaap with:

.. code-block:: bash

    mvn exec:java  -Dexec.mainClass=org.onap.policy.models.simulators.Main -Dexec.args="src/test/resources/YOUR_CONF_FILE.json"

At this stage the dmaap simulator should be running on your local machine on port 3904.

2.3.3 Policy API
^^^^^^^^^^^^^^^^

Navigate to the "/main" directory. You can then run the following command to start the policy api:

.. code-block:: bash

    java -jar target/api-main-2.8.2-SNAPSHOT.jar --spring.datasource.url=jdbc:mariadb://localhost:3306/policyadmin --spring.jpa.hibernate.ddl-auto=update --server.port=6968


2.3.4 Policy PAP
^^^^^^^^^^^^^^^^

In the policy-pap repo, you should find the file 'main\src\main\resources\application.yaml'. This file may need to be altered slightly as below:

.. code-block:: yaml

    spring:
      security:
        user:
          name: policyadmin
          password: zb!XztG34
      http:
        converters:
          preferred-json-mapper: gson
      datasource:
        url: jdbc:mariadb://localhost:3306/policyadmin
        driverClassName: org.mariadb.jdbc.Driver
        username: policy_user
        password: policy_user
      jpa:
        properties:
          hibernate:
            dialect: org.hibernate.dialect.MariaDB103Dialect
        hibernate:
          ddl-auto: update
          naming:
            physical-strategy: org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
            implicit-strategy: org.onap.policy.common.spring.utils.CustomImplicitNamingStrategy

    server:
      port: 6970
      servlet:
        context-path: /policy/pap/v1
    pap:
      name: PapGroup
      aaf: false
      topic:
        pdp-pap.name: POLICY-PDP-PAP
        notification.name: POLICY-NOTIFICATION
        heartbeat.name: POLICY-HEARTBEAT
      pdpParameters:
        heartBeatMs: 120000
        updateParameters:
          maxRetryCount: 1
          maxWaitMs: 30000
        stateChangeParameters:
          maxRetryCount: 1
          maxWaitMs: 30000
      savePdpStatisticsInDb: true
      topicParameterGroup:
        topicSources:
        - topic: ${pap.topic.pdp-pap.name}
          servers:
          - localhost
          topicCommInfrastructure: dmaap
          fetchTimeout: 15000
        - topic: ${pap.topic.heartbeat.name}
          effectiveTopic: ${pap.topic.pdp-pap.name}
          consumerGroup: policy-pap
          servers:
          - localhost
          topicCommInfrastructure: dmaap
          fetchTimeout: 15000
        topicSinks:
        - topic: ${pap.topic.pdp-pap.name}
          servers:
          - localhost
          topicCommInfrastructure: dmaap
        - topic: ${pap.topic.notification.name}
          servers:
          - localhost
          topicCommInfrastructure: dmaap
      healthCheckRestClientParameters:
      - clientName: api
        hostname: localhost
        port: 6968
        userName: policyadmin
        password: zb!XztG34
        useHttps: false
        basePath: policy/api/v1/healthcheck
      - clientName: distribution
        hostname: policy-distribution
        port: 6969
        userName: healthcheck
        password: zb!XztG34
        useHttps: false
        basePath: healthcheck
      - clientName: dmaap
        hostname: localhost
        port: 3904
        useHttps: false
        basePath: topics

    management:
      endpoints:
        web:
          base-path: /
          exposure:
            include: health, metrics, prometheus
          path-mapping.metrics: plain-metrics
          path-mapping.prometheus: metrics

Next, navigate to the "/main" directory. You can then run the following command to start the policy pap

.. code-block:: bash

    mvn spring-boot:run

2.3.5 ACM Runtime
^^^^^^^^^^^^^^^^^

To start the clampacm runtime we need to go the "runtime-acm" directory in the clamp repo. There is a config file that is used, by default, for the clampacm runtime. That config file is here: "src/main/resources/application.yaml". For development in your local environment, it shouldn't need any adjustment and we can just run the clampacm runtime with:

.. code-block:: bash

    mvn spring-boot:run

2.3.6 ACM Policy Participant
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To start the policy participant we need to go to the "participant/participant-impl/participant-impl-policy" directory in the clamp repo. There is a config file under "src/main/resources/config/application.yaml". For development in your local environment, we will need to adjust this file slightly:

.. code-block:: yaml

    spring:
      security:
        user:
          name: participantUser
          password: zb!XztG34
      autoconfigure:
        exclude:
          - org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration
          - org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
          - org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration
          - org.springframework.boot.autoconfigure.data.web.SpringDataWebAutoConfiguration

    participant:
      pdpGroup: defaultGroup
      pdpType: apex
      policyApiParameters:
        clientName: api
        hostname: localhost
        port: 6968
        userName: policyadmin
        password: zb!XztG34
        useHttps: false
        allowSelfSignedCerts: true
      policyPapParameters:
        clientName: pap
        hostname: localhost
        port: 6970
        userName: policyadmin
        password: zb!XztG34
        useHttps: false
        allowSelfSignedCerts: true
      intermediaryParameters:
        reportingTimeIntervalMs: 120000
        description: Participant Description
        participantId: 101c62b3-8918-41b9-a747-d21eb79c6c03
        clampAutomationCompositionTopics:
          topicSources:
            -
              topic: POLICY-ACRUNTIME-PARTICIPANT
              servers:
                - ${topicServer:localhost}
              topicCommInfrastructure: dmaap
              fetchTimeout: 15000
          topicSinks:
            -
              topic: POLICY-ACRUNTIME-PARTICIPANT
              servers:
                - ${topicServer:localhost}
              topicCommInfrastructure: dmaap
        participantSupportedElementTypes:
          -
            typeName: org.onap.policy.clamp.acm.PolicyAutomationCompositionElement
            typeVersion: 1.0.0

    management:
      endpoints:
        web:
          base-path: /
          exposure:
            include: health, metrics, prometheus
    server:
      port: 8085
      servlet:
        context-path: /onap/policy/clamp/acm/policyparticipant


Navigate to the "participant/participant-impl/participant-impl-policy" directory. We can then run the policy-participant with the following command:

.. code-block:: bash

    mvn spring-boot:run

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
