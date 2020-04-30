.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _pap-label:

Policy Administration Point (PAP) Architecture
##############################################

.. contents::
    :depth: 3

The PAP keeps track of PDPs, supporting the deployment of PDP groups and the deployment of a *policy set* across those
PDP groups. Policies are created using the Policy API, but are deployed via the PAP. 

A PAP is stateless in a RESTful sense, using the database (persistent storage) to track PDPs and the deployment of
policies to those PDPs. In short, policy management on PDPs is the responsibility of PAPs; management of policy sets or
policies by any other manner is not permitted.

Because the PDP is the main unit of scalability in the Policy Framework, the framework is designed to allow PDPs in a
PDP group to arbitrarily appear and disappear and for policy consistency across all PDPs in a PDP group to be easily
maintained. The PAP is responsible for controlling the state across the PDPs in a PDP group. The PAP interacts with the
Policy database and transfers policy sets to PDPs.

There are a number of rules for PDP group and PDP state management:

1. Only one version of a PDP group may be ACTIVE at any time

2. If a PDP group with a certain version is ACTIVE and a later version   of the same PDP group is activated, then the
   system upgrades the PDP group

3. If a PDP group with a certain version is ACTIVE and an earlier version of the same PDP group is activated, then the
   system downgrades the PDP group

4. There is no restriction on the number of PASSIVE versions of a PDP group that can exist in the system


1 APIs
======
The APIs in the subchapters below are supported by the PAP.

1.1 REST API
------------

The purpose of this API is to support CRUD of PDP groups and subgroups and to support the deployment and life cycles of
policies on PDP sub groups and PDPs. This API is provided by the *PolicyAdministration* component (PAP) of the Policy
Framework, see the :ref:`ONAP Policy Framework Architecture <architecture-label>` page.

PDP groups and subgroups may be prefedined in the system. Predefined groups and subgroups may be modified or deleted
over this API. The policies running on predefined groups or subgroups as well as the instance counts and properties may
also be modified.

A PDP may be preconfigured with its PDP group, PDP subgroup, and policies. The PDP sends this information to the PAP
when it starts. If the PDP group, subgroup, or any policy is unknown to the PAP, the PAP locks the PDP in state PASSIVE.

PAP supports the operations listed in the following table, via its REST API:

.. csv-table::
   :header: "Operation", "Description"
   :widths: 25,70

   "Health check", "Queries the health of the PAP"
   "Consolidated healthcheck", "Queries the health of all policy components"
   "Statistics", "Queries various statistics"
   "PDP state change", "Changes the state of all PDPs in a PDP Group"
   "PDP Group create/update", "Creates/updates PDP Groups"
   "PDP Group delete", "Deletes a PDP Group"
   "PDP Group query", "Queries all PDP Groups"
   "Deployment update", "Deploy/undeploy one or more policies in specified PdpGroups"
   "Deploy policy", "Deploys one or more policies to the PDPs"
   "Undeploy policy", "Undeploys a policy from the PDPs"
   "Policy deployment status", "Queries the status of all deployed policies"
   "PDP statistics", "Queries the statistics of PDPs"

1.2 DMaaP API
-------------

PAP interacts with the PDPs via the DMaaP Message Router.  The messages listed
in the following table are transmitted via DMaaP:

.. csv-table::
   :header: "Message", "Direction", "Description"
   :widths: 25,10,70

   "PDP status", "Incoming", "Registers a PDP with PAP; also sent as a periodic heart beat; also sent in response to requests from the PAP"
   "PDP update", "Outgoing", "Assigns a PDP to a PDP Group and Subgroup; also deploys or undeploys policies from the PDP"
   "PDP state change", "Outgoing", "Changes the state of a PDP or all PDPs within a PDP Group or Subgroup"

In addition, PAP generates notifications via the DMaaP Message Router when policies are successfully or unsuccessfully
deployed (or undeployed) from all relevant PDPs.

Here is a sample notification:

.. literalinclude:: notification/dmaap-pap-notif.json
    :language: json


2 PAP REST API Swagger
======================

It is worth noting that we use basic authorization for access with user name and password set to *healthcheck* and
*zb!XztG34*, respectively.

For every call, the client is encouraged to insert a uuid-type *requestID* as parameter. It is helpful for tracking each
http transaction and facilitates debugging. More importantly, it complies with Logging requirements v1.2. If the client
does not provide the requestID in a call, one will be randomly generated and attached to the response header,
*x-onap-requestid*.

In accordance with `ONAP API Common Versioning Strategy Guidelines
<https://wiki.onap.org/display/DW/ONAP+API+Common+Versioning+Strategy+%28CVS%29+Guidelines>`_, several custom headers
are added in the response to each call:

.. csv-table::
   :header: "Header", "Example value", "Description"
   :widths: 25,10,70

   "x-latestversion", "1.0.0", "latest version of the API"
   "x-minorversion", "0", "MINOR version of the API"
   "x-patchversion", "0", "PATCH version of the API"
   "x-onap-requestid", "e1763e61-9eef-4911-b952-1be1edd9812b", "described above; used for logging purposes"
    

.. swaggerv2doc:: swagger/health-check-pap.json

This operation performs a health check on the PAP.

Here is a sample response:

.. literalinclude:: response/health-check-pap-resp.json
    :language: json

.. swaggerv2doc:: swagger/consolidated-healthcheck-pap.json

This operation performs a health check of all policy components. The response
contains health check result of each component. The consolidated health check
is reported as healthy only if all the components are healthy, otherwise the 
"healthy" flag is marked as false.

Here is a sample response:

.. literalinclude:: response/consolidated-healthcheck-pap-resp.json
    :language: json

.. swaggerv2doc:: swagger/statistics-pap.json

This operation allows statistics for PDP groups, PDP subgroups, and individual PDPs to be retrieved.

.. note::
  While this API is supported, most of the statistics are not currently updated; that work has been deferred to a later
  release.

Here is a sample response:

.. literalinclude:: response/statistics-pap-resp.json
    :language: json

.. swaggerv2doc:: swagger/state-change-pap.json

The state of PDP groups is managed by this operation. PDP groups can be in states PASSIVE, TEST, SAFE, or ACTIVE. For a full
description of PDP group states, see the :ref:`ONAP Policy Framework Architecture <architecture-label>` page.

.. swaggerv2doc:: swagger/groups-batch-pap.json

This operation allows the PDP groups and subgroups to be created and updated. Many PDP groups can be created or updated
in a single POST operation by specifying more than one PDP group in the POST operation body.
This can be used to create the PDP group by providing all the details including the supported policy types for each subgroup.
However, it cannot be used to update policies; that is done using one of
the deployment requests.  Consequently, the "policies" property of this
request will be ignored.
This can also be used to update a PDP Group, but supported policy types cannot be updated during the update operation.
So, "policies" and "supportedPolicyTypes" properties in the request will be ignored if provided during the PDP Group update operation.

.. note::
  If a subgroup is to be deleted from a PDP Group, then the policies must be removed from
  the subgroup first.

.. note::
  Policies cannot be added/updated during PDP Group create/update operations. So, if provided, they are ignored.
  Supported policy types are defined during PDP Group creation. They cannot be updated once they are created.
  So, supportedPolicyTypes are expected during PDP Group create, but ignored if provided during PDP Group update.

Here is a sample request:

.. literalinclude:: request/groups-batch-pap-req.json
    :language: json

.. swaggerv2doc:: swagger/group-delete-pap.json

The API also allows PDP groups to be deleted. DELETE operations are only permitted on PDP groups in PASSIVE state.

.. swaggerv2doc:: swagger/group-query-pap.json

This operation allows the PDP groups and subgroups to be listed as well as the policies that are deployed on each PDP
group and subgroup.

Here is a sample response:

.. literalinclude:: response/group-query-pap-resp.json
    :language: json

.. swaggerv2doc:: swagger/deployments-batch-pap.json

This operation allows policies to be deployed on specific PDP groups.
Each subgroup includes an "action" property, which is used to indicate
that the policies are being added (POST) to the subgroup, deleted (DELETE)
from the subgroup, or that the subgroup's entire set of policies is being
replaced (PATCH) by a new set of policies.  As such, a subgroup may appear
more than once in a single request, one time to delete some policies and
another time to add new policies to the same subgroup.

Here is a sample request:

.. literalinclude:: request/deployment-batch-pap-req.json
    :language: json

.. swaggerv2doc:: swagger/policy-deploy-pap.json

This operation allows policies to be deployed across all relevant PDP groups.
PAP will deploy the specified policies to all relevant subgroups.  Only the
policies supported by a given subgroup will be deployed to that subgroup.

.. note::
  The policy version is optional.  If left unspecified, then the latest version of the policy is deployed. On the other
  hand, if it is specified, it may be an integer, or it may be a fully qualified version (e.g., "3.0.2").
  In addition, a subgroup to which a policy is being deployed must have at
  least one PDP instance, otherwise the request will be rejected.

Here is a sample request:

.. literalinclude:: request/policy-deploy-pap-req.json
    :language: json

.. swaggerv2doc:: swagger/policy-undeploy-pap.json

This operation allows policies to be undeployed from PDP groups.

.. note::
  If the policy version is specified, then it may be an integer, or it may be a fully qualified version (e.g., "3.0.2").
  On the other hand, if left unspecified, then the latest deployed version will be undeployed.

.. note::
  Due to current limitations, a fully qualified policy version must always be specified.

.. swaggerv2doc:: swagger/deployed-policy-pap.json

This operation allows the deployed policies to be listed together with deployment status.

Here is a sample response:

.. literalinclude:: response/deployed-policy-pap-resp.json
    :language: json

.. swaggerv2doc:: swagger/pdp-statistics-pap.json

This operation allows the PDP statistics to be retrieved for all registered PDPs.
The result can be filtered based on PDP group, PDP subgroup & PDP instance.

Here is a sample response:

.. literalinclude:: response/pdp-statistics-pap-resp.json
    :language: json

  
3 Future Features 
=================

3.1 Disable policies in PDP
===========================

This operation will allow disabling individual policies running in PDP engine. It is mainly beneficial
in scenarios where network operators/administrators wants to disable a particular policy in PDP engine 
for sometime due to failure in system or during scheduled maintenance.

End of Document
