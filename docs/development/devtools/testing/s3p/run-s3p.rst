Running the Policy Framework S3P Tests
######################################

.. contents::
    :depth: 3

Per release, the policy framework team perform stability and performance tests per component of the policy framework.
This testing work involves performing a series of test on a full OOM deployment and updating the various test plans to work towards the given deployment.
This work can take some time to setup before performing any tests to begin with.
For stability testing, a tool called JMeter is used to trigger a series of tests for a period of 72 hours which has to be manually initiated and monitored by the tester.
Likewise, with the performance tests, but in this case for ~2 hours.
As part of the work to make to automate this process a script can be now triggered to bring up a microk8s cluster on a VM, install JMeter, alter the cluster info to match the JMX test plans for JMeter to trigger and gather results at the end.
These S3P tests will be triggered for a shorter period as part of the CSITs to prove the stability and performance of our components.

There has been recent work completed to trigger our CSIT tests in a K8s environment.
As part of this work, a script has been created to bring up a microk8s cluster for testing purposes which includes all necessary components for our policy framework testing.
For automating the S3Ps, we will use this script to bring up a K8s environment to perform the S3P tests against.
Once this cluster is brought up, a script is called to alter the cluster.
The IPS and PORTS of our policy components are set by this script to ensure consistency in the test plans.
JMeter is installed and the S3P test plans are triggered to run by their respective components.

.. code-block:: bash
   :caption: Start S3P Script

   #===MAIN===#
   if [ -z "${WORKSPACE}" ]; then
       export WORKSPACE=$(git rev-parse --show-toplevel)
   fi
   export TESTDIR=${WORKSPACE}/testsuites
   export API_PERF_TEST_FILE=$TESTDIR/performance/src/main/resources/testplans/policy_api_performance.jmx
   export API_STAB_TEST_FILE=$TESTDIR/stability/src/main/resources/testplans/policy_api_stability.jmx
   if [ $1 == "run" ]
   then
     mkdir automate-performance;cd automate-performance;
     git clone "https://gerrit.onap.org/r/policy/docker"
     cd docker/csit
     if [ $2 == "performance" ]
     then
       bash start-s3p-tests.sh run $API_PERF_TEST_FILE;
     elif [ $2 == "stability" ]
     then
       bash start-s3p-tests.sh run $API_STAB_TEST_FILE;
     else
       echo "echo Invalid arguments provided. Usage: $0 [option..] {performance | stability}"
     fi
   else
     echo "Invalid arguments provided. Usage: $0 [option..] {run | uninstall}"
   fi

This script is triggered by each component.
It will export the performance and stability testplans and trigger the start-s3p-test.sh script which will perform the steps to automatically run the s3p tests.

