.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _policy-api-smoke-testing-label:

.. toctree::
   :maxdepth: 2

XACML PDP Smoke Test
~~~~~~~~~~~~~~~~~~~~

The policy-xacml-pdp smoke testing can be executed against a kubernetes based policy framework
installation, and/or a docker-compose set up similar to the one executed by CSIT tests.

General Setup
*************

PF kubernetes Install
---------------------

For installation instructions, please refer to the following documentation:

`Policy Framework K8S Install
<https://docs.onap.org/projects/onap-policy-parent/en/latest/development/devtools/testing/csit.html>`_

The script referred to in the above link should handle the install of the of microk8s, docker and
other required components for the install of the policy framework and clamp components. The scripts
are used by policy as a means to run the CSIT tests in Kubernetes.

docker-compose based
--------------------

A smaller testing environment can be put together by replicating the docker-based CSIT test
environment. Details are on the same page as K8s setup:

`Policy CSIT Test Install Docker
<https://docs.onap.org/projects/onap-policy-parent/en/latest/development/devtools/testing/csit.html>`_

Testing procedures
******************

The smoke tests should be focused on verifying the proper workings of the xacml
PDP and dependent components. The following scenarios should be considered:

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

- `CSIT Robot framework <https://github.com/onap/policy-docker/blob/master/csit/resources/tests/xacml-pdp-test.robot>`_
- `JMeter S3P <https://github.com/onap/policy-xacml-pdp/blob/master/testsuites/stability/src/main/resources/testplans/stability.jmx>`_

