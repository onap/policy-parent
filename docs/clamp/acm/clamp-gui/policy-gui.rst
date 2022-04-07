.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _clamp-policy-gui-label:

TOSCA Policy GUI
####################################################

.. contents::
    :depth: 4

1 - How to run the Front-End Gui
================================
This section describes how to run the front end on your local machine.

**Section 1:** Prerequisite

**Step 1:** Building and running CLAMP

see :doc:`../../../development/clamp-smoke`.

**Step 2:** Go to the clamp directory

.. code-block:: bash

    /clamp/extra/bin-for-dev

**Step 3:** Inside the clamp directory run

.. code-block:: bash

    ./start-db.sh test

**Step 4:** Check docker container id

.. code-block:: bash

    docker ps

**Step 5:** Log into docker container

.. code-block:: bash

    docker exec -it 'container_id' bash

**Step 6:** Go into mariadb shell

.. code-block:: bash

    mysql -u root -p

**Step 7:** Enter password

    strong_pitchou

.. image:: images/01-gui.png

**Step 8:** Go into cldsdb4 database

.. code-block:: bash

    use cldsdb4;

**Step 9:** Verify if there is data in the following table 'loop_templates'

.. code-block:: bash

    select * from loop_templates;

** If for some reason the database is empty do the go to the '/docker-entrypoint-initdb.d/dump' directory

.. code-block:: bash

    ./load-fake-data.sh

**Step 10:** Once the database is up and running need to start the clamp emulator, by running the following command inside the /clamp/extra/bin-for-dev

.. code-block:: bash

    ./start-emulator.sh

**Step 11:** Verify if mariadb and the emulator is running

.. code-block:: bash

    docker ps

.. image:: images/02-gui.png

**Step 12:** Start the backend service by running the command inside the /clamp/extra/bin-for-dev

.. code-block:: bash

    ./start-backend.sh

2 - Checking out and building the UI
====================================

**Step 1:** Checkout the UI from the repo

.. code-block:: bash

    git clone "https://gerrit.nordix.org/onap/policy/gui"

**Step 2:** Change into the "gui" directory and run the following

.. code-block:: bash

    mvn clean install

**Step 3:** Go into the gui-clamp/ui-react directory and run the following

.. code-block:: bash

    npm install

**Step 4:** Start the front end UI

.. code-block:: bash

    npm start --scripts-prepend-node-path

** If you get the following error

.. image:: images/03-gui.png

    gedit package.json

.. code-block:: bash

   change the following
   "version": "${project.version}",

   to

   "version": "2.1.1",

    save and close

    then delete the node_modules directory

    rm -rf node_modules/

    then run again

    npm install

.. code-block:: bash

    npm start --scripts-prepend-node-path

**Step 5:** Once the UI starts at localhost:3000 it will ask for credentials:

    Login: admin
    Password: password

