.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _policy-clamp-runtime-smoke-label:

CLAMP Automation Composition Smoke Tests
########################################

.. contents::
    :depth: 3


This article explains how to build the CLAMP automation composition for development purposes and how to run smoke tests for automation composition. To start, the developer should consult the latest ONAP Wiki to familiarize themselves with developer best practices and how-tos to setup their environment, see `https://wiki.onap.org/display/DW/Developer+Best+Practices`.


This article assumes that:

* You are using a *\*nix* operating system such as linux or macOS.
* You are using a directory called *git* off your home directory *(~/git)* for your git repositories
* Your local maven repository is in the location *~/.m2/repository*
* You have copied the settings.xml from oparent to *~/.m2/* directory
* You have added settings to access the ONAP Nexus to your M2 configuration, see `Maven Settings Example <https://wiki.onap.org/display/DW/Setting+Up+Your+Development+Environment>`_ (bottom of the linked page)

The procedure documented in this article has been verified using Ubuntu 20.04 LTS VM.

Cloning CLAMP automation composition
************************************

Run the below command to clone the required CLAMP automation composition:

.. code-block:: bash

    cd ~/git
    git clone https://gerrit.onap.org/r/policy/clamp clamp


Execution of the command above results in the following directory hierarchy in your *~/git* directory:

    *  ~/git/clamp


Building CLAMP automation composition
*************************************

**Step 1:** Optionally, for a completely clean build, remove the ONAP built modules from your local repository.

    .. code-block:: bash

        rm -fr ~/.m2/repository/org/onap


**Step 2:** You can now build the Policy framework.

Build java artifacts and docker images:

    .. code-block:: bash

       cd ~/git/clamp
       mvn clean install -P docker -DskipTests


Running Postgres and Kafka
**************************

Assuming you have successfully built the codebase using the instructions above. There are two requirements for the Clamp automation composition component to run, Postgres database and Kafka/Zookeeper. The easiest way to do this is to run a docker compose locally.

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


Developing and Debugging CLAMP automation composition
*****************************************************

Running ACM-R on the Command Line
+++++++++++++++++++++++++++++++++

   .. code-block:: bash

      cd ~/git/clamp/runtime-acm
      java -DRUNTIME_USER=runtimeUser -DRUNTIME_PASSWORD=zb\!XztG34 \
           -DSQL_HOST=localhost -DSQL_PORT=5432 -DSQL_USER=policy_user -DSQL_PASSWORD=policy_user \
           -DKAFKA_SERVER=localhost:29092 -DTOPIC_COMM_INFRASTRUCTURE=kafka \
           -jar target/policy-clamp-runtime-acm-9.0.1-SNAPSHOT.jar


Running participant simulator
+++++++++++++++++++++++++++++

Run the following commands:

   .. code-block:: bash

      cd ~/git/clamp/participant/participant-impl/participant-impl-simulator
      java -Dserver.port=8085 -DHTTP_USER=participantUser -DHTTP_PASSWORD=zb\!XztG34 \
           -DkafkaServer=localhost:29092 -DtopicCommInfrastructure=kafka \
           -DparticipantId=101c62b3-8918-41b9-a747-d21eb79c6c90 \
           -DapplicationName=sim-ppnt -DgroupId=policy-clamp-ac-sim-ppnt \
           -jar target/policy-clamp-participant-impl-simulator-9.0.1-SNAPSHOT.jar


Running the CLAMP automation composition docker image
+++++++++++++++++++++++++++++++++++++++++++++++++++++

Create the '*docker-compose.yaml*' using following code:

.. literalinclude:: files/docker-compose-clamp.yaml
   :language: yaml

Run the docker composition:

   .. code-block:: bash

      cd ~/git/
      docker compose up


Swagger UI of automation composition is available at *http://localhost:6969/onap/policy/clamp/acm/swagger-ui/index.html*
