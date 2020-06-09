.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. DO NOT CHANGE THIS LABEL FOR RELEASE NOTES - EVEN THOUGH IT GIVES A WARNING
.. _release_notes:

Policy Release Notes
====================

.. note
..      * This Release Notes must be updated each time the team decides to Release new artifacts.
..      * The scope of these Release Notes are for ONAP POLICY. In other words, each ONAP component has its Release Notes.
..      * This Release Notes is cumulative, the most recently Released artifact is made visible in the top of
..      * this Release Notes.
..      * Except the date and the version number, all the other sections are optional but there must be at least
..      * one section describing the purpose of this new release.
..      * This note must be removed after content has been added.

..      ===========================
..      * * *    FRANKFURT    * * *
..      ===========================

Abstract
========

This document provides the release notes for the Policy Framework Project's Frankfurt release.

Summary
=======

New features include policy update notifications, native policy support, streamlined health check for the Policy Administration Point (PAP),
configurable pre-loading/pre-deployment of policies, new APIs (e.g. to create one or more Policies with a single call), new experimental PDP monitoring GUI, and enhancements to all three PDPs: XACML, Drools, APEX.

Release Data
============

+--------------------------------------+--------------------------------------+
| **Policy Project**                   |                                      |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Docker images**                    | - policy-api 2.2.4                   |
|                                      | - policy-pap 2.2.3                   |
|                                      | - policy-pdpd-cl 1.6.4               |
|                                      | - policy-xacml-pdp 2.2.2             |
|                                      | - policy-apex-pdp 2.3.2              |
|                                      | - policy-distribution 2.3.2          |
|                                      | - policy-pe 1.6.4                    |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release designation**              | 6.0.0 frankfurt                      |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | 2020-06-04                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+


New features
------------

Common changes in all policy components
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Upgraded all policy components to Java 11.
* Logback file can be now loaded using OOM configmap.
  - If needed, logback file can be loaded as a configmap during the OOM deployment. For this, just put the logback.xml file in corresponding config directory in OOM charts.

* TOSCA changes:
  - “tosca_definitions_version” is now “tosca_simple_yaml_1_1_0”
  - typeVersion→ type_version, int→integer, bool→boolean, String→string, Map→map, List→list
* SupportedPolicyTypes now removed from pdp status message.
  - All PDPs now send PdpGroup to which they belong to in the registration message.
  - SupportedPolicyTypes are not sent anymore.

* Native Policy Support
  - Each PDP engine has its own native policy language. A new Policy Type **onap.policies.Native** was created and supported for each PDP
  engine to support native policy types.


POLICY-PAP
~~~~~~~~~~
* Policy Update Notifications
  - PAP now generates notifications  via the DMaaP Message Router when policies are successfully or unsuccessfully deployed (or undeployed) from all relevant PDPs.

* PAP API to fetch Policy deployment status
  - Clients will be able to poll the PAP API to find out when policies have been successfully or unsuccessfully deployed to the PDP's.

* Removing supportedPolicyTypes from PdpStatus
  - PDPs are assigned to a PdpGroup based on what group is mentioned in the heartbeat. Earlier this was done based on the supportedPolicyTypes.

* Support policy types with wild-cards, Preload wildcard supported type in PAP

* PAP should NOT make a PDP passive if it cannot deploy a policy.
  - If a PDP fails to deploy one or more policies specified in a PDP-UPDATE message, PAP will undeploy those policies that failed to deploy to the PDP.  This entails removing the policies from the Pdp Group(s), issuing new PDP-UPDATE requests, and updating the notification tracking data.
  - Also, re-register pdp if not found in the DB during heartbeat processing.

* Consolidated health check in PAP
  - PAP can report the health check for ALL the policy components now. The PDP’s health is tracked based on heartbeats, and other component’s REST API is used for healthcheck.
  - “healthCheckRestClientParameters” (REST parameters for API and Distribution healthcheck) are added to the startup config file in PAP.

* PDP statistics from PAP
 - All PDPs send statistics data as part of the heartbeat. PAP reads this and saves this data to the database, and this statistics data can be accessed from the monitoring GUI.

* PAP API for Create or Update PdpGroups
 - A new API is now available just for creating/updating PDP Groups. Policies cannot be added/updated during PDP Group create/update operations. There is another API for this. So, if provided in the create/update group request, they are ignored. Supported policy types are defined during PDP Group creation. They cannot be updated once they are created. Refer to this for details: https://github.com/onap/policy-parent/blob/master/docs/pap/pap.rst#id8

* PAP API to deploy policies to PdpGroups
 - A new API is introduced to deploy policies on specific PDPGroups. Each subgroup includes an "action" property, which is used to indicate that the policies are being added (POST) to the subgroup, deleted (DELETE) from the subgroup, or that the subgroup's entire set of policies is being replaced (PATCH) by a new set of policies.

POLICY-API
~~~~~~~~~~

* A new simplified API to create one or more policies in one call.
  - This simplified API doesn’t require policy type id & policy type version to be part of the URL.
  - The simple URI “policy/api/v1/policies” with a POST input body takes in a ToscaServiceTemplate with the policies in it.

* List of Preloaded policy types are made configurable
  - Until El Alto, the list of pre-loaded policy types are hardcoded in the code. Now, this is made configurable, and the list can be specified in the startup config file for the API component under “preloadPolicyTypes”. The list is ignored if the DB already contains one or more policy types.

* Preload default policies for ONAP components
  - The ability to configure the preloading of initial default policies into the system upon startup.

* A lot of improvements to the API code and validations corresponding to the changes in policy-models.
  - Creating same policyType/policy repeatedly without any change in request body will always be successful with 200 response
  - If there is any change in the request body, then that should be a new version. If any change is posted without a version change, then 406 error response is returned.

* Known versioning issues are there in Policy Types handling.
  - https://jira.onap.org/browse/POLICY-2377 covers the versioning issues in Policy. Basically, multiple versions of a Policy Type cannot be handled in TOSCA. So, in Frankfurt, the latest version of the policy type is examined. This will be further looked into in Guilin.

* Cascaded GET of PolicyTypes and Policies
  - Fetching/GET PolicyType now returns all of the referenced/parent policyTypes and dataTypes as well.
  - Fetching/GET Policy allows specifying mode now.
  - By default the mode is “BARE”, which returns only the requested Policy in response. If mode is specified as “REFERENCED”, all of the referenced/parent policyTypes and dataTypes are returned as well.

* The /deployed API is removed from policy/api
  - This run time administration job to see the deployment status of a policy is now possible via PAP.

* Changes related to design and support of TOSCA Compliant Policy Types for the operational and guard policy models.

POLICY-DISTRIBUTION
~~~~~~~~~~~~~~~~~~~

* From Frankfurt release, policy-distribution component uses APIs provided by Policy-API and Policy-PAP for creation of policy types and policies, and deployment of policies.
  - Note: If “deployPolicies” field in the startup config file is true, then only the policies are deployed using PAP endpoint.

* Policy/engine & apex-pdp dependencies are removed from policy-distribution.


APEX-PDP
~~~~~~~~

* Changed the JavaScript executor from Nashorn to Rhino as part of Java 11 upgrade.
  - There are minor changes in the JavaScript task logic files associated with this Rhino migration. An example for this change can be seen here: https://gerrit.onap.org/r/c/policy/apex-pdp/+/103546/2/examples/examples-onap-bbs/src/main/resources/logic/SdncResourceUpdateTask.js

  - There is a known issue in Rhino javascript related to the usage of JSON.stringify. This is captured in this JIRA https://jira.onap.org/browse/POLICY-2463.

* APEX supports multiple policy deployment in Frankfurt.
  - Up through El Alto APEX-PDP had the capability to take in only a single ToscaPolicy. When PAP sends a list of Tosca Policies in PdpUpdate, only the first one is taken and only that single Policy is deployed in APEX. This is fixed in Frankfurt. Now, APEX can deploy a list of Tosca Policies altogether into the engine.

  - Note: There shouldn’t be any duplicates in the deployed policies (for e.g. same input/output parameter names, or same event/task names etc).

  - For example, when 3 policies are deployed and one has duplicates, say same input/task or any such concept is used in the 2nd and 3rd policy, then APEX-PDP ignores the 3rd policy and executes only the 1st and 2nd policies. APEX-PDP also respond back to PAP with the message saying that “only Policy 1 and 2 are deployed. Others failed due to duplicate concept”.

* Context retainment during policy upgrade.
  - In APEX-PDP, context is referred by the apex concept ‘contextAlbum’. When there is no major version change in the upgraded policy to be deployed, the existing context of the currently running policy is retained. When the upgraded policy starts running, it will have access to this context as well.

  - For example, Policy A v1.1 is currently deployed to APEX. It has a contextAlbum named HeartbeatContext and heartbeats are currently added to the HeartbeatContext based on events coming in to the policy execution. Now, when Policy A v1.2 (with some other changes and same HeartbeatContext) is deployed, Policy Av1.1 is replaced by Policy A1.2 in the APEX engine, but the content in HeartbeatContext is retained for Policy A1.2.

* APEX-PDP now specifies which PdpGroup it belongs to.
  - Up through El Alto, PAP assigned each PDP to a PDP group based on the supportedPolicyTypes it sends in the heartbeat. But in Frankfurt, each PDP comes up saying which PdpGroup they belong to, and this is sent to PAP in the heartbeat. PAP then registers the PDP the PdpGroup specified by the PDP. If no group name is specified like this, then PAP assigns the PDP to defaultGroup by default. SupportedPolicyTypes are not sent to PAP by the PDP now.

  - In APEX-PDP, this can be specified in the startup config file(OnapPfConfig.json). "pdpGroup": "<groupName>" is added under “pdpStatusParameters” in the config file.

* APEX-PDP now sends PdpStatistics data in heartbeat.
  - Apex now sends the PdpStatistics data in every heartbeat sent to PAP. PAP saves this data to the database, and this statistics data can be accessed from the monitoring GUI.

* Removed “content” section from ToscaPolicy properties in APEX.
  - Up through El Alto, APEX specific policy information was placed under properties|content in ToscaPolicy. Avoid placing under "content" and keep the information directly under properties. So, the ToscaPolicy structure will have apex specific policy information in properties|engineServiceParameters, properties|eventInputParameters, properties|eventOutputParameters.

* Passing parameters from ApexConfig to policy logic.
  - TaskParameters can be used to pass parameters from ApexConfig to the policy logic. Consider a scenario where from CLAMP, serviceId or closedLoopId has to be passed to the policy, and this should be available to perform some logic or action within the policy. In the CLAMP UI, while configuring the APEX Policy, specifying taskParameters with these will enable this.

  - More information about the usage of Task Parameters can be found here: https://onap.readthedocs.io/en/latest/submodules/policy/parent.git/docs/apex/APEX-User-Manual.html#configure-task-parameters

  - In the taskLogic, taskParameters can be accessed as  executor.parameters.get("ParameterKey1"))

  - More information can be found here: https://onap.readthedocs.io/en/latest/submodules/policy/parent.git/docs/apex/APEX-Policy-Guide.html#accessing-taskparameters

* GRPC support for APEX-CDS interaction.
  - APEX-PDP now supports interaction with CDS over gRPC. Up through El Alto, CDS interaction was possible over REST only. A new plugin was developed in APEX for this feature. Refer the link for more details. https://onap.readthedocs.io/en/latest/submodules/policy/parent.git/docs/apex/APEX-User-Manual.html#grpc-io

POLICY-XACML
~~~~~~~~~~~~

* Added optional Decision API param to Decision API for monitor decisions that returns abbreviated results.
  - Return only an abbreviated list of policies (e.g. metadata Policy Id and Version) without the actual contents of the policies (e.g. the Properties).

* XACML PDP now support PASSIVE_MODE.
* Added support to return status and error if pdp-x failed to load a policy.
* Changed optimization Decision API application to support "closest matches" algorithm.
* Changed Xacml-pdp to report the pdp group defined in XacmlPdpParameters config file as part of heartbeat. Also, removed supportedPolicyType from pdpStatus message.
* Design the TOSCA policy model for SDNC naming policies and implement an application that translates it to a working policy and is available for decision API.
* XACML pdp support for Control Loop Coordination
  - Added policies for SON and PCI to support each blocking the other, with test cases and appropriate requests

* Extend PDP-X capabilities so that it can load in and enforce the native XACML policies deployed from PAP.

POLICY-DROOLS-PDP
~~~~~~~~~~~~~~~~~

* Support for offline mode.
  - The OOM deployment now supports offline mode for PDP-D by default.

* Parameterize mvn repo urls and proxy settings
  - This allows the users to build the docker images for drools-pdp and drools-application using their own CI pipelines if needed.

* TOSCA Policy Type design for operational policy supported by Drools so that policy is compliant with TOSCA policies
* pip updated to pip3 in docker.
* Extend PDP-D capabilities so that it can instantiate new drools controller instances for executing native Drools policies deployed from PAP.
* Updated drools to use the redesigned Actors in policy/models.
* Server Pool feature for supporting multiple active Drools PDP hosts.
* server-pool is a resilient implementation that supports redundancy within and across data centers involving multiple PDP-Drools. Implementation involves hashing of which PDP-Drools owns which transaction and routing transactions to the appropriate PDP-Drools. By implementing as a feature, any deployment can choose to use or not use server-pool for its redundancy needs.

POLICY-DROOLS-APPLICATIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~

* Support for offline mode.
* Rate limiting DCAE flooding of ONSETs
  - Policy will get flooded with potentially hundreds of ONSETs at once being picked up from DMaaP. Processing of multiple ONSETs (potentially hundreds in a batch read) of the same underlying unique network alarm severely impacts performance.

* Design Operational Policy Type for Drools
  - Design and preload the drools operational policy type.
  - Backwards compatible support for tosca operational policies in usecases.
  - Tosca compliant vCPE, vFirewall, vDNS

* PDP-D support for native Drools policy execution
  - Topics are decoupled from controllers. Native policies require topics configured at installation. Topics can also be overridden or new ones added when being placed in the mounted config directory.

* Update Drools to use new actors.
  - Add frankfurt rules for Actor redesign
  - Usecases controller disabled (to be removed shortly after Frankfurt release) and the Frankfurt controller will be used.

* Delete template.demo sub-module and amsterdam controllers
* Removed vLB from drools-apps.
* Replace URL with host/port/contextURI in the controlloop properties.
  - Corresponding changes in base.conf file in OOM which is mounted.

Known Limitations, Issues and Workarounds
=========================================

System Limitations
------------------


Known Vulnerabilities
---------------------

* `POLICY-2463 <https://jira.onap.org/browse/POLICY-2463>`_ - In APEX Policy javascript task logic, JSON.stringify causing stackoverflow exceptions
* `POLICY-2487 <https://jira.onap.org/browse/POLICY-2487>`_ - policy/api hangs in loop if preload policy does not exist

Workarounds
-----------
* `POLICY-2463 <https://jira.onap.org/browse/POLICY-2463>`_ - Parse incoming object using JSON.Parse() or cast the object to a String

Security Notes
--------------

* `POLICY-2221 <https://jira.onap.org/browse/POLICY-2221>`_ - Password removal from helm charts
* `POLICY-2064 <https://jira.onap.org/browse/POLICY-2064>`_ - Allow overriding of keystore and truststore in policy helm charts
* `POLICY-2381 <https://jira.onap.org/browse/POLICY-2381>`_ - Dependency upgrades
    - Upgrade drools 7.33.0
    - Upgrade jquery to 3.4.1 in jquery-ui
    - Upgrade snakeyaml to 1.26
    - Upgrade org.infinispan infinispan-core 10.1.5.Final
    - upgrade io.netty 4.1.48.Final
    - exclude org.glassfish.jersey.media jersey-media-jaxb artifact
    - Upgrade com.fasterxml.jackson.core 2.10.0.pr3
    - Upgrade org.org.jgroups 4.1.5.Final
    - Upgrade commons-codec 20041127.091804
    - Upgrade com.github.ben-manes.caffeine 2.8.0


References
==========

For more information on the ONAP Frankfurt release, please see:

#. `ONAP Home Page`_
#. `ONAP Documentation`_
#. `ONAP Release Downloads`_
#. `ONAP Wiki Page`_


.. _`ONAP Home Page`: https://www.onap.org
.. _`ONAP Wiki Page`: https://wiki.onap.org
.. _`ONAP Documentation`: https://docs.onap.org
.. _`ONAP Release Downloads`: https://git.onap.org

Quick Links:
    - `POLICY project page`_
    - `Passing Badge information for POLICY`_

..      ==========================
..      * * *     EL ALTO    * * *
..      ==========================

Version: 5.0.1
--------------

:Release Date: 2019-10-24 (El Alto Release)

**New Features**

Artifacts released:

.. csv-table::
   :header: "Repository", "Java Artifact", "Docker Image (if applicable)"
   :widths: 15,10,10

   "policy/parent", "3.0.1", ""
   "policy/common", "1.5.2", ""
   "policy/models", "2.1.4", ""
   "policy/api", "2.1.2", "onap/policy-api:2.1.2"
   "policy/pap", "2.1.2", "onap/policy-pap:2.1.2"
   "policy/drools-pdp", "1.5.2", "onap/policy-drools:1.5.2"
   "policy/apex-pdp", "2.2.1", "onap/policy-apex-pdp:2.2.1"
   "policy/xacml-pdp", "2.1.2", "onap/policy-xacml-pdp:2.1.2"
   "policy/drools-applications", "1.5.3", "onap/policy-pdpd-cl:1.5.3"
   "policy/engine", "1.5.2", "onap/policy-pe:1.5.2"
   "policy/distribution", "2.2.1", "onap/policy-distribution:2.2.1"
   "policy/docker", "1.4.0", "onap/policy-common-alpine:1.4.0 onap/policy/base-alpine:1.4.0"

The El Alto release for POLICY delivered the following Epics. For a full list of stories and tasks delivered in the El Alto release, refer to `JiraPolicyElAlto`_.

    * [POLICY-1727] - This epic covers technical debt left over from Dublin
	- POLICY-969	Docker improvement in policy framwork modules
	- POLICY-1074	Fix checkstyle warnings in every repository
	- POLICY-1121	RPM build for Apex
	- POLICY-1223	CII Silver Badging Requirements
	- POLICY-1600	Clean up hash code equality checks, cloning and copying in policy-models
	- POLICY-1646	Replace uses of getCanonicalName() with getName()
	- POLICY-1652	Move PapRestServer to policy/common
	- POLICY-1732	Enable maven-checkstyle-plugin in apex-pdp
	- POLICY-1737	Upgrade oParent 2.0.0 - change daily jobs to staging jobs
	- POLICY-1742	Make HTTP return code handling configurable in APEX
	- POLICY-1743	Make URL configurable in REST Requestor and REST Client
	- POLICY-1744	Remove topic.properties and incorporate into overall properties
	- POLICY-1770	PAP REST API for PDPGroup Healthcheck
	- POLICY-1771	Boost policy/api JUnit code coverage
	- POLICY-1772	Boost policy/xacml-pdp JUnit code coverage
	- POLICY-1773	Enhance the policy/xacml-pdp S3P Stability and Performance tests
	- POLICY-1784	Better Handling of "version" field value with clients
	- POLICY-1785	Deploy same policy with a new version simply adds to the list
	- POLICY-1786	Create a simple way to populate the guard database for testing
	- POLICY-1791	Address Sonar issues in new policy repos
	- POLICY-1795	PAP: bounced apex and xacml pdps show deleted instance in pdp status through APIs. 
	- POLICY-1800	API|PAP components use different version formats
	- POLICY-1805	Build up stability test for api component to follow S3P requirements
	- POLICY-1806	Build up S3P performance test for api component
	- POLICY-1847	Add control loop coordination as a preloaded policy type
	- POLICY-1871	Change policy/distribution to support ToscaPolicyType & ToscaPolicy
	- POLICY-1881	Upgrade policy/distribution to latest SDC artifacts
	- POLICY-1885	Apex-pdp: Extend CLIEditor to generate policy in ToscaServiceTemplate format
	- POLICY-1898	Move apex-pdp & distribution documents to policy/parent
	- POLICY-1942	Boost policy/apex-pdp JUnit code coverage
	- POLICY-1953	Create addTopic taking BusTopicParams instead of Properties in policy/endpoints

    * Additional items delivered with the release.
	- POLICY-1637	Remove "version" from PdpGroup
	- POLICY-1653	Remove isNullVersion() method
	- POLICY-1966	Fix more sonar issues in policy drools
	- POLICY-1988	Generate El Alto AAF Certificates

    * [POLICY-1823] - This epic covers the work to develop features that will be deployed dark in El Alto.
	- POLICY-1762	Create CDS API model implementation
	- POLICY-1763	Create CDS Actor
	- POLICY-1899	Update optimization xacml application to support more flexible Decision API
	- POLICY-1911	XACML PDP must be able to retrieve Policy Type from API


**Bug Fixes**

The following bug fixes have been deployed with this release:

    * `[POLICY-1671] <https://jira.onap.org/browse/POLICY-1671>`_ - policy/engine JUnit tests now take over 30 minutes to run
    * `[POLICY-1725] <https://jira.onap.org/browse/POLICY-1725>`_ - XACML PDP returns 500 vs 400 for bad syntax JSON
    * `[POLICY-1793] <https://jira.onap.org/browse/POLICY-1793>`_ - API|MODELS: Retrieving Legacy Operational Policy as a Tosca Policy with wrong version
    * `[POLICY-1795] <https://jira.onap.org/browse/POLICY-1795>`_ - PAP: bounced apex and xacml pdps show deleted instance in pdp status through APIs. 
    * `[POLICY-1800] <https://jira.onap.org/browse/POLICY-1800>`_ - API|PAP components use different version formats
    * `[POLICY-1802] <https://jira.onap.org/browse/POLICY-1802>`_ - Apex-pdp: context album is mandatory for policy model to compile
    * `[POLICY-1803] <https://jira.onap.org/browse/POLICY-1803>`_ - PAP should undeploy policies when subgroup is deleted
    * `[POLICY-1807] <https://jira.onap.org/browse/POLICY-1807>`_ - Latest version is always returned when using the endpoint to retrieve all versions of a particular policy 
    * `[POLICY-1808] <https://jira.onap.org/browse/POLICY-1808>`_ - API|PAP|PDP-X [new] should publish docker images with the following tag X.Y-SNAPSHOT-latest 
    * `[POLICY-1810] <https://jira.onap.org/browse/POLICY-1810>`_ - API: support "../deployed" REST API (URLs) for legacy policies
    * `[POLICY-1811] <https://jira.onap.org/browse/POLICY-1811>`_ - The endpoint of retrieving the latest version of TOSCA policy does not return the latest one, especially when there are double-digit versions
    * `[POLICY-1818] <https://jira.onap.org/browse/POLICY-1818>`_ - APEX does not allow arbitrary Kafka parameters to be specified
    * `[POLICY-1838] <https://jira.onap.org/browse/POLICY-1838>`_ - Drools-pdp error log is missing data in ErrorDescription field
    * `[POLICY-1839] <https://jira.onap.org/browse/POLICY-1839>`_ - Policy Model  currently needs to be escaped
    * `[POLICY-1843] <https://jira.onap.org/browse/POLICY-1843>`_ - Decision API not returning monitoring policies when calling api with policy-type
    * `[POLICY-1844] <https://jira.onap.org/browse/POLICY-1844>`_ - XACML PDP does not update policy statistics
    * `[POLICY-1858] <https://jira.onap.org/browse/POLICY-1858>`_ - Usecase DRL - named query should not be invoked
    * `[POLICY-1859] <https://jira.onap.org/browse/POLICY-1859>`_ - Drools rules should not timeout when given timeout=0 - should be treated as infinite
    * `[POLICY-1872] <https://jira.onap.org/browse/POLICY-1872>`_ - brmsgw fails building a jar - trafficgenerator dependency does not exist
    * `[POLICY-2047] <https://jira.onap.org/browse/POLICY-2047>`_ - TOSCA Policy Types should be map not a list
    * `[POLICY-2060] <https://jira.onap.org/browse/POLICY-2060>`_ - ToscaProperties object is missing metadata field
    * `[POLICY-2156] <https://jira.onap.org/browse/POLICY-2156>`_ - missing field in create VF module request to SO


**Security Notes**

*Fixed Security Issues*


    * `[POLICY-2115] <https://jira.onap.org/browse/POLICY-2115>`_ - Upgrade org.jgroups : jgroups : 4.0.12.Final 
    * `[POLICY-2084] <https://jira.onap.org/browse/POLICY-2084>`_ - Investigate pip (py2.py3-none-any) 9.0.1 (.whl) in apex-pdp
    * `[POLICY-2072] <https://jira.onap.org/browse/POLICY-2072>`_ - Upgrade io.netty : netty-codec-http2 and netty-common to 4.1.39.Final
    * `[POLICY-2005] <https://jira.onap.org/browse/POLICY-2005>`_ - Upgrade elastic search to 6.8.2
    * `[POLICY-2001] <https://jira.onap.org/browse/POLICY-2001>`_ - Upgrade com.thoughtworks.xstream to 1.4.11.1
    * `[POLICY-2000] <https://jira.onap.org/browse/POLICY-2000>`_ - Upgrade oparent 2.1.0-SNAPSHOT - to pull in jetty server to 9.4.20.v20190813
    * `[POLICY-1999] <https://jira.onap.org/browse/POLICY-1999>`_ - Upgrade to httpcomponents httpclient 4.5.9
    * `[POLICY-1598] <https://jira.onap.org/browse/POLICY-1598>`_ - mariadb container is outdated
    * `[POLICY-1597] <https://jira.onap.org/browse/POLICY-1597>`_ - nexus container is outdated

*Known Security Issues*

*Known Vulnerabilities in Used Modules*

POLICY code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been addressed, items that remain open have been assessed for risk and determined to be false positive. The POLICY open Critical security vulnerabilities and their risk assessment have been documented as part of the `project (El Alto Release) <https://wiki.onap.org/pages/viewpage.action?pageId=68541992>`_.

Quick Links:
    - `POLICY project page`_
    - `Passing Badge information for POLICY`_
    - `Project Vulnerability Review Table for POLICY (El Alto Release) <https://wiki.onap.org/pages/viewpage.action?pageId=68541992>`_

**Known Issues**

The following known issues will be addressed in a future release:

    * `[POLICY-1276] <https://jira.onap.org/browse/POLICY-1276>`_ - JRuby interpreter shutdown fails on second and subsequent runs
    * `[POLICY-1291] <https://jira.onap.org/browse/POLICY-1291>`_ - Maven Error when building Apex documentation in Windows
    * `[POLICY-1578] <https://jira.onap.org/browse/POLICY-1578>`_ - PAP pushPolicies.sh in startup fails due to race condition in some environments
    * `[POLICY-1832] <https://jira.onap.org/browse/POLICY-1832>`_ - API|PAP: data race condition seem to appear sometimes when creating and deploying policy
    * `[POLICY-2103] <https://jira.onap.org/browse/POLICY-2103>`_ - policy/distribution may need to re-synch if SDC gets reinstalled
    * `[POLICY-2062] <https://jira.onap.org/browse/POLICY-2062>`_ - APEX PDP logs > 4G filled local storage
    * `[POLICY-2080] <https://jira.onap.org/browse/POLICY-2080>`_ - drools-pdp JUnit fails intermittently in feature-active-standby-management
    * `[POLICY-2111] <https://jira.onap.org/browse/POLICY-2111>`_ - PDP-D APPS: AAF Cadi conflicts with Aether libraries
    * `[POLICY-2158] <https://jira.onap.org/browse/POLICY-2158>`_ - PAP loses synchronization with PDPs
    * `[POLICY-2159] <https://jira.onap.org/browse/POLICY-2159>`_ - PAP console (legacy): cannot edit policies with GUI


..      ==========================
..      * * *      DUBLIN    * * *
..      ==========================

Version: 4.0.0
--------------

:Release Date: 2019-06-26 (Dublin Release)

**New Features**

Artifacts released:

.. csv-table::
   :header: "Repository", "Java Artifact", "Docker Image (if applicable)"
   :widths: 15,10,10

   "policy/parent", "2.1.0", ""
   "policy/common", "1.4.0", ""
   "policy/models", "2.0.2", ""
   "policy/api", "2.0.1", "onap/policy-api:2.0.1"
   "policy/pap", "2.0.1", "onap/policy-pap:2.0.1"
   "policy/drools-pdp", "1.4.0", "onap/policy-drools:1.4.0"
   "policy/apex-pdp", "2.1.0", "onap/policy-apex-pdp:2.1.0"
   "policy/xacml-pdp", "2.1.0", "onap/policy-xacml-pdp:2.1.0"
   "policy/drools-applications", "1.4.2", "onap/policy-pdpd-cl:1.4.2"
   "policy/engine", "1.4.1", "onap/policy-pe:1.4.1"
   "policy/distribution", "2.1.0", "onap/policy-distribution:2.1.0"
   "policy/docker", "1.4.0", "onap/policy-common-alpine:1.4.0 onap/policy/base-alpine:1.4.0"

The Dublin release for POLICY delivered the following Epics. For a full list of stories and tasks delivered in the Dublin release, refer to `JiraPolicyDublin`_.

    * [POLICY-1068] - This epic covers the work to cleanup, enhance, fix, etc. any Control Loop based code base.
        - POLICY-1195	Separate model code from drools-applications into other repositories
        - POLICY-1367	Spike - Experimentation for management of Drools templates and Operational Policies
        - POLICY-1397	PDP-D: NOOP Endpoints Support to test Operational Policies.
        - POLICY-1459	PDP-D [Control Loop] : Create a Control Loop flavored PDP-D image

    * [POLICY-1069] - This epic covers the work to harden the codebase for the Policy Framework project.
        - POLICY-1007	Remove Jackson from policy framework components
        - POLICY-1202	policy-engine & apex-pdp are using different version of eclipselink
        - POLICY-1250	Fix issues reported by sonar in policy modules
        - POLICY-1368	Remove hibernate from policy repos
        - POLICY-1457	Use Alpine in base docker images

    * [POLICY-1072] - This epic covers the work to support S3P Performance criteria.
        - S3P Performance related items

    * [POLICY-1171] - Enhance CLC Facility
        - POLICY-1173	High-level specification of coordination directives

    * [POLICY-1220] - This epic covers the work to support S3P Security criteria
        - POLICY-1538	Upgrade Elasticsearch to 6.4.x to clear security issue

    * [POLICY-1269] - R4 Dublin - ReBuild Policy Infrastructure
        - POLICY-1270	Policy Lifecycle API RESTful HealthCheck/Statistics Main Entry Point
        - POLICY-1271	PAP RESTful HealthCheck/Statistics Main Entry Point
        - POLICY-1272	Create the S3P JMeter tests for API, PAP, XACML (2nd Gen)
        - POLICY-1273	Policy Type Application Design Requirements
        - POLICY-1436	XACML PDP RESTful HealthCheck/Statistics Main Entry Point
        - POLICY-1440	XACML PDP RESTful Decision API Main Entry Point
        - POLICY-1441	Policy Lifecycle API RESTful Create/Read Main Entry Point for Policy Types
        - POLICY-1442	Policy Lifecycle API RESTful Create/Read Main Entry Point for Concrete Policies
        - POLICY-1443	PAP Dmaap PDP Register/UnRegister Main Entry Point
        - POLICY-1444	PAP Dmaap Policy Deploy/Undeploy Policies Main Entry Point
        - POLICY-1445	XACML PDP upgrade to xacml 2.0.0
        - POLICY-1446	Policy Lifecycle API RESTful Delete Main Entry Point for Policy Types
        - POLICY-1447	Policy Lifecycle API RESTful Delete Main Entry Point for Concrete Policies
        - POLICY-1449	XACML PDP Dmaap Register/UnRegister Functionality
        - POLICY-1451	XACML PDP Dmaap Deploy/UnDeploy Functionality
        - POLICY-1452	Apex PDP Dmaap Register/UnRegister Functionality
        - POLICY-1453	Apex PDP Dmaap Deploy/UnDeploy Functionality
        - POLICY-1454	Drools PDP Dmaap Register/UnRegister Functionality
        - POLICY-1455	Drools PDP Dmaap Deploy/UnDeploy Functionality
        - POLICY-1456	Policy Architecture and Roadmap Documentation
        - POLICY-1458	Create S3P JMeter Tests for Policy API
        - POLICY-1460	Create S3P JMeter Tests for PAP
        - POLICY-1461	Create S3P JMeter Tests for Policy XACML Engine (2nd Generation)
        - POLICY-1462	Create S3P JMeter Tests for Policy SDC Distribution
        - POLICY-1471	Policy Application Designer - Develop Guard and Control Loop Coordination Policy Type application
        - POLICY-1474	Modifications of Control Loop Operational Policy to support new Policy Lifecycle API
        - POLICY-1515	Prototype Policy Lifecycle API Swagger Entry Points
        - POLICY-1516	Prototype the Policy Decision API
        - POLICY-1541	PAP REST API for PDPGroup Query, Statistics & Delete
        - POLICY-1542	PAP REST API for PDPGroup Deployment, State Management & Health Check

    * [POLICY-1399] - This epic covers the work to support model drive control loop design as defined by the Control Loop Subcommittee
        - Model drive control loop related items

    * [POLICY-1404] - This epic covers the work to support the CCVPN Use Case for Dublin
        - POLICY-1405	Develop SDNC API for trigger bandwidth

    * [POLICY-1408] - This epic covers the work done with the Casablanca release
        - POLICY-1410	List Policy API
        - POLICY-1413	Dashboard enhancements
        - POLICY-1414	Push Policy and DeletePolicy API enhancement
        - POLICY-1416	Model enhancements to support CLAMP
        - POLICY-1417	Resiliency improvements
        - POLICY-1418	PDP APIs - make ClientAuth optional
        - POLICY-1419	Better multi-role support
        - POLICY-1420	Model enhancement to support embedded JSON
        - POLICY-1421	New audit data for push/delete
        - POLICY-1422	Enhanced encryption
        - POLICY-1423	Save original model file
        - POLICY-1427	Controller Logging Feature
        - POLICY-1489	PDP-D: Nested JSON Event Filtering support with JsonPath
        - POLICY-1499	Mdc Filter Feature

    * [POLICY-1438] - This epic covers the work to support 5G OOF PCI Use Case
        - POLICY-1463	Functional code changes in Policy for OOF SON use case
        - POLICY-1464	Config related aspects for OOF SON use case

    * [POLICY-1450] - This epic covers the work to support the Scale Out Use Case.
        - POLICY-1278	AAI named-queries are being deprecated and should be replaced with custom-queries
        - POLICY-1545	E2E Automation - Parse the newly added model ids from operation policy

    * Additional items delivered with the release.
        - POLICY-1159	Move expectException to policy-common/utils-test
        - POLICY-1176	Work on technical debt introduced by CLC POC
        - POLICY-1266	A&AI Modularity
        - POLICY-1274	further improvement in PSSD S3P test
        - POLICY-1401	Build onap.policies.Monitoring TOSCA Policy Template
        - POLICY-1465	Support configurable Heap Memory Settings for JVM processes


**Bug Fixes**

The following bug fixes have been deployed with this release:

    * `[POLICY-1241] <https://jira.onap.org/browse/POLICY-1241>`_ - Test failure in drools-pdp if JAVA_HOME is not set
    * `[POLICY-1289] <https://jira.onap.org/browse/POLICY-1289>`_ - Apex only considers 200 response codes as successful result codes
    * `[POLICY-1437] <https://jira.onap.org/browse/POLICY-1437>`_ - Fix issues in FileSystemReceptionHandler of policy-distribution component
    * `[POLICY-1501] <https://jira.onap.org/browse/POLICY-1501>`_ - policy-engine JUnit tests are not independent
    * `[POLICY-1627] <https://jira.onap.org/browse/POLICY-1627>`_ - APEX does not support specification of a partitioner class for Kafka

**Security Notes**

*Fixed Security Issues*

    * `[OJSI-117] <https://jira.onap.org/browse/OJSI-117>`_ - In default deployment POLICY (nexus) exposes HTTP port 30236 outside of cluster.
    * `[OJSI-157] <https://jira.onap.org/browse/OJSI-157>`_ - In default deployment POLICY (policy-api) exposes HTTP port 30240 outside of cluster.
    * `[OJSI-118] <https://jira.onap.org/browse/OJSI-118>`_ - In default deployment POLICY (policy-apex-pdp) exposes HTTP port 30237 outside of cluster.
    * `[OJSI-184] <https://jira.onap.org/browse/OJSI-184>`_ - In default deployment POLICY (brmsgw) exposes HTTP port 30216 outside of cluster.

*Known Security Issues*

*Known Vulnerabilities in Used Modules*

POLICY code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been addressed, items that remain open have been assessed for risk and determined to be false positive. The POLICY open Critical security vulnerabilities and their risk assessment have been documented as part of the `project (Dublin Release) <https://wiki.onap.org/pages/viewpage.action?pageId=54723253>`_.

Quick Links:
    - `POLICY project page`_
    - `Passing Badge information for POLICY`_
    - `Project Vulnerability Review Table for POLICY (Dublin Release) <https://wiki.onap.org/pages/viewpage.action?pageId=54723253>`_


**Known Issues**

The following known issues will be addressed in a future release:

    * `[POLICY-1795] - <https://jira.onap.org/browse/POLICY-1795>`_ PAP: bounced apex and xacml pdps show deleted instance in pdp status through APIs. 
    * `[POLICY-1810] - <https://jira.onap.org/browse/POLICY-1810>`_ API: ensure that the REST APISs (URLs) are supported and consistent regardless the type of policy: operational, guard, tosca-compliant.
    * `[POLICY-1277] - <https://jira.onap.org/browse/POLICY-1277>`_ policy config takes too long time to become retrievable in PDP
    * `[POLICY-1378] - <https://jira.onap.org/browse/POLICY-1378>`_ add support to append value into policyScope while one policy could be used by several services
    * `[POLICY-1650] - <https://jira.onap.org/browse/POLICY-1650>`_ Policy UI doesn't show left menu or any content
    * `[POLICY-1671] - <https://jira.onap.org/browse/POLICY-1671>`_ policy/engine JUnit tests now take over 30 minutes to run
    * `[POLICY-1725] - <https://jira.onap.org/browse/POLICY-1725>`_ XACML PDP returns 500 vs 400 for bad syntax JSON
    * `[POLICY-1793] - <https://jira.onap.org/browse/POLICY-1793>`_ API|MODELS: Retrieving Legacy Operational Policy as a Tosca Policy with wrong version
    * `[POLICY-1800] - <https://jira.onap.org/browse/POLICY-1800>`_ API|PAP components use different version formats
    * `[POLICY-1802] - <https://jira.onap.org/browse/POLICY-1802>`_ Apex-pdp: context album is mandatory for policy model to compile
    * `[POLICY-1808] - <https://jira.onap.org/browse/POLICY-1808>`_ API|PAP|PDP-X [new] should publish docker images with the following tag X.Y-SNAPSHOT-latest 
    * `[POLICY-1818] - <https://jira.onap.org/browse/POLICY-1818>`_ APEX does not allow arbitrary Kafka parameters to be specified
    * `[POLICY-1276] - <https://jira.onap.org/browse/POLICY-1276>`_ JRuby interpreter shutdown fails on second and subsequent runs
    * `[POLICY-1803] - <https://jira.onap.org/browse/POLICY-1803>`_ PAP should undeploy policies when subgroup is deleted
    * `[POLICY-1291] - <https://jira.onap.org/browse/POLICY-1291>`_ Maven Error when building Apex documentation in Windows
    * `[POLICY-1872] - <https://jira.onap.org/browse/POLICY-1872>`_ brmsgw fails building a jar - trafficgenerator dependency does not exist


..      ==========================
..      * * *   CASABLANCA   * * *
..      ==========================

Version: 3.0.2
--------------

:Release Date: 2019-03-31 (Casablanca Maintenance Release #2)

The following items were deployed with the Casablanca Maintenance Release:

**Bug Fixes**

    * [POLICY-1522] - Policy doesn't send "payload" field to APPC

**Security Fixes**

    * [POLICY-1538] - Upgrade Elasticsearch to 6.4.x to clear security issue

**License Issues**

    * [POLICY-1433] - Remove proprietary licenses in PSSD test CSAR

**Known Issues**

The following known issue will be addressed in a future release.

    * `[POLICY-1650] <https://jira.onap.org/browse/POLICY-1277>`_ - Policy UI doesn't show left menu or any content

A workaround for this issue consists in bypassing the Portal UI when accessing the Policy UI.   See `PAP recipes <https://docs.onap.org/en/casablanca/submodules/policy/engine.git/docs/platform/cookbook.html?highlight=policy%20cookbook#id23>`_ for the specific procedure.


Version: 3.0.1
--------------

:Release Date: 2019-01-31 (Casablanca Maintenance Release)

The following items were deployed with the Casablanca Maintenance Release:

**New Features**

    * [POLICY-1221] - Policy distribution application to support HTTPS communication
    * [POLICY-1222] - Apex policy PDP to support HTTPS Communication

**Bug Fixes**

    * `[POLICY-1282] <https://jira.onap.org/browse/POLICY-1282>`_ - Policy format with some problems
    * `[POLICY-1395] <https://jira.onap.org/browse/POLICY-1395>`_ - Apex PDP does not preserve context on model upgrade


Version: 3.0.0
--------------

:Release Date: 2018-11-30 (Casablanca Release)

**New Features**

The Casablanca release for POLICY delivered the following Epics. For a full list of stories and tasks delivered in the Casablanca release, refer to `JiraPolicyCasablanca`_ (Note: Jira details can also be viewed from this link).

    * [POLICY-701] - This epic covers the work to integrate Policy into the SDC Service Distribution

    The policy team introduced a new application into the framework that provides integration of the Service Distribution Notifications from SDC to Policy.

    * [POLICY-719] - This epic covers the work to build the Policy Lifecycle API
    * [POLICY-726] - This epic covers the work to distribute policy from the PAP to the PDPs into the ONAP platform
    * [POLICY-876] - This epics covers the work to re-build how the PAP organizes the PDP's into groups.

    The policy team did some forward looking spike work towards re-building the Software Architecture.

    * [POLICY-809] - Maintain and implement performance
    * [POLICY-814] - 72 hour stability testing (component and platform)

    The policy team made enhancements to the Drools PDP to further support S3P Performance.
    For the new Policy SDC Distribution application and the newly ingested Apex PDP the team established S3P
    performance standard and performed 72 hour stability tests.

    * [POLICY-824] - maintain and implement security

    The policy team established AAF Root Certificate for HTTPS communication and CADI/AAF integration into the
    MVP applications. In addition, many java dependencies were upgraded to clear CLM security issues.

    * [POLICY-840] - Flexible control loop coordination facility.

    Work towards a POC for control loop coordination policies were implemented.

    * [POLICY-841] - Covers the work required to support HPA

    Enhancements were made to support the HPA use case through the use of the new Policy SDC Service Distribution application.

    * [POLICY-842] - This epic covers the work to support the Auto Scale Out functional requirements

    Enhancements were made to support Scale Out Use Case to enforce new guard policies and updated SO and A&AI APIs.

    * [POLICY-851] - This epic covers the work to bring in the Apex PDP code

    A new Apex PDP engine was ingested into the platform and work was done to ensure code cleared CLM security issues,
    sonar issues, and checkstyle.

    * [POLICY-1081] - This epic covers the contribution for the 5G OOF PCI Optimization use case.

    Policy templates changes were submitted that supported the 5G OOF PCI optimization use case.

    * [POLICY-1182] - Covers the work to support CCVPN use case

    Policy templates changes were submitted that supported the CCVPN use case.

**Bug Fixes**

The following bug fixes have been deployed with this release:

    * `[POLICY-799] <https://jira.onap.org/browse/POLICY-799>`_ - Policy API Validation Does Not Validate Required Parent Attributes in the Model
    * `[POLICY-869] <https://jira.onap.org/browse/POLICY-869>`_ - Control Loop Drools Rules should not have exceptions as well as die upon an exception
    * `[POLICY-872] <https://jira.onap.org/browse/POLICY-872>`_ - investigate potential race conditions during rules version upgrades during call loads
    * `[POLICY-878] <https://jira.onap.org/browse/POLICY-878>`_ - pdp-d: feature-pooling disables policy-controllers preventing processing of onset events
    * `[POLICY-909] <https://jira.onap.org/browse/POLICY-909>`_ - get_ZoneDictionaryDataByName class type error
    * `[POLICY-920] <https://jira.onap.org/browse/POLICY-920>`_ - Hard-coded path in junit test
    * `[POLICY-921] <https://jira.onap.org/browse/POLICY-921>`_ - XACML Junit test cannot find property file
    * `[POLICY-1083] <https://jira.onap.org/browse/POLICY-1083>`_ - Mismatch in action cases between Policy and APPC


**Security Notes**

POLICY code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been addressed, items that remain open have been assessed for risk and determined to be false positive. The POLICY open Critical security vulnerabilities and their risk assessment have been documented as part of the `project (Casablanca Release) <https://wiki.onap.org/pages/viewpage.action?pageId=45300864>`_.

Quick Links:
    - `POLICY project page`_
    - `Passing Badge information for POLICY`_
    - `Project Vulnerability Review Table for POLICY (Casablanca Release) <https://wiki.onap.org/pages/viewpage.action?pageId=45300864>`_

**Known Issues**

    * `[POLICY-1277] <https://jira.onap.org/browse/POLICY-1277>`_ - policy config takes too long time to become retrievable in PDP
    * `[POLICY-1282] <https://jira.onap.org/browse/POLICY-1282>`_ - Policy format with some problems



..      =======================
..      * * *   BEIJING   * * *
..      =======================

Version: 2.0.0
--------------

:Release Date: 2018-06-07 (Beijing Release)

**New Features**

The Beijing release for POLICY delivered the following Epics. For a full list of stories and tasks delivered in the Beijing release, refer to `JiraPolicyBeijing`_.

    * [POLICY-390] - This epic covers the work to harden the Policy platform software base (incl 50% JUnit coverage)
        - POLICY-238	policy/drools-applications: clean up maven structure
        - POLICY-336	Address Technical Debt
        - POLICY-338	Address JUnit Code Coverage
        - POLICY-377	Policy Create API should validate input matches DCAE microservice template
        - POLICY-389	Cleanup Jenkin's CI/CD process's
        - POLICY-449	Policy API + Console : Common Policy Validation
        - POLICY-568	Integration with org.onap AAF project
        - POLICY-610	Support vDNS scale out for multiple times in Beijing release

    * [POLICY-391] - This epic covers the work to support Release Planning activities
        - POLICY-552	ONAP Licensing Scan - Use Restrictions

    * [POLICY-392] - Platform Maturity Requirements - Performance Level 1
        - POLICY-529	Platform Maturity Performance - Drools PDP
        - POLICY-567	Platform Maturity Performance - PDP-X

    * [POLICY-394] - This epic covers the work required to support a Policy developer environment in which Policy Developers can create, update policy templates/rules separate from the policy Platform runtime platform.
        - POLICY-488	pap should not add rules to official template provided in drools applications

    * [POLICY-398] - This epic covers the body of work involved in supporting policy that is platform specific.
        - POLICY-434	need PDP /getConfig to return an indicator of where to find the config data - in config.content versus config field

    * [POLICY-399] - This epic covers the work required to policy enable Hardware Platform Enablement
        - POLICY-622	Integrate OOF Policy Model into Policy Platform

    * [POLICY-512] - This epic covers the work to support Platform Maturity Requirements - Stability Level 1
        - POLICY-525	Platform Maturity Stability - Drools PDP
        - POLICY-526	Platform Maturity Stability - XACML PDP

    * [POLICY-513] - Platform Maturity Requirements - Resiliency Level 2
        - POLICY-527	Platform Maturity Resiliency - Policy Engine GUI and PAP
        - POLICY-528	Platform Maturity Resiliency - Drools PDP
        - POLICY-569	Platform Maturity Resiliency - BRMS Gateway
        - POLICY-585	Platform Maturity Resiliency - XACML PDP
        - POLICY-586	Platform Maturity Resiliency - Planning
        - POLICY-681	Regression Test Use Cases

    * [POLICY-514] - This epic covers the work to support Platform Maturity Requirements - Security Level 1
        - POLICY-523	Platform Maturity Security - CII Badging - Project Website

    * [POLICY-515] - This epic covers the work to support Platform Maturity Requirements - Escalability Level 1
        - POLICY-531	Platform Maturity Scalability - XACML PDP
        - POLICY-532	Platform Maturity Scalability - Drools PDP
        - POLICY-623	Docker image re-design

    * [POLICY-516] - This epic covers the work to support Platform Maturity Requirements - Manageability Level 1
        - POLICY-533	Platform Maturity Manageability L1 - Logging
        - POLICY-534	Platform Maturity Manageability - Instantiation < 1 hour

    * [POLICY-517] - This epic covers the work to support Platform Maturity Requirements - Usability Level 1
        - POLICY-535	Platform Maturity Usability - User Guide
        - POLICY-536	Platform Maturity Usability - Deployment Documentation
        - POLICY-537	Platform Maturity Usability - API Documentation

    * [POLICY-546] - R2 Beijing - Various enhancements requested by clients to the way we handle TOSCA models.


**Bug Fixes**

The following bug fixes have been deployed with this release:

    * `[POLICY-484] <https://jira.onap.org/browse/POLICY-484>`_ - Extend election handler run window and clean up error messages
    * `[POLICY-494] <https://jira.onap.org/browse/POLICY-494>`_ - POLICY EELF Audit.log not in ECOMP Standards Compliance
    * `[POLICY-501] <https://jira.onap.org/browse/POLICY-501>`_ - Fix issues blocking election handler and add directed interface for opstate
    * `[POLICY-509] <https://jira.onap.org/browse/POLICY-509>`_ - Add IntelliJ file to .gitingore
    * `[POLICY-510] <https://jira.onap.org/browse/POLICY-510>`_ - Do not enforce hostname validation
    * `[POLICY-518] <https://jira.onap.org/browse/POLICY-518>`_ - StateManagement creation of EntityManagers.
    * `[POLICY-519] <https://jira.onap.org/browse/POLICY-519>`_ - Correctly initialize the value of allSeemsWell in DroolsPdpsElectionHandler
    * `[POLICY-629] <https://jira.onap.org/browse/POLICY-629>`_ - Fixed a bug on editor screen
    * `[POLICY-684] <https://jira.onap.org/browse/POLICY-684>`_ - Fix regex for brmsgw dependency handling
    * `[POLICY-707] <https://jira.onap.org/browse/POLICY-707>`_ - ONAO-PAP-REST unit tests fail on first build on clean checkout
    * `[POLICY-717] <https://jira.onap.org/browse/POLICY-717>`_ - Fix a bug in checking required fields if the object has include function
    * `[POLICY-734] <https://jira.onap.org/browse/POLICY-734>`_ - Fix Fortify Header Manipulation Issue
    * `[POLICY-743] <https://jira.onap.org/browse/POLICY-743>`_ - Fixed data name since its name was changed on server side
    * `[POLICY-753] <https://jira.onap.org/browse/POLICY-753>`_ - Policy Health Check failed with multi-node cluster
    * `[POLICY-765] <https://jira.onap.org/browse/POLICY-765>`_ - junit test for guard fails intermittently


**Security Notes**

POLICY code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been addressed, items that remain open have been assessed for risk and determined to be false positive. The POLICY open Critical security vulnerabilities and their risk assessment have been documented as part of the `project <https://wiki.onap.org/pages/viewpage.action?pageId=25437092>`_.

Quick Links:
    - `POLICY project page`_
    - `Passing Badge information for POLICY`_
    - `Project Vulnerability Review Table for POLICY <https://wiki.onap.org/pages/viewpage.action?pageId=25437092>`_

**Known Issues**

The following known issues will be addressed in a future release:

    * `[POLICY-522] <https://jira.onap.org/browse/POLICY-522>`_ - PAP REST APIs undesired HTTP response body for 500 responses
    * `[POLICY-608] <https://jira.onap.org/browse/POLICY-608>`_ - xacml components : remove hardcoded secret key from source code
    * `[POLICY-764] <https://jira.onap.org/browse/POLICY-764>`_ - Policy Engine PIP Configuration JUnit Test fails intermittently
    * `[POLICY-776] <https://jira.onap.org/browse/POLICY-776>`_ - OOF Policy TOSCA models are not correctly rendered
    * `[POLICY-799] <https://jira.onap.org/browse/POLICY-799>`_ - Policy API Validation Does Not Validate Required Parent Attributes in the Model
    * `[POLICY-801] <https://jira.onap.org/browse/POLICY-801>`_ - fields mismatch for OOF flavorFeatures between implementation and wiki
    * `[POLICY-869] <https://jira.onap.org/browse/POLICY-869>`_  - Control Loop Drools Rules should not have exceptions as well as die upon an exception
    * `[POLICY-872] <https://jira.onap.org/browse/POLICY-872>`_  - investigate potential race conditions during rules version upgrades during call loads




Version: 1.0.2
--------------

:Release Date: 2018-01-18 (Amsterdam Maintenance Release)

**Bug Fixes**

The following fixes were deployed with the Amsterdam Maintenance Release:

    * `[POLICY-486] <https://jira.onap.org/browse/POLICY-486>`_ - pdp-x api pushPolicy fails to push latest version


Version: 1.0.1
--------------

:Release Date: 2017-11-16 (Amsterdam Release)

**New Features**

The Amsterdam release continued evolving the design driven architecture of and functionality for POLICY.  The following is a list of Epics delivered with the release. For a full list of stories and tasks delivered in the Amsterdam release, refer to `JiraPolicyAmsterdam`_.

    * [POLICY-31] - Stabilization of Seed Code
        - POLICY-25  Replace any remaining openecomp reference by onap
        - POLICY-32  JUnit test code coverage
        - POLICY-66  PDP-D Feature mechanism enhancements
        - POLICY-67  Rainy Day Decision Policy
        - POLICY-93  Notification API
        - POLICY-158  policy/engine: SQL injection Mitigation
        - POLICY-269  Policy API Support for Rainy Day Decision Policy and Dictionaries

    * [POLICY-33] - This epic covers the body of work involved in deploying the Policy Platform components
        - POLICY-40  MSB Integration
        - POLICY-124  Integration with oparent
        - POLICY-41  OOM Integration
        - POLICY-119  PDP-D: noop sinks

    * [POLICY-34] - This epic covers the work required to support a Policy developer environment in which Policy Developers can create, update policy templates/rules separate from the policy Platform runtime platform.
        - POLICY-57  VF-C Actor code development
        - POLICY-43  Amsterdam Use Case Template
        - POLICY-173  Deployment of Operational Policies Documentation

    * [POLICY-35] - This epic covers the body of work involved in supporting policy that is platform specific.
        - POLICY-68  TOSCA Parsing for nested objects for Microservice Policies

    * [POLICY-36] - This epic covers the work required to capture policy during VNF on-boarding.

    * [POLICY-37] - This epic covers the work required to capture, update, extend Policy(s) during Service Design.
        - POLICY-64  CLAMP Configuration and Operation Policies for vFW Use Case
        - POLICY-65  CLAMP Configuration and Operation Policies for vDNS Use Case
        - POLICY-48  CLAMP Configuration and Operation Policies for vCPE Use Case
        - POLICY-63  CLAMP Configuration and Operation Policies for VOLTE Use Case

    * [POLICY-38] - This epic covers the work required to support service distribution by SDC.

    * [POLICY-39] - This epic covers the work required to support the Policy Platform during runtime.
        - POLICY-61  vFW Use Case - Runtime
        - POLICY-62  vDNS Use Case - Runtime
        - POLICY-59  vCPE Use Case - Runtime
        - POLICY-60  VOLTE Use Case - Runtime
        - POLICY-51  Runtime Policy Update Support
        - POLICY-328  vDNS Use Case - Runtime Testing
        - POLICY-324  vFW Use Case - Runtime Testing
        - POLICY-320  VOLTE Use Case - Runtime Testing
        - POLICY-316  vCPE Use Case - Runtime Testing

    * [POLICY-76] - This epic covers the body of work involved in supporting R1 Amsterdam Milestone Release Planning Milestone Tasks.
        - POLICY-77  Functional Test case definition for Control Loops
        - POLICY-387  Deliver the released policy artifacts


**Bug Fixes**
    - This is technically the first release of POLICY, previous release was the seed code contribution. As such, the defects fixed in this release were raised during the course of the release. Anything not closed is captured below under Known Issues. For a list of defects fixed in the Amsterdam release, refer to `JiraPolicyAmsterdam`_.


**Known Issues**
    - The operational policy template has been tested with the vFW, vCPE, vDNS and VOLTE use cases.  Additional development may/may not be required for other scenarios.

    - For vLBS Use Case, the following steps are required to setup the service instance:
       	-  Create a Service Instance via VID.
        -  Create a VNF Instance via VID.
        -  Preload SDNC with topology data used for the actual VNF instantiation (both base and DNS scaling modules). NOTE: you may want to set "vlb_name_0" in the base VF module data to something unique. This is the vLB server name that DCAE will pass to Policy during closed loop. If the same name is used multiple times, the Policy name-query to AAI will show multiple entries, one for each occurrence of that vLB VM name in the OpenStack zone. Note that this is not a limitation, typically server names in a domain are supposed to be unique.
        -  Instantiate the base VF module (vLB, vPacketGen, and one vDNS) via VID. NOTE: The name of the VF module MUST start with ``Vfmodule_``. The same name MUST appear in the SDNC preload of the base VF module topology. We'll relax this naming requirement for Beijing Release.
        -  Run heatbridge from the Robot VM using ``Vfmodule_`` _ as stack name (it is the actual stack name in OpenStack)
        -  Populate AAI with a dummy VF module for vDNS scaling.

**Security Issues**
    - None at this time

**Other**
    - None at this time


.. Links to jira release notes

.. _JiraPolicyElAlto: https://jira.onap.org/secure/ReleaseNote.jspa?projectId=10106&version=10728
.. _JiraPolicyDublin: https://jira.onap.org/secure/ReleaseNote.jspa?projectId=10106&version=10464
.. _JiraPolicyCasablanca: https://jira.onap.org/secure/ReleaseNote.jspa?projectId=10106&version=10446
.. _JiraPolicyBeijing: https://jira.onap.org/secure/ReleaseNote.jspa?projectId=10106&version=10349
.. _JiraPolicyAmsterdam: https://jira.onap.org/secure/ReleaseNote.jspa?projectId=10106&version=10300

.. Links to Project related pages

.. _POLICY project page: https://wiki.onap.org/display/DW/Policy+Framework+Project
.. _Passing Badge information for POLICY: https://bestpractices.coreinfrastructure.org/en/projects/1614


.. note
..      CHANGE  HISTORY
..	09/19/2019 - Updated for El Alto Release.
..	05/16/2019 - Updated for Dublin Release.
..      01/17/2019 - Updated for Casablanca Maintenance Release.
..      11/19/2018 - Updated for Casablanca.  Also, fixed bugs is a list of bugs where the "Affected Version" is Beijing.
..		Changed version number to use ONAP versions.
..      10/08/2018 - Initial document for Casablanca release.
..	05/29/2018 - Information for Beijing release.
..      03/22/2018 - Initial document for Beijing release.
..      01/15/2018 - Added change for version 1.1.3 to the Amsterdam branch.  Also corrected prior version (1.2.0) to (1.1.1)
..		Also, Set up initial information for Beijing.
..		Excluded POLICY-454 from bug list since it doesn't apply to Beijing per Jorge.


End of Release Notes

.. How to notes for SS
..	For initial document: list epic and user stories for each, list user stories with no epics.
..     	For Bugs section, list bugs where Affected Version is a prior release (Casablanca, Beijing etc), Fixed Version is the current release (Dublin), Resolution is done.
..     	For Known issues, list bugs that are slotted for a future release.
