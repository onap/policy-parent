.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0


Policy/ACM OOM Installation
---------------------------

.. contents::
    :depth: 2

Notes
*****
* This guide assumes that you have access to a Kubernetes cluster.
* The examples for this guide were carried out on a 3 node Ubuntu-based cluster. However, cluster software such as microk8s should work just as well.

Cluster Used in this Guide
**************************
* Ubuntu-based VM using Ubuntu 22.04.1 LTS
* VM has 16GB RAM and 150 GB HDD and 4CPU
* microk8s-based cluster is used

Prerequisites
*************
* Microk8s Cluster capable of running kubectl commands
* Both kubectl client and the server use v1.30.4
* Helm version v3.15.4 is installed
* There should be a running chart repo called "local"
* Chartmuseum used to create the chart repo

Deploy Policy/ACM OOM & Required Charts
***************************************
The policy K8S charts are located in the `OOM repository <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes/policy;h=78576c7a0d30cb87054e9776326cdde20986e6e3;hb=refs/heads/master>`_.

Install Helm Plugins
^^^^^^^^^^^^^^^^^^^^
Chart museum's **helm-push** plugin should be installed

.. code-block:: bash

    helm plugin install https://github.com/chartmuseum/helm-push --version 0.10.3

And then we should install the **deploy** and **undeploy** plugins from oom. so, navigate to the oom/kubernetes directory in the above cloned oom gerrit repo.

.. code-block:: bash

    helm plugin install helm/plugins/deploy
    helm plugin install helm/plugins/undeploy

Package and Upload Charts to Repo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Navigate to the same oom/kubernetes directory. The **make** command can be used here to package and upload (among other things) the charts to the local chart repo. This command is slow as it has to package and upload all of the helm charts in oom. However, we are skipping linting of the charts and using the **-j** flag to allow us to use multiple threads - this will maximize the speed.

.. code-block:: bash

    make all SKIP_LINT=TRUE -j$(nproc)

Once this is completed, we should be able to see all of the charts in the local helm repo.

.. code-block:: bash

    helm search repo local

    local/policy                     	14.0.5       	           	ONAP Policy
    local/policy-apex-pdp            	14.0.1       	           	ONAP Policy APEX PDP
    local/policy-api                 	14.0.2       	           	ONAP Policy Design API
    local/policy-clamp-ac-a1pms-ppnt 	14.0.1       	           	ONAP Policy Clamp A1PMS Participant
    local/policy-clamp-ac-http-ppnt  	14.0.1       	           	ONAP Policy Clamp Controlloop Http Participant
    local/policy-clamp-ac-k8s-ppnt   	14.0.1       	           	ONAP Policy Clamp Controlloop K8s Participant
    local/policy-clamp-ac-kserve-ppnt	14.0.1       	           	ONAP Policy Clamp Kserve Participant
    local/policy-clamp-ac-pf-ppnt    	14.0.1       	           	ONAP Policy Clamp Controlloop Policy Participant
    local/policy-clamp-runtime-acm   	14.0.2       	           	ONAP Policy Clamp Controlloop Runtime
    local/policy-distribution        	14.0.1       	           	ONAP Policy Distribution
    local/policy-drools-pdp          	14.0.2       	           	ONAP Drools Policy Engine (PDP-D)
    local/policy-pap                 	14.0.2       	           	ONAP Policy Administration (PAP)
    local/policy-xacml-pdp           	14.0.3       	           	ONAP Policy XACML PDP (PDP-X)

.. note::
    Only the policy/acm charts are shown above - there will be many others.

Strimzi Kafka and Cert Manager Install
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Install Cert Manager

.. code-block:: bash

    kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.2.0/cert-manager.yaml

Currently, the following policy/acm components use Strimzi Kafka by default:

* policy-ppnt
* k8s-ppnt
* http-ppnt
* a1Policy-mgmt-ppnt
* kserve-ppnt
* acm runtime

There is a future plan to move all components to Strimzi Kafka. However, in the meantime, our deployments require both DMAAP message-router and Strimzi Kafka
|
Install Strimzi Kafka Operator

.. code-block:: bash

    helm repo add strimzi https://strimzi.io/charts/
    helm install strimzi-kafka-operator strimzi/strimzi-kafka-operator --namespace strimzi-system --version 0.43.0 --set watchAnyNamespace=true --create-namespace

Once these are installed and running, we can move on to the installation of the policy and related helm charts

Policy and Related Helm Chart Install
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
At this stage, we have all the required charts that we need for either Policy Framework or ACM installation. The command to deploy the charts is below

.. code-block:: bash

    helm deploy dev local/onap --namespace onap -f ~/override.yaml --create-namespace

In the above **helm deploy** command we provide an override file called **override.yaml**. In this file, we can turn on/off different parts of the onap installation. we have provided an file below in the collapsable code. This is provided just as examples - you can adjust any way you see fit. The choice between postgres and mariadb is controlled by **global.mariadbGalera.localCluster & global.mariadbGalera.useInPolicy** for mariadb and **global.postgres.localCluster & global.postgres.useInPolicy** for postgres

.. collapse:: Policy/ACM Chart Override

    .. code-block:: yaml

        global:
          repository: nexus3.onap.org:10001
          pullPolicy: IfNotPresent
          masterPassword: password
          serviceMesh:
            enabled: false
          cmpv2Enabled: false
          addTestingComponents: false
          useStrimziKafka: true
          useStrimziKafkaPf: false
          mariadbGalera:
            # flag to enable the DB creation via mariadb-operator
            useOperator: false
            # if useOperator set to "true", set "enableServiceAccount to "false"
            # as the SA is created by the Operator
            enableServiceAccount: true
            localCluster: true
            # '&mariadbConfig' means we "store" the values for  later use in the file
            # with '*mariadbConfig' pointer.
            config: &mariadbConfig
              mysqlDatabase: policyadmin
            service: &mariadbService policy-mariadb
            internalPort: 3306
            nameOverride: *mariadbService
            # (optional) if localCluster=false and an external secret is used set this variable
            #userRootSecret: <secretName>
            useInPolicy: true
          prometheusEnabled: false
          postgres:
            localCluster: false
            service:
              name: pgset
              name2: policy-pg-primary
              name3: policy-pg-replica
            container:
              name: postgres
            useInPolicy: false
        robot:
          enabled: false
        so:
          enabled: false
        cassandra:
          enabled: false
        mariadb-galera:
          enabled: false
          replicaCount: 1
        appc:
          enabled: false
        sdnc:
          enabled: false
          replicaCount: 1
          config:
            enableClustering: false
        aaf:
          enabled: false
        aai:
          enabled: false
        clamp:
          enabled: false
        cli:
          enabled: false
        cds:
          enabled: false
        consul:
          enabled: false
        contrib:
          enabled: false
        awx:
          enabled: false
        netbox:
          enabled: false
        dcaegen2:
          enabled: false
        pnda:
          enabled: false
        dmaap:
          enabled: false
          message-router:
            enabled: false
          dmaap-bc:
            enabled: false
          dmaap-dr-prov:
            enabled: false
          dmaap-dr-node:
            enabled: false
          dmaap-strimzi:
            enabled: false
        esr:
          enabled: false
        log:
          enabled: false
        sniro-emulator:
          enabled: false
        oof:
          enabled: false
        msb:
          enabled: false
        multicloud:
          enabled: false
        nbi:
          enabled: false
        pomba:
          enabled: false
        portal:
          enabled: false
        platform:
          enabled: false
        sdc:
          enabled: false
        uui:
          enabled: false
        vfc:
          enabled: false
        vid:
          enabled: false
        modeling:
          enabled: false
        cps:
          enabled: false
        vnfsdk:
          enabled: false
        vvp:
          enabled: false
        strimzi:
          enabled: true
          replicaCount: 1
          persistence:
            kafka:
              size: 1Gi
            zookeeper:
              size: 256Mi
          strimzi-kafka-bridge:
            enabled: false
        policy:
          enabled: true
          policy-clamp-ac-a1pms-ppnt:
            enabled: true
          policy-clamp-ac-kserve-ppnt:
            enabled: true
          policy-clamp-ac-k8s-ppnt:
            enabled: true
          policy-clamp-ac-http-ppnt:
            enabled: true
          policy-clamp-ac-pf-ppnt:
            enabled: true
          policy-clamp-runtime-acm:
            enabled: true
          policy-gui:
            enabled: false
          policy-apex-pdp:
            enabled: true
          policy-nexus:
            enabled: false
          policy-api:
            enabled: true
          policy-pap:
            enabled: true
          policy-xacml-pdp:
            enabled: true
          policy-drools-pdp:
            enabled: true
          policy-distribution:
            enabled: false

|

Policy/ACM Pods
***************
To get a listing of the Policy or ACM Pods, run the following command:

.. code-block:: bash

  kubectl get pods -n onap | grep dev-policy

  dev-policy-59684c7b9c-5gd6r                        2/2     Running            0          8m41s
  dev-policy-apex-pdp-0                              1/1     Running            0          8m41s
  dev-policy-api-56f55f59c5-nl5cg                    1/1     Running            0          8m41s
  dev-policy-distribution-54cc59b8bd-jkg5d           1/1     Running            0          8m41s
  dev-policy-mariadb-0                               1/1     Running            0          8m41s
  dev-policy-xacml-pdp-765c7d58b5-l6pr7              1/1     Running            0          8m41s

.. note::
   To get a listing of the Policy services, run this command:
   kubectl get svc -n onap | grep policy

Accessing Policy/ACM Containers
*******************************
Accessing the policy docker containers is the same as for any kubernetes container. Here is an example:

.. code-block:: bash

  kubectl -n onap exec -it dev-policy-policy-xacml-pdp-584844b8cf-9zptx bash

.. _install-upgrade-policy-label:

Installing or Upgrading Policy/ACM
**********************************
The assumption is you have cloned the charts from the OOM repository into a local directory.

**Step 1** Go into local copy of OOM charts

From your local copy, edit any of the values.yaml files in the policy tree to make desired changes.

The policy/acm schemas will be installed automatically as part of the database configuration using ``db-migrator``.
By default the policy/acm schemas is upgraded to the latest version.
For more information on how to change the ``db-migrator`` setup please see
:ref:`Using Policy DB Migrator <policy-db-migrator-label>`.

**Step 2** Build the charts

.. code-block:: bash

  make policy -j$(nproc)
  make SKIP_LINT=TRUE onap -j$(nproc)

.. note::
   SKIP_LINT is only to reduce the "make" time. **-j** allows the use of multiple threads.

**Step 3** Undeploy Policy/ACM
After undeploying policy, loop on monitoring the policy pods until they go away.

.. code-block:: bash

  helm undeploy dev
  kubectl get pods -n onap | grep dev


**Step 4** Re-Deploy Policy pods

After deploying policy, loop on monitoring the policy pods until they come up.

.. code-block:: bash

  helm deploy dev local/onap --namespace onap -f override.yaml
  kubectl get pods -n onap | grep dev

.. note::
   If you want to purge the existing data and start with a clean install,
   please follow these steps after undeploying:

   **Step 1** Delete NFS persisted data for Policy

   .. code-block:: bash

     rm -fr /dockerdata-nfs/dev/policy

   **Step 2** Make sure there is no orphan policy database persistent volume or claim.

   First, find if there is an orphan database PV or PVC with the following commands:

   .. code-block:: bash

     kubectl get pvc -n onap | grep policy
     kubectl get pv -n onap | grep policy

   If there are any orphan resources, delete them with

   .. code-block:: bash

       kubectl delete pvc <orphan-policy-mariadb-resource>
       kubectl delete pv <orphan-policy-mariadb-resource>


Restarting a faulty component
*****************************
Each policy component can be restarted independently by issuing the following command:

.. code-block:: bash

    kubectl delete pod <policy-pod> -n onap

Exposing ports
**************
For security reasons, the ports for the policy containers are configured as ClusterIP and thus not exposed. If you find you need those ports in a development environment, then the following will expose them.

.. code-block:: bash

  kubectl -n onap expose service policy-api --port=7171 --target-port=6969 --name=api-public --type=NodePort

Additional PDP-D Customizations
*******************************

Credentials and other configuration parameters can be set as values
when deploying the policy (drools) subchart.  Please refer to
`PDP-D Default Values <https://git.onap.org/oom/tree/kubernetes/policy/components/policy-drools-pdp/values.yaml>`_
for the current default values.  It is strongly recommended that sensitive
information is secured appropriately before using in production.

Additional customization can be applied to the PDP-D.  Custom configuration goes under the
"resources" directory of the drools subchart (oom/kubernetes/policy/charts/drools/resources).
This requires rebuilding the policy subchart
(see section :ref:`install-upgrade-policy-label`).

Configuration is done by adding or modifying configmaps and/or secrets.
Configmaps are placed under "drools/resources/configmaps", and
secrets under "drools/resources/secrets".

Custom configuration supportes these types of files:

* **\*.conf** files to support additional environment configuration.
* **features\*.zip** to add additional custom features.
* **\*.pre.sh** scripts to be executed before starting the PDP-D process.
* **\*.post.sh** scripts to be executed after starting the PDP-D process.
* **policy-keystore** to override the PDP-D policy-keystore.
* **policy-truststore** to override the PDP-D policy-truststore.
* **aaf-cadi.keyfile** to override the PDP-D AAF key.
* **\*.properties** to override or add properties files.
* **\*.xml** to override or add xml configuration files.
* **\*.json** to override json configuration files.
* **\*settings.xml** to override maven repositories configuration .

Examples
^^^^^^^^
To *override the PDP-D keystore or trustore*, add a suitable replacement(s) under
"drools/resources/secrets".  Modify the drools chart values.yaml with
new credentials, and follow the procedures described at
:ref:`install-upgrade-policy-label` to redeploy the chart.

To *disable https* for the DMaaP configuration topic, add a copy of
`engine.properties <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/server/config/engine.properties>`_
with "dmaap.source.topics.PDPD-CONFIGURATION.https" set to "false", or alternatively
create a ".pre.sh" script (see above) that edits this file before the PDP-D is
started.

To use *noop topics* for standalone testing, add a "noop.pre.sh" script under
oom/kubernetes/policy/charts/drools/resources/configmaps/:

.. code-block:: bash

    #!/bin/bash
    sed -i "s/^dmaap/noop/g" $POLICY_HOME/config/*.properties

