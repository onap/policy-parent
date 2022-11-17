.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _policy-api-smoke-testing-label:

.. toctree::
   :maxdepth: 2

XACML PDP Smoke Test
~~~~~~~~~~~~~~~~~~~~

The policy-xacml-pdp smoke testing can be executed against a kubernetes based ONAP installation,
and/or a docker-compose set up similar to the one executed by CSIT tests.

General Setup
*************

ONAP OOM kubernetes
-------------------

For installation instructions, please refer to the following documentation:

`OOM User Guide <https://docs.onap.org/projects/onap-oom/en/latest/sections/guides/user_guides/oom_user_guide.html>`_

At a minimum policy needs the following components installed:

- onap base charts
- AAF for certificate generation
- DMaaP message-router for communication among policy components.

docker-compose based
--------------------

A smaller testing environment can be put together by replicating the CSIT test environment:

`Policy CSIT Test infrastructure <https://git.onap.org/policy/docker/tree/csit>`_

Testing procedures
******************

The smoke tests should be focused on verifying the proper workings of the xacml
PDP and dependent components.   The following scenarios should be considered:

- PDP-X registration with PAP.
- PDP-X restarts and re-registration with PAP.
- Healtchecks
- Statistics and Prometheus metrics.
- Verify decision with monitoring policies.
- Verify decision with optimization policy.
- Verify decision with min/max policy.
- Verify decision with frequency limiter policy.
- Verify decision with default guard policy.
- Verify decision with naming policy.

The following testsuites contain everything necessary for the previous verifications:

- `CSIT Robot framework <https://git.onap.org/policy/docker/tree/csit/xacml-pdp/tests/xacml-pdp-test.robot>`_
- `JMeter S3P <https://git.onap.org/policy/xacml-pdp/tree/testsuites/stability/src/main/resources/testplans/stability.jmx>`_

