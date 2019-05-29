.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _pap-label:

Policy Administration Point (PAP) Architecture
==============================================
.. toctree::

The PAP keeps track of PDPs, supporting the deployment of PDP groups and the
deployment of a *policy set* across those PDP groups.  Policies are created
using the Policy API, but are deployed via the PAP. 

A PAP is stateless in
a RESTful sense, using the database (persistent storage) to track PDPs and
the deployment of policies to those PDPs. In short, policy management on PDPs
is the responsibility of PAPs; management of policy sets or policies by any
other manner is not permitted.

Because the PDP is the main unit of scalability in the Policy Framework, the
framework is designed to allow PDPs in a PDP group to arbitrarily appear and
disappear and for policy consistency across all PDPs in a PDP group to be
easily maintained.  The PAP is responsible for controlling the state across
the PDPs in a PDP group. The PAP interacts with the Policy database and
transfers policy sets to PDPs.


REST API
--------

PAP supports the operations listed in the following table, via its REST API:

.. csv-table::
   :header: "Operation", "Description"
   :widths: 25,70

   "Health check", "Queries the health of the PDPs"
   "Statistics", "Queries various statistics"
   "PDP state change", "Changes the state of an individual PDP or of all PDPs in a PDP Group"
   "PDP Group create/update", "Creates/updates PDP Groups"
   "PDP Group delete", "Deletes a PDP Group"
   "PDP Group query", "Queries all PDP Groups"
   "Deploy policy", "Deploys one or more policies to the PDPs"
   "Undeploy policy", "Undeploys a policy from the PDPs"


DMaaP API
---------

PAP interacts with the PDPs via the DMaaP Message Router.  The messages listed
in the following table are transmitted via DMaaP:

.. csv-table::
   :header: "Message", "Direction", "Description"
   :widths: 25,10,70

   "PDP status", "Incoming", "Registers a PDP with PAP; also sent as a periodic heart beat; also sent in response to requests from the PAP"
   "PDP update", "Outgoing", "Assigns a PDP to a PDP Group and Subgroup; also deploys or undeploys policies from the PDP"
   "PDP state change", "Outgoing", "Changes the state of a PDP or all PDPs within a PDP Group or Subgroup"
   "PDP health check", "Outgoing", "Requests a health check from a PDP"


PAP REST API Swagger
--------------------

It is worth noting that we use basic authorization for access with user name
and password set to *healthcheck* and *zb!XztG34*, respectively.

For every call, the client is encouraged to insert a uuid-type *requestID* as
parameter. It is helpful for tracking each http transaction and facilitates
debugging. More importantly, it complies with Logging requirements v1.2. If
the client does not provide the requestID in a call, one will be randomly
generated and attached to the response header, *x-onap-requestid*.

In accordance with `ONAP API Common Versioning Strategy Guidelines <https://wiki.onap.org/display/DW/ONAP+API+Common+Versioning+Strategy+%28CVS%29+Guidelines>`_,
several custom headers are added in the response to each call:

.. csv-table::
   :header: "Header", "Example value", "Description"
   :widths: 25,10,70

   "x-latestversion", "1.0.0", "latest version of the API"
   "x-minorversion", "0", "MINOR version of the API"
   "x-patchversion", "0", "PATCH version of the API"
   "x-onap-requestid", "e1763e61-9eef-4911-b952-1be1edd9812b", "described above; used for logging purposes"
    

.. swaggerv2doc:: swagger/health-check-pap.json

.. swaggerv2doc:: swagger/statistics-pap.json

Note: while this API is supported, most of the statistics
are not currently updated; that work has been deferred to a later release.

.. swaggerv2doc:: swagger/state-change-pap.json

.. swaggerv2doc:: swagger/group-pap.json

Note: due to current limitations, if a subgroup is to be deleted from a PDP
Group, then the policies must be removed from the subgroup in one request,
and then the subgroup deleted in a subsequent request.

.. swaggerv2doc:: swagger/group-delete-pap.json

.. swaggerv2doc:: swagger/group-query-pap.json

.. swaggerv2doc:: swagger/policy-deploy-pap.json

Note: the policy version is optional.  If left unspecified, then the latest
version of the policy is deployed. On the other hand, if it is specified, it
may be an integer, or it may be a fully qualified version (e.g., "3.0.2").

.. swaggerv2doc:: swagger/policy-undeploy-pap.json

Note: if the policy version is specified, then it
may be an integer, or it may be a fully qualified version (e.g., "3.0.2").
On the other hand, if left unspecified, then the latest deployed version
will be undeployed.

Note: due to current limitations, a fully qualified policy version must
always be specified.

End of Document
