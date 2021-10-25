.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _xacml-s3p-label:

.. toctree::
   :maxdepth: 2

##########################

Performance Test of Policy XACML PDP
************************************

The Performance test was executed by performing requests
against the Policy RESTful APIs residing on the XACML PDP installed on a Cloud based Virtual Machine.

VM Configuration:
- 16GB RAM
- 4 VCPU
- 40GB Disk

ONAP was deployed using a K8s Configuration on the same VM.
Running jmeter and ONAP OOM on the same VM may adversely impact the performance of the XACML-PDP being tested.

Summary
=======

The Performance test was executed, and the result analyzed, via:

.. code-block:: bash

    jmeter -Jduration=1200 -Jusers=10 \
        -Jxacml_ip=$ip -Jpap_ip=$ip -Japi_ip=$ip \
        -Jxacml_port=30111 -Jpap_port=30197 -Japi_port=30664 \
        -n -t perf.jmx -l testresults.jtl

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

   10, 309.919, 5.83457
   20, 2527.73, 22.2634
   40, 3184.78, 35.1173
   80, 3677.35, 60.2893


Stability Test of Policy XACML PDP
************************************

The stability test was executed by performing requests
against the Policy RESTful APIs residing on the XACML PDP installed in the citycloud
lab.  This was running on a kubernetes pod having the following configuration:

- 16GB RAM
- 4 VCPU
- 40GB Disk

The test was run via jmeter, which was installed on the same VM.
Running jmeter and ONAP OOM on the same VM may adversely impact the performance of the XACML-PDP being tested.
Due to the minimal nauture of this setup, the K8S cluster became overloaded on a couple of occasions during the test.
This resulted in a small number of errors and a greater maximum transaction time than normal.

Summary
=======

The stability test was performed on a default ONAP OOM installation in the city Cloud Lab environment.
JMeter was installed on the same VM to inject the traffic defined in the
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

    summary = 222450112 in 72:00:39 =  858.1/s Avg:     5 Min:     1 Max: 946942 Err:    17 (0.00%)

The XACML PDP offered good performance with JMeter for the traffic mix described above, using 858 threads per second
to inject the traffic load.   A small number of errors were encountered, and no significant CPU spikes were noted.
The average transaction time was 5ms. with a maximum of 946942ms.

