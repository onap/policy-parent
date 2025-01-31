.. This work is licensed under a Creative Commons Attribution
.. 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

Policy DB Migrator Smoke Tests
##############################

Prerequisites
*************

- Have Docker and Docker compose installed
- Some bash knowledge

Preparing the test
==================

The goal for the smoke test is to confirm the any upgrade or downgrade operation between different
db-migrator versions are completed without issues.

So, before running the test, make sure that there are different tests doing upgrade and downgrade
operations to the latest version. The script with test cases is under db-migrator folder in `docker
repository <https://github.com/onap/policy-docker/tree/master/policy-db-migrator/smoke-test>`_

Edit the `*-tests.sh` file to add the tests and also to check if the database variables (host,
admin user, admin password) are set correctly.

Running the test
================

The script mentioned on the step above is ran against the `Docker compose configuration
<https://github.com/onap/policy-docker/tree/master/compose>`_.

Change the `db_migrator_policy_init.sh` on db-migrator service descriptor in the docker compose file
to the `*-test.sh` file.

Start the service

.. code-block:: bash

    cd ~/git/docker/compose
    ./start-compose.sh policy-db-migrator

To collect the logs

.. code-block:: bash

    docker compose logs
    # or
    docker logs policy-db-migrator

To finish execution

.. code-block:: bash

    ./stop-compose.sh


End of Document
