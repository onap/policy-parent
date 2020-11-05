.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _policy-development-tools-label:

Policy Platform Development Tools
#################################

.. contents::
    :depth: 3


This article explains how to build the ONAP Policy Framework for development purposes and how to run stability/performance tests for a variety of components. To start, the developer should consult the latest ONAP Wiki to familiarize themselves with developer best practices and how-tos to setup their environment, see `https://wiki.onap.org/display/DW/Developer+Best+Practices`.


This article assumes that:

* You are using a *\*nix* operating system such as linux or macOS.
* You are using a directory called *git* off your home directory *(~/git)* for your git repositories
* Your local maven repository is in the location *~/.m2/repository*
* You have copied the settings.xml from oparent to *~/.m2/* directory
* You have added settings to access the ONAP Nexus to your M2 configuration, see `Maven Settings Example <https://wiki.onap.org/display/DW/Setting+Up+Your+Development+Environment>`_ (bottom of the linked page)

The procedure documented in this article has been verified to work on a MacBook laptop running macOS Mojave Version 10.14.6 and an Unbuntu 18.06 VM.

Cloning All The Policy Repositories
***********************************

Run a script such as the script below to clone the required modules from the `ONAP git repository <https://gerrit.onap.org/r/#/admin/projects/?filter=policy>`_. This script clones all the ONAP Policy Framework repositories.

ONAP Policy Framework has dependencies to the ONAP Parent *oparent* module, the ONAP ECOMP SDK *ecompsdkos* module, and the A&AI Schema module.


.. code-block:: bash
   :caption: Typical ONAP Policy Framework Clone Script
   :linenos:

    #!/usr/bin/env bash

    ## script name for output
    MOD_SCRIPT_NAME=`basename $0`

    ## the ONAP clone directory, defaults to "onap"
    clone_dir="onap"

    ## the ONAP repos to clone
    onap_repos="\
    policy/parent \
    policy/common \
    policy/models \
    policy/docker \
    policy/api \
    policy/pap \
    policy/apex-pdp \
    policy/drools-pdp \
    policy/drools-applications \
    policy/xacml-pdp \
    policy/distribution \
    policy/gui \
    policy/engine "

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
    *  ~/git/onap/policy/api
    *  ~/git/onap/policy/pap
    *  ~/git/onap/policy/gui
    *  ~/git/onap/policy/docker
    *  ~/git/onap/policy/drools-applications
    *  ~/git/onap/policy/drools-pdp
    *  ~/git/onap/policy/engine
    *  ~/git/onap/policy/apex-pdp
    *  ~/git/onap/policy/xacml-pdp
    *  ~/git/onap/policy/distribution


Building ONAP Policy Framework Components
*****************************************

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
            <module>api</module>
            <module>pap</module>
            <module>apex-pdp</module>
            <module>xacml-pdp</module>
            <module>drools-pdp</module>
            <module>drools-applications</module>
            <module>distribution</module>
            <module>gui</module>
            <!-- The engine repo is being deprecated,
            and can be ommitted if not working with
            legacy api and components. -->
            <module>engine</module>
        </modules>
    </project>

**Policy Architecture/API Transition**

In Dublin, a new Policy Architecture was introduced. The legacy architecture runs in parallel with the new architecture. It will be deprecated after Frankfurt release.
If the developer is only interested in working with the new architecture components, the engine sub-module can be ommitted.


**Step 3:** You can now build the Policy framework.

Java artifacts only:

    .. code-block:: bash

       cd ~/git/onap
       mvn clean install

With docker images:

    .. code-block:: bash

       cd ~/git/onap
       mvn clean install -P docker

Developing and Debugging each Policy Component
**********************************************

Running a MariaDb Instance
++++++++++++++++++++++++++

The Policy Framework requires a MariaDb instance running. The easiest way to do this is to run a docker image locally. 

One example on how to do this is to use the scripts used by the policy/api S3P tests.

`Simulator Setup Script Example <https://gerrit.onap.org/r/gitweb?p=policy/api.git;a=tree;f=testsuites/stability/src/main/resources/simulatorsetup;h=9038413f67cff2e2a79d6345f198f96ee0c57de1;hb=refs/heads/guilin>`_

    .. code-block:: bash

       cd ~/git/onap/api/testsuites/stability/src/main/resources/simulatorsetup
       ./setup_components.sh

Another example on how to run the MariaDb is using the docker compose file used by the Policy API CSITs:

`Example Compose Script to run MariaDB <https://gerrit.onap.org/r/gitweb?p=integration/csit.git;a=blob;f=scripts/policy/docker-compose-api.yml;h=e32190f1e6cb6d9b64ddf53a2db2c746723a0c6a;hb=refs/heads/guilin>`_

Running the API component standalone
+++++++++++++++++++++++++++++++++++++

Assuming you have successfully built the codebase using the instructions above. The only requirement for the API component to run is a
running MariaDb database instance. The easiest way to do this is to run the docker image, please see the mariadb documentation for the latest
information on doing so. Once the mariadb is up and running, a configuration file must be provided to the api in order for it to know how to
connect to the mariadb. You can locate the default configuration file in the packaging of the api component:

`Default API Configuration <https://gerrit.onap.org/r/gitweb?p=policy/api.git;a=blob;f=packages/policy-api-tarball/src/main/resources/etc/defaultConfig.json;h=042fb9d54c79ce4dad517e2564636632a8ecc550;hb=refs/heads/guilin>`_

You will want to change the fields pertaining to "host", "port" and "databaseUrl" to your local environment settings.

Running the API component using Docker Compose
++++++++++++++++++++++++++++++++++++++++++++++

An example of running the api using a docker compose script is located in the Policy Integration CSIT test repository.

`Policy CSIT API Docker Compose <https://gerrit.onap.org/r/gitweb?p=integration/csit.git;a=blob;f=scripts/policy/docker-compose-api.yml;h=e32190f1e6cb6d9b64ddf53a2db2c746723a0c6a;hb=refs/heads/guilin>`_

Running the Stability/Performance Tests
***************************************

The following links contain instructions on how to run the S3P Stability and Performance tests. These may be helpful to developers to become
familiar with the Policy Framework components and test any local changes.

.. toctree::
   :maxdepth: 1

   api-s3p.rst
   pap-s3p.rst
   apex-s3p.rst
   drools-s3p.rst
   xacml-s3p.rst
   distribution-s3p.rst

