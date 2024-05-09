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

Run a script such as the script below to clone the required modules from the `ONAP git repository <https://gerrit.onap.org/r/admin/repos/q/filter:policy>`_. This script clones CLAMP automation composition and all dependency.

.. code-block:: bash

    cd ~/git
    git clone https://gerrit.onap.org/r/policy/clamp clamp


Execution of the command above results in the following directory hierarchy in your *~/git* directory:

    *  ~/git/clamp


Building CLAMP automation composition
*************************************

**Step 1:** Setting topicParameterGroup for kafka localhost.
It needs to set 'kafka' as topicCommInfrastructure and 'localhost:29092' as server.
In the clamp repo, you should find the file 'runtime-acm/src/main/resources/application.yaml'. This file (in the 'runtime' parameters section) may need to be altered as below:

.. literalinclude:: files/runtime-application.yaml
   :language: yaml

Same changes (in the 'participant' parameters section) may need to be apply into the file 'participant/participant-impl/participant-impl-simulator/src/main/resources/config/application.yaml'.

.. literalinclude:: files/participant-sim-application.yaml
   :language: yaml

**Step 2:** Optionally, for a completely clean build, remove the ONAP built modules from your local repository.

    .. code-block:: bash

        rm -fr ~/.m2/repository/org/onap


**Step 3:** You can now build the Policy framework.

Build java artifacts only:

    .. code-block:: bash

       cd ~/git/clamp
       mvn clean install -DskipTests

Build with docker images:

    .. code-block:: bash

       cd ~/git/clamp/packages/
       mvn clean install -P docker

Running MariaDb and Kafka
*************************

Assuming you have successfully built the codebase using the instructions above. There are two requirements for the Clamp automation composition component to run, MariaDb database and Kafka/Zookeeper. The easiest way to do this is to run a docker compose locally.

A sql such as the one below can be used to build the SQL initialization. Create the *mariadb.sql* file in the directory *~/git*.

.. literalinclude:: files/mariadb.sql
   :language: SQL

Create the '*docker-compose.yaml*' using following code:

.. literalinclude:: files/docker-compose-local.yaml
   :language: yaml

Run the docker composition:

   .. code-block:: bash

      cd ~/git/
      docker compose up


Developing and Debugging CLAMP automation composition
*****************************************************

Running on the Command Line using Maven
+++++++++++++++++++++++++++++++++++++++

Once the mariadb and DMaap simulator are up and running, run the following commands:

   .. code-block:: bash

      cd ~/git/clamp/runtime-acm
      mvn spring-boot:run


Running on the Command Line
+++++++++++++++++++++++++++

   .. code-block:: bash

      cd ~/git/clamp/runtime-acm
      java -jar target/policy-clamp-runtime-acm-7.1.3-SNAPSHOT.jar


Running participant simulator
+++++++++++++++++++++++++++++

Run the following commands:

   .. code-block:: bash

      cd ~/git/clamp/participant/participant-impl/participant-impl-simulator
      java -jar target/policy-clamp-participant-impl-simulator-7.1.3-SNAPSHOT.jar


Running the CLAMP automation composition docker image
+++++++++++++++++++++++++++++++++++++++++++++++++++++

Create the '*docker-compose.yaml*' using following code:

   .. code-block:: yaml

      services:
        mariadb:
          image: mariadb:10.10.2
          command: ['mysqld', '--lower_case_table_names=1']
          volumes:
            - type: bind
              source: ./mariadb.sql
              target: /docker-entrypoint-initdb.d/data.sql
          environment:
            - MYSQL_ROOT_PASSWORD=my-secret-pw
          ports:
            - "3306:3306"

        zookeeper:
          image: confluentinc/cp-zookeeper:latest
          environment:
            ZOOKEEPER_CLIENT_PORT: 2181
            ZOOKEEPER_TICK_TIME: 2000
          ports:
            - 2181:2181
        kafka:
          image: confluentinc/cp-kafka:latest
          container_name: kafka
          depends_on:
            - zookeeper
          ports:
            - 29092:29092
            - 9092:9092
          environment:
            KAFKA_BROKER_ID: 1
            KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
            KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:9092,PLAINTEXT_HOST://localhost:29092
            KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
            KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
            KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1

        runtime-acm:
          image: onap/policy-clamp-runtime-acm
          depends_on:
            - zookeeper
            - kafka
            - mariadb
          environment:
            MARIADB_HOST: mariadb
            TOPICSERVER: kafka:9092
            SERVER_SSL_ENABLED: false
          volumes:
            - type: bind
              source: ./clamp/runtime-acm/src/main/resources/application.yaml
              target: /opt/app/policy/clamp/etc/AcRuntimeParameters.yaml
          ports:
            - "6969:6969"

        participant-simulator:
          image: onap/policy-clamp-ac-sim-ppnt
          depends_on:
            - zookeeper
            - kafka
          environment:
            MARIADB_HOST: mariadb
            TOPICSERVER: kafka:9092
            SERVER_SSL_ENABLED: false
          volumes:
            - type: bind
              source: ./clamp/participant/participant-impl/participant-impl-simulator/src/main/resources/config/application.yaml
              target: /opt/app/policy/clamp/etc/SimulatorParticipantParameters.yaml
         ports:
           - "8085:8085"

Run the docker composition:

   .. code-block:: bash

      cd ~/git/
      docker compose up


Swagger UI of automation composition is available at *http://localhost:6969/onap/policy/clamp/acm/swagger-ui/index.html*
