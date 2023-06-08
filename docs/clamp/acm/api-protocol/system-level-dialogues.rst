.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _system-level-label:

ACM System Level Dialogues
##########################
Priming The CLAMP Automation Composition Runtime Lifecycle Management uses the following system-level dialogues. These dialogues enable the CLAMP runtime capabilities described in Section 2 of TOSCA Defined Automation Compositions: Architecture and Design. Design Time dialogues will be described in future releases of the system.


.. contents::
    :depth: 4


1 Dialogues on Participants
===========================
1.1 Register a Participant
--------------------------

Participant Registration is performed by a Participant when it starts up. It registers its ID and the ACM Element Types it supports with the ACM runtime.

.. image:: ../images/system-dialogues/RegisterParticipant.png

1.2 Deregister a Participant
----------------------------
Participant Deregistration is performed by a Participant when it shuts down. It deregisters its ID and type with the ACM runtime. The participant should already have cleared down all its ACM Element instances and set their states to "Not In Service".

.. image:: ../images/system-dialogues/DeregisterParticipant.png

1.3 Supervise Participants
--------------------------
Participant Supervision is performed periodically between participants and the ACM runtime server to ensure that registered participants are available over time. Participants send a heartbeat message to the ACM runtime at a configured interval. The heartbeat message contains updated status information for each AC Element Instance that has changed status since the last Heartbeat message sent by the participant.

.. image:: ../images/system-dialogues/SuperviseParticipantsStatusUpdate.png

The ACM runtime regularly checks the heartbeat reports from participants and takes action if participants time out. If a heartbeat message is not received for a participant in the Timeout Interval, the participant is marked as timed out and its ACM element instances are informed.

.. image:: ../images/system-dialogues/SuperviseParticipantsTimeout.png

1.4 Get Participant Information
-------------------------------
The information on participants is available over a REST endpoint.

.. image:: ../images/system-dialogues/GetParticipantInformation.png

1.5 Order Full Participant Report
---------------------------------

.. image:: ../images/system-dialogues/FullParticipantReport.png

2 Dialogues on Automation Composition Types
===========================================
Commissioning dialogues are used to commission and decommission Automation Composition Types and to set the values of Common Parameters. The values of common parameters are included in the TOSCA YAML file that defines the full Automation Composition Type.

2.1 Commission or Update an Automation Composition Type
-------------------------------------------------------
Create on a POST and update on a PUT.

.. image:: ../images/system-dialogues/CommissionUpdateAcType.png

2.2 Commission an Automation Composition Type using SDC
-------------------------------------------------------

.. image:: ../images/system-dialogues/CommissionAcTypeSDC.png

2.3 Decommission an Automation Composition Type
-----------------------------------------------

.. image:: ../images/system-dialogues/DecommissionAcType.png

2.4 Prime an Automation Composition Type on Participants
--------------------------------------------------------
The Priming operation sends Automation Composition Types and common property values to participants for each Automation Composition Element Type in the Automation Composition Type.

.. image:: ../images/system-dialogues/PrimeAcTypeOnPpnts.png

A participant should respond for each Automation Composition Element Type, thus causing the full Automation Composition Type to become primed. Note that if more than one participant can support an Automation Composition Element Type the ACM Runtime uses the participant in the first response it receives for that Automation Composition Element Type.

.. image:: ../images/system-dialogues/PrimeAcTypeMultiplePpnts.png

The ACM Runtime updates the priming information in the database.

.. image:: ../images/system-dialogues/PrimeInfoUpdatedInDb.png

2.5 Deprime an Automation Composition Type on Participants
----------------------------------------------------------
The Depriming operation removes Automation Composition Types and common property values on participants for each Automation Composition Element Type in the Automation Composition Type.

.. image:: ../images/system-dialogues/DeprimeOnParticipants.png

A participant should respond for each Automation Composition Element Type, thus causing the full Automation Composition Type to become deprimed.

.. image:: ../images/system-dialogues/DeprimeElements.png

The ACM Runtime updates the priming information in the database.

.. image:: ../images/system-dialogues/UpdateDeprimeInDb.png

2.6 Get Automation Composition Types
------------------------------------
This dialogue allows an Automation Composition Type to be read.

.. image:: ../images/system-dialogues/GetAcTypes.png

3. Instantiation Dialogues
==========================
Instantiation dialogues are used to create, set parameters on, instantiate, update, and remove Automation Composition instances.

3.1 Create an Automation Composition Instance
---------------------------------------------

.. image:: ../images/system-dialogues/CreateAcInstance.png

Note that this dialogue creates the Automation Composition Instance in the ACM database. The instance is sent to the participants using the process described in the dialogue in Section 3.3.

3.2 Delete an Automation Composition Instance
---------------------------------------------
The user requests the AC Instance to be deleted using a REST endpoint. The ACM Runtime orders the AC Instance to be deleted.

.. image:: ../images/system-dialogues/DeleteAcInstance.png

Each participant deletes its AC Element Instances from the AC Instance

.. image:: ../images/system-dialogues/DeleteInstanceElements.png

The ACM Runtime receives and stores the responses, when all instances element are deleted, it delete the instance.

.. image:: ../images/system-dialogues/DeleteResponseStored.png

3.3 Deploy Automation Composition Instance
------------------------------------------
The user requests the AC Instance to be deployed using a REST endpoint. The ACM Runtime orders the AC Instance to be deployed to Participants.

.. image:: ../images/system-dialogues/DeployAcInstance.png

Each participant deploys its AC Element Instances from the AC Instance.

.. image:: ../images/system-dialogues/DeployAcInstanceElements.png

The ACM Runtime receives and stores the responses.

.. image:: ../images/system-dialogues/DeployResponseStored.png

3.4 Update Automation Composition Instance
------------------------------------------
The user requests the AC Instance to be updated using a REST endpoint. The ACM Runtime orders the AC Instance to be updated.

.. image:: ../images/system-dialogues/UpdateAcInstance.png

Each participant updates its AC Element from the AC Instance

.. image:: ../images/system-dialogues/UpdateAcElements.png

The ACM Runtime receives and stores the responses.

.. image:: ../images/system-dialogues/UpdateAcElementsResponse.png

3.5 Undeploy Automation Composition Instance
--------------------------------------------
The user requests the AC Instance to be undeployed using a REST endpoint. The ACM Runtime orders the AC Instance to be undeployed.

.. image:: ../images/system-dialogues/UndeployInstance.png

Each participant undeploys its AC Element Instances from the AC Instance

.. image:: ../images/system-dialogues/UndeployInstanceElements.png

The ACM Runtime receives and stores the responses.

.. image:: ../images/system-dialogues/UndeployResponseStored.png

3.6 Read Automation Composition Instances
-----------------------------------------

.. image:: ../images/system-dialogues/ReadAcInstances.png

3.7 Unlock Automation Composition Instance
------------------------------------------
The user requests the AC Instance to be unlocked using a REST endpoint. The ACM Runtime orders the AC Instance to be unlocked on Participants.

.. image:: ../images/system-dialogues/OrderInstanceUnlock.png

Each participant unlocks its AC Element Instances from the AC Instance.

.. image:: ../images/system-dialogues/UnlockInstanceElements.png

The ACM Runtime receives and stores the responses.

.. image:: ../images/system-dialogues/UnlockResponseStored.png

3.8 Lock Automation Composition Instance
----------------------------------------
The user requests the AC Instance to be locked using a REST endpoint. The ACM Runtime orders the AC Instance to be locked on Participants.

.. image:: ../images/system-dialogues/LockAcInstance.png

Each participant locks its AC Element Instances from the AC Instance.

.. image:: ../images/system-dialogues/LockAcInstanceElements.png

The ACM Runtime receives and stores the responses.

.. image:: ../images/system-dialogues/LockResponseStored.png

3.9 Update Operational State on Automation Composition Instance
---------------------------------------------------------------

.. image:: ../images/system-dialogues/UpdateOperationalState.png

3.10 Update Usage State on Automation Composition Instance
----------------------------------------------------------

.. image:: ../images/system-dialogues/UpdateUsageState.png

End of Document
















