.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _clamp-policy-gui-label:

TOSCA Policy GUI
################

.. contents::
    :depth: 4

1 - How to run the Front-End Gui
================================
This section describes how to run the front end on your local machine.

** Prerequisite:

** Building and running CLAMP

see :doc:`../../../development/clamp-smoke`.

**Step 1:** Go to the clamp directory

.. code-block:: bash

    /clamp/extra/bin-for-dev

**Step 2:** Inside the clamp directory run

.. code-block:: bash

    ./start-db.sh test

**Step 3:** Check docker container id

.. code-block:: bash

    docker ps

**Step 4:** Log into docker container

.. code-block:: bash

    docker exec -it 'container_id' bash

**Step 5:** Go into mariadb shell

.. code-block:: bash

    mysql -u root -p

**Step 6:** Enter password

    strong_pitchou

.. image:: images/01-gui.png

**Step 7:** Go into cldsdb4 database

.. code-block:: bash

    use cldsdb4;

**Step 8:** Verify if there is data in the following table 'loop_templates'

.. code-block:: bash

    select * from loop_templates;

** If for some reason the database is empty do the go to the '/docker-entrypoint-initdb.d/dump' directory

.. code-block:: bash

    ./load-fake-data.sh

**Step 9:** Once the database is up and running need to start the clamp emulator, by running the following command inside the /clamp/extra/bin-for-dev

.. code-block:: bash

    ./start-emulator.sh

**Step 10:** Verify if mariadb and the emulator is running

.. code-block:: bash

    docker ps

.. image:: images/02-gui.png

**Step 11:** Start the backend service by running the command inside the /clamp/extra/bin-for-dev

.. code-block:: bash

    ./start-backend.sh


2 - Checking out and building the UI
====================================

.. _Building UI

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

3 - How to Commission/Decommission the TOSCA Service Template
=============================================================

This section describes how to commission and decommission the Tosca Service Template

** Prerequisite:

see :ref:`Building UI`.

**Step 1:** From the Main Menu Click on TOSCA Automation Composition Dropdown

.. image:: images/04-gui.png

**Step 2:** From the Dropdown Menu Select Upload Automation Composition To Commissioning

.. image:: images/05-gui.png

**Step 3:** On the window Upload Tosca to Commissioning API Click on the input box that says 'Please Select a file'

.. image:: images/06-gui.png

**Step 4:** Once the yaml file is selected click on Upload Tosca Service Template

.. image:: images/07-gui.png

**Step 5:** After the upload there should have a message "Upload Success" in green

.. image:: images/08-gui.png

**Step 6:** To validate that the TOSCA Service Template has been commissioned click on Manage Commissioned Automation Composition Template

.. image:: images/09-gui.png

**Step 7:** In the View Tosca Template Window click on Pull Tosca Service Template

.. image:: images/10-gui.png

**Step 8:** Once the Tosca Service Template has been pulled there should be a json object rendered in the window

.. image:: images/11-gui.png

**Step 9:** Click on Close close the window

**Step 10:** Click on Edit Automation Composition Properties

.. image:: images/12-gui.png

**Step 11:** In the Change ACM Common Properties change the appropriate properties and click on save and there should have a popup saying 'Changes Saved.  Commission When Ready...'

.. image:: images/13-gui.png

**Step 12:** After saving the changes click on Commission and should have a Green message saying 'Commissioning Success'

.. image:: images/14-gui.pn

**Step 13:** To Decommission the Tosca Service Follow Step 6 and 8

**Step 14:** Once the json objected is rendered in the window click on delete

.. image:: images/11-gui.png

**Step 14:** Once the json objected is rendered in the window click on delete

.. image:: images/11-gui.png

**Step 15:** If the delete is successful it should show a message "Delete Successful"

.. image:: images/15-gui.png