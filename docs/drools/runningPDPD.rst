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
**Step 1:**

You can download the 'Dockerfile' for 'drools-pdp' using this command:

    .. code-block:: bash

       wget https://gerrit.onap.org/r/gitweb?p=policy/drools-pdp.git;a=blob_plain;f=packages/docker/src/main/docker/Dockerfile;hb=refs/heads/master

**Step 2:**

Build an image from the 'Dockerfile'. <IMAGE_NAME> is a tag name you can give to your image to help identify it.

    .. code-block:: bash  

       docker build -t "<IMAGE_NAME>:Dockerfile" .

**Step 3:**

List available docker images using

    .. code-block:: bash  

       docker images

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
