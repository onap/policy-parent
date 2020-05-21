
.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

*******************************
Feature: Control Loop Frankfurt
*******************************

.. contents::
    :depth: 3

Summary
^^^^^^^

The "controlloop-frankfurt" feature enables the "frankfurt" controller in a PDP-D.
The "frankfurt" controller supports the official ONAP use cases for Frankfurt.

.. note::
   This feature is enabled by default vs the usecases controller which will be deprecated. In the Guilin release we will
   be renaming this feature back to usecases.

Usage
^^^^^

The feature is enabled by default.  The lifecycle "enabled" property can be toggled with
the "features" command line tool.

    .. code-block:: bash
       :caption: PDPD Features Command

        policy stop

        features disable controlloop-frankfurt     # enable/disable toggles the activation of the feature.

        policy start

End of Document
