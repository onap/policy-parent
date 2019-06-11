.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _xacml-label:

Policy XACML PDP Engine
#######################

.. toctree::
   :maxdepth: 2

The ONAP XACML Policy PDP Engine uses an `open source implementation <https://github.com/att/XACML>`__ of the `OASIS XACML 3.0 Standard <https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=xacml>`__ to support fine-grained policy decisions in the ONAP. The XACML 3.0 Standard is a language for both policies and request/response for access control decisions. The ONAP XACML PDP translates TOSCA Compliant Policies into the XACML policy language, loads the policies into the XACML engine and exposes a Decision API which uses the XACML request/response language to render decisions.

ONAP Supported Policy Types
***************************

In ONAP the following Policy Types are supported. Each Policy Type is implemented as an application that extends the **XacmlApplicationServiceProvider**. For details on each implementation, please refer to the `applications submodule of the onap/xacml-pdp project <https://gerrit.onap.org/r/gitweb?p=policy/xacml-pdp.git;a=tree;f=applications;h=047878fe14851d8a51998e065b8aca583ed8c994;hb=refs/heads/dublin>`__.

By cloning the policy/xacml-pdp repository, one can run the JUnit tests to get a better understanding on how applications are built using translators and the XACML Policies that are generated for each Policy Type. Each application supports one or more Policy Types and an associated "action" used by the Decision API when making these calls.

Monitoring Policy Types
=======================
These Policy Types are used by Control Loop DCAE microservice components to support monitoring of VNF's during Control Loops. The DCAE Platform makes a call to Decision API to request the contents of these policies. The implementation involves creating an overarching XACML Policy that contains the TOSCA policy as a payload that is returned to the DCAE Platform.

.. csv-table::
   :header: "Policy Type", "Action", "Description"

   "onap.policies.monitoring.cdap.tca.hi.lo.app", "configure", "TCA DCAE microservice component"
   "onap.policies.monitoring.dcaegen2.collectors.datafile.datafile-app-server", "configure", "REST Collector"

The translator used to translate these TOSCA Policy Types is the `StdCombinedPolicyResultsTranslator <https://gerrit.onap.org/r/gitweb?p=policy/xacml-pdp.git;a=blob;f=applications/common/src/main/java/org/onap/policy/pdp/xacml/application/common/std/StdCombinedPolicyResultsTranslator.java;h=2d7386d99f97ccee828b665a46b46531495cdfcd;hb=refs/heads/dublin>`__.

This is an example Decision API payload made to retrieve a decision for a Monitoring Policy Type.

.. literalinclude:: decision.monitoring.json
  :language: JSON

Guard Policy Types
==================
These Policy Types are used by Control Loop Drools Engine to support guarding of Control Loops during runtime control loop execution. NOTE: For Dublin, these policy types are not TOSCA compliant but rather a simple variation of the Casablanca legacy guard policy.

.. csv-table::
   :header: "Policy Type", "Action", "Description"

   "onap.policies.controlloop.guard.FrequencyLimiter", "guard", "Limits frequency of actions over a specified time period"
   "onap.policies.controlloop.guard.Blacklist", "guard", "Blacklists a regexp of VNF IDs"
   "onap.policies.controlloop.guard.MinMax", "guard", "For scaling, enforces a min/max number of VNFS"

The translator used to translate these legacy Policy Types is the `LegacyGuardTranslator <https://gerrit.onap.org/r/gitweb?p=policy/xacml-pdp.git;a=blob;f=applications/guard/src/main/java/org/onap/policy/xacml/pdp/application/guard/LegacyGuardTranslator.java;h=2917aab26dfbcf805dd00fead66ef68439561a11;hb=refs/heads/dublin>`__ which implements a more fine grained approach to translating the properties into a XACML policy.

This is an example Decision API payload made to retrieve a decision for a Guard Policy Type.

.. literalinclude:: decision.guard.json
  :language: JSON


Control Loop Coordination Policy Types
======================================
These Policy Types are similar to the guard Policy Types and are called by the Control Loop Drools PDP Engine to support guarding of Control Loops during runtime control loop execution. NOTE: For Dublin, these Policy Types are not tested by the Integration team and are available as prototypes.

.. csv-table::
   :header: "Policy Type", "Action", "Description"

   "onap.policies.controlloop.guard.coordination.FirstBlocksSecond", "guard", "Gives priority to one control loop vs another"

The translator used to translate the coordination Policy Types is the `CoordinationGuardTranslator <https://gerrit.onap.org/r/gitweb?p=policy/xacml-pdp.git;a=blob;f=applications/guard/src/main/java/org/onap/policy/xacml/pdp/application/guard/CoordinationGuardTranslator.java;h=41c1428e3da4cc5b6c1bb091d0c16a6618a036ae;hb=refs/heads/dublin>`__ which uses a XACML Policy Template in its implementation. For example, when a new policy is loaded the translator copies the template to a new policy and replaces the CONTROL_LOOP_ONE and CONTROL_LOOP_TWO values with the specified control loops. See the `XAMCL Coordination Template for more details <https://gerrit.onap.org/r/gitweb?p=policy/xacml-pdp.git;a=blob;f=applications/guard/src/main/resources/coordination/function/onap.policies.controlloop.guard.coordination.FirstBlocksSecond.xml;h=bea05f264be5e422eb2da448d40057f736b7555c;hb=refs/heads/dublin>`__.

The same Decision API payload example for guard applies to this Policy Type.

Optimization Policy Types
=========================
These Policy Types are used by the OOF Project support placement in ONAP. The OOF Platform makes a call to the Decision API to request these Policies based on the values specified in the **policyScope** and **policyType** properties. Please refer to the OOF Project for more details on how these Policy Types are using in their platform.

.. csv-table::
   :header: "Policy Type", "Action"

   "onap.policies.optimization.AffinityPolicy", "optimize"
   "onap.policies.optimization.DistancePolicy", "optimize"
   "onap.policies.optimization.HpaPolicy", "optimize"
   "onap.policies.optimization.OptimizationPolicy", "optimize"
   "onap.policies.optimization.PciPolicy", "optimize"
   "onap.policies.optimization.QueryPolicy", "optimize"
   "onap.policies.optimization.SubscriberPolicy", "optimize"
   "onap.policies.optimization.Vim_fit", "optimize"
   "onap.policies.optimization.VnfPolicy", "optimize"

The translator used to translate the optimization Policy Types is the `StdMatchableTranslator <https://gerrit.onap.org/r/gitweb?p=policy/xacml-pdp.git;a=blob;f=applications/common/src/main/java/org/onap/policy/pdp/xacml/application/common/std/StdMatchableTranslator.java;h=dd44af7aa4ab2ef70b216f8a3a6a02c6f1fddf56;hb=refs/heads/dublin>`__.

This is an example Decision API payload made to retrieve a decision for an Optimization Policy Type.

.. literalinclude:: decision.affinity.json
  :language: JSON

Supporting Custom Policy Types
******************************
In order to support your own custom Policy Type that the XACML PDP Engine can support, one needs to build a Java service application that extends the **XacmlApplicationServiceProvider** interface and expose it in the classpath used to load the XACML PDP Engine. First, ensure you define and create the TOSCA Policy Type according to these :ref:`Policy Design and Development <design-label>`. You should be able to load your custom Policy Type using the :ref:`Policy Lifecycle API <api-label>`. Once successful, you should be able to start creating policies from your custom Policy Type.

See each of the ONAP Policy Type application implementations for examples on how to implement the methods for the **XacmlApplicationServiceProvider**. Consider re-using the standard implementations.

Once your application is developed and the XACML PDP Engine can find your application via setting the classpath appropriately, then use the :ref:`PAP REST API <pap-label>` to ensure the XACML PDP is loaded and registering your custom Policy Type. Once successful, then you should be able to start deploying the created policies to the XACML PDP Engine.

The following tutorial can be helpful to get started: :ref:`xacmltutorial-label`

Decision API
************
The Decision API is used by ONAP components that enforce policies and need a decision on which policy to enforce for a specific situation. The Decision API mimics closely the XACML request standard in that it supports a subject, action and resource.

.. csv-table::
   :header: "Field", "Required", "XACML equivalent", "Description"

   "ONAPName", "True", "subject", "The name of the ONAP project making the call"
   "ONAPComponent", "True", "subject", "The name of the ONAP sub component making the call"
   "ONAPInstance", "False", "subject", "An optional instance ID for that sub component"
   "action", "True", "action", "The action being performed"
   "resource", "True", "resource", "An object specific to the action that contains properties describing the resource"

It is worth noting that we use basic authorization for API access with username and password set to *healthcheck* and *zb!XztG34* respectively.
Also, the new APIs support both *http* and *https*.

For every API call, client is encouraged to insert an uuid-type requestID as parameter. It is helpful for tracking each http transaction
and facilitates debugging. Mostly importantly, it complies with Logging requirements v1.2. If client does not provider the requestID in API call,
one will be randomly generated and attached to response header *x-onap-requestid*.

In accordance with `ONAP API Common Versioning Strategy Guidelines <https://wiki.onap.org/display/DW/ONAP+API+Common+Versioning+Strategy+%28CVS%29+Guidelines>`_,
in the response of each API call, several custom headers are added::

    x-latestversion: 1.0.0
    x-minorversion: 0
    x-patchversion: 0
    x-onap-requestid: e1763e61-9eef-4911-b952-1be1edd9812b

x-latestversion is used only to communicate an API's latest version.

x-minorversion is used to request or communicate a MINOR version back from the client to the server, and from the server back to the client.

x-patchversion is used only to communicate a PATCH version in a response for troubleshooting purposes only, and will not be provided by the client on request.

x-onap-requestid is used to track REST transactions for logging purpose, as described above.

.. swaggerv2doc:: swagger.json


End of Document
