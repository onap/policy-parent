
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
The "usecases" controller is carried forward from the El Alto release and will be deprecated in favor of the
"frankfurt" controller.

.. note::
   This feature is disabled by default. Please use the 'frankfurt' feature in lieu of this. We will be renaming the 'frankfurt'
   controller feature back to use cases in the Guilin release.

Usage
^^^^^

The feature is disabled by default.  The lifecycle "enabled" property can be toggled with
the "features" command line tool.

    .. code-block:: bash
       :caption: PDPD Features Command

        policy stop

        features disable controlloop-usecases     # enable/disable toggles the activation of the feature.

        policy start

End of Document
