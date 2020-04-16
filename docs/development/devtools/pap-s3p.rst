.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. toctree::
   :maxdepth: 2

Policy PAP component
~~~~~~~~~~~~~~~~~~~~

72 Hours Stability Test of PAP
++++++++++++++++++++++++++++++

Introduction
------------

The 72 hour Stability Test for PAP has the goal of introducing a steady flow of transactions initiated from a test client server running JMeter for the duration of 72 hours.

Setup details
-------------

The stability test is performed on VM's running in OpenStack cloud environment.

There are 2 seperate VM's, one for running PAP & other one for running JMeter to simulate steady flow of transactions.

All the dependencies like mariadb, dmaap simulator, pdp simulator & policy/api component are installed in the VM having JMeter.

For simplicity lets assume

VM1 will be running JMeter, MariaDB, DMaaP simulator, PDP simulator & API component.

VM2 will be running only PAP component.

**OpenStack environment details**

Version: Mitaka

**PAP VM details (VM2)**

OS:Ubuntu 16.04 LTS

CPU: 4 core

RAM: 4 GB

HardDisk: 40 GB

Docker Version: 18.09.6

Java: openjdk version "1.8.0_212"

**JMeter VM details (VM1)**

OS: Ubuntu 16.04 LTS

CPU: 4 core

RAM: 4 GB

HardDisk: 40 GB

Docker Version: 18.09.6

Java: openjdk version "1.8.0_212"

JMeter: 5.1.1

Install Docker in VM1 & VM2
---------------------------

Make sure to execute below commands in VM1 & VM2 both.

Make the etc/hosts entries

.. code-block:: bash

    $ echo $(hostname -I | cut -d\  -f1) $(hostname) | sudo tee -a /etc/hosts
    
Make the DNS entries

.. code-block:: bash

    $ echo "nameserver <PrimaryDNSIPIP>" >> /etc/resolvconf/resolv.conf.d/head
    $ echo "nameserver <SecondaryDNSIP>" >> /etc/resolvconf/resolv.conf.d/head
    $ resolvconf -u
    
Update the ubuntu software installer

.. code-block:: bash

    $ apt-get update
    
Check and Install Java

.. code-block:: bash

    $ apt-get install -y openjdk-8-jdk
    $ java -version

Ensure that the Java version that is executing is OpenJDK version 8


Check and install docker

.. code-block:: bash

    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    $ add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    $ apt-get update
    $ apt-cache policy docker-ce
    $ apt-get install -y docker-ce
    $ systemctl status docker
    $ docker ps

Change the permissions of the Docker socket file

.. code-block:: bash

    $ chmod 777 /var/run/docker.sock
    
Check the status of the Docker service and ensure it is running correctly

.. code-block:: bash

    $ service docker status
    $ docker ps

Install JMeter in VM1
---------------------

Download & install JMeter

.. code-block:: bash

    $ mkdir jMeter
    $ cd jMeter
    $ wget http://mirrors.whoishostingthis.com/apache//jmeter/binaries/apache-jmeter-5.1.1.zip
    $ unzip apache-jmeter-5.1.1.zip

Run JMeter

.. code-block:: bash

    $ /home/ubuntu/jMeter/apache-jmeter-5.1.1/bin/jmeter

The above command will load the JMeter UI. Then navigate to File → Open → Browse and select the test plan jmx file to open. 
The jmx file is present in the policy/pap git repository.

Install simulators in VM1
-------------------------

For installing simulator, there is a script placed at `install simulator script <https://gerrit.onap.org/r/gitweb?p=policy/pap.git;a=blob;f=testsuites/stability/src/main/resources/simulatorsetup/setup_components.sh;h=86de3c1efcb468431a2395eef610db209a613fc3;hb=refs/heads/master>`_

Copy the script & all related files in virtual machine and run it.

After installation make sure that following 4 docker containers are up and running.

.. code-block:: bash

    root@policytest-policytest-3-p5djn6as2477:/home/ubuntu/simulator# docker ps
    CONTAINER ID        IMAGE                                   COMMAND                  CREATED             STATUS              PORTS                    NAMES
    887efa8dac12        nexus3.onap.org:10001/onap/policy-api   "bash ./policy-api.sh"   6 days ago          Up 6 days           0.0.0.0:6969->6969/tcp   policy-api
    0a931c0a63ac        pdp/simulator:latest                    "bash pdp-sim.sh"        6 days ago          Up 6 days                                    pdp-simulator
    a41adcb32afb        dmaap/simulator:latest                  "bash dmaap-sim.sh"      6 days ago          Up 6 days           0.0.0.0:3904->3904/tcp   dmaap-simulator
    d52d6b750ba0        mariadb:10.2.14                         "docker-entrypoint.s…"   6 days ago          Up 6 days           0.0.0.0:3306->3306/tcp   mariadb

Install PAP in VM2
------------------

For installing PAP, there is a script placed at `install pap script <https://gerrit.onap.org/r/gitweb?p=policy/pap.git;a=blob;f=testsuites/stability/src/main/resources/papsetup/setup_pap.sh;h=dc5e69e76da9f48f6b23cc012e14148f1373d1e1;hb=refs/heads/master>`_

Copy the script & all related files in virtual machine and run it.

After installation make sure that following docker container is up and running.

.. code-block:: bash

    root@policytest-policytest-0-uc3y2h5x6p4j:/home/ubuntu/pap# docker ps
    CONTAINER ID        IMAGE                                                         COMMAND                  CREATED             STATUS              PORTS                                            NAMES
    42ac0ed4b713        nexus3.onap.org:10001/onap/policy-pap:2.0.0-SNAPSHOT-latest   "bash ./policy-pap.sh"   3 days ago          Up 3 days           0.0.0.0:6969->6969/tcp, 0.0.0.0:9090->9090/tcp   policy-pap

Install & configure visualVM in VM2
-----------------------------------

visualVM needs to be installed in the virtual machine having PAP. It will be used to monitor CPU, Memory, GC for PAP while stability test is running.

Install visualVM

.. code-block:: bash

    $ sudo apt-get install visualvm
    
Run few commands to configure permissions

.. code-block:: bash

    $ cd /usr/lib/jvm/java-8-openjdk-amd64/bin/
    $ sudo touch visualvm.policy
    $ sudo chmod 777 visualvm.policy
     
    $ vi visualvm.policy
     
    Add the following in visualvm.policy
     
     
    grant codebase "file:/usr/lib/jvm/java-8-openjdk-amd64/lib/tools.jar" {
       permission java.security.AllPermission;
    };

Run following commands to start jstatd using port 1111

.. code-block:: bash

    $ cd /usr/lib/jvm/java-8-openjdk-amd64/bin/
    $ ./jstatd -p 1111 -J-Djava.security.policy=visualvm.policy  &
    
Run visualVM locally to connect to remote VM2

.. code-block:: bash

    # On your windows machine or your linux box locally, launch visualVM
    
Connect to jstatd & remote apex-pdp JVM

    1. Right click on "Remote" in the left panel of the screen and select "Add Remote Host..."
    2. Enter the IP address of VM2.
    3. Right click on IP address, select "Add JMX Connection..."
    4. Enter the VM2 IP Address (from step 2) <IP address>:9090 ( for example -10.12.6.201:9090) and click OK.
    5. Double click on the newly added nodes under "Remote" to start monitoring CPU, Memory & GC.

Sample Screenshot of visualVM

.. image:: images/pap-s3p-vvm-sample.png

Test Plan
---------

The 72 hours stability test will run the following steps sequentially in a single threaded loop.

- **Create Policy Type** - creates an operational policy type using policy/api component
- **Create Policy** - creates an operational policy using the policy type create in above step using policy/api component
- **Check Health** - checks the health status of pap
- **Check Statistics** - checks the statistics of pap
- **Change state to ACTIVE** - changes the state of PdpGroup to ACTIVE
- **Check PdpGroup Query** - makes a PdpGroup query request and verify that PdpGroup is in ACTIVE state.
- **Deploy Policy** - deploys the policy in PdpGroup
- **Undeploy Policy** - undeploy the policy from PdpGroup
- **Change state to PASSIVE** - changes the state of PdpGroup to PASSIVE
- **Check PdpGroup Query** - makes a PdpGroup query request and verify that PdpGroup is in PASSIVE state.
- **Delete Policy** - deletes the operational policy using policy/api component
- **Delete Policy Type** - deletes the operational policy type using policy/api component

The following steps can be used to configure the parameters of test plan.

- **HTTP Authorization Manager** - used to store user/password authentication details.
- **HTTP Header Manager** - used to store headers which will be used for making HTTP requests.
- **User Defined Variables** -  used to store following user defined parameters.

==========  ===============================================
 **Name**    **Description**
==========  ===============================================
 PAP_HOST     IP Address or host name of PAP component
 PAP_PORT     Port number of PAP for making REST API calls
 API_HOST     IP Address or host name of API component
 API_PORT     Port number of API for making REST API calls
==========  ===============================================

Screenshot of PAP stability test plan

.. image:: images/pap-s3p-testplan.png

Test Results
------------

**Summary**

Stability test plan was triggered for 72 hours.

**Test Statistics**

=======================  =================  ==================  ==================================
**Total # of requests**  **Success %**      **Error %**         **Average time taken per request**
=======================  =================  ==================  ==================================
178208                   100 %              0 %                 76 ms
=======================  =================  ==================  ==================================

**VisualVM Screenshot**

.. image:: images/pap-s3p-vvm-1.png
.. image:: images/pap-s3p-vvm-2.png

**JMeter Screenshot**

.. image:: images/pap-s3p-jm-1.png
.. image:: images/pap-s3p-jm-1.png
