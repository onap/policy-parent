
.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

******************
Feature: Lifecycle
******************

.. contents::
    :depth: 3

Summary
^^^^^^^

The "lifecycle" feature enables a PDP-D to work with the Dublin Release Policy architectural framework.

The lifecycle feature maintains three states: TERMINATED, PASSIVE, and ACTIVE.
The PAP (Dublin style) interacts with the lifecycle feature to put a PDP-D in PASSIVE or ACTIVE states.
The PASSIVE state allows for Tosca Operational policies to be deployed.
Policy execution is enabled when the PDP-D transitions to the ACTIVE state.

This feature can coexist side by side with the legacy mode of operation that predates the Dublin release.

Usage
^^^^^

The feature is enabled by default.
The lifecycle "enabled" property  can be toggled with the "features" command line tool available in PDP-D containers.

    .. code-block:: bash
       :caption: PDPD Features Command

        policy stop

        features disable lifecycle     # enable/disable toggles the activation of the feature.

        policy start

End of Document
