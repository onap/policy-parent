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

  kubectl get pods | grep policy

  brmsgw                     ClusterIP   10.43.77.177    <none>        9989/TCP                              5d15h   app=brmsgw,release=dev-policy
  drools                     ClusterIP   10.43.167.154   <none>        6969/TCP,9696/TCP                     5d15h   app=drools,release=dev-policy
  nexus                      ClusterIP   10.43.239.92    <none>        8081/TCP                              5d15h   app=nexus,release=dev-policy
  pap                        NodePort    10.43.207.229   <none>        8443:30219/TCP,9091:30218/TCP         5d15h   app=pap,release=dev-policy
  pdp                        ClusterIP   None            <none>        8081/TCP                              5d15h   app=pdp,release=dev-policy
  policy-apex-pdp            ClusterIP   10.43.226.0     <none>        6969/TCP                              5d15h   app=policy-apex-pdp,release=dev-policy
  policy-api                 ClusterIP   10.43.102.56    <none>        6969/TCP                              5d15h   app=policy-api,release=dev-policy
  policy-distribution        ClusterIP   10.43.4.211     <none>        6969/TCP                              5d15h   app=policy-distribution,release=dev-policy
  policy-pap                 ClusterIP   10.43.175.164   <none>        6969/TCP                              5d15h   app=policy-pap,release=dev-policy
  policy-xacml-pdp           ClusterIP   10.43.181.208   <none>        6969/TCP                              5d15h   app=policy-xacml-pdp,release=dev-policy
  policydb                   ClusterIP   10.43.93.233    <none>        3306/TCP                              5d15h   app=policydb,release=dev-policy

Some of these pods are shared between the legacy components and the latest framework components, while others are not.

.. csv-table::
   :header: "Policy Pod", "Latest Framework", "Legacy"
   :widths: 15,10,10

   "brmsgw", "", "yes"
   "drools", "yes", "yes"
   "nexus", "yes", "yes"
   "pap", "", "yes"
   "pdp", "", "yes"
   "policy-apex-pdp", "yes", ""
   "policy-api", "yes", ""
   "policy-distribution", "yes", "yes"
   "policy-pap", "yes", ""
   "policy-xacml-pdp", "yes", ""
   "policydb", "yes", "yes"

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

**Step 2** Build the charts

.. code-block:: bash

  make policy
  make onap

**Step 3** Undeploy Policy
After undeploying policy, loop on monitoring the policy pods until they go away.

.. code-block:: bash

  helm del --purge dev-policy
  kubectl get pods -n onap

**Step 4** Delete NFS persisted data for Policy
Sudo to root if you logged in using another account such as ubuntu.

.. code-block:: bash

  rm -fr /dockerdata-nfs/dev-policy

**Step 5** Re-Deploy Policy pods
After deploying policy, loop on monitoring the policy pods until they come up.

.. code-block:: bash

  helm deploy dev-policy local/onap --namespace onap
  kubectl get pods -n onap

Restarting a faulty component
*****************************
Each policy component can be restarted independently by issuing the following command:

kubectl delete pod <policy-pod> -n onap

Exposing ports
**************
For security reasons, the ports for the policy containers are configured as ClusterIP and thus not exposed. If you find you need those ports in a development environment, then the following will expose them.

.. code-block:: bash

  kubectl -n onap expose service policy-api --port=7171 --target-port=6969 --name=api-public --type=NodePort

Overriding certificate stores
*******************************
Each policy component keystore and or truststore can be overriden.   The procedure will be applicable
to an installation that requires certificates other than the pre-packaged AAF derived ones
that come with the official ONAP distribution.

To override a default keystore, the new certificate store (policy-keystore) file should be placed at the
appropriate helm chart locations below:

* **oom/kubernetes/policy/charts/drools/resources/secrets/policy-keystore** drools pdp keystore override.
* **oom/kubernetes/policy/charts/policy-apex-pdp/resources/config/policy-keystore** apex pdp keystore override.
* **oom/kubernetes/policy/charts/policy-api/resources/config/policy-keystore** api keystore override.
* **oom/kubernetes/policy/charts/policy-distribution/resources/config/policy-keystore** distribution keystore override.
* **oom/kubernetes/policy/charts/policy-pap/resources/config/policy-keystore** pap keystore override.
* **oom/kubernetes/policy/charts/policy-xacml-pdp/resources/config/policy-keystore** xacml pdp keystore override.

In the event that the truststore (policy-truststore) needs to be overriden as well, place it at the appropriate
location below:

* **oom/kubernetes/policy/charts/drools/resources/configmaps/policy-truststore** drools pdp truststore override.
* **oom/kubernetes/policy/charts/policy-apex-pdp/resources/config/policy-truststore** apex pdp truststore override.
* **oom/kubernetes/policy/charts/policy-api/resources/config/policy-truststore** api truststore override.
* **oom/kubernetes/policy/charts/policy-distribution/resources/config/policy-truststore** distribution truststore override.
* **oom/kubernetes/policy/charts/policy-pap/resources/config/policy-truststore** pap truststore override.
* **oom/kubernetes/policy/charts/policy-xacml-pdp/resources/config/policy-truststore** xacml pdp truststore override.

After these changes, follow the procedures in the :ref:`Installing or Upgrading Policy` section to make usage of
the new stores effective.

Additional PDP-D Customizations
*******************************

Credentials and other configuration parameters can be set as values
when deploying the policy (drools) subchart.  Please refer to
`PDP-D Default Values <https://git.onap.org/oom/tree/kubernetes/policy/charts/drools/values.yaml>`_
for the current default values.  It is strongly recommended that sensitive
information is secured appropriately before using in production.

Additional customization can be applied to the PDP-D.  Custom configuration goes under the
"resources" directory of the drools subchart (oom/kubernetes/policy/charts/drools/resources).
This requires rebuilding the policy subchart
(see section :ref:`Rebuilding and/or modifying the Policy Charts`).

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

Examples
^^^^^^^^

To *disable AAF*, simply override the "aaf.enabled" value when deploying the helm chart
(see the OOM installation instructions mentioned above).

To *override the PDP-D keystore or trustore*, add a suitable replacement(s) under
"drools/resources/secrets".  Modify the drools chart values.yaml with
new credentials, and follow the procedures described at
:ref:`Rebuilding and/or modifying the Policy Charts` to redeploy the chart.

To *disable https* for the DMaaP configuration topic, add a copy of
`engine.properties <https://git.onap.org/policy/drools-pdp/tree/policy-management/src/main/server/config/engine.properties>`_
with "dmaap.source.topics.PDPD-CONFIGURATION.https" set to "false", or alternatively
create a ".pre.sh" script (see above) that edits this file before the PDP-D is
started.
