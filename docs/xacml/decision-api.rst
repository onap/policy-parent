.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _decision-api-label:

Decision API
############

The Decision API is used by ONAP components that enforce policies and need a decision on which policy to enforce for a
specific situation. The Decision API mimics closely the XACML request standard in that it supports a subject, action
and resource.

 When the PAP enables an xacml-pdp, the decision API becomes available. Conversely, when the PAP disables an xacml-pdp, the
 decision API is disabled. The decision API is enabled/disabled by the PDP-STATE-CHANGE messages from PAP. If a request is
 to the decision API while it is disabled, a "404 - Not Found" error will be returned.

.. csv-table::
   :header: "Field", "Required", "XACML equivalent", "Description"

   "ONAPName", "True", "subject", "The name of the ONAP project making the call"
   "ONAPComponent", "True", "subject", "The name of the ONAP sub component making the call"
   "ONAPInstance", "False", "subject", "An optional instance ID for that sub component"
   "action", "True", "action", "The action being performed"
   "resource", "True", "resource", "An object specific to the action that contains properties describing the resource"

It is worth noting that we use basic authorization for API access with username and password set to *healthcheck* and *zb!XztG34* respectively.
Also, the new APIs support both *http* and *https*.

For every API call, the client is encouraged to insert an uuid-type requestID as parameter. It is helpful for tracking each http transaction
and facilitates debugging. Most importantly, it complies with Logging requirements v1.2. If the client does not provide the requestID in the API call,
one will be randomly generated and attached to the response header *x-onap-requestid*.

In accordance with `ONAP API Common Versioning Strategy Guidelines <https://wiki.onap.org/display/DW/ONAP+API+Common+Versioning+Strategy+%28CVS%29+Guidelines>`_,
in the response of each API call, several custom headers are added::

    x-latestversion: 1.0.0
    x-minorversion: 0
    x-patchversion: 0
    x-onap-requestid: e1763e61-9eef-4911-b952-1be1edd9812b

x-latestversion is used only to communicate an API's latest version.

x-minorversion is used to request or communicate a MINOR version back from the client to the server, and from the server back to the client.

x-patchversion is used only to communicate a PATCH version in a response for troubleshooting purposes only, and will be provided to the client on request.

x-onap-requestid is used to track REST transactions for logging purpose, as described above.

:download:`Download the Decision API Swagger <swagger.json>`

.. swaggerv2doc:: swagger.json


End of Document
