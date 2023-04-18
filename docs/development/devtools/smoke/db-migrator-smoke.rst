.. This work is licensed under a Creative Commons Attribution
.. 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

Policy DB Migrator Smoke Tests
##############################

Prerequisites
*************

Check number of files in each release

.. code::
  :number-lines:

    ls 0800/upgrade/*.sql | wc -l = 96
    ls 0900/upgrade/*.sql | wc -l = 13
    ls 1000/upgrade/*.sql | wc -l = 9
    ls 0800/downgrade/*.sql | wc -l = 96
    ls 0900/downgrade/*.sql | wc -l = 13
    ls 1000/downgrade/*.sql | wc -l = 9

Upgrade scripts
===============

.. code::
  :number-lines:

    /opt/app/policy/bin/prepare_upgrade.sh policyadmin
    /opt/app/policy/bin/db-migrator -s policyadmin -o upgrade # upgrade to Jakarta version (latest)
    /opt/app/policy/bin/db-migrator -s policyadmin -o upgrade -t 0900 # upgrade to Istanbul
    /opt/app/policy/bin/db-migrator -s policyadmin -o upgrade -t 0800 # upgrade to Honolulu

.. note::
   You can also run db-migrator upgrade with the -t and -f options

Downgrade scripts
=================

.. code::
  :number-lines:

    /opt/app/policy/bin/prepare_downgrade.sh policyadmin
    /opt/app/policy/bin/db-migrator -s policyadmin -o downgrade -t 0900 # downgrade to Istanbul
    /opt/app/policy/bin/db-migrator -s policyadmin -o downgrade -t 0800 # downgrade to Honolulu
    /opt/app/policy/bin/db-migrator -s policyadmin -o downgrade -t 0 # delete all tables

Db migrator initialization script
=================================

Update /oom/kubernetes/policy/resources/config/db_migrator_policy_init.sh with the appropriate upgrade/downgrade calls.

The policy version you are deploying should either be an upgrade or downgrade from the current db migrator schema version.

Every time you modify db_migrator_policy_init.sh you will have to undeploy, make and redeploy before updates are applied.

1. Fresh Install
****************

.. list-table::
   :widths: 60 20
   :header-rows: 0

   * - Number of files run
     - 118
   * - Tables in policyadmin
     - 70
   * - Records Added
     - 118
   * - schema_version
     - 1000

2. Downgrade to Honolulu (0800)
*******************************

Modify db_migrator_policy_init.sh - remove any lines referencing upgrade and add the 2 lines under "Downgrade scripts" tagged as Honolulu

Make/Redeploy to run downgrade.

.. list-table::
   :widths: 60 20
   :header-rows: 0

   * - Number of files run
     - 13
   * - Tables in policyadmin
     - 73
   * - Records Added
     - 13
   * - schema_version
     - 0800

3. Upgrade to Istanbul (0900)
*****************************

Modify db_migrator_policy_init.sh - remove any lines referencing downgrade and add the 2 lines under "Upgrade scripts".

Make/Redeploy to run upgrade.

.. list-table::
   :widths: 60 20
   :header-rows: 0

   * - Number of files run
     - 13
   * - Tables in policyadmin
     - 75
   * - Records Added
     - 13
   * - schema_version
     - 0900

4. Upgrade to Istanbul (0900) without any information in the migration schema
*****************************************************************************

Ensure you are on release 0800. (This may require running a downgrade before starting the test)

Drop db-migrator tables in migration schema:

.. code::
  :number-lines:

    DROP TABLE schema_versions;
    DROP TABLE policyadmin_schema_changelog;

Modify db_migrator_policy_init.sh - remove any lines referencing downgrade and add the 2 lines under "Upgrade scripts".

Make/Redeploy to run upgrade.

.. list-table::
   :widths: 60 20
   :header-rows: 0

   * - Number of files run
     - 13
   * - Tables in policyadmin
     - 75
   * - Records Added
     - 13
   * - schema_version
     - 0900

5. Upgrade to Istanbul (0900) after failed downgrade
****************************************************

Ensure you are on release 0900.

Rename pdpstatistics table in policyadmin schema:

.. code::

    RENAME TABLE pdpstatistics TO backup_pdpstatistics;

Modify db_migrator_policy_init.sh - remove any lines referencing upgrade and add the 2 lines under "Downgrade scripts"

Make/Redeploy to run downgrade

This should result in an error (last row in policyadmin_schema_changelog will have a success value of 0)

Rename backup_pdpstatistic table in policyadmin schema:

.. code::

    RENAME TABLE backup_pdpstatistics TO pdpstatistics;

Modify db_migrator_policy_init.sh - Remove any lines referencing downgrade and add the 2 lines under "Upgrade scripts"

Make/Redeploy to run upgrade

.. list-table::
   :widths: 60 20
   :header-rows: 0

   * - Number of files run
     - 11
   * - Tables in policyadmin
     - 75
   * - Records Added
     - 11
   * - schema_version
     - 0900

6. Downgrade to Honolulu (0800) after failed downgrade
******************************************************

Ensure you are on release 0900.

Add timeStamp column to papdpstatistics_enginestats:

.. code::

    ALTER TABLE jpapdpstatistics_enginestats ADD COLUMN timeStamp datetime DEFAULT NULL NULL AFTER UPTIME;

Modify db_migrator_policy_init.sh - remove any lines referencing upgrade and add the 2 lines under "Downgrade scripts"

Make/Redeploy to run downgrade

This should result in an error (last row in policyadmin_schema_changelog will have a success value of 0)

Remove timeStamp column from jpapdpstatistics_enginestats:

.. code::

    ALTER TABLE jpapdpstatistics_enginestats DROP COLUMN timeStamp;

The config job will retry 5 times. If you make your fix before this limit is reached you won't need to redeploy.

Redeploy to run downgrade

.. list-table::
   :widths: 60 20
   :header-rows: 0

   * - Number of files run
     - 14
   * - Tables in policyadmin
     - 73
   * - Records Added
     - 14
   * - schema_version
     - 0800

7. Downgrade to Honolulu (0800) after failed upgrade
****************************************************

Ensure you are on release 0800.

Modify db_migrator_policy_init.sh - remove any lines referencing downgrade and add the 2 lines under "Upgrade scripts"

Update pdpstatistics:

.. code::

    ALTER TABLE pdpstatistics ADD COLUMN POLICYUNDEPLOYCOUNT BIGINT DEFAULT NULL NULL AFTER POLICYEXECUTEDSUCCESSCOUNT;

Make/Redeploy to run upgrade

This should result in an error (last row in policyadmin_schema_changelog will have a success value of 0)

Once the retry count has been reached, update pdpstatistics:

.. code::

    ALTER TABLE pdpstatistics DROP COLUMN POLICYUNDEPLOYCOUNT;

Modify db_migrator_policy_init.sh - Remove any lines referencing upgrade and add the 2 lines under "Downgrade scripts"

Make/Redeploy to run downgrade

.. list-table::
   :widths: 60 20
   :header-rows: 0

   * - Number of files run
     - 7
   * - Tables in policyadmin
     - 73
   * - Records Added
     - 7
   * - schema_version
     - 0800

8. Upgrade to Istanbul (0900) after failed upgrade
**************************************************

Ensure you are on release 0800.

Modify db_migrator_policy_init.sh - remove any lines referencing downgrade and add the 2 lines under "Upgrade scripts"

Update PDP table:

.. code::

    ALTER TABLE pdp ADD COLUMN LASTUPDATE datetime NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER HEALTHY;

Make/Redeploy to run upgrade

This should result in an error (last row in policyadmin_schema_changelog will have a success value of 0)

Update PDP table:

.. code::

    ALTER TABLE pdp DROP COLUMN LASTUPDATE;

The config job will retry 5 times. If you make your fix before this limit is reached you won't need to redeploy.

Redeploy to run upgrade

.. list-table::
   :widths: 60 20
   :header-rows: 0

   * - Number of files run
     - 14
   * - Tables in policyadmin
     - 75
   * - Records Added
     - 14
   * - schema_version
     - 0900

9. Downgrade to Honolulu (0800) with data in pdpstatistics and jpapdpstatistics_enginestats
*******************************************************************************************

Ensure you are on release 0900.

Check pdpstatistics and jpapdpstatistics_enginestats are populated with data.

.. code::
  :number-lines:

    SELECT count(*) FROM pdpstatistics;
    SELECT count(*) FROM jpapdpstatistics_enginestats;

Modify db_migrator_policy_init.sh - remove any lines referencing upgrade and add the 2 lines under "Downgrade scripts"

Make/Redeploy to run downgrade

Check the tables to ensure the number of records is the same.

.. code::
  :number-lines:

    SELECT count(*) FROM pdpstatistics;
    SELECT count(*) FROM jpapdpstatistics_enginestats;

Check pdpstatistics to ensure the primary key has changed:

.. code::

    SELECT column_name, constraint_name FROM information_schema.key_column_usage WHERE table_name='pdpstatistics';

Check jpapdpstatistics_enginestats to ensure id column has been dropped and timestamp column added.

.. code::

    SELECT table_name, column_name, data_type FROM information_schema.columns WHERE table_name = 'jpapdpstatistics_enginestats';

Check the pdp table to ensure the LASTUPDATE column has been dropped.

.. code::

    SELECT table_name, column_name, data_type FROM information_schema.columns WHERE table_name = 'pdp';


.. list-table::
   :widths: 60 20
   :header-rows: 0

   * - Number of files run
     - 13
   * - Tables in policyadmin
     - 73
   * - Records Added
     - 13
   * - schema_version
     - 0800

10. Upgrade to Istanbul (0900) with data in pdpstatistics and jpapdpstatistics_enginestats
******************************************************************************************

Ensure you are on release 0800.

Check pdpstatistics and jpapdpstatistics_enginestats are populated with data.

.. code::
  :number-lines:

    SELECT count(*) FROM pdpstatistics;
    SELECT count(*) FROM jpapdpstatistics_enginestats;

Modify db_migrator_policy_init.sh - remove any lines referencing downgrade and add the 2 lines under "Upgrade scripts"

Make/Redeploy to run upgrade

Check the tables to ensure the number of records is the same.

.. code::
  :number-lines:

    SELECT count(*) FROM pdpstatistics;
    SELECT count(*) FROM jpapdpstatistics_enginestats;

Check pdpstatistics to ensure the primary key has changed:

.. code::

    SELECT column_name, constraint_name FROM information_schema.key_column_usage WHERE table_name='pdpstatistics';

Check jpapdpstatistics_enginestats to ensure timestamp column has been dropped and id column added.

.. code::

    SELECT table_name, column_name, data_type FROM information_schema.columns WHERE table_name = 'jpapdpstatistics_enginestats';

Check the pdp table to ensure the LASTUPDATE column has been added and the value has defaulted to the CURRENT_TIMESTAMP.

.. code::

    SELECT table_name, column_name, data_type, column_default FROM information_schema.columns WHERE table_name = 'pdp';

.. list-table::
   :widths: 60 20
   :header-rows: 0

   * - Number of files run
     - 13
   * - Tables in policyadmin
     - 75
   * - Records Added
     - 13
   * - schema_version
     - 0900

.. note::
   The number of records added may vary depending on the number of retries.

With addition of Postgres support to db-migrator, these tests can be also performed on a Postgres version of database.
In addition, scripts running the aforementioned scenarios can be found under `smoke-tests` folder on db-migrator code base.

End of Document
