.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _gui-server-label:

The Policy Framework GUI Server
###############################

The **gui-server** microservice serves the GUI code to the browser for Policy Framework UI. In addition, it acts as
a single point of reference for the REST interfaces provided by **policy-api**, **policy-pap**, and **acm-runtime**.
It can also be used as a HTTPS gatewy for REST references into a Policy Framework deployment in a Kubernetes cluster.

.. contents::
    :depth: 2

The **gui-server** is a regular microservice, and it is packaged, delivered and configured as a docker image. It is
a Spring application and therefore uses a normal Spring-style *applciation.yaml* approach to configuration.

Definitive example configurations are available in the codebase:

- `application_http.yaml <https://github.com/onap/policy-gui/blob/master/gui-server/src/test/resources/application_http.yaml>`_
  showing how to configure gui-server for HTTP access
- `application_https.yaml <https://github.com/onap/policy-gui/blob/master/gui-server/src/test/resources/application_https.yaml>`_
  showing how to configure gui-server for HTTPS access

The configuration parameters are explained in the sections below

Server Configuration
--------------------

Configuration for HTTP access to gui-server::

  server:
    port: 2443
    ssl:
      enabled: false

Start gui-server on port 2443 and disable SSL.

Configuration for HTTPS access to gui-server::

  server:
    port: 2443
    ssl:
      enabled: true
      enabled-protocols: TLSv1.2
      client-auth: want
      key-store: file:./src/test/resources/helloworld-keystore.jks
      key-store-password: changeit
      trust-store: file:./src/test/resources/helloworld-truststore.jks
      trust-store-password: changeit

Start gui-server on port 2443 and enable SSL with the parameters specified above

Note that other standard Spring **server** configuraiton parameters as
documented
`on the Spring website <https://docs.spring.io/spring-boot/docs/current/reference/html/application-properties.html>`_
are supported.

Runtime Adaptation Configuration
--------------------------------

You can configure the adaptation for **policy-api**, **policy-pap**, and **runtime-acm**. In other words, you can map
the URL that the GUI produced or that you want to use in a REST tool such as *postman* or *curl* in the **runtime-ui**
part of the aaplication.yaml file::

  runtime-ui:
    policy-api:
      mapping-path: "/runtime-ui/policy-api/restservices/"
      url: http://localhost:30440
      disable-ssl-validation: true
      disable-ssl-hostname-check: true
    policy-pap:
      mapping-path: "/runtime-ui/policy-pap/restservices/"
      url: http://localhost:30442
      disable-ssl-validation: true
      disable-ssl-hostname-check: true
    acm:
      mapping-path: "/runtime-ui/acm/restservices/"
      url: http://localhost:30258
      disable-ssl-validation: true
      disable-ssl-hostname-check: true

The parameters under the **policy-api**, **policy-pap**, and **acm** sections are identical.

mapping-path and url
++++++++++++++++++++

The **mapping-path** is the root part of the path that will be replaced by the **url**, the **url** replaces the
**mapping-path**.

Therefore, using the configuration above for policy-api, the following mapping occurs::

  http://localhost:2443/runtime-ui/policy-api/restservices/policy/api/v1/healthcheck

  maps to

  http://localhost:30440/policy/api/v1/healthcheck

and::

  https://localhost:2443/runtime-ui/acm/restservices/onap/policy/clamp/acm/v2/commission

  maps to

  http://localhost:30258/onap/policy/clamp/acm/v2/commission

disable-ssl-validation and disable-ssl-hostname-check
+++++++++++++++++++++++++++++++++++++++++++++++++++++

The **disable-ssl-validation** **disable-ssl-hostname-check** are boolean values. If the target server (policy-api,
policy-pap, or runtime-acm) is using http, these values should be set to **false**. If the target server is using
HTTPS, set the values as **true** so that the **gui-server** transfers and forwards certificates to target servers.

Spring Boot Acuator Monitoring
------------------------------

The **gui-server** supports regular
`Spring Boot Actuator monitoring <https://docs.spring.io/spring-boot/docs/1.4.0.M2/reference/html/production-ready-monitoring.html>`_
and monitoring over `prometheus <https://prometheus.io/>`_.

The following section of the *application.yaml** file is an example of how to enable monitoring::

  management:
    endpoints:
      web:
        base-path: /
        exposure:
          include: health,metrics,prometheus
        path-mapping.metrics: plain-metrics
        path-mapping.prometheus: metrics

The configuration above enables the following URLs::

  # Health Check
  http://localhost:2443/health

  # Plain Metrics
  http://localhost:2443/plain-metrics

  # Prometheus Metrics
  http://localhost:2443/metrics


