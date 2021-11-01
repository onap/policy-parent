.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _clamp-pairwise-testing-label:

.. toctree::
   :maxdepth: 2

CLAMP <-> Dcae
~~~~~~~~~~~~~~

The pairwise testing is executed against a default ONAP installation in the OOM.
CLAMP-Control loop interacts with DCAE to deploy dcaegen2 services like PMSH.
This test verifies the interaction between DCAE and controlloop works as expected.

General Setup
*************

The kubernetes installation allocated all policy components across multiple worker node VMs.
The worker VM hosting the policy components has the following spec:

- 16GB RAM
- 8 VCPU
- 160GB Ephemeral Disk


The ONAP components used during the pairwise tests are:

- CLAMP control loop runtime, policy participant, kubernetes participant.
- DCAE for running dcaegen2-service via kubernetes participant.
- ChartMuseum service from platform, initialised with DCAE helm charts.
- DMaaP for the communication between Control loop runtime and participants.
- Policy Gui for instantiation and commissioning of control loops.


ChartMuseum Setup
*****************

The chartMuseum helm chart from the platform is deployed in the same cluster. The chart server is then initialized with the helm charts of dcaegen2-services by running the below script in OOM repo.
The script accepts the directory path as an argument where the helm charts are located.

.. code-block:: bash

    #!/bin/sh
    ./oom/kubernetes/contrib/tools/registry-initialize.sh -d /oom/kubernetes/dcaegen2-services/charts/

Testing procedure
*****************

The test set focused on the following use cases:

- Deployment and Configuration of DCAE microservice PMSH
- Undeployment of PMSH

Creation of the Control Loop:
-----------------------------
A Control Loop is created by commissioning a Tosca template with Control loop definitions and instantiating the Control Loop with the state "UNINITIALISED".

- Upload a TOSCA template from the POLICY GUI. The definitions includes a kubernetes participant and control loop elements that deploys and configures a microservice in the kubernetes cluster.
  Control loop element for kubernetes participant includes a helm chart information of DCAE microservice and the element for Http Participant includes the configuration entity for the microservice.
  :download:`Sample Tosca template <tosca/pairwise-testing.yml>`

  .. image:: images/cl-commission.png

  Verification: The template is commissioned successfully without errors.

- Instantiate the commissioned Control loop definitions from the Policy Gui under 'Instantiation Management'.

  .. image:: images/create-instance.png

  Update instance properties of the Control Loop Elements if required.

  .. image:: images/update-instance.PNG

  Verification: The control loop is created with default state "UNINITIALISED" without errors.

  .. image:: images/cl-instantiation.png


Deployment and Configuration of DCAE microservice (PMSH):
---------------------------------------------------------
The Control Loop state is changed from "UNINITIALISED" to "PASSIVE" from the Policy Gui. The kubernetes participant deploys the PMSH helm chart from the DCAE chartMuseum server.

.. image:: images/cl-passive.png

Verification:

- DCAE service PMSH is deployed in to the kubernetes cluster. PMSH pods are in RUNNING state.
  `helm ls -n <namespace>` - The helm deployment of dcaegen2 service PMSH is listed.
  `kubectl get pod -n <namespace>` - The PMSH pods are deployed, up and Running.

- The subscription configuration for PMSH microservice from the TOSCA definitions are updated in the Consul server. The configuration can be verified on the Consul server UI `http://<CONSUL-SERVER_IP>/ui/#/dc1/kv/`

- The overall state of the Control Loop is changed to "PASSIVE" in the Policy Gui.

.. image:: images/cl-create.png


Undeployment of DCAE microservice (PMSH):
-----------------------------------------
The Control Loop state is changed from "PASSIVE" to "UNINITIALISED" from the Policy Gui.

.. image:: images/cl-uninitialise.png

Verification:

- The kubernetes participant uninstall the DCAE PMSH helm chart from the kubernetes cluster. The pods are removed from the cluster.

- The overall state of the Control Loop is changed to "UNINITIALISED" in the Policy Gui.

.. image:: images/cl-uninitialised-state.png



