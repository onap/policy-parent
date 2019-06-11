.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _xacmltutorial-label:

Policy XACML - Custom Application Tutorial
##########################################

.. toctree::
   :maxdepth: 3

Design a Policy Type
********************
Follow :ref:`TOSCA Policy Primer <tosca-label>` for more information. For the tutorial, we will use
this example Policy Type in which an ONAP PEP client would like to enforce an action **authorize**
on users to execute a permission on a resource.

.. code-bloack:: yaml
  :caption: Example Tutorial Policy Type
  :linenos:

tosca_definitions_version: tosca_simple_yaml_1_0_0
policy_types:
  -
    onap.policies.Authorization:
	derived_from: tosca.policies.Root
	version: 1.0.0
	description: Example tutorial policy type for doing user authorization
	properties:
	    user:
		type: string
		required: true
		description: The unique user name
	    permissions:
		type: list
		required: true
		description: A list of resource permissions
		entry_schema:
		    type: onap.datatypes.Tutorial
data_types:
  -
    onap.datatypes.Tutorial:
    derived_from: tosca.datatypes.Root
    version: 1.0.0
    properties:
	resource:
	    type: string
	    required: true
	    description: The resource
	permission:
	    type: string
	    required: true
	    description: The permission level
	    constraints:
		- valid_values: [read, write, delete]

We would expect then to be able to create the following policies to allow the demo user to Read/Write
a resource called foo. While the audit user can only read the resource called foo. No user has Delete
permission.

.. code-block:: yaml
  :caption: Example Policies Derived From Tutorial Policy Type
  :linenos:

tosca_definitions_version: tosca_simple_yaml_1_0_0
topology_template:
    policies:
        -
            onap.policy.tutorial.demo:
                type: onap.policies.Authorization
                version: 1.0.0
                metadata:
                    policy-id: onap.policy.tutorial.demo
                properties:
                    user: demo
                    permissions:
                        -
                            resource: foo
                            permission: read
                        -
                            resource: foo
                            permission: write
        -
            onap.policy.tutorial.audit:
                type: onap.policies.Authorization
                version: 1.0.0
                metadata:
                    policy-id: onap.policy.tutorial.bar
                properties:
                    user: audit
                    permissions:
                        -
                            resource: foo
                            permission: read

Create A Maven Project
**********************
This part of the tutorial assumes you understand how to use Eclipse to create an Maven
project. Please follow any examples for the Eclipse installation to create a blank
application.


