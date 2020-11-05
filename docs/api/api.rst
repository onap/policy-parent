.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. THIS IS USED INTERNALLY IN POLICY ONLY
.. _api-label:

Policy Life Cycle API
#####################

.. contents::
    :depth: 2

The purpose of this API is to support CRUD of TOSCA *PolicyType* and *Policy* entities. This API is provided by the
*PolicyDevelopment* component of the Policy Framework, see the :ref:`The ONAP Policy Framework Architecture
<architecture-label>` page. The Policy design API backend is running in an independent building block component of the
policy framework that provides REST services for the aforementioned CRUD behaviors. The Policy design API component interacts
with a policy database for storing and fetching new policies or policy types as needed. Apart from CRUD, an API is also
exposed for clients to retrieve healthcheck status of the API REST service and statistics report including a variety of
counters that reflect the history of API invocation.

We strictly follow `TOSCA Specification <http://docs.oasis-open.org/tosca/TOSCA-Simple-Profile-YAML/v1.1/TOSCA-Simple-Profile-YAML-v1.1.pdf>`_
to define policy types and policies. A policy type defines the schema for a policy, expressing the properties, targets, and triggers
that a policy may have. The type (string, int etc) and constraints (such as the range of legal values) of each property is defined
in the Policy Type. Both Policy Type and policy are included in a TOSCA Service Template, which is used as the entity passed into an API
POST call and the entity returned by API GET and DELETE calls. More details are presented in following sections. Policy Types and Policies
can be composed for any given domain of application.  All Policy Types and Policies must be composed as well-formed TOSCA Service Templates.
One Service Template can contain multiple policies and policy types.

Child policy types can inherit from parent policy types, so a hierarchy of policy types can be built up. For example, the HpaPolicy Policy
Type in the table below is a child of a Resource Policy Type, which is a child of an Optimization policy.
See also `the examples in Github <https://github.com/onap/policy-models/tree/guilin/models-examples/src/main/resources/policytypes>`_.

::

 onap.policies.Optimization.yaml
  onap.policies.optimization.Resource.yaml
   onap.policies.optimization.resource.AffinityPolicy.yaml
   onap.policies.optimization.resource.DistancePolicy.yaml
   onap.policies.optimization.resource.HpaPolicy.yaml
   onap.policies.optimization.resource.OptimizationPolicy.yaml
   onap.policies.optimization.resource.PciPolicy.yaml
   onap.policies.optimization.resource.Vim_fit.yaml
   onap.policies.optimization.resource.VnfPolicy.yaml
 onap.policies.optimization.Service.yaml
   onap.policies.optimization.service.QueryPolicy.yaml
   onap.policies.optimization.service.SubscriberPolicy.yaml

Custom data types can be defined in TOSCA for properties specified in Policy Types. Data types can also inherit from parents, so a hierarchy of data types can also be built up.

.. warning::
 When creating a Policy Type, the ancestors of the Policy Type and all its custom Data Type definitions and ancestors MUST either already
 exist in the database or MUST also be defined in the incoming TOSCA Service Template. Requests with missing or bad references are rejected
 by the API.

Each Policy Type can have multiple Policy instances created from it. Therefore, many Policy instances of the HpaPolicy Policy Type above can be created. When a policy is created, its Policy Type is specified in the *type* and *type_version* fields of the policy.

.. warning::
 The Policy Type specified for a Policy MUST exist in the database before the policy can be created. Requests with missing or bad
 Policy Type references are rejected by the API.

The API allows applications to create, update, delete, and query *PolicyType* entities so that they become available for
use in ONAP by applications such as CLAMP. Some Policy Type entities are preloaded in the Policy Framework.

.. warning::
 If a TOSCA entity (Data Type, Policy Type, or Policy with a certain version) already exists in the database and an attempt is made
 to re-create the entity with different fields, the API will reject the request with the error message "entity in incoming fragment
 does not equal existing entity". In such cases, delete the Policy or Policy Type and re-create it using the API.


The TOSCA fields below are valid on API calls:

============ ======= ======== ========== ===============================================================================
**Field**    **GET** **POST** **DELETE** **Comment**
============ ======= ======== ========== ===============================================================================
(name)       M       M        M          The definition of the reference to the Policy Type, GET allows ranges to be
                                         specified
version      O       M        C          GET allows ranges to be specified, must be specified if more than one version
                                         of the Policy Type exists and a specific version is required
description  R       O        N/A        Desciption of the Policy Type
derived_from R       C        N/A        Must be specified when a Policy Type is derived from another Policy Type such
                                         as in the case of derived Monitoring Policy Types. The referenced Policy Type
                                         must either already exist in the database or be defined as another policy type
                                         in the incoming TOSCA service template
metadata     R       O        N/A        Metadata for the Policy Type
properties   R       M        N/A        This field holds the specification of the specific Policy Type in ONAP. Any user
                                         defined data types specified on properties must either already exist in the
                                         database or be defined in the incoming TOSCA service template
targets      R       O        N/A        A list of node types and/or group types to which the Policy Type can be applied
triggers     R       O        N/A        Specification of policy triggers, not currently supported in ONAP
============ ======= ======== ========== ===============================================================================

.. note::
  On this and subsequent tables, use the following legend:   M-Mandatory, O-Optional, R-Read-only, C-Conditional.
  Conditional means the field is mandatory when some other field is present.

.. note::
  Preloaded policy types may only be queried over this API, modification or deletion of preloaded policy type
  implementations is disabled.

.. note::
  Policy types that are in use (referenced by defined Policies and/or child policy types) may not be deleted.

.. note::
  The group types of targets in TOSCA are groups of TOSCA nodes, not PDP groups; the *target* concept in TOSCA is
  equivalent to the Policy Enforcement Point (PEP) concept


To ease policy creation, we preload several widely used policy types in policy database. Below is a table listing the preloaded policy types.

.. _policy-preload-label:

.. csv-table::
   :header: "Policy Type Name", "Payload"
   :widths: 15,10

   "Monitoring.TCA", `onap.policies.monitoring.tcagen2.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.monitoring.tcagen2.yaml>`_
   "Monitoring.Collectors", `onap.policies.monitoring.dcaegen2.collectors.datafile.datafile-app-server.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.monitoring.dcaegen2.collectors.datafile.datafile-app-server.yaml>`_
   "Optimization", `onap.policies.Optimization.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.Optimization.yaml>`_
   "Optimization.Resource", `onap.policies.optimization.Resource.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.optimization.Resource.yaml>`_
   "Optimization.Resource.AffinityPolicy", `onap.policies.optimization.resource.AffinityPolicy.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.AffinityPolicy.yaml>`_
   "Optimization.Resource.DistancePolicy", `onap.policies.optimization.resource.DistancePolicy.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.DistancePolicy.yaml>`_
   "Optimization.Resource.HpaPolicy", `onap.policies.optimization.resource.HpaPolicy.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.HpaPolicy.yaml>`_
   "Optimization.Resource.OptimizationPolicy", `onap.policies.optimization.resource.OptimizationPolicy.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.OptimizationPolicy.yaml>`_
   "Optimization.Resource.PciPolicy", `onap.policies.optimization.resource.PciPolicy.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.PciPolicy.yaml>`_
   "Optimization.Resource.Vim_fit", `onap.policies.optimization.resource.Vim_fit.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.Vim_fit.yaml>`_
   "Optimization.Resource.VnfPolicy", `onap.policies.optimization.resource.VnfPolicy.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.VnfPolicy.yaml>`_
   "Optimization.Service", `onap.policies.optimization.Service.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.optimization.Service.yaml>`_
   "Optimization.Service.QueryPolicy", `onap.policies.optimization.service.QueryPolicy.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.optimization.service.QueryPolicy.yaml>`_
   "Optimization.Service.SubscriberPolicy", `onap.policies.optimization.service.SubscriberPolicy.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.optimization.service.SubscriberPolicy.yaml>`_
   "Controlloop.Guard.Common", `onap.policies.controlloop.guard.Common.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.Common.yaml>`_
   "Controlloop.Guard.Common.Blacklist", `onap.policies.controlloop.guard.common.Blacklist.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.common.Blacklist.yaml>`_
   "Controlloop.Guard.Common.FrequencyLimiter", `onap.policies.controlloop.guard.common.FrequencyLimiter.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.common.FrequencyLimiter.yaml>`_
   "Controlloop.Guard.Common.MinMax", `onap.policies.controlloop.guard.common.MinMax.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.common.MinMax.yaml>`_
   "Controlloop.Guard.Common.Filter", `onap.policies.controlloop.guard.common.Filter.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.common.Filter.yaml>`_
   "Controlloop.Guard.Coordination.FirstBlocksSecond", `onap.policies.controlloop.guard.coordination.FirstBlocksSecond.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.coordination.FirstBlocksSecond.yaml>`_
   "Controlloop.Operational.Common", `onap.policies.controlloop.operational.Common.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.controlloop.operational.Common.yaml>`_
   "Controlloop.Operational.Common.Apex", `onap.policies.controlloop.operational.common.Apex.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.controlloop.operational.common.Apex.yaml>`_
   "Controlloop.Operational.Common.Drools", `onap.policies.controlloop.operational.common.Drools.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.controlloop.operational.common.Drools.yaml>`_
   "Naming", `onap.policies.Naming.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.Naming.yaml>`_
   "Native.Drools", `onap.policies.native.Drools.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.native.Drools.yaml>`_
   "Native.Xacml", `onap.policies.native.Xacml.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.native.Xacml.yaml>`_
   "Native.Apex", `onap.policies.native.Apex.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policytypes/onap.policies.native.Apex.yaml>`_

We also preload a policy in the policy database. Below is a table listing the preloaded polic(ies).

.. csv-table::
   :header: "Policy Type Name", "Payload"
   :widths: 15,10

   "SDNC.Naming", `sdnc.policy.naming.input.tosca.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/sdnc.policy.naming.input.tosca.yaml>`_

Below is a table containing sample well-formed TOSCA compliant policies.

.. csv-table::
   :header: "Policy Name", "Payload"
   :widths: 15,10

   "vCPE.Monitoring.Tosca", `vCPE.policy.monitoring.input.tosca.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vCPE.policy.monitoring.input.tosca.yaml>`_  `vCPE.policy.monitoring.input.tosca.json <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vCPE.policy.monitoring.input.tosca.json>`_
   "vCPE.Optimization.Tosca", `vCPE.policies.optimization.input.tosca.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vCPE.policies.optimization.input.tosca.yaml>`_  `vCPE.policies.optimization.input.tosca.json <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vCPE.policies.optimization.input.tosca.json>`_
   "vCPE.Operational.Tosca", `vCPE.policy.operational.input.tosca.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vCPE.policy.operational.input.tosca.yaml>`_  `vCPE.policy.operational.input.tosca.json <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vCPE.policy.operational.input.tosca.json>`_
   "vDNS.Guard.FrequencyLimiting.Tosca", `vDNS.policy.guard.frequencylimiter.input.tosca.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vDNS.policy.guard.frequencylimiter.input.tosca.yaml>`_
   "vDNS.Guard.MinMax.Tosca", `vDNS.policy.guard.minmaxvnfs.input.tosca.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vDNS.policy.guard.minmaxvnfs.input.tosca.yaml>`_
   "vDNS.Guard.Blacklist.Tosca", `vDNS.policy.guard.blacklist.input.tosca.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vDNS.policy.guard.blacklist.input.tosca.yaml>`_
   "vDNS.Monitoring.Tosca", `vDNS.policy.monitoring.input.tosca.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vDNS.policy.monitoring.input.tosca.yaml>`_  `vDNS.policy.monitoring.input.tosca.json <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vDNS.policy.monitoring.input.tosca.json>`_
   "vDNS.Operational.Tosca", `vDNS.policy.operational.input.tosca.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vDNS.policy.operational.input.tosca.yaml>`_  `vDNS.policy.operational.input.tosca.json <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vDNS.policy.operational.input.tosca.json>`_
   "vFirewall.Monitoring.Tosca", `vFirewall.policy.monitoring.input.tosca.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vFirewall.policy.monitoring.input.tosca.yaml>`_  `vFirewall.policy.monitoring.input.tosca.json <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vFirewall.policy.monitoring.input.tosca.json>`_
   "vFirewall.Operational.Tosca", `vFirewall.policy.operational.input.tosca.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vFirewall.policy.operational.input.tosca.yaml>`_  `vFirewall.policy.operational.input.tosca.json <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vFirewall.policy.operational.input.tosca.json>`_
   "vFirewallCDS.Operational.Tosca", `vFirewallCDS.policy.operational.input.tosca.yaml <https://github.com/onap/policy-models/blob/guilin/models-examples/src/main/resources/policies/vFirewallCDS.policy.operational.input.tosca.yaml>`_


Below is a global API table from where swagger JSON for different types of policy design API can be downloaded.

Global API Table
----------------
.. csv-table::
   :header: "API name", "Swagger JSON"
   :widths: 10,5

   "Healthcheck API", ":download:`link <swagger/healthcheck-api.json>`"
   "Statistics API", ":download:`link <swagger/statistics-api.json>`"
   "Tosca Policy Type API", ":download:`link <swagger/policytype-api.json>`"
   "Tosca Policy API", ":download:`link <swagger/policy-api.json>`"

API Swagger
-----------

It is worth noting that we use basic authorization for API access with username and password set to *healthcheck* and *zb!XztG34* respectively.
Also, the new APIs support both *http* and *https*.

For every API call, client is encouraged to insert an uuid-type requestID as parameter.
It is helpful for tracking each http transaction and facilitates debugging.
Mostly importantly, it complies with Logging requirements v1.2.
If a client does not provide the requestID in API call, one will be randomly generated
and attached to response header *x-onap-requestid*.

In accordance with `ONAP API Common Versioning Strategy Guidelines <https://wiki.onap.org/display/DW/ONAP+API+Common+Versioning+Strategy+%28CVS%29+Guidelines>`_,
in the response of each API call, several custom headers are added::

    x-latestversion: 1.0.0
    x-minorversion: 0
    x-patchversion: 0
    x-onap-requestid: e1763e61-9eef-4911-b952-1be1edd9812b
    x-latestversion is used only to communicate an API's latest version.

x-minorversion is used to request or communicate a MINOR version back from the client to the server, and from the server back to the client.

x-patchversion is used only to communicate a PATCH version in a response for troubleshooting purposes only, and will not be provided by the client on request.

x-onap-requestid is used to track REST transactions for logging purpose, as described above.

.. swaggerv2doc:: swagger/healthcheck-api.json

.. swaggerv2doc:: swagger/statistics-api.json

.. swaggerv2doc:: swagger/policytype-api.json

.. swaggerv2doc:: swagger/policy-api.json

When making a POST policy API call, the client must not only provide well-formed JSON/YAML,
but also must conform to the TOSCA specification. For example. the "type" field for a TOSCA
policy should strictly match the policy type name it derives.
Please check out the sample policies in above policy table.

Also, in the POST payload passed into each policy or policy type creation call (i.e. POST API invocation), the client needs to explicitly
specify the version of the policy or policy type to create. That being said, the "version" field is mandatory in the TOSCA service template
formatted policy or policy type payload. If the version is missing, that POST call will return "406 - Not Acceptable" and
the policy or policy type to create will not be stored in the database.

To avoid inconsistent versions between the database and policies deployed in the PDPs, policy API REST service employs some enforcement
rules that validate the version specified in the POST payload when a new version is to create or an existing version to update.
Policy API will not blindly override the version of the policy or policy type to create/update.
Instead, we encourage the client to carefully select a version for the policy or policy type to change and meanwhile policy API will check the validity
of the version and feed an informative warning back to the client if the specified version is not good.
To be specific, the following rules are implemented to enforce the version:

1. If the incoming version is not in the database, we simply insert it. For example: if policy version 1.0.0 is stored in the database and now
   a client wants to create the same policy with updated version 3.0.0, this POST call will succeed and return "200" to the client.

2. If the incoming version is already in the database and the incoming payload is different from the same version in the database,
   "406 - Not Acceptable" will be returned. This forces the client to update the version of the policy if the policy is changed.

3. If a client creates a version of a policy and wishes to update a property on the policy, they must delete that version of the policy and re-create it.

4. If multiple policies are included in the POST payload, policy API will also check if duplicate version exists in between
   any two policies or policy types provided in the payload. For example, a client provides a POST payload which includes two policies with the same
   name and version but different policy properties. This POST call will fail and return "406" error back to the calling application along with a
   message such as "duplicate policy {name}:{version} found in the payload".

5. The same version validation is applied to policy types too.

6. To avoid unnecessary id/version inconsistency between the ones specified in the entity fields and the ones returned in the metadata field,
   "policy-id" and "policy-version" in the metadata will only be set by policy API. Any incoming explicit specification in the POST payload will be
   ignored. For example, A POST payload has a policy with name "sample-policy-name1" and version "1.0.0" specified. In this policy, the metadata
   also includes "policy-id": "sample-policy-name2" and "policy-version": "2.0.0". The 200 return of this POST call will have this created policy with
   metadata including "policy-id": "sample-policy-name1" and "policy-version": "1.0.0".

Regarding DELETE APIs for TOSCA compliant policies, we only expose API to delete one particular version of policy
or policy type at a time for safety purpose. If client has the need to delete multiple or a group of policies or policy types,
they will need to delete them one by one.

Sample API Curl Commands
-------------------------

From an API client perspective, using *http* or *https* does not make much difference to the curl command.
Here we list some sample curl commands (using *http*) for POST, GET and DELETE monitoring and operational policies that are used in vFirewall use case.
JSON payload for POST calls can be downloaded from policy table above.

If you are accessing the api from the container, the default *ip* and *port* would be **https:/policy-api:6969/policy/api/v1/**.

Create vFirewall Monitoring Policy::
  curl --user 'healthcheck:zb!XztG34' -X POST "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.monitoring.tcagen2/versions/1.0.0/policies" -H "Accept: application/json" -H "Content-Type: application/json" -d @vFirewall.policy.monitoring.input.tosca.json

Get vFirewall Monitoring Policy::
  curl --user 'healthcheck:zb!XztG34' -X GET "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.monitoring.tcagen2/versions/1.0.0/policies/onap.vfirewall.tca/versions/1.0.0" -H "Accept: application/json" -H "Content-Type: application/json"

Delete vFirewall Monitoring Policy::
  curl --user 'healthcheck:zb!XztG34' -X DELETE "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.monitoring.tcagen2/versions/1.0.0/policies/onap.vfirewall.tca/versions/1.0.0" -H "Accept: application/json" -H "Content-Type: application/json"

Create vFirewall Operational Policy::
  curl --user 'healthcheck:zb!XztG34' -X POST "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.controlloop.operational.common.Drools/versions/1.0.0/policies" -H "Accept: application/json" -H "Content-Type: application/json" -d @vFirewall.policy.operational.input.tosca.json

Get vFirewall Operational Policy::
  curl --user 'healthcheck:zb!XztG34' -X GET "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.controlloop.operational.common.Drools/versions/1.0.0/policies/operational.modifyconfig/versions/1.0.0" -H "Accept: application/json" -H "Content-Type: application/json"

Delete vFirewall Operational Policy::
  curl --user 'healthcheck:zb!XztG34' -X DELETE "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.controlloop.operational.common.Drools/versions/1.0.0/policies/operational.modifyconfig/versions/1.0.0" -H "Accept: application/json" -H "Content-Type: application/json"

Get all available policies::
  curl --user 'healthcheck:zb!XztG34' -X GET "http://{ip}:{port}/policy/api/v1/policies" -H "Accept: application/json" -H "Content-Type: application/json"

Get version 1.0.0 of vFirewall Monitoring Policy::
  curl --user 'healthcheck:zb!XztG34' -X GET "http://{ip}:{port}/policy/api/v1/policies/onap.vfirewall.tca/versions/1.0.0" -H "Accept: application/json" -H "Content-Type: application/json"

Delete version 1.0.0 of vFirewall Monitoring Policy::
  curl --user 'healthcheck:zb!XztG34' -X DELETE "http://{ip}:{port}/policy/api/v1/policies/onap.vfirewall.tca/versions/1.0.0" -H "Accept: application/json" -H "Content-Type: application/json"
