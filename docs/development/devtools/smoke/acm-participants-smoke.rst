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
* Your local helm is in the location /usr/local/bin/helm
* Your local kubectl is in the location /usr/local/bin/kubectl

The procedure documented in this article has been verified using Ubuntu 20.04 LTS VM.

2.1 Prerequisites
=================
- Java 21
- Docker
- Maven 3.9
- Git
- helm3
- k8s cluster
- Refer to this guide for basic environment setup `Setting up dev environment <https://wiki.onap.org/display/DW/Setting+Up+Your+Development+Environment>`_

2.2 Cloning CLAMP automation composition
========================================

Run the below command to clone the required CLAMP automation composition:

.. code-block:: bash

    cd ~/git
    git clone https://gerrit.onap.org/r/policy/clamp clamp


Execution of the command above results in the following directory hierarchy in your *~/git* directory:

    *  ~/git/clamp


2.3 Setting up the components
=============================

2.3.1 Setting for kubernetes.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
If the helm location is not '/usr/local/bin/helm' or the kubectl location is not '/usr/local/bin/kubectl', you have to update
the file 'participant/participant-impl/participant-impl-kubernetes/src/main/java/org/onap/policy/clamp/acm/participant/kubernetes/helm/HelmClient.java'.

2.3.2 Building CLAMP automation composition
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Step 1:** Optionally, for a completely clean build, remove the ONAP built modules from your local repository.

    .. code-block:: bash

        rm -fr ~/.m2/repository/org/onap


**Step 2:** You can now build the Policy framework.

Build java artifacts and docker images:

    .. code-block:: bash

       cd ~/git/clamp
       mvn clean install -P docker -DskipTests


2.3.3 Running Postgres and Kafka
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We will be using Docker to run our Postgres instance and Kafka. It will have the acm-runtime database running in it.
Create the *db-pg.conf* and *db-pg.sh* files in the directory *~/git*.

.. literalinclude:: files/db-pg.conf
   :language: yaml

.. literalinclude:: files/db-pg.sh
   :language: yaml


Create the '*docker-compose.yaml*' using following code:

.. literalinclude:: files/docker-compose-local.yaml
   :language: yaml

Run the docker composition:

   .. code-block:: bash

      cd ~/git/
      docker compose up

2.3.4 Running ACM-R on the Command Line
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
To start the automation composition runtime service, we need to execute the following command line from the "runtime-acm" directory in the clamp repo. Automation composition runtime uses the config file "src/main/resources/application.yaml" by default.

   .. code-block:: bash

      cd ~/git/clamp/runtime-acm
      java -DRUNTIME_USER=runtimeUser -DRUNTIME_PASSWORD=zb\!XztG34 \
           -DSQL_HOST=localhost -DSQL_PORT=5432 -DSQL_USER=policy_user -DSQL_PASSWORD=policy_user \
           -DKAFKA_SERVER=localhost:29092 -DTOPIC_COMM_INFRASTRUCTURE=kafka \
           -jar target/policy-clamp-runtime-acm-9.0.1-SNAPSHOT.jar

2.3.5 Helm chart repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Kubernetes participant consumes helm charts from the local chart database as well as from a helm repository. For the smoke testing, we are going to add `nginx-stable` helm repository to the helm client.
The following command can be used to add nginx repository to the helm client.

   .. code-block:: bash

      helm repo add nginx-stable https://helm.nginx.com/stable

2.3.6 Kubernetes and http participants
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The participants can be started from the clamp repository by executing the following command line from the appropriate directories.
The participants will be started and get registered to the Automation composition runtime.

Navigate to the directory "participant/participant-impl/participant-impl-kubernetes/" and start kubernetes participant.

  .. code-block:: bash

      cd ~/git/clamp/participant/participant-impl/participant-impl-kubernetes
      java -Dserver.port=8082 -DkafkaServer=localhost:29092 -DtopicCommInfrastructure=kafka \
           -jar target/policy-clamp-participant-impl-kubernetes-9.0.1-SNAPSHOT.jar


Navigate to the directory "participant/participant-impl/participant-impl-http/" and start http participant.

   .. code-block:: bash

      cd ~/git/clamp/participant/participant-impl/participant-impl-http
      java -Dserver.port=8083 -DkafkaServer=localhost:29092 -DtopicCommInfrastructure=kafka \
           -jar target/policy-clamp-participant-impl-http-9.0.1-SNAPSHOT.jar



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

A successful prime request gives 202 responses in the postman client.

3.3 Create New Instances of Automation composition
==================================================
Once AC definition is primes, we can instantiate automation composition instances. This will create the instances with default state "UNDEPLOYED".

Instantiation Endpoint:

.. code-block:: bash

   POST: https://<Runtime ACM IP> : <Port> /onap/policy/clamp/acm/v2/compositions/{compositionId}/instances

Request body:

:download:`Instantiation json <json/acm-instantiation.json>`

A successful creation of new instance gives 201 responses in the postman client.

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


A successful deploy request gives 202 responses in the postman client.
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
