.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _strimzi-policy-label:

.. toctree::
   :maxdepth: 2

Policy Framework with Strimzi-Kafka communication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This page will explain how to setup a local Kubernetes cluster and minimal helm setup to run and deploy Policy Framework on a single host.
The rationale for this page is to spin up a development environment quickly and efficiently without the hassle of setting up a multi node cluster/Network file share that are needed in a full deployment.

This is meant for a development purpose only as we are going to use microk8s in this page

Troubleshooting tips included for possible issues while installation

General Setup
*************

One VM running Ubuntu 20.04 LTS (should also work on 18.04), with internet access to download charts/containers and the oom repo
Root/sudo privileges
Sufficient RAM depending on how many components you want to deploy
Around 20G of RAM allows for a few components, the minimal setup to enable(AAF, Policy, Strimzi-Kafka)


Overall procedure
*****************

Install/remove Microk8s with appropriate version
Install/remove Helm with appropriate version
Tweak Microk8s
Download oom repo
Install the needed Helm plugins
Install ChartMuseum as a local helm repo
Build all oom charts and store them in the chart repo
Fine tune deployment based on your VM capacity and component needs
Deploy/Undeploy charts
Enable communication over Kafka
Run testsuites


Install/Upgrade Microk8s with appropriate version
-------------------------------------------------

Microk8s is a bundled lightweight version of kubernetes maintained by Canonical, it has the advantage to be well integrated with snap on Ubuntu, which makes it super easy to manage/upgrade/work with

More info on : https://microk8s.io/docs

There are 2 things to know with microk8s :

1) it is wrapped by snap, which is nice but you need to understand that it's not exactly the same as having a proper k8s installation (more info below on some specific commands)

2) it is not using docker as the container runtime, it's using containerd, it's not an issue, just be aware of that as you won't see containers using classic docker commands


If you have a previous version of microk8s, you first need to uninstall it (upgrade is possible but it is not recommended between major versions so I recommend to uninstall as it's fast and safe)

    .. code-block:: bash

        sudo snap remove microk8s

You need to select the appropriate version to install, to see all possible version do :

    .. code-block:: bash

       sudo snap info microk8s
       sudo snap install microk8s --classic --channel=1.19/stable

You may need to change your firewall configuration to allow pod to pod communication and pod to internet communication :

    .. code-block:: bash

       sudo ufw allow in on cni0 && sudo ufw allow out on cni0
       sudo ufw default allow routed
       sudo microk8s enable dns storage
       sudo microk8s enable dns

Install/remove Helm with appropriate version
--------------------------------------------

Helm is the package manager for k8s, we require a specific version for each ONAP release, the best is to look at the OOM guides to see which one is required (link to add)

For the Honolulu release we need Helm 3 - A significant improvement with Helm3 is that it does not require a specific pod running in the kubernetes cluster (no more Tiller pod)

As Helm is self contained, it's pretty straightforward to install/upgrade, we can also use snap to install the right version

    .. code-block:: bash

       sudo snap install helm --classic --channel=3.5/stable

Note: You may encounter some log issues when installing helm with snap

Normally the helm logs are available in "~/.local/share/helm/plugins/deploy/cache/onap/logs", if you notice that the log files are all equal to 0, you can uninstall the helm with snap and reinstall it manually

    .. code-block:: bash

       wget https://get.helm.sh/helm-v3.5.4-linux-amd64.tar.gz

       tar xvfz helm-v3.5.4-linux-amd64.tar.gz

       sudo mv linux-amd64/helm /usr/local/bin/helm


Tweak Microk8s
--------------
The below tweaks are not strictly necessary, but they help in making the setup more simple and flexible.

A) Increase the max number of pods & Add priviledged config
As ONAP may deploy a significant amount of pods, we need to inform kubelet to allow more than the basic configuration (as we plan an all in box setup), if you only plan to run a limited number of components, this is not needed

to change the max number of pods, we need to add a parameter to the startup line of kubelet.

1. Edit the file located at :

    .. code-block:: bash

       sudo nano /var/snap/microk8s/current/args/kubelet

add the following line at the end :

--max-pods=250

save the file and restart kubelet to apply the change :

    .. code-block:: bash

       sudo service snap.microk8s.daemon-kubelet restart

2. Edit the file located at :

    .. code-block:: bash

       sudo nano /var/snap/microk8s/current/args/kube-apiserver

add the following line at the end :

--allow-privileged=true

save the file and restart kubelet to apply the change :

    .. code-block:: bash

       sudo service snap.microk8s.daemon-apiserver restart


B) run a local copy of kubectl
Microk8s comes bundled with kubectl, you can interact with it by doing:

    .. code-block:: bash

       sudo microk8s kubectl describe node

to make things simpler as we will most likely interact a lot with kubectl, let's install a local copy of kubectl so we can use it to interact with the kubernetes cluster in a more straightforward way

We need kubectl 1.19 to match the cluster we have installed, let's again use snap to quickly choose and install the one we need

    .. code-block:: bash

       sudo snap install kubectl --classic --channel=1.19/stable

Now we need to provide our local kubectl client with a proper config file so that it can access the cluster, microk8s allows to retrieve the cluster config very easily

Simply create a .kube folder in your home directory and dump the config there

    .. code-block:: bash

       cd
       mkdir .kube
       cd .kube
       sudo microk8s.config > config
       chmod 700 config

the last line is there to avoid helm complaining about too open permission

you should now have helm and kubectl ready to interact with each other, you can verify this by trying :

    .. code-block:: bash

       kubectl version

this should output both the local client and server version

    .. code-block:: bash

       Client Version: version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.7", GitCommit:"1dd5338295409edcfff11505e7bb246f0d325d15", GitTreeState:"clean", BuildDate:"2021-01-13T13:23:52Z", GoVersion:"go1.15.5", Compiler:"gc", Platform:"linux/amd64"}
       Server Version: version.Info{Major:"1", Minor:"19+", GitVersion:"v1.19.7-34+02d22c9f4fb254", GitCommit:"02d22c9f4fb2545422b2b28e2152b1788fc27c2f", GitTreeState:"clean", BuildDate:"2021-02-11T20:13:16Z", GoVersion:"go1.15.8", Compiler:"gc", Platform:"linux/amd64"}


Download OOM repo
-----------------
    .. code-block:: bash

       cd
       git clone "https://gerrit.onap.org/r/oom"


Install the needed Helm plugins
-------------------------------
Onap deployments are using the deploy and undeploy plugins for helm

to install them just run :

    .. code-block:: bash

       helm plugin install ./oom/kubernetes/helm/plugins/undeploy/
       helm plugin install ./oom/kubernetes/helm/plugins/deploy/

       cp -R ~/oom/kubernetes/helm/plugins/ ~/.local/share/helm/plugins

this will copy the plugins into your home directory .helm folder and make them available as helm commands

Another plugin we need is the push plugin, with helm3 there is no more an embedded repo to use.
    .. code-block:: bash

       helm plugin install https://github.com/chartmuseum/helm-push.git --version 0.10.0

Once all plugins are installed, you should see them as available helm commands when doing :

    .. code-block:: bash

       helm --help

Add the helm repo:
    .. code-block:: bash

       helm repo add strimzi https://strimzi.io/charts/

Install the operator:
    .. code-block:: bash

       helm install strimzi-kafka-operator strimzi/strimzi-kafka-operator --namespace strimzi-system --version 0.28.0 --set watchAnyNamespace=true --create-namespace



Install the chartmuseum repository
----------------------------------
Download the chartmuseum script and run it as a background task

    .. code-block:: bash

       curl -LO https://s3.amazonaws.com/chartmuseum/release/latest/bin/linux/amd64/chartmuseum
       chmod +x ./chartmuseum
       mv ./chartmuseum /usr/local/bin
       /usr/local/bin/chartmuseum --port=8080   --storage="local"   --storage-local-rootdir="~/chartstorage" &

you should see the chartmuseum repo starting locally, you can press enter to come back to your terminal

you can now inform helm that a local repo is available for use :

    .. code-block:: bash

       # helm repo add local http://localhost:8080

Tip: If there is an error as below while adding repo local, then remove the repo, update and readd.
Error: repository name (local) already exists, please specify a different name

    .. code-block:: bash

       # helm repo remove local

"local" has been removed from your repositories

    .. code-block:: bash

       # helm repo update

Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈

    .. code-block:: bash

       helm repo add local http://localhost:8080
       2022-09-24T11:43:29.777+0100    INFO    [1] Request served      {"path": "/index.yaml", "comment": "", "clientIP": "127.0.0.1", "method": "GET", "statusCode": 200, "latency": "4.107325ms", "reqID": "bd5d6089-b921-4086-a88a-13bd608a4135"}
       "local" has been added to your repositories


Build all oom charts and store them in the chart repo
-----------------------------------------------------
You should be ready to build all helm charts, go into the oom/kubernetes folder and run a full make

Ensure you have "make" installed:

    .. code-block:: bash

       sudo apt install make

Then build OOM

    .. code-block:: bash

       cd ~/oom/kubernetes
       make all

You can speed up the make skipping the linting of the charts

    .. code-block:: bash

       $cd ./oom/kubernetes
       $make all -e SKIP_LINT=TRUE; make onap -e SKIP_LINT=TRUE

You'll notice quite a few message popping into your terminal running the chartmuseum, showing that it accepts and store the generated charts, that's normal, if you want, just open another terminal to run the helm commands

Once the build completes, you should be ready to deploy ONAP


Fine tune deployment based on your VM capacity and component needs
------------------------------------------------------------------
    .. code-block:: bash

       $cd ./oom/kubernetes
       Edit onap/values.yaml, to include the components to deploy, for this usecase, we set below components to true
       aaf: enabled: true
       policy: enabled: true
       strimzi: enabled: true

Save the file and we are all set to DEPLOY


Deploy/Undeploy charts
----------------------
1) First you need to ensure that the onap namespace exists (it now must be created prior deployment)

    .. code-block:: bash

       kubectl create namespace onap

2) Launch the chart deployment, pay attention to the last parameter, it must point to your override file create above

    .. code-block:: bash

       helm deploy dev local/onap -n onap --create-namespace --set global.masterPassword=test --debug -f ./onap/values.yaml --verbose --debug

You should see all pods starting up and you should be able to see logs using kubectl, dive into containers etc...
    .. code-block:: bash

       kubectl get po
       kubectl get pvc
       kubectl get pv
       kubectl get secrets
       kubectl get cm
       kubectl get svc
       kubectl logs dev-policy-api-7bb656d67f-qqmtk
       kubectl describe dev-policy-api-7bb656d67f-qqmtk
       kubectl exec -it <podname> ifconfig
       kubectl exec -it <podname> pwd
       kubectl exec -it <podname> sh
  
TIP: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
  
TIP: If only policy pods are needed to brought down and bring-up
    .. code-block:: bash

       helm uninstall dev-policy
       make policy -e SKIP_LINT=TRUE
       helm install dev-policy local/policy -n onap --set global.masterPassword=test --debug
 
TIP: If there is an error to bring up "dev-strimzi-entity-operator not found. Retry 60/60"
    .. code-block:: bash

       kubectl -nkube-system get svc/kube-dns

Stop the microk8s cluster with "microk8s stop" command
Edit the kubelet configuration file /var/snap/microk8s/current/args/kubelet and add the following lines: 

--resolv-conf=""
--cluster-dns=<IPAddress>
--cluster-domain=cluster.local

Start the microk8s cluster with "microk8s start" command
Check the status of microk8s cluster with "microk8s status" command

How to undeploy and start fresh
The easiest is to use kubectl, you can clean up the cluster in 3 commands :

    .. code-block:: bash

       kubectl delete namespace onap
       kubectl delete pv --all
       helm undeploy dev
       helm undeploy onap
       kubectl delete pvc --all;kubectl delete pv --all;kubectl delete cm --all;kubectl delete deploy --all;kubectl delete secret --all;kubectl delete jobs --all;kubectl delete pod --all
       rm -rvI /dockerdata-nfs/dev/
       rm -rf ~/.cache/helm/repository/local-*
       rm -rf ~/.cache/helm/repository/policy-11.0.0.tgz
       rm -rf ~/.cache/helm/repository/onap-11.0.0.tgz
       rm -rf  /dockerdata-nfs/*
       helm repo update
       helm repo remove local

don't forget to create the namespace again before deploying again (helm won't complain if it is not there, but you'll end up with an empty cluster after if finishes)

Note : you could also reset the K8S cluster by using the microk8s feature : microk8s reset


Enable communication over Kafka
-------------------------------
Following commands will create a simple custom kafka cluster

    .. code-block:: yaml

       kubectl create namespace kafka

After that we feed Strimzi with a simple Custom Resource, which will then give you a small persistent Apache Kafka Cluster with one node each for Apache Zookeeper and Apache Kafka:

# Apply the `Kafka` Cluster CR file

    .. code-block:: yaml

       kubectl apply -f https://strimzi.io/examples/latest/kafka/kafka-persistent-single.yaml -n kafka 

We now need to wait while Kubernetes starts the required pods, services and so on:


    .. code-block:: yaml

       kubectl wait kafka/my-cluster --for=condition=Ready --timeout=300s -n kafka 

The above command might timeout if you’re downloading images over a slow connection. If that happens you can always run it again.

Once the cluster is running, you can run a simple producer to send messages to a Kafka topic (the topic will be automatically created):


    .. code-block:: yaml

       kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.31.1-kafka-3.2.3 --rm=true --restart=Never -- bin/kafka-console-producer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic

And to receive them in a different terminal you can run:


    .. code-block:: yaml

       kubectl -n kafka run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.31.1-kafka-3.2.3 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic --from-beginning

NOTE: If targeting ONAP based Strimzi Kafka cluster with security certs, Set UseStrimziKafka to true

Policy application properties need to be modified for communication over Kafka
Modify the configuration of Topic properties for the components that need to communicate over kafka

    .. code-block:: yaml

     topicSources:
        -
          topic: policy-acruntime-participant
          servers:
            - localhost:9092
          topicCommInfrastructure: kafka
          fetchTimeout: 15000
          useHttps: true
          additionalProps:
            group-id: policy-group
            key.deserializer: org.apache.kafka.common.serialization.StringDeserializer
            value.deserializer: org.apache.kafka.common.serialization.StringDeserializer
            partition.assignment.strategy: org.apache.kafka.clients.consumer.RoundRobinAssignor
            enable.auto.commit: false
            auto.offset.reset: earliest
            security.protocol: SASL_PLAINTEXT
            properties.sasl.mechanism: SCRAM-SHA-512
            properties.sasl.jaas.config: ${JAASLOGIN}

      topicSinks:
        -
          topic: policy-acruntime-participant
          servers:
            - localhost:9092
          topicCommInfrastructure: kafka
          useHttps: true
          additionalProps:
            key.serializer: org.apache.kafka.common.serialization.StringSerializer
            value.serializer: org.apache.kafka.common.serialization.StringSerializer
            acks: 1
            retry.backoff.ms: 150
            retries: 3
            security.protocol: SASL_PLAINTEXT
            properties.sasl.mechanism: SCRAM-SHA-512
            properties.sasl.jaas.config: ${JAASLOGIN}


Ensure strimzi and policy pods are running, and topics are created with below commands

    .. code-block:: bash

       $ kubectl get kafka -n onap
       NAME          DESIRED KAFKA REPLICAS   DESIRED ZK REPLICAS   READY   WARNINGS
       dev-strimzi   2                        2                     True    True

       $ kubectl get kafkatopics -n onap
       NAME                                                                                               CLUSTER       PARTITIONS   REPLICATION FACTOR   READY
       consumer-offsets---84e7a678d08f4bd226872e5cdd4eb527fadc1c6a                                        dev-strimzi   50           2                    True
       policy-acruntime-participant                                                                       dev-strimzi   10           2                    True
       policy-heartbeat                                                                                   dev-strimzi   10           2                    True
       policy-notification                                                                                dev-strimzi   10           2                    True
       policy-pdp-pap                                                                                     dev-strimzi   10           2                    True
       strimzi-store-topic---effb8e3e057afce1ecf67c3f5d8e4e3ff177fc55                                     dev-strimzi   1            2                    True
       strimzi-topic-operator-kstreams-topic-store-changelog---b75e702040b99be8a9263134de3507fc0cc4017b   dev-strimzi   1            2                    True


Run testsuites
--------------
If you have deployed the robot pod Or have a local robot installation, you can perform some tests using the provided scripts in the oom repo

Browse to the test suite you have started and open the folder, click the report.html to see robot test results
