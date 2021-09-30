.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0


Policy OOM Installation
-----------------------

.. contents::
    :depth: 2

Policy OOM Charts
*****************
The policy K8S charts are located in the `OOM repository <https://gerrit.onap.org/r/gitweb?p=oom.git;a=tree;f=kubernetes/policy;h=78576c7a0d30cb87054e9776326cdde20986e6e3;hb=refs/heads/master>`_.

Please refer to the OOM documentation on how to install and deploy ONAP.

Policy Pods
***********
To get a listing of the Policy Pods, run the following command:

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

Accessing Policy Containers
***************************
Accessing the policy docker containers is the same as for any kubernetes container. Here is an example:

.. code-block:: bash

  kubectl -n onap exec -it dev-policy-policy-xacml-pdp-584844b8cf-9zptx bash

Installing or Upgrading Policy
******************************
The assumption is you have cloned the charts from the OOM repository into a local directory.

**Step 1** Go into local copy of OOM charts

From your local copy, edit any of the values.yaml files in the policy tree to make desired changes.

The policy schema will be installed automatically as part of the database configuration using ``db-migrator``.
By default the policy schema is upgraded to the latest version.
For more information on how to change the ``db-migrator`` setup please see: `Using Policy DB Migrator`_.

.. _Using Policy DB Migrator: ../db-migrator/policy-db-migrator.html

**Step 2** Build the charts

.. code-block:: bash

  make policy
  make SKIP_LINT=TRUE onap

.. note::
   SKIP_LINT is only to reduce the "make" time

**Step 3** Undeploy Policy
After undeploying policy, loop on monitoring the policy pods until they go away.

.. code-block:: bash

  helm undeploy dev-policy
  kubectl get pods -n onap | grep dev-policy


**Step 4** Re-Deploy Policy pods

After deploying policy, loop on monitoring the policy pods until they come up.

.. code-block:: bash

  helm deploy dev-policy local/onap --namespace onap
  kubectl get pods -n onap | grep dev-policy

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

Overriding certificate stores
*******************************
Policy components package default key and trust stores that support https based communication with other
AAF-enabled ONAP components.  Each store can be overridden at installation.

To override a default keystore, the new certificate store (policy-keystore) file should be placed at the
appropriate helm chart locations below:

* oom/kubernetes/policy/charts/drools/resources/secrets/policy-keystore drools pdp keystore override.
* oom/kubernetes/policy/charts/policy-apex-pdp/resources/config/policy-keystore apex pdp keystore override.
* oom/kubernetes/policy/charts/policy-api/resources/config/policy-keystore api keystore override.
* oom/kubernetes/policy/charts/policy-distribution/resources/config/policy-keystore distribution keystore override.
* oom/kubernetes/policy/charts/policy-pap/resources/config/policy-keystore pap keystore override.
* oom/kubernetes/policy/charts/policy-xacml-pdp/resources/config/policy-keystore xacml pdp keystore override.

In the event that the truststore (policy-truststore) needs to be overriden as well, place it at the appropriate
location below:

* oom/kubernetes/policy/charts/drools/resources/configmaps/policy-truststore drools pdp truststore override.
* oom/kubernetes/policy/charts/policy-apex-pdp/resources/config/policy-truststore apex pdp truststore override.
* oom/kubernetes/policy/charts/policy-api/resources/config/policy-truststore api truststore override.
* oom/kubernetes/policy/charts/policy-distribution/resources/config/policy-truststore distribution truststore override.
* oom/kubernetes/policy/charts/policy-pap/resources/config/policy-truststore pap truststore override.
* oom/kubernetes/policy/charts/policy-xacml-pdp/resources/config/policy-truststore xacml pdp truststore override.

When the keystore passwords are changed, the corresponding component configuration ([1]_) should also change:

* oom/kubernetes/policy/charts/drools/values.yaml
* oom/kubernetes/policy-apex-pdp/resources/config/config.json
* oom/kubernetes/policy-distribution/resources/config/config.json

This procedure is applicable to an installation that requires either AAF or non-AAF derived certificates.
The reader is refered to the AAF documentation when new AAF-compliant keystores are desired:

* `AAF automated configuration and Certificates <https://docs.onap.org/projects/onap-aaf-authz/en/latest/sections/configuration/AAF_4.1_config.html#typical-onap-entity-info-in-aaf>`_.
* `AAF Certificate Management for Dummies <https://wiki.onap.org/display/DW/AAF+Certificate+Management+for+Dummies>`_.
* `Instructional Videos <https://wiki.onap.org/display/DW/Instructional+Videos>`_.

After these changes, follow the procedures in the :ref:`Installing or Upgrading Policy` section to make usage of
the new stores effective.

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
(see section :ref:`Installing or Upgrading Policy`).

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

To *disable AAF*, simply override the "aaf.enabled" value when deploying the helm chart
(see the OOM installation instructions mentioned above).

To *override the PDP-D keystore or trustore*, add a suitable replacement(s) under
"drools/resources/secrets".  Modify the drools chart values.yaml with
new credentials, and follow the procedures described at
:ref:`Installing or Upgrading Policy` to redeploy the chart.

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


.. rubric:: Footnotes

.. [1] There is a limitation that store passwords are not configurable for policy-api, policy-pap, and policy-xacml-pdp.
