.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _policy-development-tools-label:

CLAMP control loop runtime Smoke Tests
######################################

.. contents::
    :depth: 3


This article explains how to build the CLAMP control loop runtime for development purposes and how to run smoke tests for control loop runtime. To start, the developer should consult the latest ONAP Wiki to familiarize themselves with developer best practices and how-tos to setup their environment, see `https://wiki.onap.org/display/DW/Developer+Best+Practices`.


This article assumes that:

* You are using a *\*nix* operating system such as linux or macOS.
* You are using a directory called *git* off your home directory *(~/git)* for your git repositories
* Your local maven repository is in the location *~/.m2/repository*
* You have copied the settings.xml from oparent to *~/.m2/* directory
* You have added settings to access the ONAP Nexus to your M2 configuration, see `Maven Settings Example <https://wiki.onap.org/display/DW/Setting+Up+Your+Development+Environment>`_ (bottom of the linked page)

The procedure documented in this article has been verified using Unbuntu 20.04 LTS VM.

Cloning CLAMP control loop runtime and all dependency
*****************************************************

Run a script such as the script below to clone the required modules from the `ONAP git repository <https://gerrit.onap.org/r/#/admin/projects/?filter=policy>`_. This script clones CLAMP control loop runtime and all dependency.

ONAP Policy Framework has dependencies to the ONAP Parent *oparent* module, the ONAP ECOMP SDK *ecompsdkos* module, and the A&AI Schema module.


.. code-block:: bash
   :caption: Typical ONAP Policy Framework Clone Script
   :linenos:

    #!/usr/bin/env bash

    ## script name for output
    MOD_SCRIPT_NAME='basename $0'

    ## the ONAP clone directory, defaults to "onap"
    clone_dir="onap"

    ## the ONAP repos to clone
    onap_repos="\
    policy/parent \
    policy/common \
    policy/models \
    policy/clamp \
    policy/docker "

    ##
    ## Help screen and exit condition (i.e. too few arguments)
    ##
    Help()
    {
        echo ""
        echo "$MOD_SCRIPT_NAME - clones all required ONAP git repositories"
        echo ""
        echo "       Usage:  $MOD_SCRIPT_NAME [-options]"
        echo ""
        echo "       Options"
        echo "         -d          - the ONAP clone directory, defaults to '.'"
        echo "         -h          - this help screen"
        echo ""
        exit 255;
    }

    ##
    ## read command line
    ##
    while [ $# -gt 0 ]
    do
        case $1 in
            #-d ONAP clone directory
            -d)
                shift
                if [ -z "$1" ]; then
                    echo "$MOD_SCRIPT_NAME: no clone directory"
                    exit 1
                fi
                clone_dir=$1
                shift
            ;;

            #-h prints help and exists
            -h)
                Help;exit 0;;

            *)    echo "$MOD_SCRIPT_NAME: undefined CLI option - $1"; exit 255;;
        esac
    done

    if [ -f "$clone_dir" ]; then
        echo "$MOD_SCRIPT_NAME: requested clone directory '$clone_dir' exists as file"
        exit 2
    fi
    if [ -d "$clone_dir" ]; then
        echo "$MOD_SCRIPT_NAME: requested clone directory '$clone_dir' exists as directory"
        exit 2
    fi

    mkdir $clone_dir
    if [ $? != 0 ]
    then
        echo cannot clone ONAP repositories, could not create directory '"'$clone_dir'"'
        exit 3
    fi

    for repo in $onap_repos
    do
        repoDir=`dirname "$repo"`
        repoName=`basename "$repo"`

        if [ ! -z $dirName ]
        then
            mkdir "$clone_dir/$repoDir"
            if [ $? != 0 ]
            then
                echo cannot clone ONAP repositories, could not create directory '"'$clone_dir/repoDir'"'
                exit 4
            fi
        fi

        git clone https://gerrit.onap.org/r/${repo} $clone_dir/$repo
    done

    echo ONAP has been cloned into '"'$clone_dir'"'


Execution of the script above results in the following directory hierarchy in your *~/git* directory:

    *  ~/git/onap
    *  ~/git/onap/policy
    *  ~/git/onap/policy/parent
    *  ~/git/onap/policy/common
    *  ~/git/onap/policy/models
    *  ~/git/onap/policy/clamp
    *  ~/git/onap/policy/docker


Building CLAMP control loop runtime and all dependency
******************************************************

**Step 1:** Optionally, for a completely clean build, remove the ONAP built modules from your local repository.

    .. code-block:: bash

        rm -fr ~/.m2/repository/org/onap


**Step 2:**  A pom such as the one below can be used to build the ONAP Policy Framework modules. Create the *pom.xml* file in the directory *~/git/onap/policy*.

.. code-block:: xml
   :caption: Typical pom.xml to build the ONAP Policy Framework
   :linenos:

    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>org.onap</groupId>
        <artifactId>onap-policy</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <packaging>pom</packaging>
        <name>${project.artifactId}</name>
        <inceptionYear>2017</inceptionYear>
        <organization>
            <name>ONAP</name>
        </organization>

        <modules>
            <module>parent</module>
            <module>common</module>
            <module>models</module>
            <module>clamp</module>
        </modules>
    </project>


**Step 3:** You can now build the Policy framework.

Java artifacts only:

    .. code-block:: bash

       cd ~/git/onap/policy
       mvn -pl '!org.onap.policy.clamp:policy-clamp-runtime' install

With docker images:

    .. code-block:: bash

       cd ~/git/onap/policy/clamp/packages/
       mvn clean install -P docker

Running MariaDb and DMaaP Simulator
***********************************

Running a MariaDb Instance
++++++++++++++++++++++++++

Assuming you have successfully built the codebase using the instructions above. There are two requirements for the Clamp controlloop runtime component to run, one of them is a
running MariaDb database instance. The easiest way to do this is to run the docker image locally.

An sql such as the one below can be used to build the SQL initialization. Create the *mariadb.sql* file in the directory *~/git*.

    .. code-block:: SQL

       create database controlloop;
       CREATE USER 'policy'@'%' IDENTIFIED BY 'P01icY';
       GRANT ALL PRIVILEGES ON controlloop.* TO 'policy'@'%';


Execution of the command above results in the creation and start of the *mariadb-smoke-test* container.

    .. code-block:: bash

       cd ~/git
       docker run --name mariadb-smoke-test  \
        -p 3306:3306 \
        -e MYSQL_ROOT_PASSWORD=my-secret-pw  \
        --mount type=bind,source=~/git/mariadb.sql,target=/docker-entrypoint-initdb.d/data.sql \
        mariadb:10.5.8


Running the DMaaP Simulator during Development
++++++++++++++++++++++++++++++++++++++++++++++
The second requirement for the Clamp controlloop runtime component to run is to run the DMaaP simulator. You can run it from the command line using Maven.


Change the local configuration file *src/test/resources/simParameters.json* using the below code:

.. code-block:: json

   {
     "dmaapProvider": {
       "name": "DMaaP simulator",
       "topicSweepSec": 900
     },
     "restServers": [
       {
         "name": "DMaaP simulator",
         "providerClass": "org.onap.policy.models.sim.dmaap.rest.DmaapSimRestControllerV1",
         "host": "localhost",
         "port": 3904,
         "https": false
       }
     ]
   }

Run the following commands:

   .. code-block:: bash

      cd ~/git/onap/policy/models/models-sim/policy-models-simulators
      mvn exec:java  -Dexec.mainClass=org.onap.policy.models.simulators.Main -Dexec.args="src/test/resources/simParameters.json"


Developing and Debugging CLAMP control loop runtime
***************************************************

Running on the Command Line using Maven
+++++++++++++++++++++++++++++++++++++++

Once the mariadb and DMaap simulator are up and running, run the following commands:

   .. code-block:: bash

      cd ~/git/onap/policy/clamp/runtime-controlloop
      mvn spring-boot:run


Running on the Command Line
+++++++++++++++++++++++++++

   .. code-block:: bash

      cd ~/git/onap/policy/clamp/runtime-controlloop
      java -jar target/policy-clamp-runtime-controlloop-6.1.3-SNAPSHOT.jar


Running in Eclipse
++++++++++++++++++

1. Check out the policy models repository
2. Go to the *policy-clamp-runtime-controlloop* module in the clamp repo
3. Specify a run configuration using the class *org.onap.policy.clamp.controlloop.runtime.Application* as the main class
4. Run the configuration

Swagger UI of Control loop runtime is available at *http://localhost:6969/onap/controlloop/swagger-ui/*, and swagger JSON at *http://localhost:6969/onap/controlloop/v2/api-docs/*


Running one or more participant simulators
++++++++++++++++++++++++++++++++++++++++++

Into *docker\csit\clamp\tests\data* you can find a test case with policy-participant. In order to use that test you can use particpant-simulator.
Copy the file *src/main/resources/config/application.yaml* and paste into *src/test/resources/*, after that change *participantId* and *participantType* as showed below:

   .. code-block:: yaml

      participantId:
        name: org.onap.policy.controlloop.PolicyControlLoopParticipant
        version: 2.3.1
      participantType:
        name: org.onap.PM_Policy
        version: 1.0.0

Run the following commands:

   .. code-block:: bash

      cd ~/git/onap/policy/clamp/participant/participant-impl/participant-impl-simulator
       java -jar target/policy-clamp-participant-impl-simulator-6.1.3-SNAPSHOT.jar --spring.config.location=src/test/resources/application.yaml


Creating self-signed certificate
++++++++++++++++++++++++++++++++

There is an additional requirement for the Clamp control loop runtime docker image to run, is creating the SSL self-signed certificate.

Run the following commands:

   .. code-block:: bash

      cd ~/git/onap/policy/docker/csit/
      ./gen_truststore.sh
      ./gen_keystore.sh

Execution of the commands above results additional files into the following directory *~/git/onap/policy/docker/csit/config*:

    *  ~/git/onap/policy/docker/csit/config/cakey.pem
    *  ~/git/onap/policy/docker/csit/config/careq.pem
    *  ~/git/onap/policy/docker/csit/config/caroot.cer
    *  ~/git/onap/policy/docker/csit/config/ks.cer
    *  ~/git/onap/policy/docker/csit/config/ks.csr
    *  ~/git/onap/policy/docker/csit/config/ks.jks


Running the CLAMP control loop runtime docker image
+++++++++++++++++++++++++++++++++++++++++++++++++++

Run the following command:

   .. code-block:: bash

      docker run --name runtime-smoke-test \
       -p 6969:6969 \
       -e mariadb.host=host.docker.internal \
       -e topicServer=host.docker.internal \
       --mount type=bind,source=~/git/onap/policy/docker/csit/config/ks.jks,target=/opt/app/policy/clamp/etc/ssl/policy-keystore  \
       --mount type=bind,source=~/git/onap/policy/clamp/runtime-controlloop/src/main/resources/application.yaml,target=/opt/app/policy/clamp/etc/ClRuntimeParameters.yaml  \
       onap/policy-clamp-cl-runtime


Swagger UI of Control loop runtime is available at *https://localhost:6969/onap/controlloop/swagger-ui/*, and swagger JSON at *https://localhost:6969/onap/controlloop/v2/api-docs/*
