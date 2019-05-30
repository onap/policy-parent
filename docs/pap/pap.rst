.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _pap-label:

THIS TEXT WAS DUMPED IN FROM THE DESIGN PAGE IN CONFLUENCE
##########################################################

Policy Administration Point (PAP) Architecture
----------------------------------------------
.. toctree::
   :maxdepth: 1

There are a number of rules for state management:

1. Only one version of a PDP group may be ACTIVE at any time

2. If a PDP group with a certain version is ACTIVE and a later version   of the same PDP group is activated, then the
   system upgrades the PDP group

3. If a PDP group with a certain version is ACTIVE and an earlier version of the same PDP group is activated, then the
   system downgrades the PDP group

4. There is no restriction on the number of PASSIVE versions of a PDP group that can exist in the system

5. <Rules on SAFE/TEST> ? `Pamela
   Dragosh <file://localhost/display/~pdragosh>`__


It also allows a PDP group
health check to be ordered on PDP groups and on individual PDPs.

 As health checks may be long lived operations,
Health checks are scheduled for execution by this operation. Users check
the result of a health check test by issuing a PDP Group Query operation
(see Section 3.3.1) and checking the *healthy* field of PDPs.


3.3 Policy Administration API
-----------------------------

The purpose of this API is to support CRUD of PDP groups and subgroups
and to support the deployment and life cycles of *PolicyImpl* entities
(TOSCA *Policy* and *PolicyTypeImpl* entities) on PDP sub groups and
PDPs. See Section 2 for details on policy deployment on PDP groups and
subgroups. This API is provided by the *PolicyAdministration* component
(PAP) of the Policy Framework, see `The ONAP Policy
Framework <file://localhost/display/DW/The+ONAP+Policy+Framework>`__
architecture.

PDP groups and subgroups may be prefedined in the system. Predefined
groups and subgroups may not be modified or deleted over this API.
However, the policies running on predefined groups or subgroups as well
as the instance counts and properties may be modified.

A PDP may be preconfigured with its PDP group, PDP subgroup, and
policies. The PDP sends this information to the PAP when it starts. If
the PDP group, subgroup, or any policy is unknown to the PAP, the PAP
locks the PDP in state PASSIVE.

The fields below are valid on API calls:

============= ====================== ======================== ========== ========================================================================= ===================================================================== ==============================================================================================
**Field**     **GET**                **POST**                 **DELETE** **Comment**
============= ====================== ======================== ========== ========================================================================= ===================================================================== ==============================================================================================
name          M                      M                        M          The name of the PDP group
version       O                      M                        C          The version of the PDP group
state         R                      N/A                      N/A        The administrative state of the PDP group: PASSIVE, SAFE, TEST, or ACTIVE
description   R                      O                        N/A        The PDP group description
properties    R                      O                        N/A        Specific properties for a PDP group
pdp_subgroups R                      M                        N/A        A list of PDP subgroups for a PDP group
\             pdp_type               R                        M          N/A                                                                       The PDP type of this PDP subgroup, currently xacml, drools, or apex
\             supported_policy_types R                        N/A        N/A                                                                       A list of the policy types supported by the PDPs in this PDP subgroup
\             policies               R                        M          N/A                                                                       The list of policies running on the PDPs in this PDP subgroup
\                                    (name)                   R          M                                                                         N/A                                                                   The name of a TOSCA policy running in this PDP subgroup
\                                    policy_type              R          N/A                                                                       N/A                                                                   The TOSCA policy type of the policy
\                                    policy_type_version      R          N/A                                                                       N/A                                                                   The version of the TOSCA policy type of the policy
\                                    policy_type_impl         R          C                                                                         N/A                                                                   The policy type implementation (XACML, Drools Rules, or APEX Model) that implements the policy
\             instance_count         R                        N/A        N/A                                                                       The number of PDP instances running in a PDP subgroup
\             min_instance_count     O                        N/A        N/A                                                                       The minumum number of PDP instances to run in a PDP subgroup
\             properties             O                        N/A        N/A                                                                       Deployment configuration or other properties for the PDP subgroup
\             deployment_info        R                        N/A        N/A                                                                       Information on the deployment for a PDP subgroup
\             instances              R                        N/A        N/A                                                                       A list of PDP instances running in a PDP subgroup
\                                    instance                 R          N/A                                                                       N/A                                                                   The instance ID of a PDP running in a Kuberenetes Pod
\                                    state                    R          N/A                                                                       N/A                                                                   The administrative state of the PDP: PASSIVE, SAFE, TEST, or ACTIVE
\                                    healthy                  R          N/A                                                                       N/A                                                                   The result of the latest health check on the PDP: HEALTHY/NOT_HEALTHY/TEST_IN_PROGRESS
\                                    message                  O          N/A                                                                       N/A                                                                   A status message for the PDP if any
\                                    deployment_instance_info R          N/A                                                                       N/A                                                                   Information on the node running the PDP
============= ====================== ======================== ========== ========================================================================= ===================================================================== ==============================================================================================

Note: In the Dublin release, the *policy_type_impl* of all policy types
in a PDP subgroup must be the same.

YAML is used for illustrative purposes in the examples in this section.
JSON (application/json) will be used as the content type in the
implementation of this API.

3.3.1 PDP Group Query
~~~~~~~~~~~~~~~~~~~~~

This operation allows the PDP groups and subgroups to be listed together
with the policies that are deployed on each PDP group and subgroup.

*https:{url}:{port}/policy/pap/v1/pdps GET*

**PDP Group query for all PDP groups and Subgroups**  Expand source

pdp_groups:

- name: onap.pdpgroup.controlloop.Operational

version: 1.0.0

state: active

description: ONAP Control Loop Operational and Guard policies

  properties:

# PDP group level properties if any

pdp_subgroups:

pdp_type: drools

supported_policy_types:

- onap.controllloop.operational.drools.vCPE

- onap.controllloop.operational.drools.vFW

  policies:

- onap.controllloop.operational.drools.vCPE.eastRegion:

policy_type: onap.controllloop.operational.drools.vCPE

policy_type_version: 1.0.0

policy_type_impl: onap.controllloop.operational.drools.impl

- onap.controllloop.operational.drools.vFW.eastRegion:

policy_type: onap.controllloop.operational.drools.vFW

policy_type_version: 1.0.0

policy_type_impl: onap.controllloop.operational.drools.impl

min_instance_count: 3

 instance_count: 3

properties:

# The properties below are for illustration only

instance_spawn_load_threshold: 70%

instance_kill_load_threshold: 50%

instance_geo_redundancy: true

deployment_info:

service_endpoint: https://<the drools service endpoint for this PDP
group>

deployment: A deployment identifier

# Other deployment info

instances:

- instance: drools_1

state: active

healthy: yes

deployment_instance_info:

node_address: drools_1_pod

# Other deployment instance info

- instance: drools_2

state: active

healthy: yes

 deployment_instance_info:

node_address: drools_2_pod

# Other deployment instance info

- instance: drools_3

state: active

healthy: yes

 deployment_instance_info:

node_address: drools_3_pod

# Other deployment instance info

- pdp_type: apex

supported_policy_types:

- onap.controllloop.operational.apex.BBS

- onap.controllloop.operational.apex.SampleDomain

policies:

- onap.controllloop.operational.apex.BBS.eastRegion:

policy_type: onap.controllloop.operational.apex.BBS

policy_type_version: 1.0.0

policy_type_impl: onap.controllloop.operational.apex.impl

- onap.controllloop.operational.apex.sampledomain.eastRegion:

policy_type: onap.controllloop.operational.apex.SampleDomain

policy_type_version: 1.0.0

policy_type_impl: onap.controllloop.operational.apex.impl

min_instance_count: 2

 instance_count: 3

properties:

# The properties below are for illustration only

instance_spawn_load_threshold: 80%

instance_kill_load_threshold: 60%

instance_geo_redundancy: true

deployment_info:

service_endpoint: https://<the apex service endpoint for this PDP group>

deployment: A deployment identifier

# Other deployment info

instances:

- instance: apex_1

state: active

healthy: yes

  deployment_instance_info:

node_address: apex_1_podgroup

# Other deployment instance info

- instance: apex_2

deployment_instance_info:

node_address: apex_2_pod

# Other deployment instance infoCreation

- instance: apex_3

state: active

healthy: yes

  deployment_instance_info:

node_address: apex_3_pod

# Other deployment instance info

- pdp_type: xacml

supported_policy_types:

- onap.policies.controlloop.guard.FrequencyLimiter

  - onap.policies.controlloop.guard.BlackList

- onap.policies.controlloop.guard.MinMax

policies:

- onap.policies.controlloop.guard.frequencylimiter.EastRegion:

policy_type: onap.policies.controlloop.guard.FrequencyLimiter

policy_type_version: 1.0.0

policy_type_impl: onap.controllloop.guard.impl

- onap.policies.controlloop.guard.blackList.EastRegion:

policy_type: onap.policies.controlloop.guard.BlackList

policy_type_version: 1.0.0

policy_type_impl: onap.controllloop.guard.impl

- onap.policies.controlloop.Guard.MinMax.EastRegion:

policy_type: onap.policies.controlloop.guard.MinMax

policy_type_version: 1.0.0

policy_type_impl: onap.controllloop.guard.impl

min_instance_count: 2

  instance_count: 2

properties:

# The properties below are for illustration only

instance_geo_redundancy: true

deployment_info:

service_endpoint: https://<the XACML service endpoint for this PDP
group>

deployment: A deployment identifier

# Other deployment info

instances:

- instance: xacml_1

state: active

healthy: yes

 deployment_instance_info:

node_address: xacml_1_pod

# Other deployment instance info

- instance: xacml_2

state: active

healthy: yes

 deployment_instance_info:

node_address: xacml_2_pod

# Other deployment instance info

- name: onap.pdpgroup.monitoring

version: 2.1.3

state: active

description: DCAE mS Configuration Policies

properties:

# PDP group level properties if any

pdp_subgroups:

- pdp_type: xacml

supported_policy_types:

- onap.policies.monitoring.cdap.tca.hi.lo.app

policies:

- onap.scaleout.tca:

policy_type: onap.policies.monitoring.cdap.tca.hi.lo.app

policy_type_version: 1.0.0

policy_type_impl: onap.policies.monitoring.impl

min_instance_count: 2

 instance_count: 2

properties:

# The properties below are for illustration only

instance_geo_redundancy: true

deployment_info:

service_endpoint: https://<the XACML service endpoint for this PDP
group>

deployment: A deployment identifier

# Other deployment info

instances:

- instance: xacml_1

state: active

healthy: yes

 deployment_instance_info:

node_address: xacml_1_pod

# Other deployment instance info

- instance: xacml_2

state: active

healthy: yes

 deployment_instance_info:

node_address: xacml_2_pod

# Other deployment instance info

The table below shows some more examples of GET operations

======================================================================================= ================================================================
**Example**                                                                             **Description**
======================================================================================= ================================================================
*https:{url}:{port}/policy/pap/v1/pdps*                                                 Get all PDP Groups and subgroups in the system
*https:{url}:{port}/policy/pap/v1/pdps/groups/onap.pdpgroup.controlloop*                Get PDP Groups and subgroups that match the supplied name filter
*https:{url}:{port}/policy/pap/v1/pdps/groups/onap.pdpgroup.monitoring/subgroups/xacml* Get the PDP subgroup informtation for the specified subgroup
\
======================================================================================= ================================================================

3.3.2 PDP Group Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~

This operation allows the PDP groups and subgroups to be created. A POST
operation is used to create a new PDP group name. A POST operation is
also used to update an existing PDP group. Many PDP groups can be
created or updated in a single POST operation by specifying more than
one PDP group in the POST operation body.

*https:{url}:{port}/policy/pap/v1/pdps POST*

**POST body to deploy or update PDP groups**  Expand source

pdp_groups:

- name: onap.pdpgroup.controlloop.operational

description: ONAP Control Loop Operational and Guard policies

pdp_subgroups:

- pdp_type: drools

supportedPolicyTypes:

- onap.controllloop.operational.drools.vcpe.EastRegion

version: 1.2.3

- onap.controllloop.operational.drools.vfw.EastRegion

version: 1.2.3

min_instance_count: 3group

properties:

# The properties below are for illustration only

instance_spawn_load_threshold: 70%

instance_kill_load_threshold: 50%

instance_geo_redundancy: true

- pdp_type: apex

policies:

- onap.controllloop.operational.apex.bbs.EastRegion

version: 1.2.3

- onap.controllloop.operational.apex.sampledomain.EastRegion

version: 1.2.3

min_instance_count: 2

properties:

# The properties below are for illustration only

instance_spawn_load_threshold: 80%

instance_kill_load_threshold: 60%

instance_geo_redundancy: true

- pdp_type: xacml

policies:

- onap.policies.controlloop.guard.frequencylimiter.EastRegion

version: 1.2.3

- onap.policies.controlloop.guard.blacklist.EastRegion

version: 1.2.3

- onap.policies.controlloop.guard.minmax.EastRegion

version: 1.2.3

min_instance_count: 2

properties:

# The properties below are for illustration only

instance_geo_redundancy: true

- name: onap.pdpgroup.monitoring

description: DCAE mS Configuration Policies

properties:

# PDP group level properties if any

pdp_subgroups:

- pdp_type: xacml

policies:

- onap.scaleout.tca

version: 1.2.3

min_instance_count: 2

properties:

# The properties below are for illustration only

instance_geo_redundancy: true

Other systems such as CLAMP can use this API to deploy policies using a
POST operation with the body below where only mandatory fields are
specified.

*https:{url}:{port}/policy/pap/v1/pdps POST*

**POST body to deploy or update PDP groups**  Expand source

pdp_groups:

- name: onap.pdpgroup.Monitoring

description: DCAE mS Configuration Policies

pdp_subgroups:

- pdp_type: xacml

policies:

- onap.scaleout.tca

Simple API for CLAMP to deploy one or more policy-id's with optional policy-version.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*https:{url}:{port}/policy/pap/v1/pdps/policies POST*

Content-Type: application/json

{

"policies" : [

{

"policy-id": "onap.scaleout.tca",

"policy-version": 1

},

{

"policy-id": "ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3"

},

{

"policy-id":
"guard.frequency.ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3"

},

{

"policy-id":
"guard.minmax.ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3"

}

]

}

HTTP status code indicates success or failure.{

"errorDetails": "some error message"

}

Simple API for CLAMP to undeploy a policy-id with optional policy-version.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*https:{url}:{port}/policy/pap/v1/pdps/policies{policy-id} DELETE*

*https:{url}:{port}/policy/pap/v1/pdps/policies{policy-id}/versions/{policy-version}
DELETE*

HTTP status code indicates success or failure.

{

"errorDetails": "some error message"

}

3.3.3 PDP Group Delete
~~~~~~~~~~~~~~~~~~~~~~

The API also allows PDP groups to be deleted with a DELETE operation.
DELETE operations are only permitted on PDP groups in PASSIVE state. The
format of the delete operation is as below:

*https:{url}:{port}/policy/pap/v1/pdps/groups/onap.pdpgroup.monitoring
DELETE*

3.3.4 PDP Group State Management
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The state of PDP groups is managed by the API. PDP groups can be in
states PASSIVE, TEST, SAFE, or ACTIVE. For a full description of PDP
group states, see `The ONAP Policy
Framework <file://localhost/display/DW/The+ONAP+Policy+Framework>`__
architecture page. The state of a PDP group is changed with a PUT
operation.

The following PUT operation changes a PDP group to ACTIVE:

*https:{url}:{port}/policy/pap/v1/pdps/groups/onap.pdpgroup.monitoring/state=active*

There are a number of rules for state management:

1. Only one version of a PDP group may be ACTIVE at any time

2. If a PDP group with a certain version is ACTIVE and a later version
   of the same PDP group is activated, then the system upgrades the PDP
   group

3. If a PDP group with a certain version is ACTIVE and an earlier
   version of the same PDP group is activated, then the system
   downgrades the PDP group

4. There is no restriction on the number of PASSIVE versions of a PDP
   group that can exist in the system

5. <Rules on SAFE/TEST> ? `Pamela
   Dragosh <file://localhost/display/~pdragosh>`__

3.3.5 PDP Group Statistics
~~~~~~~~~~~~~~~~~~~~~~~~~~

This operation allows statistics for PDP groups, PDP subgroups, and
individual PDPs to be retrieved.

*https:{url}:{port}/policy/pap/v1/pdps/statistics GET*

**Draft Example statistics returned for a PDP Group**  Expand source

report_timestamp: 2019-02-11T15:23:50+00:00

pdp_group_count: 2

pdp_groups:

- name: onap.pdpgroup.controlloop.Operational

state: active

create_timestamp: 2019-02-11T15:23:50+00:00

update_timestamp: 2019-02-12T15:23:50+00:00

state_change_timestamp: 2019-02-13T15:23:50+00:00

pdp_subgroups:

- pdp_type: drools

instance_count: 3

deployed_policy_count: 2

policy_execution_count: 123

policy_execution_ok_count: 121

policy_execution_fail_count: 2

instances:

- instance: drools_1

start_timestamp: 2019-02-13T15:23:50+00:00

policy_execution_count: 50

policy_execution_ok_count: 49

policy_execution_fail_count: 1

- instance: drools_2

start_timestamp: 2019-02-13T15:30:50+00:00

policy_execution_count: 50

policy_execution_ok_count: 49

policy_execution_fail_count: 1

- instance: drools_3

start_timestamp: 2019-02-13T15:33:50+00:00

policy_execution_count: 23

policy_execution_ok_count: 23

policy_execution_fail_count: 0

The table below shows some more examples of GET operations for
statistics

================================================================================================== ===================================================================================
**Example**                                                                                        **Description**
================================================================================================== ===================================================================================
*https:{url}:{port}/policy/pap/v1/pdps/statistics*                                                 Get statistics for all PDP Groups and subgroups in the system
*https:{url}:{port}/policy/pap/v1/pdps/groups/onap.pdpgroup.controlloop/statistics*                Get statistics for all PDP Groups and subgroups that match the supplied name filter
*https:{url}:{port}/policy/pap/v1/pdps/groups/onap.pdpgroup.monitoring/subgroups/xacml/statistics* Get statistics for the specified subgroup
\
================================================================================================== ===================================================================================

3.3.6 PDP Group Health Check
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A PDP group health check allows ordering of health checks on PDP groups
and on individual PDPs. As health checks may be long lived operations,
Health checks are scheduled for execution by this operation. Users check
the result of a health check test by issuing a PDP Group Query operation
(see Section 3.3.1) and checking the *healthy* field of PDPs.

*https:{url}:{port}/policy/pap/v1/pdps/healthcheck PUT*

The operation returns a HTTP status code of 202: Accepted if the health
check request has been accepted by the PAP. The PAP then orders
execution of the health check on the PDPs. The health check result is
retrieved with a subsequent GET operation.

The table below shows some more examples of PUT operations for ordering
health checks

======================================================================================================= ========================================================================================
**Example**                                                                                             **Description**
======================================================================================================= ========================================================================================
*https:{url}:{port}/policy/pap/v1/pdps/healthcheck PUT*                                                 Order a health check on all PDP Groups and subgroups in the system
*https:{url}:{port}/policy/pap/v1/pdps/groups/onap.pdpgroup.controlloop/healthcheck PUT*                Order a health check on all PDP Groups and subgroups that match the supplied name filter
*https:{url}:{port}/policy/pap/v1/pdps/groups/onap.pdpgroup.monitoring/subgroups/xacml/healthcheck PUT* Order a health check on the specified subgroup
\
======================================================================================================= ========================================================================================



End of Document
