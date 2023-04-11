.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _apex-policy-examples-label:

Policy Examples
***************

.. toctree::
   :maxdepth: 1

   APEX-MyFirstPolicyExample.rst
   APEX-DecisionMakerExample.rst

.. contents::
    :depth: 3

Sample APEX Policy in TOSCA format
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

         .. container:: paragraph

            An example APEX policy in TOSCA format for the vCPE
            use case can be found here:

         .. container:: ulist

            -  `APEX TOSCA Policy
               vCPE <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vCPE.apex.policy.operational.input.tosca.json>`__

My First Policy
^^^^^^^^^^^^^^^

         .. container:: paragraph

            A good starting point is the ``My First Policy`` example. It
            describes a sales problem, to which policy can be applied.
            The example details the policy background, shows how to use
            the REST Editor to create a policy, and provides details for
            running the policies. The documentation can be found:

         .. container:: ulist

            -  :ref:`My-First-Policy Example <apex-myFirstExample>`

Decision Maker
^^^^^^^^^^^^^^

         .. container:: paragraph

            The domain Decision Maker shows a very simple policy for
            decisions. Interesting here is that the it creates a Docker
            image to run the policy and that it uses the APEX REST
            applications to update the policy on the-fly. It also has
            local context to remember past decisions, and shows how to
            use that to no make the same decision twice in a row. The
            documentation can be found:

         .. container:: ulist

            -  :ref:`Decision Maker on APEX site <apex-DecisionMakerExample>`

.. container::
   :name: footer

   .. container::
      :name: footer-text

      2.3.0-SNAPSHOT
      Last updated 2020-04-08 16:04:24 GMT