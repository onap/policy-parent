.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _drools-label:

.. contents::
    :depth: 4

************
Introduction
************

The Drools PDP, aka PDP-D, is the PDP in the Policy Framework that uses the
`Drools BRMS <https://www.drools.org/>`__ to enforce policies.

The PDP-D functionality can be thought of 2 different areas:

- PDP-D Engine.
- PDP-D Applications.

PDP-D Engine
============

The PDP-D Engine is the infrastructure that *policy applications* use,
providing services for networking, resource grouping, and diagnostics.

The PDP-D Engine supports the following Tosca Drools native Policy Types:

- onap.policies.native.Drools
- onap.policies.native.drools.Controller

These types are used to dynamically add and configure new application controllers.

The PDP-D Engine hosts applications by means of *controllers*.
*Controllers* may support other Tosca Policy Types.   The most common
types supported by the *Control Loop* application controllers are:

- onap.policies.controlloop.operational.common.Drools
- onap.policies.controlloop.Operational

See the following guides for more detailed information:

.. toctree::
   :maxdepth: 2

   pdpdEngine.rst

PDP-D Applications
==================

A PDP-D application is a named grouping of resources (*controllers*), that is managed by the PDP-D Engine.
This grouping typically contains references to communication endpoints, coordinates to a maven artifact,
and coders.

The PDP-D APPS software resides on the `policy/drools-applications repository <https://git.onap.org/policy/drools-applications>`__.

At present, *control loops* is the only application type delivered in ONAP.

See the following guide for additional information:

.. toctree::
   :maxdepth: 2

   pdpdApps.rst

