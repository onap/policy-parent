.. This work is licensed under a Creative Commons Attribution 4.0 International License.

OPA-PDP Decision
****************

.. contents::
    :depth: 3

OPA-PDP Decision
^^^^^^^^^^^^^^^^

      .. container:: sectionbody

         .. container:: paragraph

           OPA-PDP supports sending structured responses to decision requests. The OPA-PDP response is similar to the output from the Rego playground. The decision response is based on the "policy filter" provided in the decision request, which is mandatory. The "policyFilter" is a list of filter values, allowing multiple filters to be specified for the required output. If the policy filter contains an empty value, all output parameters are displayed. If an incorrect policy filter value is provided, valid input filters are displayed. The policy ID should be mentioned in the "policyName" field.
           Input field should be populated with json for which decision needs to be validated.

         .. csv-table::
           :header: "Header", "Example value", "Description"
           :widths: 25,10,70

           "policyName", "cell.consistency", "tosca-policy"
           "policyFilter", "allow", "output parameter"
           "input", "{cell:445611193265040128,PCI:2}", "input json"

         .. csv-table::
            :header: "/decision"
            :widths: 10

            `Decision Swagger <./local-swagger.html#tag/OPAPDPDecisionControllerv1>`_

         .. container:: paragraph

            This operation performs a decision request on PDP whether PCI value 2 can be modified on cell id 445611193265040128.
            Here is a sample request:

         .. literalinclude:: resources/decision_request.json
            :language: JSON
            :caption: cell.consistency decision request json

         .. container:: paragraph

            As the policy allows changes  on cell id 445611193265040128 and the pci is in range change is permitted.
            Here is a sample response:

         .. literalinclude:: resources/decision_response.json
            :language: JSON
            :caption: cell.consistency decision response

.. container::
   :name: footer

   .. container::
      :name: footer-text

      1.0.0-SNAPSHOT
      Last updated 2025-03-27 16:04:24 IST