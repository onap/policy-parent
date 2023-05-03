.. _local-policy-label:

.. toctree::
   :maxdepth: 2

Policy Framework Component Microk8s Installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This page will explain how to install the policy in a microk8s environment.
The intention of this page is to outline the process to spin up a kubernetes cluster using microk8s.

These instructions are for development purposes only.

Process
*******

In the latest release of the Policy Framework, the  ability to run the Policy Framework CSITs in a kubernetes environment was introduced.
As part of this work, a script has been added to the policy/docker repo to bring up a kubernetes environment and deploy the Policy Framework helm charts.
This makes installation of the Policy Framework easier for developers.

Steps
-----

1. Clone the policy/docker repo.

    .. code-block:: bash

        git clone https://github.com/onap/policy-docker

2. Invoke the microk8s installation script (docker/csit/run-k8s-csit.sh)

    .. code-block:: bash

        docker/csit/run-k8s-csit.sh {install} {project_name}

    When the project name is not specified, the script only installs the policy helm charts and will not execute the robot tests. Alternatively, if you want to run the csit tests for a particular project, you can supply the name here.

    This script verifies the microk8s kubernetes cluster is running, deploys the policy helm charts under the default namespace, builds the docker image for the robot framework and deploys the robot framework helm chart
    in the default namespace, and invokes the robot test(s) for the project supplied by the user. The test results can be viewed from the logs of the policy-csit-robot pod.

3. Teardown the cluster

    .. code-block:: bash

        docker/csit/run-k8s-csit.sh {uninstall}

    To teardown the cluster, the same script can be invoked with the {uninstall} argument. No project name is required.
