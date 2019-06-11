.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _api-label:

Policy Life Cycle API
#####################
.. toctree::
   :maxdepth: 2 


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

In Dublin release, to ease policy creation, we preload several widely used policy types in policy database. Below is a table summarizing 
preloaded policy types.

.. csv-table::
   :header: "Policy Type Name", "Preloaded JSON"
   :widths: 15,10

   "Controlloop.Guard.Blacklist", ":download:`link <policytypes/onap.policies.controlloop.guard.Blacklist.json>`"
   "Controlloop.Guard.FrequencyLimiter", ":download:`link <policytypes/onap.policies.controlloop.guard.FrequencyLimiter.json>`"
   "Controlloop.Guard.MinMax", ":download:`link <policytypes/onap.policies.controlloop.guard.MinMax.json>`"
   "Controlloop.Operational", ":download:`link <policytypes/onap.policies.controlloop.Operational.json>`"
   "Monitoring.TCA", ":download:`link <policytypes/onap.policies.monitoring.cdap.tca.hi.lo.app.json>`"
   "Monitoring.Collectors", ":download:`link <policytypes/onap.policies.monitoring.dcaegen2.collectors.datafile.datafile-app-server.json>`"
   "Optimization.AffinityPolicy", ":download:`link <policytypes/onap.policies.optimization.AffinityPolicy.json>`"
   "Optimization.DistancePolicy", ":download:`link <policytypes/onap.policies.optimization.DistancePolicy.json>`"
   "Optimization.HpaPolicy", ":download:`link <policytypes/onap.policies.optimization.HpaPolicy.json>`"
   "Optimization.OptimizationPolicy", ":download:`link <policytypes/onap.policies.optimization.OptimizationPolicy.json>`"
   "Optimization.PciPolicy", ":download:`link <policytypes/onap.policies.optimization.PciPolicy.json>`"
   "Optimization.QueryPolicy", ":download:`link <policytypes/onap.policies.optimization.QueryPolicy.json>`"
   "Optimization.SubscriberPolicy", ":download:`link <policytypes/onap.policies.optimization.SubscriberPolicy.json>`"
   "Optimization.Vim_fit", ":download:`link <policytypes/onap.policies.optimization.Vim_fit.json>`"
   "Optimization.VnfPolicy", ":download:`link <policytypes/onap.policies.optimization.VnfPolicy.json>`"


Also, in Dublin release, We provide backward compatibility support for controlloop operational and guard 
policies encoded in legacy format. Below is a table containing sample legacy guard/operational policies and 
well-formed TOSCA monitoring policies.

.. csv-table::
   :header: "Policy Name", "Policy JSON"
   :widths: 15,10

   "vCPE.Monitoring.Tosca", ":download:`link <policies/vCPE.policy.monitoring.input.tosca.json>`"
   "vCPE.Operational.Legacy", ":download:`link <policies/vCPE.policy.operational.input.json>`"
   "vDNS.Guard.FrequencyLimiting.Legacy", ":download:`link <policies/vDNS.policy.guard.frequency.input.json>`"
   "vDNS.Guard.MinMax.Legacy", ":download:`link <policies/vDNS.policy.guard.minmax.input.json>`"
   "vDNS.Monitoring.Tosca", ":download:`link <policies/vDNS.policy.monitoring.input.tosca.json>`"
   "vDNS.Operational.Legacy", ":download:`link <policies/vDNS.policy.operational.input.json>`"
   "vFirewall.Monitoring.Tosca", ":download:`link <policies/vFirewall.policy.monitoring.input.tosca.json>`"
   "vFirewall.Operational.Legacy", ":download:`link <policies/vFirewall.policy.operational.input.json>`"


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
in the JSON payload, "type" field value should strictly match the policy type name embedded in the API path (case sensitive). 
Otherwise, it will complain the policy type does not exist. Please check out the sample policies in above policy table.

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

  
