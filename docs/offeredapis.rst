.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. DO NOT CHANGE THIS LABEL FOR RELEASE NOTES - EVEN THOUGH IT GIVES A WARNING
.. _offeredapis:


Policy Offered APIs
===================

The Policy Framework supports the public APIs listed in the links below:

.. toctree::
   :maxdepth: 1

   api/api
   pap/pap
   xacml/decision-api
   clamp/acm/api-protocol/acm-rest-apis

Postman Environment for API Testing
-----------------------------------

The following environment file from postman can be used for testing API's. All you need to do is fill in the IP and Port information for the installation that you have created.

:download:`Postman Environment <PolicyAPI.postman_environment.json>`

.. note::
  If you are testing on a Docker Installation use *http* as **protocol**, *localhost* as **IP**,
  and the values set in the `export-ports.sh <https://raw.githubusercontent.com/onap/policy-docker/master/compose/export-ports.sh>`_ as **PORT**.
  More information in: :ref:`Docker Installation <docker-label>`

Postman Collection for API Testing
----------------------------------

Postman collection for `Policy Framework Lifecycle API <https://github.com/onap/policy-api/blob/master/postman/lifecycle-api-collection.json>`_

Postman collection for `Policy Framework Administration API <https://github.com/onap/policy-pap/blob/master/postman/pap-api-collection.json>`_

Postman collection for `Policy Framework Decision API <https://github.com/onap/policy-xacml-pdp/blob/master/postman/decision-api-collection.json>`_

API Swagger
-----------

The standard for API definition in the RESTful API world is the OpenAPI Specification (OAS). The OAS, which is based on
the original "Swagger Specification," is being widely used in API developments.

OAS 3.0 is used to describe the API contracts, and those documents are added as a source artifacts.

`Swagger Specification for Policy API <./api/local-swagger.html>`_

`Swagger Specification for Policy PAP <./pap/local-swagger.html>`_

`Swagger Specification for Policy XACML-PDP <./xacml/local-swagger.html>`_

`Swagger Specification for Policy DROOLS-PDP <./drools/local-swagger.html>`_

`Swagger Specification for Policy ACM-R <./clamp/acm/api-protocol/local-swagger.html>`_


The YAML document can be also downloaded and imported in an web editor such as `Editor Swagger <https://editor.swagger.io/>`_

An "OpenApi first" approach is adopted, so starting from the Swagger document we auto-generate interfaces that are implemented in the API controllers.

.. note::
  The Swagger document can still be extracted from the code in the API that uses *Spring-Doc* dependency at the endpoint "../v3/api-docs/"
  For Example ACM-Runtime endpoint

  ``http://<IP>:<PORT>/onap/policy/clamp/acm/v3/api-docs``
