.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

CLAMP Policy Participant Smoke Tests
------------------------------------

1. Introduction
***************

The Smoke testing of the policy participant is executed in a local CLAMP/Policy environment. The CLAMP-ACM interfaces interact with the Policy Framework to perform actions based on the state of the policy participant. The goal of the Smoke tests is the ensure that CLAMP Policy Participant and Policy Framework work together as expected.
All applications will be running by console, so they need to run with different ports. Configuration files should be changed accordingly.

+------------------------------+-------+
| Application                  |  port |
+==============================+=======+
| MariDB                       |  3306 |
+------------------------------+-------+
| Zookeeper                    |  2181 |
+------------------------------+-------+
| Kafka                        | 29092 |
+------------------------------+-------+
| policy-api                   |  6968 |
+------------------------------+-------+
| policy-pap                   |  6970 |
+------------------------------+-------+
| policy-clamp-runtime-acm     |  6969 |
+------------------------------+-------+
| onap/policy-clamp-ac-pf-ppnt |  8085 |
+------------------------------+-------+


2. Setup Guide
**************

This section will show the developer how to set up their environment to start testing in GUI with some instruction on how to carry out the tests. There are several prerequisites. Note that this guide is written by a Linux user - although the majority of the steps show will be exactly the same in Windows or other systems.

2.1 Prerequisites
=================

- Java 17
- Maven 3.9
- Git
- Refer to this guide for basic environment setup `Setting up dev environment <https://wiki.onap.org/display/DW/Setting+Up+Your+Development+Environment>`_

2.2 Cloning CLAMP automation composition and all dependency
===========================================================

Run a script such as the script below to clone the required modules from the `ONAP git repository <https://gerrit.onap.org/r/admin/repos/q/filter:policy>`_. This script clones CLAMP automation composition and all dependency.

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
    policy/api \
    policy/clamp \
    policy/pap "

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
    *  ~/git/onap/policy/api
    *  ~/git/onap/policy/clamp
    *  ~/git/onap/policy/pap


2.3 Building CLAMP automation composition and all dependency
============================================================

**Step 1:** Setting topicParameterGroup for kafka localhost in clamp and policy-participant.
It needs to set 'kafka' as topicCommInfrastructure and 'localhost:29092' as server.
In the clamp repo, you should find the file 'runtime-acm/src/main/resources/application.yaml'. This file (in the 'runtime' parameters section) may need to be altered as below:

.. literalinclude:: files/runtime-application.yaml
   :language: yaml

Setting topicParameterGroup for kafka localhost and api/pap http client (in the 'participant' parameters section) may need to be apply into the file 'participant/participant-impl/participant-impl-policy/src/main/resources/config/application.yaml'.

.. literalinclude:: files/participant-policy-application.yaml
   :language: yaml


**Step 2:** Setting datasource.url, hibernate.ddl-auto and server.port in policy-api.
In the api repo, you should find the file 'main/src/main/resources/application.yaml'. This file may need to be altered as below:

.. literalinclude:: files/api-application.yaml
   :language: yaml


**Step 3:** Setting datasource.url, server.port, and api http client in policy-pap.
In the pap repo, you should find the file 'main/src/main/resources/application.yaml'. This file may need to be altered as below:

.. literalinclude:: files/pap-application.yaml
   :language: yaml


**Step 4:** Optionally, for a completely clean build, remove the ONAP built modules from your local repository.

    .. code-block:: bash

        rm -fr ~/.m2/repository/org/onap


**Step 5:**  A pom such as the one below can be used to build the ONAP Policy Framework modules. Create the *pom.xml* file in the directory *~/git/onap/policy*.

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
        <inceptionYear>2024</inceptionYear>
        <organization>
            <name>ONAP</name>
        </organization>

        <modules>
            <module>api</module>
            <module>clamp</module>
            <module>pap</module>
        </modules>
    </project>


**Step 6:** You can now build the Policy framework.

Build java artifacts only:

    .. code-block:: bash

       cd ~/git/onap/policy
       mvn clean install -DskipTests

Build with docker images:

    .. code-block:: bash

       cd ~/git/onap/policy/clamp/packages/
       mvn clean install -P docker

       cd ~/git/onap/policy/api/packages/
       mvn clean install -P docker

       cd ~/git/onap/policy/pap/packages/
       mvn clean install -P docker

2.4 Setting up the components
=============================

2.4.1 MariaDB and Kafka Setup
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We will be using Docker to run our mariadb instance`and Zookeeper/Kafka. It will have a total of two databases running in mariadb.

- clampacm: the policy-clamp-runtime-acm db
- policyadmin: the policy-api db

**Step 1:** Create the *mariadb.sql* file in a directory *~/git*.

    .. code-block:: SQL

       create database clampacm;
       CREATE USER 'policy'@'%' IDENTIFIED BY 'P01icY';
       GRANT ALL PRIVILEGES ON clampacm.* TO 'policy'@'%';
       CREATE DATABASE `policyadmin`;
       CREATE USER 'policy_user'@'%' IDENTIFIED BY 'policy_user';
       GRANT ALL PRIVILEGES ON policyadmin.* to 'policy_user'@'%';
       CREATE DATABASE `migration`;
       GRANT ALL PRIVILEGES ON migration.* to 'policy_user'@'%';
       FLUSH PRIVILEGES;


**Step 2:** Create the *init.sh* file in a directory *~/git* with execution permission.

    .. code-block:: sh

       #!/bin/sh

       export POLICY_HOME=/opt/app/policy
       export SQL_USER=${MYSQL_USER}
       export SQL_PASSWORD=${MYSQL_PASSWORD}
       export SCRIPT_DIRECTORY=sql

       /opt/app/policy/bin/prepare_upgrade.sh ${SQL_DB}
       /opt/app/policy/bin/db-migrator -s ${SQL_DB} -o report
       /opt/app/policy/bin/db-migrator -s ${SQL_DB} -o upgrade
       rc=$?
       /opt/app/policy/bin/db-migrator -s ${SQL_DB} -o report
       nc -l -p 6824
       exit $rc


**Step 3:** Create the *wait_for_port.sh* file in a directory *~/git* with execution permission.

    .. code-block:: sh

       #!/bin/sh

       usage() {
         echo args: [-t timeout] [-c command] hostname1 port1 hostname2 port2 ... >&2
         exit 1
       }
       tmout=300
       cmd=
       while getopts c:t: opt
       do
           case "$opt" in
               c)
                   cmd="$OPTARG"
                   ;;
               t)
                   tmout="$OPTARG"
                   ;;
               *)
                   usage
                   ;;
           esac
       done
       nargs=$((OPTIND-1))
       shift "$nargs"
       even_args=$(($#%2))
       if [ $# -lt 2 ] || [ "$even_args" -ne 0 ]
       then
           usage
       fi
       while [ $# -ge 2 ]
       do
           export host="$1"
           export port="$2"
           shift
           shift
           echo "Waiting for $host port $port..."

           while [ "$tmout" -gt 0 ]
           do
               if command -v docker > /dev/null 2>&1
               then
                   docker ps --format "table {{ .Names }}\t{{ .Status }}"
               fi
               nc -vz "$host" "$port"
               rc=$?
               if [ $rc -eq 0 ]
               then
                   break
               else
                   tmout=$((tmout-1))
                   sleep 1
               fi
           done
           if [ $rc -ne 0 ]
           then
               echo "$host port $port cannot be reached"
               exit $rc
           fi
       done
       $cmd
       exit 0


**Step 4:** Create the '*docker-compose.yaml*' using following code:

.. literalinclude:: files/docker-compose-policy.yaml
   :language: yaml


**Step 5:** Run the docker composition:

   .. code-block:: bash

      cd ~/git/
      docker compose up


2.4.2 Policy API
^^^^^^^^^^^^^^^^

In the policy-api repo, navigate to the "/main" directory. You can then run the following command to start the policy api:

.. code-block:: bash

    mvn spring-boot:run


2.4.3 Policy PAP
^^^^^^^^^^^^^^^^

In the policy-pap repo, navigate to the "/main" directory. You can then run the following command to start the policy pap:

.. code-block:: bash

    mvn spring-boot:run

2.4.4 ACM Runtime
^^^^^^^^^^^^^^^^^

To start the clampacm runtime we need to go the "runtime-acm" directory in the clamp repo. You can then run the following command to start the clampacm runtime:

.. code-block:: bash

    mvn spring-boot:run

2.4.5 ACM Policy Participant
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To start the policy participant we need to go to the "participant/participant-impl/participant-impl-policy" directory in the clamp repo. You can then run the following command to start the policy-participant:

.. code-block:: bash

    mvn spring-boot:run

3. Testing Procedure
====================

3.1 Testing Outline
^^^^^^^^^^^^^^^^^^^

To perform the Smoke testing of the policy-participant we will be verifying the behaviours of the participant when the ACM changes state. The scenarios are:

- UNDEPLOYED to DEPLOYED: participant creates policies and policyTypes specified in the ToscaServiceTemplate using policy-api and deploys the policies using pap.
- LOCK to UNLOCK: participant changes lock state to UNLOCK. No operation performed.
- UNLOCK to LOCK: participant changes lock state to LOCK. No operation performed.
- DEPLOYED to UNDEPLOYED: participant undeploys deployed policies and deletes policies and policyTypes which have been created.

3.2 Testing Steps
^^^^^^^^^^^^^^^^^

Creation of AC Definition:
**************************
An AC Definition is created by commissioning a Tosca template.
Using postman, commission a TOSCA template using the following template:

:download:`Tosca Service Template <tosca/tosca_service_template_pptnt_smoke.yaml>`

To verify this, we check that the AC Definition has been created and is in state COMMISSIONED.

    .. image:: images/pol-part-clampacm-get-composition.png

Priming AC Definition:
**********************
The AC Definition state is changed from COMMISSIONED to PRIMED using postman:

.. code-block:: json

    {
        "primeOrder": "PRIME"
    }


To verify this, we check that the AC Definition has been primed.

    .. image:: images/pol-part-clampacm-get-primed-composition.png


Creation of AC Instance:
************************
Using postman, instance the AC definition using the following template:

:download:`Instantiate ACM <json/instantiation_pptnt_smoke.json>`

To verify this, we check that the AC Instance has been created and is in state UNDEPLOYED.

    .. image:: images/pol-part-clampacm-creation-ver.png

Creation and deploy of policies and policyTypes:
************************************************
The AC Instance deploy state is changed from UNDEPLOYED to DEPLOYED using postman:

.. code-block:: json

    {
        "deployOrder": "DEPLOY"
    }

This state change will trigger the creation of policies and policyTypes using the policy-api and the deployment of the policies specified in the ToscaServiceTemplate.
To verify this we will check, using policy-api endpoints, that the onap.policies.native.apex.ac.element policy, which is specified in the service template, has been created.

    .. image:: images/pol-part-clampacm-ac-policy-ver.png

And we will check that the apex onap.policies.native.apex.ac.element policy has been deployed to the defaultGroup. We check this using pap:

    .. image:: images/pol-part-clampacm-ac-deploy-ver.png

Undeployment and deletion of policies and policyTypes:
******************************************************
The ACM STATE is changed from DEPLOYED to UNDEPLOYED using postman:

.. code-block:: json

    {
        "deployOrder": "UNDEPLOY"
    }

This state change will trigger the undeployment of the onap.policies.native.apex.ac.element policy which was deployed previously and the deletion of the previously created policies and policyTypes.
To verify this we do a PdpGroup Query as before and check that the onap.policies.native.apex.ac.element policy has been undeployed and removed from the defaultGroup:

    .. image:: images/pol-part-clampacm-ac-undep-ver.png


As before, we can check that the Test Policy policyType is not found this time and likewise for the onap.policies.native.apex.ac.element policy:

    .. image:: images/pol-part-clampacm-test-policy-nf.png
