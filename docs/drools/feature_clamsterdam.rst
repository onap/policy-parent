
.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

******************
Feature: Lifecycle
******************

.. contents::
    :depth: 3

Summary
^^^^^^^

The "controlloop-amsterdam" feature enables the legacy "amsterdam" controller in a PDP-D.

Usage
^^^^^

The feature is enabled by default.  The lifecycle "enabled" property  can be toggled with the "features" command line tool available in PDP-D containers.

    .. code-block:: bash
       :caption: PDPD Features Command

        policy stop

        features disable controlloop-amsterdam     # enable/disable toggles the activation of the feature.

        policy start

End of Document
