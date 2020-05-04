.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _xacml-label:

Policy XACML PDP Engine
#######################

.. toctree::
   :maxdepth: 2

The ONAP XACML Policy PDP Engine uses an `open source implementation <https://github.com/att/XACML>`__ of the `OASIS XACML 3.0 Standard <https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=xacml>`__ to support fine-grained policy decisions in the ONAP. The XACML 3.0 Standard is a language for both policies and requests/responses for access control decisions. The ONAP XACML PDP translates TOSCA Compliant Policies into the XACML policy language, loads the policies into the XACML engine and exposes a Decision API which uses the XACML request/response language to render decisions for ONAP components.

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
-----------------------------------------------

This translator pulls a URL encoded XML XACML policy from a TOSCA Policy and loads it into a XACML Engine. This allows native XACML policies to be used to support complex use cases in which a translation from TOSCA to XACML is too difficult.

`Implementation of Native Policy Translator <https://github.com/onap/policy-xacml-pdp/tree/master/applications/native/src/main/java/org/onap/policy/xacml/pdp/application/nativ>`_

Monitoring Policy Types
=======================
These Policy Types are used by Control Loop DCAE microservice components to support monitoring of VNF/PNF entities to support an implementation of a Control Loops. The DCAE Platform makes a call to Decision API to request the contents of these policies. The implementation involves creating an overarching XACML Policy that contains the TOSCA policy as a payload that is returned to the DCAE Platform.

The following policy types derive from onap.policies.Monitoring:

.. csv-table::
   :header: "Derived Policy Type", "Action", "Description"

   "onap.policies.monitoring.cdap.tca.hi.lo.app", "configure", "TCA DCAE microservice component"
   "onap.policies.monitoring.dcaegen2.collectors.datafile.datafile-app-server", "configure", "REST Collector"
   "onap.policies.monitoring.docker.sonhandler.app", "configure", "SON Handler microservice component"

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
   "onap.policies.controlloop.guard.coordination.FirstBlocksSecond", "guard", "Gives priority to one control loop vs another"

This is an example Decision API payload made to retrieve a decision for a Guard Policy Type.

.. literalinclude:: decision.guard.json
  :language: JSON

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

This Policy type is used by any client or ONAP component who has the need of native XACML evaluation. A native XACML policy or policy set encoded in XML can be created off this policy type and loaded into the XACML PDP engine by invoking the PAP policy deployment API. Native XACML requests encoded in either JSON or XML can be sent to the XACML PDP engine for evaluation by invoking the native decision API. Native XACML responses will be returned upon evaluating the requests against the matching XACML policies. Those native XACML policies, policy sets, requests and responses all follow the `OASIS XACML 3.0 Standard <https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=xacml>`__.

.. csv-table::
   :header: "Policy Type", "Action", "Description"

   "onap.policies.native.Xacml", "native", "any client or ONAP component"

According to the XACML 3.0 specification, two content-types are supported and used to present the native requests/responses. They are formally defined as "application/xacml+json" and "application/xacml+xml".

This is an example Native Decision API payload made to retrieve a decision for whether Julius Hibbert can read http://medico.com/record/patient/BartSimpson.

.. literalinclude:: decision.native.json
  :language: JSON

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

Your custom **XacmlApplicationServiceProvider** must provide an implementation of a *ToscaPolicyTranslator*.

`Interface for ToscaPolicyTranslator <https://github.com/onap/policy-xacml-pdp/blob/master/applications/common/src/main/java/org/onap/policy/pdp/xacml/application/common/ToscaPolicyTranslator.java>`_

See each of the ONAP Policy type application implementations which each have their own *ToscaPolicyTranslator*. Most use or extend the **StdBaseTranslator**.

`Standard Tosca Policy Translator implementation <https://github.com/onap/policy-xacml-pdp/blob/master/applications/common/src/main/java/org/onap/policy/pdp/xacml/application/common/std/StdBaseTranslator.java>`.

XACML Application Tutorial
==========================

The following tutorial can be helpful to get started:

.. toctree::
   :maxdepth: 1

   xacml-tutorial

Once your application is developed and the ONAP XACML PDP Engine can find your application via setting the classpath appropriately, then use the :ref:`PAP REST API <pap-label>` to ensure the ONAP XACML PDP is registering your custom Policy Type with the PAP. Once successful, then you should be able to start deploying the created policies to the XACML PDP Engine.

