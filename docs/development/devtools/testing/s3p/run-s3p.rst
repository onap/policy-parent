Running the Policy Framework S3P Tests
######################################

.. contents::
    :depth: 3

Per release, the policy framework team perform stability and performance tests per component of the policy framework.
This testing work involves performing a series of test on a full OOM deployment and updating the various test plans to work towards the given deployment.
This work can take some time to setup to begin with, before performing any tests.
For stability testing, a tool called JMeter is used to trigger a series of tests for a period of 72 hours which has to be manually initiated and monitored by the tester.
Likewise, the performance tests run in the same manner but for a shorter time of ~2 hours.
As part of the work to automate this process a script can be now triggered to bring up a microk8s cluster on a VM, install JMeter, alter the cluster info to match the JMX test plans for JMeter to trigger and gather results at the end.
These S3P tests will be triggered for a shorter period as part of the GHAs to prove the stability and performance of our components.

There has been recent work completed to trigger our CSIT tests in a K8s environment.
As part of this work, a script has been created to bring up a microk8s cluster for testing purposes which includes all necessary components for our policy framework testing.
For automating the S3Ps, we will use this script to bring up a K8s environment to perform the S3P tests against.
Once this cluster is brought up, a script is called to alter the cluster.
The IPS and PORTS of our policy components are set by this script to ensure consistency in the test plans.
JMeter is installed and the S3P test plans are triggered to run by their respective components.

`run-s3p-tests.sh <https://github.com/onap/policy-docker/blob/master/csit/run-s3p-tests.sh>`_

This script automates the setup, execution, and teardown of S3P tests for policy components.
It initializes a Kubernetes environment, installs Apache JMeter for running test plans, and executes specified JMX test files.
The script logs all operations, tracks errors, warnings, and processed files, and provides a summary report upon completion.
It includes options to either run tests (test <jmx_file>) or clean up the environment (clean). The clean option uninstalls the Kubernetes cluster and removes temporary resources.
The script also ensures proper resource usage tracking and error handling throughout its execution.

`run-s3p-test.sh <https://github.com/onap/policy-api/blob/master/testsuites/run-s3p-test.sh>`_

In summary, this script automates running performance or stability tests for a Policy Framework component by setting up necessary directories, cloning the required docker repository, and executing predefined test plans.
It also provides a clean-up option to remove resources after testing.