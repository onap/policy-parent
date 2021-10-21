.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _clamp-controlloop-participants-smoke-tests:

CLAMP participants (kubernetes, http) Smoke Tests
-------------------------------------------------
1. Introduction
***************
The CLAMP participants (kubernetes and http) are used to interact with the helm client in a kubernetes environment for the
deployment of microservices via helm chart as well as to configure the microservices over REST endpoints. Both of these participants are
often used together in the Control loop workflow.

This document will serve as a guide to do smoke tests on the different components that are involved when working with the participants and outline how they operate. It will also show a developer how to set up their environment for carrying out smoke tests on these participants.

2. Setup Guide
**************
This article assumes that:

* You are using the operating systems such as linux/macOS/windows.
* You are using a directory called *git* off your home directory *(~/git)* for your git repositories
* Your local maven repository is in the location *~/.m2/repository*
* You have copied the settings.xml from oparent to *~/.m2/* directory
* You have added settings to access the ONAP Nexus to your M2 configuration, see `Maven Settings Example <https://wiki.onap.org/display/DW/Setting+Up+Your+Development+Environment>`_ (bottom of the linked page)

The procedure documented in this article has been verified using Ubuntu 20.04 LTS VM.

2.1 Prerequisites
=================
- Java 11
- Docker
- Maven 3
- Git
- helm3
- k8s cluster
- Refer to this guide for basic environment setup `Setting up dev environment <https://wiki.onap.org/display/DW/Setting+Up+Your+Development+Environment>`_

2.2 Assumptions
===============
- You are accessing the policy repositories through gerrit.

The following repositories are required for development in this project. These repositories should be present on your machine and you should run "mvn clean install" on all of them so that the packages are present in your .m2 repository.

- policy/parent
- policy/common
- policy/models
- policy/clamp
- policy/docker

In this setup guide, we will be setting up all the components technically required for a working dev environment.

2.3 Setting up the components
=============================

2.3.1 MariaDB Setup
^^^^^^^^^^^^^^^^^^^
We will be using Docker to run our mariadb instance. It will have the runtime-controlloop database running in it.

- controlloop: the runtime-controlloop db

The easiest way to do this is to perform a small alteration on an SQL script provided by the clamp backend in the file "runtime/extra/sql/bulkload/create-db.sql"

.. code-block:: mysql

    CREATE DATABASE `controlloop`;
    USE `controlloop`;
    DROP USER 'policy';
    CREATE USER 'policy';
    GRANT ALL on controlloop.* to 'policy' identified by 'P01icY' with GRANT OPTION;

Once this has been done, we can run the bash script provided here: "runtime/extra/bin-for-dev/start-db.sh"

.. code-block:: bash

    ./start-db.sh

This will setup all the Control Loop runtime database. The database will be exposed locally on port 3306 and will be backed by an anonymous docker volume.

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


2.3.3 Controlloop Runtime
^^^^^^^^^^^^^^^^^^^^^^^^^
To start the controlloop runtime service, we need to execute the following maven command from the "runtime-controlloop" directory in the clamp repo. Control Loop runtime uses the config file "src/main/resources/application.yaml" by default.

.. code-block:: bash

    mvn spring-boot:run

2.3.4 Helm chart repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Kubernetes participant consumes helm charts from the local chart database as well as from a helm repository. For the smoke testing, we are going to add `nginx-stable` helm repository to the helm client.
The following command can be used to add nginx repository to the helm client.

.. code-block:: bash

    helm repo add nginx-stable https://helm.nginx.com/stable

2.3.5 Kubernetes and http participants
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The participants can be started from the clamp repository by executing the following maven command from the appropriate directories.
The participants will be started and get registered to the Control Loop runtime.

Navigate to the directory "participant/participant-impl/participant-impl-kubernetes/" and start kubernetes participant.

.. code-block:: bash

    mvn spring-boot:run

Navigate to the directory "participant/participant-impl/participant-impl-http/" and start http participant.

.. code-block:: bash

    mvn spring-boot:run


3. Running Tests
****************
In this section, we will run through the sequence of steps in Control Loop workflow . The workflow can be triggered via Postman client.

3.1 Commissioning
=================
Commission Control loop TOSCA definitions to Runtime.

The Control Loop definitions are commissioned to CL runtime which populates the CL runtime database.
The following sample TOSCA template is commissioned to the runtime endpoint which contains definitions for kubernetes participant that deploys nginx ingress microservice
helm chart and a http POST request for http participant.

:download:`Tosca Service Template <tosca/smoke-test-participants.yaml>`

Commissioning Endpoint:

.. code-block:: bash

   POST: https://<CL Runtime IP> : <Port> /onap/controlloop/v2/commission

A successful commissioning gives 200 response in the postman client.


3.2 Create New Instances of Control Loops
=========================================
Once the template is commissioned, we can instantiate Control Loop instances. This will create the instances with default state "UNINITIALISED".

Instantiation Endpoint:

.. code-block:: bash

   POST: https://<CL Runtime IP> : <Port> /onap/controlloop/v2/instantiation

Request body:

:download:`Instantiation json <json/cl-instantiation.json>`

3.3 Change the State of the Instance
====================================
When the Control loop is updated with state “PASSIVE”, the Kubernetes participant fetches the node template for all control loop elements and deploys the helm chart of each CL element in to the cluster. The following sample json input is passed on the request body.

Control Loop Update Endpoint:

.. code-block:: bash

   PUT: https://<CL Runtime IP> : <Port> /onap/controlloop/v2/instantiation/command

   Request body:
.. code-block:: bash

   {
     "orderedState": "PASSIVE",
     "controlLoopIdentifierList": [
       {
         "name": "K8SInstance0",
         "version": "1.0.1"
       }
     ]
   }


After the state changed to "PASSIVE", nginx-ingress pod is deployed in the kubernetes cluster. And http participant should have posted the dummy data to the configured URL in the tosca template.

The following command can be used to verify the pods deployed successfully by kubernetes participant.

.. code-block:: bash

   helm ls -n onap | grep nginx
   kubectl get po -n onap | grep nginx

The overall state of the control loop should be "PASSIVE" to indicate both the participants has successfully completed the operations. This can be verified by the following rest endpoint.

Verify control loop state:

.. code-block:: bash

   GET: https://<CL Runtime IP> : <Port>/onap/controlloop/v2/instantiation


3.4 Control Loop can be "UNINITIALISED" after deployment
========================================================

By changing the state to "UNINITIALISED", all the helm deployments under the corresponding control loop will be uninstalled from the cluster.
Control Loop Update Endpoint:

.. code-block:: bash

   PUT: https://<CL Runtime IP> : <Port> /onap/controlloop/v2/instantiation/command

   Request body:
.. code-block:: bash

   {
     "orderedState": "UNINITIALISED",
     "controlLoopIdentifierList": [
       {
         "name": "K8SInstance0",
         "version": "1.0.1"
       }
     ]
   }

The nginx pod should be deleted from the k8s cluster.

This concludes the required smoke tests for http and kubernetes participants.
