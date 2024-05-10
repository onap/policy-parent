.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _policy-distribution-smoke-testing-label:

Policy Distribution Smoke Test
################################

The policy-distribution smoke testing is executed against a custom ONAP docker or Kubernetes installation as defined in the docker compose file in "policy/docker/csit/".
The policy-distribution configuration file is located in "docker/csit/config/distribution/".
This test verifies the execution of the REST API's exposed by the component to make sure the CSAR Decoding and Forwarding works as expected.
Also, the deployment of the policy is checked automatically. An event is then sent to the deployed policy, and thus, its correct operation is verified.

There are 2 alternative ways to carry out the tests. In Docker and in Kubernetes

Docker Setup
************
In policy/docker/csit/

More detailed setup for docker CSIT is here

`Policy CSIT Test Install Docker <https://docs.onap.org/projects/onap-policy-parent/en/latest/development/devtools/testing/csit.html>`_

.. code-block:: bash

    ./run-project-csit.sh distribution

This script will do the following:

- Deploys all required components - including api, pap and distribution
- Runs distributions CSIT tests. These tests:

    - Take a policy from a CSAR file in distribution.
    - Distribution sends and deploys it in API and PAP.
    - Send an event to the deployed policy - if the policy is NOT deployed successfully, this will FAIL with a 404.

- Takes down all the components.
- Saves the results in a .html file in the csit/archives/distribution directory
- Saves the docker compose logs in the same directory

K8S Setup
*********
In policy/docker/csit/

More detailed setup for K8S CSIT is here

`Policy CSIT Test Install Kubernetes <https://docs.onap.org/projects/onap-policy-parent/en/latest/development/devtools/testing/csit.html>`_

.. code-block:: bash

    ./run-k8s-csit.sh install distribution

This script will do the following:

- Installs microk8s and configures it.
- Deploys all required components - including api, pap and distribution as helm charts
- Waits for all the charts to come up
- Runs distributions CSIT tests. These tests:

    - Take a policy from a CSAR file in distribution.
    - Distribution sends and deploys it in API and PAP.
    - Sends an event to the deployed policy - if the policy is NOT deployed successfully, this will FAIL with a 404.

- Saves the results in a .html file in the csit/archives/distribution directory
- The pods are not automatically taken down.

To uninstall policy helm deployment and/or the microk8s cluster, use `run-k8s-csit.sh`

.. code-block:: bash

  # to uninstall deployment
  ./run-k8s-csit.sh uninstall

  # to remove cluster
  ./run-k8s-csit.sh clean

End of document