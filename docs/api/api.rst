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

Starting from Dublin release, we strictly follow `TOSCA Specification <http://docs.oasis-open.org/tosca/TOSCA-Simple-Profile-YAML/v1.1/TOSCA-Simple-Profile-YAML-v1.1.pdf>`_ 
to define policy type and policy. Policy type is equivalent to policy model mentioned by clients before Dublin release.
Both policy type and policy are included in a TOSCA Service Template which is used as the entity passed into API POST call 
and the entity returned by API GET and DELETE calls. More details are presented in following sessions.
We encourage clients to compose all kinds of policies and corresponding policy types in well-formed TOSCA Service Template. 
One Service Template can contain one or more policies and policy types. Each policy type can have multiple policies created 
atop. In other words, different policies can match the same or different policy types. Existence of a policy type is a prerequisite
of creating such type of policies. In the payload body of each policy to create, policy type name and version should be indicated and
the specified policy type should be valid and existing in policy database. 

Starting from El Alto release, to ease policy creation, we preload several widely used policy types in policy database. Below is a table summarizing 
preloaded policy types.

.. csv-table::
   :header: "Policy Type Name", "Payload"
   :widths: 15,10

   "Controlloop.Guard.Blacklist", `onap.policies.controlloop.guard.Blacklist.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.Blacklist.yaml>`_
   "Controlloop.Guard.FrequencyLimiter", `onap.policies.controlloop.guard.FrequencyLimiter.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.FrequencyLimiter.yaml>`_
   "Controlloop.Guard.MinMax", `onap.policies.controlloop.guard.MinMax.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.MinMax.yaml>`_
   "Controlloop.Guard.Coordination.FirstBlocksSecond", `onap.policies.controlloop.guard.coordination.FirstBlocksSecond.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.guard.coordination.FirstBlocksSecond.yaml>`_
   "Controlloop.Operational", `onap.policies.controlloop.Operational.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.controlloop.Operational.yaml>`_
   "Monitoring.TCA", `onap.policies.monitoring.cdap.tca.hi.lo.app.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.monitoring.cdap.tca.hi.lo.app.yaml>`_
   "Monitoring.Collectors", `onap.policies.monitoring.dcaegen2.collectors.datafile.datafile-app-server.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.monitoring.dcaegen2.collectors.datafile.datafile-app-server.yaml>`_
   "Optimization", `onap.policies.Optimization.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.Optimization.yaml>`_
   "Optimization.AffinityPolicy", `onap.policies.optimization.AffinityPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.AffinityPolicy.yaml>`_
   "Optimization.DistancePolicy", `onap.policies.optimization.DistancePolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.DistancePolicy.yaml>`_
   "Optimization.HpaPolicy", `onap.policies.optimization.HpaPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.HpaPolicy.yaml>`_
   "Optimization.OptimizationPolicy", `onap.policies.optimization.OptimizationPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.OptimizationPolicy.yaml>`_
   "Optimization.PciPolicy", `onap.policies.optimization.PciPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.PciPolicy.yaml>`_
   "Optimization.QueryPolicy", `onap.policies.optimization.QueryPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.QueryPolicy.yaml>`_
   "Optimization.SubscriberPolicy", `onap.policies.optimization.SubscriberPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.SubscriberPolicy.yaml>`_
   "Optimization.Vim_fit", `onap.policies.optimization.Vim_fit.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.Vim_fit.yaml>`_
   "Optimization.VnfPolicy", `onap.policies.optimization.VnfPolicy.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policytypes/onap.policies.optimization.VnfPolicy.yaml>`_

Also, in El Alto release, We provide backward compatibility support for controlloop operational and guard 
policies encoded in legacy format. Below is a table containing sample legacy guard/operational policies and 
well-formed TOSCA monitoring policies.

.. csv-table::
   :header: "Policy Name", "Payload"
   :widths: 15,10

   "vCPE.Monitoring.Tosca", `vCPE.policy.monitoring.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vCPE.policy.monitoring.input.tosca.yaml>`_  `vCPE.policy.monitoring.input.tosca.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vCPE.policy.monitoring.input.tosca.json>`_
   "vCPE.Optimization.Tosca", `vCPE.policies.optimization.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vCPE.policies.optimization.input.tosca.yaml>`_
   "vCPE.Operational.Legacy", `vCPE.policy.operational.input.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vCPE.policy.operational.input.json>`_
   "vDNS.Guard.FrequencyLimiting.Legacy", `vDNS.policy.guard.frequency.input.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vDNS.policy.guard.frequency.input.json>`_
   "vDNS.Guard.MinMax.Legacy", `vDNS.policy.guard.minmax.input.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vDNS.policy.guard.minmax.input.json>`_
   "vDNS.Monitoring.Tosca", `vDNS.policy.monitoring.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vDNS.policy.monitoring.input.tosca.yaml>`_  `vDNS.policy.monitoring.input.tosca.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vDNS.policy.monitoring.input.tosca.json>`_
   "vDNS.Operational.Legacy", `vDNS.policy.operational.input.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vDNS.policy.operational.input.json>`_
   "vFirewall.Monitoring.Tosca", `vFirewall.policy.monitoring.input.tosca.yaml <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vFirewall.policy.monitoring.input.tosca.yaml>`_  `vFirewall.policy.monitoring.input.tosca.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vFirewall.policy.monitoring.input.tosca.json>`_
   "vFirewall.Operational.Legacy", `vFirewall.policy.operational.input.json <https://github.com/onap/policy-models/blob/master/models-examples/src/main/resources/policies/vFirewall.policy.operational.input.json>`_


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
   "Legacy Guard Policy API", ":download:`link <swagger/guard-policy-api.json>`"
   "Legacy Operational Policy API", ":download:`link <swagger/operational-policy-api.json>`"

API Swagger
--------------------

It is worth noting that we use basic authorization for API access with username and password set to *healthcheck* and *zb!XztG34* respectively. 
Also, the new APIs support both *http* and *https*.

For every API call, client is encouraged to insert an uuid-type requestID as parameter. It is helpful for tracking each http transaction 
and facilitates debugging. Mostly importantly, it complies with Logging requirements v1.2. If client does not provider the requestID in API call,
one will be randomly generated and attached to response header *x-onap-requestid*.

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

It is worth noting that in POST policy API, client needs to provide a policy payload encoded in well-formed TOSCA Service Template, and 
in the JSON/YAML payload, "type" field value should strictly match the policy type name embedded in the API path (case sensitive). 
Otherwise, it will complain the policy type does not exist. Please check out the sample policies in above policy table.

Also, in the POST payload passed into each policy or policy type creation call (i.e. POST API invocation), client needs to explicitly 
specify the version of the policy or policy type to create. That being said, "version" field is mandatory in TOSCA service template 
formatted policy or policy type payload. Likewise in legacy guard and operational policy payload, "policy-version" is mandatory too. 
If version is missing, that POST call will return "406 - Not Acceptable" and the policy or policy type to create will not be stored in
the database.

To avoid inconsistent versions existing in between the database and deployed in the PDPs, policy API REST service employs some enforcement 
rules that validate the version specified in the POST payload when a new version is to create or an existing version to update. 
Policy API will not blindly override the version of the policy or policy type to create/update. 
Instead, we encourage client to carefully select a version for the policy or policy type to change and meanwhile policy API will check the validity 
of the version and feed the useful informative warning back to the client if the specified version is not good.
To be specific, the following rules are implemented to enforce the version:

1. If the version is not in the database, we simply insert it. For example: if policy version 1.0.0 is stored in the database and now 
   a client wants to create the same policy with updated version 3.0.0, it will pass through and be stored in the database.

2. If the version is already in the database, "406 - Not Acceptable" will be returned along with the message saying "specified version x.x.x" 
   is already existing and the latest version is y.y.y. It can force the client to create a newer version than the latest one. 
   For example, if policy versions "1.0.0" and "2.0.0" are already in the database and a client wants to create version "1.0.0" again, the 
   client will get "406" code returned along with the message "specified version 1.0.0 is already existing and the latest version is 2.0.0".
   Then the client can change the version to anything newer than "2.0.0", says "3.0.0". 

3. If multiply policies or policy types are included in the POST payload, policy API will also check if duplicate version exists in between 
   any two policies or policy types provided in the payload. For example, a client provides a POST payload which includes two policies with the same 
   name and version but different policy properties. This POST call will not get through and the client will receive "406" code along with a message 
   saying "duplicate policy {name}:{version} found in the payload".

4. The same version validation is applied to legacy types of policies and policy types too (i.e. legacy guard and operational) so that everything 
   is consistent.

5. To avoid unnecessary id/version inconsistency between the ones specified in the entity fields and the ones returned in the metadata field, 
   "policy-id" and "policy-version" in the metadata will only be set by policy API. Any incoming explicit specification in the POST payload will be 
   ignored. For example, A POST payload has a policy with name "sample-policy-name1" and version "1.0.0" specified. In this policy, the metadata 
   also includes "policy-id": "sample-policy-name2" and "policy-version": "2.0.0". The 200 return of this POST call will have this created policy with 
   metadata including "policy-id": "sample-policy-name1" and "policy-version": "1.0.0".

.. swaggerv2doc:: swagger/guard-policy-api.json

It is worth noting that guard policy name should start with one of the three: *guard.frequency.*, *guard.minmax.*, or *guard.blacklist.*.
Otherwise, it will complain that guard policy type cannot be found (does not exist). Apart from policy name, the policy version specified 
in API path should be an integer, e.g. 1, 2, 10, instead of "1.0.0", "2.0.1", etc.
These naming restrictions will disappear after we evolve to use well-formed TOSCA Service Template for guard policies and 
legacy policy design API is then deprecated.

.. swaggerv2doc:: swagger/operational-policy-api.json

Likewise, the policy version specified in operational policy API path should be an integer too, e.g. 1, 2, 10, instead of 
"1.0.0", "2.0.1", etc. This restriction will disappear after we deprecate legacy policy design API in the near future release.


Regarding DELETE APIs for both TOSCA policies and legacy policies, we only expose API to delete one particular version of policy 
or policy type at a time for safety purpose. If client has the need to delete multiple or a group of policies or policy types, 
they will need to delete one by one.  

Sample API Curl Commands
-------------------------

From API client perspective, using *http* or *https* does not have much difference in curl command. Here we list some sample curl commands (using *http*) 
for POST, GET and DELETE monitoring and operational policies that are used in vFirewall use case. 

JSON payload for POST calls can be downloaded from policy table above.

Create vFirewall Monitoring Policy::
  curl --user 'healthcheck:zb!XztG34' -X POST "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.monitoring.cdap.tca.hi.lo.app/versions/1.0.0/policies" -H "Accept: application/json" -H "Content-Type: application/json" -d @vFirewall.policy.monitoring.input.tosca.json

Get vFirewall Monitoring Policy::
  curl --user 'healthcheck:zb!XztG34' -X GET "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.monitoring.cdap.tca.hi.lo.app/versions/1.0.0/policies/onap.vfirewall.tca/versions/1.0.0" -H "Accept: application/json" -H "Content-Type: application/json"
  
Delete vFirewall Monitoring Policy::
  curl --user 'healthcheck:zb!XztG34' -X DELETE "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.monitoring.cdap.tca.hi.lo.app/versions/1.0.0/policies/onap.vfirewall.tca/versions/1.0.0" -H "Accept: application/json" -H "Content-Type: application/json"

Create vFirewall Operational Policy::
  curl --user 'healthcheck:zb!XztG34' -X POST "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.controlloop.Operational/versions/1.0.0/policies" -H "Accept: application/json" -H "Content-Type: application/json" -d @vFirewall.policy.operational.input.json
  
Get vFirewall Operational Policy::
  curl --user 'healthcheck:zb!XztG34' -X GET "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.controlloop.Operational/versions/1.0.0/policies/operational.modifyconfig/versions/1" -H "Accept: application/json" -H "Content-Type: application/json"
  
Delete vFirewall Operational Policy::
  curl --user 'healthcheck:zb!XztG34' -X DELETE "http://{ip}:{port}/policy/api/v1/policytypes/onap.policies.controlloop.Operational/versions/1.0.0/policies/operational.modifyconfig/versions/1" -H "Accept: application/json" -H "Content-Type: application/json"

  
