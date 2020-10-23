.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _xacml-s3p-label:

.. toctree::
   :maxdepth: 2

Policy XACML PDP component
##########################

Both the Performance and the Stability tests were executed by performing requests
against the Policy RESTful APIs residing on the XACML PDP installed in the windriver
lab.  This was running on a kubernetes pod having the following configuration:

- 16GB RAM
- 8 VCPU
- 160GB Disk

Both tests were run via jmeter, which was installed on a separate VM so-as not
to impact the performance of the XACML-PDP being tested.

Performance Test of Policy XACML PDP
************************************

Summary
=======

The Performance test was executed, and the result analyzed, via:

.. code-block:: bash

    jmeter -Jduration=1200 -Jusers=10 \
        -Jxacml_ip=$ip -Jpap_ip=$ip -Japi_ip=$ip \
        -Jxacml_port=31104 -Jpap_port=32425 -Japi_port=30709 \
        -n -t perf.jmx

    ./result.sh

Note: the ports listed above correspond to port 6969 of the respective components.

The performance test, perf.jmx, runs the following, all in parallel:

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

The test was run for 20 minutes at a time, for different numbers of users (i.e.,
threads), with the following results:

.. csv-table::
   :header: "Number of Users", "Throughput (requests/second)", "Average Latency (ms)"

   10, 6064, 4.1
   20, 6495, 7.2
   40, 6457, 12.2
   80, 5803, 21.3


Stability Test of Policy XACML PDP
************************************

Summary
=======

The stability test was performed on a default ONAP OOM installation in the Intel Wind River Lab environment.
JMeter was installed on a separate VM to inject the traffic defined in the
`XACML PDP stability script
<https://git.onap.org/policy/xacml-pdp/tree/testsuites/stability/src/main/resources/testplans/stability.jmx>`_
with the following command:

.. code-block:: bash

    jmeter.sh -Jduration=259200 -Jusers=2 -Jxacml_ip=$ip -Jpap_ip=$ip -Japi_ip=$ip \
        -Jxacml_port=31104 -Jpap_port=32425 -Japi_port=30709 --nongui --testfile stability.jmx

The default log level of the root and org.eclipse.jetty.server.RequestLog loggers in the logback.xml
of the XACML PDP
(om/kubernetes/policy/components/policy-xacml-pdp/resources/config/logback.xml)
was set to ERROR since the OOM installation did not have log rotation enabled of the
container logs in the kubernetes worker nodes.

Results
=======

The stability summary results were reported by JMeter with the following line:

.. code-block:: bash

    2020-10-23 19:44:31,515 INFO o.a.j.r.Summariser: summary = 1061746369 in 72:00:16 = 4096.0/s Avg:     0 Min:     0 Max:  2584 Err:     0 (0.00%)

The XACML PDP offered good performance with JMeter for the traffic mix described above, creating 4096 threads per second
to inject the traffic load.   No errors were encountered, and no significant CPU spikes were noted.

