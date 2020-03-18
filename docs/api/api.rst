.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _api-label:

Policy Life Cycle API
#####################

.. contents::
    :depth: 2

Policy life cycle API comprises of policy design API and policy deployment API. This documentation focuses on policy
design API. Policy design API is publicly exposed for clients to Create/Read/Update/Delete (CRUD) policy types, policy type
implementation and policies which can be recognized and executable by appropriate policy engines incorporated in ONAP
policy framework. Policy design API backend is running in an independent building block component of policy framework
that provides REST service for aforementioned CRUD behaviors. Policy design API component interacts with a policy database
for storing and fetching new policies or policy types as needed. Apart from CRUD, API is also exposed for clients to retrieve
healthcheck status of this API REST service and statistics report including a variety of counters that reflect the history
of API invocation.

We strictly follow `TOSCA Specification <http://docs.oasis-open.org/tosca/TOSCA-Simple-Profile-YAML/v1.1/TOSCA-Simple-Profile-YAML-v1.1.pdf>`_
to define policy type and policy. A policy type is equivalent to the policy model mentioned by clients before Dublin release.
Both policy type and policy are included in a TOSCA Service Template which is used as the entity passed into API POST call
and the entity returned by API GET and DELETE calls. More details are presented in following sessions.
We encourage clients to compose all kinds of policies and corresponding policy types in well-formed TOSCA Service Template.
One Service Template can contain one or more policies and policy types. Each policy type can have multiple policies created
atop. In other words, different policies can match the same or different policy types. Existence of a policy type is a prerequisite
of creating such type of policies. In the payload body of each policy to create, policy type name and version should be indicated and
the specified policy type should be valid and existing in policy database.

To ease policy creation, we preload several widely used policy types in policy database. Below is a table listing the preloaded policy types.

.. csv-table::
   :header: "Policy Type Name", "Payload"
   :widths: 15,10

   "Monitoring.TCA", `onap.policies.monitoring.cdap.tca.hi.lo.app.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.monitoring.cdap.tca.hi.lo.app.yaml>`_
   "Monitoring.Collectors", `onap.policies.monitoring.dcaegen2.collectors.datafile.datafile-app-server.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.monitoring.dcaegen2.collectors.datafile.datafile-app-server.yaml>`_
   "Optimization", `onap.policies.Optimization.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.Optimization.yaml>`_
   "Optimization.Resource", `onap.policies.optimization.Resource.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.Resource.yaml>`_
   "Optimization.Resource.AffinityPolicy", `onap.policies.optimization.resource.AffinityPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.AffinityPolicy.yaml>`_
   "Optimization.Resource.DistancePolicy", `onap.policies.optimization.resource.DistancePolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.DistancePolicy.yaml>`_
   "Optimization.Resource.HpaPolicy", `onap.policies.optimization.resource.HpaPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.HpaPolicy.yaml>`_
   "Optimization.Resource.OptimizationPolicy", `onap.policies.optimization.resource.OptimizationPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.OptimizationPolicy.yaml>`_
   "Optimization.Resource.PciPolicy", `onap.policies.optimization.resource.PciPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.PciPolicy.yaml>`_
   "Optimization.Resource.Vim_fit", `onap.policies.optimization.resource.Vim_fit.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.Vim_fit.yaml>`_
   "Optimization.Resource.VnfPolicy", `onap.policies.optimization.resource.VnfPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.resource.VnfPolicy.yaml>`_
   "Optimization.Service", `onap.policies.optimization.Service.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.Service.yaml>`_
   "Optimization.Service.QueryPolicy", `onap.policies.optimization.service.QueryPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.service.QueryPolicy.yaml>`_
   "Optimization.Service.SubscriberPolicy", `onap.policies.optimization.service.SubscriberPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.service.SubscriberPolicy.yaml>`_
   "Controlloop.Guard.Common", `onap.policies.controlloop.guard.Common.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.Common.yaml>`_
   "Controlloop.Guard.Common.Blacklist", `onap.policies.controlloop.guard.common.Blacklist.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.common.Blacklist.yaml>`_
   "Controlloop.Guard.Common.FrequencyLimiter", `onap.policies.controlloop.guard.common.FrequencyLimiter.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.common.FrequencyLimiter.yaml>`_
   "Controlloop.Guard.Common.MinMax", `onap.policies.controlloop.guard.common.MinMax.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.common.MinMax.yaml>`_
   "Controlloop.Guard.Coordination.FirstBlocksSecond", `onap.policies.controlloop.guard.coordination.FirstBlocksSecond.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.coordination.FirstBlocksSecond.yaml>`_
   "Controlloop.Operational", `onap.policies.controlloop.Operational.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.Operational.yaml>`_
   "Controlloop.Operational.Common", `onap.policies.controlloop.operational.Common.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.operational.Common.yaml>`_
   "Controlloop.Operational.Common.Apex", `onap.policies.controlloop.operational.common.Apex.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.operational.common.Apex.yaml>`_
   "Controlloop.Operational.Common.Drools", `onap.policies.controlloop.operational.common.Drools.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.operational.common.Drools.yaml>`_
   "Naming", `onap.policies.Naming.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.Naming.yaml>`_
   "Native.Drools", `onap.policies.native.Drools.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.native.Drools.yaml>`_
   "Native.Xacml", `onap.policies.native.Xacml.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.native.Xacml.yaml>`_
   "Native.Apex", `onap.policies.native.Apex.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.native.Apex.yaml>`_

We also preload a policy in the policy database. Below is a table listing the preloaded polic(ies).

.. csv-table::
   :header: "Policy Type Name", "Payload"
   :widths: 15,10

   "SDNC.Naming", `sdnc.policy.naming.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/sdnc.policy.naming.input.tosca.yaml>`_

Below is a table containing sample well-formed TOSCA compliant policies.

.. csv-table::
   :header: "Policy Name", "Payload"
   :widths: 15,10

   "vCPE.Monitoring.Tosca", `vCPE.policy.monitoring.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vCPE.policy.monitoring.input.tosca.yaml>`_  `vCPE.policy.monitoring.input.tosca.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vCPE.policy.monitoring.input.tosca.json>`_
   "vCPE.Optimization.Tosca", `vCPE.policies.optimization.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vCPE.policies.optimization.input.tosca.yaml>`_  `vCPE.policies.optimization.input.tosca.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vCPE.policies.optimization.input.tosca.json>`_
   "vCPE.Operational.Tosca", `vCPE.policy.operational.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vCPE.policy.operational.input.tosca.yaml>`_  `vCPE.policy.operational.input.tosca.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vCPE.policy.operational.input.tosca.json>`_
   "vDNS.Guard.FrequencyLimiting.Tosca", `vDNS.policy.guard.frequencylimiter.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vDNS.policy.guard.frequencylimiter.input.tosca.yaml>`_
   "vDNS.Guard.MinMax.Tosca", `vDNS.policy.guard.minmaxvnfs.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vDNS.policy.guard.minmaxvnfs.input.tosca.yaml>`_
   "vDNS.Guard.Blacklist.Tosca", `vDNS.policy.guard.blacklist.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vDNS.policy.guard.blacklist.input.tosca.yaml>`_
   "vDNS.Monitoring.Tosca", `vDNS.policy.monitoring.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vDNS.policy.monitoring.input.tosca.yaml>`_  `vDNS.policy.monitoring.input.tosca.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vDNS.policy.monitoring.input.tosca.json>`_
   "vDNS.Operational.Tosca", `vDNS.policy.operational.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vDNS.policy.operational.input.tosca.yaml>`_  `vDNS.policy.operational.input.tosca.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vDNS.policy.operational.input.tosca.json>`_
   "vFirewall.Monitoring.Tosca", `vFirewall.policy.monitoring.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vFirewall.policy.monitoring.input.tosca.yaml>`_  `vFirewall.policy.monitoring.input.tosca.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vFirewall.policy.monitoring.input.tosca.json>`_
   "vFirewall.Operational.Tosca", `vFirewall.policy.operational.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vFirewall.policy.operational.input.tosca.yaml>`_  `vFirewall.policy.operational.input.tosca.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vFirewall.policy.operational.input.tosca.json>`_
   "vFirewallCDS.Operational.Tosca", `vFirewallCDS.policy.operational.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vFirewallCDS.policy.operational.input.tosca.yaml>`_


Below is a global API table from where swagger JSON for different types of policy design API can be downloaded.
Global API Table
--------------------
.. csv-table::
   :header: "API name", "Swagger JSON"
   :widths: 10,5

   "Healthcheck API", ":download:`link <swagger/healthcheck-api.json>`"
   "Statistics API", ":download:`link <swagger/statistics-api.json>`"
   "Tosca Policy Type API", ":download:`link <swagger/policytype-api.json>`"
   "Tosca Policy API", ":download:`link <swagger/policy-api.json>`"
   "Legacy Operational Policy API", ":download:`link <swagger/operational-policy-api.json>`"

API Swagger
--------------------

It is worth noting that we use basic authorization for API access with username and password set to *healthcheck* and *zb!XztG34* respectively.
Also, the new APIs support both *http* and *https*.

For every API call, client is encouraged to insert an uuid-type requestID as parameter.
It is helpful for tracking each http transaction and facilitates debugging.
Mostly importantly, it complies with Logging requirements v1.2.
If client does not provider the requestID in API call, one will be randomly generated
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

.. swaggerv2doc:: swagger/operational-policy-api.json

Regarding DELETE APIs for TOSCA compliant policies, we only expose API to delete one particular version of policy
or policy type at a time for safety purpose. If client has the need to delete multiple or a group of policies or policy types,
they will need to delete them one by one.

Sample API Curl Commands
-------------------------

From API client perspective, using *http* or *https* does not have much difference in curl command.
Here we list some sample curl commands (using *http*) for POST, GET and DELETE monitoring and operational policies that are used in vFirewall use case.
JSON payload for POST calls can be downloaded from policy table above.

Create vFirewall Monitoring Policy::
  curl --user 'healthcheck:zb!XztG34' -X POST "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.monitoring.cdap.tca.hi.lo.app/versions/1.0.0/policies" -H "Accept: application/json" -H "Content-Type: application/json" -d @vFirewall.policy.monitoring.input.tosca.json

Get vFirewall Monitoring Policy::
  curl --user 'healthcheck:zb!XztG34' -X GET "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.monitoring.cdap.tca.hi.lo.app/versions/1.0.0/policies/onap.vfirewall.tca/versions/1.0.0" -H "Accept: application/json" -H "Content-Type: application/json"

Delete vFirewall Monitoring Policy::
  curl --user 'healthcheck:zb!XztG34' -X DELETE "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.monitoring.cdap.tca.hi.lo.app/versions/1.0.0/policies/onap.vfirewall.tca/versions/1.0.0" -H "Accept: application/json" -H "Content-Type: application/json"

Create vFirewall Operational Policy::
  curl --user 'healthcheck:zb!XztG34' -X POST "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.controlloop.operational.common.Drools/versions/1.0.0/policies" -H "Accept: application/json" -H "Content-Type: application/json" -d @vFirewall.policy.operational.input.tosca.json

Get vFirewall Operational Policy::
  curl --user 'healthcheck:zb!XztG34' -X GET "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.controlloop.operational.common.Drools/versions/1.0.0/policies/operational.modifyconfig/versions/1.0.0" -H "Accept: application/json" -H "Content-Type: application/json"

Delete vFirewall Operational Policy::
  curl --user 'healthcheck:zb!XztG34' -X DELETE "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.controlloop.operational.common.Drools/versions/1.0.0/policies/operational.modifyconfig/versions/1.0.0" -H "Accept: application/json" -H "Content-Type: application/json"
