
.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

*******************
Feature: no locking
*******************

.. contents::
    :depth: 3

The no-locking feature allows applications to use a Lock Manager that always succeeds. It does not
deny acquiring resource locks.

To utilize the no-locking feature, first stop policy engine, disable other locking features, and
then enable it using the "*features*" command.

In an official OOM installation, place a script with a .pre.sh suffix:

    .. code-block:: bash
       :caption: features.pre.sh

        #!/bin/sh

        sh -c "features disable distributed-locking"
        sh -c "features enable no-locking"


under the directory:

    .. code-block:: bash

        oom/kubernetes/policy/components/policy-drools-pdp/resources/configmaps


and rebuild the policy charts.

At container initialization, the distributed-locking will be disabled, and the no-locking feature
will be enabled.

End of Document
