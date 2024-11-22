.. _local-policy-label:

.. toctree::
   :maxdepth: 2

Policy Framework Component Local Execution
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This page will explain how to execute policy components locally using an IDE (IntelliJ/Eclipse) or using the command line.
The intention of this page is to outline how a developer can quickly execute a single component for testing purposes, alleviating the need to generate docker images per change to test in Docker/Kubernetes environments.

These instructions are for development purposes only.

Note: Run "mvn clean install" before bringing up the components using the methods outlined below.
Note: Running applications in the IDEs will require run configurations if shown below.

Policy API
**********

Eclipse
-------

    .. image:: images/policy-api-eclipse.png

IntelliJ
--------

    .. image:: images/policy-api-intellij.png

Command Line
------------

    .. code-block:: bash

        mvn spring-boot:run -Dspring-boot.run.arguments=”–server.port=8082”

Policy PAP
**********

Eclipse
-------

    .. image:: images/policy-pap-eclipse.png

IntelliJ
--------

    .. image:: images/policy-pap-intellij.png

Command Line
------------

    .. code-block:: bash

        mvn spring-boot:run -Dspring-boot.run.arguments=”–server.port=8082”

Apex-PDP
********

Eclipse
-------

    .. image:: images/apex-pdp-eclipse.png

IntelliJ
--------

    .. image:: images/apex-pdp-intellij.png

Command Line
------------

    .. code-block:: bash

        cd services/services-engine
        mvn -q -e clean compile exec:java -Dexec.mainClass="org.onap.policy.apex.service.engine.main.ApexMain" -Dexec.args="-p /PATH/TO/POLICY_FILE.json"

ACM-Runtime
***********

Eclipse
-------

    .. image:: images/acm-eclipse.png

IntelliJ
--------

    .. image:: images/acm-intellij.png

Command Line
------------

    .. code-block:: bash

        mvn spring-boot:run -Dspring-boot.run.arguments=”–server.port=8082”

XACML-PDP
*********

Eclipse
-------

    .. image:: images/xacml-pdp-eclipse.png

IntelliJ
--------

    .. image:: images/xacml-pdp-intellij.png

Command Line
------------

    .. code-block:: bash

        cd main
        mvn -q -e clean compile exec:java -Dexec.mainClass="org.onap.policy.pdpx.main.startstop.Main" -Dexec.args="-c /PATH/TO/XacmlPdpConfigParameters.json"

Drools-PDP
**********

Eclipse
-------

    .. image:: images/drools-pdp-eclipse.png

IntelliJ
--------

    .. image:: images/drools-pdp-intellij.png

Command Line
------------

    .. code-block:: bash

        cd policy-management
        mvn -q -e clean compile exec:java -Dexec.mainClass="org.onap.policy.drools.system.Main"

Policy Participant
******************

Eclipse
-------

    .. image:: images/policy-ppnt-eclipse.png

IntelliJ
--------

    .. image:: images/policy-ppnt-intellij.png

Command Line
------------

    .. code-block:: bash

        mvn spring-boot:run -Dspring-boot.run.arguments=”–server.port=8082”

Http Participant
****************

Eclipse
-------

Similar to above eclipse configuration for participant startup.

IntelliJ
--------

    .. image:: images/http-ppnt-intellij.png

Command Line
------------

    .. code-block:: bash

        mvn spring-boot:run -Dspring-boot.run.arguments=”–server.port=8082”

Kubernetes Participant
**********************

Eclipse
-------

Similar to above eclipse configuration for participant startup.

IntelliJ
--------

    .. image:: images/k8s-ppnt-intellij.png

Command Line
------------

    .. code-block:: bash

        mvn spring-boot:run -Dspring-boot.run.arguments=”–server.port=8082”

A1 Participant
**************

Eclipse
-------

Similar to above eclipse configuration for participant startup.

IntelliJ
--------

    .. image:: images/a1-ppnt-intellij.png

Command Line
------------

    .. code-block:: bash

        mvn spring-boot:run -Dspring-boot.run.arguments=”–server.port=8082”

Kserve Participant
******************

Eclipse
-------

Similar to above eclipse configuration for participant startup.

IntelliJ
--------

    .. image:: images/kserve-ppnt-intellij.png

Command Line
------------

    .. code-block:: bash

        mvn spring-boot:run -Dspring-boot.run.arguments=”–server.port=8082”
