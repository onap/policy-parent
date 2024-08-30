.. This work is licensed under a  Creative Commons Attribution
.. 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _policy-db-migrator-label:

Using Policy DB Migrator
########################

Policy DB Migrator is a set of shell scripts used to
install the database tables required to run ONAP Policy Framework and ACM.

.. note::
   Currently the Istanbul versions of the PAP and API components require
   ``db-migrator`` to run prior to initialization.

Package contents
================

Policy DB Migrator is run as a docker container and consists of the following scripts:

.. code::
  :number-lines:

    prepare_upgrade.sh
    prepare_downgrade.sh
    db-migrator
    db-migrator-pg


``prepare_upgrade.sh`` is included as part of the docker image and is used
to copy the upgrade sql files to the run directory.
This script takes one parameter: <SCHEMA NAME>.

``prepare_downgrade.sh`` is included as part of the docker image and is used
to copy the downgrade sql files to the run directory.
This script takes one parameter: <SCHEMA NAME>.

``db-migrator`` and ``db-migrator-pg`` are included as part of the docker image
and are used to run either the upgrade or downgrade operation for MariaDB or
PostgresSQL depending on user requirements.
These script can take up to four parameters:

.. list-table::
   :widths: 20 20 20
   :header-rows: 1

   * - Parameter Name
     - Parameter flag
     - Value (example)
   * - operation
     - -o
     - upgrade/downgrade/report
   * - schema
     - -s
     - schema_name
   * - to
     - -t
     - target_version (latest is 1600)
   * - from
     - -f
     - origin_version (earliest is 0800)

The container also consists of several sql files which are used to upgrade/downgrade
the policy database.

The following environment variables need to be set to enable ``db-migrator``
to run and connect to the database.

.. list-table::
   :widths: 20 20
   :header-rows: 1

   * - Name
     - Value (example)
   * - SQL_HOST
     - mariadb
   * - SQL_DB
     - policyadmin clampacm etc [one or more schema separated by space]
   * - SQL_USER
     - policy_user
   * - SQL_PASSWORD
     - policy_user
   * - POLICY_HOME
     - /opt/app/policy
   * - SCRIPT_DIRECTORY
     - sql

The following environment variables need to be set to enable ``db-migrator-pg``
to run and connect to the database.

.. list-table::
   :widths: 20 20
   :header-rows: 1

   * - Name
     - Value (example)
   * - SQL_HOST
     - postgres
   * - SQL_DB
     - policyadmin clampacm etc [one or more schema separated by space]
   * - SQL_USER
     - policy_user
   * - SQL_PASSWORD
     - policy_user
   * - POLICY_HOME
     - /opt/app/policy
   * - SCRIPT_DIRECTORY
     - postgres
   * - PGPASSWORD
     - ${SQL_PASSWORD}

Prepare Upgrade
===============

Prior to upgrading the following script is run:

.. code::

   /opt/app/policy/bin/prepare_upgrade.sh <SCHEMA NAME>

This will copy the upgrade files from ``/home/${SCHEMA}/${SCRIPT_DIRECTORY}`` to ``$POLICY_HOME/etc/db/migration/<SCHEMA NAME>/${SCRIPT_DIRECTORY}/``

Each individual sql file that makes up that release will be run as part of the upgrade.


Prepare Downgrade
=================

Prior to downgrading the following script is run:
.. code::

   /opt/app/policy/bin/prepare_downgrade.sh <SCHEMA NAME>

This will copy the downgrade files from ``/home/${SCHEMA}/${SCRIPT_DIRECTORY}`` to ``$POLICY_HOME/etc/db/migration/<SCHEMA NAME>/${SCRIPT_DIRECTORY}/``

Each individual sql file that makes up that release will be run as part of the downgrade.

Upgrade
=======

.. code::

   /opt/app/policy/bin/db-migrator -s <SCHEMA NAME> -o upgrade -f 0800 -t 0900

OR

.. code::

   /opt/app/policy/bin/db-migrator-pg -s <SCHEMA NAME> -o upgrade -f 0800 -t 0900

If the ``-f`` and ``-t`` flags are not specified, the script will attempt to run all available
sql files greater than the current version.

The script will return either 1 or 0 depending on successful completion.

Downgrade
=========

.. code::

   /opt/app/policy/bin/db-migrator -s <SCHEMA NAME> -o downgrade -f 0900 -t 0800

OR

.. code::

   /opt/app/policy/bin/db-migrator-pg -s <SCHEMA NAME> -o downgrade -f 0900 -t 0800

If the ``-f`` and ``-t`` flags are not specified, the script will attempt to run all available
sql files less than the current version.

The script will return either 1 or 0 depending on successful completion.

Logging
=======

After every upgrade/downgrade ``db-migrator`` or ``db-migrator-pg`` runs the report operation
to show the contents of the db-migrator log table.

.. code::

   /opt/app/policy/bin/db-migrator -s <SCHEMA NAME> -o report

.. code::

   /opt/app/policy/bin/db-migrator-pg -s <SCHEMA NAME> -o report

Console output will also show the sql script command as in the example below:

.. code::

   upgrade 0100-jpapdpgroup_properties.sql
   --------------
   CREATE TABLE IF NOT EXISTS jpapdpgroup_properties (name VARCHAR(120) NULL, version VARCHAR(20) NULL,
   PROPERTIES VARCHAR(255) NULL, PROPERTIES_KEY VARCHAR(255) NULL)


migration schema
================

The migration schema contains three tables which belong to ``db-migrator``.

* schema_versions - table to store the schema version currently installed by ``db-migrator``

.. list-table::
   :widths: 20 20
   :header-rows: 1

   * - name
     - version
   * - policyadmin
     - 1400
   * - clampacm
     - 1400

* policyadmin_schema_changelog - table which stores a record of each sql file that has been run

.. list-table::
   :widths: 10 40 10 10 10 20 10 20
   :header-rows: 1

   * - ID
     - script
     - operation
     - from_version
     - to_version
     - tag
     - success
     - atTime
   * - 1
     - 0100-jpapdpgroup_properties.sql
     - upgrade
     - 0
     - 0800
     - 1309210909250800u
     - 1
     - 2021-09-13 09:09:26

* clampacm_schema_changelog - table which stores a record of each sql file that has been run

.. list-table::
   :widths: 10 40 10 10 10 20 10 20
   :header-rows: 1

   * - ID
     - script
     - operation
     - from_version
     - to_version
     - tag
     - success
     - atTime
   * - 1
     - 0100-automationcomposition.sql
     - upgrade
     - 0
     - 1400
     - 1309210909250800u
     - 1
     - 2024-04-24 09:09:26

* ID: Sequence number of the operation
* script: name of the sql script which was run
* operation: operation type - upgrade/downgrade
* from_version: starting version
* to_version: target version
* tag: tag to identify operation batch
* success: 1 if script succeeded and 0 if it failed
* atTime: time script was run


Partial Upgrade/Downgrade
=========================

If an upgrade or downgrade ends with a failure status (success=0) the next time an upgrade
or downgrade is run it will start from the point of failure rather than re-run scripts
that succeeded. This allows the user to perform a partial upgrade or downgrade depending
on their requirements.

Running db-migrator
===================

The script that runs ``db-migrator`` is part of the database configuration and is in the following directory:

.. code::

   oom/kubernetes/policy/resources/config/db_migrator_policy_init.sh

This script is mounted from the host file system to the policy-db-migrator container.
It is setup to run an upgrade by default.

.. code::

   /opt/app/policy/bin/prepare_upgrade.sh ${SQL_DB}
   /opt/app/policy/bin/db-migrator -s ${SQL_DB} -o upgrade
   rc=$?
   /opt/app/policy/bin/db-migrator -s ${SQL_DB} -o report
   exit $rc

.. code::

   /opt/app/policy/bin/prepare_upgrade.sh ${SQL_DB}
   /opt/app/policy/bin/db-migrator-pg -s ${SQL_DB} -o upgrade
   rc=$?
   /opt/app/policy/bin/db-migrator-pg -s ${SQL_DB} -o report
   exit $rc

The following table describes what each line does:

.. list-table::
   :widths: 30 30
   :header-rows: 1

   * - code
     - description
   * - /opt/app/policy/bin/prepare_upgrade.sh ${SQL_DB}
     - prepare the upgrade scripts for the <SQL_DB> schema
   * - /opt/app/policy/bin/db-migrator -s ${SQL_DB} -o upgrade
     - run the upgrade
   * - rc=$?
     - assign the return code from db-migrator to a variable
   * - /opt/app/policy/bin/db-migrator -s ${SQL_DB} -o report
     - run the db-migrator report for the <SQL_DB> schema
   * - exit $rc
     - exit with the return code from db-migrator

To alter how ``db-migrator`` is run the first two lines need to be modified.
The first line can be changed to call either ``prepare_upgrade.sh`` or ``prepare_downgrade.sh``.
The second line can be changed to use different input parameters for ``db-migrator`` :

.. list-table::
   :widths: 10 20 10
   :header-rows: 1

   * - flag
     - value
     - required
   * - ``-o``
     - upgrade/downgrade
     - ``Y``
   * - ``-s``
     - ${SQL_DB}
     - ``Y``
   * - ``-f``
     - current version (e.g. 0800)
     - ``N``
   * - ``-t``
     - target version (e.g. 0900)
     - ``N``

This is an example of how a downgrade from version 0900 to version 0800 could be run:

.. code::

   /opt/app/policy/bin/prepare_downgrade.sh ${SQL_DB}
   /opt/app/policy/bin/db-migrator -s ${SQL_DB} -o downgrade -f 0900 -t 0800
   rc=$?
   /opt/app/policy/bin/db-migrator -s ${SQL_DB} -o report
   exit $rc

Additional Information
======================
If the target version of your upgrade or downgrade is the same as the current version,
no sql files are run.

If an upgrade is run on a database where tables already exist in the policy schema, the
current schema version is set to 1300 and only sql scripts from later versions are run.

.. note::
   It is advisable to take a backup of your database prior to running this utility.
   Please refer to the mariadb or postgres documentation on how to do this.

End of Document
