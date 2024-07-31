.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _docker-label:

Policy Docker Usage
--------------------------

.. contents::
    :depth: 3


Starting the ONAP Policy Framework Docker Containers
****************************************************
In order to start the containers, you can use *docker-compose*. This uses the *docker-compose.yml* yaml file to
bring up the ONAP Policy Framework. This file is located in the policy/docker repository. In the csit folder there
are scripts to *automatically* bring up components in Docker, without the need to build all the images locally.

Clone the read-only version of policy/docker repo from gerrit:

.. code-block:: bash

  git clone "https://gerrit.onap.org/r/policy/docker"


The docker compose structure
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After cloning the docker repository, the scripts and compose files are under the *compose/* folder.

.. code-block:: bash

  docker
    compose
      config -- all the components configurations
      metrics -- configuration for Prometheus server and Grafana dashboards
      docker-compose.gui.yml -- compose file with gui services
      docker-compose.yml -- compose file with policy components services, including simulator, prometheus and grafana
      export-ports.sh -- script to export the http ports for all components and where the images are collected from
      get-versions.sh -- script to get the latest SNAPSHOT version of images based on branch (master is default)
      start-compose.sh -- script to start the containers / applications
      stop-compose.sh -- script to stop the containers / applications
      wait_for_port.sh -- helper script to allow some wait time before an application is completely up and running


Start the containers automatically
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Assuming all the scripts are being executed from the compose folder.

To start all components without Policy GUI:

.. code-block:: bash

  ./start-compose.sh

To start all components with Grafana dashboards and Prometheus server:

.. code-block:: bash

  ./start-compose.sh --grafana

**You now have a full standalone ONAP Policy framework up and running!**

To stop all containers, use stop-compose.sh

.. code-block:: bash

  ./stop-compose.sh


.. _building-pf-docker-images-label:

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

This image has the drools use case application and the supporting software built together with the Drools PDP engine.
It is recommended to use this image if you are first working with ONAP Policy and wish to test or learn how the use
cases work.

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

**Step 8:** Build the Policy Message Router Simulator

.. code-block:: bash

  cd ~/git/onap/policy/models/models-sim/packages
  mvn clean install -P docker

Start the containers manually
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Step 1:** Set the containers location and project.

For *local* images, set CONTAINER_LOCATION="", located at the `export-ports.sh` script
*You will need to build locally all the images using the steps in the previous section*

For *remote* images set CONTAINER_LOCATION="nexus3.onap.org:10001/"


**Step 2:** Set gerrit branch

By default, the `start-compose.sh` script will use the `get-versions.sh` to bring up latest SNAPSHOT version.
To use a different branch, edit the variable GERRIT_BRANCH located at the start of `get-versions.sh` to the
branch needed.


**Step 3:** Get all the images versions

Use the script get-versions.sh

.. code-block:: bash

  source ./get-versions.sh


**Step 4:** Run the system using the `start-compose.sh` script

.. code-block:: bash

  ./start-compose.sh <component> [--grafana] [--gui]

The <component> input is any of the policy components available:

 - api
 - pap
 - apex-pdp
 - distribution
 - drools-pdp
 - drools-applications
 - xacml-pdp
 - policy-acm-runtime


Debugging docker containers
^^^^^^^^^^^^^^^^^^^^^^^^^^^

To debug code against docker compose, the java parameters for jmxremote needs to be added to the start script
in the component.

Example:
For Policy PAP, edit the `policy-pap.sh` script:

.. code-block:: bash

  vi ~git/onap/policy/pap/packages/policy-pap-docker/src/main/docker/policy-pap.sh


Before the `-jar /app/pap.jar \ ` line, add the following block:


.. code-block:: bash

  -Dcom.sun.management.jmxremote.rmi.port=5005 \
  -Dcom.sun.management.jmxremote=true \
  -Dcom.sun.management.jmxremote.port=5005 \
  -Dcom.sun.management.jmxremote.ssl=false \
  -Dcom.sun.management.jmxremote.authenticate=false \
  -Dcom.sun.management.jmxremote.local.only=false \

On `docker-compose.yml` compose file, add to the port section the mapping 5005.

.. code-block:: yaml

  pap:
  image: ${CONTAINER_LOCATION}onap/policy-pap:${POLICY_PAP_VERSION}
  container_name: policy-pap
  depends_on:
    - mariadb
    - simulator
    - api
  hostname: policy-pap
  ports:
    - ${PAP_PORT}:6969
    - 5005:5005

That should allow an IDE to connect remotely to the 5005 port.
Follow the instructions of the IDE being used to add a remote connection.

For Intellij, under Run/Debug Configurations, add a new Remote JVM Debug, point Use module classpath to the
<component>-main sub-project.
