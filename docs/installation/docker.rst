.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0


Policy Docker Installation
--------------------------

.. contents::
    :depth: 2


Building the ONAP Policy Framework Docker Images
************************************************
The instructions here are based on the instructions in the file *~/git/onap/policy/docker/README.md*.

**Step 1:** Build the Policy API Docker image

.. code-block:: bash

  cd ~/git/onap/policy/api/packages
  mvn clean install -P docker

**Step 2:** Build the Policy PAP Docker image

.. code-block:: bash

  cd ~/git/onap/policy/pap/packages
  mvn clean install -P docker

**Step 3:** Build the Drools PDP docker image.

This image is a standalone vanilla Drools engine, which does not contain any pre-built drools rules or applications.

.. code-block:: bash

  cd ~/git/onap/policy/drools-pdp/
  mvn clean install -P docker

**Step 4:** Build the Drools Application Control Loop image.

This image has the drools use case application and the supporting software built together with the Drools PDP engine. It is recommended to use this image if you are first working with ONAP Policy and wish to test or learn how the use cases work.

.. code-block:: bash

  cd ~/git/onap/policy/drools-applications
  mvn clean install -P docker

**Step 5:** Build the Apex PDP docker image:

.. code-block:: bash

  cd ~/git/onap/policy/apex-pdp
  mvn clean install -P docker

**Step 6:** Build the XACML PDP docker image:

.. code-block:: bash

  cd ~/git/onap/policy/xacml-pdp/packages
  mvn clean install -P docker

**Step 7:** Build the policy engine docker image (If working with the legacy Policy Architecture/API):

.. code-block:: bash

  cd ~/git/onap/policy/engine/
  mvn clean install -P docker

**Step 8:** Build the Policy SDC Distribution docker image:

.. code-block:: bash

  cd ~/git/onap/policy/distribution/packages
  mvn clean install -P docker


Starting the ONAP Policy Framework Docker Images
************************************************

In order to run the containers, you can use *docker-compose*. This uses the *docker-compose.yml* yaml file to bring up the ONAP Policy Framework. This file is located in the policy/docker repository.

**Step 1:** Set the environment variable *MTU* to be a suitable MTU size for the application.

.. code-block:: bash

  export MTU=9126


**Step 2:** Determine if you want the legacy Policy Engine to have policies pre-loaded or not. By default, all the configuration and operational policies will be pre-loaded by the docker compose script. If you do not wish for that to happen, then export this variable:

.. note:: This applies ONLY to the legacy Engine and not the Policy Lifecycle polices

.. code-block:: bash

  export PRELOAD_POLICIES=false


**Step 3:** Run the system using *docker-compose*. Note that on some systems you may have to run the *docker-compose* command as root or using *sudo*. Note that this command takes a number of minutes to execute on a laptop or desktop computer.

.. code-block:: bash

  docker-compose up -d


**You now have a full standalone ONAP Policy framework up and running!**

