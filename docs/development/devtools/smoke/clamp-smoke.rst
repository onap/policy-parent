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

Cloning CLAMP automation composition and all dependency
*******************************************************

Run a script such as the script below to clone the required modules from the `ONAP git repository <https://gerrit.onap.org/r/admin/repos/q/filter:policy>`_. This script clones CLAMP automation composition and all dependency.

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
    policy/clamp "

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


Building CLAMP automation composition and all dependency
********************************************************

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
        <inceptionYear>2023</inceptionYear>
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

Build java artifacts only:

    .. code-block:: bash

       cd ~/git/onap/policy
       mvn clean install

Build with docker images:

    .. code-block:: bash

       cd ~/git/onap/policy/clamp/packages/
       mvn clean install -P docker

       cd ~/git/onap/policy/models/models-sim/packages
       mvn clean install -P docker

Running MariaDb and DMaaP Simulator
***********************************

Running a MariaDb Instance
++++++++++++++++++++++++++

Assuming you have successfully built the codebase using the instructions above. There are two requirements for the Clamp automation composition component to run, one of them is a
running MariaDb database instance. The easiest way to do this is to run the docker image locally.

A sql such as the one below can be used to build the SQL initialization. Create the *mariadb.sql* file in the directory *~/git*.

    .. code-block:: SQL

       create database clampacm;
       CREATE USER 'policy'@'%' IDENTIFIED BY 'P01icY';
       GRANT ALL PRIVILEGES ON clampacm.* TO 'policy'@'%';


Execution of the command above results in the creation and start of the *mariadb-smoke-test* container.

    .. code-block:: bash

       cd ~/git
       docker run --name mariadb-smoke-test  \
        -p 3306:3306 \
        -e MYSQL_ROOT_PASSWORD=my-secret-pw  \
        --mount type=bind,source=$HOME/git/mariadb.sql,target=/docker-entrypoint-initdb.d/data.sql \
        -d mariadb:10.10.2 \
        --lower-case-table-names=1


Running the DMaaP Simulator during Development
++++++++++++++++++++++++++++++++++++++++++++++
The second requirement for the Clamp automation composition component to run is to run the DMaaP simulator. You can run it from the command line using Maven.


Create a new configuration file *~/git/onap/policy/models/models-sim/policy-models-simulators/src/test/resources/newParameters.json* using the below code:

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
      mvn exec:java  -Dexec.mainClass=org.onap.policy.models.simulators.Main -Dexec.args="src/test/resources/newParameters.json"


Developing and Debugging CLAMP automation composition
*****************************************************

Running on the Command Line using Maven
+++++++++++++++++++++++++++++++++++++++

Once the mariadb and DMaap simulator are up and running, run the following commands:

   .. code-block:: bash

      cd ~/git/onap/policy/clamp/runtime-acm
      mvn spring-boot:run


Running on the Command Line
+++++++++++++++++++++++++++

   .. code-block:: bash

      cd ~/git/onap/policy/clamp/runtime-acm
      java -jar target/policy-clamp-runtime-acm-6.4.2-SNAPSHOT.jar


Running in Eclipse
++++++++++++++++++

1. Check out the policy models repository
2. Go to the *policy-clamp-runtime-acm* module in the clamp repo
3. Where necessary Add as Source Folder 'target/generated-sources/swagger'
4. Specify a run configuration using the class *org.onap.policy.clamp.acm.runtime.Application* as the main class
5. Run the configuration

Swagger UI of Automation composition is available at *http://localhost:6969/onap/policy/clamp/acm/swagger-ui/index.html*


Running one or more participants
++++++++++++++++++++++++++++++++

Into :ref:`HTTP Participant <clamp-acm-http-participant>` you can find a test case with http-participant.

Run the following commands:

   .. code-block:: bash

      cd ~/git/onap/policy/clamp/participant/participant-impl/participant-impl-http
      java -jar target/policy-clamp-participant-impl-http-6.4.2-SNAPSHOT.jar


Running the CLAMP automation composition docker image
+++++++++++++++++++++++++++++++++++++++++++++++++++++

Create the '*docker-composition.yaml*' using following code:

   .. code-block:: yaml

      version: '3.1'

      services:
        mariadb:
          image: mariadb:10.10.2
          volumes:
            - type: bind
              source: ./mariadb.sql
              target: /docker-entrypoint-initdb.d/data.sql
          environment:
            - MYSQL_ROOT_PASSWORD=my-secret-pw
            - lower-case-table-names=1
          ports:
            - "3306:3306"

        runtime-acm:
          image: onap/policy-clamp-runtime-acm
          environment:
            - mariadb.host=mariadb
            - topicServer=message-router
          volumes:
            - type: bind
              source: ./onap/policy/clamp/runtime-acm/src/main/resources/application.yaml
              target: /opt/app/policy/clamp/etc/AcRuntimeParameters.yaml
          ports:
            - "6969:6969"

        message-router:
          image: onap/policy-models-simulator
          volumes:
            - type: bind
              source: ./onap/policy/models/models-sim/policy-models-simulators/src/test/resources/newParameters.json
              target: /opt/app/policy/simulators/etc/mounted/simParameters.json
          ports:
            - "3904:3904"

Run the docker composition:

   .. code-block:: bash

      cd ~/git/
      docker-compose up


Swagger UI of automation composition is available at *http://localhost:6969/onap/policy/clamp/acm/swagger-ui/index.html*
