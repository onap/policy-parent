.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _allowed-operations-label:

Allowed operations in ACM
#########################

.. contents::
    :depth: 4

CRUD Automation Composition Definition
--------------------------------------

+------------+--------------+----------------------------------+
| **Action** | **state**    | **Description**                  |
+------------+--------------+----------------------------------+
|   Create   |              |  Create new AC Definition        |
+------------+--------------+----------------------------------+
|   Update   | COMMISSIONED |  Update the AC Definition        |
+------------+--------------+----------------------------------+
|   Delete   | COMMISSIONED |  Delete the AC Definition        |
+------------+--------------+----------------------------------+

Change status of Automation Composition Definition
--------------------------------------------------

+------------+--------------+---------------------+-------------------------------------------------------+
| **Action** | **state**    |   **stChResult**    | **Description**                                       |
+------------+--------------+---------------------+-------------------------------------------------------+
|            | COMMISSIONED |                     | Start Priming transition                              |
+            +--------------+---------------------+-------------------------------------------------------+
|            | PRIMING      |   FAILED            | Start Priming transition after PRIMING is failed      |
+   Prime    +--------------+---------------------+-------------------------------------------------------+
|            | PRIMING      |   TIMEOUT           | Start Priming transition after PRIMING got timeout    |
+            +--------------+---------------------+-------------------------------------------------------+
|            | DEPRIMING    |   FAILED            | Start Priming transition after DEPRIMING is failed    |
+            +--------------+---------------------+-------------------------------------------------------+
|            | DEPRIMING    |   TIMEOUT           | Start Priming transition after DEPRIMING got timeout  |
+------------+--------------+---------------------+-------------------------------------------------------+
|            | PRIMED       |   NO_ERROR          | Start Depriming the AC Definition.                    |
|            |              |                     | No instances connected to this AC Definition.         |
+            +--------------+---------------------+-------------------------------------------------------+
|            | DEPRIMING    |   FAILED            | Start Depriming after DEPRIMING is failed             |
+  Deprime   +--------------+---------------------+-------------------------------------------------------+
|            | DEPRIMING    |   TIMEOUT           | Start Depriming after DEPRIMING got timeout           |
+            +--------------+---------------------+-------------------------------------------------------+
|            | PRIMING      |   FAILED            | Start Depriming after PRIMING is failed               |
+            +--------------+---------------------+-------------------------------------------------------+
|            | PRIMING      |   TIMEOUT           | Start Depriming after PRIMING got timeout             |
+------------+--------------+---------------------+-------------------------------------------------------+

**Note**: "stChResult" = stateChangeResult.

CRUD Automation Composition Instance
------------------------------------
AC Definition is PRIMED with NO_ERROR.

+------------+-----------------+---------------+-------------+----------------+-----------------------------------------------------------------------------+
| **Action** | **deployState** | **lockState** | **subSate** | **stChResult** | **Description**                                                             |
+------------+-----------------+---------------+-------------+----------------+-----------------------------------------------------------------------------+
| Create     |                 |               |             |                | Create a new AC instance                                                    |
+------------+-----------------+---------------+-------------+----------------+-----------------------------------------------------------------------------+
| Update     | UNDEPLOYED      |               |             |                | Update the AC Instance                                                      |
+            +-----------------+---------------+-------------+----------------+-----------------------------------------------------------------------------+
|            | DEPLOYED        |  LOCKED       |             |                | Start Updating and send update to participants                              |
+            +-----------------+---------------+-------------+----------------+-----------------------------------------------------------------------------+
|            | UPDATING        |  LOCKED       |             |  FAILED        | Start Updating and send update to participants after UPDATING is failed     |
+            +-----------------+---------------+-------------+----------------+-----------------------------------------------------------------------------+
|            | UPDATING        |  LOCKED       |             |  TIMEOUT       | Start Updating and send update to participants after UPDATING got timeout   |
+------------+-----------------+---------------+-------------+----------------+-----------------------------------------------------------------------------+
| Migrate    | DEPLOYED	       |  LOCKED       |             |                | Start Migrating and send migrate to participants                            |
+------------+-----------------+---------------+-------------+----------------+-----------------------------------------------------------------------------+
|            | UNDEPLOYED      |               |             |                | Start Deleting and send delete to participants                              |
+            +-----------------+---------------+-------------+----------------+-----------------------------------------------------------------------------+
| Delete     | UNDEPLOYED      |               |  PREPARING  |  FAILED        | Start Deleting and send delete to participants after PREPARING is failed    |
+            +-----------------+---------------+-------------+----------------+-----------------------------------------------------------------------------+
|            | UNDEPLOYED      |               |  PREPARING  |  TIMEOUT       | Start Deleting and send delete to participants after PREPARING got timeout  |
+            +-----------------+---------------+-------------+----------------+-----------------------------------------------------------------------------+
| Delete     | DELETING        |               |             |  FAILED        | Start Deleting and send delete to participants after DELETING is failed     |
+            +-----------------+---------------+-------------+----------------+-----------------------------------------------------------------------------+
|            | DELETING        |               |             |  TIMEOUT       | Start Deleting and send delete to participants after DELETING got timeout   |
+------------+-----------------+---------------+-------------+----------------+-----------------------------------------------------------------------------+

Change status of Automation Composition Instance
------------------------------------------------

+------------+-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
| **Action** | **deployState** | **lockState** | **subSate**           | **stChResult** | **Description**                                                                             |
+------------+-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | UNDEPLOYED      |               |                       |                | Start Deploying and send deploy to participants                                             |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYING       |  NONE         |                       |  FAILED        | Start Deploying and send deploy to participants after DEPLOYING is failed                   |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|  Deploy    | DEPLOYING       |  NONE         |                       |  TIMEOUT       | Start Deploying and send deploy to participants after DEPLOYING got timeout                 |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | UNDEPLOYING     |  NONE         |                       |  FAILED        | Start Deploying and send deploy to participants after UNDEPLOYING is failed                 |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | UNDEPLOYING     |  NONE         |                       |  TIMEOUT       | Start Deploying and send deploy to participants after UNDEPLOYING got timeout               |
+------------+-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYED        |  LOCKED       |                       |                | Start Undeploying and send undeploy to participants                                         |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYING       |  NONE         |                       |  FAILED        | Start Undeploying and send undeploy to participants after DEPLOYING is failed               |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYING       |  NONE         |                       |  TIMEOUT       | Start Undeploying and send undeploy to participants after DEPLOYING got timeout             |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYED        |  LOCKED       | REVIEWING             |  FAILED        | Start Undeploying and send undeploy to participants after REVIEWING is failed               |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYED        |  LOCKED       | REVIEWING             |  TIMEOUT       | Start Undeploying and send undeploy to participants after REVIEWING got timeout             |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYED        |  LOCKED       | MIGRATION_PRECHECKING |  FAILED        | Start Undeploying and send undeploy to participants after MIGRATION_PRECHECKING is failed   |
+  Undeploy  +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYED        |  LOCKED       | MIGRATION_PRECHECKING |  TIMEOUT       | Start Undeploying and send undeploy to participants after MIGRATION_PRECHECKING got timeout |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | UNDEPLOYING     |  NONE         |                       |  FAILED        | Start Undeploying and send undeploy to participants after UNDEPLOYING is failed             |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | UNDEPLOYING     |  NONE         |                       |  TIMEOUT       | Start Undeploying and send undeploy to participants after UNDEPLOYING got timeout           |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | UPDATING        |  LOCKED       |                       |  FAILED        | Start Undeploying and send update to participants after UPDATING is failed                  |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | UPDATING        |  LOCKED       |                       |  TIMEOUT       | Start Undeploying and send update to participants after UPDATING got timeout                |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | MIGRATING       |  LOCKED       |                       |  FAILED        | Start Undeploying and send update to participants after MIGRATING is failed                 |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | MIGRATING       |  LOCKED       |                       |  TIMEOUT       | Start Undeploying and send update to participants after MIGRATING got timeout               |
+------------+-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYED        |  UNLOCKED     |                       |                | Start Locking and send lock to participants                                                 |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYED        |  UNLOCKING    |                       |  FAILED        | Start Locking and send lock to participants after UNLOCKING is failed                       |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|   Lock     | DEPLOYED        |  UNLOCKING    |                       |  TIMEOUT       | Start Locking and send lock to participants after UNLOCKING got timeout                     |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYED        |  LOCKING      |                       |  FAILED        | Start Locking and send lock to participants after LOCKING is failed                         |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYED        |  LOCKING      |                       |  TIMEOUT       | Start Locking and send lock to participants after LOCKING got timeout                       |
+------------+-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYED        | LOCKED        |                       |                | Start Unlocking and send unlock to participants                                             |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYED        | UNLOCKING     |                       |  FAILED        | Start Unlocking and send unlock to participants after UNLOCKING is failed                   |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|  Unlock    | DEPLOYED        | UNLOCKING     |                       |  TIMEOUT       | Start Unlocking and send unlock to participants after UNLOCKING got timeout                 |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYED        | LOCKING       |                       |  FAILED        | Start Unlocking and send unlock to participants after LOCKING is failed                     |
+            +-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+
|            | DEPLOYED        | LOCKING       |                       |  TIMEOUT       | Start Unlocking and send unlock to participants after LOCKING got timeout                   |
+------------+-----------------+---------------+-----------------------+----------------+---------------------------------------------------------------------------------------------+

Sub status of Automation Composition Instance
---------------------------------------------

+---------------------+-----------------+---------------+-----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+
| **Action**          | **deployState** | **lockState** | **subSate**           | **stChResult** | **Description**                                                                                                 |
+---------------------+-----------------+---------------+-----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+
|                     | UNDEPLOYED      |               |                       |                | Start Preparing and send prepare to participants                                                                |
+                     +-----------------+---------------+-----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+
|  Prepare            | UNDEPLOYED      |               | PREPARING             |  FAILED        | Start Preparing and send prepare to participants after PREPARING is failed                                      |
+                     +-----------------+---------------+-----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+
|                     | UNDEPLOYED      |               | PREPARING             |  TIMEOUT       | Start Preparing and send prepare to participants after PREPARING got timeout                                    |
+---------------------+-----------------+---------------+-----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+
|                     | DEPLOYED        | LOCKED        |                       |                | Start Reviewing and send review to participants                                                                 |
+                     +-----------------+---------------+-----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+
|  Review             | DEPLOYED        | LOCKED        | REVIEWING             |  FAILED        | Start Reviewing and send review to participants after REVIEWING is failed                                       |
+                     +-----------------+---------------+-----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+
|                     | DEPLOYED        | LOCKED        | REVIEWING             |  TIMEOUT       | Start Reviewing and send review to participants after REVIEWING got timeout                                     |
+---------------------+-----------------+---------------+-----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+
|                     | DEPLOYED        | LOCKED        |                       |                | Start Migration-Prechecking and send Migration-Precheck to participants                                         |
+                     +-----------------+---------------+-----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+
|  Migration-Precheck | DEPLOYED        | LOCKED        | MIGRATION_PRECHECKING |  FAILED        | Start Migration-Prechecking and send Migration-Precheck to participants after MIGRATION_PRECHECKING is failed   |
+                     +-----------------+---------------+-----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+
|                     | DEPLOYED        | LOCKED        | MIGRATION_PRECHECKING |  TIMEOUT       | Start Migration-Prechecking and send Migration-Precheck to participants after MIGRATION_PRECHECKING got timeout |
+---------------------+-----------------+---------------+-----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+
