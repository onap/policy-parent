OPA-PDP Dynamic Data Update
***************************

.. contents::
    :depth: 3

OPA-PDP Dynamic Data Update
^^^^^^^^^^^^^^^^^^^^^^^^^^^

      .. container:: sectionbody

         .. container:: paragraph

            The Data API provides endpoints for reading and writing data in OPA-PDP. However, data updated via the Data API is not persisted in OPA-PDP.
            This feature is useful for scenarios where data needs to be dynamically modified without redeploying the policy. Users can also fine-tune and validate the data configuration. Once the configuration is finalized, users can undeploy the existing policy and create new data/policy with the updated configuration.

GET a Document
^^^^^^^^^^^^^^

         .. csv-table::
            :header: "/data/{path:.+}","method","example"
            :widths: 25,5,25

            `Data Swagger <./local-swagger.html#tag/OPAPDPDecisionControllerv1>`_,"GET","/data/node/cell/consistency"

         .. container:: paragraph

            This operation gets the data stored in PDP in json format.

         .. literalinclude:: resources/data_get_response.json
            :language: JSON
            :caption: response for GET cell.consistency data stored in OPA-PDP

Patch a Document
^^^^^^^^^^^^^^^^

         .. csv-table::
            :header: "/data/{path:.+}","method","example"
            :widths: 25,5,25

            `Data Swagger <./local-swagger.html#tag/OPAPDPDecisionControllerv1>`_,"PATCH","/data/node/cell/consistency"

         .. container:: paragraph

            Update a document.

            OPA_PDP accepts updates encoded as JSON Patch operations. The message body of the request should contain a JSON encoded array containing one or more JSON Patch operations.
            Each operation specifies the operation type, path, and an optional value. For more information on JSON Patch, see `RFC 6902 <https://www.rfc-editor.org/rfc/rfc6902>`__.

            The effective path of the JSON Patch operation is obtained by joining the path portion of the URL with the path value from the operation(s) contained in the message body.
            In all cases, the parent of the effective path MUST refer to an existing document, otherwise the server returns 404. In the case of **remove** and **replace** operations, the effective path MUST refer to an existing document, otherwise the server returns 404.

         .. csv-table::
           :header: "Header", "Example value", "Description"
           :widths: 25,10,70

           "policyName", "cell.consistency", "tosca-policy"
           "op", "add,replace,remove", "operation type"
           "path", "maxPCI", "path at which operation needs to be performed  refer RFC 6902"
           "value","4000", "A string or json content that needs to be replaced or added"

         .. literalinclude:: resources/data_replace_request.json
            :language: JSON
            :caption: **replace** maxPCI data value to 4000 in cell.consistency policy

         .. literalinclude:: resources/data_remove_request.json
            :language: JSON
            :caption: **remove** maxPCI element from data in cell.consistency policy

         .. literalinclude:: resources/data_add_request.json
            :language: JSON
            :caption: **add** test json element to data in cell.consistency policy

Dynamic Data Patch Conditions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Rules and Constraints applied when performing dynamic data patch operations in the `policy-opa-pdp` system. These conditions ensure data integrity and policy consistency during runtime updates.

         
Patch Preconditions
^^^^^^^^^^^^^^^^^^^

1. **Deployment Requirement**
       - The `policyName` provided in the dynamic data patch payload must correspond to a policy that has already been deployed.
       - Patching is not permitted for non-existent or undeployed policies.

2. **Scoped Data Modification**
       - If the specified `policyName` exists, the patch operation is restricted to the `data.node` associated with that policy.
       - Modifications outside the scope of the associated `data.node` are not allowed.

3. **Data Type Compatibility**
       - If the existing `data.node` is a JSON object:
           * New keys of any valid JSON type (object, array, string, boolean, number) may be added.
           * These keys will be inserted under the existing JSON object structure.
       - If the existing `data.node` is a JSON array:
           * The array must be replaced in its entirety.
           * Partial additions or modifications are not supported, as they may render the policy non-functional.

4. **Operation Constraints**
       - Patch operations such as `replace` and `remove` are only valid if the target key already exists within the current `data.node`.
       - Attempting to modify or remove non-existent keys will result in rejection of the patch request.

       These rules are enforced to maintain the operational stability and correctness of policy evaluations during dynamic updates.

.. warning::
       .. container:: paragraph

         Improper dynamic data updates can leave the data in an incorrect state. In such situations,
         you can undeploy and redeploy the policy to restore the old data. Some common mistakes to avoid include:

         .. container:: ulist

            -  Removing JSON elements without restoring them.
            -  Replacing values without restoring them.
            -  Adding unnecessary data elements.

.. container::
   :name: footer

   .. container::
      :name: footer-text

      1.0.0-SNAPSHOT
      Last updated 2025-03-27 16:04:24 IST
