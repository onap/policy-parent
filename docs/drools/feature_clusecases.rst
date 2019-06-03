
.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

*******************************
Feature: Control Loop Use Cases
*******************************

.. contents::
    :depth: 3

Summary
^^^^^^^

The "controlloop-usecases" feature enables the "usecases" controller in a PDP-D.
The "usecases" controller supports the official ONAP use cases in a more efficient manner than 
the legacy "amsterdam" controller.
The main difference is that control loop provisioning does not need a new version upgrade
each time a control loop is added or removed.

Usage
^^^^^

The feature is enabled by default.  The lifecycle "enabled" property can be toggled with
the "features" command line tool.

    .. code-block:: bash
       :caption: PDPD Features Command

        policy stop

        features disable controlloop-usecases     # enable/disable toggles the activation of the feature.

        policy start

End of Document
