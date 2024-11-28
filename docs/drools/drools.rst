.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _drools-label:

Policy Drools PDP Engine
########################

.. contents::
    :depth: 1

The Drools PDP, aka PDP-D, is the PDP in the Policy Framework that uses the
`Drools BRMS <https://www.drools.org/>`_ to enforce policies.

The PDP-D functionality has been partitioned into two functional areas:

- PDP-D Engine.
- PDP-D Applications.

**PDP-D Engine**

The PDP-D Engine is the infrastructure that *policy applications* use. It provides networking
services, resource grouping, and diagnostics.

The PDP-D Engine supports the following Tosca Native Policy Types:

- onap.policies.native.Drools
- onap.policies.native.drools.Controller

These types are used to dynamically add and configure new application controllers.

The PDP-D Engine hosts applications by means of *controllers*. *Controllers* may support other
Tosca Policy Types. The types supported by the *Control Loop* applications are:

- onap.policies.controlloop.operational.common.Drools


**PDP-D Applications**

A PDP-D application, ie. a *controller*, contains references to the resources that the application
needs. These include networked endpoint references, and maven coordinates.

*Control Loop* applications are used in ONAP to enforce operational policies.


The following guides offer more information in these two functional areas.

.. toctree::
   :maxdepth: 2

   pdpdEngine.rst
   pdpdApps.rst


End of Document
