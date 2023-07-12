.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _xacml-label:

Policy XACML PDP Engine
#######################

.. toctree::
   :maxdepth: 2

The ONAP XACML Policy PDP Engine uses an `open source implementation <https://github.com/att/xacml-3.0>`__ of the `OASIS XACML 3.0 Standard <http://docs.oasis-open.org/xacml/3.0/xacml-3.0-core-spec-os-en.html>`__ to support fine-grained policy decisions in the ONAP. The XACML 3.0 Standard is a language for both policies and requests/responses for access control decisions. The ONAP XACML PDP translates TOSCA Compliant Policies into the XACML policy language, loads the policies into the XACML engine and exposes a Decision API which uses the XACML request/response language to render decisions for ONAP components.

ONAP XACML PDP Supported Policy Types
*************************************

The following Policy Types are supported by the XACML PDP Engine (PDP-X):

.. csv-table:: Supported Base Policy Types
    :header: "Application", "Base Policy Type", "Action", "Description"

    "Monitoring", "onap.policies.Monitoring", "configure", "Control Loop DCAE Monitoring Policies"
    "Guard", "onap.policies.controlloop.guard.Common", "guard", "Control Loop Guard and Coordination Policies"
    "Optimization", "onap.policies.Optimization", "optimize", "Optimization policy types used by OOF"
    "Naming", "onap.policies.Naming", "naming", "Naming policy types used by SDNC"
    "Native", "onap.policies.native.Xacml", "native", "Native XACML Policies"
    "Match", "onap.policies.Match", "native", "Matchable Policy Types for the ONAP community to use"

Each Policy Type is implemented as an application that extends the **XacmlApplicationServiceProvider**, and provides a **ToscaPolicyTranslator** that translates the TOSCA representation of the policy into a XACML OASIS 3.0 standard policy.

By cloning the policy/xacml-pdp repository, a developer can run the JUnit tests for the applications to get a better understanding on how applications are built using translators and the XACML Policies that are generated for each Policy Type. Each application supports one or more Policy Types and an associated "action" used by the Decision API when making these calls.

See the :ref:`policy-development-tools-label` for more information on cloning and developing the policy repositories.

XACML-PDP applications are located in the 'applications' sub-module in the policy/xacml-pdp repo. `Click here to view the applications sub-modules <https://github.com/onap/policy-xacml-pdp/tree/master/applications>`_

XACML PDP TOSCA Translators
===========================

The following common translators are available in ONAP for use by developers. Each is used or extended by the standard PDP-X applications in ONAP.

StdCombinedPolicyResultsTranslator Translator
---------------------------------------------
A simple translator that wraps the TOSCA policy into a XACML policy and performs matching of the policy based on either policy-id and/or policy-type. The use of this translator is discouraged as it behaves like a database call and does not take advantage of the fine-grain decision making features described by the XACML OASIS 3.0 standard. It is used to support backward compatibility of legacy "configure" policies.

`Implementation of Combined Results Translator <https://github.com/onap/policy-xacml-pdp/blob/master/applications/common/src/main/java/org/onap/policy/pdp/xacml/application/common/std/StdCombinedPolicyResultsTranslator.java>`_.

The Monitoring and Naming applications use this translator.

.. _xacml-matchable-label:

StdMatchableTranslator Translator
---------------------------------
More robust translator that searches metadata of TOSCA properties for a **matchable** field set to **true**. The translator then uses those "matchable" properties to translate a policy into a XACML OASIS 3.0 policy which allows for fine-grained decision making such that ONAP applications can retrieve the appropriate policy(s) to be enforced during runtime.

Each of the properties designated as "matchable" are treated relative to each other as an "AND" during a Decision request call. In addition, each value of a "matchable property that is an array, is treated as an "OR". The more properties specified in a decision request, the more fine-grained a policy will be returned. In addition, the use of "policy-type" can be used in a decision request to further filter the decision results to a specific type of policy.

`Implementation of Matchable Translator <https://github.com/onap/policy-xacml-pdp/blob/master/applications/common/src/main/java/org/onap/policy/pdp/xacml/application/common/std/StdMatchableTranslator.java>`_.

The Optimization application uses this translator.

GuardTranslator and CoordinationGuardTranslator
-----------------------------------------------
These two translators are used by the Guard application and are very specific to those Policy Types. They are good examples on how to build your own translator for a very specific implementation of a policy type. This can be the case if any of the Std* translators are not appropriate to use directly or override for your application.

`Implementation of Guard Translator <https://github.com/onap/policy-xacml-pdp/blob/master/applications/guard/src/main/java/org/onap/policy/xacml/pdp/application/guard/GuardTranslator.java>`_

`Implementation of Coordination Translator <https://github.com/onap/policy-xacml-pdp/blob/master/applications/guard/src/main/java/org/onap/policy/xacml/pdp/application/guard/CoordinationGuardTranslator.java>`_

Native XACML OAISIS 3.0 XML Policy Translator
---------------------------------------------

This translator pulls a URL encoded XML XACML policy from a TOSCA Policy and loads it into a XACML Engine. This allows native XACML policies to be used to support complex use cases in which a translation from TOSCA to XACML is too difficult.

`Implementation of Native Policy Translator <https://github.com/onap/policy-xacml-pdp/tree/master/applications/native/src/main/java/org/onap/policy/xacml/pdp/application/nativ>`_

Monitoring Policy Types
=======================
These Policy Types are used by Control Loop DCAE microservice components to support monitoring of VNF/PNF entities to support an implementation of a Control Loops. The DCAE Platform makes a call to Decision API to request the contents of these policies. The implementation involves creating an overarching XACML Policy that contains the TOSCA policy as a payload that is returned to the DCAE Platform.

The following policy types derive from onap.policies.Monitoring:

.. csv-table::
   :header: "Derived Policy Type", "Action", "Description"

   "onap.policies.monitoring.tcagen2", "configure", "TCA DCAE microservice gen2 component"
   "onap.policies.monitoring.dcaegen2.collectors.datafile.datafile-app-server", "configure", "REST Collector"
   "onap.policies.monitoring.docker.sonhandler.app", "configure", "SON Handler microservice component"

.. note::
   DCAE project deprecated TCA DCAE microservice in lieu for their gen2 microservice. Thus, the policy type onap.policies.monitoring.cdap.tca.hi.lo.app was removed from Policy Framework.

This is an example Decision API payload made to retrieve a decision for a Monitoring Policy by id. Not recommended - as users may change id's of a policy. Available for backward compatibility.

.. literalinclude:: decision.monitoring.json
  :language: JSON

This is an example Decision API payload made to retrieve a decision for all deployed Monitoring Policies for a specific type of Monitoring policy.

.. literalinclude:: decision.monitoring.type.json
  :language: JSON

Guard and Control Loop Coordination Policy Types
================================================
These Policy Types are used by Control Loop Drools Engine to support guarding control loop operations and coordination of Control Loops during runtime control loop execution.

.. csv-table::
   :header: "Policy Type", "Action", "Description"

   "onap.policies.controlloop.guard.common.FrequencyLimiter", "guard", "Limits frequency of actions over a specified time period"
   "onap.policies.controlloop.guard.common.Blacklist", "guard", "Blacklists a regexp of VNF IDs"
   "onap.policies.controlloop.guard.common.MinMax", "guard", "For scaling, enforces a min/max number of VNFS"
   "onap.policies.controlloop.guard.common.Filter", "guard", "Used for filtering entities in A&AI from Control Loop actions"
   "onap.policies.controlloop.guard.coordination.FirstBlocksSecond", "guard", "Gives priority to one control loop vs another"

This is an example Decision API payload made to retrieve a decision for a Guard Policy Type.

.. literalinclude:: decision.guard.json
  :language: JSON

The return decision simply has "permit" or "deny" in the response to tell the calling application whether they are allowed to perform the operation.

.. literalinclude:: decision.guard.response.json
  :language: JSON

Guard Common Base Policy Type
-----------------------------
Each guard Policy Type derives from **onap.policies.controlloop.guard.Common** base policy type. Thus, they share a set of common
properties.

.. csv-table:: Common Properties for all Guards
   :header: "Property", "Examples", "Required", "Type", "Description"

   "actor", "APPC, SO", "Required", "String", "Identifies the actor involved in the Control Loop operation."
   "operation", "Restart, VF Module Create", "Required", "String", "Identifies the Control Loop operation the actor must perform."
   "timeRange", "start_time: T00:00:00Z end_time: T08:00:00Z", "Optional", "tosca.datatypes.TimeInterval", "A given time range the guard is in effect. Following the TOSCA specification the format should be ISO 8601 format "
   "id", "control-loop-id", "Optional", "String", "A specific Control Loop id the guard is in effect."

`Common Guard Policy Type <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.Common.yaml>`__

Frequency Limiter Guard Policy Type
-----------------------------------
The Frequency Limiter Guard is used to specify limits as to how many operations can occur over a given time period.

.. csv-table:: Frequency Guard Properties
   :header: "Property", "Examples", "Required", "Type", "Description"

   "timeWindow", "10, 60", "Required", "integer", "The time window to count the actions against."
   "timeUnits", "second minute, hour, day, week, month, year", "Required", "String", "The units of time the window is counting"
   "limit", "5", "Required", "integer", "The limit value to be checked against."

.. literalinclude:: example.guard.limiter.yaml
  :language: YAML

`Frequency Limiter Guard Policy Type <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.common.FrequencyLimiter.yaml>`__

Min/Max Guard Policy Type
-------------------------
The Min/Max Guard is used to specify a minimum or maximum number of instantiated entities in A&AI. Typically this is a VFModule for Scaling operations. One should specify either a min or a max value, or **both** a min and max value. At least one must be specified.

.. csv-table:: Min/Max Guard Properties
   :header: "Property", "Examples", "Required", "Type", "Description"

   "target", "e6130d03-56f1-4b0a-9a1d-e1b2ebc30e0e", "Required", "String", "The target entity that has scaling restricted."
   "min", "1", "Optional", "integer", "Minimum value. Optional only if max is not specified."
   "max", "5", "Optional", "integer", "Maximum value. Optional only if min is not specified."

.. literalinclude:: example.guard.minmax.yaml
  :language: YAML

`Min/Max Guard Policy Type <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.common.MinMax.yaml>`__

Blacklist Guard Policy Type
---------------------------
The Blacklist Guard is used to specify a list of A&AI entities that are blacklisted from having an operation performed on them. Recommendation is to use the vnf-id for the A&AI entity.

.. csv-table:: Blacklist Guard Properties
   :header: "Property", "Examples", "Required", "Type", "Description"

   "blacklist", "e6130d03-56f1-4b0a-9a1d-e1b2ebc30e0e", "Required", "list of string", "List of target entity's that are blacklisted from an operation."

.. literalinclude:: example.guard.blacklist.yaml
  :language: YAML

`Blacklist Guard Policy Type <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.common.Blacklist.yaml>`__

Filter Guard Policy Type
------------------------
The Filter Guard is a more robust guard for blacklisting and whitelisting A&AI entities when performing control loop operations. The intent for this guard is to filter in or out a block of entities, while allowing the ability to filter in or out specific entities. This allows a DevOps team to control the introduction of a Control Loop for a region or specific VNF's, as well as block specific VNF's that are being negatively affected when poor network conditions arise. Care and testing should be taken to understand the ramifications when combining multiple filters as well as their use in conjunction with other Guard Policy Types.

.. csv-table:: Filter Guard Properties
   :header: "Property", "Examples", "Required", "Type", "Description"

   "algorithm", "blacklist-overrides", "Required", "What algorithm to be applied", "blacklist-overrides or whitelist-overrides are the valid values. Indicates whether blacklisting or whitelisting has precedence."
   "filters", "see table below", "Required", "list of onap.datatypes.guard.filter", "List of datatypes that describe the filter."

.. csv-table:: Filter Guard onap.datatypes.guard.filter Properties
   :header: "Property", "Examples", "Required", "Type", "Description"

   "field", "generic-vnf.vnf-name", "Required", "String", "Field used to perform filter on and must be a string value. See the Policy Type below for valid values."
   "filter", "vnf-id-1", "Required", "String", "The filter being applied."
   "function", "string-equal", "Required", "String", "The function that is applied to the filter. See the Policy Type below for valid values."
   "blacklist", "true", "Required", "boolean", "Whether the result of the filter function applied to the filter is blacklisted or whitelisted (eg Deny or Permit)."

.. literalinclude:: example.guard.filter.yaml
  :language: YAML

`Filter Guard Policy Type <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.common.Filter.yaml>`__

.. _xacml-optimization-label:

Optimization Policy Types
=========================
These Policy Types are designed to be used by the OOF Project support several domains including VNF placement in ONAP.
The OOF Platform makes a call to the Decision API to request these Policies based on the values specified in the
onap.policies.Optimization properties. Each of these properties are treated relative to each other as an "AND". In
addition, each value for each property itself is treated as an "OR".

.. csv-table::
   :header: "Policy Type", "Action"

   "onap.policies.Optimization", "optimize"
   "onap.policies.optimization.Service", "optimize"
   "onap.policies.optimization.Resource", "optimize"
   "onap.policies.optimization.resource.AffinityPolicy", "optimize"
   "onap.policies.optimization.resource.DistancePolicy", "optimize"
   "onap.policies.optimization.resource.HpaPolicy", "optimize"
   "onap.policies.optimization.resource.OptimizationPolicy", "optimize"
   "onap.policies.optimization.resource.PciPolicy", "optimize"
   "onap.policies.optimization.service.QueryPolicy", "optimize"
   "onap.policies.optimization.service.SubscriberPolicy", "optimize"
   "onap.policies.optimization.resource.Vim_fit", "optimize"
   "onap.policies.optimization.resource.VnfPolicy", "optimize"

The optimization application extends the StdMatchablePolicyTranslator in that the application applies a "closest match"
algorithm internally after a XACML decision. This filters the results of the decision to return the one or more policies
that match the incoming decision request as close as possible. In addition, there is special consideration for the
Subscriber Policy Type. If a decision request contains subscriber context attributes, then internally the application
will apply an initial decision to retrieve the scope of the subscriber. The resulting scope attributes are then added
into a final internal decision call.

This is an example Decision API payload made to retrieve a decision for an Optimization Policy Type.

.. literalinclude:: decision.affinity.json
  :language: JSON

Native XACML Policy Type
========================

This Policy type is used by any client or ONAP component who has the need of native XACML evaluation. A native XACML policy or policy set encoded in XML can be created off this policy type and loaded into the XACML PDP engine by invoking the PAP policy deployment API. Native XACML requests encoded in either JSON or XML can be sent to the XACML PDP engine for evaluation by invoking the native decision API. Native XACML responses will be returned upon evaluating the requests against the matching XACML policies. Those native XACML policies, policy sets, requests and responses all follow the `OASIS XACML 3.0 Standard <http://docs.oasis-open.org/xacml/3.0/xacml-3.0-core-spec-os-en.html>`__.

.. csv-table::
   :header: "Policy Type", "Action", "Description"

   "onap.policies.native.Xacml", "native", "any client or ONAP component"

According to the XACML 3.0 specification, two content-types are supported and used to present the native requests/responses. They are formally defined as "application/xacml+json" and "application/xacml+xml".

This is an example Native Decision API payload made to retrieve a decision for whether Julius Hibbert can read http://medico.com/record/patient/BartSimpson.

.. literalinclude:: decision.native.json
  :language: JSON

Match Policy Type
=================

This Policy type can be used to design your own Policy Type and utilize the :ref:`StdMatchableTranslator <xacml-matchable-label>`, and does not need to build your own custom application. You can design your Policy Type by inheriting from the Match policy type (eg. onap.policies.match.<YourPolicyType>) and adding a **matchable** metadata set to **true** for the properties that you would like to request a Decision on. All a user would need to do is then use the Policy Lifecycle API to add their Policy Type and then create policies from it. Then deploy those policies to the XACML PDP and they would be able to get Decisions without customizing their ONAP installation.

Here is an example Policy Type:

.. literalinclude:: match.policy-type.yaml
  :language: YAML

Here are example Policies:

.. literalinclude:: match.policies.yaml
  :language: YAML

This is an example Decision API request that can be made:

.. literalinclude:: decision.match.request.json
  :language: JSON

Which would render the following decision response:

.. literalinclude:: decision.match.response.json
  :language: JSON

Overriding or Extending the ONAP XACML PDP Supported Policy Types
*****************************************************************

It is possible to extend or replace one or more of the existing ONAP application implementations with your own. Since the XACML application loader uses the java.util.Service class to search the classpath to find and load applications, it may be necessary via the configuration file to exclude the ONAP packaged applications in order for your custom application to be loaded. This can be done via the configuration file by adding an **exclusions** property with a list of the Java class names you wish to exclude.

`A configuration file example is located here at Line 19 <https://github.com/onap/policy-xacml-pdp/blob/7711185bb36b387e3596653ca170262f919ff474/main/src/test/resources/parameters/XacmlPdpConfigParameters_Exclusions.json>`_

A coding example is available in the JUnit test for the Application Manager called `testXacmlPdpApplicationManagerSimple at Line 143 <https://github.com/onap/policy-xacml-pdp/blob/7711185bb36b387e3596653ca170262f919ff474/main/src/test/java/org/onap/policy/pdpx/main/rest/XacmlPdpApplicationManagerTest.java>`_. This example demonstrates how to exclude the Match and Guard applications while verifying a custom `TestGuardOverrideApplication <https://github.com/onap/policy-xacml-pdp/blob/master/main/src/test/java/org/onap/policy/pdpx/main/rest/TestGuardOverrideApplication.java>`_ class is loaded and associated with the **guard** action. Thus, replacing and extending the guard application.

Note that this XACML PDP feature is exclusive to the XACML PDP and is secondary to the ability of the PAP to group PDP's and declare which Policy Types are supported by a PDP group. For example, even if a PDP group excludes a Policy Type for a XACML PDP, this simply prevents policies being deployed to that group using the PAP Deployment API. If there is no **exclusions** in the configuration file, then any application will be loaded that it is in the classpath. If needed, one could use both PDP group Policy Type supported feature **and** the exclusions configuration to completely restrict which Policy Types as well as which applications are loaded at runtime.

For more information on PDP groups and setting supported Policy Types, please refer to the :ref:`PAP Documentation <pap-label>`

Supporting Your Own Policy Types and Translators
************************************************

In order to support your own custom Policy Type that the XACML PDP Engine can support, one needs to build a Java service application that extends the **XacmlApplicationServiceProvider** interface and implement a **ToscaPolicyTranslator** application. Your application should register itself as a Java service application and expose it in the classpath used to be loaded into the ONAP XACML PDP Engine. Ensure you define and create the TOSCA Policy Type according to these :ref:`Policy Design and Development <design-label>`. You should be able to load your custom Policy Type using the :ref:`Policy Lifecycle API <api-label>`. Once successful, you should be able to start creating policies from your custom Policy Type.

XacmlApplicationServiceProvider
===============================

`Interface for XacmlApplicationServiceProvider <https://github.com/onap/policy-xacml-pdp/blob/master/applications/common/src/main/java/org/onap/policy/pdp/xacml/application/common/XacmlApplicationServiceProvider.java>`_

See each of the ONAP Policy Type application implementations which re-use the **StdXacmlApplicationServiceProvider** class. This implementation can be used as a basis for your own custom applications.

`Standard Application Service Provider implementation <https://github.com/onap/policy-xacml-pdp/blob/master/applications/common/src/main/java/org/onap/policy/pdp/xacml/application/common/std/StdXacmlApplicationServiceProvider.java>`_

ToscaPolicyTranslator
=====================

Your custom **XacmlApplicationServiceProvider** must provide an implementation of a **ToscaPolicyTranslator**.

`Interface for ToscaPolicyTranslator <https://github.com/onap/policy-xacml-pdp/blob/master/applications/common/src/main/java/org/onap/policy/pdp/xacml/application/common/ToscaPolicyTranslator.java>`_

See each of the ONAP Policy type application implementations which each have their own *ToscaPolicyTranslator*. Most use or extend the **StdBaseTranslator** which contain methods that applications can use to support XACML obligations, advice as well as return attributes to the calling client applications via the **DecisionResponse**.

`Standard Tosca Policy Translator implementation <https://github.com/onap/policy-xacml-pdp/blob/master/applications/common/src/main/java/org/onap/policy/pdp/xacml/application/common/std/StdBaseTranslator.java>`_.

XACML Application and Enforcement Tutorials
===========================================

The following tutorials can be helpful to get started on building your own decision application as well as building enforcement into your application. They also show how to build and extend both the **XacmlApplicationServiceProvider** and **ToscaPolicyTranslator** classes.

.. toctree::
   :maxdepth: 1

   xacml-tutorial
   xacml-tutorial-enforcement

