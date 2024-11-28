.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _policy-csit-label:

Policy Framework CSIT Testing
#############################

.. contents::
    :depth: 3

The Continuous System and Integration Testing suites are run normally as a Jenkins job to assert
that common usage of Policy Framework services are running as expected.

This article provides the steps to run CSIT tests in a local environment, most commonly after a
significant code change.

.. note::
  Both environments described in this page are for test or learning purposes only. For real deployment
  environment, use `ONAP Operations Manager <https://github.com/onap/oom>`_

.. note::
  If building images locally, follow the instructions :ref:`here <building-pf-docker-images-label>`


First, clone policy/docker repo from gerrit:

.. code-block:: bash

  git clone "https://gerrit.onap.org/r/policy/docker"

On this whole article, it's assumed the base folder for policy-docker repository is
`~/git/policy/docker`

Under the folder `~/git/policy/docker/csit`, there are two main scripts to run the tests:

* run-k8s-csit.sh
* run-project-csit.sh


Running CSIT in Docker environment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If not familiar with the PF Docker structure, the detailed information can be found :ref:`here <docker-label>`

Running tests to validate code changes
--------------------------------------

For *local* images, set `LOCAL_IMAGES=true`, located at the `get-versions.sh` script

.. note::
   Make sure to do the same changes to any other components that are using locally built images.


Then use the `run-project-csit.sh` script to run the test suite.


.. code-block:: bash

  cd ~/git/policy/docker
  ./csit/run-project-csit.sh <component>


The <component> input is any of the policy components available:

 - api
 - pap
 - apex-pdp
 - distribution
 - drools-pdp
 - drools-applications
 - xacml-pdp
 - clamp

Keep in mind that after the Robot executions, logs from docker-compose are printed and
test logs might not be available on console and the containers are teared down. The tests results
are available under `~/git/policy/docker/csit/archives/<component>/` folder.


Running tests for learning PF usage
-----------------------------------

In that case, no changes required on docker-compose files, but commenting the tear down of docker
containers might be required. For that, edit the file `run-project-csit.sh` script and comment the
following line:

.. code-block:: bash

  # source_safely ${WORKSPACE}/compose/stop-compose.sh (currently line 36)


This way, the docker containers are still up and running for more investigation.

To tear them down, execute the `stop-compose.sh` script:

.. code-block:: bash

  cd ~/git/policy/docker/compose
  ./stop-compose.sh


Running CSIT in Micro K8S environment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The microk8s version of Policy Framework was brought up for integration test in PF as whole, such
as Stability and Performance tests, but can be used for CSIT validation as well. The helm charts
are under `~/git/policy/docker/helm` folder.


Running tests or installing one PF component
--------------------------------------------

If needed to install or run tests for an specific PF component, the `run-k8s-csit.sh` script can be
used to run the test suite or installation with the proper arguments.


.. code-block:: bash

  cd ~/git/policy/docker
  ./csit/run-k8s-csit.sh install <component>


The <component> input is any of the policy components available:

 - api
 - pap
 - apex-pdp
 - distribution
 - drools-pdp
 - xacml-pdp
 - clamp


Different from Docker usage, the microk8s installation is not removed when tests finish.


Installing all available PF components
--------------------------------------

Use the `run-k8s-csit.sh` script to install PF components with Prometheus server available.

.. code-block:: bash

  cd ~/git/policy/docker
  ./csit/run-k8s-csit.sh install


In this case, no tests are executed and the environment can be used for other integration tests
such as Stability and Performance, Smoke tests or manual test.


Uninstall and clean up
----------------------

If running the CSIT tests with microk8s environment, docker images for the tests suites are created.
To clean them up, user `docker prune <https://docs.docker.com/config/pruning/>`_ command.

To uninstall policy helm deployment and/or the microk8s cluster, use `run-k8s-csit.sh`


.. code-block:: bash

  cd ~/git/policy/docker

  # to uninstall deployment
  ./csit/run-k8s-csit.sh uninstall

  # to remove cluster
  ./csit/run-k8s-csit.sh clean


End of document