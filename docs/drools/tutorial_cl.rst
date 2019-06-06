
.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

***********************************************************************************************
Using the Control Loop PDP-D docker image for standalone testing
***********************************************************************************************

.. contents::
    :depth: 3

In this tutorial will start a Control Loop PDP-D container to use to test Operational Policies
without companion components.

**Step 1:** Copy a template *base.conf* with configuration to instantiate the container.

    .. code-block:: bash

        mkdir config
        cd config
        wget https://git.onap.org/policy/docker/plain/config/drools/base.conf?h=dublin -O base.conf


**Step 2:** Simplify *base.conf* for a standalone configuration (by disabling db and nexus access):

    .. code-block:: bash

        cd config
        sed -i "s/^SQL_HOST=.*$/SQL_HOST=/g" base.conf
        sed -i "s/^SNAPSHOT_REPOSITORY_ID=.*$/SNAPSHOT_REPOSITORY_ID=/g" base.conf
        sed -i "s/^SNAPSHOT_REPOSITORY_URL=.*$/SNAPSHOT_REPOSITORY_URL=/g" base.conf
        sed -i "s/^RELEASE_REPOSITORY_ID=.*$/RELEASE_REPOSITORY_ID=/g" base.conf
        sed -i "s/^RELEASE_REPOSITORY_URL=.*$/RELEASE_REPOSITORY_URL=/g" base.conf

**Step 3:** Open a *bash* shell into the PDP-D Control Loop container.

    .. code-block:: bash

        docker run --rm --env-file config/base.conf -p 9696:9696 -it --name pdp nexus3.onap.org:10001/onap/policy-pdpd-cl:1.4.1 bash

**Step 4:** Disable the distributed-locking feature, since this is a single CL PDP-D instance.

    .. code-block:: bash

        features disable distributed-locking

**Step 4:** [OPTIONAL] If using simulators (see tutorials), enable the *controlloop-utils* feature.

    .. code-block:: bash

        features enable controlloop-utils

**Step 5:** [OPTIONAL] To reduce error logs due to being unable to communicate with DMaaP, change the official configuration to use *noop* topics instead (no network IO involved).

    .. code-block:: bash

        cd $POLICY_HOME/config
        sed -i "s/^dmaap/noop/g" *.properties

**Step 5:** Start the CL PDP-D.

    .. code-block:: bash

        policy start

**Step 6:** Place the CL PDP-D in *ACTIVE* mode.

    .. code-block:: bash

        cat pdp-state-change.json
        {
          "state": "ACTIVE",
          "messageName": "PDP_STATE_CHANGE",
          "requestId": "385146af-adeb-4157-b97d-6ae85c1ddcb3",
          "timestampMs": 1555791893587,
          "name": "8a9e0c256c59",
          "pdpGroup": "controlloop",
          "pdpSubgroup": "drools"
        }

        http --verify=no -a "${TELEMETRY_USER}:${TELEMETRY_PASSWORD}" PUT https://localhost:9696/policy/pdp/engine/topics/sources/noop/POLICY-PDP-PAP/events @pdp-state-change.json Content-Type:'text/plain'

        telemetry     # to verify
        > get lifecycle/fsm/state   # verify that state is ACTIVE

Note that *name* in *pdp-state-change.json* can be obtained from running *hostname* in the container.

Proceed with testing your new policy as described in the specific tutorials:

• vCPE - `Tutorial: Testing the vCPE use case in a standalone PDP-D <tutorial_vCPE.html>`_
• vDNS - `Tutorial: Testing the vDNS Use Case in a standalone PDP-D <tutorial_vDNS.html>`_
• vFW - `Tutorial: Testing the vFW flow in a standalone PDP-D <tutorial_vFW.html>`_
• VoLTE - `Tutorial: Testing the VOLTE Use Case in a standalone PDP-D <tutorial_VOLTE.html>`_


.. seealso:: To deploy a control loop in Eclipse from the control loop archetype template, refer to `Modifying the Release Template  <modAmsterTemplate.html>`_.


End of Document
