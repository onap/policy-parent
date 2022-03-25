.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

CLAMP Policy Participant Smoke Tests
------------------------------------

1. Introduction
***************

The Smoke testing of the policy participant is executed in a local CLAMP/Policy environment. The CLAMP-ACM interfaces interact with the Policy Framework to perform actions based on the state of the policy participant. The goal of the Smoke tests is the ensure that CLAMP Policy Participant and Policy Framework work together as expected.

2. Setup Guide
**************

This section will show the developer how to set up their environment to start testing in GUI with some instruction on how to carry out the tests. There are a number of prerequisites. Note that this guide is written by a Linux user - although the majority of the steps show will be exactly the same in Windows or other systems.

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
- policy/docker
- policy/gui
- policy/api

In this setup guide, we will be setting up all the components technically required for a working convenient dev environment.

2.3 Setting up the components
=============================

2.3.1 MariaDB Setup
^^^^^^^^^^^^^^^^^^^

We will be using Docker to run our mariadb instance. It will have a total of two databases running in it.

- acm: the runtime-acm db
- policyadmin: the policy-api db

The easiest way to do this is to perform a small alteration on an SQL script provided by the clamp backend in the file "runtime/extra/sql/bulkload/create-db.sql"

.. code-block:: mysql

    CREATE DATABASE `acm`;
    USE `acm`;
    DROP USER 'policy';
    CREATE USER 'policy';
    GRANT ALL on acm.* to 'policy' identified by 'P01icY' with GRANT OPTION;
    CREATE DATABASE `policyadmin`;
    USE `policyadmin`;
    DROP USER 'policy_user';
    CREATE USER 'policy_user';
    GRANT ALL on acm.* to 'policy_user' identified by 'policy_user' with GRANT OPTION;
    FLUSH PRIVILEGES;

Once this has been done, we can run the bash script provided here: "runtime/extra/bin-for-dev/start-db.sh"

.. code-block:: bash

    ./start-db.sh

This will setup the two databases needed. The database will be exposed locally on port 3306 and will be backed by an anonymous docker volume.

2.3.2 DMAAP Simulator
^^^^^^^^^^^^^^^^^^^^^

For convenience, a dmaap simulator has been provided in the policy/models repository. To start the simulator, you can do the following:
1. Navigate to /models-sim/policy-models-simulators in the policy/models repository.
2. Add a configuration file to src/test/resources with the following contents:

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

In the policy-api repo, you should find the file "src/main/resources/etc/defaultConfig.json". This file must be altered slightly - as below with the restServerParameters and databaseProviderParameters shown. Note how the database parameters match-up with what you setup in Mariadb:

.. code-block:: yaml

    server:
      port: 6969
    spring:
      security.user:
        name: policyadmin
        password: zb!XztG34
      mvc.converters.preferred-json-mapper: gson
      datasource:
        url: jdbc:mariadb://mariadb:3306/policyadmin
        driverClassName: org.mariadb.jdbc.Driver
        username: policy_user
        password: policy_user
      jpa:
        properties:
          hibernate:
            dialect: org.hibernate.dialect.MariaDB103Dialect
        hibernate:
          ddl-auto: none
          naming:
            physical-strategy: org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
            implicit-strategy: org.onap.policy.common.spring.utils.CustomImplicitNamingStrategy
    policy-api:
      name: ApiGroup
      aaf: false
    database:
      name: PolicyProviderParameterGroup
      implementation: org.onap.policy.models.provider.impl.DatabasePolicyModelsProviderImpl
      driver: org.mariadb.jdbc.Driver
      url: jdbc:mariadb://mariadb:3306/policyadmin
      user: policy_user
      password: policy_user
      persistenceUnit: PolicyDb
    policy-preload:
      policyTypes:
        - policytypes/onap.policies.monitoring.tcagen2.yaml
        - policytypes/onap.policies.monitoring.dcaegen2.collectors.datafile.datafile-app-server.yaml
        - policytypes/onap.policies.monitoring.dcae-restconfcollector.yaml
        - policytypes/onap.policies.monitoring.dcae-pm-subscription-handler.yaml
        - policytypes/onap.policies.monitoring.dcae-pm-mapper.yaml
        - policytypes/onap.policies.Optimization.yaml
        - policytypes/onap.policies.optimization.Resource.yaml
        - policytypes/onap.policies.controlloop.operational.common.Drools.yaml
      policies:
        - policies/sdnc.policy.naming.input.tosca.yaml
    management:
      endpoints:
        web:
          base-path: /
          exposure:
            include: health,metrics,prometheus
          path-mapping.prometheus: metrics

Next, navigate to the "/main" directory. You can then run the following command to start the policy api:

.. code-block:: bash

    mvn exec:java -Dexec.mainClass=org.onap.policy.api.main.startstop.Main -Dexec.args=" -c ../packages/policy-api-tarball/src/main/resources/etc/defaultConfig.json"

2.3.4 Policy PAP
^^^^^^^^^^^^^^^^

In the policy-pap repo, you should find the file 'main/src/test/resources/parameters/PapConfigParameters.json'. This file may need to be altered slightly as below:

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
        url: jdbc:mariadb://mariadb:3306/policyadmin
        driverClassName: org.mariadb.jdbc.Driver
        username: policy_user
        password: policy_user
      jpa:
        properties:
          hibernate:
            dialect: org.hibernate.dialect.MySQL5InnoDBDialect
        hibernate:
          ddl-auto: none
          naming:
            physical-strategy: org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
            implicit-strategy: org.onap.policy.pap.main.CustomImplicitNamingStrategy
    server:
      port: 6969
    pap:
      name: PapGroup
      pdpParameters:
        heartBeatMs: 120000
        updateParameters:
          maxRetryCount: 1

Next, navigate to the "/main" directory. You can then run the following command to start the policy pap

.. code-block:: bash

    mvn -q -e clean compile exec:java -Dexec.mainClass="org.onap.policy.pap.main.startstop.Main" -Dexec.args="-c /src/test/resources/parameters/PapConfigParameters.json"

2.3.5 ACM Runtime
^^^^^^^^^^^^^^^^^^^^^^^^^

To start the acm runtime we need to go the "runtime-acm" directory in the clamp repo. There is a config file that is used, by default, for the acm runtime. That config file is here: "src/main/resources/application.yaml". For development in your local environment, it shouldn't need any adjustment and we can just run the acm runtime with:

.. code-block:: bash

    mvn spring-boot:run

2.3.6 ACM Policy Participant
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To start the policy participant we need to go to the "participant-impl/participant-impl-policy" directory in the clamp repo. There is a config file under "src/main/resources/config/application.yaml". For development in your local environment, we will need to adjust this file slightly:

.. code-block:: yaml

    server:
        port: 8082

    participant:
      pdpGroup: defaultGroup
      pdpType: apex
      policyApiParameters:
        clientName: api
        hostname: localhost
        port: 6970
        userName: healthcheck
        password: zb!XztG34
        https: true
        allowSelfSignedCerts: true
      policyPapParameters:
        clientName: pap
        hostname: localhost
        port: 6968
        userName: healthcheck
        password: zb!XztG34
        https: true
        allowSelfSignedCerts: true
      intermediaryParameters:
        reportingTimeIntervalMs: 120000
        description: Participant Description
        participantId:
          name: org.onap.PM_Policy
          version: 1.0.0
        participantType:
          name: org.onap.policy.acm.PolicyControlLoopParticipant
          version: 2.3.1
        clampControlLoopTopics:
          topicSources:
            -
              topic: POLICY-CLRUNTIME-PARTICIPANT
              servers:
                - ${topicServer:localhost}
              topicCommInfrastructure: dmaap
              fetchTimeout: 15000
          topicSinks:
            -
              topic: POLICY-CLRUNTIME-PARTICIPANT
              servers:
                - ${topicServer:localhost}
              topicCommInfrastructure: dmaap

Navigate to the participant-impl/particpant-impl-policy/main directory. We can then run the policy-participant with the following command:

.. code-block:: bash

    mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8082 --topicServer=localhost"

3. Testing Procedure
====================

3.1 Testing Outline
^^^^^^^^^^^^^^^^^^^

To perform the Smoke testing of the policy-participant we will be verifying the behaviours of the participant when the control loop changes state. The scenarios are:

- UNINITIALISED to PASSIVE: participant creates policies and policyTypes specified in the ToscaServiceTemplate using policy-api and deploys the policies using pap.
- PASSIVE to RUNNING: participant changes state to RUNNING. No operation performed.
- RUNNING to PASSIVE: participant changes state to PASSIVE. No operation performed.
- PASSIVE to UNINITIALISED: participant undeploys deployed policies and deletes policies and policyTypes which have been created.

3.2 Testing Steps
^^^^^^^^^^^^^^^^^

Creation of ACM:
************************

A ACM is created by commissioning a Tosca template with ACM definitions and instantiating the ACM with the state "UNINITIALISED".
Using postman, commission a TOSCA template and instantiate using the following template:

:download:`Tosca Service Template <tosca/tosca_service_template_pptnt_smoke.yaml>`

:download:`Instantiate ACM <tosca/instantiation_pptnt_smoke.json>`

To verify this, we check that the ACM has been created and is in state UNINITIALISED.

    .. image:: images/pol-part-acm-creation-ver.png

Creation of policies and policyTypes:
*************************************

The ACM STATE is changed from UNINITIALISED to PASSIVE using postman:

.. code-block:: json

    {
        "orderedState": "PASSIVE",
        "controlLoopIdentifierList": [
            {
                "name": "PMSHInstance0",
                "version": "1.0.1"
            }
        ]
    }

This state change will trigger the creation of policies and policyTypes using the policy-api. To verify this we will check, using policy-api endpoints, that the "Sirisha" policyType, which is specified in the service template, has been created.

    .. image:: images/pol-part-acm-sirisha-ver.png

We can also check that the pm-control policy has been created.

    .. image:: images/pol-part-acm-pmcontrol-ver.png

Deployment of policies:
***********************

The ACM STATE is changed from UNINITIALISED to PASSIVE using postman:

This state change will trigger the deployment of the policies specified in the ToscaServiceTemplate. To verify this, we will check that the apex pmcontrol policy has been deployed to the defaultGroup. We check this using pap:

    .. image:: images/pol-part-acm-pmcontrol-deploy-ver.png

Undeployment of policies:
*************************

The ACM STATE is changed from PASSIVE to UNINITIALISED using postman:

.. code-block:: json

    {
        "orderedState": "UNINITIALISED",
        "controlLoopIdentifierList": [
            {
                "name": "PMSHInstance0",
                "version": "1.0.1"
            }
        ]
    }

This state change will trigger the undeployment of the pmcontrol policy which was deployed previously. To verifiy this we do a PdpGroup Query as before and check that the pmcontrol policy has been undeployed and removed from the defaultGroup:

    .. image:: images/pol-part-acm-pmcontrol-undep-ver.png

Deletion of policies and policyTypes:
*************************************

The ACM STATE is changed from PASSIVE to UNINITIALISED using postman:

This state change will trigger the deletion of the previously created policies and policyTypes. To verify this, as before, we can check that the Sirisha policyType is not found this time and likewise for the pmcontrol policy:

    .. image:: images/pol-part-acm-sirisha-nf.png

    .. image:: images/pol-part-acm-pmcontrol-nf.png
