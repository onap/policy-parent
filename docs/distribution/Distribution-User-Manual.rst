.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0


Policy Distribution User Manual
*******************************

.. contents::
    :depth: 3

Installation
^^^^^^^^^^^^

Requirements
------------

            .. container:: paragraph

               Distribution is 100% written in Java and runs on any platform
               that supports a JVM, e.g. Windows, Unix, Cygwin.

Installation Requirements
#########################

               .. container:: ulist

                  -  Downloaded distribution: JAVA runtime environment
                     (JRE, Java 11, Distribution is tested with the
                     OpenJDK)

                  -  Building from source: JAVA development kit (JDK,
                     Java 11, Distribution is tested with the OpenJDK)

                  -  Sufficient rights to install Distribution on the system

                  -  Installation tools

                     .. container:: ulist

                        -  TAR and GZ to extract from that TAR.GZ
                           distribution

                           .. container:: ulist

                              -  Windows for instance
                                 `7Zip <http://www.7-zip.org/>`__

                        -  `Docker <https://www.docker.com/>`__ to run Distribution
                           inside a Docker container


Build (Install from Source) Requirements
########################################

               .. container:: paragraph

                  Installation from source requires a few development
                  tools

               .. container:: ulist

                  -  GIT to retrieve the source code

                  -  Java SDK, Java version 8 or later

                  -  Apache Maven 3 (the Distribution build environment)

Get the Distribution Source Code
--------------------------------

            .. container:: paragraph

               The Distribution source code is hosted in ONAP as project distribution.
               The current stable version is in the master branch.
               Simply clone the master branch from ONAP using HTTPS.

            .. container:: listingblock

               .. container:: content

                  .. code:: text

                     git clone https://gerrit.onap.org/r/policy/distribution

Build Distribution
------------------

   .. container:: paragraph

      The examples in this document assume that the distribution source
      repositories are cloned to:

   .. container:: ulist

      -  Unix, Cygwin: ``/usr/local/src/distribution``

      -  Windows: ``C:\dev\distribution``

      -  Cygwin: ``/cygdrive/c/dev/distribution``

   .. important::
      A Build requires ONAP Nexus
      Distribution has a dependency to ONAP parent projects. You might need to adjust your Maven M2 settings. The most current
      settings can be found in the ONAP oparent repo: `Settings <https://git.onap.org/oparent/plain/settings.xml>`__.

   .. important::
      A Build needs Space
      Building distribution requires approximately 1-2 GB of hard disc space, 100 MB for the actual build with full
      distribution and around 1 GB for the downloaded dependencies.

   .. important::
      A Build requires Internet (for first build)
      During the build, several (a lot) of Maven dependencies will be downloaded and stored in the configured local Maven
      repository. The first standard build (and any first specific build) requires Internet access to download those
      dependencies.

   .. container:: paragraph

      Use Maven for a standard build without any tests.

      +-------------------------------------------------------+--------------------------------------------------------+
      | Unix, Cygwin                                          | Windows                                                |
      +=======================================================+========================================================+
      | .. container::                                        | .. container::                                         |
      |                                                       |                                                        |
      |    .. container:: content                             |    .. container:: content                              |
      |                                                       |                                                        |
      |       .. code:: text                                  |       .. code:: text                                   |
      |                                                       |                                                        |
      |         # cd /usr/local/src/distribution              |          >c:                                           |
      |         # mvn clean install -DskipTest                |          >cd \dev\distribution                         |
      |                                                       |          >mvn clean install -DskipTests                |
      +-------------------------------------------------------+--------------------------------------------------------+

.. container:: paragraph

   The build takes 2-3 minutes on a standard development laptop. It
   should run through without errors, but with a lot of messages from
   the build process.

|

.. container:: paragraph

   When Maven is finished with the build, the final screen should look
   similar to this (omitting some ``success`` lines):

.. container:: listingblock

   .. container:: content

      .. code:: text

        [INFO] ------------------------------------------------------------------------
        [INFO] Reactor Summary:
        [INFO]
        [INFO] policy-distribution ................................ SUCCESS [  3.666 s]
        [INFO] distribution-model ................................. SUCCESS [ 11.234 s]
        [INFO] forwarding ......................................... SUCCESS [  7.611 s]
        [INFO] reception .......................................... SUCCESS [  7.072 s]
        [INFO] main ............................................... SUCCESS [ 21.017 s]
        [INFO] plugins ............................................ SUCCESS [  0.453 s]
        [INFO] forwarding-plugins ................................. SUCCESS [01:20 min]
        [INFO] reception-plugins .................................. SUCCESS [ 18.545 s]
        [INFO] Policy Distribution Packages ....................... SUCCESS [  0.419 s]
        [INFO] ------------------------------------------------------------------------
        [INFO] BUILD SUCCESS
        [INFO] ------------------------------------------------------------------------
        [INFO] Total time: 02:39 min
        [INFO] Finished at: 2018-11-15T13:59:09Z
        [INFO] Final Memory: 73M/1207M
        [INFO] ------------------------------------------------------------------------

.. container:: paragraph

   The build will have created all artifacts required for distribution
   installation. The following example show how to change to the target
   directory and how it should look.

+----------------------------------------------------------------------------------------------------------------------------+
| Unix, Cygwin                                                                                                               |
+============================================================================================================================+
| .. container::                                                                                                             |
|                                                                                                                            |
|    .. container:: listingblock                                                                                             |
|                                                                                                                            |
|       .. container:: content                                                                                               |
|                                                                                                                            |
|          .. code:: text                                                                                                    |
|                                                                                                                            |
|             -rw-r--r-- 1 user 1049089    10616 Oct 31 13:35 checkstyle-checker.xml                                         |
|             -rw-r--r-- 1 user 1049089      609 Oct 31 13:35 checkstyle-header.txt                                          |
|             -rw-r--r-- 1 user 1049089      245 Oct 31 13:35 checkstyle-result.xml                                          |
|             -rw-r--r-- 1 user 1049089       89 Oct 31 13:35 checkstyle-cachefile                                           |
|             drwxr-xr-x 1 user 1049089        0 Oct 31 13:35 maven-archiver/                                                |
|             -rw-r--r-- 1 user 1049089     7171 Oct 31 13:35 policy-distribution-tarball-2.0.1-SNAPSHOT.jar                 |
|             drwxr-xr-x 1 user 1049089        0 Oct 31 13:35 archive-tmp/                                                   |
|             -rw-r--r-- 1 user 1049089 66296012 Oct 31 13:35 policy-distribution-tarball-2.0.1-SNAPSHOT-tarball.tar.gz      |
|             drwxr-xr-x 1 user 1049089        0 Nov 12 10:56 test-classes/                                                  |
|             drwxr-xr-x 1 user 1049089        0 Nov 20 14:31 classes/                                                       |
+----------------------------------------------------------------------------------------------------------------------------+

+-------------------------------------------------------------------------------------------------------------------+
| Windows                                                                                                           |
+===================================================================================================================+
| .. container::                                                                                                    |
|                                                                                                                   |
|    .. container:: listingblock                                                                                    |
|                                                                                                                   |
|       .. container:: content                                                                                      |
|                                                                                                                   |
|          .. code:: text                                                                                           |
|                                                                                                                   |
|                 11/12/2018  10:56 AM    <DIR>          .                                                          |
|                 11/12/2018  10:56 AM    <DIR>          ..                                                         |
|                 10/31/2018  01:35 PM    <DIR>          archive-tmp                                                |
|                 10/31/2018  01:35 PM                89 checkstyle-cachefile                                       |
|                 10/31/2018  01:35 PM            10,616 checkstyle-checker.xml                                     |
|                 10/31/2018  01:35 PM               609 checkstyle-header.txt                                      |
|                 10/31/2018  01:35 PM               245 checkstyle-result.xml                                      |
|                 11/20/2018  02:31 PM    <DIR>          classes                                                    |
|                 10/31/2018  01:35 PM    <DIR>          maven-archiver                                             |
|                 10/31/2018  01:35 PM        66,296,012 policy-distribution-tarball-2.0.1-SNAPSHOT-tarball.tar.gz  |
|                 10/31/2018  01:35 PM             7,171 policy-distribution-tarball-2.0.1-SNAPSHOT.jar             |
|                 11/12/2018  10:56 AM    <DIR>          test-classes                                               |
+-------------------------------------------------------------------------------------------------------------------+

Install Distribution
--------------------

   .. container:: paragraph

      Distribution can be installed in different ways:

   .. container:: ulist

      -  Windows, Unix, Cygwin: manually from a ``.tar.gz`` archive

      -  Windows, Unix, Cygwin: build from source using Maven, then
         install manually

Install Manually from Archive (Windows, 7Zip, GUI)
##################################################

   .. container:: paragraph

      Download a ``tar.gz`` archive and copy the file into the install
      folder (in this example ``C:\distribution``). Assuming you are using 7Zip,
      right click on the file and extract the ``tar`` archive.

|

      .. container:: content

         Extract the TAR archive

   .. container:: paragraph

      Then right-click on the new created TAR file and extract the actual
      distribution.

|

      .. container:: content

         Extract the distribution

   .. container:: paragraph

      Inside the new distribution folder you see the main directories: ``bin``,
      ``etc``and ``lib``

|

   .. container:: paragraph

      Once extracted, please rename the created folder to
      ``distribution-full-2.0.2-SNAPSHOT``. This will keep the directory name in
      line with the rest of this documentation.

Build from Source
-----------------

Build and Install Manually (Unix, Windows, Cygwin)
##################################################

      .. container:: paragraph

         Clone the Distribution GIT repositories into a directory. Go to that
         directory. Use Maven to build Distribution (all details on building
         Distribution from source can be found in *Distribution HowTo: Build*).

      .. container:: paragraph

         Now, take the ``.tar.gz`` file and install distribution.

Installation Layout
-------------------

   .. container:: paragraph

      A full installation of distribution comes with the following layout.

   .. container:: listingblock

      .. container:: content

                - bin
                - etc
                - lib

Running Distribution in Docker
------------------------------

Run in ONAP
###########

      .. container:: paragraph

         Running distribution from the ONAP docker repository only requires 2
         commands:

      .. container:: olist arabic

         #. Log into the ONAP docker repo

      .. container:: listingblock

         .. container:: content

            ::

               docker login -u docker -p docker nexus3.onap.org:10003

      .. container:: olist arabic

         #. Run the distribution docker image

      .. container:: listingblock

         .. container:: content

            ::

               docker run -it --rm  nexus3.onap.org:10003/onap/policy-distribution:latest

Build a Docker Image
####################

      .. container:: paragraph

         Alternatively, one can use the Dockerfile defined in the Docker
         package to build an image.

Distribution Configurations Explained
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Introduction to Distribution Configuration
------------------------------------------

         .. container:: paragraph

            A distribution engine can be configured to use various combinations
            of policy reception handlers, policy decoders and policy forwarders.
            The system is built using a plugin architecture. Each configuration
            option is realized by a plugin, which can be loaded and
            configured when the engine is started. New plugins can be
            added to the system at any time, though to benefit from a
            new plugin, an engine will need to be restarted.

    |

         .. container:: paragraph

            The distribution already comes with sdc reception handler,
            file reception handler, hpa optimization policy decoder, file in csar policy decoder,
            policy lifecycle api forwarder.

General Configuration Format
----------------------------

         .. container:: paragraph

            The distribution configuration file is a JSON file containing a few
            main blocks for different parts of the configuration. Each
            block then holds the configuration details. The following
            code shows the main blocks:

         .. container:: listingblock

            .. container:: content

               .. code:: text

                  {
                    "restServerParameters":{
                      ... (1)
                    },
                    "receptionHandlerParameters":{ (2)
                      "pluginHandlerParameters":{ (3)
                        "policyDecoders":{...}, (4)
                        "policyForwarders":{...} (5)
                      }
                    },
                    "receptionHandlerConfigurationParameters":{
                      ... (6)
                    }
                    ,
                    "policyForwarderConfigurationParameters":{
                      ... (7)
                    }
                    ,
                    "policyDecoderConfigurationParameters":{
                      ... (8)
                    }
                  }

         .. container:: colist arabic

            +-----------------------------------+-----------------------------------+
            | **1**                             | rest server configuration         |
            +-----------------------------------+-----------------------------------+
            | **2**                             | reception handler plugin          |
            |                                   | configurations                    |
            +-----------------------------------+-----------------------------------+
            | **3**                             | plugin handler parameters         |
            |                                   | configuration                     |
            +-----------------------------------+-----------------------------------+
            | **4**                             | policy decoder plugin             |
            |                                   | configuration                     |
            +-----------------------------------+-----------------------------------+
            | **5**                             | policy forwarder plugin           |
            |                                   | configuration                     |
            +-----------------------------------+-----------------------------------+
            | **6**                             | reception handler plugin          |
            |                                   | parameters                        |
            +-----------------------------------+-----------------------------------+
            | **7**                             | policy forwarder plugin           |
            |                                   | parameters                        |
            +-----------------------------------+-----------------------------------+
            | **8**                             | policy decoder plugin             |
            |                                   | parameters                        |
            +-----------------------------------+-----------------------------------+

A configuration example
-----------------------

         .. container:: paragraph

            The following example loads HPA use case & general tosca policy related plug-ins.

         .. container:: paragraph

            Notifications are consumed from SDC through SDC client.
            Consumed artifacts format is CSAR.

         .. container:: paragraph

            Generated policies are forwarded to policy lifecycle api's for creation & deployment.

         .. container:: listingblock

            .. container:: content

               .. code:: text

                {
                    "name":"SDCDistributionGroup",
                    "restServerParameters":{
                        "host":"0.0.0.0",
                        "port":6969,
                        "userName":"healthcheck",
                        "password":"zb!XztG34"
                      },
                    "receptionHandlerParameters":{
                         "SDCReceptionHandler":{
                            "receptionHandlerType":"SDC",
                            "receptionHandlerClassName":"org.onap.policy.distribution.reception.handling.sdc.SdcReceptionHandler",
                                "receptionHandlerConfigurationName":"sdcConfiguration",
                            "pluginHandlerParameters":{
                                "policyDecoders":{
                                    "ToscaPolicyDecoder":{
                                        "decoderType":"ToscaPolicyDecoder",
                                        "decoderClassName":"org.onap.policy.distribution.reception.decoding.policy.file.PolicyDecoderFileInCsarToPolicy",
                                        "decoderConfigurationName": "toscaPolicyDecoderConfiguration"
                                    }
                                },
                                "policyForwarders":{
                                    "LifeCycleApiForwarder":{
                                        "forwarderType":"LifeCycleAPI",
                                        "forwarderClassName":"org.onap.policy.distribution.forwarding.lifecycle.api.LifecycleApiPolicyForwarder",
                                        "forwarderConfigurationName": "lifecycleApiConfiguration"
                                    }
                                }
                            }
                        }
                    },
                    "receptionHandlerConfigurationParameters":{
                        "sdcConfiguration":{
                            "parameterClassName":"org.onap.policy.distribution.reception.handling.sdc.SdcReceptionHandlerConfigurationParameterGroup",
                            "parameters":{
                                "asdcAddress": "sdc-be.onap:8443",
                                "messageBusAddress": [
                                "message-router.onap"
                                 ],
                                "user": "policy",
                                "password": "Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U",
                                "pollingInterval":20,
                                "pollingTimeout":30,
                                "consumerId": "policy-id",
                                "artifactTypes": [
                                "TOSCA_CSAR",
                                "HEAT"
                                ],
                                "consumerGroup": "policy-group",
                                "environmentName": "AUTO",
                                "keystorePath": "null",
                                "keystorePassword": "null",
                                "activeserverTlsAuth": false,
                                "isFilterinEmptyResources": true,
                                "isUseHttpsWithDmaap": true
                            }
                        }
                    },
                    "policyDecoderConfigurationParameters":{
                        "toscaPolicyDecoderConfiguration":{
                            "parameterClassName":"org.onap.policy.distribution.reception.decoding.policy.file.PolicyDecoderFileInCsarToPolicyParameterGroup",
                            "parameters":{
                                "policyFileName": "tosca_policy",
                                "policyTypeFileName": "tosca_policy_type"
                            }
                        }
                    },
                    "policyForwarderConfigurationParameters":{
                        "lifecycleApiConfiguration": {
                            "parameterClassName": "org.onap.policy.distribution.forwarding.lifecycle.api.LifecycleApiForwarderParameters",
                            "parameters": {
                                "apiParameters": {
                                    "hostName": "policy-api",
                                    "port": 6969,
                                    "userName": "healthcheck",
                                    "password": "zb!XztG34"
                                },
                                "papParameters": {
                                    "hostName": "policy-pap",
                                    "port": 6969,
                                    "userName": "healthcheck",
                                    "password": "zb!XztG34"
                                },
                                "isHttps": true,
                                "deployPolicies": true
                            }
                        }
                    }
                }


The Distribution Engine
^^^^^^^^^^^^^^^^^^^^^^^

         .. container:: paragraph

            The Distribution engine can be started using ``policy-dist.sh`` script.
            The script is located in the source code at
            *distribution/packages/policy-distribution-docker/src/main/docker*
            directory

    |

         .. container:: paragraph

            On UNIX and Cygwin systems use ``policy-dist.sh`` script.

    |

         .. container:: paragraph

            On Windows systems navigate to the distribution installation directory.
            Run the following command
            ``java -cp "etc:lib\*" org.onap.policy.distribution.main.startstop.Main -c <config-file-path>``

    |

         .. container:: paragraph

            The Distribution engine comes with CLI arguments for setting
            configuration. The configuration file is always required.
            The option ``-h`` prints a help screen.

         .. container:: listingblock

            .. container:: content

               .. code:: text

                  usage: org.onap.policy.distribution.main.startstop.Main [options...]
                  options
                  -c,--config-file <CONFIG_FILE>  the full path to the configuration file to use, the configuration file must be a Json file
                                                  containing the distribution configuration parameters
                  -h,--help                       outputs the usage of this command
                  -v,--version                    outputs the version of distribution system


The Distribution REST End-points
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

         .. container:: paragraph

            The distribution engine comes with built-in REST based
            endpoints for fetching health check status & statistical data
            of running distribution system.

         .. container:: listingblock

            .. container:: content

               .. code:: text

                  # Example Output from curl http -a '{user}:{password}' :6969/healthcheck

                      HTTP/1.1 200 OK
                    Content-Length: XXX
                    Content-Type: application/json
                    Date: Tue, 17 Apr 2018 10:51:14 GMT
                    Server: Jetty(9.3.20.v20170531)
                    {
                         "code":200,
                         "healthy":true,
                         "message":"alive",
                         "name":"Policy SSD",
                         "url":"self"
                    }

                  # Example Output from curl http -a '{user}:{password}' :6969/statistics

                    HTTP/1.1 200 OK
                    Content-Length: XXX
                    Content-Type: application/json
                    Date: Tue, 17 Apr 2018 10:51:14 GMT
                    Server: Jetty(9.3.20.v20170531)
                    {
                         "code":200,
                         "distributions":10,
                         "distribution_complete_ok":8,
                         "distribution_complete_fail":2,
                         "downloads":15,
                         "downloads_ok"; 10,
                         "downloads_error": 5
                    }

