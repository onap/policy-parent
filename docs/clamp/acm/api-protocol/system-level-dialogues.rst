.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _system-level-label:

System Level Dialogues
######################


.. contents::
    :depth: 4


The CLAMP Automation Composition Runtime Lifecycle Management uses the following system level dialogues.
These dialogues enable the CLAMP runtime capabilities described in :ref:`Section 2 of
TOSCA Defined Automation Compositions: Architecture and Design <acm-capabilities>`.
Design Time dialogues will be described in future releases of the system.


1 Commissioning Dialogues
=========================

Commissioning dialogues are used to commission and decommission Automation Composition Type definitions
and to set the values of Common Parameters.

Commissioning a Automation Composition Type is a three-step process:

#. The Automation Composition Type must be created, that is the Automation Composition Type definition must be
   loaded and stored in the database. This step may be carried out over the REST interface or
   using SDC distribution.

#. The Common Properties of the Automation Composition type must be assigned values and those values
   must be stored in the database. This step is optional only if all mandatory common properties
   have default values. The Common Property values may be set and amended over and over again
   in multiple sessions until the Automation Composition Type is primed.

#. The Automation Composition Type Definition and the Common Property values must be primed, that is
   sent to the concerned participants. Once a Automation Composition Type is primed, its Common Property
   values can no longer be changed. To change Common Properties on a primed Automation Composition Type,
   all instances of the Automation Composition Type must be removed and the Automation Composition Type must be
   de-primed.

1.1 Commissioning a Automation Composition Type Definition using the CLAMP GUI
------------------------------------------------------------------------------

This dialogue corresponds to a "File → Import" menu on the CLAMP GUI. The documentation of
future releases of the system will describe how the Design Time functionality interacts
with the Runtime commissioning API.

.. image:: ../images/system-dialogues/comissioning-clamp-gui.png

1.2 Commissioning a Automation Composition Type Definition using SDC
--------------------------------------------------------------------

.. image:: ../images/system-dialogues/comissioning-sdc.png

1.3 Setting Common Properties for a Automation Composition Type Definition
--------------------------------------------------------------------------

This dialogue sets the values of common properties. The values of the common properties
may be set, updated, or deleted at will, as this dialogue saves the properties to the
database but does not send the definitions or properties to the participants. However,
once a Automation Composition Type Definition and its properties are primed
(See :ref:`Section 1.4 <priming-cl-label>`), the properties cannot be changed until the automation composition type
definition is de-primed (See :ref:`Section 1.5 <depriming-cl-label>`).

.. image:: ../images/system-dialogues/common-properties-type-definition.png

.. _priming-cl-label:

1.4 Priming a Automation Composition Type Definition on Participants
--------------------------------------------------------------------
The Priming operation sends Automation Composition Type definitions and common property values
to participants. Once a Automation Composition Type definition is primed, its property values
can on longer be changed until it is de-primed.

.. image:: ../images/system-dialogues/priming-cl-type-definition.png

.. _depriming-cl-label:

1.5 De-Prime a Automation Composition Type Definition on Participants
---------------------------------------------------------------------

This dialogue allows a Automation Composition Type Definition to be de-primed so that it can be
deleted or its common parameter values can be altered.

.. image:: ../images/system-dialogues/depriming-cl-type-definition.png

1.6 Decommissioning a Automation Composition Type Definition in CLAMP
---------------------------------------------------------------------

.. image:: ../images/system-dialogues/decommission-cl-type-definition.png

1.7 Reading Commissioned Automation Composition Type Definitions
----------------------------------------------------------------

.. image:: ../images/system-dialogues/read-commision-cl-type-definition.png


2. Instantiation Dialogues
==========================

Instantiation dialogues are used to create, set parameters on, instantiate, update,
and remove Automation Composition instances.

Assume a suitable Automation Composition Definition exists in the Commissioned Automation Composition Inventory.
To get a Automation Composition instance running one would, for example, execute dialogues
:ref:`2.1 <creating-cl-instance>`, :ref:`2.3 <updating-cl-instance-config>`, and
:ref:`2.4 <changing-cl-instance-state>`.

.. _creating-cl-instance:

2.1 Creating a Automation Composition Instance
----------------------------------------------

.. image:: ../images/system-dialogues/create-cl-instance.png

.. note::
    This dialogue creates the Automation Composition Instance in the Instantiated Automation Composition Inventory.
    The instance is sent to the participants using the process described in the dialogue in
    :ref:`Section 2.3 <updating-cl-instance-config>`.

2.2 Updating Instance Specific Parameters on a Automation Composition Instance
------------------------------------------------------------------------------

.. image:: ../images/system-dialogues/update-instance-params-cl.png

.. _updating-cl-instance-config:

2.3 Updating a Automation Composition Instance with a Configuration on Participants
-----------------------------------------------------------------------------------

.. image:: ../images/system-dialogues/update-cl-instance-config-participants.png

.. _changing-cl-instance-state:

2.4 Changing the state of a Automation Composition Instance on Participants
---------------------------------------------------------------------------

.. image:: ../images/system-dialogues/change-cl-instance-state-participants.png

2.5 De-instantiating a Automation Composition Instance from Participants
------------------------------------------------------------------------

.. image:: ../images/system-dialogues/deinstantiate-cl-from-participants.png

2.6 Deleting a Automation Composition Instance
----------------------------------------------

.. image:: ../images/system-dialogues/delete-cl-instance.png

2.7 Reading Automation Composition Instances
--------------------------------------------

.. image:: ../images/system-dialogues/read-cl-instance.png


1. Monitoring Dialogues
=======================

Monitoring dialogues are used to monitor and to read statistics on Automation Composition Instances.

3.1 Reporting of Monitoring Information and Statistics by Participants
----------------------------------------------------------------------

.. image:: ../images/system-dialogues/monitoring-by-participants.png

3.2 Viewing of Monitoring Information
-------------------------------------

.. image:: ../images/system-dialogues/view-monitoring-info.png

3.2 Viewing of Statistics
-------------------------

.. image:: ../images/system-dialogues/view-statistics.png

3.3 Statistics Housekeeping
---------------------------

.. image:: ../images/system-dialogues/statistics-housekeeping.png


4. Supervision Dialogues
========================

Supervision dialogues are used to check the state of Automation Composition Instances and Participants.

4.1 Supervise Participants
--------------------------

.. image:: ../images/system-dialogues/supervise-participants.png

4.2 Supervise Automation Compositions
-------------------------------------

.. image:: ../images/system-dialogues/supervise-acms.png

End of Document
