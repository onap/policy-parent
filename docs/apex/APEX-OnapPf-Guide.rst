.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0


APEX OnapPf Guide
*****************

.. contents::
    :depth: 3

Installation
^^^^^^^^^^^^

Build and Install
-----------------

   .. container:: paragraph

      Refer to
      :ref:`Apex User Manual <apex-user-manual-label>` to find details on the build and installation of the APEX component. Information on the requirements and system configuration can also be found here.

Installation Layout
-------------------

   .. container:: paragraph

      A full installation of APEX comes with the following layout.

   .. container:: listingblock

      .. container:: content

         ::

            $APEX_HOME
                ├───bin             (1)
                ├───etc             (2)
                │   ├───editor
                │   ├───hazelcast
                │   ├───infinispan
                │   └───META-INF
                │   ├───onappf
                |       └───config      (3)
                │   └───ssl             (4)
                ├───examples            (5)
                │   ├───config          (6)
                │   ├───docker          (7)
                │   ├───events          (8)
                │   ├───html            (9)
                │   ├───models          (10)
                │   └───scripts         (11)
                ├───lib             (12)
                │   └───applications        (13)
                └───war             (14)

   .. container:: colist arabic

      +-----------------------------------+-----------------------------------+
      | **1**                             | binaries, mainly scripts (bash    |
      |                                   | and bat) to start the APEX engine |
      |                                   | and applications                  |
      +-----------------------------------+-----------------------------------+
      | **2**                             | configuration files, such as      |
      |                                   | logback (logging) and third party |
      |                                   | library configurations            |
      +-----------------------------------+-----------------------------------+
      | **3**                             | configuration file for            |
      |                                   | APEXOnapPf, such as               |
      |                                   | OnapPfConfig.json (initial        |
      |                                   | configuration for APEXOnapPf)     |
      +-----------------------------------+-----------------------------------+
      | **4**                             | ssl related files such as         |
      |                                   | policy-keystore and               |
      |                                   | policy-truststore                 |
      +-----------------------------------+-----------------------------------+
      | **5**                             | example policy models to get      |
      |                                   | started                           |
      +-----------------------------------+-----------------------------------+
      | **6**                             | configurations for the examples   |
      |                                   | (with sub directories for         |
      |                                   | individual examples)              |
      +-----------------------------------+-----------------------------------+
      | **7**                             | Docker files and additional       |
      |                                   | Docker instructions for the       |
      |                                   | examples                          |
      +-----------------------------------+-----------------------------------+
      | **8**                             | example events for the examples   |
      |                                   | (with sub directories for         |
      |                                   | individual examples)              |
      +-----------------------------------+-----------------------------------+
      | **9**                             | HTML files for some examples,     |
      |                                   | e.g. the Decisionmaker example    |
      +-----------------------------------+-----------------------------------+
      | **10**                            | the policy models, generated for  |
      |                                   | each example (with sub            |
      |                                   | directories for individual        |
      |                                   | examples)                         |
      +-----------------------------------+-----------------------------------+
      | **11**                            | additional scripts for the        |
      |                                   | examples (with sub directories    |
      |                                   | for individual examples)          |
      +-----------------------------------+-----------------------------------+
      | **12**                            | the library folder with all Java  |
      |                                   | JAR files                         |
      +-----------------------------------+-----------------------------------+
      | **13**                            | applications, also known as jar   |
      |                                   | with dependencies (or fat jars),  |
      |                                   | individually deployable           |
      +-----------------------------------+-----------------------------------+
      | **14**                            | WAR files for web applications    |
      +-----------------------------------+-----------------------------------+


Verify the APEXOnapPf Installation
----------------------------------

   .. container:: paragraph

      When APEX is installed and all settings are realized, the
      installation can be verified.

Verify Installation - run APEXOnapPf
####################################

      .. container:: paragraph

         A simple verification of an APEX installation can be done by
         simply starting the APEXOnapPf without any configuration. On
         Unix (or Cygwin) start the engine using
         ``$APEX_HOME/bin/apexOnapPf.sh``. On Windows start the engine
         using ``%APEX_HOME%\bin\apexOnapPf.bat``. The engine will fail
         to fully start. However, if the output looks similar to the
         following line, the APEX installation is realized.

      .. container:: listingblock

         .. container:: content

            .. code::
               :number-lines:

               Apex [main] INFO o.o.p.a.s.onappf.ApexStarterMain - In ApexStarter with parameters []
               Apex [main] ERROR o.o.p.a.s.onappf.ApexStarterMain - start of services-onappf failed
               org.onap.policy.apex.services.onappf.exception.ApexStarterException: apex starter configuration file was not specified as an argument
               at org.onap.policy.apex.services.onappf.ApexStarterCommandLineArguments.validateReadableFile(ApexStarterCommandLineArguments.java:278)
                       at org.onap.policy.apex.services.onappf.ApexStarterCommandLineArguments.validate(ApexStarterCommandLineArguments.java:165)
                       at org.onap.policy.apex.services.onappf.ApexStarterMain.<init>(ApexStarterMain.java:66)
                       at org.onap.policy.apex.services.onappf.ApexStarterMain.main(ApexStarterMain.java:165)


         .. container:: paragraph

            To fully verify the installation, run the ApexOnapPf by providing the configuration files.

         .. container:: paragraph

            OnapPfConfig.json is the file which contains the initial configuration to startup the ApexStarter service. The Kafka topics to be used for sending or receiving messages is also specified in the this file. Provide this file as argument while running the ApexOnapPf.

         .. container:: listingblock

            .. container:: content

               .. code::
                      :number-lines:

                      # $APEX_HOME/bin/apexOnapPf.sh -c $APEX_HOME/etc/onappf/config/OnapPfConfig.json (1)
                      # $APEX_HOME/bin/apexOnapPf.sh -c C:/apex/apex-full-2.0.0-SNAPSHOT/etc/onappf/config/OnapPfConfig.json (2)
                      >%APEX_HOME%\bin\apexOnapPf.bat -c %APEX_HOME%\etc\onappf\config\OnapPfConfig.json (3)

         .. container:: colist arabic

            +-------+---------+
            | **1** | UNIX    |
            +-------+---------+
            | **2** | Cygwin  |
            +-------+---------+
            | **3** | Windows |
            +-------+---------+

         .. container:: paragraph

            The APEXOnapPf should start successfully. Assuming the logging levels are
            not changed (default level is ``info``), the output should look
            similar to this (last few lines)

         .. container:: listingblock

            .. container:: content

               .. code::
                  :number-lines:

                  In ApexStarter with parameters [-c, C:/apex/etc/onappf/config/OnapPfConfig.json] . . .
                  Apex [main] INFO o.o.p.c.u.services.ServiceManager - service manager starting set alive
                  Apex [main] INFO o.o.p.c.u.services.ServiceManager - service manager starting register pdp status context object
                  Apex [main] INFO o.o.p.c.u.services.ServiceManager - service manager starting topic sinks
                  Apex [main] INFO o.o.p.c.u.services.ServiceManager - service manager starting Pdp Status publisher
                  Apex [main] INFO o.o.p.c.u.services.ServiceManager - service manager starting Register pdp update listener
                  Apex [main] INFO o.o.p.c.u.services.ServiceManager - service manager starting Register pdp state change request dispatcher
                  Apex [main] INFO o.o.p.c.u.services.ServiceManager - service manager starting Message Dispatcher . . .
                  Apex [main] INFO o.o.p.c.u.services.ServiceManager - service manager starting Rest Server . . .
                  Apex [main] INFO o.o.p.c.u.services.ServiceManager - service manager started
                  Apex [main] INFO o.o.p.a.s.onappf.ApexStarterMain - Started ApexStarter service

         .. container:: paragraph

            The ApexOnapPf service is now running, sending heartbeat messages to Kafka (which will be received by PAP) and listening for messages from PAP on the Kafka topic specified. Based on instructions from PAP, the ApexOnapPf will deploy or undeploy policies on the ApexEngine.

         .. container:: paragraph

            Terminate APEX by simply using ``CTRL+C`` in the console.

Running APEXOnapPf in Docker
----------------------------

      .. container:: paragraph

         Running APEX from the ONAP docker repository only requires 2
         commands:

      .. container:: olist arabic

         1. Log into the ONAP docker repo

         .. container:: listingblock

            .. container:: content

               ::

                  docker login -u docker -p docker nexus3.onap.org:10003


         2. Run the APEX docker image

         .. container:: listingblock

            .. container:: content

               ::

                  docker run -p 6969:6969 -p 23324:23324 -it --rm  nexus3.onap.org:10001/onap/policy-apex-pdp:2.1-SNAPSHOT-latest /bin/bash -c "/opt/app/policy/apex-pdp/bin/apexOnapPf.sh -c /opt/app/policy/apex-pdp/etc/onappf/config/OnapPfConfig.json"

      .. container:: paragraph

         To run the ApexOnapPf, the startup script apexOnapPf.sh along with the required configuration files are specified. Also, the ports 6969 (healthcheck) and 23324 (deployment port for the ApexEngine) are exposed.

Build a Docker Image
####################

      .. container:: paragraph

         Alternatively, one can use the Dockerfile defined in the Docker
         package to build an image.

      .. container:: listingblock

         .. container:: title

            APEX Dockerfile

         .. container:: content

            .. code::
               :number-lines:

               #
               # Docker file to build an image that runs APEX on Java 11 or better in alpine
               #
               FROM onap/policy-jre-alpine:2.0.1

               LABEL maintainer="Policy Team"

               ARG POLICY_LOGS=/var/log/onap/policy/apex-pdp
               ENV POLICY_HOME=/opt/app/policy/apex-pdp
               ENV POLICY_LOGS=$POLICY_LOGS

               RUN apk add --no-cache \
                       vim \
                       iproute2 \
                       iputils \
                   && addgroup -S apexuser && adduser -S apexuser -G apexuser \
                   && mkdir -p $POLICY_HOME \
                   && mkdir -p $POLICY_LOGS \
                   && chown -R apexuser:apexuser $POLICY_LOGS \
                   && mkdir /packages

               COPY /maven/apex-pdp-package-full.tar.gz /packages
               RUN tar xvfz /packages/apex-pdp-package-full.tar.gz --directory $POLICY_HOME \
                   && rm /packages/apex-pdp-package-full.tar.gz \
                   && find /opt/app -type d -perm 755 \
                   && find /opt/app -type f -perm 644 \
                   && chmod 755 $POLICY_HOME/bin/* \
                   && cp -pr $POLICY_HOME/examples /home/apexuser \
                   && chown -R apexuser:apexuser /home/apexuser/* $POLICY_HOME \
                   && chmod 644 $POLICY_HOME/etc/*

               USER apexuser
               ENV PATH $POLICY_HOME/bin:$PATH
               WORKDIR /home/apexuser


APEXOnapPf Configuration File Explained
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

         .. container:: paragraph

            The ApexOnapPf is initialized using a configuration file:

         .. container:: ulist

            -  OnapPfConfig.json

Format of the configuration file (OnapPfConfig.json) explained
--------------------------------------------------------------

         .. container:: paragraph

            The configuration file is a JSON file containing the initial values for configuring the rest server for healthcheck and the pdp itself.
            The topic infrastructure and the topics to be used for sending or receiving messages is specified in this configuration file.
            A sample can be found below:

         .. container:: listingblock

            .. container:: content

               .. code::

                  {
                      "name":"ApexStarterParameterGroup",
                      "restServerParameters": {  (1)
                          "host": "0.0.0.0",
                          "port": 6969,
                          "userName": "...",
                          "password": "...",
                          "https": true  (2)
                      },
                      "pdpStatusParameters":{
                          "timeIntervalMs": 120000,  (3)
                          "pdpType":"apex",  (4)
                          "pdpGroup":"defaultGroup",  (5)
                          "description":"Pdp Heartbeat",
                          "supportedPolicyTypes":[{"name":"onap.policies.controlloop.operational.Apex","version":"1.0.0"}]  (6)
                      },
                      "topicParameterGroup": {
                        "topicSources": [
                          {
                            "topic": "policy-pdp-pap",
                            "servers": [
                              "kafka:9092"
                            ],
                            "useHttps": false,
                            "topicCommInfrastructure": "kafka",
                            "fetchTimeout": 15000
                          }
                        ],
                        "topicSinks": [
                          {
                            "topic": "policy-pdp-pap",
                            "servers": [
                              "kafka:9092"
                            ],
                            "useHttps": false,
                            "topicCommInfrastructure": "kafka"
                          }
                        ]
                      }
                  }

         .. container:: colist arabic

            +-----------------------------------+-------------------------------------------------+
            | **1**                             | parameters for setting up the                   |
            |                                   | rest server such as host, port                  |
            |                                   | userName and password.                          |
            +-----------------------------------+-------------------------------------------------+
            | **2**                             | https flag if enabled will enable               |
            |                                   | https support by the rest server.               |
            +-----------------------------------+-------------------------------------------------+
            | **3**                             | time interval in which PDP-A                    |
            |                                   | has to send heartbeats to PAP.                  |
            |                                   | Specified in milliseconds.                      |
            +-----------------------------------+-------------------------------------------------+
            | **4**                             | Type of the pdp.                                |
            +-----------------------------------+-------------------------------------------------+
            | **5**                             | The group to which the pdp belong to.           |
            +-----------------------------------+-------------------------------------------------+
            | **6**                             | List of policy types supported by               |
            |                                   | the PDP. A trailing “.*” can be used to         |
            |                                   | specify multiple policy types; for example,     |
            |                                   | “onap.policies.controlloop.operational.apex.*”  |
            |                                   | would match any policy type beginning with      |
            |                                   | “onap.policies.controlloop.operational.apex.”   |
            +-----------------------------------+-------------------------------------------------+
            | **7**                             | List of topics' details from                    |
            |                                   | which messages are received.                    |
            +-----------------------------------+-------------------------------------------------+
            | **8**                             | Topic name of the source to which               |
            |                                   | PDP-A listens to for messages                   |
            |                                   | from PAP.                                       |
            +-----------------------------------+-------------------------------------------------+
            | **9**                             | List of servers for the source                  |
            |                                   | topic.                                          |
            +-----------------------------------+-------------------------------------------------+
            | **10**                            | The source topic infrastructure.                |
            |                                   | For e.g. kafka, noop                            |
            +-----------------------------------+-------------------------------------------------+
            | **11**                            | List of topics' details to which                |
            |                                   | messages are sent.                              |
            +-----------------------------------+-------------------------------------------------+
            | **12**                            | Topic name of the sink to which                 |
            |                                   | PDP-A sends messages.                           |
            +-----------------------------------+-------------------------------------------------+
            | **13**                            | List of servers for the sink                    |
            |                                   | topic.                                          |
            +-----------------------------------+-------------------------------------------------+
            | **14**                            | The sink topic infrastructure.                  |
            |                                   | For e.g. kafka, noop                            |
            +-----------------------------------+-------------------------------------------------+
