.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _docker-label:

Policy Docker Installation
--------------------------

.. contents::
    :depth: 2


Starting the ONAP Policy Framework Docker Images
************************************************
In order to start the containers, you can use *docker-compose*. This uses the *docker-compose-all.yml* yaml file to bring up the ONAP Policy Framework. This file is located in the policy/docker repository. In the csit folder there are scripts to *automatically* bring up components in Docker, without the need to build all the images locally.

Clone the read-only version of policy/docker repo from gerrit:

.. code-block:: bash

  git clone "https://gerrit.onap.org/r/policy/docker"


Start the containers automatically
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: The start-all.sh script in policy/docker/csit will bring up all the Policy Framework components, and give the local ip for the GUI. The latest images will be downloaded from Nexus.

.. code-block:: bash

  export CONTAINER_LOCATION=nexus3.onap.org:10001/
  export PROJECT=pap
  ./start-all.sh


To stop them use ./stop-all.sh

.. code-block:: bash

  ./stop-all.sh


Start the containers manually
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Step 1:** Set the containers location and project.

For *local* images, set CONTAINER_LOCATION="" (or don't set it at all)
*You will need to build locally all the images using the steps in the next chapter*

For *remote* images set CONTAINER_LOCATION="nexus3.onap.org:10001/"

.. code-block:: bash

  export CONTAINER_LOCATION=nexus3.onap.org:10001/
  export PROJECT=pap


**Step 2:** Set gerrit branch

Set GERRIT_BRANCH="master"

Or use the script get-branch.sh

.. code-block:: bash

  source ./get-branch.sh


**Step 3:** Get all the images versions

Use the script get-versions.sh

.. code-block:: bash

  source ./get-versions.sh


**Step 4:** Run the system using docker-compose

.. code-block:: bash

  docker-compose -f docker-compose-all.yml up <image> <image>


**You now have a full standalone ONAP Policy framework up and running!**


Building the ONAP Policy Framework Docker Images
************************************************
If you want to use your own local images, you can build them following these instructions:

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

**Step 7:** Build the Policy SDC Distribution docker image:

.. code-block:: bash

  cd ~/git/onap/policy/distribution/packages
  mvn clean install -P docker

