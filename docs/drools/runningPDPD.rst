.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

**********************************************************
Methods to run PDP-D
**********************************************************

.. contents::
    :depth: 2

There are two methods you can use to run a PDP-D for testing purposes:

1. Using Docker

2. Using Eclipse

Using Docker
^^^^^^^^^^^^
**Step 1:** Clone the integration/csit repository. 

You can find the repo here: https://gerrit.onap.org/r/admin/repos/integration/csit.
Although this repository is used for CSIT testing, we can use this as a means to get a PDP-D up and running with docker.

    .. code-block:: bash

        git clone "https://gerrit.onap.org/r/integration/csit"

**Step 2:** Note the "docker-compose" commands that will be used.

    .. code-block:: bash

        docker-compose -f ${WORKSPACE}/scripts/policy/docker-compose-drools-apps.yml up -d

        docker-compose -f ${WORKSPACE}/scripts/policy/docker-compose-drools-apps.yml down -v

Note that ${WORKSPACE} refers to the local path where the csit repository is.

**Step 3:** Edit the "docker-compose-drools-apps.yml" file.

Take a look at the "csit/scripts/policy/docker-compose-drools-apps.yml" file. It should look similar to this:

    .. image:: img/docker/yamlClone.png

The following changes need to be made based on which version you are running and your local setup.

    .. code-block:: bash

        ${POLICY_MARIADB_VER} should be "10.2.14" (without quotes, version subject to change)

        ${WORKSPACE} should be the absolute path to the cloned "csit" repository.

        ${POLICY_DROOLS_APPS_VERSION} should be "1.6.0" (without quotes, version subject to change).

If you are using MacOS, you will also need to make the following changes:

    .. code-block:: bash

        expose:
        - 6969
        - 9696

        will need to be changed to:

        ports:
        - "6969:6969"
        - "9696:9696"

**Step 4:** Start containers and interact with PDP-D.

    .. code-block:: bash

        docker-compose -f scripts/policy/docker-compose-drools-apps.yml up -d
        docker container ls
        docker exec -it drools bash

    .. image:: img/docker/dockerComposeUp.png

    .. code-block:: bash

        policy status

    .. image:: img/docker/policyStatus.png

    .. code-block:: bash

        # launches subshell where telemetry commands can be executed
        telemetry

        ls

        cd controllers

        # Get the current controllers
        get

    .. image:: img/docker/telemetryCmd.png

    .. code-block:: bash

        # Get information about the "frankfurt" controller
        get frankfurt

    .. image:: img/docker/getFrankfurt.png


    .. code-block:: bash

        docker-compose -f scripts/policy/docker-compose-drools-apps.yml down -v

    .. image:: img/docker/dockerComposeDown.png

In the next section, you will see more about using telemetry commands and interacting with the PDP-D.

Using Eclipse
^^^^^^^^^^^^^

**Step 1:** Clone 'drools-pdp' repository and create a new directory for eclipse workspace.

Link to repository: https://gerrit.onap.org/r/admin/repos/policy/drools-pdp
For the purposes of this demo, we will create an new directory to use as a workspace for eclipse.

    .. code-block:: bash

       $ git clone "https://gerrit.onap.org/r/policy/drools-pdp"
       Cloning into 'drools-pdp'...
       remote: Counting objects: 59, done
       remote: Finding sources: 100% (30/30)
       remote: Total 14406 (delta 0), reused 14399 (delta 0)
       Receiving objects: 100% (14406/14406), 3.23 MiB | 628.00 KiB/s, done.
       Resolving deltas: 100% (6630/6630), done.
       Checking out files: 100% (588/588), done.

       $ mkdir workspace-drools-pdp

       $ ls
       drools-pdp/  workspace-drools-pdp/

The "drools-pdp/" directory contains the cloned repository and "workspace-drools-pdp/" is an empty directory.

**Step 2:** Import "drools-pdp" as an existing maven project.

Open Eclipse. Hit the **browse** button and navigate to the "workspace-drools-pdp/" directory. Select that folder as the workspace directory and hit **launch**.

    .. image:: img/eclipse/selectWorkspaceDirectory.png

Select File -> Import -> Maven -> Existing Maven Projects -> Next

    .. image:: img/eclipse/importMaven.png

Select **Browse** and navigate to the root directory of the cloned project. Hit **Select All** to make sure all projects are included and select **Finish**.

    .. image:: img/eclipse/selectProjects.png

**Step 3:** Run "policy-management" as a java application

All of the projects will appear in the package explorer after they finish importing. Right click on "policy-management", select "Run As", and select "Java Application".

    .. image:: img/eclipse/runJavaApp.png

Type "main" and select the option "Main - org.onap.policy.drools.system" then hit **OK**.

    .. image:: img/eclipse/mainApp.png

If everything is successful, the PDP-D will start running and you will notice output displayed in the console. In the next section, you will see how to interact with the PDP-D using telemetry commands.
