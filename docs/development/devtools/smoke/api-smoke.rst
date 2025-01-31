.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _policy-api-smoke-testing-label:

.. toctree::
   :maxdepth: 2

Policy API Smoke Test
~~~~~~~~~~~~~~~~~~~~~

The policy-api smoke testing is executed against a default ONAP installation as per OOM charts.
This test verifies the execution of all the REST api's exposed by the component to make sure the
contract works as expected.

General Setup
*************

The kubernetes installation will allocate all onap components across multiple worker node VMs.
The normal worker VM hosting onap components has the following spec:

- 16GB RAM
- 8 VCPU
- 160GB Ephemeral Disk


The ONAP components used during the smoke tests are:

- Policy API to perform CRUD of policies.
- Policy DB to store the policies.


Testing procedure
*****************

The test set is focused on the following use cases:

- Execute all the REST api's exposed by policy-api component.

Execute policy-api testing
--------------------------
Download & execute the steps in postman collection for verifying policy-api component.
The steps need to be performed sequentially one after another. And no input is required from user.

`Policy Framework Lifecycle API <https://github.com/onap/policy-api/blob/master/postman/lifecycle-api-collection.json>`_

Make sure to execute the delete steps in order to clean the setup after testing.
