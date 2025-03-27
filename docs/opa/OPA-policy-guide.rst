.. This work is licensed under a Creative Commons Attribution 4.0 International License.

OPA PDP Policy Guide
********************

.. contents::
    :depth: 3

Policy Creation Steps
^^^^^^^^^^^^^^^^^^^^^

      .. container:: sectionbody

       .. container:: paragraph

          Following are the steps in writing a policy.

                .. container:: ulist

                1. write rego files for policy.OPA PDP supports rego version v1.
                2. write json file for data
                3. Encode rego files and json to base64
                4. write tosca policy with encoded content

          Let us assume we are writing a policy to check whether modifying a PCI value on a cell is allowed.

write rego files for policy
###########################

       .. container:: paragraph

          When writing Rego files, if you need to use data, you must reference it with the data key. For example: data.node.cell.consistency.minPCI.

            .. literalinclude:: resources/cell_consistency.rego
                :language: REGO
                :caption: rego code to check PCI range validation
                :linenos:

            .. literalinclude:: resources/cell_consistency_topology.rego
                :language: REGO
                :caption: rego code to check whether PCI change allowed on current cell
                :linenos:
.. note::
         .. container:: ulist

            -  OPA PDP supports rego version v1

write json for data
###################

            .. literalinclude:: resources/cell_consistency.json
                :language: JSON
                :caption: data file which acts as a data source for policy checks
                :linenos:

Encode rego files and json to base64 write tosca policy
########################################################

            .. literalinclude:: resources/cell_consistency.yaml
                :language: YAML
                :caption: tosca policy cell consistency
                :linenos:

       .. container:: paragraph

            In the above yaml file two fields that are important are data and policy.Both are of type map they have key and value pair.

   .. note::
         .. container:: ulist

            -  while writing policy keys  should start with policy-id (eg:cell.consistency,cell.consistency.topology)
            -  while writing data keys should start with node.<policy-id> (eg:node.cell.consistency)
            -  The package name (eg: cell.consistency)  inside the rego file should match the policy key.

       .. container:: paragraph

           TOSCA policy names must adhere to naming rules. The OPA PDP emphasizes that each TOSCA policy should have a unique policy name or policy ID. Internally, the OPA PDP creates directories based on the name structure. If two policy names share the same parent hierarchy (considering . as the hierarchy delimiter), deleting a policy higher in the hierarchy will also delete its child policies. To prevent this, the following constraints are added.

            .. container:: ulist

                - **Not Allowed**: If a policy named onap.org.cell is deployed, then deploying a policy named onap.org.cell.consistency is disallowed because this name shares the direct hierarchical structure.
                - **Not Allowed**: If a policy named onap.org.cell is deployed, then deploying a policy named onap.org is disallowed because it is parent directory.
                - **Allowed**: If a policy named onap.org.cell is deployed, then deploying a policy named onap.org.consistency,onap.org1.cell,onap1.org.cell is permitted, as it does not share the same hierarchy.


.. container:: footer
   :name: footer

   .. container:: footer-text
      :name: footer-text