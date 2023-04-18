.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _policy-api-smoke-testing-label:

.. toctree::
   :maxdepth: 2

Policy Drools PDP and Applications Smoke Test
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The policy-drools-pdp smoke testing can be executed against a kubernetes based ONAP installation,
and/or a docker-compose set up similar to the one executed by CSIT tests.

General Setup
*************

ONAP OOM kubernetes
-------------------

For installation instructions, please refer to the following documentation:

`OOM Documentation <https://docs.onap.org/projects/onap-oom/en/latest/>`_

At a minimum policy needs the following components installed:

- onap base charts
- AAF for certificate generation
- DMaaP message-router for communication among policy components.

AAI, SO and other components can be simulated by installing the simulator charts:

`Policy Simulator Helm Chart <https://github.com/onap/policy-docker/tree/master/helm/policy/components/policy-models-simulator>`_

docker-compose based
--------------------

A smaller testing environment can be put together by replicating the CSIT test environment:

`Policy CSIT Test infrastructure <https://github.com/onap/policy-docker/tree/master/csit>`_

Testing procedures
******************

The smoke tests should be focused on verifying the proper workings of drools
and dependent components.   The following scenarios should be considered:

- PDP-D registration with PAP.
- PDP-D restarts and re-registration with PAP.
- Proper workings of telemetry tool.
- Exploration of correct PDP-D states with the telemetry tool.
- Statistics and prometheus metrics.
- Verify correct states of API, PAP, and controllers using the PDP-D healthchecks.
- Verify distributed locking capability and proper use of the database.
- Verify vCPE, vDNS, and vFirewall use cases and recorded metrics.

The following testsuites contain everything necessary for the previous verifications:
- `CSIT Robot framework <https://github.com/onap/policy-docker/blob/master/csit/resources/tests/drools-applications-test.robot>`_
- `JMeter S3P <https://github.com/onap/policy-drools-applications/blob/master/testsuites/stability/src/main/resources/s3p.jmx>`_

