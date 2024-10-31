.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (c) 2017-2020 AT&T Intellectual Property.  All rights reserved.
.. _clamp-pre-migration-release-notes:

Pre Migration (Guilin and earlier) Release Notes for CLAMP
==========================================================

.. warning:: The CLAMP project was migrated to policy-clamp in the Policy Framework in the Honolulu release. For CLAMP release notes for the Hinolulu and subsequent
             releases, please see the policy-clamp related release notes in the :ref:`POLICY Framework Release Notes<release_notes>`

Version: 5.1.0 (Guilin)
-----------------------

:Release Date: 2020-11-19

**New Features**

The Guilin release of the Control Loop Automation Management Platform (CLAMP).

The main goal of the Guilin release was to:

    - Complete integration to CDS for Actor/Action selection.
    - SECCOM Perform Software Composition Analysis - Vulnerability tables (TSC must have).
    - SECCOM Password removal from OOM HELM charts (TSC must have) - implementation of certinInitializer to get AAF certificates at oom deployment time.

**Bug Fixes**

	- The full list of implemented user stories and epics is available on `CLAMP R7 - M1 release planning <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16430687/CLAMP+R7+-+M1+Release+Planning>`_
	- The full list of issues(bugs) solved, is available on `CLAMP R7 - Guilin list of solved issues(bugs) <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16450689/CLAMP+R7+-+Guilin+list+of+solved+issues+bugs>`_

**Known Issues**

**Security Notes**

*Fixed Security Issues*

*Known Security Issues*

*Known Vulnerabilities in Used Modules*

CLAMP code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been addressed, items that remain open have been assessed for risk and actions to be taken in future release.

Quick Links:
 	- `CLAMP project page <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16230605/CLAMP+Project>`_

 	- `Passing Badge information for CLAMP <https://bestpractices.coreinfrastructure.org/en/projects/1197>`_

**Upgrade Notes**

    - The Upgrade strategy for Guilin can be found here:`<https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16417801/Frankfurt+CLAMP+Container+upgrade+strategy>`_
    - New Docker Containers are available. the list of containers composing this release are below:
       - clamp-backend: nexus3.onap.org:10001/onap/clamp-backend 5.1.5
       - clamp-frontend: nexus3.onap.org:10001/onap/clamp-frontend 5.1.5
       - clamp-dash-es: nexus3.onap.org:10001/onap/clamp-dashboard-elasticsearch 5.0.4
       - clamp-dash-kibana: nexus3.onap.org:10001/onap/clamp-dashboard-kibana 5.0.4
       - clamp-dash-logstash: nexus3.onap.org:10001/onap/clamp-dashboard-logstash 5.0.4


Version: 5.0.7 (Frankfurt maintenance release tag 6.0.0)
--------------------------------------------------------

:Release Date: 2020-08-17

**Bug Fixes**

	- `CLAMP-878 <https://lf-onap.atlassian.net/browse/CLAMP-885>`_ Clamp backend pod fails with mariaDB server error
	- `CLAMP-885 <https://lf-onap.atlassian.net/browse/CLAMP-885>`_ CLAMP update documentation

**Known Issues**
    - `CLAMP-856 <https://lf-onap.atlassian.net/browse/CLAMP-856>`_ CLAMP should not display all CDS workflow properties
    - Other more minor issues are captured in the following page:`CLAMP known Frankfurt issues <https://wiki.onap.org/display/DW/CLAMP+R6+-+Frankfurt+known+issues%28bugs%29+-+to+be+solved+in+futur+Releases>`_

**Security Notes**

N/A

*Fixed Security Issues*

*Known Security Issues*

*Known Vulnerabilities in Used Modules*

CLAMP code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been addressed, items that remain open have been assessed for risk and actions to be taken in future release.

Quick Links:
 	- `CLAMP project page <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16230605/CLAMP+Project>`_
 	- `Passing Badge information for CLAMP <https://bestpractices.coreinfrastructure.org/en/projects/1197>`_

**Upgrade Notes**

    - The Upgrade strategy for Frankfurt can be found here:`<https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16417801/Frankfurt+CLAMP+Container+upgrade+strategy>`_
    - New Docker Containers are available. the list of containers composing this release are below:

       - clamp-backend-filebeat-onap: docker.elastic.co/beats/filebeat 5.5.0
       - clamp-backend: nexus3.onap.org:10001/onap/clamp-backend 5.0.7
       - clamp-frontend: nexus3.onap.org:10001/onap/clamp-frontend 5.0.7
       - clamp-dash-es: nexus3.onap.org:10001/onap/clamp-dashboard-elasticsearch 5.0.3
       - clamp-dash-kibana: nexus3.onap.org:10001/onap/clamp-dashboard-kibana 5.0.3
       - clamp-dash-logstash: nexus3.onap.org:10001/onap/clamp-dashboard-logstash 5.0.3

Version: 5.0.1 (Frankfurt)
--------------------------

:Release Date: 2020-05-12

**New Features**

The Frankfurt release is the seventh release of the Control Loop Automation Management Platform (CLAMP).

The main goal of the Frankfurt release was to:

    - implementing a new Control Loop creation flow: Self Serve Control Loop(partially done will be continued in next release).
    - Add Tosca policy-model support for Operational Policies definitions.
    - Add integration to CDS for Actor/Action selection.
    - Move from SearchGuard to OpenDistro.
    - Document(high level) current upgrade component strategy (TSC must have).
    - SECCOM Perform Software Composition Analysis - Vulnerability tables (TSC must have).
    - SECCOM Password removal from OOM HELM charts (TSC must have).
    - SECCOM HTTPS communication vs. HTTP (TSC must have)

**Bug Fixes**

	- The full list of implemented user stories and epics is available on `Frankfurt CLAMP M1 release planning <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16397735/CLAMP+R6+-+M1+Release+Planning>`_
	- The full list of issues(bugs) solved, is available on `CLAMP R6 - Frankfurt list of solved issues(bugs) <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16426873/CLAMP+R6+-+Frankfurt+list+of+solved+issues+bugs>`_

**Known Issues**
    - `CLAMP-856 <https://lf-onap.atlassian.net/browse/CLAMP-856>`_ CLAMP should not display all CDS workflow properties

**Security Notes**

*Fixed Security Issues*

*Known Security Issues*

*Known Vulnerabilities in Used Modules*

CLAMP code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been addressed, items that remain open have been assessed for risk and actions to be taken in future release.

Quick Links:
 	- `CLAMP project page <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16230605/CLAMP+Project>`_

 	- `Passing Badge information for CLAMP <https://bestpractices.coreinfrastructure.org/en/projects/1197>`_

**Upgrade Notes**

    - The Upgrade strategy for Frankfurt can be found here:`<https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16417801/Frankfurt+CLAMP+Container+upgrade+strategy>`_
    - New Docker Containers are available. the list of containers composing this release are below:
      - clamp-backend-filebeat-onap: docker.elastic.co/beats/filebeat 5.5.0
      - clamp-backend: nexus3.onap.org:10001/onap/clamp-backend 5.0.6
      - clamp-frontend: nexus3.onap.org:10001/onap/clamp-frontend 5.0.6
      - clamp-dash-es: nexus3.onap.org:10001/onap/clamp-dashboard-elasticsearch 5.0.3
      - clamp-dash-kibana: nexus3.onap.org:10001/onap/clamp-dashboard-kibana 5.0.3
      - clamp-dash-logstash: nexus3.onap.org:10001/onap/clamp-dashboard-logstash 5.0.3


Version: 4.1.3 (El-Alto)
------------------------

:Release Date: 2019-10-11

**New Features**

The El Alto release is the sixth release of the Control Loop Automation Management Platform (CLAMP).

The main goal of the El Alto release was to:

    - _.Fix a maximum a security issues, especially the angular related issues by moving to React.

**Bug Fixes**

	- The full list of implemented user stories and epics is available
	  This includes the list of bugs that were fixed during the course of this release.

**Known Issues**

    - `CLAMP-506 <https://lf-onap.atlassian.net/browse/CLAMP-506>`_ Elastic Search Clamp image cannot be built anymore(SearchGuard DMCA issue)
    - Due to the uncertainties with the DMCA SearchGuard issue, the ELK stack has been removed from El Alto release, meaning the CLAMP "Control Loop Dashboard" is not part of the El Alto release.
    - `CLAMP-519 <https://lf-onap.atlassian.net/browse/CLAMP-519>`_ Clamp cannot authenticate to AAF(Local authentication as workaround)


**Security Notes**

*Fixed Security Issues*

*Known Security Issues*

*Known Vulnerabilities in Used Modules*

CLAMP code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been addressed, items that remain open have been assessed for risk and actions to be taken in future release.
The CLAMP open Critical security vulnerabilities and their risk assessment have been documented as part of the `project in El Alto <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16399457/El+Alto+CLAMP+Security+Vulnerability+Report>`_.

Quick Links:
 	- `CLAMP project page <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16230605/CLAMP+Project>`_

 	- `Passing Badge information for CLAMP <https://bestpractices.coreinfrastructure.org/en/projects/1197>`_

 	- `Project Vulnerability Review Table for CLAMP (El Alto) <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16399457/El+Alto+CLAMP+Security+Vulnerability+Report>`_

**Upgrade Notes**

    New Docker Containers are available.


Version: 4.1.0 (El-Alto Early Drop)
-----------------------------------

:Release Date: 2019-08-19

**New Features**

The El Alto-Early Drop release is the fifth release of the Control Loop Automation Management Platform (CLAMP).

The main goal of the El Alto-Early Drop release was to:

    - _.Fix a maximum a security issues, especially the angular related issues by moving to React.

**Bug Fixes**

	- The full list of implemented user stories and epics is available on `CLAMP R5 - Early Drop RELEASE <https://wiki.onap.org/display/DW/CLAMP+R5+-+Early+Drop>`_
	  This includes the list of bugs that were fixed during the course of this release.

**Known Issues**

    - `CLAMP-384 <https://lf-onap.atlassian.net/browse/CLAMP-384>`_ Loop State in UI is not reflecting the current state

**Security Notes**

*Fixed Security Issues*

    - `OJSI-166 <https://lf-onap.atlassian.net/browse/OJSI-166>`_ Port 30290 exposes unprotected service outside of cluster.

*Known Security Issues*

*Known Vulnerabilities in Used Modules*

CLAMP code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been
addressed, items that remain open have been assessed for risk and actions to be taken in future release.
The CLAMP open Critical security vulnerabilities and their risk assessment have been documented as part of the
 `project in El Alto Early Drop <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16386513/CLAMP+R5+-+Early+Drop>`_.

Quick Links:
 	- `CLAMP project page <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16230605/CLAMP+Project>`_
 	- `Passing Badge information for CLAMP <https://bestpractices.coreinfrastructure.org/en/projects/1197>`_

**Upgrade Notes**

    New Docker Containers are available.



Version: 4.0.5 (Dublin)
-----------------------

:Release Date: 2019-06-06

**New Features**

The Dublin release is the fourth release of the Control Loop Automation Management Platform (CLAMP).

The main goal of the Dublin release was to:

    - Stabilize Platform maturity by stabilizing CLAMP maturity matrix see `Wiki for Dublin <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16337727/Dublin+Release+Platform+Maturity>`_.
    - CLAMP supports of Policy-model based Configuration Policy
    - CLAMP supports new Policy Engine direct Rest API (no longer based on jar provided by Policy Engine)
    - CLAMP main Core/UI have been reworked, removal of security issues reported by Nexus IQ.

**Bug Fixes**

	- The full list of implemented user stories and epics is available on `DUBLIN RELEASE <https://lf-onap.atlassian.net/projects/CLAMP/versions/10427>`_
	  This includes the list of bugs that were fixed during the course of this release.

**Known Issues**

    - `CLAMP-384 <https://lf-onap.atlassian.net/browse/CLAMP-384>`_ Loop State in UI is not reflecting the current state

**Security Notes**

*Fixed Security Issues*

    - `OJSI-128 <https://lf-onap.atlassian.net/browse/OJSI-128>`_ In default deployment CLAMP (clamp) exposes HTTP port 30258 outside of cluster.
    - `OJSI-147 <https://lf-onap.atlassian.net/browse/OJSI-147>`_ In default deployment CLAMP (cdash-kibana) exposes HTTP port 30290 outside of cluster.
    - `OJSI-152 <https://lf-onap.atlassian.net/browse/OJSI-152>`_ In default deployment CLAMP (clamp) exposes HTTP port 30295 outside of cluster.

*Known Security Issues*

*Known Vulnerabilities in Used Modules*

CLAMP code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been
addressed, items that remain open have been assessed for risk and actions to be taken in future release.
The CLAMP open Critical security vulnerabilities and their risk assessment have been documented as part of
the `project in Dublin <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16374261/Dublin+CLAMP+Security+Vulnerability+Report>`_.

Quick Links:
 	- `CLAMP project page <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16230605/CLAMP+Project>`_

 	- `Passing Badge information for CLAMP <https://bestpractices.coreinfrastructure.org/en/projects/1197>`_

 	- `Project Vulnerability Review Table for CLAMP (Dublin) <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16374261/Dublin+CLAMP+Security+Vulnerability+Report>`_

**Upgrade Notes**

    New Docker Containers are available.


Version: 3.0.4 - maintenance release
------------------------------------

:Release Date: 2019-04-06

**New Features**
none

**Bug Fixes**
none

**Known Issues**
CLAMP certificates have been renewed to extend their expiry dates

    - `CLAMP-335 <https://lf-onap.atlassian.net/browse/CLAMP-335>`_ Update Certificates on Casablanca release.


Version: 3.0.3 - maintenance release
------------------------------------

:Release Date: 2019-02-06

**New Features**
none

**Bug Fixes**
none

**Known Issues**
one documentation issue was fixed, this issue does not require a new docker image:

    - `CLAMP-257 <https://lf-onap.atlassian.net/browse/CLAMP-257>`_ User Manual for CLAMP : nothing on readthedocs.

Version: 3.0.3 (Casablanca)
---------------------------

:Release Date: 2018-11-30

**New Features**

The Casablanca release is the third release of the Control Loop Automation Management Platform (CLAMP).

The main goal of the Casablanca release was to:

    - Enhance Platform maturity by improving CLAMP maturity matrix see `Wiki for Casablanca <https://wiki.onap.org/display/DW/Casablanca+Release+Platform+Maturity>`_.
    - CLAMP Dashboard improvements for the monitoring of active Closed Loops
    - CLAMP logs alignment on the ONAP platform.
    - CLAMP is now integrated with AAF for authentication and permissions retrieval (AAF server is pre-loaded by default with the required permissions)
    - CLAMP improvement for configuring the policies (support of Scale Out use case)
    - CLAMP main Core/UI have been reworked, removal of security issues reported by Nexus IQ on JAVA/JAVASCRIPT code (Libraries upgrade or removal/replacement when possible)
    - As a POC, the javascript coverage can now be enabled in SONAR (Disabled for now)

**Bug Fixes**

	- The full list of implemented user stories and epics is available on `CASABLANCA RELEASE <https://lf-onap.atlassian.net/projects/CLAMP/versions/10408>`_
	  This includes the list of bugs that were fixed during the course of this release.

**Known Issues**

    - None

**Security Notes**

CLAMP code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been
addressed, items that remain open have been assessed for risk and actions to be taken in future release.
The CLAMP open Critical security vulnerabilities and their risk assessment have been documented as part of
the `project in Casablanca <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16315131/Casablanca+CLAMP+Security+Vulnerability+Report>`_.

Quick Links:
 	- `CLAMP project page <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16230605/CLAMP+Project>`_

 	- `Passing Badge information for CLAMP <https://bestpractices.coreinfrastructure.org/en/projects/1197>`_

 	- `Project Vulnerability Review Table for CLAMP in Casablanca <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16315131/Casablanca+CLAMP+Security+Vulnerability+Report>`_

**Upgrade Notes**

    New Docker Containers are available, an ELK stack is also now part of CLAMP deployments.

**Deprecation Notes**

    The CLAMP Designer Menu (in CLAMP UI) is deprecated since Beijing, the design time is being onboarded into SDC - DCAE D.

**Other**

    CLAMP Dashboard is now implemented, allows to monitor Closed Loops that are running by retrieving CL events on DMAAP.

**How to - Videos**

    https://wiki.onap.org/display/DW/CLAMP+videos

Version: 2.0.2 (Beijing)
------------------------

:Release Date: 2018-06-07

**New Features**

The Beijing release is the second release of the Control Loop Automation Management Platform (CLAMP).

The main goal of the Beijing release was to:

    - Enhance Platform maturity by improving CLAMP maturity matrix see `Wiki for Beijing <https://wiki.onap.org/display/DW/Beijing+Release+Platform+Maturity>`_.
    - Focus CLAMP on Closed loop runtime operations and control - this is reflected by the move of the design part to DCAE-D.
    - Introduce CLAMP Dashboard for monitoring of active Closed Loops.
    - CLAMP is integrated with MSB.
    - CLAMP has integrated SWAGGER.
    - CLAMP main Core has been reworked for improved flexibility.

**Bug Fixes**

	- The full list of implemented user stories and epics is available on `BEIJING RELEASE <https://lf-onap.atlassian.net/projects/CLAMP/versions/10314>`_
	  This includes the list of bugs that were fixed during the course of this release.

**Known Issues**

    - `CLAMP-69 <https://lf-onap.atlassian.net/browse/CLAMP-69>`_ Deploy action does not always work.

        The "Deploy" action does not work directly after submitting it.

        Workaround:

        You have to close the CL and reopen it again. In that case the Deploy action will do something.

**Security Notes**

CLAMP code has been formally scanned during build time using NexusIQ and all Critical vulnerabilities have been 
addressed, items that remain open have been assessed for risk and determined to be false positive. 
The CLAMP open Critical security vulnerabilities and their risk assessment have been documented as part of 
the `project in Beijing <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16275671/CLAMP+R2+-+Security+Vulnerability+Threat+Analysis>`_.

Quick Links:
 	- `CLAMP project page <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16230605/CLAMP+Project>`_

 	- `Passing Badge information for CLAMP <https://bestpractices.coreinfrastructure.org/en/projects/1197>`_

 	- `Project Vulnerability Review Table for CLAMP (Beijing) <https://lf-onap.atlassian.net/wiki/spaces/DW/pages/16275671/CLAMP+R2+-+Security+Vulnerability+Threat+Analysis>`_

**Upgrade Notes**

    New Docker Containers are available, an ELK stack is also now part of CLAMP deployments.

**Deprecation Notes**

    The CLAMP Designer UI is now deprecated and unavailable, the design time is being onboarded into SDC - DCAE D.

**Other**

    CLAMP Dashboard is now implemented, allows to monitor Closed Loops that are running by retrieving CL events on DMAAP.

Version: 1.1.0 (Amsterdam)
--------------------------

:Release Date: 2017-11-16

**New Features**

The Amsterdam release is the first release of the Control Loop Automation Management Platform (CLAMP).

The main goal of the Amsterdam release was to:

    - Support the automation of provisionning for the Closed loops of the vFW, vDNW and vCPE through TCA.
    - Support the automation of provisionning for the Closed loops of VVolte (Holmes)
    - Demonstrate complete interaction with Policy, DCAE, SDC and Holmes.

**Bug Fixes**

	- The full list of implemented user stories and epics is available on `AMSTERDAM RELEASE <https://lf-onap.atlassian.net/projects/CLAMP/versions/10313>`_
	  This is technically the first release of CLAMP, previous release was the seed code contribution.
	  As such, the defects fixed in this release were raised during the course of the release.
	  Anything not closed is captured below under Known Issues. If you want to review the defects fixed in the Amsterdam release, refer to Jira link above.

**Known Issues**
	- `CLAMP-68 <https://lf-onap.atlassian.net/browse/CLAMP-68>`_ ResourceVF not always provisioned.

        In Closed Loop -> Properties CL: When opening the popup window, the first service in the list does not show Resource-VF even though in SDC there is a resource instance in the service.

        Workaround:

        If you have multiple service available (if not create a dummy one on SDC), just click on another one and then click back on the first one in the list. The ResourceVF should be provisioned now.

    - `CLAMP-69 <https://lf-onap.atlassian.net/browse/CLAMP-69>`_ Deploy action does not always work.

        The "Deploy" action does not work directly after submitting it.

        Workaround:

        You have to close the CL and reopen it again. In that case the Deploy action will do something


**Security Issues**
	CLAMP is following the CII Best Practices Badge Program, results including security assesment can be found on the
	`project page <https://bestpractices.coreinfrastructure.org/projects/1197>`_


**Upgrade Notes**

    N/A

**Deprecation Notes**

    N/A

**Other**



===========

End of Release Notes
