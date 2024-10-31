.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. DO NOT CHANGE THIS LABEL FOR RELEASE NOTES - EVEN THOUGH IT GIVES A WARNING
.. _release_notes:

Policy Framework Release Notes
##############################

.. note
..      * This Release Notes must be updated each time the team decides to Release new artifacts.
..      * The scope of these Release Notes are for ONAP POLICY. In other words, each ONAP component has its Release Notes.
..      * This Release Notes is cumulative, the most recently Released artifact is made visible in the top of
..      * this Release Notes.
..      * Except the date and the version number, all the other sections are optional but there must be at least
..      * one section describing the purpose of this new release.


..      ==========================
..      * * *     NEWDELHI     * * *
..      ==========================

Version: 14.0.0
---------------

:Release Date: 2024-06-13 (Newdelhi Release)

Artifacts released:

.. list-table::
   :widths: 15 10 10
   :header-rows: 1

   * - Repository
     - Java Artifact
     - Docker Image (if applicable)
   * - policy/parent
     - 4.1.4
     - N/A
   * - policy/docker
     - 3.1.3
     - | policy-jre-alpine
       | policy-jdk-alpine
       | policy-db-migrator
   * - policy/common
     - 2.1.3
     - N/A
   * - policy/models
     - 3.1.3
     - N/A
   * - policy/api
     - 3.1.3
     - policy-api
   * - policy/pap
     - 3.1.3
     - policy-pap
   * - policy/apex-pdp
     - 3.1.3
     - policy-apex-pdp
   * - policy/drools-pdp
     - 2.1.3
     - policy-drools
   * - policy/xacml-pdp
     - 3.1.3
     - policy-xacml-pdp
   * - policy/distribution
     - 3.1.3
     - policy-distribution
   * - policy/clamp
     - 7.1.3
     - | policy-clamp-ac-pf-ppnt
       | policy-clamp-ac-k8s-ppnt
       | policy-clamp-ac-http-ppnt
       | policy-clamp-runtime-acm'
   * - policy/gui
     - 3.1.3
     - policy-gui
   * - policy/drools-applications
     - 2.1.3
     - policy-pdpd-cl

Key Updates
===========

* Improvements to CLAMP Automation Composition Management (ACM)

  CLAMP ACM is improved with various new capabilities in newdelhi release. ACM supports tracing feature with the integration of openTelemetry for http and kafka tracing.
  This provides a more efficient way of diagnosing bottlenecks and performance issues in the system.
  Participant's outProperties are now retained during the restart and redeployment scenario that can be consumed by the participants.
  New Regression test suite has been added to test the ACM workflow with various combinations of ACM-R and participant versions.
  ACM element versions can now be upgraded during Migration.

  See:
   - `POLICY-4865 <https://lf-onap.atlassian.net/browse/POLICY-4865>`_ - R14: Improvements specific to clamp

* Backward compatibility support in ACM

  From Newdelhi release, Users can deploy a newer version of ACM-R against an older participant version maintaining the backward compatibility.
  Participant intermediary provides flexibility for the users to maintain the older version participant when ACM-R is upgraded.

  See:
   - `POLICY-4952 <https://lf-onap.atlassian.net/browse/POLICY-4952>`_ - R14: Backward compatibility between ACM-R and participants

* Oparent dependency removed

  From newdelhi onwards, Policy framework can be installed without oparent maven dependency. policy-parent provides all the required dependencies and design rule configurations
  for the policy components.

  See:
   - `POLICY-4960 <https://lf-onap.atlassian.net/browse/POLICY-4960>`_ - R14: Remove oparent dependency from PF

* Tracing support in clamp

  Distributed tracing of messages between acm, participants, databases, rest is available in policy clamp that helps to diagnose the bottlenecks and performance issues in the system.
  A combination of OpenTelemetry and Micrometer is used to achieve this.

  See:
   - `POLICY-4875 <https://lf-onap.atlassian.net/browse/POLICY-4875>`_ - R14: Add support for Open Telemetry in ACM.

Known Limitations, Issues and Workarounds
=========================================

System Limitations
~~~~~~~~~~~~~~~~~~
N/A

Known Vulnerabilities
~~~~~~~~~~~~~~~~~~~~~
N/A

Workarounds
~~~~~~~~~~~
N/A

Security Notes
==============
N/A

Functional Improvements
=======================
| `POLICY-4865 <https://lf-onap.atlassian.net/browse/POLICY-4865>`_ - R14: Improvements specific to clamp
|  `POLICY-4875 <https://lf-onap.atlassian.net/browse/POLICY-4875>`_ - Add support for Open Telemetry in ACM
|  `POLICY-4908 <https://lf-onap.atlassian.net/browse/POLICY-4908>`_ - Add support for outProperties retention in restart/redeploy scenario
|  `POLICY-4952 <https://lf-onap.atlassian.net/browse/POLICY-4952>`_ - Support backward compatibility between ACM and participants
|  `POLICY-4915 <https://lf-onap.atlassian.net/browse/POLICY-4915>`_ - Allow element version update in Migration
|  `POLICY-4869 <https://lf-onap.atlassian.net/browse/POLICY-4869>`_ - Allow semantic versioning in ACM templates and instances
|  `POLICY-4934 <https://lf-onap.atlassian.net/browse/POLICY-4934>`_ - Add db migrator support for clamp database

| `POLICY-4960 <https://lf-onap.atlassian.net/browse/POLICY-4960>`_ - Remove oparent dependency in Policy framework


Necessary Improvements and Bug Fixes
====================================

Necessary Improvements
~~~~~~~~~~~~~~~~~~~~~~
| `POLICY-4867 <https://lf-onap.atlassian.net/browse/POLICY-4867>`_ - R14: Refactoring and removal of unused code
|  `POLICY-4855 <https://lf-onap.atlassian.net/browse/POLICY-4855>`_ - Remove AAF from Policy common repository
| `POLICY-4868 <https://lf-onap.atlassian.net/browse/POLICY-4868>`_ - R14: Software (non functional) improvements
|  `POLICY-4960 <https://lf-onap.atlassian.net/browse/POLICY-4960>`_ - Remove oparent dependency in Policy framework
|  `POLICY-4654 <https://lf-onap.atlassian.net/browse/POLICY-4654>`_ - Add metrics for ACM-R and participants
|  `POLICY-4893 <https://lf-onap.atlassian.net/browse/POLICY-4893>`_ - Update Security dependencies
|  `POLICY-4895 <https://lf-onap.atlassian.net/browse/POLICY-4895>`_ - Update SLAs dashboards with spring actuator changes
|  `POLICY-4987 <https://lf-onap.atlassian.net/browse/POLICY-4987>`_ - Improve CSIT scripts and dependencies updates to CSIT docker images
|  `POLICY-5002 <https://lf-onap.atlassian.net/browse/POLICY-5002>`_ - Alter release scripts to include checkstyle update
| `POLICY-4865 <https://lf-onap.atlassian.net/browse/POLICY-4865>`_ - R14: Improvements specific to CLAMP
|  `POLICY-4806 <https://lf-onap.atlassian.net/browse/POLICY-4806>`_ - Support stress testing of ACM with multiple compositions
|  `POLICY-4870 <https://lf-onap.atlassian.net/browse/POLICY-4870>`_ - Improve descriptiveness of error messages in clamp
|  `POLICY-4900 <https://lf-onap.atlassian.net/browse/POLICY-4900>`_ - Add validation in ACM for unique element Ids
|  `POLICY-4918 <https://lf-onap.atlassian.net/browse/POLICY-4918>`_ - Support recursive update of properties in participant Intermediary
| `POLICY-4635 <https://lf-onap.atlassian.net/browse/POLICY-4635>`_ - R14: Enhance Policy Framework Documentation
|  `POLICY-4644 <https://lf-onap.atlassian.net/browse/POLICY-4644>`_ - Development documentation for Apex
|  `POLICY-4584 <https://lf-onap.atlassian.net/browse/POLICY-4584>`_ - Update property configuration mechanism documentation
|  `POLICY-4585 <https://lf-onap.atlassian.net/browse/POLICY-4585>`_ - Update PAP architecture documentation
|  `POLICY-4629 <https://lf-onap.atlassian.net/browse/POLICY-4629>`_ - Update policy framework upgrade documentation

Bug Fixes
~~~~~~~~~
| `POLICY-4946 <https://lf-onap.atlassian.net/browse/POLICY-4946>`_ - Authorization issue in jenkins merge job for policy clamp regression module
| `POLICY-4953 <https://lf-onap.atlassian.net/browse/POLICY-4953>`_ - Missing properties from participant cache during migration
| `POLICY-4961 <https://lf-onap.atlassian.net/browse/POLICY-4961>`_ - Fix AutomationComposition copy constructor
| `POLICY-4968 <https://lf-onap.atlassian.net/browse/POLICY-4968>`_ - K8s Participant gets out of sync with ChartMuseum


References
==========

For more information on the ONAP London release, please see:

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
..      * * *     MONTREAL     * * *
..      ==========================

Version: 13.0.0
---------------

:Release Date: 2023-11-30 (Montreal Release)

Artifacts released:

.. list-table::
   :widths: 15 10 10
   :header-rows: 1

   * - Repository
     - Java Artifact
     - Docker Image (if applicable)
   * - policy/parent
     - 4.0.2
     - N/A
   * - policy/docker
     - 3.0.2
     - | policy-jre-alpine
       | policy-jdk-alpine
       | policy-db-migrator
   * - policy/common
     - 2.0.2
     - N/A
   * - policy/models
     - 3.0.2
     - N/A
   * - policy/api
     - 3.0.2
     - policy-api
   * - policy/pap
     - 3.0.2
     - policy-pap
   * - policy/apex-pdp
     - 3.0.2
     - policy-apex-pdp
   * - policy/drools-pdp
     - 2.0.2
     - policy-drools
   * - policy/xacml-pdp
     - 3.0.2
     - policy-xacml-pdp
   * - policy/distribution
     - 3.0.2
     - policy-distribution
   * - policy/clamp
     - 7.0.3
     - | policy-clamp-ac-pf-ppnt
       | policy-clamp-ac-k8s-ppnt
       | policy-clamp-ac-http-ppnt
       | policy-clamp-runtime-acm'
   * - policy/gui
     - 3.0.2
     - policy-gui
   * - policy/drools-applications
     - 2.0.2
     - policy-pdpd-cl

Key Updates
===========

* Improvements to CLAMP Automation Composition Management (ACM)

  CLAMP ACM is improved with new features and Failure handling capabilities. ACM can handle a restarted participant and send updates to the participant with the runtime data.
  In addition, the user can also update instance properties on the deployed instances without impacting the ACM system. From Montreal release, the ACM participants can handle
  multiple messages from ACM simultaneously. ACM configuration now supports customizable element names in the compositions.

  See:
   - `POLICY-4505 <https://lf-onap.atlassian.net/browse/POLICY-4505>`_ - R13: Improvements specific to clamp

* Migration functionality in ACM

  From Montreal release, Users can migrate the deployed AC instances to a different composition definition with updated configurations without impacting the running system.

  See:
   - `POLICY-4809 <https://lf-onap.atlassian.net/browse/POLICY-4809>`_ - R13: Instance Migration/Upgrade in ACM

* Java 17 Upgrade

  All the components in the policy framework are upgraded to java 17 version. Spring version upgraded to spring 6 and spring boot 3. This improves the overall performance of the
  applications along with the latest java capabilities. Also this upgrade is very significant in removing the critical security vulnerabilities.

  See:
   - `POLICY-4665 <https://lf-onap.atlassian.net/browse/POLICY-4665>`_ - R13: Java 17 and associated dependency upgrade

* Remove AAF from Policy Framework

  AAF project is deprecated in ONAP. Policy Framework is refactored to remove unused functionalities and configurations related to AAF.

  See:
   - `POLICY-4592 <https://lf-onap.atlassian.net/browse/POLICY-4592>`_ - R13: Remove AAF from Policy Framework

Known Limitations, Issues and Workarounds
=========================================

System Limitations
~~~~~~~~~~~~~~~~~~
N/A

Known Vulnerabilities
~~~~~~~~~~~~~~~~~~~~~
N/A

Workarounds
~~~~~~~~~~~
N/A

Security Notes
==============

Policy Framework upgraded to Spring 6 and Springboot 3 and eliminated critical security vulnerabilities. Java version upgraded to Java 17.

Functional Improvements
=======================
| `POLICY-4505 <https://lf-onap.atlassian.net/browse/POLICY-4505>`_ - R13: Improvements specific to clamp
|  `POLICY-4591 <https://lf-onap.atlassian.net/browse/POLICY-4591>`_ - Update properties on deployed instances
|  `POLICY-4683 <https://lf-onap.atlassian.net/browse/POLICY-4683>`_ - Failure handling on the ACM-R
|  `POLICY-4700 <https://lf-onap.atlassian.net/browse/POLICY-4700>`_ - Handle multiple messages from ACM to Participant simultaneously
|  `POLICY-4716 <https://lf-onap.atlassian.net/browse/POLICY-4716>`_ - Enable timeout functionality in ACM/Participants
|  `POLICY-4684 <https://lf-onap.atlassian.net/browse/POLICY-4684>`_ - Participant restart handling in ACM
|  `POLICY-4827 <https://lf-onap.atlassian.net/browse/POLICY-4827>`_ - Allow customisation of element names in composition definition
|  `POLICY-4699 <https://lf-onap.atlassian.net/browse/POLICY-4699>`_ - Create a mock participant for ACM testing
|  `POLICY-4809 <https://lf-onap.atlassian.net/browse/POLICY-4809>`_ - Instance Migration/Upgrade in ACM

Necessary Improvements and Bug Fixes
====================================

Necessary Improvements
~~~~~~~~~~~~~~~~~~~~~~
| `POLICY-4396 <https://lf-onap.atlassian.net/browse/POLICY-4396>`_ - R13: Improvements on Apex-pdp
|  `POLICY-4765 <https://lf-onap.atlassian.net/browse/POLICY-4765>`_ - Support for Context Albums across policy sets in Apex
|  `POLICY-4645 <https://lf-onap.atlassian.net/browse/POLICY-4645>`_ - Use Postgres DB in CSIT tests for Apex-pdp
| `POLICY-4505 <https://lf-onap.atlassian.net/browse/POLICY-4505>`_ - R13: Improvements on clamp Acm
|  `POLICY-4651 <https://lf-onap.atlassian.net/browse/POLICY-4651>`_ - Extend instance deletion to request additional actions in participant
|  `POLICY-4636 <https://lf-onap.atlassian.net/browse/POLICY-4636>`_ - ACM manual and automation tests
|  `POLICY-4774 <https://lf-onap.atlassian.net/browse/POLICY-4774>`_ - Participant priming properties
|  `POLICY-4762 <https://lf-onap.atlassian.net/browse/POLICY-4762>`_ - Unused Property Removal in clamp/docker
|  `POLICY-4802 <https://lf-onap.atlassian.net/browse/POLICY-4802>`_ - Make authentication optional for prometheus metrics
|  `POLICY-4808 <https://lf-onap.atlassian.net/browse/POLICY-4808>`_ - Update swagger with new functionality and examples
|  `POLICY-4818 <https://lf-onap.atlassian.net/browse/POLICY-4818>`_ - policy endpoint allow packaging of kafka-client dependency
|  `POLICY-4768 <https://lf-onap.atlassian.net/browse/POLICY-4768>`_ - Update openapi.yaml to have the common headers section
|  `POLICY-4763 <https://lf-onap.atlassian.net/browse/POLICY-4763>`_ - Make changes to the liveness/readiness timeout in helm charts
| `POLICY-4593 <https://lf-onap.atlassian.net/browse/POLICY-4593>`_ - R13: Software (non functional) improvements
|  `POLICY-4615 <https://lf-onap.atlassian.net/browse/POLICY-4615>`_ - Software Vulnerability discrepancies in Sonatype reports
|  `POLICY-4406 <https://lf-onap.atlassian.net/browse/POLICY-4406>`_ - Mitigate vulnerable dependencies in CDS
|  `POLICY-4831 <https://lf-onap.atlassian.net/browse/POLICY-4831>`_ - Fix Sonar issues


Bug Fixes
~~~~~~~~~
| `POLICY-4769 <https://lf-onap.atlassian.net/browse/POLICY-4769>`_ - State change result of AC instances not updated after TIMEOUT
| `POLICY-4770 <https://lf-onap.atlassian.net/browse/POLICY-4770>`_ - Participants are offline in the runtime database after registration
| `POLICY-4772 <https://lf-onap.atlassian.net/browse/POLICY-4772>`_ - Restart flag in ACM instance is still true after participant is restarted
| `POLICY-4773 <https://lf-onap.atlassian.net/browse/POLICY-4773>`_ - Missing validation in Delete AC instance
| `POLICY-4776 <https://lf-onap.atlassian.net/browse/POLICY-4776>`_ - Participants are unable to perform deploy/undeploy/delete operations after restart
| `POLICY-4804 <https://lf-onap.atlassian.net/browse/POLICY-4804>`_ - Participant Intermediary is not updating the transition state "UNDEPLOYING" in the participant status
| `POLICY-4830 <https://lf-onap.atlassian.net/browse/POLICY-4830>`_ - Tosca element names are not validated if not aligned with the configured values


References
==========

For more information on the ONAP London release, please see:

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
..      * * *     LONDON     * * *
..      ==========================

Version: 12.0.0
---------------

:Release Date: 2023-06-15 (London Release)

Artifacts released:

.. list-table::
   :widths: 15 10 10
   :header-rows: 1

   * - Repository
     - Java Artifact
     - Docker Image (if applicable)
   * - policy/parent
     - 3.7.2
     - N/A
   * - policy/docker
     - 2.6.2
     - | policy-jre-alpine
       | policy-jdk-alpine
       | policy-db-migrator
   * - policy/common
     - 1.12.2
     - N/A
   * - policy/models
     - 2.8.2
     - N/A
   * - policy/api
     - 2.8.2
     - policy-api
   * - policy/pap
     - 2.8.2
     - policy-pap
   * - policy/apex-pdp
     - 2.9.2
     - policy-apex-pdp
   * - policy/drools-pdp
     - 1.12.2
     - policy-drools
   * - policy/xacml-pdp
     - 2.8.2
     - policy-xacml-pdp
   * - policy/distribution
     - 2.9.2
     - policy-distribution
   * - policy/clamp
     - 6.4.3
     - | policy-clamp-ac-pf-ppnt
       | policy-clamp-ac-k8s-ppnt
       | policy-clamp-ac-http-ppnt
       | policy-clamp-runtime-acm'
   * - policy/gui
     - 2.4.2
     - policy-gui
   * - policy/drools-applications
     - 1.12.2
     - policy-pdpd-cl

Key Updates
===========

* Improvements to CLAMP Automation Composition Management (ACM)

  CLAMP ACM is improved to allow much more flexibility in the specification and life cycle management of rApps. ACM can manage the lifecycle of
  rApps made up of an arbitrary number of microservices and rules/learning models/schemas in the form of metadata. In the London release,
  the state machine is improved to allow priming of rApp types, and to support deploymeent/undeployment and locking/unlocking of rApps.
  Update of the properties of rApps is also supported at run time. In addition,
  `ITU Recommendation X.731 <https://www.itu.int/rec/T-REC-X.731-199201-I/en>`_ is now supported for state reporting from rApp microservices.

  See:
   - `POLICY-4401 <https://lf-onap.atlassian.net/browse/POLICY-4401>`_ - R12: Improvements specific to clamp

* Improved database support in CLAMP ACM

  CLAMP ACM now supports MySql 8.x as a database and supports secured DB communication.

  See:
   - `POLICY-4395 <https://lf-onap.atlassian.net/browse/POLICY-4395>`_ - R12: Database related issues

* Metadata driven API Generation

  Up until now, the Policy Framework components used handwritten code to implement their REST interfaces and the Swagger 2 API documentation was generated from
  annotations in the code. From the London release on, the REST API code is generated from OpenAPI 3.0 (Swagger 3.0) documents. In addition, the API documentation
  is substantially enhanced. See the `Policy Offered APIs in the documentation <https://docs.onap.org/projects/onap-policy-parent/en/london/offeredapis.html>`_.

  See:
   - `POLICY-4123 <https://lf-onap.atlassian.net/browse/POLICY-4123>`_ - R12: OpenAPI Adaption and Swagger Cleanup

* Improved Metrics and SLAs

  The metrics generated by the Policy Framework have been substantially improved for the London release. In addition to gathering metrics on REST call
  performance and policy deployment and execution time, we have defined SLA values for these metrics. We have implemented automated tests that run
  as part of the CSIT testing that ensure the SLAs are complied with.

  See:
   - `POLICY-4124 <https://lf-onap.atlassian.net/browse/POLICY-4124>`_ - R12: Add metrics to measure SLAs

* Improved Testing

  Testing is much improved in the London release.
    - S3P tests have been automated and run as CSIT tests
    - Automated tests to verify SLA compliance using prometheus metrics are added
    - A suite of contract tests is provided for each REST API
    - Tests now use http rather than https

  See:
   - `POLICY-4125 <https://lf-onap.atlassian.net/browse/POLICY-4125>`_ - R12: New Test Development
   - `POLICY-4126 <https://lf-onap.atlassian.net/browse/POLICY-4126>`_ - R12: Improve Automated Testing and Policy Framework S3P Tests

Known Limitations, Issues and Workarounds
=========================================

System Limitations
~~~~~~~~~~~~~~~~~~
N/A

Known Vulnerabilities
~~~~~~~~~~~~~~~~~~~~~
.. list-table::
   :widths: 8 3 5 15
   :header-rows: 1

   * - Dependency
     - Security Threat Level
     - Policy Framework Components
     - Comment
   * - com.fasterxml.jackson.core:jackson-core:2.14.1 (2.15.1)
     - 10
     - | policy/common (D)
       | policy/models (T)
       | policy/api (T)
       | policy/pap (T)
       | policy/distribution (T)
       | policy/clamp (T)
       | policy/gui (T)
       | policy/apex-pdp (T)
       | policy/xacml-pdp (T)
       | policy/drools-pdp (T)
       | policy/drools-applications (T)
     - Used in the implementation of policy endpoints
   * - com.google.protobuf:protobuf-java:3.10.0
     - 10
     - | policy/models (T)
       | policy/clamp (T)
       | policy/apex-pdp (T)
       | policy/drools-applications (T)
     - Transitive dependency pulled in by CDS/Spring/Springboot
   * - com.squareup.okhttp3:okhttp:4.9.1
     - 10
     - | policy/clamp (T)
     - Transitive dependency pulled in by Spring/Springboot
   * - com.sthoughtworks.xstrea:xstream:1.4.19
     - 10
     - | policy/drools-pdp (T)
     - Transitive dependency pulled in by Drools rules
   * - net.minidev:json-smart:2.4.6
     - 10
     - | policy/models (T)
       | policy/apex-pdp (T)
       | policy/drools-applications (T)
     - Transitive dependency pulled in by CDS
   * - io.grpc:grpc-core:1.25.0
     - 6
     - | policy/models (T)
       | policy/apex-pdp (T)
       | policy/drools-applications (T)
     - Transitive dependency pulled in by CDS
   * - org.apache.maven:maven-model:3.8.6
     - 6
     - | policy/drools-pdp (T)
     - Transitive dependency pulled in to handle artifact generation
   * - org.apache.tomcat.embed:tomcat-embed-core:9.0.71
     - 10
     - | policy/api (T)
       | policy/pap (T)
       | policy/clamp (T)
     - Transitive dependency pulled in by org.springframework.boot:spring-boot-starter-web
   * - org.bouncycastle:bc.fips:1.0.2.3
     - 6
     - | policy/common (T)
       | policy/models (T)
       | policy/distribution (T)
       | policy/apex-pdp (T)
     - Transitive dependency pulled in by org.bouncycastle:bcpkix-fips:1.0.5 in the utils-test module
   * - org.eclipse.jetty:jetty-http:10.0.13
     - 6
     - | policy/common (T)
       | policy/models (T)
       | policy/api (T)
       | policy/pap (T)
       | policy/distribution (T)
       | policy/clamp (T)
       | policy/gui (T)
       | policy/apex-pdp (T)
       | policy/drools-pdp (T)
       | policy/xacml-pdp (T)
       | policy/drools-applications (T)
     - Transitive dependency pulled in by org.eclipse.jetty:jetty-server
   * - org.eclipse.jetty:jetty-server:10.0.13
     - 6
     - | policy/common (D)
       | policy/models (T)
       | policy/api (T)
       | policy/pap (T)
       | policy/distribution (T)
       | policy/clamp (T)
       | policy/gui (T)
       | policy/apex-pdp (T)
       | policy/drools-pdp (T)
       | policy/xacml-pdp (T)
       | policy/drools-applications (T)
     - Used in the implementation of policy endpoints
   * - org.jetbrains.kotlin:kotlin-daemon-client:1.3.61
     - 6
     - | policy/models (T)
       | policy/apex-pdp (T)
       | policy/drools-applications (T)
     - Transitive dependency pulled in by CDS
   * - org.jetbrains.kotlin:kotlin-scripting-jvm:1.3.61
     - 6
     - | policy/models (T)
       | policy/apex-pdp (T)
       | policy/drools-applications (T)
     - Transitive dependency pulled in by CDS
   * - org.springframework:spring-web:5.3.25
     - 10
     - | policy/api (T)
       | policy/pap (T)
       | policy/clamp (T)
       | policy/gui (T)
     - Transitive dependency pulled in by Spring/Springboot
   * - org.springframework:spring-webmvc:5.3.25
     - 10
     - | policy/api (T)
       | policy/pap (T)
       | policy/clamp (T)
       | policy/gui (T)
     - Transitive dependency pulled in by Spring/Springboot
   * - org.springframework.boot:spring-boot-actuator-autoconfigure:2.7.8
     - 10
     - | policy/api (T)
       | policy/pap (T)
       | policy/clamp (T)
       | policy/gui (T)
     - Transitive dependency pulled in by Spring/Springboot
   * - org.springframework.boot:spring-boot-autoconfigure:2.7.8
     - 10
     - | policy/models (T)
       | policy/api (T)
       | policy/pap (T)
       | policy/clamp (T)
       | policy/gui (T)
       | policy/apex-pdp (T)
       | policy/drools-applications (T)
     - Transitive dependency pulled in by Spring/Springboot
   * - org.springframework.security:spring-security-config:5.7.6
     - 10
     - | policy/api (T)
       | policy/pap (T)
       | policy/clamp (T)
     - Transitive dependency pulled in by Spring/Springboot
   * - org.springframework.security:spring-security-web:5.7.6
     - 10
     - | policy/api (T)
       | policy/pap (T)
       | policy/clamp (T)
     - Transitive dependency pulled in by Spring/Springboot
   * - org.webjars:jquery-ui:1.12.1
     - 6
     - | policy/gui (T)
     - Used by GUI for doing jquery queries

Workarounds
~~~~~~~~~~~
N/A

Security Notes
==============

Upgrading to Spring 6 and Springboot 3 is required to remove security vulnerabilities above. This change requries moving to Java 17.
This change will be done in the Montreal release of the Policy Framework. See `POLICY-4665 <https://lf-onap.atlassian.net/browse/POLICY-4665>`_.

Functional Improvements
=======================
| `POLICY-4395 <https://lf-onap.atlassian.net/browse/POLICY-4395>`_ - R12: Database related issues
|  `POLICY-4184 <https://lf-onap.atlassian.net/browse/POLICY-4184>`_ - ACM Support for MySql 8.x DB client interfaces
|  `POLICY-4358 <https://lf-onap.atlassian.net/browse/POLICY-4358>`_ - Support secured DB communications for CLAMP/ACM
| `POLICY-4401 <https://lf-onap.atlassian.net/browse/POLICY-4401>`_ - R12: Improvements specific to clamp
|  `POLICY-4282 <https://lf-onap.atlassian.net/browse/POLICY-4282>`_ - Test and Verification of ACM State Management
|  `POLICY-4330 <https://lf-onap.atlassian.net/browse/POLICY-4330>`_ - Add Prometheus metric messages for ACM
|  `POLICY-4413 <https://lf-onap.atlassian.net/browse/POLICY-4413>`_ - Refactor the state machines in CLAMP ACM-R and the Participant Intermediary
|  `POLICY-4418 <https://lf-onap.atlassian.net/browse/POLICY-4418>`_ - Remove old implementation of statistics in ACM
|  `POLICY-4458 <https://lf-onap.atlassian.net/browse/POLICY-4458>`_ - Create a Participant for A1-PMS 
|  `POLICY-4525 <https://lf-onap.atlassian.net/browse/POLICY-4525>`_ - Create a Participant for KServe
|  `POLICY-4563 <https://lf-onap.atlassian.net/browse/POLICY-4563>`_ - ACM manual and automation tests
|  `POLICY-4639 <https://lf-onap.atlassian.net/browse/POLICY-4639>`_ - UseState and OperationalState support in ACM

Necessary Improvements and Bug Fixes
====================================

Necessary Improvements
~~~~~~~~~~~~~~~~~~~~~~
| `POLICY-4122 <https://lf-onap.atlassian.net/browse/POLICY-4122>`_ - R12: Refactoring and Removal of Unused Code
|  `POLICY-4138 <https://lf-onap.atlassian.net/browse/POLICY-4138>`_ - Transfer the API handling from the clamp-backend microservice to another microservice
|  `POLICY-4139 <https://lf-onap.atlassian.net/browse/POLICY-4139>`_ - Remove the clamp-backend microservice
|  `POLICY-4140 <https://lf-onap.atlassian.net/browse/POLICY-4140>`_ - Ensure that all unit tests and automated integration and S3P tests still pass when the unused code is removed
|  `POLICY-4157 <https://lf-onap.atlassian.net/browse/POLICY-4157>`_ - Investigation story For Server-Client in PF
| `POLICY-4123 <https://lf-onap.atlassian.net/browse/POLICY-4123>`_ - R12: OpenAPI Adaption and Swagger Cleanup
|  `POLICY-3368 <https://lf-onap.atlassian.net/browse/POLICY-3368>`_ - Revise Rest API conventions and structure
|  `POLICY-3465 <https://lf-onap.atlassian.net/browse/POLICY-3465>`_ - Upgrade Swagger to io.swagger.core.v3
|  `POLICY-4143 <https://lf-onap.atlassian.net/browse/POLICY-4143>`_ - Generate Contract Testing stubs from OpenAPI specifications
|  `POLICY-4144 <https://lf-onap.atlassian.net/browse/POLICY-4144>`_ - Ensure that all unit tests and automated integration and S3P tests still pass when the OpenAPI approach is reversed
|  `POLICY-4158 <https://lf-onap.atlassian.net/browse/POLICY-4158>`_ - Open API Specifications as a Source Artifacts ACM
|  `POLICY-4159 <https://lf-onap.atlassian.net/browse/POLICY-4159>`_ - Maven build for OpenAPI Interface Generation
|  `POLICY-4160 <https://lf-onap.atlassian.net/browse/POLICY-4160>`_ - Rest endpoint implementation code Acm
|  `POLICY-4162 <https://lf-onap.atlassian.net/browse/POLICY-4162>`_ - Spike to understand OpenAPI Adaption
|  `POLICY-4404 <https://lf-onap.atlassian.net/browse/POLICY-4404>`_ - Remove SpringFox from Policy Framework
|  `POLICY-4448 <https://lf-onap.atlassian.net/browse/POLICY-4448>`_ - Rest endpoint implementation code Api and Pap
| `POLICY-4124 <https://lf-onap.atlassian.net/browse/POLICY-4124>`_ - R12: Add metrics to measure SLAs
|  `POLICY-4145 <https://lf-onap.atlassian.net/browse/POLICY-4145>`_ - Enable Observability and Performance Management
|  `POLICY-4147 <https://lf-onap.atlassian.net/browse/POLICY-4147>`_ - Add Prometheus counters for measuring APEX PDP performance SLAs
|  `POLICY-4148 <https://lf-onap.atlassian.net/browse/POLICY-4148>`_ - Check counter names for consistency
|  `POLICY-4149 <https://lf-onap.atlassian.net/browse/POLICY-4149>`_ - Verify that the counters are being produced
|  `POLICY-4165 <https://lf-onap.atlassian.net/browse/POLICY-4165>`_ - SLAs from Global Requirements
|  `POLICY-4469 <https://lf-onap.atlassian.net/browse/POLICY-4469>`_ - SLAs on REST Interfaces for Async Requests
| `POLICY-4125 <https://lf-onap.atlassian.net/browse/POLICY-4125>`_ - R12: New Test Development
|  `POLICY-4150 <https://lf-onap.atlassian.net/browse/POLICY-4150>`_ - Add the tests to the automated test suite in the Policy Framework
|  `POLICY-4151 <https://lf-onap.atlassian.net/browse/POLICY-4151>`_ - Add tests that check SLA compliance
|  `POLICY-4152 <https://lf-onap.atlassian.net/browse/POLICY-4152>`_ - Execute the new tests
|  `POLICY-4164 <https://lf-onap.atlassian.net/browse/POLICY-4164>`_ - Verify SLAs on Policy Execution in PDPs
|  `POLICY-4571 <https://lf-onap.atlassian.net/browse/POLICY-4571>`_ - S3P Test to check multiple PDP registration
|  `POLICY-4655 <https://lf-onap.atlassian.net/browse/POLICY-4655>`_ - Remove k8s based csit from jenkins
| `POLICY-4126 <https://lf-onap.atlassian.net/browse/POLICY-4126>`_ - R12: Improve Automated Testing and Policy Framework S3P Tests
|  `POLICY-4111 <https://lf-onap.atlassian.net/browse/POLICY-4111>`_ - S3P testing of APEX-PDP prometheus metrics
|  `POLICY-4153 <https://lf-onap.atlassian.net/browse/POLICY-4153>`_ - Ensure reports on SLA compliance are generated by test execution
|  `POLICY-4154 <https://lf-onap.atlassian.net/browse/POLICY-4154>`_ - Write a suite of automated contract tests.
|  `POLICY-4155 <https://lf-onap.atlassian.net/browse/POLICY-4155>`_ - Add the tests to the automated test suite in the Policy Framework
|  `POLICY-4156 <https://lf-onap.atlassian.net/browse/POLICY-4156>`_ - Automate the current S3P test suites in the Policy Framework
|  `POLICY-4417 <https://lf-onap.atlassian.net/browse/POLICY-4417>`_ - Support Policy CSIT tests in kubernetes environment with helm chart
|  `POLICY-4501 <https://lf-onap.atlassian.net/browse/POLICY-4501>`_ - Add ACM demo service template example in clamp
| `POLICY-4127 <https://lf-onap.atlassian.net/browse/POLICY-4127>`_ - R12: Enhance Policy Framework Documentation
|  `POLICY-4581 <https://lf-onap.atlassian.net/browse/POLICY-4581>`_ - Policy Offered APIs
|  `POLICY-4583 <https://lf-onap.atlassian.net/browse/POLICY-4583>`_ - Update Policy Platform Development Tools documentation
|  `POLICY-4586 <https://lf-onap.atlassian.net/browse/POLICY-4586>`_ - Review and update the ACM design documentation
|  `POLICY-4587 <https://lf-onap.atlassian.net/browse/POLICY-4587>`_ - Write documentation for Composition and participant development in ACM
| `POLICY-4396 <https://lf-onap.atlassian.net/browse/POLICY-4396>`_ - R12: Improvements specific to apex-pdp
|  `POLICY-4411 <https://lf-onap.atlassian.net/browse/POLICY-4411>`_ - Make apex-pdp dockerfile consistent
|  `POLICY-4460 <https://lf-onap.atlassian.net/browse/POLICY-4460>`_ - Add documentation for KafkaAvroSerializer support in apex-pdp
| `POLICY-4397 <https://lf-onap.atlassian.net/browse/POLICY-4397>`_ - R12: Improvements specific to xacml-pdp
|  `POLICY-4218 <https://lf-onap.atlassian.net/browse/POLICY-4218>`_ - Add handling of references in the XACML-PDP Tutorial code to the release scripts
| `POLICY-4398 <https://lf-onap.atlassian.net/browse/POLICY-4398>`_ - R12: Improvements specific to drools-pdp and drools-applications
|  `POLICY-4405 <https://lf-onap.atlassian.net/browse/POLICY-4405>`_ - Mitigate vulnerable dependencies in drools-pdp
| `POLICY-4399 <https://lf-onap.atlassian.net/browse/POLICY-4399>`_ - R12: Improvements to api/pap and policy handling
|  `POLICY-4451 <https://lf-onap.atlassian.net/browse/POLICY-4451>`_ - Policy PAP hard codes topic names
|  `POLICY-4455 <https://lf-onap.atlassian.net/browse/POLICY-4455>`_ - Make topics in PAP configurable
|  `POLICY-4463 <https://lf-onap.atlassian.net/browse/POLICY-4463>`_ - Fix pap csit with topics names
| `POLICY-4407 <https://lf-onap.atlassian.net/browse/POLICY-4407>`_ - R12: Software (non functional) improvements
|  `POLICY-4360 <https://lf-onap.atlassian.net/browse/POLICY-4360>`_ - Fix grafana compose 
|  `POLICY-4466 <https://lf-onap.atlassian.net/browse/POLICY-4466>`_ - Move duplicate POM config for git-commit-id-maven-plugin to policy/parent
|  `POLICY-4471 <https://lf-onap.atlassian.net/browse/POLICY-4471>`_ - Check and repair CSIT jobs
|  `POLICY-4474 <https://lf-onap.atlassian.net/browse/POLICY-4474>`_ - Ensure code coverage in all components is over 80%
|  `POLICY-4482 <https://lf-onap.atlassian.net/browse/POLICY-4482>`_ - Mitigate Vulnerabilities in Dependencies of Policy Components
|  `POLICY-4484 <https://lf-onap.atlassian.net/browse/POLICY-4484>`_ - Perform Interim Release of Policy Framework for London
|  `POLICY-4536 <https://lf-onap.atlassian.net/browse/POLICY-4536>`_ - Fix Sonar issues in PF components
|  `POLICY-4547 <https://lf-onap.atlassian.net/browse/POLICY-4547>`_ - Fix issue in StartAndStop Activator Test
|  `POLICY-4549 <https://lf-onap.atlassian.net/browse/POLICY-4549>`_ - Improve MariaDB sqls for db-migrator
|  `POLICY-4558 <https://lf-onap.atlassian.net/browse/POLICY-4558>`_ - Remove Integration Docker base images from Policy Framework base images
|  `POLICY-4570 <https://lf-onap.atlassian.net/browse/POLICY-4570>`_ - Policy Framework Interim Release
|  `POLICY-4578 <https://lf-onap.atlassian.net/browse/POLICY-4578>`_ - Update vulnerabilities in Policy Components
|  `POLICY-4628 <https://lf-onap.atlassian.net/browse/POLICY-4628>`_ - Update sdc-distribution-client to 2.0.1
|  `POLICY-4638 <https://lf-onap.atlassian.net/browse/POLICY-4638>`_ - Restructure policy-gui
|  `POLICY-4648 <https://lf-onap.atlassian.net/browse/POLICY-4648>`_ - Release images for M4
|  `POLICY-4680 <https://lf-onap.atlassian.net/browse/POLICY-4680>`_ - Pin versions of python libraries in csit configuration
| `REQ-439 <https://lf-onap.atlassian.net/browse/REQ-439>`_ - Continuation of Package Upgrades in Direct Dependencies
|  `POLICY-4472 <https://lf-onap.atlassian.net/browse/POLICY-4472>`_ - Packages Upgrades in Direct Dependencies for London Release

Bug Fixes
~~~~~~~~~
| `POLICY-4649 <https://lf-onap.atlassian.net/browse/POLICY-4649>`_ - Fix postgres script syntax errors 
| `POLICY-4625 <https://lf-onap.atlassian.net/browse/POLICY-4625>`_ - Participant primed status is not updated correctly in the runtime 
| `POLICY-4623 <https://lf-onap.atlassian.net/browse/POLICY-4623>`_ - Fix Anchor installing-or-upgrading-policy in docs
| `POLICY-4576 <https://lf-onap.atlassian.net/browse/POLICY-4576>`_ - Omission in release script to update oom images
| `POLICY-4575 <https://lf-onap.atlassian.net/browse/POLICY-4575>`_ - Fix ClassCastException in ACM
| `POLICY-4562 <https://lf-onap.atlassian.net/browse/POLICY-4562>`_ - Sonar hotspot Interrupted Exception
| `POLICY-4561 <https://lf-onap.atlassian.net/browse/POLICY-4561>`_ - Fix UNDEPLOY transition in policyParticipant in ACM
| `POLICY-4560 <https://lf-onap.atlassian.net/browse/POLICY-4560>`_ - Fix participantHtml issue with multi instances in ACM
| `POLICY-4537 <https://lf-onap.atlassian.net/browse/POLICY-4537>`_ - Policy DB scripts are bound to fixed MariaDB version
| `POLICY-4527 <https://lf-onap.atlassian.net/browse/POLICY-4527>`_ - Galera jobs must use repositoryGenerator quitQuit images 
| `POLICY-4491 <https://lf-onap.atlassian.net/browse/POLICY-4491>`_ - Fix PAP CSIT intermittent failure
| `POLICY-4490 <https://lf-onap.atlassian.net/browse/POLICY-4490>`_ - Disable ACM CSITs due to ongoing work
| `POLICY-4486 <https://lf-onap.atlassian.net/browse/POLICY-4486>`_ - Fix copy contructor in DocToscaServiceTemplate in ACM
| `POLICY-4473 <https://lf-onap.atlassian.net/browse/POLICY-4473>`_ - Clamp ACM dockersuse profile not working
| `POLICY-4429 <https://lf-onap.atlassian.net/browse/POLICY-4429>`_ - PDP-X guard table creation script problems with = in password
| `POLICY-4410 <https://lf-onap.atlassian.net/browse/POLICY-4410>`_ - Fix ACM stability and performance jmx configuration for random failures
| `POLICY-4381 <https://lf-onap.atlassian.net/browse/POLICY-4381>`_ - The REST path of ACM endpoints is not configurable via Spring properties

References
==========

For more information on the ONAP London release, please see:

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
..      * * *     KOHN       * * *
..      ==========================

Version: 11.0.0
---------------

:Release Date: 2022-11-20 (Kohn Release)

Artifacts released:

.. list-table::
   :widths: 15 10 10
   :header-rows: 1

   * - Repository
     - Java Artifact
     - Docker Image (if applicable)
   * - policy/parent
     - 3.6.1
     - N/A
   * - policy/docker
     - 2.5.1
     - | policy-jre-alpine
       | policy-jdk-alpine
       | policy-db-migrator
   * - policy/common
     - 1.11.1
     - N/A
   * - policy/models
     - 2.7.2
     - N/A
   * - policy/api
     - 2.7.2
     - policy-api
   * - policy/pap
     - 2.7.2
     - policy-pap
   * - policy/apex-pdp
     - 2.8.2
     - policy-apex-pdp
   * - policy/drools-pdp
     - 1.11.2
     - policy-drools
   * - policy/xacml-pdp
     - 2.7.2
     - policy-xacml-pdp
   * - policy/distribution
     - 2.8.2
     - policy-distribution
   * - policy/clamp
     - 6.3.2
     - | policy-clamp-ac-pf-ppnt
       | policy-clamp-ac-k8s-ppnt
       | policy-clamp-ac-http-ppnt
       | policy-clamp-runtime-acm'
   * - policy/gui
     - 2.3.2
     - policy-gui
   * - policy/drools-applications
     - 1.11.2
     - policy-pdpd-cl

Key Updates
===========

* Support for O1 and A1 Policy Payloads in the 5G SON use Case

  The 5G SON policy is updated to allow O1 and A1 Policy payloads to be passed to SDN-R. Now, policies can pass O1 and
  A1 Policy payloads.

  See:
   - `REQ-1212 <https://lf-onap.atlassian.net/browse/REQ-1212>`_ - 5G SON use case enhancements for Kohn release
   - `POLICY-4108 <https://lf-onap.atlassian.net/browse/POLICY-4108>`_ Control Loop Policy for A1-based action for SON
     Use Case


* Native Kafka messaging bewtween Policy Framework components

  The Policy Framework can now be configured to use Kafka for asynchronous communication between PAP and PDPs and
  between CLAMP ACM Runtime and Participants. Kafka messaging is an alternative to using DMaaP MR for asynchronous
  messaging. The Policy Framework components are configured to use either DMaaP or Kafka messaging, with DMaaP
  being the default. This change is supported by APEX-PDP in this release and will be supported DROOLS-PDP and XACML-PDP
  in future releases.

  See:
   - `POLICY-4121  <https://lf-onap.atlassian.net/browse/POLICY-4121>`_ - R11: DMaaP and Kafka updates

* Support for Secured Database Communication

  Database communiction with MariaDB, MySql, or PostgreSQL can be configured to be secure. Secure database communication
  is introduced for API, PAP, DROOLS-PDP and XACML-PDP. Support for secure database communication will be introduced in
  CLAMP ACM in a future release.

  See:
   - `POLICY-4176  <https://lf-onap.atlassian.net/browse/POLICY-4176>`_ - Support Secured Database Connections

* Support for MySql 8

  The Policy Framework can use MySql 8 for persistence in addition to MariaDb and Postgres. Interoperability with MySql
  8 has been added for DB-MIGRATOR, API, PAP, DROOLS-PDP, XACML-PDP, and CLAM ACM.

  See:
   - `POLICY-4314  <https://lf-onap.atlassian.net/browse/POLICY-4314>`_ - Support for MySql 8.x DB client interfaces

* Support for Service Mesh

  All Policy Framework components and images support service mesh and are service mesh compatible. The OOM charts for
  all Policy Framework components have been updated to supprot configuration for Service Mesh. In addition, some minor
  bugs in startup scripts were fixed to allow HTTP or HTTPS to be configured on components.

* XACML-PDP improvements

  - Support for XACML 3.1 introduced
  - Exposure of application level metrics
  - Support for Postgres database as well as MariaDB
  - Support for DCAE TCAGEN2 monitoring app changes
  - Logging to standard output
  - XACML tutorial updated and improved

  See:
   - `POLICY-4049  <https://lf-onap.atlassian.net/browse/POLICY-4049>`_ - R11: Improvements specific to xacml-pdp

* DROOLS-PDP and DROOLS-Applications improvements

  - Latest Drools libraries supported
  - JDBC pooling libraries upgraded

  See:
   - `POLICY-4050  <https://lf-onap.atlassian.net/browse/POLICY-4050>`_ - R11: Improvements specific to drools-pdp and drools-applications

* APEX-PDP Improvements

   - Support for event definitions in JSON as well as AVRO is added
   - Support for Metadata Set generation from the APEX CLI editor
   - Support for deserialization of messages encoded in Avro carried over Kafka

  See:
   - `POLICY-4048  <https://lf-onap.atlassian.net/browse/POLICY-4048>`_ - R11: Improvements specific to apex-pdp

* Policy-Distribution Improvements

   - Configuration added to allow distribution of CLAMP ACM compositions
   - Policy distribution re-synchs if SDC is reinstalled

   See:
    - `POLICY-4052  <https://lf-onap.atlassian.net/browse/POLICY-4052>`_ - R11: Improvements to distribution

* CLAMP Improvements

   - Instance properties can be edited
   - Helm repository can be configured in the Kubernetes participant

  See:
   - `POLICY-4053  <https://lf-onap.atlassian.net/browse/POLICY-4053>`_ - R11: Improvements specific to clamp

* System Attribute Improvements
    - Demo Grafana dashboards available for policy framework components
    - All parameters in Helm Charts have default values
    - Springboot dependency handling improved in policy-parent
    - CSITs amended to use HTTP rather than HTTPS and to use released image versions from Nexus when snapshot image
      versions are not available
    - Updates to database drivers to latest versions

Known Limitations, Issues and Workarounds
=========================================

System Limitations
~~~~~~~~~~~~~~~~~~
N/A

Known Vulnerabilities
~~~~~~~~~~~~~~~~~~~~~
.. list-table::
   :widths: 8 3 5 15
   :header-rows: 1

   * - Dependency
     - Security Threat Level
     - Policy Framework Components
     - Comment
   * - io.grpc:grpc-core:1.25.0
     - 6
     - | policy/models
       | policy/apex-pdp
     - Transitive dependency pulled in by the CDS project
   * - io.springfox:springfox-swagger-ui:3.0.0
     - 6
     - | policy/api
       | policy/pap
       | policy/clamp
     - Dependency used to generate Swagger files from annotations
   * - io.springfox:springfox-swagger2:3.0.0
     - 6
     - | policy/api
       | policy/pap
       | policy/clamp
     - Dependency used to generate Swagger files from annotations
   * - io.projectreactor.netty:reactor-netty-core:1.0.19
     - 6
     - | policy/clamp
     - TBC
   * - io.projectreactor.netty:reactor-netty-http:1.0.19
     - 6
     - | policy/clamp
     - TBC
   * - org.webjars jquery-ui 1.12.1
     - 6
     - | policy/gui
     - TBC
   * - com.thoughtworks.xstream:xstream:1.4.17
     - 10
     - | policy/drools-pdp
     - Pulled in by the Drools rule engine
   * - org.apache.maven:maven-compat:3.3.9
     - 10
     - | policy/drools-pdp
     - Pulled in by the Drools rule engine
   * - org.apache.maven:maven-core:3.3.9
     - 10
     - | policy/drools-pdp
     - Pulled in by the Drools rule engine
   * - org.apache.maven:maven-settings:3.3.9
     - 10
     - | policy/drools-pdp
     - Pulled in by the Drools rule engine
   * - org.jsoup:jsoup:1.7.2
     - 10
     - | policy/drools-pdp
     - Pulled in by the Drools rule engine

Workarounds
~~~~~~~~~~~
N/A

Security Notes
==============
.. list-table::
   :widths: 8 3 5 15
   :header-rows: 1

   * - Dependency
     - Security Threat Level
     - Policy Framework Components
     - Comment
   * - org.springframework:spring-web:5.3.22
     - 10
     - | policy/common
       | policy/api
       | policy/pap
       | policy/clamp
       | policy/gui
     - Threat only applies when serialising and deserialising Java Objects, which the Policy Framework does not do

Functional Improvements
=======================
| `POLICY-4108  <https://lf-onap.atlassian.net/browse/POLICY-4108>`_ - Control Loop Policy for A1-based action for SON Use Case
|  `POLICY-4356  <https://lf-onap.atlassian.net/browse/POLICY-4356>`_ - 5g son policy models changes
|  `POLICY-4357  <https://lf-onap.atlassian.net/browse/POLICY-4357>`_ - 5g son policy drools apps changes

| `POLICY-4121  <https://lf-onap.atlassian.net/browse/POLICY-4121>`_ - R11: DMaaP and Kafka updates
|  `POLICY-4131  <https://lf-onap.atlassian.net/browse/POLICY-4131>`_ - Update the DMaaP client in the Policy Framework common utility library.
|  `POLICY-4132  <https://lf-onap.atlassian.net/browse/POLICY-4132>`_ - Check that all asynchronous messaging continues to work with updated DMaaP client
|  `POLICY-4133  <https://lf-onap.atlassian.net/browse/POLICY-4133>`_ - Add a Kafka client in the Policy Framework common utility library.
|  `POLICY-4134  <https://lf-onap.atlassian.net/browse/POLICY-4134>`_ - Configure the Policy Framework components to use Kafka along with DMaaP
|  `POLICY-4135  <https://lf-onap.atlassian.net/browse/POLICY-4135>`_ - Check that all asynchronous messaging continues to work with Kafka messaging
|  `POLICY-4313  <https://lf-onap.atlassian.net/browse/POLICY-4313>`_ - Move kafka version management to policy/parent/integration
|  `POLICY-4204  <https://lf-onap.atlassian.net/browse/POLICY-4204>`_ - OOM experimentation using strimzi
|  `POLICY-4146  <https://lf-onap.atlassian.net/browse/POLICY-4146>`_ - Add Prometheus counters for measuring SLAs on ACM REST endpoints
|  `POLICY-4163  <https://lf-onap.atlassian.net/browse/POLICY-4163>`_ - SLAs on REST Interfaces
|  `POLICY-4166  <https://lf-onap.atlassian.net/browse/POLICY-4166>`_ - Spike to understand metrics to measure SLAs
|  `POLICY-4220  <https://lf-onap.atlassian.net/browse/POLICY-4220>`_ - CSIT does not display logs for some containers
|  `POLICY-4086  <https://lf-onap.atlassian.net/browse/POLICY-4086>`_ - Improve CSIT to use proper currentInstanceCount value in PdpGroups
|  `POLICY-4338  <https://lf-onap.atlassian.net/browse/POLICY-4338>`_ - Convert CSITs to use HTTP rather than HTTPS
|  `POLICY-4167  <https://lf-onap.atlassian.net/browse/POLICY-4167>`_ - Add build instruction in readme

| `POLICY-4120  <https://lf-onap.atlassian.net/browse/POLICY-4120>`_ - R11: SUSE flavoured images in the Policy Framework
|  `POLICY-4128  <https://lf-onap.atlassian.net/browse/POLICY-4128>`_ - Create an OpenSuse docker file equivalent to the existing Alpine docker file for each image in the Policy Framework
|  `POLICY-4129  <https://lf-onap.atlassian.net/browse/POLICY-4129>`_ - Add a build profile to each repo build to trigger generation of Suse flavoured images
|  `POLICY-4130  <https://lf-onap.atlassian.net/browse/POLICY-4130>`_ - Add OCI Image spec labels to both Alpine and OpenSuse docker files
|  `POLICY-4208  <https://lf-onap.atlassian.net/browse/POLICY-4208>`_ - Reduce size of docker images
|  `POLICY-4278  <https://lf-onap.atlassian.net/browse/POLICY-4278>`_ - Upgrade OpenSuse to version 15.4
|  `POLICY-4334  <https://lf-onap.atlassian.net/browse/POLICY-4334>`_ - Allow setting external dockerfile

| `POLICY-3642  <https://lf-onap.atlassian.net/browse/POLICY-3642>`_ - R11: Database and TOSCA related issues
|  `POLICY-1749  <https://lf-onap.atlassian.net/browse/POLICY-1749>`_ - Resolve specification of policy type versions in policies in TOSCA
|  `POLICY-2540  <https://lf-onap.atlassian.net/browse/POLICY-2540>`_ - Proper handling of data types in policy-models and policy-api
|  `POLICY-3236  <https://lf-onap.atlassian.net/browse/POLICY-3236>`_ - Adjust flexibility of Tosca Service Template Handling
|  `POLICY-4067  <https://lf-onap.atlassian.net/browse/POLICY-4067>`_ - Fetch all versions of a policyType API returning only the latest version
|  `POLICY-4176  <https://lf-onap.atlassian.net/browse/POLICY-4176>`_ - Support Secured Database Connections
|  `POLICY-4314  <https://lf-onap.atlassian.net/browse/POLICY-4314>`_ - Support for MySql 8.x DB client interfaces
|  `POLICY-3489  <https://lf-onap.atlassian.net/browse/POLICY-3489>`_ - Add script to load default data into tables using db-migrator
|  `POLICY-3585  <https://lf-onap.atlassian.net/browse/POLICY-3585>`_ - TOSCA Handling issues
|  `POLICY-4097  <https://lf-onap.atlassian.net/browse/POLICY-4097>`_ - Validate policy-api redundancy with at least 2 pods using J release
|  `POLICY-4098  <https://lf-onap.atlassian.net/browse/POLICY-4098>`_ - Validate policy-pap redundancy with at least 2 pods using J release
|  `POLICY-4099  <https://lf-onap.atlassian.net/browse/POLICY-4099>`_ - Spike to determine the work in apex-pdp for redundancy support
|  `POLICY-4100  <https://lf-onap.atlassian.net/browse/POLICY-4100>`_ - Spike to determine the work in drools-pdp for redundancy support

| `POLICY-4048  <https://lf-onap.atlassian.net/browse/POLICY-4048>`_ - R11: Improvements specific to apex-pdp
|  `POLICY-4290  <https://lf-onap.atlassian.net/browse/POLICY-4290>`_ - Support JSON based event schema in apex-pdp
|  `POLICY-3446  <https://lf-onap.atlassian.net/browse/POLICY-3446>`_ - Change apex-pdp to use BeanValidator
|  `POLICY-3810  <https://lf-onap.atlassian.net/browse/POLICY-3810>`_ - Fix sonar issues in apex-pdp
|  `POLICY-4084  <https://lf-onap.atlassian.net/browse/POLICY-4084>`_ - Apex cli editor should generate policies with metadataSet
|  `POLICY-4285  <https://lf-onap.atlassian.net/browse/POLICY-4285>`_ - Remove debian packaging from apex-pdp build
|  `POLICY-4324  <https://lf-onap.atlassian.net/browse/POLICY-4324>`_ - Fix Docker File for Apex MyFirstExample
|  `POLICY-4369  <https://lf-onap.atlassian.net/browse/POLICY-4369>`_ - Support KafkaAvroDeserializer in KafkaConsumer plugin of apex-pdp

| `POLICY-4049  <https://lf-onap.atlassian.net/browse/POLICY-4049>`_ - R11: Improvements specific to xacml-pdp
|  `POLICY-3762  <https://lf-onap.atlassian.net/browse/POLICY-3762>`_ - Expose application level metrics in xacml-pdp
|  `POLICY-4187  <https://lf-onap.atlassian.net/browse/POLICY-4187>`_ - Support postgresql in Xacml PDP
|  `POLICY-4317  <https://lf-onap.atlassian.net/browse/POLICY-4317>`_ - PAP, PDP-X: Support DCAE tcagen2 monitoring app changes
|  `POLICY-3495  <https://lf-onap.atlassian.net/browse/POLICY-3495>`_ - Xacml-pdp should log to stdout
|  `POLICY-4171  <https://lf-onap.atlassian.net/browse/POLICY-4171>`_ - Update Docker Tag related configurations in XACML Tutorial code
|  `POLICY-4275  <https://lf-onap.atlassian.net/browse/POLICY-4275>`_ - Upgrade XACML PDP to use XACML 3.1 release

| `POLICY-4050  <https://lf-onap.atlassian.net/browse/POLICY-4050>`_ - R11: Improvements specific to drools-pdp and drools-applications
|  `POLICY-3960  <https://lf-onap.atlassian.net/browse/POLICY-3960>`_ - Add/update documents for application metrics support in drools-pdp
|  `POLICY-4177  <https://lf-onap.atlassian.net/browse/POLICY-4177>`_ - Support secured DB communications for PDP-D Core
|  `POLICY-4197  <https://lf-onap.atlassian.net/browse/POLICY-4197>`_ - PDP-D: thread dump upon detection of application stuck session
|  `POLICY-4213  <https://lf-onap.atlassian.net/browse/POLICY-4213>`_ - PDP-D APPS: Jenkins jobs started to fail basic builds
|  `POLICY-4281  <https://lf-onap.atlassian.net/browse/POLICY-4281>`_ - Upgrade JDBC pooling libraries in drools
|  `POLICY-4335  <https://lf-onap.atlassian.net/browse/POLICY-4335>`_ - PDP-D: Upgrade to the latest version of drools libraries

| `POLICY-4051  <https://lf-onap.atlassian.net/browse/POLICY-4051>`_ - R11: Improvements to api, pap and policy handling
|  `POLICY-3887  <https://lf-onap.atlassian.net/browse/POLICY-3887>`_ - Enhancement in enhanced policy health check
|  `POLICY-2874  <https://lf-onap.atlassian.net/browse/POLICY-2874>`_ - Investigate Policy-API S3P stability test results
|  `POLICY-4288  <https://lf-onap.atlassian.net/browse/POLICY-4288>`_ - Check PAP CSIT Undeploy test timeout

| `POLICY-4052  <https://lf-onap.atlassian.net/browse/POLICY-4052>`_ - R11: Improvements to distribution
|  `POLICY-4110  <https://lf-onap.atlassian.net/browse/POLICY-4110>`_ - Update configuration changes for distribution of ACM
|  `POLICY-2103  <https://lf-onap.atlassian.net/browse/POLICY-2103>`_ - policy/distribution may need to re-synch if SDC gets reinstalled

| `POLICY-4053  <https://lf-onap.atlassian.net/browse/POLICY-4053>`_ - R11: Improvements specific to clamp
|  `POLICY-4078  <https://lf-onap.atlassian.net/browse/POLICY-4078>`_ - Investigation of DB issue within Policy Clamp runtime
|  `POLICY-4341  <https://lf-onap.atlassian.net/browse/POLICY-4341>`_ - ACM Runtime pod fails to come-up referencing to wrong filepath
|  `POLICY-4365  <https://lf-onap.atlassian.net/browse/POLICY-4365>`_ - Increase code coverage in clamp
|  `POLICY-4094  <https://lf-onap.atlassian.net/browse/POLICY-4094>`_ - Add Edit functionality for instance properties in Policy GUI
|  `POLICY-4105  <https://lf-onap.atlassian.net/browse/POLICY-4105>`_ - Remove usage of jackson libraries from clamp runtime acm
|  `POLICY-4113  <https://lf-onap.atlassian.net/browse/POLICY-4113>`_ - Make the permitted helm repository protocol a configurable parameter in k8s participant
|  `POLICY-4224  <https://lf-onap.atlassian.net/browse/POLICY-4224>`_ - Clean up CLAMP Docker handling
|  `POLICY-4225  <https://lf-onap.atlassian.net/browse/POLICY-4225>`_ - Fix type version in all tosca_service_template
|  `POLICY-4229  <https://lf-onap.atlassian.net/browse/POLICY-4229>`_ - Fix type version in all tosca_service_template in parent documetation
|  `POLICY-4237  <https://lf-onap.atlassian.net/browse/POLICY-4237>`_ - Add override parameters for enabling protocol in k8s-ppnt helm chart
|  `POLICY-4240  <https://lf-onap.atlassian.net/browse/POLICY-4240>`_ - Update PMSH service template for ACM
|  `POLICY-4286  <https://lf-onap.atlassian.net/browse/POLICY-4286>`_ - Junk output in the docker build for kubernetes participant
|  `POLICY-4289  <https://lf-onap.atlassian.net/browse/POLICY-4289>`_ - Refactoring redundant spring libraries defined in clamp pom files
|  `POLICY-4371  <https://lf-onap.atlassian.net/browse/POLICY-4371>`_ - Remove policy-clamp-be from OOM deployment for Service Mesh
|  `POLICY-4382  <https://lf-onap.atlassian.net/browse/POLICY-4382>`_ - Update ACM document in ONAP doc for Kohn release

Necessary Improvements and Bug Fixes
====================================

Necessary Improvements
~~~~~~~~~~~~~~~~~~~~~~
| `POLICY-4045  <https://lf-onap.atlassian.net/browse/POLICY-4045>`_ - R11: Software (non functional) improvements
|  `POLICY-3967  <https://lf-onap.atlassian.net/browse/POLICY-3967>`_ - Create detailed grafana dashboards for each policy framework component
|  `POLICY-4168  <https://lf-onap.atlassian.net/browse/POLICY-4168>`_ - Security vulnerability when unzipping csar on distribution
|  `POLICY-4169  <https://lf-onap.atlassian.net/browse/POLICY-4169>`_ - Ensure all parameters in Helm Charts have default values
|  `POLICY-3860  <https://lf-onap.atlassian.net/browse/POLICY-3860>`_ - Analyze and improve spring boot dependencies management in PF components
|  `POLICY-4207  <https://lf-onap.atlassian.net/browse/POLICY-4207>`_ - Remove Jenkins jobs on Guilin branches
|  `POLICY-4228  <https://lf-onap.atlassian.net/browse/POLICY-4228>`_ - Add Ramesh Murugan Iyer as a committer
|  `POLICY-4230  <https://lf-onap.atlassian.net/browse/POLICY-4230>`_ - Update Weekly Meetings with status from daily scrums
|  `POLICY-4234  <https://lf-onap.atlassian.net/browse/POLICY-4234>`_ - Fix CSITs on Honolulu/Istanbul/Jakarta branches
|  `POLICY-4242  <https://lf-onap.atlassian.net/browse/POLICY-4242>`_ - PACKAGES UPGRADES IN DIRECT DEPENDENCIES FOR KOHN
|  `POLICY-4280  <https://lf-onap.atlassian.net/browse/POLICY-4280>`_ - Upgrade mariadb driver to latest 2.x version in PDP-D, and APPS
|  `POLICY-4287  <https://lf-onap.atlassian.net/browse/POLICY-4287>`_ - Update Docker Builds to allow for multiple architecture Docker Fille generation
|  `POLICY-4308  <https://lf-onap.atlassian.net/browse/POLICY-4308>`_ - Unmaintained Repos
|  `POLICY-4354  <https://lf-onap.atlassian.net/browse/POLICY-4354>`_ - Update INFO.yaml fine on all repos
|  `POLICY-4393  <https://lf-onap.atlassian.net/browse/POLICY-4393>`_ - Update dependencies to remove security vulnerabilities

| `POLICY-4046  <https://lf-onap.atlassian.net/browse/POLICY-4046>`_ - R11: Address technical debt left over from Previous Release
|  `POLICY-4093  <https://lf-onap.atlassian.net/browse/POLICY-4093>`_ - Update spring vesion in oparent and remove override in policy/parent

Bug Fixes
~~~~~~~~~
| `POLICY-4170  <https://lf-onap.atlassian.net/browse/POLICY-4170>`_ - Fix k8s-ppnt cluster role binding name in OOM
| `POLICY-4186  <https://lf-onap.atlassian.net/browse/POLICY-4186>`_ - Wrong versions of policy related jar in policy-xacml-pdp latest image
| `POLICY-4226  <https://lf-onap.atlassian.net/browse/POLICY-4226>`_ - policy distribution cannot disable https to SDC
| `POLICY-4236  <https://lf-onap.atlassian.net/browse/POLICY-4236>`_ - K8s participant marks the deployment failed if the deployment is initiated with a delay
| `POLICY-4238  <https://lf-onap.atlassian.net/browse/POLICY-4238>`_ - CLAMP ACM docker image Java logging does not work
| `POLICY-4239  <https://lf-onap.atlassian.net/browse/POLICY-4239>`_ - ACM commissioning fails with 404 error when deployed in CSIT docker
| `POLICY-4241  <https://lf-onap.atlassian.net/browse/POLICY-4241>`_ - Participant update list in ACM is not populated with multiple AC elements
| `POLICY-4268  <https://lf-onap.atlassian.net/browse/POLICY-4268>`_ - Logging directory mismatch for policy OOM components
| `POLICY-4269  <https://lf-onap.atlassian.net/browse/POLICY-4269>`_ - Clamp Backend fails without AAF in Service Mesh
| `POLICY-4270  <https://lf-onap.atlassian.net/browse/POLICY-4270>`_ - CSIT fails while executing CLAMP ACM test cases
| `POLICY-4274  <https://lf-onap.atlassian.net/browse/POLICY-4274>`_ - XACML-PDP raw decision API serialization is incorrect
| `POLICY-4326  <https://lf-onap.atlassian.net/browse/POLICY-4326>`_ - Look into Policy-Distribution grafana chart for negative heap memory
| `POLICY-4331  <https://lf-onap.atlassian.net/browse/POLICY-4331>`_ - Policy-GUI Apex Broken Tests
| `POLICY-4339  <https://lf-onap.atlassian.net/browse/POLICY-4339>`_ - Clamp build fails in policy participant module while processing policies without topology template
| `POLICY-4351  <https://lf-onap.atlassian.net/browse/POLICY-4351>`_ - log of Element container is not visible at Standard Output
| `POLICY-4352  <https://lf-onap.atlassian.net/browse/POLICY-4352>`_ - Lob type from jpa entities casting wrongly on postgres
| `POLICY-4353  <https://lf-onap.atlassian.net/browse/POLICY-4353>`_ - JSON schema plugin is not working with multiple events mentioned in apex config with | separator
| `POLICY-4355  <https://lf-onap.atlassian.net/browse/POLICY-4355>`_ - PodStatus Validator is failing to check if the pod is running in K8sParticipant

References
==========

For more information on the ONAP Kohn release, please see:

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
..      * * *    JAKARTA     * * *
..      ==========================

Version: 10.0.0
---------------

:Release Date: 2022-05-12 (Jakarta Release)

Artifacts released:

.. list-table::
   :widths: 15 10 10
   :header-rows: 1

   * - Repository
     - Java Artifact
     - Docker Image (if applicable)
   * - policy/parent
     - 3.5.3
     - N/A
   * - policy/docker
     - 2.4.3
     - | policy-jre-alpine
       | policy-jdk-alpine
       | policy-db-migrator
   * - policy/common
     - 1.10.3
     - N/A
   * - policy/models
     - 2.6.3
     - N/A
   * - policy/api
     - 2.6.3
     - policy-api
   * - policy/pap
     - 2.6.3
     - policy-pap
   * - policy/apex-pdp
     - 2.7.3
     - policy-apex-pdp
   * - policy/drools-pdp
     - 1.10.3
     - policy-drools
   * - policy/xacml-pdp
     - 2.6.3
     - policy-xacml-pdp
   * - policy/distribution
     - 2.7.3
     - policy-distribution
   * - policy/clamp
     - 6.2.3
     - | policy-clamp-backend
       | policy-clamp-ac-pf-ppnt
       | policy-clamp-ac-k8s-ppnt
       | policy-clamp-ac-http-ppnt
       | policy-clamp-runtime-acm'
   * - policy/gui
     - 2.2.3
     - policy-gui
   * - policy/drools-applications
     - 1.10.3
     - policy-pdpd-cl

Key Updates
===========

* `REQ-994 <https://lf-onap.atlassian.net/browse/REQ-994>`_ - Control Loop in TOSCA LCM Improvement
  CLAMP (Control Loop Automation Management Platform) functionalities, moved to the Policy project in the Istanbul
  release, provides a Control Loop Lifecycle management architecture. A control Loop is a key concept for Automation
  and Assurance Use Cases and remains a top priority for ONAP as an automation platform butit is not the only possible
  composition of components that is possible to combine to deliver functionality.

  This work evolves the Control Loop LCM architecture to provide abstract Automation Composition
  Management (ACM) logic with a generic Automation Composition definition, isolating Composition logic logic from ONAP
  component logic. It elaborates APIs that allow integrate with other design systems as well as 3PP component integration.

  The current PMSH and TCS control loops are migrated to use an Automation Composition approach. Support for Automation
  Compositions in SDC is also introduced.

* Metadata Sets for Policy Types.

  A Metadata set allows a global set of metadata containing rules or global parameters that all instances of a certain
  policy type can use. Metadta sets are introduced in the Policy Framework in the Jakarta release. This means that
  different rule set implementations can be associated with a policy type, which can be used in appropriate situations.

* Introduction of Prometheus for monitoring Policy components so that necessary alerts can be easily triggered and
  possible outages can be avoided in production systems.

  * Expose application level metrics in policy components. An end user can plug in a prometheus instance and start
    listening to the metrics exposed by policy components and either raise alerts or show them on a Grafana dashboard
    for operations team to keep monitoring the health of the system.

  * Provide sample Grafana dashboards for policy metrics.

* Improve the policy/api and policy/pap readiness probes to handle database failures so that the policy/api and
  policy/pap kubernetes pods are marked ready only if the policy database pod is ready.

* Migration of Policy Framework components to Springboot to support easier handling, configuration and maintenance.
  The migrated components are policy/api, policy/pap, policy/clamp, and policy/gui.

* Enhanced healthchecks on drools pdp to report on stuck applications.  This together with enhanced liveness probes
  self-heals the unresponsive pod in such condition by restarting it.

* Drools PDP has been upgraded to the latest available stable version: 7.68.0.Final.

* Extend CDS actor model to decouple VNF handling from the vFirewall use case.

* Policy Framework Database Configurability. Some of the components in the Policy Framework can be configured to use
  any JDBC-compliant RDBMS and configuraiton files are supplied for the Postgres RDBMS. MariaDB remains the default
  RDBMS for the Policy Framework in ONAP. Further testing will be carried out using Postgres in Kohn and future
  releases.

* System Attribute Improvements
    - Transaction boundaries on REST calls are implemented per REST call on applications migrated to Spring (policy/api,
      policy/pap, and policy/clamp)
    - JDBC backend uses Spring and Hibernate rather than Eclipselink
    - All GUIs are now included in the policy/gui microservice
    - Documentation is retionalized and cleaned up, testing documentation is now complete
    - Scripts are added to make release of the Policy Framework easier

Known Limitations, Issues and Workarounds
=========================================

System Limitations
~~~~~~~~~~~~~~~~~~
N/A

Known Vulnerabilities
~~~~~~~~~~~~~~~~~~~~~
N/A

Workarounds
~~~~~~~~~~~
N/A

Security Notes
==============

| `POLICY-2744 <https://lf-onap.atlassian.net/browse/POLICY-2744>`_ - Use an account other than healthcheck in API and PAP components for provisioning of policies
| `POLICY-3815 <https://lf-onap.atlassian.net/browse/POLICY-3815>`_ - Use an account other than healthcheck in API and PAP components for provisioning of policies - OOM Charts
| `POLICY-3862 <https://lf-onap.atlassian.net/browse/POLICY-3862>`_ - Check all code for Log4J before version 2.15.0 and upgrade if necessary
| `POLICY-4085 <https://lf-onap.atlassian.net/browse/POLICY-4085>`_ - Remove usage of jackson libraries from clamp runtime


Functional Improvements
=======================
| `POLICY-1837 <https://lf-onap.atlassian.net/browse/POLICY-1837>`_ - Review transaction boundaries of models
| `POLICY-2715 <https://lf-onap.atlassian.net/browse/POLICY-2715>`_ - Allow underlying database to be configured: MariaDB or Postgres
| `POLICY-2952 <https://lf-onap.atlassian.net/browse/POLICY-2952>`_ - R10: TOSCA Control Loop Design Time
| `POLICY-2973 <https://lf-onap.atlassian.net/browse/POLICY-2973>`_ - Build interaction between SDC and Design Time Catalogue
| `POLICY-3034 <https://lf-onap.atlassian.net/browse/POLICY-3034>`_ - Support statistics in PDP-X
| `POLICY-3213 <https://lf-onap.atlassian.net/browse/POLICY-3213>`_ - Persistence Policy Models using JPA/JDBC/Hibernate/MariaDB
| `POLICY-3498 <https://lf-onap.atlassian.net/browse/POLICY-3498>`_ - Provide API to retrieve policies deployed since a given time
| `POLICY-3579 <https://lf-onap.atlassian.net/browse/POLICY-3579>`_ - End to End Demo of PMSH usecase
| `POLICY-3582 <https://lf-onap.atlassian.net/browse/POLICY-3582>`_ - Uber Story: Cover the full scope of LCM for Control Loops: Server Side
| `POLICY-3638 <https://lf-onap.atlassian.net/browse/POLICY-3638>`_ - Change policy-gui so that all GUIs work in the same jar/JVM
| `POLICY-3745 <https://lf-onap.atlassian.net/browse/POLICY-3745>`_ - PDP-D: Upgrade drools to the latest 7.x release
| `POLICY-3747 <https://lf-onap.atlassian.net/browse/POLICY-3747>`_ - Support Readiness and Liveness probes on Control loop helm charts
| `POLICY-3748 <https://lf-onap.atlassian.net/browse/POLICY-3748>`_ - Enable cluster admin role for k8s participant helm chart in OOM
| `POLICY-3750 <https://lf-onap.atlassian.net/browse/POLICY-3750>`_ - R10: Improve runtime monitoring capabilities in policy components
| `POLICY-3753 <https://lf-onap.atlassian.net/browse/POLICY-3753>`_ - Migrate policy-api component to spring boot
| `POLICY-3754 <https://lf-onap.atlassian.net/browse/POLICY-3754>`_ - Migrate policy-pap component to spring boot
| `POLICY-3755 <https://lf-onap.atlassian.net/browse/POLICY-3755>`_ - Create a list of application metrics to be exposed in policy framework components
| `POLICY-3756 <https://lf-onap.atlassian.net/browse/POLICY-3756>`_ - Expose application level metrics in policy-api
| `POLICY-3757 <https://lf-onap.atlassian.net/browse/POLICY-3757>`_ - Expose application level metrics in policy-pap
| `POLICY-3759 <https://lf-onap.atlassian.net/browse/POLICY-3759>`_ - Expose application level metrics in policy-distribution
| `POLICY-3760 <https://lf-onap.atlassian.net/browse/POLICY-3760>`_ - Expose application level metrics in apex-pdp
| `POLICY-3761 <https://lf-onap.atlassian.net/browse/POLICY-3761>`_ - Expose application level metrics in drools-pdp
| `POLICY-3763 <https://lf-onap.atlassian.net/browse/POLICY-3763>`_ - Improve policy-api & policy-pap readiness probes to handle db failures
| `POLICY-3777 <https://lf-onap.atlassian.net/browse/POLICY-3777>`_ - R10: Control Loop in TOSCA LCM improvement
| `POLICY-3781 <https://lf-onap.atlassian.net/browse/POLICY-3781>`_ - R10: Policy Framework Database Configurability
| `POLICY-3808 <https://lf-onap.atlassian.net/browse/POLICY-3808>`_ - Commission a Control Loop Type from a Control Loop Type package/service
| `POLICY-3816 <https://lf-onap.atlassian.net/browse/POLICY-3816>`_ - Support Policy Type Metadata Sets in Policy Framework
| `POLICY-3823 <https://lf-onap.atlassian.net/browse/POLICY-3823>`_ - Proof of concept of Controlloop design time with SDC
| `POLICY-3835 <https://lf-onap.atlassian.net/browse/POLICY-3835>`_ - Write scripts to make release of the Policy Framework easier
| `POLICY-3839 <https://lf-onap.atlassian.net/browse/POLICY-3839>`_ - Migrate controlloop runtime from Eclipselink to Hibernate
| `POLICY-3865 <https://lf-onap.atlassian.net/browse/POLICY-3865>`_ - PDP-D APPS: extend CDS actor VNF operations support
| `POLICY-3870 <https://lf-onap.atlassian.net/browse/POLICY-3870>`_ - Add Controlloop design-time components to SDC
| `POLICY-3886 <https://lf-onap.atlassian.net/browse/POLICY-3886>`_ - Create basic installation & setup for prometheus & grafana
| `POLICY-3889 <https://lf-onap.atlassian.net/browse/POLICY-3889>`_ - Implement TCS Control Loops using a TOSCA appraoch
| `POLICY-3892 <https://lf-onap.atlassian.net/browse/POLICY-3892>`_ - Create basic grafana dashboards for monitoring policy framework components
| `POLICY-3896 <https://lf-onap.atlassian.net/browse/POLICY-3896>`_ - Change Apex Editor to use Spring Boot
| `POLICY-3902 <https://lf-onap.atlassian.net/browse/POLICY-3902>`_ - Extend PDP-X statistics endpoint to support per application metrics
| `POLICY-3921 <https://lf-onap.atlassian.net/browse/POLICY-3921>`_ - Align TOSCA Control Loop with Automation Composition
| `POLICY-3938 <https://lf-onap.atlassian.net/browse/POLICY-3938>`_ - Rename CLAMP "TOSCA Control Loop" feature to CLAMP "Automation Composition Management"
| `POLICY-4040 <https://lf-onap.atlassian.net/browse/POLICY-4040>`_ - Enable prometheus monitoring on drools-pdp charts

Necessary Improvements and Bug Fixes
====================================

Necessary Improvements
~~~~~~~~~~~~~~~~~~~~~~
| `POLICY-1820 <https://lf-onap.atlassian.net/browse/POLICY-1820>`_ - Transfer APEX model to use policy-models
| `POLICY-2086 <https://lf-onap.atlassian.net/browse/POLICY-2086>`_ - Remove references to mariadb from resource files
| `POLICY-2587 <https://lf-onap.atlassian.net/browse/POLICY-2587>`_ - CLC target locking behavior needs to be by-passed for CLC to be effective
| `POLICY-2588 <https://lf-onap.atlassian.net/browse/POLICY-2588>`_ - Target Locking Implementations should be configurable
| `POLICY-2683 <https://lf-onap.atlassian.net/browse/POLICY-2683>`_ - REQ-443  improve its CII Badging score by improving input validation and documenting it in their CII Badging site.
| `POLICY-3076 <https://lf-onap.atlassian.net/browse/POLICY-3076>`_ - Improve code coverage in policy framework repos
| `POLICY-3259 <https://lf-onap.atlassian.net/browse/POLICY-3259>`_ - Components should not crash at start-up due to dmaap issues
| `POLICY-3269 <https://lf-onap.atlassian.net/browse/POLICY-3269>`_ - Allow policy to disable guard check in drools-apps
| `POLICY-3358 <https://lf-onap.atlassian.net/browse/POLICY-3358>`_ - Remove Clamp GUI from Clamp Repo
| `POLICY-3380 <https://lf-onap.atlassian.net/browse/POLICY-3380>`_ - Archive onap/clamp and remove any jenkins jobs
| `POLICY-3386 <https://lf-onap.atlassian.net/browse/POLICY-3386>`_ - PDP-D: better liveness checks to recover from stuck sessions
| `POLICY-3540 <https://lf-onap.atlassian.net/browse/POLICY-3540>`_ - Refactor Participant Interfaces and Tests
| `POLICY-3708 <https://lf-onap.atlassian.net/browse/POLICY-3708>`_ - Improve Documentation for Jakarta Release
| `POLICY-3710 <https://lf-onap.atlassian.net/browse/POLICY-3710>`_ - Tidy up the Policy Framework documentation
| `POLICY-3791 <https://lf-onap.atlassian.net/browse/POLICY-3791>`_ - sphinx-build warnings in policy parent docs
| `POLICY-3804 <https://lf-onap.atlassian.net/browse/POLICY-3804>`_ - Add gui-clamp coverage info to sonar
| `POLICY-3866 <https://lf-onap.atlassian.net/browse/POLICY-3866>`_ - Tidy up Policy Framework Documentation
| `POLICY-3885 <https://lf-onap.atlassian.net/browse/POLICY-3885>`_ - Document metadataSet usage in policy documentation
| `POLICY-3895 <https://lf-onap.atlassian.net/browse/POLICY-3895>`_ - Improve drools pdp and drools apps logging
| `POLICY-3920 <https://lf-onap.atlassian.net/browse/POLICY-3920>`_ - Write a User Guide for TOSCA Control Loops in CLAMP
| `POLICY-3927 <https://lf-onap.atlassian.net/browse/POLICY-3927>`_ - Remove Unused maven dependencies in apex-editor
| `POLICY-3928 <https://lf-onap.atlassian.net/browse/POLICY-3928>`_ - Remove Unused test resources in apex-editor
| `POLICY-3977 <https://lf-onap.atlassian.net/browse/POLICY-3977>`_ - PDP-D: enhanced healthchecks for monitoring subcomponents
| `POLICY-3979 <https://lf-onap.atlassian.net/browse/POLICY-3979>`_ - PDP-D + APPS: investigate configuration to use MySql instead of MariaDB

Bug Fixes
~~~~~~~~~
| `POLICY-3153 <https://lf-onap.atlassian.net/browse/POLICY-3153>`_ - Fix Db connection issues in TOSCA control loop
| `POLICY-3589 <https://lf-onap.atlassian.net/browse/POLICY-3589>`_ - Http participant unable to resolve Intermediary config during startup
| `POLICY-3743 <https://lf-onap.atlassian.net/browse/POLICY-3743>`_ - APEX-PDP RestClient reports failure when response code!=200
| `POLICY-3749 <https://lf-onap.atlassian.net/browse/POLICY-3749>`_ - Drools CSITs failing due to version related problem
| `POLICY-3780 <https://lf-onap.atlassian.net/browse/POLICY-3780>`_ - Update endpoints in xacml-pdp jmx files
| `POLICY-3794 <https://lf-onap.atlassian.net/browse/POLICY-3794>`_ - Cannot create a new APEX policy on Policy Editor
| `POLICY-3831 <https://lf-onap.atlassian.net/browse/POLICY-3831>`_ - Camel Integration Tests Failing
| `POLICY-3871 <https://lf-onap.atlassian.net/browse/POLICY-3871>`_ - Fix issues in existing entity classes in policy-models
| `POLICY-3893 <https://lf-onap.atlassian.net/browse/POLICY-3893>`_ - apex-pdp intermittent error in build
| `POLICY-3897 <https://lf-onap.atlassian.net/browse/POLICY-3897>`_ - Fix issue with usage of GeneratedValue in PfGeneratedIdKey
| `POLICY-3905 <https://lf-onap.atlassian.net/browse/POLICY-3905>`_ - drools pdp merge job failing
| `POLICY-3913 <https://lf-onap.atlassian.net/browse/POLICY-3913>`_ - Fix issue where some metrics are lost in spring boot
| `POLICY-3914 <https://lf-onap.atlassian.net/browse/POLICY-3914>`_ - Fix spring configuration for pap csit
| `POLICY-3929 <https://lf-onap.atlassian.net/browse/POLICY-3929>`_ - Race condition in apex-editor model upload
| `POLICY-3933 <https://lf-onap.atlassian.net/browse/POLICY-3933>`_ - CLAMP CSIT failing with HTTP 401 unauthorized for URL error
| `POLICY-3978 <https://lf-onap.atlassian.net/browse/POLICY-3978>`_ - Changing default append on instance name
| `POLICY-3983 <https://lf-onap.atlassian.net/browse/POLICY-3983>`_ - Policy-API is not using the mounted logback.xml file
| `POLICY-4030 <https://lf-onap.atlassian.net/browse/POLICY-4030>`_ - PAP/API healthcheck response code not in line with the actual health report
| `POLICY-4039 <https://lf-onap.atlassian.net/browse/POLICY-4039>`_ - Fix configuration issues causing automation composition issues
| `POLICY-4041 <https://lf-onap.atlassian.net/browse/POLICY-4041>`_ - Duplicate log entries in policy-gui
| `POLICY-4043 <https://lf-onap.atlassian.net/browse/POLICY-4043>`_ - Batch deploy/undeploy operations incrementing corresponding apex counter by only 1
| `POLICY-4044 <https://lf-onap.atlassian.net/browse/POLICY-4044>`_ - APEX-PDP engine metrics remain 0 even after execution of events
| `POLICY-4068 <https://lf-onap.atlassian.net/browse/POLICY-4068>`_ - PAP consolidated healthcheck returning report with empty url for PAP
| `POLICY-4087 <https://lf-onap.atlassian.net/browse/POLICY-4087>`_ - Inconsistent behaviour in APEX when PDP STATE changed to PASSIVE and then ACTIVE
| `POLICY-4088 <https://lf-onap.atlassian.net/browse/POLICY-4088>`_ - PAP shows incorrect deployments counter on parallel deploy/undeploy
| `POLICY-4092 <https://lf-onap.atlassian.net/browse/POLICY-4092>`_ - Modify Nssi Closed Loop Error
| `POLICY-4095 <https://lf-onap.atlassian.net/browse/POLICY-4095>`_ - Failures on Daily Master tests onap-policy-clamp-runtime-acm
| `POLICY-4096 <https://lf-onap.atlassian.net/browse/POLICY-4096>`_ - Policy deployment fails if prometheus operator is not installed
| `POLICY-4104 <https://lf-onap.atlassian.net/browse/POLICY-4104>`_ - Issue when serialization into JSON Object which brings allot of garbage
| `POLICY-4106 <https://lf-onap.atlassian.net/browse/POLICY-4106>`_ - PDP-D APPS: Network Slicing: incorrect SO operation

References
==========

For more information on the ONAP Jakarta release, please see:

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
..      * * *    ISTANBUL    * * *
..      ==========================

Version: 9.0.1
--------------

:Release Date: 2022-02-17 (Istanbul Maintenance Release #1)

**Artifacts**

Artifacts released:

.. list-table::
   :widths: 15 10 10
   :header-rows: 1

   * - Repository
     - Java Artifact
     - Docker Image (if applicable)
   * - policy/parent
     - 3.4.4
     - N/A
   * - policy/docker
     - 2.3.2
     - | onap/policy-jdk-alpine:2.3.2
       | onap/policy-jre-alpine:2.3.2
       | onap/policy-db-migrator:2.3.2
   * - policy/common
     - 1.9.2
     - N/A
   * - policy/models
     - 2.5.2
     - N/A
   * - policy/api
     - 2.5.2
     - onap/policy-api:2.5.2
   * - policy/pap
     - 2.5.2
     - onap/policy-pap:2.5.2
   * - policy/drools-pdp
     - 1.9.2
     - onap/policy-drools:1.9.2
   * - policy/apex-pdp
     - 2.6.2
     - onap/policy-apex-pdp:2.6.2
   * - policy/xacml-pdp
     - 2.5.2
     - onap/policy-xacml-pdp:2.5.2
   * - policy/drools-applications
     - 1.9.2
     - onap/policy-pdpd-cl:1.9.2
   * - policy/clamp
     - 6.1.4
     - | onap/policy-clamp-backend:6.1.4
       | onap/policy-clamp-frontend:6.1.4
       | onap/policy-clamp-cl-pf-ppnt:6.1.4
       | onap/policy-clamp-cl-k8s-ppnt:6.1.4
       | onap/policy-clamp-cl-http-ppnt:6.1.4
       | onap/policy-clamp-cl-runtime:6.1.4
   * - policy/gui
     - 2.1.2
     - onap/policy-gui:2.1.2
   * - policy/distribution
     - 2.6.2
     - onap/policy-distribution:2.6.2

**Bug Fixes and Necessary Enhancements**

    * `[POLICY-3862] <https://lf-onap.atlassian.net/browse/POLICY-3862>`_
      - Check all code for Log4J before version 2.15.0 and upgrade if necessary

Version: 9.0.0
--------------

:Release Date: 2021-11-04 (Istanbul Release)

New features
============

Artifacts released:

.. list-table::
   :widths: 15 10 10
   :header-rows: 1

   * - Repository
     - Java Artifact
     - Docker Image (if applicable)
   * - policy/parent
     - 3.4.3
     - N/A
   * - policy/docker
     - 2.3.1
     - | onap/policy-jdk-alpine:2.3.1
       | onap/policy-jre-alpine:2.3.1
       | onap/policy-db-migrator:2.3.1
   * - policy/common
     - 1.9.1
     - N/A
   * - policy/models
     - 2.5.1
     - N/A
   * - policy/api
     - 2.5.1
     - onap/policy-api:2.5.1
   * - policy/pap
     - 2.5.1
     - onap/policy-pap:2.5.1
   * - policy/drools-pdp
     - 1.9.1
     - onap/policy-drools:1.9.1
   * - policy/apex-pdp
     - 2.6.1
     - onap/policy-apex-pdp:2.6.1
   * - policy/xacml-pdp
     - 2.5.1
     - onap/policy-xacml-pdp:2.5.1
   * - policy/drools-applications
     - 1.9.1
     - onap/policy-pdpd-cl:1.9.1
   * - policy/clamp
     - 6.1.3
     - | onap/policy-clamp-backend:6.1.3
       | onap/policy-clamp-frontend:6.1.3
       | onap/policy-clamp-cl-pf-ppnt:6.1.3
       | onap/policy-clamp-cl-k8s-ppnt:6.1.3
       | onap/policy-clamp-cl-http-ppnt:6.1.3
       | onap/policy-clamp-cl-runtime:6.1.3
   * - policy/gui
     - 2.1.1
     - onap/policy-gui:2.1.1
   * - policy/distribution
     - 2.6.1
     - onap/policy-distribution:2.6.1

Key Updates
===========

Clamp -> policy
Control Loop
Database

* `REQ-684 <https://lf-onap.atlassian.net/browse/REQ-684>`_ - Merge CLAMP functionality into Policy Framework project
    - keep CLAMP functions into ONAP
    - reduce ONAP footprint
    - consolidate the UI (Control loop UI and policy)
    - enables code sharing and common handling for REST and TOSCA
    - introduces the Spring Framework into the Policy Framework
    - see `the CLAMP documentation <https://docs.onap.org/projects/onap-policy-parent/en/latest/clamp/clamp.html>`_

* `REQ-716 <https://lf-onap.atlassian.net/browse/REQ-716>`_ - Control Loop in TOSCA LCM
   - Allows Control Loops to be defined and described in Metadata using TOSCA
   - Control loops can run on the fly on any component that implements a *participant* API
   - Control Loops can be commissioned into Policy/CLAMP, they can be parameterized, initiated on arbitrary
     participants, activated and monitored
   - See `the CLAMP TOSCA Control Loop documentation
     <https://docs.onap.org/projects/onap-policy-parent/en/latest/clamp/clamp.html>`_

* CLAMP Client Policy and TOSCA Handling
    - Push existing policy(tree) into pdp
    - Handling of PDP Groups
    - Handling of Policy Types
    - Handling of TOSCA Service Templates
    - Push of Policies to PDPs
    - Support multiple PDP Groups per Policy Type
    - Tree view in Policies list
    - Integration of new TOSCA Control Loop GUI into CLAMP GUI

* Policy Handling Improvements
    - Support delta policies in PDPs
    - Allow XACML rules to specify EventManagerService
    - Sending of notifications to Kafka & Rest in apex-pdp policies
    - External configuration of groups other than defaultGroup
    - XACML Decision support for Multiple Requests
    - Updated query parameter names and support for wildcards in APIs
    - Added new APIs for Policy Audit capabilities
    - Capability to send multiple output events from a state in APEX-PDP

* System Attribute Improvements
    - Support for upgrade and rollback, starting with upgrade from the Honolulu release to the Istanbul release
    - Consolidated health check
    - Phase 1 of Spring Framework introduction
    - Phase 1 of Prometheus introduction, base Prometheus metrics

Known Limitations, Issues and Workarounds
=========================================

System Limitations
~~~~~~~~~~~~~~~~~~
N/A

Known Vulnerabilities
~~~~~~~~~~~~~~~~~~~~~
N/A

Workarounds
~~~~~~~~~~~
N/A

Security Notes
==============

| `POLICY-3169 <https://lf-onap.atlassian.net/browse/POLICY-3169>`_ - Remove security issues reported by NEXUS-IQ
| `POLICY-3315 <https://lf-onap.atlassian.net/browse/POLICY-3315>`_ - Review license scan issues
| `POLICY-3327 <https://lf-onap.atlassian.net/browse/POLICY-3327>`_ - OOM AAF generated certificates contain invalid SANs entries
| `POLICY-3338 <https://lf-onap.atlassian.net/browse/POLICY-3338>`_ - Upgrade CDS dependency to the latest version
| `POLICY-3384 <https://lf-onap.atlassian.net/browse/POLICY-3384>`_ - Use signed certificates in the CSITs
| `POLICY-3431 <https://lf-onap.atlassian.net/browse/POLICY-3431>`_ - Review license scan issues
| `POLICY-3516 <https://lf-onap.atlassian.net/browse/POLICY-3516>`_ - Upgrade CDS dependency to the 1.1.5 version
| `POLICY-3590 <https://lf-onap.atlassian.net/browse/POLICY-3590>`_ - Address security vulnerabilities and License issues in Policy Framework
| `POLICY-3697 <https://lf-onap.atlassian.net/browse/POLICY-3697>`_ - Review license scan issues


Functional Improvements
=======================
| `REQ-684 <https://lf-onap.atlassian.net/browse/REQ-684>`_ - Merge CLAMP functionality into Policy Framework project
| `REQ-716 <https://lf-onap.atlassian.net/browse/REQ-716>`_ - Control Loop in TOSCA LCM
| `POLICY-1787 <https://lf-onap.atlassian.net/browse/POLICY-1787>`_ - Support mariadb upgrade/rollback functionality
| `POLICY-2535 <https://lf-onap.atlassian.net/browse/POLICY-2535>`_ - Query deployed policies by regex on the name, for a given policy type
| `POLICY-2618 <https://lf-onap.atlassian.net/browse/POLICY-2618>`_ - PDP-D make legacy configuration interface (used by brmsgw) an optional feature
| `POLICY-2769 <https://lf-onap.atlassian.net/browse/POLICY-2769>`_ - Support multiple PAP instances
| `POLICY-2865 <https://lf-onap.atlassian.net/browse/POLICY-2865>`_ - Add support and documentation on how an application can control what info is returned in Decision API
| `POLICY-2896 <https://lf-onap.atlassian.net/browse/POLICY-2896>`_ - Improve consolidated health check to include dependencies
| `POLICY-2920 <https://lf-onap.atlassian.net/browse/POLICY-2920>`_ - policy-clamp ui is capable to push and existing policy(tree) into pdp
| `POLICY-2921 <https://lf-onap.atlassian.net/browse/POLICY-2921>`_ - use the policy-clamp ui to manage pdp groups
| `POLICY-2923 <https://lf-onap.atlassian.net/browse/POLICY-2923>`_ - use the policy-clamp ui to manage policy types
| `POLICY-2930 <https://lf-onap.atlassian.net/browse/POLICY-2930>`_ - clamp-backend rest api to push policies to pdp
| `POLICY-2931 <https://lf-onap.atlassian.net/browse/POLICY-2931>`_ - clamp GUI to push policy to pdp
| `POLICY-3072 <https://lf-onap.atlassian.net/browse/POLICY-3072>`_ - clamp ui support multiple pdp group per policy type
| `POLICY-3107 <https://lf-onap.atlassian.net/browse/POLICY-3107>`_ - Support delta policies in PDPs
| `POLICY-3165 <https://lf-onap.atlassian.net/browse/POLICY-3165>`_ - Implement tree view in policies list
| `POLICY-3209 <https://lf-onap.atlassian.net/browse/POLICY-3209>`_ - CLAMP Component Lifecycle Management using Spring Framework
| `POLICY-3218 <https://lf-onap.atlassian.net/browse/POLICY-3218>`_ - Integrate CLAMP GUIs (Instantiation/Monitoring) in the policy-gui repo
| `POLICY-3227 <https://lf-onap.atlassian.net/browse/POLICY-3227>`_ - Implementation of context album improvements in apex-pdp
| `POLICY-3228 <https://lf-onap.atlassian.net/browse/POLICY-3228>`_ - Implement clamp backend part to add policy models api
| `POLICY-3229 <https://lf-onap.atlassian.net/browse/POLICY-3229>`_ - Implement the front end part to add tosca model
| `POLICY-3230 <https://lf-onap.atlassian.net/browse/POLICY-3230>`_ - Make default PDP-D and PDP-D-APPS work out of the box
| `POLICY-3260 <https://lf-onap.atlassian.net/browse/POLICY-3260>`_ - Allow rules to specify EventManagerService
| `POLICY-3324 <https://lf-onap.atlassian.net/browse/POLICY-3324>`_ - Design a solution for sending notifications to Kafka & Rest in apex-pdp policies
| `POLICY-3331 <https://lf-onap.atlassian.net/browse/POLICY-3331>`_ - PAP: should allow for external configuration of groups other than defaultGroup
| `POLICY-3340 <https://lf-onap.atlassian.net/browse/POLICY-3340>`_ - Create REST API's in PAP to fetch the audit information stored in DB
| `POLICY-3514 <https://lf-onap.atlassian.net/browse/POLICY-3514>`_ - XACML Decision support for Multiple Requests
| `POLICY-3524 <https://lf-onap.atlassian.net/browse/POLICY-3524>`_ - Explore options to integrate prometheus with policy framework components
| `POLICY-3527 <https://lf-onap.atlassian.net/browse/POLICY-3527>`_ - Update query parameter names in policy audit api's
| `POLICY-3533 <https://lf-onap.atlassian.net/browse/POLICY-3533>`_ - PDP-D: make DB port provisionable
| `POLICY-3538 <https://lf-onap.atlassian.net/browse/POLICY-3538>`_ - Export basic metrics from policy components for prometheus
| `POLICY-3545 <https://lf-onap.atlassian.net/browse/POLICY-3545>`_ - Use generic create policy url in policy/distribution
| `POLICY-3557 <https://lf-onap.atlassian.net/browse/POLICY-3557>`_ - Export basic prometheus metrics from clamp

Necessary Improvements and Bug Fixes
====================================

Necessary Improvements
~~~~~~~~~~~~~~~~~~~~~~
| `POLICY-2418 <https://lf-onap.atlassian.net/browse/POLICY-2418>`_ - Refactor XACML PDP POJO's into Bean objects in order to perform validation more simply
| `POLICY-2429 <https://lf-onap.atlassian.net/browse/POLICY-2429>`_ - Mark policy/engine read-only and remove ci-management jobs for it
| `POLICY-2542 <https://lf-onap.atlassian.net/browse/POLICY-2542>`_ - Improve the REST parameter validation for PAP api's
| `POLICY-2767 <https://lf-onap.atlassian.net/browse/POLICY-2767>`_ - Improve error handling of drools-pdp when requestID in onset is not valid UUID
| `POLICY-2899 <https://lf-onap.atlassian.net/browse/POLICY-2899>`_ - Store basic audit details of deploy/undeploy operations in PAP
| `POLICY-2996 <https://lf-onap.atlassian.net/browse/POLICY-2996>`_ - Address technical debt left over from Honolulu
| `POLICY-3059 <https://lf-onap.atlassian.net/browse/POLICY-3059>`_ - Fix name of target-database property in persistence.xml files
| `POLICY-3062 <https://lf-onap.atlassian.net/browse/POLICY-3062>`_ - Update the ENTRYPOINT in APEX-PDP Dockerfile
| `POLICY-3078 <https://lf-onap.atlassian.net/browse/POLICY-3078>`_ - Support SSL communication in Kafka IO plugin of Apex-PDP
| `POLICY-3087 <https://lf-onap.atlassian.net/browse/POLICY-3087>`_ - Use sl4fj instead of EELFLogger
| `POLICY-3089 <https://lf-onap.atlassian.net/browse/POLICY-3089>`_ - Cleanup logs for success/failure consumers in apex-pdp
| `POLICY-3096 <https://lf-onap.atlassian.net/browse/POLICY-3096>`_ - Fix intermittent test failures in APEX
| `POLICY-3128 <https://lf-onap.atlassian.net/browse/POLICY-3128>`_ - Use command command-line handler across policy repos
| `POLICY-3129 <https://lf-onap.atlassian.net/browse/POLICY-3129>`_ - Refactor command-line handling across policy-repos
| `POLICY-3132 <https://lf-onap.atlassian.net/browse/POLICY-3132>`_ - Apex-pdp documentation refers to missing logos.png
| `POLICY-3134 <https://lf-onap.atlassian.net/browse/POLICY-3134>`_ - Use base image for policy-jdk docker images
| `POLICY-3136 <https://lf-onap.atlassian.net/browse/POLICY-3136>`_ - Ignore jacoco and checkstyle when in eclipse
| `POLICY-3143 <https://lf-onap.atlassian.net/browse/POLICY-3143>`_ - Remove keystore files from policy repos
| `POLICY-3145 <https://lf-onap.atlassian.net/browse/POLICY-3145>`_ - HTTPS clients should not allow self-signed certificates
| `POLICY-3147 <https://lf-onap.atlassian.net/browse/POLICY-3147>`_ - Xacml-pdp should not use RestServerParameters for client parameters
| `POLICY-3155 <https://lf-onap.atlassian.net/browse/POLICY-3155>`_ - Use python3 for CSITs
| `POLICY-3160 <https://lf-onap.atlassian.net/browse/POLICY-3160>`_ - Use "sh" instead of "ash" where possible
| `POLICY-3163 <https://lf-onap.atlassian.net/browse/POLICY-3163>`_ - Remove spaces from xacml file name
| `POLICY-3166 <https://lf-onap.atlassian.net/browse/POLICY-3166>`_ - Use newer onap base image in clamp
| `POLICY-3171 <https://lf-onap.atlassian.net/browse/POLICY-3171>`_ - Fix sporadic error in models provider junits
| `POLICY-3175 <https://lf-onap.atlassian.net/browse/POLICY-3175>`_ - Minor clean-up of drools-apps
| `POLICY-3182 <https://lf-onap.atlassian.net/browse/POLICY-3182>`_ - Update npm repo
| `POLICY-3189 <https://lf-onap.atlassian.net/browse/POLICY-3189>`_ - Create a new key class which uses the @GeneratedValue annotation
| `POLICY-3190 <https://lf-onap.atlassian.net/browse/POLICY-3190>`_ - Investigate handling of context albums in Apex-PDP for failure responses (ex - AAI)
| `POLICY-3198 <https://lf-onap.atlassian.net/browse/POLICY-3198>`_ - Remove VirtualControlLoopEvent from OperationsHistory classes
| `POLICY-3211 <https://lf-onap.atlassian.net/browse/POLICY-3211>`_ - Parameter Handling and Parameter Validation
| `POLICY-3214 <https://lf-onap.atlassian.net/browse/POLICY-3214>`_ - Change Monitoring UI implementation to use React
| `POLICY-3215 <https://lf-onap.atlassian.net/browse/POLICY-3215>`_ - Update CLAMP Module structure to Multi Module Maven approach
| `POLICY-3221 <https://lf-onap.atlassian.net/browse/POLICY-3221>`_ - wrong lifecycle state information in INFO.yaml for policy/clamp
| `POLICY-3222 <https://lf-onap.atlassian.net/browse/POLICY-3222>`_ - Use existing clamp gui to set the parameters during CL instantiation
| `POLICY-3235 <https://lf-onap.atlassian.net/browse/POLICY-3235>`_ - gui-editor-apex fails to start
| `POLICY-3257 <https://lf-onap.atlassian.net/browse/POLICY-3257>`_ - Update csit test cases to include policy status & statistics api's
| `POLICY-3261 <https://lf-onap.atlassian.net/browse/POLICY-3261>`_ - Rules need a way to release locks
| `POLICY-3262 <https://lf-onap.atlassian.net/browse/POLICY-3262>`_ - Extract more common code from UsecasesEventManager
| `POLICY-3292 <https://lf-onap.atlassian.net/browse/POLICY-3292>`_ - Update the XACML PDP Tutorial docker compose files to point to release Honolulu images
| `POLICY-3298 <https://lf-onap.atlassian.net/browse/POLICY-3298>`_ - Add key names to IndexedXxx factory class toString() methods
| `POLICY-3299 <https://lf-onap.atlassian.net/browse/POLICY-3299>`_ - Merge policy CSITs into docker/csit
| `POLICY-3300 <https://lf-onap.atlassian.net/browse/POLICY-3300>`_ - PACKAGES UPGRADES IN DIRECT DEPENDENCIES FOR ISTANBUL
| `POLICY-3303 <https://lf-onap.atlassian.net/browse/POLICY-3303>`_ - Update the default logback.xml in APEX to log to STDOUT
| `POLICY-3305 <https://lf-onap.atlassian.net/browse/POLICY-3305>`_ - Ensure XACML PDP application/translator methods are extendable
| `POLICY-3306 <https://lf-onap.atlassian.net/browse/POLICY-3306>`_ - Fix issue where apex-pdp test is failing in gitlab
| `POLICY-3307 <https://lf-onap.atlassian.net/browse/POLICY-3307>`_ - Turn off frankfurt CSITs
| `POLICY-3333 <https://lf-onap.atlassian.net/browse/POLICY-3333>`_ - bean validator should use SerializedName
| `POLICY-3336 <https://lf-onap.atlassian.net/browse/POLICY-3336>`_ - APEX CLI/Model: multiple outputs for nextState NULL
| `POLICY-3337 <https://lf-onap.atlassian.net/browse/POLICY-3337>`_ - Move clamp documentation to policy/parent
| `POLICY-3366 <https://lf-onap.atlassian.net/browse/POLICY-3366>`_ - PDP-D: support configuration of overarching DMAAP https flag
| `POLICY-3367 <https://lf-onap.atlassian.net/browse/POLICY-3367>`_ - oom: policy-clamp-create-tables.sql: add IF NOT EXISTS clauses
| `POLICY-3374 <https://lf-onap.atlassian.net/browse/POLICY-3374>`_ - Docker registry should be defined in the parent pom
| `POLICY-3378 <https://lf-onap.atlassian.net/browse/POLICY-3378>`_ - Move groovy scripts to separate/common file
| `POLICY-3382 <https://lf-onap.atlassian.net/browse/POLICY-3382>`_ - Create document for policy chaining in drools-pdp
| `POLICY-3383 <https://lf-onap.atlassian.net/browse/POLICY-3383>`_ - Standardize policy deployment vs undeployment count in PdpStatistics
| `POLICY-3388 <https://lf-onap.atlassian.net/browse/POLICY-3388>`_ - policy/gui merge jobs failing
| `POLICY-3389 <https://lf-onap.atlassian.net/browse/POLICY-3389>`_ - Use lombok annotations instead of hashCode, equals, toString, get, set
| `POLICY-3404 <https://lf-onap.atlassian.net/browse/POLICY-3404>`_ - Rolling DB errors in log output for API, PAP, and DB components
| `POLICY-3419 <https://lf-onap.atlassian.net/browse/POLICY-3419>`_ - Remove operationshistory10 DB
| `POLICY-3450 <https://lf-onap.atlassian.net/browse/POLICY-3450>`_ - PAP should support turning on/off via configuration storing PDP statistics
| `POLICY-3456 <https://lf-onap.atlassian.net/browse/POLICY-3456>`_ - Use new RestClientParameters class instead of BusTopicParams
| `POLICY-3457 <https://lf-onap.atlassian.net/browse/POLICY-3457>`_ - Topic source should not go into fast-fail loop when dmaap is unreachable
| `POLICY-3459 <https://lf-onap.atlassian.net/browse/POLICY-3459>`_ - Document how to turn off collection of PdpStatistics
| `POLICY-3473 <https://lf-onap.atlassian.net/browse/POLICY-3473>`_ - CSIT for xacml doesn't check dmaap msg status
| `POLICY-3474 <https://lf-onap.atlassian.net/browse/POLICY-3474>`_ - Delete extra simulators from policy-models
| `POLICY-3486 <https://lf-onap.atlassian.net/browse/POLICY-3486>`_ - policy-jdk docker image should have at least one up to date image
| `POLICY-3499 <https://lf-onap.atlassian.net/browse/POLICY-3499>`_ - Improve Apex-PDP logs to avoid printing errors for irrelevant events in multiple policy deployment
| `POLICY-3501 <https://lf-onap.atlassian.net/browse/POLICY-3501>`_ - Refactor guard actor
| `POLICY-3511 <https://lf-onap.atlassian.net/browse/POLICY-3511>`_ - Limit statistics record count
| `POLICY-3525 <https://lf-onap.atlassian.net/browse/POLICY-3525>`_ - Improve policy/pap csit automation test cases
| `POLICY-3528 <https://lf-onap.atlassian.net/browse/POLICY-3528>`_ - Update documents & postman collection for pdp statistics api's
| `POLICY-3531 <https://lf-onap.atlassian.net/browse/POLICY-3531>`_ - PDP-X: initialization delays causes liveness checks to be missed under OOM deployment
| `POLICY-3532 <https://lf-onap.atlassian.net/browse/POLICY-3532>`_ - Add Honolulu Maintenance Release notes to read-the-docs
| `POLICY-3539 <https://lf-onap.atlassian.net/browse/POLICY-3539>`_ - Use RestServer from policy/common in apex-pdp
| `POLICY-3547 <https://lf-onap.atlassian.net/browse/POLICY-3547>`_ - METADATA tables for policy/docker db-migrator should be different than counterpart in policy/drools-pdp seed
| `POLICY-3556 <https://lf-onap.atlassian.net/browse/POLICY-3556>`_ - Document xacml REST server limitations
| `POLICY-3605 <https://lf-onap.atlassian.net/browse/POLICY-3605>`_ - Enhance dmaap simulator to support ""/topics" endpoint
| `POLICY-3609 <https://lf-onap.atlassian.net/browse/POLICY-3609>`_ - Add CSIT test case for policy consolidated health check

Bug Fixes
~~~~~~~~~
| `POLICY-2845 <https://lf-onap.atlassian.net/browse/POLICY-2845>`_ - Policy dockers contain GPLv3
| `POLICY-3066 <https://lf-onap.atlassian.net/browse/POLICY-3066>`_ - Stackoverflow error in APEX standalone after changing to onap java image
| `POLICY-3161 <https://lf-onap.atlassian.net/browse/POLICY-3161>`_ - OOM clamp BE/FE do not start properly when clamp db exists in the cluster
| `POLICY-3174 <https://lf-onap.atlassian.net/browse/POLICY-3174>`_ - POLICY-APEX  log does not include the DATE in STDOUT
| `POLICY-3176 <https://lf-onap.atlassian.net/browse/POLICY-3176>`_ - POLICY-DROOLS  log does not include the DATE in STDOUT
| `POLICY-3177 <https://lf-onap.atlassian.net/browse/POLICY-3177>`_ - POLICY-PAP log does not include the DATE in STDOUT
| `POLICY-3201 <https://lf-onap.atlassian.net/browse/POLICY-3201>`_ - fix CRITICAL weak-cryptography issues identified in sonarcloud
| `POLICY-3202 <https://lf-onap.atlassian.net/browse/POLICY-3202>`_ - PDP-D: no locking feature: service loader not locking the no-lock-manager
| `POLICY-3203 <https://lf-onap.atlassian.net/browse/POLICY-3203>`_ - Update the PDP deployment in policy window failure
| `POLICY-3204 <https://lf-onap.atlassian.net/browse/POLICY-3204>`_ - Clamp UI does not accept to deploy policy to PDP
| `POLICY-3205 <https://lf-onap.atlassian.net/browse/POLICY-3205>`_ - The submit operation in Clamp cannot be achieved successfully
| `POLICY-3225 <https://lf-onap.atlassian.net/browse/POLICY-3225>`_ - Clamp policy UI does not send right pdp command
| `POLICY-3226 <https://lf-onap.atlassian.net/browse/POLICY-3226>`_ - Clamp policy UI does 2 parallel queries to policy list
| `POLICY-3248 <https://lf-onap.atlassian.net/browse/POLICY-3248>`_ - PdpHeartbeats are not getting processed by PAP
| `POLICY-3301 <https://lf-onap.atlassian.net/browse/POLICY-3301>`_ - Apex Avro Event Schemas - Not support for colon ':' character in field names
| `POLICY-3322 <https://lf-onap.atlassian.net/browse/POLICY-3322>`_ - gui-editor-apex doesn't contain webapp correctly
| `POLICY-3332 <https://lf-onap.atlassian.net/browse/POLICY-3332>`_ - Issues around delta policy deployment in APEX
| `POLICY-3369 <https://lf-onap.atlassian.net/browse/POLICY-3369>`_ - Modify NSSI closed loop not running
| `POLICY-3445 <https://lf-onap.atlassian.net/browse/POLICY-3445>`_ - Version conflicts in spring boot dependency jars in CLAMP
| `POLICY-3454 <https://lf-onap.atlassian.net/browse/POLICY-3454>`_ - PDP-D CL APPS: swagger mismatched libraries cause telemetry shell to fail
| `POLICY-3468 <https://lf-onap.atlassian.net/browse/POLICY-3468>`_ - PDPD-CL APPS: Clean up library transitive dependencies conflicts (jackson version) from new CDS libraries
| `POLICY-3507 <https://lf-onap.atlassian.net/browse/POLICY-3507>`_ - CDS Operation Policy execution runtime error
| `POLICY-3526 <https://lf-onap.atlassian.net/browse/POLICY-3526>`_ - OOM start of policy-distribution fails (keyStore values)
| `POLICY-3558 <https://lf-onap.atlassian.net/browse/POLICY-3558>`_ - Delete Instance Properties if Instantiation is Unitialized
| `POLICY-3600 <https://lf-onap.atlassian.net/browse/POLICY-3600>`_ - Some REST calls in Clamp GUI do not include pathname
| `POLICY-3601 <https://lf-onap.atlassian.net/browse/POLICY-3601>`_ - Static web resource paths in gui-editor-apex are incorrect
| `POLICY-3602 <https://lf-onap.atlassian.net/browse/POLICY-3602>`_ - Context schema table is not populated in Apex Editor
| `POLICY-3603 <https://lf-onap.atlassian.net/browse/POLICY-3603>`_ - gui-pdp-monitoring broken in gui docker image
| `POLICY-3608 <https://lf-onap.atlassian.net/browse/POLICY-3608>`_ - LASTUPDATE column in pdp table causing Nullpointer Exception in PAP initialization
| `POLICY-3610 <https://lf-onap.atlassian.net/browse/POLICY-3610>`_ - PDP-D-APPS:  audit and metric logging information is incorrect
| `POLICY-3611 <https://lf-onap.atlassian.net/browse/POLICY-3611>`_ - "API,PAP: decrease eclipselink verbosity in persistence.xml"
| `POLICY-3625 <https://lf-onap.atlassian.net/browse/POLICY-3625>`_ - Terminated PDPs are not being removed by PAP
| `POLICY-3637 <https://lf-onap.atlassian.net/browse/POLICY-3637>`_ - Policy-mariadb connection intermittently fails from PF components
| `POLICY-3639 <https://lf-onap.atlassian.net/browse/POLICY-3639>`_ - CLAMP_REST_URL environment variable is not needed
| `POLICY-3647 <https://lf-onap.atlassian.net/browse/POLICY-3647>`_ - Cannot create Instance from Policy GUI
| `POLICY-3649 <https://lf-onap.atlassian.net/browse/POLICY-3649>`_ - SSL Handshake failure between CL participants and DMaap
| `POLICY-3650 <https://lf-onap.atlassian.net/browse/POLICY-3650>`_ - Disable apex-editor and pdp-monitoring in gui docker
| `POLICY-3660 <https://lf-onap.atlassian.net/browse/POLICY-3660>`_ - DB-Migrator job completes even during failed upgrade
| `POLICY-3678 <https://lf-onap.atlassian.net/browse/POLICY-3678>`_ - K8s participants tests are skipped due to json parsing error.
| `POLICY-3679 <https://lf-onap.atlassian.net/browse/POLICY-3679>`_ - Modify pdpstatistics to prevent duplicate keys
| `POLICY-3680 <https://lf-onap.atlassian.net/browse/POLICY-3680>`_ - PDP Monitoring GUI fails to parse JSON from PAP
| `POLICY-3682 <https://lf-onap.atlassian.net/browse/POLICY-3682>`_ - Unable to list the policies in Policy UI
| `POLICY-3683 <https://lf-onap.atlassian.net/browse/POLICY-3683>`_ - clamp-fe & policy-gui: useless rolling logs
| `POLICY-3684 <https://lf-onap.atlassian.net/browse/POLICY-3684>`_ - Unable to select a PDP group & Subgroup when configuring a control loop policy
| `POLICY-3685 <https://lf-onap.atlassian.net/browse/POLICY-3685>`_ - Fix CL state change issues in runtime and participants
| `POLICY-3686 <https://lf-onap.atlassian.net/browse/POLICY-3686>`_ - Update Participant Status after Commissioning
| `POLICY-3687 <https://lf-onap.atlassian.net/browse/POLICY-3687>`_ - Continuous sending CONTROL_LOOP_STATE_CHANGE message
| `POLICY-3688 <https://lf-onap.atlassian.net/browse/POLICY-3688>`_ - Register participant in ParticipantRegister message
| `POLICY-3689 <https://lf-onap.atlassian.net/browse/POLICY-3689>`_ - Handle ParticipantRegister
| `POLICY-3691 <https://lf-onap.atlassian.net/browse/POLICY-3691>`_ - Problems Parsing Service Template
| `POLICY-3695 <https://lf-onap.atlassian.net/browse/POLICY-3695>`_ - Tosca Constraint "in_range" not supported by policy/models
| `POLICY-3706 <https://lf-onap.atlassian.net/browse/POLICY-3706>`_ - Telemetry not working in drools-pdp
| `POLICY-3707 <https://lf-onap.atlassian.net/browse/POLICY-3707>`_ - Cannot delete a loop in design state

References
==========

For more information on the ONAP Istanbul release, please see:

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
..      * * *    HONOLULU    * * *
..      ==========================

Version: 8.0.1
--------------

:Release Date: 2021-08-12 (Honolulu Maintenance Release #1)

**Artifacts**

Artifacts released:

.. csv-table::
   :header: "Repository", "Java Artifact", "Docker Image (if applicable)"
   :widths: 15,10,10

   "policy/parent", "3.3.2", ""
   "policy/common", "1.8.2", ""
   "policy/models", "2.4.4", ""
   "policy/api", "2.4.4", "onap/policy-api:2.4.4"
   "policy/pap", "2.4.5", "onap/policy-pap:2.4.5"
   "policy/drools-pdp", "1.8.4", "onap/policy-drools:1.8.4"
   "policy/apex-pdp", "2.5.4", "onap/policy-apex-pdp:2.5.4"
   "policy/xacml-pdp", "2.4.5", "onap/policy-xacml-pdp:2.4.5"
   "policy/drools-applications", "1.8.4", "onap/policy-pdpd-cl:1.8.4"
   "policy/distribution", "2.5.4", "onap/policy-distribution:2.5.4"
   "policy/docker", "2.2.1", "onap/policy-jdk-alpine:2.2.1, onap/policy-jre-alpine:2.2.1"


**Bug Fixes and Necessary Enhancements**


    * `[POLICY-3062] <https://lf-onap.atlassian.net/browse/POLICY-3062>`_ - Update the ENTRYPOINT in APEX-PDP Dockerfile
    * `[POLICY-3066] <https://lf-onap.atlassian.net/browse/POLICY-3066>`_ - Stackoverflow error in APEX standalone after changing to onap java image
    * `[POLICY-3078] <https://lf-onap.atlassian.net/browse/POLICY-3078>`_ - Support SSL communication in Kafka IO plugin of Apex-PDP
    * `[POLICY-3173] <https://lf-onap.atlassian.net/browse/POLICY-3173>`_ - APEX-PDP incorrectly reports successful policy deployment to PAP
    * `[POLICY-3202] <https://lf-onap.atlassian.net/browse/POLICY-3202>`_ - PDP-D: no locking feature: service loader not locking the no-lock-manager
    * `[POLICY-3227] <https://lf-onap.atlassian.net/browse/POLICY-3227>`_ - Implementation of context album improvements in apex-pdp
    * `[POLICY-3230] <https://lf-onap.atlassian.net/browse/POLICY-3230>`_ - Make default PDP-D and PDP-D-APPS work out of the box
    * `[POLICY-3248] <https://lf-onap.atlassian.net/browse/POLICY-3248>`_ - PdpHeartbeats are not getting processed by PAP
    * `[POLICY-3301] <https://lf-onap.atlassian.net/browse/POLICY-3301>`_ - Apex Avro Event Schemas - Not support for colon ':' character in field names
    * `[POLICY-3305] <https://lf-onap.atlassian.net/browse/POLICY-3305>`_ - Ensure XACML PDP application/translator methods are extendable
    * `[POLICY-3331] <https://lf-onap.atlassian.net/browse/POLICY-3331>`_ - PAP: should allow for external configuration of groups other than defaultGroup
    * `[POLICY-3338] <https://lf-onap.atlassian.net/browse/POLICY-3338>`_ - Upgrade CDS dependency to the latest version
    * `[POLICY-3366] <https://lf-onap.atlassian.net/browse/POLICY-3366>`_ - PDP-D: support configuration of overarching DMAAP https flag
    * `[POLICY-3450] <https://lf-onap.atlassian.net/browse/POLICY-3450>`_ - PAP should support turning on/off via configuration storing PDP statistics
    * `[POLICY-3454] <https://lf-onap.atlassian.net/browse/POLICY-3454>`_ - PDP-D CL APPS: swagger mismatched libraries cause telemetry shell to fail
    * `[POLICY-3485] <https://lf-onap.atlassian.net/browse/POLICY-3485>`_ - Limit statistics record count
    * `[POLICY-3507] <https://lf-onap.atlassian.net/browse/POLICY-3507>`_ - CDS Operation Policy execution runtime error
    * `[POLICY-3516] <https://lf-onap.atlassian.net/browse/POLICY-3516>`_ - Upgrade CDS dependency to the 1.1.5 version


Known Limitations
=================

The APIs provided by xacml-pdp (e.g., healthcheck, statistics, decision)
are always active.  While PAP controls which policies are deployed to a
xacml-pdp, it does not control whether or not the APIs are active.
In other words, xacml-pdp will respond to decision requests, regardless
of whether PAP has made it ACTIVE or PASSIVE.


Version: 8.0.0
--------------

:Release Date: 2021-04-29 (Honolulu Release)

New features
============

Artifacts released:

.. csv-table::
   :header: "Repository", "Java Artifact", "Docker Image (if applicable)"
   :widths: 15,10,10

   "policy/parent", "3.3.0", ""
   "policy/common", "1.8.0", ""
   "policy/models", "2.4.2", ""
   "policy/api", "2.4.2", "onap/policy-api:2.4.2"
   "policy/pap", "2.4.2", "onap/policy-pap:2.4.2"
   "policy/drools-pdp", "1.8.2", "onap/policy-drools:1.8.2"
   "policy/apex-pdp", "2.5.2", "onap/policy-apex-pdp:2.5.2"
   "policy/xacml-pdp", "2.4.2", "onap/policy-xacml-pdp:2.4.2"
   "policy/drools-applications", "1.8.2", "onap/policy-pdpd-cl:1.8.2"
   "policy/distribution", "2.5.2", "onap/policy-distribution:2.5.2"
   "policy/docker", "2.2.1", "onap/policy-jdk-alpine:2.2.1, onap/policy-jre-alpine:2.2.1"

Key Updates
===========

* Enhanced statistics
   - PDPs provide statistics, retrievable via PAP REST API
* PDP deployment status
   - Policy deployment API enhanced to reflect actual policy deployment status in PDPs
   - Make PAP component stateless
* Policy support
   - Upgrade XACML 3.0 code to use new Time Extensions
   - Enhancements for interoperability between Native Policies and other policy types
   - Support for arbitrary policy types on the Drools PDP
   - Improve handling of multiple policies in APEX PDP
   - Update policy-models TOSCA handling with Control Loop Entities
* Alternative locking mechanisms
   - Support NO locking feature in Drools-PDP
* Security
   - Remove credentials in code from the Apex JMS plugin
* Actor enhancements
   - Actors should give better warnings than NPE when data is missing
   - Remove old event-specific actor code
* PDP functional assignments
   - Make PDP type configurable in drools-pdp
   - Make PDP type configurable in xacml-pdp
* Performance improvements
   - Support policy updates between PAP and the PDPs, phase 1
* Maintainability
   - Use ONAP base docker image
   - Remove GPLv3 components from docker containers
   - Move CSITs to Policy repos
   - Deprecate server pool feature in drools-pdp
* PoCs
   - Merge CLAMP functionality into Policy Framework project
   - TOSCA Defined Control Loop


Known Limitations, Issues and Workarounds
=========================================

System Limitations
~~~~~~~~~~~~~~~~~~

The policy API component requires a fresh new database when migrating to the honolulu release.
Therefore, upgrades require a fresh new database installation.
Please see the
`Installing or Upgrading Policy <https://docs.onap.org/projects/onap-policy-parent/en/honolulu/installation/oom.html#installing-or-upgrading-policy>`__ section for appropriate procedures.

Known Vulnerabilities
~~~~~~~~~~~~~~~~~~~~~

Workarounds
~~~~~~~~~~~

* `POLICY-2998 <https://lf-onap.atlassian.net/browse/POLICY-2998>`_ - Provide a script to periodically purge the statistics table

Security Notes
==============

* `POLICY-3005 <https://lf-onap.atlassian.net/browse/POLICY-3005>`_ - Bump direct dependency versions
    - Upgrade org.onap.dmaap.messagerouter.dmaapclient to 1.1.12
    - Upgrade org.eclipse.persistence to 2.7.8
    - Upgrade org.glassfish.jersey.containers to 2.33
    - Upgrade com.fasterxml.jackson.module to 2.11.3
    - Upgrade com.google.re2j to 1.5
    - Upgrade org.mariadb.jdbc to 2.7.1
    - Upgrade commons-codec to 1.15
    - Upgrade com.thoughtworks.xstream to 1.4.15
    - Upgrade org.apache.httpcomponents:httpclient to 4.5.13
    - Upgrade org.apache.httpcomponents:httpcore to 4.4.14
    - Upgrade org.json to 20201115
    - Upgrade org.projectlombok to 1.18.16
    - Upgrade org.yaml to 1.27
    - Upgrade io.cucumber to 6.9.1
    - Upgrade org.apache.commons:commons-lang3 to 3.11
    - Upgrade commons-io to 2.8.0
* `POLICY-2943 <https://lf-onap.atlassian.net/browse/POLICY-2943>`_ - Review license scan issues
    - Upgrade com.hazelcast to 4.1.1
    - Upgrade io.netty to 4.1.58.Final
* `POLICY-2936 <https://lf-onap.atlassian.net/browse/POLICY-2936>`_ - Upgrade to latest version of CDS API
    - Upgrade io.grpc to 1.35.0
    - Upgrade com.google.protobuf to 3.14.0


References
==========

For more information on the ONAP Honolulu release, please see:

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

..      ========================
..      * * *    GUILIN    * * *
..      ========================

Version: 7.0.0
--------------

:Release Date: 2020-12-03 (Guilin Release)

New features
============

Artifacts released:

.. csv-table::
   :header: "Repository", "Java Artifact", "Docker Image (if applicable)"
   :widths: 15,10,10

   "policy/parent", "3.2.0", ""
   "policy/common", "1.7.1", ""
   "policy/models", "2.3.5", ""
   "policy/api", "2.3.3", "onap/policy-api:2.3.3"
   "policy/pap", "2.3.3", "onap/policy-pap:2.3.3"
   "policy/drools-pdp", "1.7.4", "onap/policy-drools:1.7.4"
   "policy/apex-pdp", "2.4.4", "onap/policy-apex-pdp:2.4.4"
   "policy/xacml-pdp", "2.3.3", "onap/policy-xacml-pdp:2.3.3"
   "policy/drools-applications", "1.7.5", "onap/policy-pdpd-cl:1.7.5"
   "policy/distribution", "2.4.3", "onap/policy-distribution:2.4.3"
   "policy/docker", "2.1.1", "onap/policy-jdk-alpine:2.1.1, onap/policy-jre-alpine:2.1.1"

Key Updates
===========

* Kubernetes integration
   - All components return with non-zero exit code in case of application failure
   - All components log to standard out (i.e., k8s logs) by default
   - Continue to write log files inside individual pods, as well
* E2E Network Slicing
   - Added ModifyNSSI operation to SO actor
* Consolidated health check
   - Indicate failure if there aren’t enough PDPs registered
* Legacy operational policies
   - Removed from all components
* OOM helm charts refactoring
   - Name standardization
   - Automated certificate generation
* Actor Model
   - Support various use cases and provide more flexibility to Policy Designers
   - Reintroduced the "usecases" controller into drools-pdp, supporting the use cases
     under the revised actor architecture
* Guard Application
   - Support policy filtering
* Matchable Application
  - Support for ONAP or 3rd party components to create matchable policy types out of the box
* Policy Lifecycle & Administration API
   - Query/Delete by policy name & version without policy type
* Apex-PDP enhancements
   - Support multiple event & response types coming from a single endpoint
   - Standalone installation now supports Tosca-based policies
   - Legacy policy format has been removed
   - Support chaining/handling of gRPC failure responses
* Policy Distribution
   - HPA decoders & related classes have been removed
* Policy Engine
   - Deprecated

Known Limitations, Issues and Workarounds
=========================================

System Limitations
~~~~~~~~~~~~~~~~~~

The policy API component requires a fresh new database when migrating to the guilin release.
Therefore, upgrades require a fresh new database installation.
Please see the
`Installing or Upgrading Policy <https://docs.onap.org/projects/onap-policy-parent/en/latest/installation/oom.html#installing-or-upgrading-policy-acm>`__ section for appropriate procedures.

Known Vulnerabilities
~~~~~~~~~~~~~~~~~~~~~

* `POLICY-2463 <https://lf-onap.atlassian.net/browse/POLICY-2463>`_ - In APEX Policy javascript task logic, JSON.stringify causing stackoverflow exceptions

Workarounds
~~~~~~~~~~~
* `POLICY-2463 <https://lf-onap.atlassian.net/browse/POLICY-2463>`_ - Use the stringify method of the execution context

Security Notes
==============

* `POLICY-2878 <https://lf-onap.atlassian.net/browse/POLICY-2878>`_ - Dependency upgrades
    - Upgrade com.fasterxml.jackson to 2.11.1
* `POLICY-2387 <https://lf-onap.atlassian.net/browse/POLICY-2387>`_ - Dependency upgrades
    - Upgrade org.json to 20200518
    - Upgrade com.google.re2j to 1.4
    - Upgrade com.thoughtworks.xstream to 1.4.12
    - Upgrade org.eclipse.persistence to 2.2.1
    - Upgrade org.apache.httpcomponents to 4.5.12
    - Upgrade org.projectlombok to 1.18.12
    - Upgrade org.slf4j to 1.7.30
    - Upgrade org.codehaus.plexus to 3.3.0
    - Upgrade com.h2database to 1.4.200
    - Upgrade io.cucumber to 6.1.2
    - Upgrade org.assertj to 3.16.1
    - Upgrade com.openpojo to 0.8.13
    - Upgrade org.mockito to 3.3.3
    - Upgrade org.awaitility to 4.0.3
    - Upgrade org.onap.aaf.authz to 2.1.21
* `POLICY-2668 <https://lf-onap.atlassian.net/browse/POLICY-2668>`_ - Dependency upgrades
    - Upgrade org.java-websocket to 1.5.1
* `POLICY-2623 <https://lf-onap.atlassian.net/browse/POLICY-2623>`_ - Remove log4j dependency
* `POLICY-1996 <https://lf-onap.atlassian.net/browse/POLICY-1996>`_ - Dependency upgrades
    - Upgrade org.onap.dmaap.messagerouter.dmaapclient to 1.1.11


References
==========

For more information on the ONAP Guilin release, please see:

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


..      ===========================
..      * * *    FRANKFURT    * * *
..      ===========================


Version: 6.0.1
--------------

:Release Date: 2020-08-21 (Frankfurt Maintenance Release #1)

**Artifacts**

Artifacts released:

.. csv-table::
   :header: "Repository", "Java Artifact", "Docker Image (if applicable)"
   :widths: 15,10,10

   "policy/drools-applications", "1.6.4", "onap/policy-pdpd-cl:1.6.4"


**Bug Fixes**


    * `[POLICY-2704] <https://lf-onap.atlassian.net/browse/POLICY-2704>`_ - Legacy PDP-X and PAP stuck in PodIntializing


**Security Notes**

*Fixed Security Issues*


    * `[POLICY-2678] <https://lf-onap.atlassian.net/browse/POLICY-2678>`_ - policy/engine tomcat upgrade for CVE-2020-11996


Version: 6.0.0
--------------

:Release Date: 2020-06-04 (Frankfurt Release)

New features
============

Artifacts released:

.. csv-table::
   :header: "Repository", "Java Artifact", "Docker Image (if applicable)"
   :widths: 15,10,10

   "policy/parent", "3.1.3", ""
   "policy/common", "1.6.5", ""
   "policy/models", "2.2.6", ""
   "policy/api", "2.2.4", "onap/policy-api:2.2.4"
   "policy/pap", "2.2.3", "onap/policy-pap:2.2.3"
   "policy/drools-pdp", "1.6.3", "onap/policy-drools:1.6.3"
   "policy/apex-pdp", "2.3.2", "onap/policy-apex-pdp:2.3.2"
   "policy/xacml-pdp", "2.2.2", "onap/policy-xacml-pdp:2.2.2"
   "policy/drools-applications", "1.6.4", "onap/policy-pdpd-cl:1.6.4"
   "policy/engine", "1.6.4", "onap/policy-pe:1.6.4"
   "policy/distribution", "2.3.2", "onap/policy-distribution:2.3.2"
   "policy/docker", "2.0.1", "onap/policy-jdk-alpine:2.0.1, onap/policy-jre-alpine:2.0.1, onap/policy-jdk-debian:2.0.1, onap/policy-jre-debian:2.0.1"

Summary
=======

New features include policy update notifications, native policy support, streamlined health check for the Policy Administration Point (PAP),
configurable pre-loading/pre-deployment of policies, new APIs (e.g. to create one or more Policies with a single call), new experimental PDP monitoring GUI, and enhancements to all three PDPs: XACML, Drools, APEX.

Common changes in all policy components
=======================================

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
==========

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
   - A new API is now available just for creating/updating PDP Groups. Policies cannot be added/updated during PDP Group create/update operations. There is another API for this. So, if provided in the create/update group request, they are ignored. Supported policy types are defined during PDP Group creation. They cannot be updated once they are created. Refer to this for details: https://github.com/onap/policy-parent/blob/master/docs/pap/pap.rst

* PAP API to deploy policies to PdpGroups
   - A new API is introduced to deploy policies on specific PDPGroups. Each subgroup includes an "action" property, which is used to indicate that the policies are being added (POST) to the subgroup, deleted (DELETE) from the subgroup, or that the subgroup's entire set of policies is being replaced (PATCH) by a new set of policies.

POLICY-API
==========

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
   - https://lf-onap.atlassian.net/browse/POLICY-2377 covers the versioning issues in Policy. Basically, multiple versions of a Policy Type cannot be handled in TOSCA. So, in Frankfurt, the latest version of the policy type is examined. This will be further looked into in Guilin.

* Cascaded GET of PolicyTypes and Policies
   - Fetching/GET PolicyType now returns all of the referenced/parent policyTypes and dataTypes as well.
   - Fetching/GET Policy allows specifying mode now.
   - By default the mode is “BARE”, which returns only the requested Policy in response. If mode is specified as “REFERENCED”, all of the referenced/parent policyTypes and dataTypes are returned as well.

* The /deployed API is removed from policy/api
   - This run time administration job to see the deployment status of a policy is now possible via PAP.

* Changes related to design and support of TOSCA Compliant Policy Types for the operational and guard policy models.

POLICY-DISTRIBUTION
===================

* From Frankfurt release, policy-distribution component uses APIs provided by Policy-API and Policy-PAP for creation of policy types and policies, and deployment of policies.
   - Note: If “deployPolicies” field in the startup config file is true, then only the policies are deployed using PAP endpoint.

* Policy/engine & apex-pdp dependencies are removed from policy-distribution.


POLICY-APEX-PDP
===============

* Changed the JavaScript executor from Nashorn to Rhino as part of Java 11 upgrade.
   - There are minor changes in the JavaScript task logic files associated with this Rhino migration. An example for this change can be seen here: https://gerrit.onap.org/r/c/policy/apex-pdp/+/103546/2/examples/examples-onap-bbs/src/main/resources/logic/SdncResourceUpdateTask.js

   - There is a known issue in Rhino javascript related to the usage of JSON.stringify. This is captured in this JIRA https://lf-onap.atlassian.net/browse/POLICY-2463.

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

   - More information about the usage of Task Parameters can be found here: https://docs.onap.org/projects/onap-policy-parent/en/latest/apex/APEX-User-Manual.html#configure-task-parameters

   - In the taskLogic, taskParameters can be accessed as  executor.parameters.get("ParameterKey1"))

   - More information can be found here: https://docs.onap.org/projects/onap-policy-parent/en/latest/apex/APEX-Policy-Guide.html#accessing-taskparameters

* GRPC support for APEX-CDS interaction.
   - APEX-PDP now supports interaction with CDS over gRPC. Up through El Alto, CDS interaction was possible over REST only. A new plugin was developed in APEX for this feature. Refer the link for more details. https://docs.onap.org/projects/onap-policy-parent/en/latest/apex/APEX-User-Manual.html#grpc-io

POLICY-XACML-PDP
================

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
=================

* Support for PDP-D in offline mode to support locked deployments.   This is the default ONAP installation.
* Parameterize maven repository URLs for easier CI/CD integration.
* Support for Tosca Compliant Operational Policies.
* Support for TOSCA Compliant Native Policies that allows creation and deployment of new drools-applications.
* Validation of Operational and Native Policies against their policy type.
* Support for a generic Drools-PDP docker image to host any type of application.
* Experimental Server Pool feature that supports multiple active Drools PDP hosts.

POLICY-DROOLS-APPLICATIONS
==========================

* Removal of DCAE ONSET alarm duplicates (with different request IDs).
* Support of a new controller (frankfurt) that supports the ONAP use cases under the new actor architecture.
* Deprecated the "usecases" controller supporting the use cases under the legacy actor architecture.
* Deleted the unsupported "amsterdam" controller related projects.


Known Limitations, Issues and Workarounds
=========================================

System Limitations
~~~~~~~~~~~~~~~~~~

The policy API component requires a fresh new database when migrating to the frankfurt release.
Therefore, upgrades require a fresh new database installation.
Please see the
`Installing or Upgrading Policy <https://docs.onap.org/projects/onap-policy-parent/en/latest/installation/oom.html#installing-or-upgrading-policy-acm>`__ section for appropriate procedures.

Known Vulnerabilities
~~~~~~~~~~~~~~~~~~~~~

* `POLICY-2463 <https://lf-onap.atlassian.net/browse/POLICY-2463>`_ - In APEX Policy javascript task logic, JSON.stringify causing stackoverflow exceptions
* `POLICY-2487 <https://lf-onap.atlassian.net/browse/POLICY-2487>`_ - policy/api hangs in loop if preload policy does not exist

Workarounds
~~~~~~~~~~~
* `POLICY-2463 <https://lf-onap.atlassian.net/browse/POLICY-2463>`_ - Parse incoming object using JSON.Parse() or cast the object to a String

Security Notes
==============

* `POLICY-2221 <https://lf-onap.atlassian.net/browse/POLICY-2221>`_ - Password removal from helm charts
* `POLICY-2064 <https://lf-onap.atlassian.net/browse/POLICY-2064>`_ - Allow overriding of keystore and truststore in policy helm charts
* `POLICY-2381 <https://lf-onap.atlassian.net/browse/POLICY-2381>`_ - Dependency upgrades
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

..      ==========================
..      * * *     EL ALTO    * * *
..      ==========================

Version: 5.0.2
--------------

:Release Date: 2020-08-24 (El Alto Maintenance Release #1)

**New Features**

Artifacts released:

.. csv-table::
   :header: "Repository", "Java Artifact", "Docker Image (if applicable)"
   :widths: 15,10,10

   "policy/api", "2.1.3", "onap/policy-api:2.1.3"
   "policy/pap", "2.1.3", "onap/policy-pap:2.1.3"
   "policy/drools-pdp", "1.5.3", "onap/policy-drools:1.5.3"
   "policy/apex-pdp", "2.2.3", "onap/policy-apex-pdp:2.2.3"
   "policy/xacml-pdp", "2.1.3", "onap/policy-xacml-pdp:2.1.3"
   "policy/drools-applications", "1.5.4", "onap/policy-pdpd-cl:1.5.4"
   "policy/engine", "1.5.3", "onap/policy-pe:1.5.3"
   "policy/distribution", "2.2.2", "onap/policy-distribution:2.2.2"
   "policy/docker", "1.4.0", "onap/policy-common-alpine:1.4.0, onap/policy/base-alpine:1.4.0"


**Bug Fixes**


    * `[PORTAL-760]  <https://lf-onap.atlassian.net/browse/PORTAL-760>`_  - Access to Policy portal is impossible
    * `[POLICY-2107] <https://lf-onap.atlassian.net/browse/POLICY-2107>`_ - policy/distribution license issue in resource needs to be removed
    * `[POLICY-2169] <https://lf-onap.atlassian.net/browse/POLICY-2169>`_ - SDC client interface change caused compile error in policy distribution
    * `[POLICY-2171] <https://lf-onap.atlassian.net/browse/POLICY-2171>`_ - Upgrade elalto branch models and drools-applications
    * `[POLICY-1509] <https://lf-onap.atlassian.net/browse/POLICY-1509>`_ - Investigate Apex org.python.jython-standalone.2.7.1
    * `[POLICY-2062] <https://lf-onap.atlassian.net/browse/POLICY-2062>`_ - APEX PDP logs > 4G filled local storage


**Security Notes**

*Fixed Security Issues*


    * `[POLICY-2475] <https://lf-onap.atlassian.net/browse/POLICY-2475>`_ - Update El Alto component certificates

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

    - POLICY-969    Docker improvement in policy framwork modules
    - POLICY-1074   Fix checkstyle warnings in every repository
    - POLICY-1121   RPM build for Apex
    - POLICY-1223   CII Silver Badging Requirements
    - POLICY-1600   Clean up hash code equality checks, cloning and copying in policy-models
    - POLICY-1646   Replace uses of getCanonicalName() with getName()
    - POLICY-1652   Move PapRestServer to policy/common
    - POLICY-1732   Enable maven-checkstyle-plugin in apex-pdp
    - POLICY-1737   Upgrade oParent 2.0.0 - change daily jobs to staging jobs
    - POLICY-1742   Make HTTP return code handling configurable in APEX
    - POLICY-1743   Make URL configurable in REST Requestor and REST Client
    - POLICY-1744   Remove topic.properties and incorporate into overall properties
    - POLICY-1770   PAP REST API for PDPGroup Healthcheck
    - POLICY-1771   Boost policy/api JUnit code coverage
    - POLICY-1772   Boost policy/xacml-pdp JUnit code coverage
    - POLICY-1773   Enhance the policy/xacml-pdp S3P Stability and Performance tests
    - POLICY-1784   Better Handling of "version" field value with clients
    - POLICY-1785   Deploy same policy with a new version simply adds to the list
    - POLICY-1786   Create a simple way to populate the guard database for testing
    - POLICY-1791   Address Sonar issues in new policy repos
    - POLICY-1795   PAP: bounced apex and xacml pdps show deleted instance in pdp status through APIs.
    - POLICY-1800   API|PAP components use different version formats
    - POLICY-1805   Build up stability test for api component to follow S3P requirements
    - POLICY-1806   Build up S3P performance test for api component
    - POLICY-1847   Add control loop coordination as a preloaded policy type
    - POLICY-1871   Change policy/distribution to support ToscaPolicyType & ToscaPolicy
    - POLICY-1881   Upgrade policy/distribution to latest SDC artifacts
    - POLICY-1885   Apex-pdp: Extend CLIEditor to generate policy in ToscaServiceTemplate format
    - POLICY-1898   Move apex-pdp & distribution documents to policy/parent
    - POLICY-1942   Boost policy/apex-pdp JUnit code coverage
    - POLICY-1953   Create addTopic taking BusTopicParams instead of Properties in policy/endpoints

    * Additional items delivered with the release.

    - POLICY-1637   Remove "version" from PdpGroup
    - POLICY-1653   Remove isNullVersion() method
    - POLICY-1966   Fix more sonar issues in policy drools
    - POLICY-1988   Generate El Alto AAF Certificates

    * [POLICY-1823] - This epic covers the work to develop features that will be deployed dark in El Alto.

    - POLICY-1762   Create CDS API model implementation
    - POLICY-1763   Create CDS Actor
    - POLICY-1899   Update optimization xacml application to support more flexible Decision API
    - POLICY-1911   XACML PDP must be able to retrieve Policy Type from API


**Bug Fixes**

The following bug fixes have been deployed with this release:

    * `[POLICY-1671] <https://lf-onap.atlassian.net/browse/POLICY-1671>`_ - policy/engine JUnit tests now take over 30 minutes to run
    * `[POLICY-1725] <https://lf-onap.atlassian.net/browse/POLICY-1725>`_ - XACML PDP returns 500 vs 400 for bad syntax JSON
    * `[POLICY-1793] <https://lf-onap.atlassian.net/browse/POLICY-1793>`_ - API|MODELS: Retrieving Legacy Operational Policy as a Tosca Policy with wrong version
    * `[POLICY-1795] <https://lf-onap.atlassian.net/browse/POLICY-1795>`_ - PAP: bounced apex and xacml pdps show deleted instance in pdp status through APIs.
    * `[POLICY-1800] <https://lf-onap.atlassian.net/browse/POLICY-1800>`_ - API|PAP components use different version formats
    * `[POLICY-1802] <https://lf-onap.atlassian.net/browse/POLICY-1802>`_ - Apex-pdp: context album is mandatory for policy model to compile
    * `[POLICY-1803] <https://lf-onap.atlassian.net/browse/POLICY-1803>`_ - PAP should undeploy policies when subgroup is deleted
    * `[POLICY-1807] <https://lf-onap.atlassian.net/browse/POLICY-1807>`_ - Latest version is always returned when using the endpoint to retrieve all versions of a particular policy
    * `[POLICY-1808] <https://lf-onap.atlassian.net/browse/POLICY-1808>`_ - API|PAP|PDP-X [new] should publish docker images with the following tag X.Y-SNAPSHOT-latest
    * `[POLICY-1810] <https://lf-onap.atlassian.net/browse/POLICY-1810>`_ - API: support "../deployed" REST API (URLs) for legacy policies
    * `[POLICY-1811] <https://lf-onap.atlassian.net/browse/POLICY-1811>`_ - The endpoint of retrieving the latest version of TOSCA policy does not return the latest one, especially when there are double-digit versions
    * `[POLICY-1818] <https://lf-onap.atlassian.net/browse/POLICY-1818>`_ - APEX does not allow arbitrary Kafka parameters to be specified
    * `[POLICY-1838] <https://lf-onap.atlassian.net/browse/POLICY-1838>`_ - Drools-pdp error log is missing data in ErrorDescription field
    * `[POLICY-1839] <https://lf-onap.atlassian.net/browse/POLICY-1839>`_ - Policy Model  currently needs to be escaped
    * `[POLICY-1843] <https://lf-onap.atlassian.net/browse/POLICY-1843>`_ - Decision API not returning monitoring policies when calling api with policy-type
    * `[POLICY-1844] <https://lf-onap.atlassian.net/browse/POLICY-1844>`_ - XACML PDP does not update policy statistics
    * `[POLICY-1858] <https://lf-onap.atlassian.net/browse/POLICY-1858>`_ - Usecase DRL - named query should not be invoked
    * `[POLICY-1859] <https://lf-onap.atlassian.net/browse/POLICY-1859>`_ - Drools rules should not timeout when given timeout=0 - should be treated as infinite
    * `[POLICY-1872] <https://lf-onap.atlassian.net/browse/POLICY-1872>`_ - brmsgw fails building a jar - trafficgenerator dependency does not exist
    * `[POLICY-2047] <https://lf-onap.atlassian.net/browse/POLICY-2047>`_ - TOSCA Policy Types should be map not a list
    * `[POLICY-2060] <https://lf-onap.atlassian.net/browse/POLICY-2060>`_ - ToscaProperties object is missing metadata field
    * `[POLICY-2156] <https://lf-onap.atlassian.net/browse/POLICY-2156>`_ - missing field in create VF module request to SO


**Security Notes**

*Fixed Security Issues*


    * `[POLICY-2115] <https://lf-onap.atlassian.net/browse/POLICY-2115>`_ - Upgrade org.jgroups : jgroups : 4.0.12.Final
    * `[POLICY-2084] <https://lf-onap.atlassian.net/browse/POLICY-2084>`_ - Investigate pip (py2.py3-none-any) 9.0.1 (.whl) in apex-pdp
    * `[POLICY-2072] <https://lf-onap.atlassian.net/browse/POLICY-2072>`_ - Upgrade io.netty : netty-codec-http2 and netty-common to 4.1.39.Final
    * `[POLICY-2005] <https://lf-onap.atlassian.net/browse/POLICY-2005>`_ - Upgrade elastic search to 6.8.2
    * `[POLICY-2001] <https://lf-onap.atlassian.net/browse/POLICY-2001>`_ - Upgrade com.thoughtworks.xstream to 1.4.11.1
    * `[POLICY-2000] <https://lf-onap.atlassian.net/browse/POLICY-2000>`_ - Upgrade oparent 2.1.0-SNAPSHOT - to pull in jetty server to 9.4.20.v20190813
    * `[POLICY-1999] <https://lf-onap.atlassian.net/browse/POLICY-1999>`_ - Upgrade to httpcomponents httpclient 4.5.9
    * `[POLICY-1598] <https://lf-onap.atlassian.net/browse/POLICY-1598>`_ - mariadb container is outdated
    * `[POLICY-1597] <https://lf-onap.atlassian.net/browse/POLICY-1597>`_ - nexus container is outdated

*Known Security Issues*

*Known Vulnerabilities in Used Modules*

POLICY code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been addressed, items that remain open have been assessed for risk and determined to be false positive. The POLICY open Critical security vulnerabilities and their risk assessment have been documented as part of the `project (El Alto Release) <https://wiki.onap.org/pages/viewpage.action?pageId=68541992>`_.

Quick Links:
    - `POLICY project page`_
    - `Passing Badge information for POLICY`_
    - `Project Vulnerability Review Table for POLICY (El Alto Release) <https://wiki.onap.org/pages/viewpage.action?pageId=68541992>`_

**Known Issues**

The following known issues will be addressed in a future release:

    * `[POLICY-1276] <https://lf-onap.atlassian.net/browse/POLICY-1276>`_ - JRuby interpreter shutdown fails on second and subsequent runs
    * `[POLICY-1291] <https://lf-onap.atlassian.net/browse/POLICY-1291>`_ - Maven Error when building Apex documentation in Windows
    * `[POLICY-1578] <https://lf-onap.atlassian.net/browse/POLICY-1578>`_ - PAP pushPolicies.sh in startup fails due to race condition in some environments
    * `[POLICY-1832] <https://lf-onap.atlassian.net/browse/POLICY-1832>`_ - API|PAP: data race condition seem to appear sometimes when creating and deploying policy
    * `[POLICY-2103] <https://lf-onap.atlassian.net/browse/POLICY-2103>`_ - policy/distribution may need to re-synch if SDC gets reinstalled
    * `[POLICY-2062] <https://lf-onap.atlassian.net/browse/POLICY-2062>`_ - APEX PDP logs > 4G filled local storage
    * `[POLICY-2080] <https://lf-onap.atlassian.net/browse/POLICY-2080>`_ - drools-pdp JUnit fails intermittently in feature-active-standby-management
    * `[POLICY-2111] <https://lf-onap.atlassian.net/browse/POLICY-2111>`_ - PDP-D APPS: AAF Cadi conflicts with Aether libraries
    * `[POLICY-2158] <https://lf-onap.atlassian.net/browse/POLICY-2158>`_ - PAP loses synchronization with PDPs
    * `[POLICY-2159] <https://lf-onap.atlassian.net/browse/POLICY-2159>`_ - PAP console (legacy): cannot edit policies with GUI


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
        - POLICY-1195   Separate model code from drools-applications into other repositories
        - POLICY-1367   Spike - Experimentation for management of Drools templates and Operational Policies
        - POLICY-1397   PDP-D: NOOP Endpoints Support to test Operational Policies.
        - POLICY-1459   PDP-D [Control Loop] : Create a Control Loop flavored PDP-D image

    * [POLICY-1069] - This epic covers the work to harden the codebase for the Policy Framework project.
        - POLICY-1007   Remove Jackson from policy framework components
        - POLICY-1202   policy-engine & apex-pdp are using different version of eclipselink
        - POLICY-1250   Fix issues reported by sonar in policy modules
        - POLICY-1368   Remove hibernate from policy repos
        - POLICY-1457   Use Alpine in base docker images

    * [POLICY-1072] - This epic covers the work to support S3P Performance criteria.
        - S3P Performance related items

    * [POLICY-1171] - Enhance CLC Facility
        - POLICY-1173   High-level specification of coordination directives

    * [POLICY-1220] - This epic covers the work to support S3P Security criteria
        - POLICY-1538   Upgrade Elasticsearch to 6.4.x to clear security issue

    * [POLICY-1269] - R4 Dublin - ReBuild Policy Infrastructure
        - POLICY-1270   Policy Lifecycle API RESTful HealthCheck/Statistics Main Entry Point
        - POLICY-1271   PAP RESTful HealthCheck/Statistics Main Entry Point
        - POLICY-1272   Create the S3P JMeter tests for API, PAP, XACML (2nd Gen)
        - POLICY-1273   Policy Type Application Design Requirements
        - POLICY-1436   XACML PDP RESTful HealthCheck/Statistics Main Entry Point
        - POLICY-1440   XACML PDP RESTful Decision API Main Entry Point
        - POLICY-1441   Policy Lifecycle API RESTful Create/Read Main Entry Point for Policy Types
        - POLICY-1442   Policy Lifecycle API RESTful Create/Read Main Entry Point for Concrete Policies
        - POLICY-1443   PAP Dmaap PDP Register/UnRegister Main Entry Point
        - POLICY-1444   PAP Dmaap Policy Deploy/Undeploy Policies Main Entry Point
        - POLICY-1445   XACML PDP upgrade to xacml 2.0.0
        - POLICY-1446   Policy Lifecycle API RESTful Delete Main Entry Point for Policy Types
        - POLICY-1447   Policy Lifecycle API RESTful Delete Main Entry Point for Concrete Policies
        - POLICY-1449   XACML PDP Dmaap Register/UnRegister Functionality
        - POLICY-1451   XACML PDP Dmaap Deploy/UnDeploy Functionality
        - POLICY-1452   Apex PDP Dmaap Register/UnRegister Functionality
        - POLICY-1453   Apex PDP Dmaap Deploy/UnDeploy Functionality
        - POLICY-1454   Drools PDP Dmaap Register/UnRegister Functionality
        - POLICY-1455   Drools PDP Dmaap Deploy/UnDeploy Functionality
        - POLICY-1456   Policy Architecture and Roadmap Documentation
        - POLICY-1458   Create S3P JMeter Tests for Policy API
        - POLICY-1460   Create S3P JMeter Tests for PAP
        - POLICY-1461   Create S3P JMeter Tests for Policy XACML Engine (2nd Generation)
        - POLICY-1462   Create S3P JMeter Tests for Policy SDC Distribution
        - POLICY-1471   Policy Application Designer - Develop Guard and Control Loop Coordination Policy Type application
        - POLICY-1474   Modifications of Control Loop Operational Policy to support new Policy Lifecycle API
        - POLICY-1515   Prototype Policy Lifecycle API Swagger Entry Points
        - POLICY-1516   Prototype the Policy Decision API
        - POLICY-1541   PAP REST API for PDPGroup Query, Statistics & Delete
        - POLICY-1542   PAP REST API for PDPGroup Deployment, State Management & Health Check

    * [POLICY-1399] - This epic covers the work to support model drive control loop design as defined by the Control Loop Subcommittee
        - Model drive control loop related items

    * [POLICY-1404] - This epic covers the work to support the CCVPN Use Case for Dublin
        - POLICY-1405   Develop SDNC API for trigger bandwidth

    * [POLICY-1408] - This epic covers the work done with the Casablanca release
        - POLICY-1410   List Policy API
        - POLICY-1413   Dashboard enhancements
        - POLICY-1414   Push Policy and DeletePolicy API enhancement
        - POLICY-1416   Model enhancements to support CLAMP
        - POLICY-1417   Resiliency improvements
        - POLICY-1418   PDP APIs - make ClientAuth optional
        - POLICY-1419   Better multi-role support
        - POLICY-1420   Model enhancement to support embedded JSON
        - POLICY-1421   New audit data for push/delete
        - POLICY-1422   Enhanced encryption
        - POLICY-1423   Save original model file
        - POLICY-1427   Controller Logging Feature
        - POLICY-1489   PDP-D: Nested JSON Event Filtering support with JsonPath
        - POLICY-1499   Mdc Filter Feature

    * [POLICY-1438] - This epic covers the work to support 5G OOF PCI Use Case
        - POLICY-1463   Functional code changes in Policy for OOF SON use case
        - POLICY-1464   Config related aspects for OOF SON use case

    * [POLICY-1450] - This epic covers the work to support the Scale Out Use Case.
        - POLICY-1278   AAI named-queries are being deprecated and should be replaced with custom-queries
        - POLICY-1545   E2E Automation - Parse the newly added model ids from operation policy

    * Additional items delivered with the release.
        - POLICY-1159   Move expectException to policy-common/utils-test
        - POLICY-1176   Work on technical debt introduced by CLC POC
        - POLICY-1266   A&AI Modularity
        - POLICY-1274   further improvement in PSSD S3P test
        - POLICY-1401   Build onap.policies.Monitoring TOSCA Policy Template
        - POLICY-1465   Support configurable Heap Memory Settings for JVM processes


**Bug Fixes**

The following bug fixes have been deployed with this release:

    * `[POLICY-1241] <https://lf-onap.atlassian.net/browse/POLICY-1241>`_ - Test failure in drools-pdp if JAVA_HOME is not set
    * `[POLICY-1289] <https://lf-onap.atlassian.net/browse/POLICY-1289>`_ - Apex only considers 200 response codes as successful result codes
    * `[POLICY-1437] <https://lf-onap.atlassian.net/browse/POLICY-1437>`_ - Fix issues in FileSystemReceptionHandler of policy-distribution component
    * `[POLICY-1501] <https://lf-onap.atlassian.net/browse/POLICY-1501>`_ - policy-engine JUnit tests are not independent
    * `[POLICY-1627] <https://lf-onap.atlassian.net/browse/POLICY-1627>`_ - APEX does not support specification of a partitioner class for Kafka

**Security Notes**

*Fixed Security Issues*

    * `[OJSI-117] <https://lf-onap.atlassian.net/browse/OJSI-117>`_ - In default deployment POLICY (nexus) exposes HTTP port 30236 outside of cluster.
    * `[OJSI-157] <https://lf-onap.atlassian.net/browse/OJSI-157>`_ - In default deployment POLICY (policy-api) exposes HTTP port 30240 outside of cluster.
    * `[OJSI-118] <https://lf-onap.atlassian.net/browse/OJSI-118>`_ - In default deployment POLICY (policy-apex-pdp) exposes HTTP port 30237 outside of cluster.
    * `[OJSI-184] <https://lf-onap.atlassian.net/browse/OJSI-184>`_ - In default deployment POLICY (brmsgw) exposes HTTP port 30216 outside of cluster.

*Known Security Issues*

*Known Vulnerabilities in Used Modules*

POLICY code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been addressed, items that remain open have been assessed for risk and determined to be false positive. The POLICY open Critical security vulnerabilities and their risk assessment have been documented as part of the `project (Dublin Release) <https://wiki.onap.org/pages/viewpage.action?pageId=54723253>`_.

Quick Links:
    - `POLICY project page`_
    - `Passing Badge information for POLICY`_
    - `Project Vulnerability Review Table for POLICY (Dublin Release) <https://wiki.onap.org/pages/viewpage.action?pageId=54723253>`_


**Known Issues**

The following known issues will be addressed in a future release:

    * `[POLICY-1795] - <https://lf-onap.atlassian.net/browse/POLICY-1795>`_ PAP: bounced apex and xacml pdps show deleted instance in pdp status through APIs.
    * `[POLICY-1810] - <https://lf-onap.atlassian.net/browse/POLICY-1810>`_ API: ensure that the REST APISs (URLs) are supported and consistent regardless the type of policy: operational, guard, tosca-compliant.
    * `[POLICY-1277] - <https://lf-onap.atlassian.net/browse/POLICY-1277>`_ policy config takes too long time to become retrievable in PDP
    * `[POLICY-1378] - <https://lf-onap.atlassian.net/browse/POLICY-1378>`_ add support to append value into policyScope while one policy could be used by several services
    * `[POLICY-1650] - <https://lf-onap.atlassian.net/browse/POLICY-1650>`_ Policy UI doesn't show left menu or any content
    * `[POLICY-1671] - <https://lf-onap.atlassian.net/browse/POLICY-1671>`_ policy/engine JUnit tests now take over 30 minutes to run
    * `[POLICY-1725] - <https://lf-onap.atlassian.net/browse/POLICY-1725>`_ XACML PDP returns 500 vs 400 for bad syntax JSON
    * `[POLICY-1793] - <https://lf-onap.atlassian.net/browse/POLICY-1793>`_ API|MODELS: Retrieving Legacy Operational Policy as a Tosca Policy with wrong version
    * `[POLICY-1800] - <https://lf-onap.atlassian.net/browse/POLICY-1800>`_ API|PAP components use different version formats
    * `[POLICY-1802] - <https://lf-onap.atlassian.net/browse/POLICY-1802>`_ Apex-pdp: context album is mandatory for policy model to compile
    * `[POLICY-1808] - <https://lf-onap.atlassian.net/browse/POLICY-1808>`_ API|PAP|PDP-X [new] should publish docker images with the following tag X.Y-SNAPSHOT-latest
    * `[POLICY-1818] - <https://lf-onap.atlassian.net/browse/POLICY-1818>`_ APEX does not allow arbitrary Kafka parameters to be specified
    * `[POLICY-1276] - <https://lf-onap.atlassian.net/browse/POLICY-1276>`_ JRuby interpreter shutdown fails on second and subsequent runs
    * `[POLICY-1803] - <https://lf-onap.atlassian.net/browse/POLICY-1803>`_ PAP should undeploy policies when subgroup is deleted
    * `[POLICY-1291] - <https://lf-onap.atlassian.net/browse/POLICY-1291>`_ Maven Error when building Apex documentation in Windows
    * `[POLICY-1872] - <https://lf-onap.atlassian.net/browse/POLICY-1872>`_ brmsgw fails building a jar - trafficgenerator dependency does not exist


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

    * `[POLICY-1650] <https://lf-onap.atlassian.net/browse/POLICY-1277>`_ - Policy UI doesn't show left menu or any content

A workaround for this issue consists in bypassing the Portal UI when accessing the Policy UI. See the **PAP recipes**
documentation for the specific procedure.


Version: 3.0.1
--------------

:Release Date: 2019-01-31 (Casablanca Maintenance Release)

The following items were deployed with the Casablanca Maintenance Release:

**New Features**

    * [POLICY-1221] - Policy distribution application to support HTTPS communication
    * [POLICY-1222] - Apex policy PDP to support HTTPS Communication

**Bug Fixes**

    * `[POLICY-1282] <https://lf-onap.atlassian.net/browse/POLICY-1282>`_ - Policy format with some problems
    * `[POLICY-1395] <https://lf-onap.atlassian.net/browse/POLICY-1395>`_ - Apex PDP does not preserve context on model upgrade


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

    * `[POLICY-799] <https://lf-onap.atlassian.net/browse/POLICY-799>`_ - Policy API Validation Does Not Validate Required Parent Attributes in the Model
    * `[POLICY-869] <https://lf-onap.atlassian.net/browse/POLICY-869>`_ - Control Loop Drools Rules should not have exceptions as well as die upon an exception
    * `[POLICY-872] <https://lf-onap.atlassian.net/browse/POLICY-872>`_ - investigate potential race conditions during rules version upgrades during call loads
    * `[POLICY-878] <https://lf-onap.atlassian.net/browse/POLICY-878>`_ - pdp-d: feature-pooling disables policy-controllers preventing processing of onset events
    * `[POLICY-909] <https://lf-onap.atlassian.net/browse/POLICY-909>`_ - get_ZoneDictionaryDataByName class type error
    * `[POLICY-920] <https://lf-onap.atlassian.net/browse/POLICY-920>`_ - Hard-coded path in junit test
    * `[POLICY-921] <https://lf-onap.atlassian.net/browse/POLICY-921>`_ - XACML Junit test cannot find property file
    * `[POLICY-1083] <https://lf-onap.atlassian.net/browse/POLICY-1083>`_ - Mismatch in action cases between Policy and APPC


**Security Notes**

POLICY code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been addressed, items that remain open have been assessed for risk and determined to be false positive. The POLICY open Critical security vulnerabilities and their risk assessment have been documented as part of the `project (Casablanca Release) <https://wiki.onap.org/pages/viewpage.action?pageId=45300864>`_.

Quick Links:
    - `POLICY project page`_
    - `Passing Badge information for POLICY`_
    - `Project Vulnerability Review Table for POLICY (Casablanca Release) <https://wiki.onap.org/pages/viewpage.action?pageId=45300864>`_

**Known Issues**

    * `[POLICY-1277] <https://lf-onap.atlassian.net/browse/POLICY-1277>`_ - policy config takes too long time to become retrievable in PDP
    * `[POLICY-1282] <https://lf-onap.atlassian.net/browse/POLICY-1282>`_ - Policy format with some problems



..      =======================
..      * * *   BEIJING   * * *
..      =======================

Version: 2.0.0
--------------

:Release Date: 2018-06-07 (Beijing Release)

**New Features**

The Beijing release for POLICY delivered the following Epics. For a full list of stories and tasks delivered in the Beijing release, refer to `JiraPolicyBeijing`_.

    * [POLICY-390] - This epic covers the work to harden the Policy platform software base (incl 50% JUnit coverage)
        - POLICY-238    policy/drools-applications: clean up maven structure
        - POLICY-336    Address Technical Debt
        - POLICY-338    Address JUnit Code Coverage
        - POLICY-377    Policy Create API should validate input matches DCAE microservice template
        - POLICY-389    Cleanup Jenkin's CI/CD process's
        - POLICY-449    Policy API + Console : Common Policy Validation
        - POLICY-568    Integration with org.onap AAF project
        - POLICY-610    Support vDNS scale out for multiple times in Beijing release

    * [POLICY-391] - This epic covers the work to support Release Planning activities
        - POLICY-552    ONAP Licensing Scan - Use Restrictions

    * [POLICY-392] - Platform Maturity Requirements - Performance Level 1
        - POLICY-529    Platform Maturity Performance - Drools PDP
        - POLICY-567    Platform Maturity Performance - PDP-X

    * [POLICY-394] - This epic covers the work required to support a Policy developer environment in which Policy Developers can create, update policy templates/rules separate from the policy Platform runtime platform.
        - POLICY-488    pap should not add rules to official template provided in drools applications

    * [POLICY-398] - This epic covers the body of work involved in supporting policy that is platform specific.
        - POLICY-434    need PDP /getConfig to return an indicator of where to find the config data - in config.content versus config field

    * [POLICY-399] - This epic covers the work required to policy enable Hardware Platform Enablement
        - POLICY-622    Integrate OOF Policy Model into Policy Platform

    * [POLICY-512] - This epic covers the work to support Platform Maturity Requirements - Stability Level 1
        - POLICY-525    Platform Maturity Stability - Drools PDP
        - POLICY-526    Platform Maturity Stability - XACML PDP

    * [POLICY-513] - Platform Maturity Requirements - Resiliency Level 2
        - POLICY-527    Platform Maturity Resiliency - Policy Engine GUI and PAP
        - POLICY-528    Platform Maturity Resiliency - Drools PDP
        - POLICY-569    Platform Maturity Resiliency - BRMS Gateway
        - POLICY-585    Platform Maturity Resiliency - XACML PDP
        - POLICY-586    Platform Maturity Resiliency - Planning
        - POLICY-681    Regression Test Use Cases

    * [POLICY-514] - This epic covers the work to support Platform Maturity Requirements - Security Level 1
        - POLICY-523    Platform Maturity Security - CII Badging - Project Website

    * [POLICY-515] - This epic covers the work to support Platform Maturity Requirements - Escalability Level 1
        - POLICY-531    Platform Maturity Scalability - XACML PDP
        - POLICY-532    Platform Maturity Scalability - Drools PDP
        - POLICY-623    Docker image re-design

    * [POLICY-516] - This epic covers the work to support Platform Maturity Requirements - Manageability Level 1
        - POLICY-533    Platform Maturity Manageability L1 - Logging
        - POLICY-534    Platform Maturity Manageability - Instantiation < 1 hour

    * [POLICY-517] - This epic covers the work to support Platform Maturity Requirements - Usability Level 1
        - POLICY-535    Platform Maturity Usability - User Guide
        - POLICY-536    Platform Maturity Usability - Deployment Documentation
        - POLICY-537    Platform Maturity Usability - API Documentation

    * [POLICY-546] - R2 Beijing - Various enhancements requested by clients to the way we handle TOSCA models.


**Bug Fixes**

The following bug fixes have been deployed with this release:

    * `[POLICY-484] <https://lf-onap.atlassian.net/browse/POLICY-484>`_ - Extend election handler run window and clean up error messages
    * `[POLICY-494] <https://lf-onap.atlassian.net/browse/POLICY-494>`_ - POLICY EELF Audit.log not in ECOMP Standards Compliance
    * `[POLICY-501] <https://lf-onap.atlassian.net/browse/POLICY-501>`_ - Fix issues blocking election handler and add directed interface for opstate
    * `[POLICY-509] <https://lf-onap.atlassian.net/browse/POLICY-509>`_ - Add IntelliJ file to .gitingore
    * `[POLICY-510] <https://lf-onap.atlassian.net/browse/POLICY-510>`_ - Do not enforce hostname validation
    * `[POLICY-518] <https://lf-onap.atlassian.net/browse/POLICY-518>`_ - StateManagement creation of EntityManagers.
    * `[POLICY-519] <https://lf-onap.atlassian.net/browse/POLICY-519>`_ - Correctly initialize the value of allSeemsWell in DroolsPdpsElectionHandler
    * `[POLICY-629] <https://lf-onap.atlassian.net/browse/POLICY-629>`_ - Fixed a bug on editor screen
    * `[POLICY-684] <https://lf-onap.atlassian.net/browse/POLICY-684>`_ - Fix regex for brmsgw dependency handling
    * `[POLICY-707] <https://lf-onap.atlassian.net/browse/POLICY-707>`_ - ONAO-PAP-REST unit tests fail on first build on clean checkout
    * `[POLICY-717] <https://lf-onap.atlassian.net/browse/POLICY-717>`_ - Fix a bug in checking required fields if the object has include function
    * `[POLICY-734] <https://lf-onap.atlassian.net/browse/POLICY-734>`_ - Fix Fortify Header Manipulation Issue
    * `[POLICY-743] <https://lf-onap.atlassian.net/browse/POLICY-743>`_ - Fixed data name since its name was changed on server side
    * `[POLICY-753] <https://lf-onap.atlassian.net/browse/POLICY-753>`_ - Policy Health Check failed with multi-node cluster
    * `[POLICY-765] <https://lf-onap.atlassian.net/browse/POLICY-765>`_ - junit test for guard fails intermittently


**Security Notes**

POLICY code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been addressed, items that remain open have been assessed for risk and determined to be false positive. The POLICY open Critical security vulnerabilities and their risk assessment have been documented as part of the `project <https://wiki.onap.org/pages/viewpage.action?pageId=25437092>`_.

Quick Links:
    - `POLICY project page`_
    - `Passing Badge information for POLICY`_
    - `Project Vulnerability Review Table for POLICY <https://wiki.onap.org/pages/viewpage.action?pageId=25437092>`_

**Known Issues**

The following known issues will be addressed in a future release:

    * `[POLICY-522] <https://lf-onap.atlassian.net/browse/POLICY-522>`_ - PAP REST APIs undesired HTTP response body for 500 responses
    * `[POLICY-608] <https://lf-onap.atlassian.net/browse/POLICY-608>`_ - xacml components : remove hardcoded secret key from source code
    * `[POLICY-764] <https://lf-onap.atlassian.net/browse/POLICY-764>`_ - Policy Engine PIP Configuration JUnit Test fails intermittently
    * `[POLICY-776] <https://lf-onap.atlassian.net/browse/POLICY-776>`_ - OOF Policy TOSCA models are not correctly rendered
    * `[POLICY-799] <https://lf-onap.atlassian.net/browse/POLICY-799>`_ - Policy API Validation Does Not Validate Required Parent Attributes in the Model
    * `[POLICY-801] <https://lf-onap.atlassian.net/browse/POLICY-801>`_ - fields mismatch for OOF flavorFeatures between implementation and wiki
    * `[POLICY-869] <https://lf-onap.atlassian.net/browse/POLICY-869>`_  - Control Loop Drools Rules should not have exceptions as well as die upon an exception
    * `[POLICY-872] <https://lf-onap.atlassian.net/browse/POLICY-872>`_  - investigate potential race conditions during rules version upgrades during call loads




Version: 1.0.2
--------------

:Release Date: 2018-01-18 (Amsterdam Maintenance Release)

**Bug Fixes**

The following fixes were deployed with the Amsterdam Maintenance Release:

    * `[POLICY-486] <https://lf-onap.atlassian.net/browse/POLICY-486>`_ - pdp-x api pushPolicy fails to push latest version


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

.. _JiraPolicyElAlto: https://lf-onap.atlassian.net/secure/ReleaseNote.jspa?projectId=10106&version=10728
.. _JiraPolicyDublin: https://lf-onap.atlassian.net/secure/ReleaseNote.jspa?projectId=10106&version=10464
.. _JiraPolicyCasablanca: https://lf-onap.atlassian.net/secure/ReleaseNote.jspa?projectId=10106&version=10446
.. _JiraPolicyBeijing: https://lf-onap.atlassian.net/secure/ReleaseNote.jspa?projectId=10106&version=10349
.. _JiraPolicyAmsterdam: https://lf-onap.atlassian.net/secure/ReleaseNote.jspa?projectId=10106&version=10300

.. Links to Project related pages

.. _POLICY project page: https://wiki.onap.org/display/DW/Policy+Framework+Project
.. _Passing Badge information for POLICY: https://bestpractices.coreinfrastructure.org/en/projects/1614


.. note
..      CHANGE  HISTORY
..  09/19/2019 - Updated for El Alto Release.
..  05/16/2019 - Updated for Dublin Release.
..      01/17/2019 - Updated for Casablanca Maintenance Release.
..      11/19/2018 - Updated for Casablanca.  Also, fixed bugs is a list of bugs where the "Affected Version" is Beijing.
..      Changed version number to use ONAP versions.
..      10/08/2018 - Initial document for Casablanca release.
..  05/29/2018 - Information for Beijing release.
..      03/22/2018 - Initial document for Beijing release.
..      01/15/2018 - Added change for version 1.1.3 to the Amsterdam branch.  Also corrected prior version (1.2.0) to (1.1.1)
..      Also, Set up initial information for Beijing.
..      Excluded POLICY-454 from bug list since it doesn't apply to Beijing per Jorge.


End of Release Notes

.. How to notes for SS
..  For initial document: list epic and user stories for each, list user stories with no epics.
..      For Bugs section, list bugs where Affected Version is a prior release (Casablanca, Beijing etc), Fixed Version is the current release (Dublin), Resolution is done.
..      For Known issues, list bugs that are slotted for a future release.
