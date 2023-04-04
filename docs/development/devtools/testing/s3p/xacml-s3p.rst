.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _xacml-s3p-label:

.. toctree::
   :maxdepth: 2

##########################

Performance Test of Policy XACML PDP (Jakarta)
**********************************************

The Performance test was executed by performing requests
against the Policy RESTful APIs.

A default ONAP installation in the Policy tenant in UNH was used to run the tests.

The Agent VMs in this lab have the following configuration:

- 16GB RAM
- 8 VCPU

Summary
=======

The Performance test was executed, and the result analysed, via:

.. code-block:: bash

    jmeter -Jduration=1200 -Jusers=10 \
        -Jxacml_ip=$ip -Jpap_ip=$ip -Japi_ip=$ip \
        -Jxacml_port=30111 -Jpap_port=30197 -Japi_port=30664 \
        -n -t perf.jmx -l testresults.jtl

Note: the ports listed above correspond to port 6969 of the respective components.

The performance tests runs the following, all in parallel:

- Healthcheck, 10 simultaneous threads
- Statistics, 10 simultaneous threads
- Decisions, 10 simultaneous threads, each running the following in sequence:

   - Monitoring Decision
   - Monitoring Decision, abbreviated
   - Naming Decision
   - Optimization Decision
   - Default Guard Decision (always "Permit")
   - Frequency Limiter Guard Decision
   - Min/Max Guard Decision

When the script starts up, it uses policy-api to create, and policy-pap to deploy,
the policies that are needed by the test.  It assumes that the "naming" policy has
already been created and deployed.  Once the test completes, it undeploys and deletes
the policies that it previously created.

Results
=======

The test was run for 20 minutes with 10 users (i.e., threads), with the following results:

.. csv-table::
   :header: "Number of Users", "Throughput (requests/second)", "Average Latency (ms)"

   10, 4603, 2

.. image:: xacml-s3p-results/s3p-perf-xacml.png


Stability Test of Policy XACML PDP
**********************************

This test was run using jmeter on a default
ONAP installation in the Policy tenant in UNH.

The Agent VMs in this lab have the following configuration:

- 16GB RAM
- 8 VCPU

Summary
=======

The stability test was performed on a default ONAP OOM installation in the Policy tenant of the UNH lab.
JMeter injected the traffic defined in the
`XACML PDP stability script
<https://git.onap.org/policy/xacml-pdp/tree/testsuites/stability/src/main/resources/testplans/stability.jmx>`_
with the following command:

.. code-block:: bash

    jmeter.sh -Jduration=259200 -Jusers=2 -Jxacml_ip=$ip -Jpap_ip=$ip -Japi_ip=$ip \
        -Jxacml_port=30111 -Jpap_port=30197 -Japi_port=30664 --nongui --testfile stability.jmx

Note: the ports listed above correspond to port 6969 of the respective components.

The default log level of the root and org.eclipse.jetty.server.RequestLog loggers in the logback.xml
of the XACML PDP
(om/kubernetes/policy/components/policy-xacml-pdp/resources/config/logback.xml)
was set to WARN since the OOM installation did have log rotation enabled of the
container logs in the kubernetes worker nodes.

The stability test, stability.jmx, runs the following, all in parallel:

- Healthcheck, 2 simultaneous threads
- Statistics, 2 simultaneous threads
- Decisions, 2 simultaneous threads, each running the following tasks in sequence:
   - Monitoring Decision
   - Monitoring Decision, abbreviated
   - Naming Decision
   - Optimization Decision
   - Default Guard Decision (always "Permit")
   - Frequency Limiter Guard Decision
   - Min/Max Guard Decision

When the script starts up, it uses policy-api to create, and policy-pap to deploy
the policies that are needed by the test.  It assumes that the "naming" policy has
already been created and deployed.  Once the test completes, it undeploys and deletes
the policies that it previously created.

Results
=======

The stability summary results were reported by JMeter with the following summary line:

.. code-block:: bash

    summary = 941639699 in 71:59:36 = 3633.2/s Avg:     1 Min:     0 Max:   842 Err:     0 (0.00%)

The XACML PDP offered very good performance with JMeter for the traffic mix described above.
The average transaction time is insignificant.  The maximum transaction time of 842 ms.
There was a Drools stability test running in parallel, hence the actual load was higher.

