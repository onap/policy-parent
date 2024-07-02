.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _acm-states-label:

ACM States
##########

.. contents::
    :depth: 4

Automation Composition Management manages a number of states of various types to manage the lifecycle of compositions. Those states are described here. Please also see the ACM System Level Dialogues page to see the system dialogues that change states and how states interrelate in detail. Please also see ITU Recommendation X.731, which is reflected in the states of AC Element Instances.

Participant Replica State
=========================
Any participant could have more than one replica.
Participant replica states are NOT managed by ACM but the state of a participant replica is recorded and supervised by ACM.

.. image:: images/acm-states/ParticipantStates.png


Automation Composition Type State
=================================
The states that an Automation Composition Type can have, are shown in the diagram below.

.. image:: images/acm-states/AcTypeStates.png

Automation Composition Element Type State
=========================================
The states that an Automation Composition Element Type can have on ACM Runtime are shown in the diagram below.

.. image:: images/acm-states/AcElementTypeStatesOnRuntime.png

The states that an Automation Composition Element Type can have on a Participant are shown in the diagram below.

.. image:: images/acm-states/AcElementTypeStatesOnPpnt.png

The states diagram below, shows the fail and timeout scenario.
In that diagram the state is presented using this combination [ Composition Element Type State : Composition Type State : StateChangeResult ].

.. image:: images/acm-states/AcTypeStatesFail.png

Automation Composition Instance State
=====================================
The states that an Automation Composition Instance can have are shown in the diagram below.

.. image:: images/acm-states/AcInstanceStates.png

Automation Composition Element Instance State
=============================================
The states that an Automation Composition Element Instance can have on ACM Runtime are shown in the diagram below.

.. image:: images/acm-states/AcElementInstanceStatesOnRuntime.png

The states that an Automation Composition Element Instance can have on a Participant are shown in the diagram below.

.. image:: images/acm-states/AcElementInstanceStatesOnPpnt.png

Automation Composition State with fail and timeout
==================================================
The states that an Automation Composition Element Instance can have for each flow, are shown in the diagrams below.
For each diagram the state is presented using this combination [ Instance Element State : Instance State : StateChangeResult ].

Deploy
------

.. image:: images/acm-states/AcInstanceStatesDeploy.png

Update
------

.. image:: images/acm-states/AcInstanceStatesUpdate.png

Migrate
-------

.. image:: images/acm-states/AcInstanceStatesMigrate.png

Delete
------

.. image:: images/acm-states/AcInstanceStatesDelete.png

End of Document
