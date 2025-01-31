.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _policy-pap-smoke-testing-label:

.. toctree::
   :maxdepth: 2

Policy PAP Smoke Test
~~~~~~~~~~~~~~~~~~~~~

The policy-pap smoke testing is executed against a default ONAP installation as per OOM charts.
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
- Kafka for the communication between components.
- Policy PAP to perform runtime administration (deploy/undeploy/status/statistics/etc).
- Policy Apex-PDP to deploy & undeploy policies. And send heartbeats to PAP.
- Policy Drools-PDP to deploy & undeploy policies. And send heartbeats to PAP.
- Policy Xacml-PDP to deploy & undeploy policies. And send heartbeats to PAP.


Testing procedure
*****************

The test set is focused on the following use cases:

- Execute all the REST api's exposed by policy-pap component.

Create policies using policy-api
--------------------------------
In order to test policy-pap, we need to use policy-api component to create the policies.

Download & execute the steps in postman collection for creating policies.
The steps need to be performed sequentially one after another. And no input is required from user.

`Policy Framework Lifecycle API <https://github.com/onap/policy-api/blob/master/postman/lifecycle-api-collection.json>`_

Make sure to skip the delete policy steps.


Execute policy-pap testing
--------------------------
Download & execute the steps in postman collection for verifying policy-pap component.
The steps need to be performed sequentially one after another. And no input is required from user.

`Policy Framework Administration API <https://github.com/onap/policy-pap/blob/master/postman/pap-api-collection.json>`_

Make sure to execute the delete steps in order to clean the setup after testing.


Delete policies using policy-api
--------------------------------
Use the previously downloaded policy-api postman collection to delete the policies created for
testing.
