.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _policy-apex-smoke-testing-label:

.. toctree::
   :maxdepth: 2

Apex-PDP Smoke Test
~~~~~~~~~~~~~~~~~~~

The apex-pdp smoke testing is executed against a default ONAP installation as per OOM charts.
This test verifies the functionalities supported by apex-pdp to make sure they are working as expected.

General Setup
*************

The kubernetes installation will allocate all onap components across multiple worker node VMs.
The normal worker VM hosting onap components has the following spec:

- 16GB RAM
- 8 VCPU
- 160GB Ephemeral Disk


The ONAP components used during the smoke tests are:

- AAI for creating dummy VNF & PNF for testing purpose.
- CDS for publishing the blueprints & triggering the actions.
- DMaaP for the communication between components.
- Policy API to perform CRUD of policies.
- Policy PAP to perform runtime administration (deploy/undeploy/status/statistics/etc).
- Policy Apex-PDP to execute policies for both VNF & PNF scenarios.


Testing procedure
*****************

The test set is focused on the following use cases:

- End to end testing of a sample VNF based policy using Apex-PDP.
- End to end testing of a sample PNF based policy using Apex-PDP.

Creation of VNF & PNF in AAI
----------------------------
In order for PDP engines to fetch the resource details from AAI during runtime execution, we need to create dummy VNF & PNF entities in AAI.
In a real control loop flow, the entities in AAI will be either created during orchestration phase or provisioned in AAI separately.

Download & execute the steps in postman collection for creating the entities along with its dependencies.
The steps need to be performed sequentially one after another. And no input is required from user.

:download:`Create VNF & PNF in AAI </development/devtools/postman/create-vnf-pnf-aai.postman_collection.json>`

Make sure to skip the delete VNF & PNF steps.


Publish Blueprints in CDS
-------------------------
In order for PDP engines to trigger an action in CDS during runtime execution, we need to publish relevant blueprints in CDS.

Download the zip files containing the blueprint for VNF & PNF specific actions.

:download:`VNF Test CBA </development/devtools/cds-cba/vnf-test-cba.zip>`
:download:`PNF Test CBA </development/devtools/cds-cba/pnf-test-cba.zip>`

Download & execute the steps in postman collection for publishing the blueprints in CDS.
In the enrich & publish CBA step, provide the previously downloaded zip file one by one.
The execute steps are provided to verify that the blueprints are working as expected.

:download:`Publish Blueprints in CDS </development/devtools/postman/publish-cba-CDS.postman_collection.json>`

Make sure to skip the delete CBA step.


Apex-PDP VNF & PNF testing
--------------------------
The below provided postman collection is prepared to have end to end testing experience of apex-pdp engine.
Including both VNF & PNF scenarios.
List of steps covered in the postman collection:

- Create & Verify VNF & PNF policies as per policy type supported by apex-pdp.
- Deploy both VNF & PNF policies to apex-pdp engine.
- Query PdpGroup at multiple stages to verify current set of policies deployed.
- Fetch policy status at multiple stages to verify policy deployment & undeployment status.
- Fetch policy audit information at multiple stages to verify policy deployment & undeployment operations.
- Fetch PDP Statistics at multiple stages to verify deployment, undeployment & execution counts.
- Send onset events to DMaaP for triggering policies to test both success & failure secnarios.
- Read policy notifications from DMaaP to verify policy execution.
- Undeploy both VNF & PNF policies from apex-pdp engine.
- Delete both VNF & PNF policies at the end.

Download & execute the steps in postman collection.
The steps need to be performed sequentially one after another. And no input is required from user.

:download:`Apex-PDP VNF & PNF Testing </development/devtools/postman/apex-pdp-vnf-pnf-testing.postman_collection.json>`

Make sure to wait for 2 minutes (the default heartbeat interval) to verify PDP Statistics.


Delete Blueprints in CDS
------------------------
Use the previously downloaded CDS postman collection to delete the blueprints published in CDS for testing.


Delete VNF & PNF in AAI
-----------------------
Use the previously downloaded AAI postman collection to delete the VNF & PNF entities created in AAI for testing.
