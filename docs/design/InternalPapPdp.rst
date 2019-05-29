
4. Policy Framework Internal APIs
=================================

The Policy Framework uses the internal APIs documented in the
subsections below. The APIs in this section are used for internal
communication in the Policy Framework. The APIs are NOT supported for
use by components outside the Policy Framework and are subject to
revision and change at any time.

4.1 PAP to PDP API
------------------

This section describes the API between the PAP and PDPs. The APIs in
this section are implemented using `DMaaP
API <file://localhost/display/DW/DMaaP+API>`__ messaging. There are four
messages on the API:

1. PDP_STATUS: PDP→PAP, used by PDPs to report to the PAP

2. PDP_UPDATE: PAP→PDP, used by the PAP to update the policies running
   on PDPs, triggers a PDP_STATUS message with the result of the
   PDP_UPDATE operation

3. PDP_STATE_CHANGE: PAP→PDP, used by the PAP to change the state of
   PDPs, triggers a PDP_STATUS message with the result of the
   PDP_STATE_CHANGE operation

4. PDP_HEALTH_CHECK: PAP→PDP, used by the PAP to order a heakth check on
   PDPs, triggers a PDP_STATUS message with the result of the
   PDP_HEALTH_CHECK operation

The fields below are valid on API calls:

======================== ============================= ======== ======== ======= ====================================================================================================================================== ==================================================================================================================================================================================================
**Field**                **PDP                         **PDP    **PDP    **PDP   **Comment**
                         STATUS**                      UPDATE** STATE    HEALTH
                                                                CHANGE** CHECK**
======================== ============================= ======== ======== ======= ====================================================================================================================================== ==================================================================================================================================================================================================
(message_name)           M                             M        M        M       pdp_status, pdp_update, pdp_state_change, or pdp_health_check
name                     M                             M        C        C       The name of the PDP, for state changes and health checks, the PDP group and subgroup can be used to specify the scope of the operation
version                  M                             N/A      N/A      N/A     The version of the PDP
pdp_type                 M                             M        N/A      N/A     The type of the PDP, currently xacml, drools, or apex
state                    M                             N/A      M        N/A     The administrative state of the PDP group: PASSIVE, SAFE, TEST, ACTIVE, or TERMINATED
healthy                  M                             N/A      N/A      N/A     The result of the latest health check on the PDP: HEALTHY/NOT_HEALTHY/TEST_IN_PROGRESS
description              O                             O        N/A      N/A     The description of the PDP
pdp_group                O                             M        C        C       The PDP group to which the PDP belongs, the PDP group and subgroup can be used to specify the scope of the operation
pdp_subgroup             O                             M        C        C       The PDP subgroup to which the PDP belongs, the PDP group and subgroup can be used to specify the scope of the operation
supported_policy_types   M                             N/A      N/A      N/A     A list of the policy types supported by the PDP
policies                 O                             M        N/A      N/A     The list of policies running on the PDP
\                        (name)                        O        M        N/A     N/A                                                                                                                                    The name of a TOSCA policy running on the PDP
\                        policy_type                   O        M        N/A     N/A                                                                                                                                    The TOSCA policy type of the policyWhen a PDP starts, it commences periodic sending of *PDP_STATUS* messages on DMaaP. The PAP receives these messages and acts in whatever manner is appropriate.
\                        policy_type_version           O        M        N/A     N/A                                                                                                                                    The version of the TOSCA policy type of the policy
\                        properties                    O        M        N/A     N/A                                                                                                                                    The properties of the policy for the XACML, Drools, or APEX PDP, see section 3.2 for details
instance                 M                             N/A      N/A      N/A     The instance ID of the PDP running in a Kuberenetes Pod
deployment_instance_info M                             N/A      N/A      N/A     Information on the node running the PDP
properties               O                             O        N/A      N/A     Other properties specific to the PDP
statistics               M                             N/A      N/A      N/A     Statistics on policy execution in the PDP
\                        policy_download_count         M        N/A      N/A     N/A                                                                                                                                    The number of policies downloaded into the PDP
\                        policy_download_success_count M        N/A      N/A     N/A                                                                                                                                    The number of policies successfully downloaded into the PDP
\                        policy_download_fail_count    M        N/A      N/A     N/A                                                                                                                                    The number of policies downloaded into the PDP where the download failed
\                        policy_executed_count         M        N/A      N/A     N/A                                                                                                                                    The number of policy executions on the PDP
\                        policy_executed_success_count M        N/A      N/A     N/A                                                                                                                                    The number of policy executions on the PDP that completed successfully
\                        policy_executed_fail_count    M        N/A      N/A     N/A                                                                                                                                    The number of policy executions on the PDP that failed
response                 O                             N/A      N/A      N/A     The response to the last operation that the PAP executed on the PDP
\                        response_to                   M        N/A      N/A     N/A                                                                                                                                    The PAP to PDP message to which this is a response
\                        response_status               M        N/A      N/A     N/A                                                                                                                                    SUCCESS or FAIL
\                        response_message              O        N/A      N/A     N/A                                                                                                                                    Message giving further information on the successful or failed operation
======================== ============================= ======== ======== ======= ====================================================================================================================================== ==================================================================================================================================================================================================

YAML is used for illustrative purposes in the examples in this section.
JSON (application/json) is used as the content type in the
implementation of this API.

| Note: The PAP checks that the set of policy types supported in all
  PDPs in a PDP subgroup are identical and will not add a PDP to a PDP
  subgroup that has a different set of supported policy types
| Note: The PA checks that the set of policy loaded on all PDPs in a PDP
  subgroup are are identical and will not add a PDP to a PDP subgroup
  that has a different set of loaded policies

4.1.1 PAP API for PDPs
~~~~~~~~~~~~~~~~~~~~~~

The purpose of this API is for PDPs to provide heartbeat, status.
health, and statistical information to Policy Administration. There is a
single *PDP_STATUS* message on this API. PDPs send this message to the
PAP using the *POLICY_PDP_PAP* DMaaP topic. The PAP listens on this
topic for messages.

When a PDP starts, it commences periodic sending of *PDP_STATUS*
messages on DMaaP. The PAP receives these messages and acts in whatever
manner is appropriate. *PDP_UPDATE*, *PDP_STATE_CHANGE*, and
*PDP_HEALTH_CHECK* operations trigger a *PDP_STATUS* message as a
response.

The *PDP_STATUS* message is used for PDP heartbeat monitoring. A PDP
sends a *PDP_STATUS* message with a state of \ *TERMINATED* when it
terminates normally. If a \ *PDP_STATUS* message is not received from a
PDP in a certain configurable time, then the PAP assumes the PDP has
failed.

A PDP may be preconfigured with its PDP group, PDP subgroup, and
policies. If the PDP group, subgroup, or any policy sent to the PAP in a
*PDP_STATUS* message is unknown to the PAP, the PAP locks the PDP in
state PASSIVE.

**PDP_STATUS message from an XACML PDP running control loop policies**
 Expand source

pdp_status:

name: xacml_1

version: 1.2.3

pdp_type: xacml

state: active

healthy: true

 description: XACML PDP running control loop policies

pdp_group: onap.pdpgroup.controlloop.operational

pdp_subgroup: xacml

supported_policy_types:

- onap.policies.controlloop.guard.FrequencyLimiter

- onap.policies.controlloop.guard.BlackList

- onap.policies.controlloop.guard.MinMax

 policies:

- onap.policies.controlloop.guard.frequencylimiter.EastRegion:

policy_type: onap.policies.controlloop.guard.FrequencyLimiter

policy_type_version: 1.0.0

properties:

# Omitted for brevity, see Section 3.2

 - onap.policies.controlloop.guard.blacklist.eastRegion:

policy_type: onap.policies.controlloop.guard.BlackList

policy_type_version: 1.0.0

properties:

# Omitted for brevity, see Section 3.2

- onap.policies.controlloop.guard.minmax.eastRegion:

policy_type: onap.policies.controlloop.guard.MinMax

policy_type_version: 1.0.0

properties:

# Omitted for brevity, see Section 3.2

instance: xacml_1

deployment_instance_info:

node_address: xacml_1_pod

# Other deployment instance info

statistics:

policy_download_count: 0

policy_download_success_count: 0

policy_download_fail_count: 0

policy_executed_count: 123

policy_executed_success_count: 122

policy_executed_fail_count: 1

**PDP_STATUS message from a Drools PDP running control loop policies**
 Expand source

pdp_status:

name: drools_2

version: 2.3.4

pdp_type: drools

state: safe

healthy: true

 description: Drools PDP running control loop policies

pdp_group: onap.pdpgroup.controlloop.operational

pdp_subgroup: drools

supported_policy_types:

- onap.controllloop.operational.drools.vCPE

  - onap.controllloop.operational.drools.vFW

policies:

- onap.controllloop.operational.drools.vcpe.EastRegion:

policy_type: onap.controllloop.operational.drools.vCPE

policy_type_version: 1.0.0

properties:

# Omitted for brevity, see Section 3.2

- onap.controllloop.operational.drools.vfw.EastRegion:

policy_type: onap.controllloop.operational.drools.vFW

policy_type_version: 1.0.0

properties:

# Omitted for brevity, see Section 3.2

instance: drools_2

deployment_instance_info:

node_address: drools_2_pod

# Other deployment instance info

statistics:

policy_download_count: 3

policy_download_success_count: 3

policy_download_fail_count: 0

policy_executed_count: 123

policy_executed_success_count: 122

policy_executed_fail_count: 1

response:

response_to: PDP_HEALTH_CHECK

response_status: SUCCESS

**PDP_STATUS message from an APEX PDP running control loop policies**
 Expand source

pdp_status:

name: apex_3

version: 2.2.1

pdp_type: apex

state: test

healthy: true

 description: APEX PDP running control loop policies

pdp_group: onap.pdpgroup.controlloop.operational

pdp_subgroup: apex

supported_policy_types:

- onap.controllloop.operational.apex.BBS

- onap.controllloop.operational.apex.SampleDomain

policies:

- onap.controllloop.operational.apex.bbs.EastRegion:

policy_type: onap.controllloop.operational.apex.BBS

policy_type_version: 1.0.0

properties:

# Omitted for brevity, see Section 3.2

- onap.controllloop.operational.apex.sampledomain.EastRegion:

policy_type: onap.controllloop.operational.apex.SampleDomain

policy_type_version: 1.0.0

properties:

# Omitted for brevity, see Section 3.2

instance: apex_3

deployment_instance_info:node_address

node_address: apex_3_pod

# Other deployment instance info

statistics:

policy_download_count: 2

policy_download_success_count: 2

policy_download_fail_count: 0

policy_executed_count: 123

policy_executed_success_count: 122

policy_executed_fail_count: 1

response:

response_to: PDP_UPDATE

response_status: FAIL

response_message: policies specified in update message incompatible with
running policy state

**PDP_STATUS message from an XACML PDP running monitoring policies**
 Expand source

pdp_status:

  name: xacml_1

version: 1.2.3

pdp_type: xacml

state: active

healthy: true

 description: XACML PDP running monitoring policies

pdp_group: onap.pdpgroup.Monitoring

pdp_subgroup: xacml

supported_policy_types:

- onap.monitoring.cdap.tca.hi.lo.app

policies:

- onap.scaleout.tca:message

policy_type: onap.policies.monitoring.cdap.tca.hi.lo.app

policy_type_version: 1.0.0

properties:

# Omitted for brevity, see Section 3.2

instance: xacml_1

deployment_instance_info:

node_address: xacml_1_pod

# Other deployment instance info

statistics:

policy_download_count: 0

policy_download_success_count: 0

policy_download_fail_count: 0

policy_executed_count: 123

policy_executed_success_count: 122

policy_executed_fail_count: 1

4.1.2 PDP API for PAPs
~~~~~~~~~~~~~~~~~~~~~~

The purpose of this API is for the PAP to load and update policies on
PDPs and to change the state of PDPs. It also allows the PAP to order
health checks to run on PDPs. The PAP sends \ *PDP_UPDATE*, \ *PDP\_*
STATE_CHANGE, and *PDP_HEALTH_CHECK* messages to PDPs using the
*POLICY_PAP_PDP* DMaaP topic. PDPs listens on this topic for messages.

The PAP can set the scope of STATE_CHANGE, and *PDP_HEALTH_CHECK*
messages:

-  PDP Group: If a PDP group is specified in a message, then the PDPs in
   that PDP group respond to the message and all other PDPs ignore it.

-  PDP Group and subgroup: If a PDP group and subgroup are specified in
   a message, then only the PDPs of that subgroup in the PDP group
   respond to the message and all other PDPs ignore it.

-  Single PDP: If the name of a PDP is specified in a message, then only
   that PDP responds to the message and all other PDPs ignore it.

Note: *PDP_UPDATE* messages must be issued individually to PDPs because
the *PDP_UPDATE* operation can change the PDP group to which a PDP
belongs.

4.1.2.1 PDP Update
^^^^^^^^^^^^^^^^^^

The *PDP_UPDATE* operation allows the PAP to modify the PDP group to
which a PDP belongs and the policies in a PDP.  Only PDPs in state
PASSIVE accept this operation. The PAP must change the state of PDPs in
state ACTIVE, TEST, or SAFE to state PASSIVE before issuing a
*PDP_UPDATE* operation on a PDP.

The following examples illustrate how the operation is used.

**PDP_UPDATE message to upgrade XACML PDP control loop policies to
versino 1.0.1**  Expand source

pdp_update:

name: xacml_1

pdp_type: xacml

description: XACML PDP running control loop policies, Upgraded

pdp_group: onap.pdpgroup.controlloop.operational

pdp_subgroup: xacml

policies:

- onap.policies.controlloop.guard.frequencylimiter.EastRegion:

policy_type: onap.policies.controlloop.guard.FrequencyLimiter

policy_type_version: 1.0.1

properties:

# Omitted for brevity, see Section 3.2

- onap.policies.controlloop.guard.blackList.EastRegion:

policy_type: onap.policies.controlloop.guard.BlackList

policy_type_version: 1.0.1

properties:

# Omitted for brevity, see Section 3.2

- onap.policies.controlloop.guard.minmax.EastRegion:

policy_type: onap.policies.controlloop.guard.MinMax

policy_type_version: 1.0.1

properties:

# Omitted for brevity, see Section 3.2

**PDP_UPDATE message to a Drools PDP to add an extra control loop
policy**  Expand source

pdp_update:

name: drools_2

pdp_type: drools

description: Drools PDP running control loop policies, extra policy
added

pdp_group: onap.pdpgroup.controlloop.operational

pdp_subgroup: drools

policies:

- onap.controllloop.operational.drools.vcpe.EastRegion:

policy_type: onap.controllloop.operational.drools.vCPE

policy_type_version: 1.0.0

properties:

# Omitted for brevity, see Section 3.2

- onap.controllloop.operational.drools.vfw.EastRegion:

policy_type: onap.controllloop.operational.drools.vFW

policy_type_version: 1.0.0

properties:

# Omitted for brevity, see Section 3.2

- onap.controllloop.operational.drools.vfw.WestRegion:

policy_type: onap.controllloop.operational.drools.vFW

policy_type_version: 1.0.0

properties:

# Omitted for brevity, see Section 3.2

**PDP_UPDATE message to an APEX PDP to remove a control loop policy**
 Expand source

pdp_update:

name: apex_3

pdp_type: apex

 description: APEX PDP updated to remove a control loop policy

pdp_group: onap.pdpgroup.controlloop.operational

pdp_subgroup: apex

policies:

- onap.controllloop.operational.apex.bbs.EastRegion:

policy_type: onap.controllloop.operational.apex.BBS

policy_type_version: 1.0.0

properties:

# Omitted for brevity, see Section 3.2

4.1.2.2 PDP State Change
^^^^^^^^^^^^^^^^^^^^^^^^

The *PDP_STATE_CHANGE* operation allows the PAP to order state changes
on PDPs in PDP groups and subgroups. The following examples illustrate
how the operation is used.

**Change the state of all control loop Drools PDPs to ACTIVE**  Expand
source

pdp_state_change:

state: active

pdp_group: onap.pdpgroup.controlloop.Operational

pdp_subgroup: drools

**Change the state of all monitoring PDPs to SAFE**  Expand source

pdp_state_change:

state: safe

pdp_group: onap.pdpgroup.Monitoring

**Change the state of a single APEX PDP to TEST**  Expand source

pdp_state_change:

state: test

name: apex_3

4.1.2.3 PDP Health Check
^^^^^^^^^^^^^^^^^^^^^^^^

The *PDP_HEALTH_CHECK* operation allows the PAP to order health checks
on PDPs in PDP groups and subgroups. The following examples illustrate
how the operation is used.

**Perform a health check on all control loop Drools PDPs**  Expand
source

pdp_health_check:

pdp_group: onap.pdpgroup.controlloop.Operational

pdp_subgroup: drools

**perform a health check on all monitoring PDPs**  Expand source

pdp_health_check:

pdp_group: onap.pdpgroup.Monitoring

**Perform a health check on a single APEX PDP**  Expand source

pdp_health_check:

name: apex_3

4.2 Policy Type Implementations (Native Policies)
-------------------------------------------------

The policy Framework must have implementations for all Policy Type
entities that may be specified in TOSCA. Policy type implementations are
native policies for the various PDPs supported in the Policy Framework.
They may be predefined and preloaded into the Policy Framework. In
addition, they may also be added, modified, queried, or deleted using
this API during runtime.

The API supports CRUD of *PolicyTypeImpl* policy type implementations,
where the XACML, Drools, and APEX policy type implementations are
supplied as strings. This API is provided by the *PolicyDevelopment*
component of the Policy Framework, see `The ONAP Policy
Framework <file://localhost/display/DW/The+ONAP+Policy+Framework>`__
architecture.

| Note that client-side editing support for TOSCA *PolicyType*
  definitions or for *PolicyTypeImpl* implementations in XACML, Drools,
  or APEX is outside the current scope of the API.
| Note: Preloaded policy type implementations may only be queried over
  this API, modification or deletion of preloaded policy type
  implementations is disabled.
| Note: Policy type implementations that are in use (referenced by
  defined Policies) may not be deleted.

The fields below are valid on API calls:

=========== ======= ======== ========== ==========================================================================================================================
**Field**   **GET** **POST** **DELETE** **Comment**
=========== ======= ======== ========== ==========================================================================================================================
name        M       M        M          The name of the Policy Type implementation
version     O       M        C          The version of the Policy Type implementation
policy_type R       M        N/A        The TOSCA policy type that this policy type implementation implements
pdp_type    R       M        N/A        The PDP type of this policy type implementation, currently xacml, drools, or apex
description R       O        N/A        The description of the policy type implementation
writable    R       N/A      N/A        Writable flag, false for predefined policy type implementations, true for policy type implementations defined over the API
policy_body R       M        N/A        The body (source) of the policy type implementation
properties  R       O        N/A        Specific properties for the policy type implementation
=========== ======= ======== ========== ==========================================================================================================================

4.2.1 Policy Type Implementation Query
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This operation allows the PDP groups and subgroups to be listed together
with the policies that are deployed on each PDP group and subgroup.

*https:{url}:{port}/policy/api/v1/native/onap.policies.controlloop.operational/impls
GET*

**Policy Type Implementation Query Result**  Expand source

policy_type_impls:

- name: onap.policies.controlloop.operational.drools.Impl

version: 1.0.0

policy_type: onap.policies.controlloop.Operational

pdp_type: drools

description: Implementation of the drools control loop policies

writable: false

- name: onap.policies.controlloop.operational.apex.bbs.Impl

version: 1.0.0

policy_type: onap.policies.controlloop.operational.Apex

pdp_type: apex

description: Implementation of the APEX BBS control loop policy

writable: true

policy_body: "<policy body>"

- name: onap.policies.controlloop.operational.apex.sampledomain.Impl

version: 1.0.0

policy_type: onap.policies.controlloop.operational.Apex

pdp_type: apex

description: Implementation of the SampleDomain test APEX policy

writable: true

policy_body: "<policy body>"

The table below shows some more examples of GET operations

========================================================================================================================================================================= ==========================================================================================================================================================
**Example**                                                                                                                                                               **Description**
========================================================================================================================================================================= ==========================================================================================================================================================
*https:{url}:{port}/policy/api/v1/native/{policy type id}/impls*                                                                                                          Get all Policy Type implementations for the given policy type

| *eg.*
| *https:{url}:{port}/policy/api/v1/native/onap.policies.monitoring/impls*
| *https:{url}:{port}/policy/api/v1/native/onap.policies.controlloop.operational.apex/impls*
*https:{url}:{port}/policy/api/v1/native/{policy type id}/impls/{policy type impl id}*                                                                                    Get all Policy Type implementation versions that match the policy type and policy type implementation IDs specified

| *eg.*
| *https:{url}:{port}/policy/api/v1/native/onap.policies.controlloop.operational/impls/onap.policies.controlloop.operational.drools.impl*
| *https:{url}:{port}/policy/api/v1/native/onap.policies.controlloop.operational.apex/impls/onap.policies.controlloop.operational.apex.sampledomain.impl*
*https:{url}:{port}/policy/api/v1/native/{policy type id}/impls/{policy type impl id}/versions/{version id}*                                                              Get the specific Policy Type implementation with the specified name and version, if the version ID is specified a *latest*, the latest version is returned

| *eg.*
| *https:{url}:{port}/policy/api/v1/native/onap.policies.controlloop.operational/impls/onap.policies.controlloop.operational.drools.impl/versions/1.2.3*
| *https:{url}:{port}/policy/api/v1/native/onap.policies.controlloop.operational.apex/impls/onap.policies.controlloop.operational.apex.sampledomain.impl/versions/latest*
========================================================================================================================================================================= ==========================================================================================================================================================

4.2.2 Policy Type Implementation Create/Update
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The API allows users (such as a policy editor or DevOps system) to
create or update a Policy Type implementation using a POST operation.
This API allows new Policy Type implementations to be created or
existing Policy Type implementations to be modified. POST operations
with a new name or a new version of an existing name are used to create
a new Policy Type implementation. POST operations with an existing name
and version are used to update an existing Policy Type implementations.
Many implementations can be created or updated in a single POST
operation by specifying more than one Policy Type implementation on the
*policy_type_impls* list.

For example, the POST operation below with the YAML body below is used
to create a new APEX Policy type implementation.

*https:{url}:{port}/policy/api/v1/native/onap.policies.controlloop.operational.apex/impls
POST*

**Create a new Policy Type Implementation**  Expand source

policy_type_impls:

- onap.policies.controlloop.operational.apex.bbs.Impl:

version: 1.0.0

policy_type: onap.policies.controlloop.operational.Apex

pdp_type: apex

description: Implementation of the APEX BBS control loop policy

policy_body: "<policy body>"

- onap.policies.controlloop.operational.apex.sampledomain.Impl:

version: 1.0.0

policy_type: onap.policies.controlloop.operational.Apex

pdp_type: apex

description: Implementation of the APEX SampleDomain control loop policy

policy_body: "<policy body>

Once this call is made, the Policy Type query in Section 3.1.2.1 returns
a result with the new Policy Type implementation defined.

4.2.3 Policy Type Implementation Delete
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The API also allows Policy Type implementations to be deleted with a
DELETE operation. The format of the delete operation is as below:

*https:{url}:{port}/api/v1/native/onap.policies.controlloop.operational.apex/impls/onap.policies.apex.bbs.impl/versions/1.0.0
DELETE*

| Note: Predefined policy type implementations cannot be deleted
| Note: Policy type implementations that are in use (Parameterized by a
  TOSCA Policy) may not be deleted, the parameterizing TOSCA policies
  must be deleted first
| Note: The *version* parameter may be omitted on the DELETE operation
  if there is only one version of the policy type implementation in the
  system
