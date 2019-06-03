
.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

********************************
Feature: Control Loop Management
********************************

.. contents::
    :depth: 3

Summary
^^^^^^^

The Control Loop Management feature augments the telemetry tooling to allow 
introspection of runtime operational policies.

Usage
^^^^^

The feature is enabled by default.  The lifecycle "enabled" property can be toggled with 
the "features" command line tool.

    .. code-block:: bash
       :caption: PDPD Features Command

        policy stop

        features disable controlloop-management   # enable/disable toggles the activation of the feature.

        policy start

The "telemetry" tool can be used to list the control loops and associated Operational Polices at runtime.

    .. code-block:: bash
       :caption: PDPD Features Command

       bash-4.4$ telemetry
       Version: 1.0.0
       https://localhost:9696/policy/pdp/engine> cd controllers/usecases/drools/facts/usecases/controlloops
       https://localhost:9696/policy/pdp/engine/controllers/usecases/drools/facts/usecases/controlloops> get
       HTTP/1.1 200 OK
       Content-Length: 132
       Content-Type: application/json
       Date: Mon, 03 Jun 2019 20:23:38 GMT
       Server: Jetty(9.4.14.v20181114)

       [
           "LOOP_vLoadBalancerMS_v3_0_vLoadBalancerMS0_k8s-tca-clamp-policy-05162019", 
           "ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e"
       ]

       https://localhost:9696/policy/pdp/engine/controllers/usecases/drools/facts/usecases/controlloops> get ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e/policy
       HTTP/1.1 200 OK
       Content-Length: 612
       Content-Type: text/plain
       Date: Mon, 03 Jun 2019 20:23:58 GMT
       Server: Jetty(9.4.14.v20181114)

       controlLoop:
         version: 2.0.0
         controlLoopName: ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e
         trigger_policy: unique-policy-id-1-restart
         timeout: 3600
         abatement: true
 
       policies:
         - id: unique-policy-id-1-restart
           name: Restart the VM
           description:
           actor: APPC
           recipe: Restart
           target:
             type: VM
           retry: 3
           timeout: 1200
           success: final_success
           failure: final_failure
           failure_timeout: final_failure_timeout
           failure_retries: final_failure_retries
           failure_exception: final_failure_exception
           failure_guard: final_failure_guard

       https://localhost:9696/policy/pdp/engine/controllers/usecases/drools/facts/usecases/controlloops> 

End of Document
