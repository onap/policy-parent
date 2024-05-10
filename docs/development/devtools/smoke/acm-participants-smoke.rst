.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _clamp-acm-participants-smoke-tests:

CLAMP participants (kubernetes, http) Smoke Tests
-------------------------------------------------
1. Introduction
***************
The CLAMP participants (kubernetes and http) are used to interact with the helm client in a kubernetes environment for the
deployment of microservices via helm chart as well as to configure the microservices over REST endpoints. Both of these participants are
often used together in the Automation Composition Management workflow.

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
- Java 17
- Docker
- Maven 3.9
- Git
- helm3
- k8s cluster
- Refer to this guide for basic environment setup `Setting up dev environment <https://wiki.onap.org/display/DW/Setting+Up+Your+Development+Environment>`_

2.2 Cloning CLAMP automation composition
========================================

Run a script such as the script below to clone the required modules from the `ONAP git repository <https://gerrit.onap.org/r/admin/repos/q/filter:policy>`_. This script clones CLAMP automation composition and all dependency.

.. code-block:: bash

    cd ~/git
    git clone https://gerrit.onap.org/r/policy/clamp clamp


Execution of the command above results in the following directory hierarchy in your *~/git* directory:

    *  ~/git/clamp


2.3 Setting up the components
=============================

2.3.1 Running MariaDb and Kafka
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We will be using Docker to run our mariadb instance and Kafka. It will have the acm-runtime database running in it.
The easiest way to do this is to perform a SQL script. Create the *mariadb.sql* file in the directory *~/git*.

.. literalinclude:: files/mariadb.sql
   :language: SQL

Create the '*docker-compose.yaml*' using following code:

.. literalinclude:: files/docker-compose-local.yaml
   :language: yaml

Run the docker composition:

   .. code-block:: bash

      cd ~/git/
      docker compose up

2.3.2 Setting topicParameterGroup for kafka localhost
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
It needs to set 'kafka' as topicCommInfrastructure and 'localhost:29092' as server.
In the clamp repo, you should find the file 'runtime-acm/src/main/resources/application.yaml'. This file (in the 'runtime' parameters section) may need to be altered as below:

.. literalinclude:: files/runtime-application.yaml
   :language: yaml

Same changes (in the 'participant' parameters section)
may need to be apply into the file 'participant/participant-impl/participant-impl-http/src/main/resources/config/application.yaml'.

.. literalinclude:: files/participant-http-application.yaml
   :language: yaml

And into the file 'participant/participant-impl/participant-impl-kubernetes/src/main/resources/config/application.yaml'.

.. literalinclude:: files/participant-kubernetes-application.yaml
   :language: yaml

2.3.3 Automation composition Runtime
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
To start the automation composition runtime service, we need to execute the following maven command from the "runtime-acm" directory in the clamp repo. Automation composition runtime uses the config file "src/main/resources/application.yaml" by default.

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
The participants will be started and get registered to the Automation composition runtime.

Navigate to the directory "participant/participant-impl/participant-impl-kubernetes/" and start kubernetes participant.

.. code-block:: bash

    mvn spring-boot:run

Navigate to the directory "participant/participant-impl/participant-impl-http/" and start http participant.

.. code-block:: bash

    mvn spring-boot:run

For building docker images of runtime-acm and participants:

.. code-block:: bash

   cd ~/git/onap/policy/clamp/packages/
   mvn clean install -P docker


3. Running Tests
****************
In this section, we will run through the sequence of steps in ACM workflow . The workflow can be triggered via Postman client.

3.1 Commissioning
=================
Commission Automation composition TOSCA definitions to Runtime.

The Automation composition definitions are commissioned to runtime-acm which populates the ACM runtime database.
The following sample TOSCA template is commissioned to the runtime endpoint which contains definitions for kubernetes participant that deploys nginx ingress microservice
helm chart and a http POST request for http participant.

:download:`Tosca Service Template <tosca/smoke-test-participants.yaml>`

Commissioning Endpoint:

.. code-block:: bash

   POST: https://<Runtime ACM IP> : <Port> /onap/policy/clamp/acm/v2/compositions

A successful commissioning gives 201 responses in the postman client.

3.2 Prime an Automation composition definition
==============================================
Once the template is commissioned, we can prime it. This will connect AC definition with related participants.

Prime Endpoint:

.. code-block:: bash

   PUT: https://<Runtime ACM IP> : <Port> /onap/policy/clamp/acm/v2/compositions/{compositionId}

Request body:

.. code-block:: json

   {
        "primeOrder": "PRIME"
   }

3.3 Create New Instances of Automation composition
==================================================
Once AC definition is primes, we can instantiate automation composition instances. This will create the instances with default state "UNDEPLOYED".

Instantiation Endpoint:

.. code-block:: bash

   POST: https://<Runtime ACM IP> : <Port> /onap/policy/clamp/acm/v2/compositions/{compositionId}/instances

Request body:

:download:`Instantiation json <json/acm-instantiation.json>`

3.4 Change the State of the Instance
====================================
When the automation composition is updated with state “DEPLOYED”, the Kubernetes participant fetches the node template for all automation composition elements and deploys the helm chart of each AC element into the cluster. The following sample json input is passed on the request body.

Automation Composition Update Endpoint:

.. code-block:: bash

   PUT: https://<Runtime ACM IP> : <Port> /onap/policy/clamp/acm/v2/compositions/{compositionId}/instances/{instanceId}

   Request body:
.. code-block:: bash

   {
    "deployOrder": "DEPLOY"
   }


After the state changed to "DEPLOYED", nginx-ingress pod is deployed in the kubernetes cluster. And http participant should have posted the dummy data to the configured URL in the tosca template.

The following command can be used to verify the pods deployed successfully by kubernetes participant.

.. code-block:: bash

   helm ls -n onap | grep nginx
   kubectl get po -n onap | grep nginx

The overall state of the automation composition should be "DEPLOYED" to indicate both the participants has successfully completed the operations. This can be verified by the following rest endpoint.

Verify automation composition state:

.. code-block:: bash

   GET: https://<Runtime ACM IP> : <Port>/onap/policy/clamp/acm/v2/compositions/{compositionId}/instances/{instanceId}


3.5 Automation Compositions can be "UNDEPLOYED" after deployment
================================================================

By changing the state to "UNDEPLOYED", all the helm deployments under the corresponding automation composition will be uninstalled from the cluster.
Automation Composition Update Endpoint:

.. code-block:: bash

   PUT: https://<Runtime ACM IP> : <Port> /onap/policy/clamp/acm/v2/compositions/{compositionId}/instances/{instanceId}

   Request body:
.. code-block:: bash

   {
    "deployOrder": "UNDEPLOY"
   }

The nginx pod should be deleted from the k8s cluster.

This concludes the required smoke tests for http and kubernetes participants.
