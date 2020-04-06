.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _apex-PCVSExample:

Policy-controlled Video Streaming (pcvs) with APEX
**************************************************

.. contents::
    :depth: 3

Introduction
^^^^^^^^^^^^

      .. container:: sectionbody

           .. container:: paragraph

                  This module contains several demos for
                  Policy-controlled Video Streaming (PCVS). Each demo
                  defines a policy using AVRO and Javascript (or other
                  scripting languages for the policy logic). To run the
                  demo, a vanilla Ubuntu server with some extra software
                  packages is required:

               .. container:: ulist

                  -  Mininet as network simulator

                  -  Floodlight as SDN controller

                  -  Kafka as messaging system

                  -  Zookeeper for Kafka configuration

                  -  APEX for policy control

Install Ubuntu Server and SW
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

          .. container:: sect1

            .. rubric:: Install Demo
               :name: install_demo

            .. container:: sectionbody

               .. container:: paragraph

                  Requirements:

               .. container:: ulist

                  -  Ubuntu server: 1.4 GB

                  -  Ubuntu with Xubuntu Desktop, git, Firefox: 2.3 GB

                  -  Ubuntu with all, system updated: 3 GB

                  -  With ZK, Kafka, VLC, Mininet, Floodlight, Python:
                     4.4 GB

                  -  APEX Build (M2 and built): M2 ~ 2 GB, APEX ~3.5 GB

                  -  APEX install (not build locally): ~ 300 MB

               .. container:: paragraph

                  On a Ubuntu OS (install a stable or LTS server first)

               .. container:: listingblock

                  .. container:: content

                     ::

                        # pre for Ubuntu, tools and X
                        sudo apt-get  -y install --no-install-recommends software-properties-common
                        sudo apt-get  -y install --no-install-recommends build-essential
                        sudo apt-get  -y install --no-install-recommends git
                        sudo aptitude -y install --no-install-recommends xubuntu-desktop
                        sudo apt-get  -y install --no-install-recommends firefox


                        # install Java
                        sudo add-apt-repository ppa:webupd8team/java
                        sudo apt-get update
                        sudo apt-get -y install --no-install-recommends oracle-java8-installer
                        java -version


                        # reboot system, run system update, then continue

                        # if VBox additions are needed, install and reboot
                        sudo (cd /usr/local/share; wget https://www.virtualbox.org/download/testcase/VBoxGuestAdditions_5.2.7-120528.iso)
                        sudo mount /usr/local/share/VBoxGuestAdditions_5.2.7-120528.iso /media/cdrom
                        sudo (cd /media/cdrom;VBoxLinuxAdditions.run)


                        # update apt-get DB
                        sudo apt-get update

                        # if APEX is build from source, install maven and rpm
                        sudo apt-get install maven rpm

                        # install ZooKeeper
                        sudo apt-get install zookeeperd

                        # install Kafka
                        (cd /tmp;wget http://ftp.heanet.ie/mirrors/www.apache.org/dist/kafka/1.0.0/kafka_2.12-1.0.0.tgz --show-progress)
                        sudo mkdir /opt/Kafka
                        sudo tar -xvf /tmp/kafka_2.12-1.0.0.tgz -C /opt/Kafka/

                        # install mininet
                        cd /usr/local/src
                        sudo git clone https://github.com/mininet/mininet.git
                        (cd mininet;util/install.sh -a)

                        # install floodlight, requires ant
                        sudo apt-get install ant
                        cd /usr/local/src
                        sudo wget --no-check-certificate https://github.com/floodlight/floodlight/archive/master.zip
                        sudo unzip master.zip
                        cd floodlight-master
                        sudo ant
                        sudo mkdir /var/lib/floodlight
                        sudo chmod 777 /var/lib/floodlight

                        # install python pip
                        sudo apt-get install python-pip

                        # install kafka-python (need newer version from github)
                        cd /usr/local/src
                        sudo git clone https://github.com/dpkp/kafka-python
                        sudo pip install ./kafka-python

                        # install vlc
                        sudo apt-get install vlc

               .. container:: paragraph

                  Install APEX either from source or from a distribution
                  package. See the APEX documentation for details. We
                  assume that APEX is installed in
                  ``/opt/ericsson/apex/apex``

               .. container:: paragraph

                  Copy the LinkMonitor file to Kafka-Python

               .. container:: listingblock

                  .. container:: content

                     ::

                        sudo cp /opt/ericsson/apex/apex/examples/scripts/pcvs/vpnsla/LinkMonitor.py /usr/local/src/kafka-python

               .. container:: paragraph

                  Change the Logback configuration in APEX to logic
                  logging

               .. container:: listingblock

                  .. container:: content

                     ::

                        (cd /opt/ericsson/apex/apex/etc; sudo cp logback-logic.xml logback.xml)

         .. container:: sect1

            .. rubric:: Get the Demo Video
               :name: get_the_demo_video

            .. container:: sectionbody

               .. container:: ulist

                  -  For all download options of the movie please visit
                     http://bbb3d.renderfarming.net/download.html

                  -  For lower-res downloads and mirrors see
                     https://peach.blender.org/download

               .. container:: listingblock

                  .. container:: content

                     ::

                        sudo mkdir /usr/local/src/videos

               .. container:: paragraph

                  Standard 720p (recommended)

               .. container:: listingblock

                  .. container:: content

                     ::

                        (cd /usr/local/src/videos; sudo curl -o big_buck_bunny_480p_surround.avi http://download.blender.org/peach/bigbuckbunny_movies/big_buck_bunny_480p_surround-fix.avi)

               .. container:: paragraph

                  Full HD video

               .. container:: listingblock

                  .. container:: content

                     ::

                        (cd videos; sudo curl -o bbb_sunflower_1080p_60fps_normal.mp4 http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_60fps_normal.mp4)



VPN SLA Demo
^^^^^^^^^^^^^

          .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  This demo uses a network with several central office
                  and core switches, over which two VPNs are run. A
                  customer ``A`` has two location ``A1`` and ``A2`` and
                  a VPN between them. A customer ``B`` has two location
                  ``B1`` and ``B2`` and a VPN between them.

               .. container:: imageblock

                  .. container:: content

                     |VPN SLA Architecture|

               .. container:: paragraph

                  The architecture above shows the scenario. The
                  components are realized in this demo as follows:

               .. container:: ulist

                  -  *CEP / Analytics* - a simple Python script taking
                     events from Kafka and sending them to APEX

                  -  *APEX / Policy* - the APEX engine running the VPA
                     SLA policy

                  -  *Controller* - A vanilla Floodlight controller
                     taking events from the Link Monitor and configuring
                     Mininet

                  -  *Network* - A network created using Mininet

               .. container:: paragraph

                  The demo requires to start some software (detailed
                  below). To show actual video streams, we use ``VLC``.
                  If you do not want to show video streams, but only the
                  policy, skip the ``VLC`` section.

               .. container:: paragraph

                  All shown scripts are available in a full APEX
                  installation in
                  ``$APEX_HOME/examples/scripts/pcvs/vpnsla``.

               .. container:: sect2

                  .. rubric:: Start all Software
                     :name: start_all_software

                  .. container:: paragraph

                     Create environment variables in a file, say
                     ``env.sh``. In each new Xterm

                  .. container:: ulist

                     -  Source these environment settings, e.g.
                        ``. ./env.sh``

                     -  Run the commands below as root (``sudo`` per
                        command or ``sudo -i`` for interactive mode as
                        shown below)

                  .. container:: listingblock

                     .. container:: content

                        ::

                           #!/usr/bin/env bash

                           export src_dir=/usr/local/src
                           export APEX_HOME=/opt/ericsson/apex/apex
                           export APEX_USER=apexuser

                  .. container:: paragraph

                     In a new Xterm, start Floodlight

                  .. container:: listingblock

                     .. container:: content

                        ::

                           sudo -i
                           . ./env.sh
                           cd $src_dir/floodlight-master && java -jar target/floodlight.jar

                  .. container:: paragraph

                     In a new Xterm start Mininet

                  .. container:: listingblock

                     .. container:: content

                        ::

                           sudo -i
                           . ./env.sh
                           mn -c && python $APEX_HOME/examples/scripts/pcvs/vpnsla/MininetTopology.py

                  .. container:: paragraph

                     In a new Xterm, start Kafka

                  .. container:: listingblock

                     .. container:: content

                        ::

                           sudo -i
                           . ./env.sh
                           /opt/Kafka/kafka_2.12-1.0.0/bin/kafka-server-start.sh /opt/Kafka/kafka_2.12-1.0.0/config/server.properties

                  .. container:: paragraph

                     In a new Xerm start APEX with the Kafka
                     configuration for this demo

                  .. container:: listingblock

                     .. container:: content

                        ::

                           cd $APEX_HOME
                           ./bin/apexApps.sh engine -c examples/config/pcvs/vpnsla/kafka2kafka.json

                  .. container:: paragraph

                     In a new Xterm start the Link Monitor. The Link
                     Monitor has a 30 second sleep to slow down the
                     demonstration. So the first action of it comes 30
                     seconds after start. Every new action in 30 second
                     intervals.

                  .. container:: listingblock

                     .. container:: content

                        ::

                           sudo -i
                           . ./env.sh
                           cd $src_dir
                           xterm -hold -e 'python3 $src_dir/kafka-python/LinkMonitor.py' &

                  .. container:: paragraph

                     Now all software should be started and the demo is
                     running. The Link Monitor will send link up events,
                     picked up by APEX which triggers the policy. Since
                     there is no problem, the policy will do nothing.

               .. container:: sect2

                  .. rubric:: Create 2 Video Streams with VLC
                     :name: create_2_video_streams_with_vlc

                  .. container:: paragraph

                     In the Mininet console, type ``xterm A1 A2`` and
                     ``xterm B1 B2`` to open terminals on these nodes.

                  .. container:: paragraph

                     ``A2`` and ``B2`` are the receiving nodes. In these
                     terminals, run ``vlc-wrapper``. In each opened VLC
                     window do

                  .. container:: ulist

                     -  Click Media → Open Network Stream

                     -  Give the URL as ``rtp://@:5004``

                  .. container:: paragraph

                     ``A1`` and ``B1`` are the sending nodes (sending
                     the video stream) In these terminals, run
                     ``vlc-wrapper``. In each opened VLC window do

                  .. container:: ulist

                     -  Click Media → Stream

                     -  Add the video (from ``/usr/local/src/videos``)

                     -  Click ``Stream``

                     -  Click ``Next``

                     -  Change the destination
                        ``RTP / MPEG Transport Stream`` and click
                        ``Add``

                     -  Change the address and type to ``10.0.0.2`` in
                        ``A1`` and to ``10.0.0.4`` in ``B1``

                     -  Turn off ``Active Transcoding`` (this is
                        important to minimize CPU load)

                     -  Click ``Next``

                     -  Click ``Stream``

                  .. container:: paragraph

                     The video should be streaming across the network
                     from ``A1`` to ``A2`` and from ``B1`` to ``B2``. If
                     the video streams a slow or interrupted the CPU
                     load is too high. In these cases either try a
                     better machine or use a different (lower quality)
                     video stream.

               .. container:: sect2

                  .. rubric:: Take out L09 and let the Policy do it’s
                     Magic
                     :name: take_out_l09_and_let_the_policy_do_it_s_magic

                  .. container:: paragraph

                     Now it is time to take out the link ``L09``. This
                     will be picked up by the Link Monitor, which sends
                     a new event (L09 DOWN) to the policy. The policy
                     then will calculate which customer should be
                     impeded (throttled). This will continue, until SLAs
                     are violated, then a priority calculation will kick
                     in (Customer ``A`` is prioritized in the setup).

                  .. container:: paragraph

                     To initiate this, simply type ``link s5 s6 down``
                     in the Mininet console followed by ``exit``.

                  .. container:: paragraph

                     If you have the video streams running, you will see
                     one or the other struggeling, depending on the
                     policy decision.

               .. container:: sect2

                  .. rubric:: Reset the Demo
                     :name: reset_the_demo

                  .. container:: paragraph

                     If you want to reset the demo, simple stop (in this
                     order) the following process

                  .. container:: ulist

                     -  Link Monitor

                     -  APEX

                     -  Mininet

                     -  Floodlight

                  .. container:: paragraph

                     Then restart them in this order

                  .. container:: ulist

                     -  Floodlight

                     -  Mininet

                     -  APEX

                     -  Link Monitor

               .. container:: sect2

                  .. rubric:: Monitor the Demo
                     :name: monitor_the_demo

                  .. container:: paragraph

                     Floodlight and APEX provide REST interfaces for
                     monitoring.

                  .. container:: ulist

                     -  Floodlight: see `Floodlight
                        Docs <https://floodlight.atlassian.net/wiki/spaces/floodlightcontroller/pages/40403023/Web+GUI>`__
                        for details on how to access the monitoring. In
                        a standard installation as we use here, pointing
                        browser to the URL
                        ``http://localhost:8080/ui/pages/index.html``
                        should work on the same host

                     -  APEX please see the APEX documentation for
                        `Monitoring
                        Client <https://ericsson.github.io/apex-docs/user-manual/engine-apps/um-engapps-eng-monitoring.html>`__
                        or `Full
                        Client <https://ericsson.github.io/apex-docs/user-manual/engine-apps/um-engapps-full-client.html>`__
                        for details on how to monitor APEX.


VPN SLA Policy
^^^^^^^^^^^^^^

            .. container:: sectionbody

               .. container:: paragraph

                  The VPN SLA policy is designed as a MEDA policy. The
                  first state (M = Match) takes the trigger event (a
                  link up or down) and checks if this is a change to the
                  known topology. The second state (E = Establish) takes
                  all available information (trigger event, local
                  context) and defines what situation we have. The third
                  state (D = Decide) takes the situation and selects
                  which algorithm is best to process it. This state can
                  select between ``none`` (nothing to do), ``solved`` (a
                  problem is solved now), ``sla`` (compare the current
                  customer SLA situation and select one to impede), and
                  ``priority`` (impede non-priority customers). The
                  fourth and final state (A = Act) selects the right
                  action for the taken decision and creates the response
                  event sent to the orchestrator.

               .. container:: paragraph

                  We have added three more policies to set the local
                  context: one for adding nodes, one for adding edges
                  (links), and one for adding customers. These policies
                  do not realize any action, they are only here for
                  updating the local context. This mechanism is the
                  fasted way to update local context, and it is
                  independent of any context plugin.

               .. container:: paragraph

                  The policy uses data defined in Avro, so we have a
                  number of Avro schema definitions.

Context Schemas
---------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  The context schemas are for the local context. We
                  model edges and nodes for the topology, customers, and
                  problems with all information on detected problems.

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        {
                            "type" : "record",
                            "name" : "TopologyEdges",
                            "fields" : [
                                {"name": "name",   "type": "string",  "doc": "Name of the Edge, typically a link name"},
                                {"name": "start",  "type": "string",  "doc": "Edge endpoint: start - a node name"},
                                {"name": "end",    "type": "string",  "doc": "Edge endpoint: end - a node name"},
                                {"name": "active", "type": "boolean", "doc": "Flag for active/inactive edges, inactive means a link is down"}
                            ]
                        }

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        {
                            "type" : "record",
                            "name" : "TopologyNodes",
                            "fields" : [
                                {"name" : "name",   "type" : "string", "doc": "The name of the node"},
                                {"name" : "mnname", "type" : "string", "doc": "The name of the node in Mininet"}
                            ]
                        }

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        {
                            "type" : "record",
                            "name" : "Customer",
                            "fields" : [
                                {"name" : "customerName", "type" : "string"},
                                {"name" : "dtSLA"       , "type" : "int"},
                                {"name" : "dtYTD"       , "type" : "int"},
                                {"name" : "priority"    , "type" : "boolean"},
                                {"name" : "satisfaction", "type" : "int"},
                                {
                                    "name": "links",
                                    "doc": "Links used by this customer",
                                    "type": {"type"  : "array", "items" : "string"}
                                }
                            ]
                        }


Trigger Schemas
---------------

        .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  The trigger event provides a status as ``UP`` or
                  ``DOWN``. To avoid tests for these strings in the
                  logic, we defined an Avro schema for an enumeration.
                  This does not impact the trigger system (it can still
                  send the strings), but makes the task logic simpler.

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        {
                            "type": "enum",
                            "name": "Status",
                            "symbols" : [
                                "UP",
                                "DOWN"
                            ]
                        }

Context Logic Nodes
--------------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  The node context logic simply takes the trigger event
                  (for context) and creates a new node in the local
                  context topology.

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        /*
                         * ============LICENSE_START=======================================================
                         *  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                         * ================================================================================
                         * Licensed under the Apache License, Version 2.0 (the "License");
                         * you may not use this file except in compliance with the License.
                         * You may obtain a copy of the License at
                         *
                         *      http://www.apache.org/licenses/LICENSE-2.0
                         *
                         * Unless required by applicable law or agreed to in writing, software
                         * distributed under the License is distributed on an "AS IS" BASIS,
                         * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                         * See the License for the specific language governing permissions and
                         * limitations under the License.
                         *
                         * SPDX-License-Identifier: Apache-2.0
                         * ============LICENSE_END=========================================================
                         */

                        load("nashorn:mozilla_compat.js");

                        var logger = executor.logger;
                        logger.trace("start: " + executor.subject.id);
                        logger.trace("-- infields: " + executor.inFields);

                        var ifNodeName = executor.inFields["nodeName"];
                        var ifMininetName = executor.inFields["mininetName"];

                        var albumTopoNodes = executor.getContextAlbum("albumTopoNodes");

                        logger.trace("-- got infields, testing existing node");

                        var ctxtNode = albumTopoNodes.get(ifNodeName);
                        if (ctxtNode != null) {
                            albumTopoNodes.remove(ifNodeName);
                            logger.trace("-- removed node: <" + ifNodeName + ">");
                        }

                        logger.trace("-- creating node: <" + ifNodeName + ">");
                        ctxtNode = "{name:" + ifNodeName + ", mnname:" + ifMininetName + "}";
                        albumTopoNodes.put(ifNodeName, ctxtNode);

                        if (logger.isTraceEnabled()) {
                            logger.trace("   >> *** Nodes ***");
                            if (albumTopoNodes != null) {
                                for (var i = 0; i < albumTopoNodes.values().size(); i++) {
                                    logger.trace("   >> >> " + albumTopoNodes.values().get(i).get("name") + " : "
                                            + albumTopoNodes.values().get(i).get("mnname"));
                                }
                            } else {
                                logger.trace("   >> >> node album is null");
                            }
                        }

                        executor.outFields["report"] = "node ctxt :: added node " + ifNodeName;

                        logger.info("vpnsla: ctxt added node " + ifNodeName);

                        var returnValueType = Java.type("java.lang.Boolean");
                        var returnValue = new returnValueType(true);
                        logger.trace("finished: " + executor.subject.id);
                        logger.debug(".");

Context Logic Edges
--------------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  The edge context logic simply takes the trigger event
                  (for context) and creates a new edge in the local
                  context topology.

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        /*
                         * ============LICENSE_START=======================================================
                         *  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                         * ================================================================================
                         * Licensed under the Apache License, Version 2.0 (the "License");
                         * you may not use this file except in compliance with the License.
                         * You may obtain a copy of the License at
                         *
                         *      http://www.apache.org/licenses/LICENSE-2.0
                         *
                         * Unless required by applicable law or agreed to in writing, software
                         * distributed under the License is distributed on an "AS IS" BASIS,
                         * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                         * See the License for the specific language governing permissions and
                         * limitations under the License.
                         *
                         * SPDX-License-Identifier: Apache-2.0
                         * ============LICENSE_END=========================================================
                         */

                        load("nashorn:mozilla_compat.js");

                        var logger = executor.logger;
                        logger.trace("start: " + executor.subject.id);
                        logger.trace("-- infields: " + executor.inFields);

                        var ifEdgeName = executor.inFields["edgeName"];
                        var ifEdgeStatus = executor.inFields["status"];

                        var albumTopoEdges = executor.getContextAlbum("albumTopoEdges");

                        logger.trace("-- got infields, testing existing edge");

                        var ctxtEdge = albumTopoEdges.get(ifEdgeName);
                        if (ctxtEdge != null) {
                            albumTopoEdges.remove(ifEdgeName);
                            logger.trace("-- removed edge: <" + ifEdgeName + ">");
                        }

                        logger.trace("-- creating edge: <" + ifEdgeName + ">");
                        ctxtEdge = "{name:" + ifEdgeName + ", start:" + executor.inFields["start"] + ", end:" + executor.inFields["end"]
                                + ", active:" + ifEdgeStatus + "}";
                        albumTopoEdges.put(ifEdgeName, ctxtEdge);

                        if (logger.isTraceEnabled()) {
                            logger.trace("   >> *** Edges ***");
                            if (albumTopoEdges != null) {
                                for (var i = 0; i < albumTopoEdges.values().size(); i++) {
                                    logger.trace("   >> >> " + albumTopoEdges.values().get(i).get("name") + " \t "
                                            + albumTopoEdges.values().get(i).get("start") + " --> " + albumTopoEdges.values().get(i).get("end")
                                            + " \t " + albumTopoEdges.values().get(i).get("active"));
                                }
                            } else {
                                logger.trace("   >> >> edge album is null");
                            }
                        }

                        executor.outFields["report"] = "edge ctxt :: added edge " + ifEdgeName;

                        logger.info("vpnsla: ctxt added edge " + ifEdgeName);

                        var returnValueType = Java.type("java.lang.Boolean");
                        var returnValue = new returnValueType(true);
                        logger.trace("finished: " + executor.subject.id);
                        logger.debug(".");

Context Logic Customer
----------------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  The customer context logic simply takes the trigger
                  event (for context) and creates a new customer in the
                  local context topology.

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        /*
                         * ============LICENSE_START=======================================================
                         *  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                         * ================================================================================
                         * Licensed under the Apache License, Version 2.0 (the "License");
                         * you may not use this file except in compliance with the License.
                         * You may obtain a copy of the License at
                         *
                         *      http://www.apache.org/licenses/LICENSE-2.0
                         *
                         * Unless required by applicable law or agreed to in writing, software
                         * distributed under the License is distributed on an "AS IS" BASIS,
                         * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                         * See the License for the specific language governing permissions and
                         * limitations under the License.
                         *
                         * SPDX-License-Identifier: Apache-2.0
                         * ============LICENSE_END=========================================================
                         */

                        load("nashorn:mozilla_compat.js");

                        var logger = executor.logger;
                        logger.trace("start: " + executor.subject.id);
                        logger.trace("-- infields: " + executor.inFields);

                        var ifCustomerName = executor.inFields["customerName"];
                        var ifLinks = executor.inFields["links"];

                        logger.trace("-- got infields, testing existing customer");
                        var ctxtCustomer = executor.getContextAlbum("albumCustomerMap").get(ifCustomerName);
                        if (ctxtCustomer != null) {
                            executor.getContextAlbum("albumCustomerMap").remove(ifCustomerName);
                            logger.trace("-- removed customer: <" + ifCustomerName + ">");
                        }

                        logger.trace("-- creating customer: <" + ifCustomerName + ">");
                        var links = new Array();
                        for (var i = 0; i < ifLinks.split(" ").length; i++) {
                            var link = executor.getContextAlbum("albumTopoEdges").get(ifLinks.split(" ")[i]);
                            if (link != null) {
                                logger.trace("-- link: <" + ifLinks.split(" ")[i] + ">");
                                links.push(ifLinks.split(" ")[i]);
                            } else {
                                logger.trace("-- unknown link: <" + ifLinks.split(" ")[i] + "> for customer <" + ifCustomerName + ">");
                            }
                        }
                        logger.trace("-- links: <" + links + ">");
                        ctxtCustomer = "{customerName:" + ifCustomerName + ", dtSLA:" + executor.inFields["dtSLA"] + ", dtYTD:"
                                + executor.inFields["dtYTD"] + ", priority:" + executor.inFields["priority"] + ", satisfaction:"
                                + executor.inFields["satisfaction"] + ", links:[" + links + "]}";

                        executor.getContextAlbum("albumCustomerMap").put(ifCustomerName, ctxtCustomer);

                        if (logger.isTraceEnabled()) {
                            logger.trace("   >> *** Customers ***");
                            if (executor.getContextAlbum("albumCustomerMap") != null) {
                                for (var i = 0; i < executor.getContextAlbum("albumCustomerMap").values().size(); i++) {
                                    logger.trace("   >> >> " + executor.getContextAlbum("albumCustomerMap").values().get(i).get("customerName")
                                            + " : " + "dtSLA=" + executor.getContextAlbum("albumCustomerMap").values().get(i).get("dtSLA")
                                            + " : " + "dtYTD=" + executor.getContextAlbum("albumCustomerMap").values().get(i).get("dtYTD")
                                            + " : " + "links=" + executor.getContextAlbum("albumCustomerMap").values().get(i).get("links")
                                            + " : " + "priority="
                                            + executor.getContextAlbum("albumCustomerMap").values().get(i).get("priority") + " : "
                                            + "satisfaction="
                                            + executor.getContextAlbum("albumCustomerMap").values().get(i).get("satisfaction"));
                                }
                            } else {
                                logger.trace("   >> >> customer album is null");
                            }
                        }

                        executor.outFields["report"] = "customer ctxt :: added customer: " + ifCustomerName;

                        logger.info("vpnsla: ctxt added customer " + ifCustomerName);

                        var returnValueType = Java.type("java.lang.Boolean");
                        var returnValue = new returnValueType(true);
                        logger.trace("finished: " + executor.subject.id);
                        logger.debug(".");

Logic: Match
------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  This is the logic for the match state. It is kept very
                  simple. Beside taking the trigger event, it also
                  creates a timestamp. This timestamp is later used for
                  SLA and downtime calculations as well as for some
                  performance information of the policy.

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        /*
                         * ============LICENSE_START=======================================================
                         *  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                         * ================================================================================
                         * Licensed under the Apache License, Version 2.0 (the "License");
                         * you may not use this file except in compliance with the License.
                         * You may obtain a copy of the License at
                         *
                         *      http://www.apache.org/licenses/LICENSE-2.0
                         *
                         * Unless required by applicable law or agreed to in writing, software
                         * distributed under the License is distributed on an "AS IS" BASIS,
                         * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                         * See the License for the specific language governing permissions and
                         * limitations under the License.
                         *
                         * SPDX-License-Identifier: Apache-2.0
                         * ============LICENSE_END=========================================================
                         */

                        load("nashorn:mozilla_compat.js");

                        var now = new Date().getTime();
                        executor.outFields["matchStart"] = now;

                        importClass(org.slf4j.LoggerFactory);

                        var logger = executor.logger;
                        logger.trace("start: " + executor.subject.id);
                        logger.trace("-- infields: " + executor.inFields);

                        var rootLogger = LoggerFactory.getLogger(logger.ROOT_LOGGER_NAME);

                        var ifEdgeName = executor.inFields["edgeName"];
                        var ifLinkStatus = executor.inFields["status"];

                        var albumTopoEdges = executor.getContextAlbum("albumTopoEdges");

                        logger.trace("-- got infields, checking albumTopoEdges changes");

                        var active = false;
                        switch (ifLinkStatus.toString()) {
                        case "UP":
                            active = true;
                            break;
                        case "DOWN":
                            active = false;
                            break;
                        default:
                            active = false;
                            logger.error("-- trigger sent unknown link status <" + ifLinkStatus + "> for link <" + ifEdgeName + ">");
                            rootLogger.error(executor.subject.id + " " + "-- trigger sent unknown link status <" + ifLinkStatus
                                    + "> for link <" + ifEdgeName + ">");
                        }

                        var link = albumTopoEdges.get(ifEdgeName);
                        if (link == null) {
                            logger.trace("-- link <" + ifEdgeName + "> not in albumTopoEdges");
                        } else {
                            logger.trace("-- found link <" + link + "> in albumTopoEdges");
                            logger.trace("-- active <" + active + "> : link.active <" + link.get("active") + ">");
                            if (active != link.get("active")) {
                                link.put("active", active);
                                logger.trace("-- link <" + ifEdgeName + "> status changed to <active:" + link.get("active") + ">");
                                executor.outFields["hasChanged"] = true;
                            } else {
                                logger.trace("-- link <" + ifEdgeName + "> status not changed <active:" + link.get("active") + ">");
                                executor.outFields["hasChanged"] = false;
                            }
                        }

                        executor.outFields["edgeName"] = ifEdgeName;
                        executor.outFields["status"] = ifLinkStatus;

                        logger.info("vpnsla: detected " + ifEdgeName + " as " + ifLinkStatus);

                        var returnValueType = Java.type("java.lang.Boolean");
                        var returnValue = new returnValueType(true);
                        logger.trace("finished: " + executor.subject.id);
                        logger.debug(".m");


Logic: Policy Establish State
-----------------------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  This is the logic for the establish state. It is the
                  most complicated logic, since establishing a situation
                  for a decision is the most important part of any
                  policy. First, the policy describes what we find (the
                  switch block), in terms of 8 normal situations and 1
                  extreme error case.

               .. container:: paragraph

                  If required, it creates local context information for
                  the problem (if it is new) or updates it (if the
                  problem still exists). It also calculates customer SLA
                  downtime and checks for any SLA violations. Finally,
                  it creates a situation object.

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        /*
                         * ============LICENSE_START=======================================================
                         *  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                         * ================================================================================
                         * Licensed under the Apache License, Version 2.0 (the "License");
                         * you may not use this file except in compliance with the License.
                         * You may obtain a copy of the License at
                         *
                         *      http://www.apache.org/licenses/LICENSE-2.0
                         *
                         * Unless required by applicable law or agreed to in writing, software
                         * distributed under the License is distributed on an "AS IS" BASIS,
                         * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                         * See the License for the specific language governing permissions and
                         * limitations under the License.
                         *
                         * SPDX-License-Identifier: Apache-2.0
                         * ============LICENSE_END=========================================================
                         */

                        load("nashorn:mozilla_compat.js");
                        importClass(org.slf4j.LoggerFactory);

                        importClass(java.util.ArrayList);

                        importClass(org.apache.avro.generic.GenericData.Array);
                        importClass(org.apache.avro.generic.GenericRecord);
                        importClass(org.apache.avro.Schema);

                        var logger = executor.logger;
                        logger.trace("start: " + executor.subject.id);
                        logger.trace("-- infields: " + executor.inFields);

                        var rootLogger = LoggerFactory.getLogger(logger.ROOT_LOGGER_NAME);

                        var ifEdgeName = executor.inFields["edgeName"];
                        var ifEdgeStatus = executor.inFields["status"].toString();
                        var ifhasChanged = executor.inFields["hasChanged"];
                        var ifMatchStart = executor.inFields["matchStart"];

                        var albumCustomerMap = executor.getContextAlbum("albumCustomerMap");
                        var albumProblemMap = executor.getContextAlbum("albumProblemMap");

                        var linkProblem = albumProblemMap.get(ifEdgeName);

                        // create outfiled for situation
                        var situation = executor.subject.getOutFieldSchemaHelper("situation").createNewInstance();
                        situation.put("violatedSLAs", new ArrayList());

                        // create a string as states+hasChanged+linkProblem and switch over it
                        var switchTest = ifEdgeStatus + ":" + ifhasChanged + ":" + (linkProblem == null ? "no" : "yes");
                        switch (switchTest) {
                        case "UP:false:no":
                            logger.trace("-- edge <" + ifEdgeName + "> UP:false:no => everything ok");
                            logger.info("vpnsla: everything ok");
                            situation.put("problemID", "NONE");
                            break;
                        case "UP:false:yes":
                            logger.trace("-- edge <" + ifEdgeName + "> UP:false:yes ==> did we miss earlier up?, removing problem");
                            albumProblemMap.remove(ifEdgeName);
                            linkProblem = null;
                            situation.put("problemID", "NONE");
                            break;
                        case "UP:true:no":
                            logger.trace("-- edge <" + ifEdgeName + "> UP:true:no ==> did we miss the earlier down?, creating new problem");
                            situation.put("problemID", ifEdgeName);
                            break;
                        case "UP:true:yes":
                            logger.trace("-- edge <" + ifEdgeName + "> UP:true:yes ==> detected solution, link up again");
                            logger.info("vpnsla: problem solved");
                            linkProblem.put("endTime", ifMatchStart);
                            linkProblem.put("status", "SOLVED");
                            situation.put("problemID", "NONE");
                            break;
                        case "DOWN:false:no":
                            logger.trace("-- edge <" + ifEdgeName + "> DOWN:false:no ==> did we miss an earlier down?, creating new problem");
                            situation.put("problemID", ifEdgeName);
                            break;
                        case "DOWN:false:yes":
                            logger.trace("-- edge <" + ifEdgeName + "> DOWN:false:yes ==> problem STILL exists");
                            logger.info("vpnsla: problem still exists");
                            linkProblem.put("status", "STILL");
                            situation.put("problemID", ifEdgeName);
                            break;
                        case "DOWN:true:no":
                            logger.trace("-- edge <" + ifEdgeName + "> DOWN:true:no ==> found NEW problem");
                            logger.info("vpnsla: this is a new problem");
                            situation.put("problemID", ifEdgeName);
                            break;
                        case "DOWN:true:yes":
                            logger.trace("-- edge <" + ifEdgeName
                                    + "> DOWN:true:yes ==> did we miss to remove an earlier problem?, remove and create new problem");
                            linkProblem = null;
                            situation.put("problemID", ifEdgeName);
                            break;

                        default:
                            logger.error("-- input wrong for edge" + ifEdgeName + ": edge status <" + ifEdgeStatus
                                    + "> unknown or null on hasChanged <" + ifhasChanged + ">");
                            rootLogger.error("-- input wrong for edge" + ifEdgeName + ": edge status <" + ifEdgeStatus
                                    + "> unknown or null on hasChanged <" + ifhasChanged + ">");
                        }

                        // create new problem if situation requires it
                        if (situation.get("problemID").equals(ifEdgeName) && linkProblem == null) {
                            logger.trace("-- edge <" + ifEdgeName + "> creating new problem");
                            linkProblem = albumProblemMap.getSchemaHelper().createNewInstance();
                            linkProblem.put("edge", ifEdgeName);
                            linkProblem.put("startTime", ifMatchStart);
                            linkProblem.put("lastUpdate", ifMatchStart);
                            linkProblem.put("endTime", 0);
                            linkProblem.put("status", "NEW");
                            linkProblem.put("edgeUsedBy", new ArrayList());
                            linkProblem.put("impededLast", new ArrayList());

                            for (var i = 0; i < albumCustomerMap.values().size(); i++) {
                                var customer = albumCustomerMap.values().get(i);
                                var customerLinks = albumCustomerMap.values().get(i).get("links");
                                for (var k = 0; k < customerLinks.size(); k++) {
                                    if (customerLinks.get(k) == ifEdgeName) {
                                        linkProblem.get("edgeUsedBy").add(customer.get("customerName"));
                                    }
                                }
                            }
                            albumProblemMap.put(ifEdgeName, linkProblem);
                            logger.trace("-- edge <" + ifEdgeName + "> problem created as <" + linkProblem + ">");
                        }

                        // set dtYTD if situation requires it
                        if (linkProblem != null && (linkProblem.get("status") == "STILL" || linkProblem.get("status") == "SOLVED")) {
                            var linkDownTimeinSecs = (ifMatchStart - linkProblem.get("lastUpdate")) / 1000;
                            logger.trace("-- edge <" + ifEdgeName + "> down time: " + linkDownTimeinSecs + " s");
                            for (var k = 0; k < linkProblem.get("impededLast").size(); k++) {
                                for (var i = 0; i < albumCustomerMap.values().size(); i++) {
                                    var customer = albumCustomerMap.values().get(i);
                                    if (customer.get("customerName").equals(linkProblem.get("impededLast").get(k))) {
                                        logger.info("-- vpnsla: customer " + customer.get("customerName") + " YDT downtime increased from "
                                                + customer.get("dtYTD") + " to " + (customer.get("dtYTD") + linkDownTimeinSecs));
                                        customer.put("dtYTD", (customer.get("dtYTD") + linkDownTimeinSecs))
                                    }
                                }
                            }
                            // set lastUpdate to this policy execution for next execution calculation
                            linkProblem.put("lastUpdate", ifMatchStart);
                        }

                        // check SLA violations if situation requires it
                        if (linkProblem != null && linkProblem.get("status") != "SOLVED") {
                            logger.info(">e> customer\tDT SLA\tDT YTD\tviolation");
                            for (var i = 0; i < albumCustomerMap.values().size(); i++) {
                                var customer = albumCustomerMap.values().get(i);
                                if (customer.get("dtYTD") > customer.get("dtSLA")) {
                                    situation.get("violatedSLAs").add(customer.get("customerName"));
                                    logger.info(">e> " + customer.get("customerName") + "\t\t" + customer.get("dtSLA") + "s\t"
                                            + customer.get("dtYTD") + "s\t" + "!!");
                                } else {
                                    logger.info(">e> " + customer.get("customerName") + "\t\t" + customer.get("dtSLA") + "s\t"
                                            + customer.get("dtYTD") + "s");
                                }
                            }
                        }

                        executor.outFields["situation"] = situation;

                        logger.trace("-- out fields <" + executor.outFields + ">");

                        var returnValueType = Java.type("java.lang.Boolean");
                        var returnValue = new returnValueType(true);
                        logger.trace("finished: " + executor.subject.id);
                        logger.debug(".e");

Logic: Policy Decide State
--------------------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  The decide state can select between different
                  algorithms depending on the situation. So it needs a
                  Task Selection Logic (TSL). This TSL select a task in
                  the current policy execution (i.e. potentially a
                  different one per execution).

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        /*
                         * ============LICENSE_START=======================================================
                         *  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                         * ================================================================================
                         * Licensed under the Apache License, Version 2.0 (the "License");
                         * you may not use this file except in compliance with the License.
                         * You may obtain a copy of the License at
                         *
                         *      http://www.apache.org/licenses/LICENSE-2.0
                         *
                         * Unless required by applicable law or agreed to in writing, software
                         * distributed under the License is distributed on an "AS IS" BASIS,
                         * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                         * See the License for the specific language governing permissions and
                         * limitations under the License.
                         *
                         * SPDX-License-Identifier: Apache-2.0
                         * ============LICENSE_END=========================================================
                         */

                        load("nashorn:mozilla_compat.js");
                        importClass(org.slf4j.LoggerFactory);

                        var logger = executor.logger;
                        logger.trace("start: " + executor.subject.id + " - TSL");

                        var rootLogger = LoggerFactory.getLogger(logger.ROOT_LOGGER_NAME);

                        var ifSituation = executor.inFields["situation"];

                        var albumProblemMap = executor.getContextAlbum("albumProblemMap");

                        var returnValueType = Java.type("java.lang.Boolean");
                        if (ifSituation.get("problemID") == "NONE") {
                            logger.trace("-- situation has no problem, selecting <VpnSlaPolicyDecideNoneTask>");
                            executor.subject.getTaskKey("VpnSlaPolicyDecideNoneTask").copyTo(executor.selectedTask);
                            var returnValue = new returnValueType(true);
                        } else if (albumProblemMap.get(ifSituation.get("problemID")).get("status") == "SOLVED") {
                            logger.trace("-- situation is solved, selecting <VpnSlaPolicyDecideSolvedTask>");
                            executor.subject.getTaskKey("VpnSlaPolicyDecideSolvedTask").copyTo(executor.selectedTask);
                            var returnValue = new returnValueType(true);
                        } else if (ifSituation.get("violatedSLAs") != null && ifSituation.get("violatedSLAs").size() > 0) {
                            logger.trace("-- situation is problem with violations, selecting <VpnSlaPolicyDecidePriorityTask>");
                            executor.subject.getTaskKey("VpnSlaPolicyDecidePriorityTask").copyTo(executor.selectedTask);
                            var returnValue = new returnValueType(true);
                        } else if (ifSituation.get("violatedSLAs") != null && ifSituation.get("violatedSLAs").size() == 0) {
                            logger.trace("-- situation is problem without violations, selecting <VpnSlaPolicyDecideSlaTask>");
                            executor.subject.getTaskKey("VpnSlaPolicyDecideSlaTask").copyTo(executor.selectedTask);
                            var returnValue = new returnValueType(true);
                        } else {
                            logger.error("-- detected unknown decision for situation <" + ifSituation.get("problemID") + ">");
                            rootLogger.error(executor.subject.id + " " + "-- detected unknown decision for situation <"
                                    + ifSituation.get("problemID") + ">");
                            var returnValue = new returnValueType(false);
                        }

                        logger.trace("finished: " + executor.subject.id);
                        logger.debug(".d-tsl");

               .. container:: paragraph

                  The actual task logic are then ``none``, ``solved``,
                  ``sla``, and ``priority``.

Logic: Decide None
-------------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        /*
                         * ============LICENSE_START=======================================================
                         *  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                         * ================================================================================
                         * Licensed under the Apache License, Version 2.0 (the "License");
                         * you may not use this file except in compliance with the License.
                         * You may obtain a copy of the License at
                         *
                         *      http://www.apache.org/licenses/LICENSE-2.0
                         *
                         * Unless required by applicable law or agreed to in writing, software
                         * distributed under the License is distributed on an "AS IS" BASIS,
                         * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                         * See the License for the specific language governing permissions and
                         * limitations under the License.
                         *
                         * SPDX-License-Identifier: Apache-2.0
                         * ============LICENSE_END=========================================================
                         */

                        load("nashorn:mozilla_compat.js");
                        importClass(org.slf4j.LoggerFactory);

                        importClass(java.util.ArrayList);

                        importClass(org.apache.avro.generic.GenericData.Array);
                        importClass(org.apache.avro.generic.GenericRecord);
                        importClass(org.apache.avro.Schema);

                        var logger = executor.logger;
                        logger.trace("start: " + executor.subject.id);
                        logger.trace("-- infields: " + executor.inFields);

                        var rootLogger = LoggerFactory.getLogger(logger.ROOT_LOGGER_NAME);

                        var ifSituation = executor.inFields["situation"];

                        // create outfiled for decision
                        var decision = executor.subject.getOutFieldSchemaHelper("decision").createNewInstance();
                        decision.put("description", "None, everything is ok");
                        decision.put("decision", "NONE");
                        decision.put("customers", new ArrayList());

                        var returnValueType = Java.type("java.lang.Boolean");
                        if (ifSituation.get("problemID") == "NONE") {
                            logger.trace("-- no problem, everything ok");
                            var returnValue = new returnValueType(true);
                        } else {
                            logger.trace("-- wrong problemID <" + problemID + "> for NONE task, we should not be here");
                            rootLogger.error(executor.subject.id + " " + "-- wrong problemID <" + problemID
                                    + "> for NONE task, we should not be here");
                            var returnValue = new returnValueType(false);
                        }

                        executor.outFields["decision"] = decision;

                        logger.trace("finished: " + executor.subject.id);
                        logger.debug(".d-non");

Logic: Decide Solved
---------------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        /*
                         * ============LICENSE_START=======================================================
                         *  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                         * ================================================================================
                         * Licensed under the Apache License, Version 2.0 (the "License");
                         * you may not use this file except in compliance with the License.
                         * You may obtain a copy of the License at
                         *
                         *      http://www.apache.org/licenses/LICENSE-2.0
                         *
                         * Unless required by applicable law or agreed to in writing, software
                         * distributed under the License is distributed on an "AS IS" BASIS,
                         * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                         * See the License for the specific language governing permissions and
                         * limitations under the License.
                         *
                         * SPDX-License-Identifier: Apache-2.0
                         * ============LICENSE_END=========================================================
                         */

                        load("nashorn:mozilla_compat.js");
                        importClass(org.slf4j.LoggerFactory);

                        importClass(java.util.ArrayList);

                        importClass(org.apache.avro.generic.GenericData.Array);
                        importClass(org.apache.avro.generic.GenericRecord);
                        importClass(org.apache.avro.Schema);

                        var logger = executor.logger;
                        logger.trace("start: " + executor.subject.id);
                        logger.trace("-- infields: " + executor.inFields);

                        var rootLogger = LoggerFactory.getLogger(logger.ROOT_LOGGER_NAME);

                        var ifSituation = executor.inFields["situation"];

                        var albumProblemMap = executor.getContextAlbum("albumProblemMap");

                        // create outfiled for decision
                        var decision = executor.subject.getOutFieldSchemaHelper("decision").createNewInstance();
                        decision.put("description", "None, everything is ok");
                        decision.put("decision", "REBUILD");
                        decision.put("customers", new ArrayList());
                        decision.put("problemID", ifSituation.get("problemID"));

                        var returnValueType = Java.type("java.lang.Boolean");
                        if (albumProblemMap.get(ifSituation.get("problemID")).get("status") == "SOLVED") {
                            logger.trace("-- problem solved");
                            var returnValue = new returnValueType(true);
                        } else {
                            logger.trace("-- wrong problemID <" + problemID + "> for SOLVED task, we should not be here");
                            rootLogger.error(executor.subject.id + " " + "-- wrong problemID <" + problemID
                                    + "> for SOLVED task, we should not be here");
                            var returnValue = new returnValueType(false);
                        }

                        executor.outFields["decision"] = decision;

                        logger.info("vpnsla: sla solved, problem solved");

                        logger.trace("finished: " + executor.subject.id);
                        logger.debug(".d-non");

Logic: Decide SLA
------------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        /*
                         * ============LICENSE_START=======================================================
                         *  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                         * ================================================================================
                         * Licensed under the Apache License, Version 2.0 (the "License");
                         * you may not use this file except in compliance with the License.
                         * You may obtain a copy of the License at
                         *
                         *      http://www.apache.org/licenses/LICENSE-2.0
                         *
                         * Unless required by applicable law or agreed to in writing, software
                         * distributed under the License is distributed on an "AS IS" BASIS,
                         * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                         * See the License for the specific language governing permissions and
                         * limitations under the License.
                         *
                         * SPDX-License-Identifier: Apache-2.0
                         * ============LICENSE_END=========================================================
                         */

                        load("nashorn:mozilla_compat.js");
                        importClass(org.slf4j.LoggerFactory);

                        importClass(java.util.ArrayList);

                        importClass(org.apache.avro.generic.GenericData.Array);
                        importClass(org.apache.avro.generic.GenericRecord);
                        importClass(org.apache.avro.Schema);

                        var logger = executor.logger;
                        logger.trace("start: " + executor.subject.id);
                        logger.trace("-- infields: " + executor.inFields);

                        var rootLogger = LoggerFactory.getLogger(logger.ROOT_LOGGER_NAME);

                        var ifSituation = executor.inFields["situation"];

                        var albumCustomerMap = executor.getContextAlbum("albumCustomerMap");
                        var albumProblemMap = executor.getContextAlbum("albumProblemMap");

                        // create outfiled for decision
                        var decision = executor.subject.getOutFieldSchemaHelper("decision").createNewInstance();
                        decision.put("description", "Impede given customers selected based on maximum SLA delta");
                        decision.put("decision", "IMPEDE");
                        decision.put("problemID", ifSituation.get("problemID"));
                        decision.put("customers", new ArrayList());

                        var problem = albumProblemMap.get(ifSituation.get("problemID"));
                        var returnValueType = Java.type("java.lang.Boolean");
                        if (problem != null && ifSituation.get("violatedSLAs").size() == 0) {
                            logger.trace("-- impede by maximum SLA");
                            var customer = "";
                            var customerSla = 0;
                            for (var i = 0; i < problem.get("edgeUsedBy").size(); i++) {
                                customerCtxt = albumCustomerMap.get(problem.get("edgeUsedBy").get(i).toString());
                                if (customerSla == 0) {
                                    customerSla = customerCtxt.get("dtSLA") - customerCtxt.get("dtYTD");
                                }
                                if ((customerCtxt.get("dtSLA") - customerCtxt.get("dtYTD")) >= customerSla) {
                                    customer = customerCtxt.get("customerName");
                                    customerSla = (customerCtxt.get("dtSLA") - customerCtxt.get("dtYTD"));
                                }
                            }
                            decision.get("customers").add(customer);
                            var returnValue = new returnValueType(true);
                        } else {
                            logger.trace("-- wrong problemID <" + ifSituation.get("problemID") + "> for SLA task, we should not be here");
                            rootLogger.error(executor.subject.id + " " + "-- wrong problemID <" + ifSituation.get("problemID")
                                    + "> for SLA task, we should not be here");
                            var returnValue = new returnValueType(false);
                        }

                        // set impededLast to decision[customers]
                        problem.get("impededLast").clear();
                        problem.get("impededLast").addAll(decision.get("customers"));

                        executor.outFields["decision"] = decision;
                        logger.trace("-- decision: " + decision);

                        logger.info("vpnsla: sla balance, impeding customers " + decision.get("customers"));

                        logger.trace("finished: " + executor.subject.id);
                        logger.debug(".d-sla");

Logic: Decide Priority
----------------------

         .. container:: sect2

            .. container:: listingblock

               .. container:: content

                  .. code:: CodeRay

                     /*
                      * ============LICENSE_START=======================================================
                      *  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                      * ================================================================================
                      * Licensed under the Apache License, Version 2.0 (the "License");
                      * you may not use this file except in compliance with the License.
                      * You may obtain a copy of the License at
                      *
                      *      http://www.apache.org/licenses/LICENSE-2.0
                      *
                      * Unless required by applicable law or agreed to in writing, software
                      * distributed under the License is distributed on an "AS IS" BASIS,
                      * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                      * See the License for the specific language governing permissions and
                      * limitations under the License.
                      *
                      * SPDX-License-Identifier: Apache-2.0
                      * ============LICENSE_END=========================================================
                      */

                     load("nashorn:mozilla_compat.js");
                     importClass(org.slf4j.LoggerFactory);

                     importClass(java.util.ArrayList);

                     importClass(org.apache.avro.generic.GenericData.Array);
                     importClass(org.apache.avro.generic.GenericRecord);
                     importClass(org.apache.avro.Schema);

                     var logger = executor.logger;
                     logger.trace("start: " + executor.subject.id);
                     logger.trace("-- infields: " + executor.inFields);

                     var rootLogger = LoggerFactory.getLogger(logger.ROOT_LOGGER_NAME);

                     var ifSituation = executor.inFields["situation"];

                     var albumCustomerMap = executor.getContextAlbum("albumCustomerMap");
                     var albumProblemMap = executor.getContextAlbum("albumProblemMap");

                     // create outfiled for decision
                     var decision = executor.subject.getOutFieldSchemaHelper("decision").createNewInstance();
                     decision.put("description", "None, everything is ok");
                     decision.put("decision", "IMPEDE");
                     decision.put("problemID", ifSituation.get("problemID"));
                     decision.put("customers", new ArrayList());

                     var problem = albumProblemMap.get(ifSituation.get("problemID"));
                     var returnValueType = Java.type("java.lang.Boolean");
                     if (problem != null && ifSituation.get("violatedSLAs").size() > 0) {
                         logger.trace("-- impede by priority");
                         for (var i = 0; i < problem.get("edgeUsedBy").size(); i++) {
                             customerCtxt = albumCustomerMap.get(problem.get("edgeUsedBy").get(i).toString());
                             if (customerCtxt.get("priority") == false) {
                                 decision.get("customers").add(customerCtxt.get("customerName"));
                             }
                         }
                         var returnValue = new returnValueType(true);
                     } else {
                         logger.trace("-- wrong problemID <" + ifSituation.get("problemID") + "> for PRIORITY task, we should not be here");
                         rootLogger.error(executor.subject.id + " " + "-- wrong problemID <" + ifSituation.get("problemID")
                                 + "> for PRIORITY task, we should not be here");
                         var returnValue = new returnValueType(false);
                     }

                     // set impededLast to decision[customers]
                     problem.get("impededLast").clear();
                     problem.get("impededLast").addAll(decision.get("customers"));

                     executor.outFields["decision"] = decision;
                     logger.trace("-- decision: " + decision);

                     logger.info("vpnsla: priority, impeding customers " + decision.get("customers"));

                     logger.trace("finished: " + executor.subject.id);
                     logger.debug(".d-pri");

Logic: Policy Act State
------------------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  This is the logic for the act state. It is simply
                  selecting an action, and creating the repsonse event
                  for the orchestrator (the output of the policy).

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        /*
                         * ============LICENSE_START=======================================================
                         *  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                         * ================================================================================
                         * Licensed under the Apache License, Version 2.0 (the "License");
                         * you may not use this file except in compliance with the License.
                         * You may obtain a copy of the License at
                         *
                         *      http://www.apache.org/licenses/LICENSE-2.0
                         *
                         * Unless required by applicable law or agreed to in writing, software
                         * distributed under the License is distributed on an "AS IS" BASIS,
                         * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                         * See the License for the specific language governing permissions and
                         * limitations under the License.
                         *
                         * SPDX-License-Identifier: Apache-2.0
                         * ============LICENSE_END=========================================================
                         */

                        load("nashorn:mozilla_compat.js");

                        var logger = executor.logger;
                        logger.trace("start: " + executor.subject.id);
                        logger.trace("-- infields: " + executor.inFields);

                        var ifDecision = executor.inFields["decision"];
                        var ifMatchStart = executor.inFields["matchStart"];

                        var albumCustomerMap = executor.getContextAlbum("albumCustomerMap");
                        var albumProblemMap = executor.getContextAlbum("albumProblemMap");

                        switch (ifDecision.get("decision").toString()) {
                        case "NONE":
                            executor.outFields["edgeName"] = "";
                            executor.outFields["action"] = "";
                            break;
                        case "IMPEDE":
                            for (var i = 0; i < ifDecision.get("customers").size(); i++) {
                                customer = albumCustomerMap.get(ifDecision.get("customers").get(i).toString());
                                executor.outFields["edgeName"] = customer.get("links").get(0);
                                executor.outFields["action"] = "firewall";
                            }
                            break;
                        case "REBUILD":
                            // finally solved, remove problem
                            albumProblemMap.remove(ifDecision.get("problemID"));
                            executor.outFields["edgeName"] = "L10"; // this is ###static###
                            executor.outFields["action"] = "rebuild"; // this is ###static###
                            break;
                        default:

                        }

                        var returnValueType = Java.type("java.lang.Boolean");
                        var returnValue = new returnValueType(true);

                        if (executor.outFields["action"] != "") {
                            logger.info("vpnsla: action is to " + executor.outFields["action"] + " " + executor.outFields["edgeName"]);
                        } else {
                            logger.info("vpnsla: no action required");
                        }

                        logger.trace("-- outfields: " + executor.outFields);
                        logger.trace("finished: " + executor.subject.id);
                        logger.debug(".a");

                        var now = new Date().getTime();
                        logger.info("VPN SLA finished in " + (now - ifMatchStart) + " ms");

CLI Spec
--------

         .. container:: sect1

            .. rubric:: Complete Policy Definition
               :name: complete_policy_definition

            .. container:: sectionbody

               .. container:: paragraph

                  The complete policy definition is realized using the
                  APEX CLI Editor. The script below shows the actual
                  policy specification. All logic and schemas are
                  included (as macro file).

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        #-------------------------------------------------------------------------------
                        # ============LICENSE_START=======================================================
                        #  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                        # ================================================================================
                        # Licensed under the Apache License, Version 2.0 (the "License");
                        # you may not use this file except in compliance with the License.
                        # You may obtain a copy of the License at
                        #
                        #      http://www.apache.org/licenses/LICENSE-2.0
                        #
                        # Unless required by applicable law or agreed to in writing, software
                        # distributed under the License is distributed on an "AS IS" BASIS,
                        # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                        # See the License for the specific language governing permissions and
                        # limitations under the License.
                        #
                        # SPDX-License-Identifier: Apache-2.0
                        # ============LICENSE_END=========================================================
                        #-------------------------------------------------------------------------------

                        # ============LICENSE_START=======================================================
                        #  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                        # ================================================================================
                        # Licensed under the Apache License, Version 2.0 (the "License");
                        # you may not use this file except in compliance with the License.
                        # You may obtain a copy of the License at
                        #
                        #      http://www.apache.org/licenses/LICENSE-2.0
                        #
                        # Unless required by applicable law or agreed to in writing, software
                        # distributed under the License is distributed on an "AS IS" BASIS,
                        # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                        # See the License for the specific language governing permissions and
                        # limitations under the License.
                        #
                        # SPDX-License-Identifier: Apache-2.0
                        # ============LICENSE_END=========================================================

                        model create name=PCVS-VpnSla version=1.0.0 description="Policies-Controlled Video Streaming, VPN SLA Policy Model"



                        schema create name=reportDecl version=1.0.0 description="Report of activities of a policy/task" flavour=Java schema=java.lang.String
                        event create name=ReportOut version=1.0.0 description="Report of a policy (issued by a task)" nameSpace=org.onap.policy.apex.examples.pcvs.vpnsla source="APEX" target="CtxtManagement"
                        event parameter create name=ReportOut version=1.0.0 parName=report schemaName=reportDecl schemaVersion=1.0.0

                        schema create name=timestampDecl version=1.0.0 description="Timestamp" flavour=Java schema=java.lang.Long



                        schema create name=ctxtEdgeNameDecl version=1.0.0 description="Topology Edges: edge (link) name" flavour=Java schema=java.lang.String
                        schema create name=ctxtEdgeStartDecl version=1.0.0 description="Topology Edges: edge endpoint (start)" flavour=Java schema=java.lang.String
                        schema create name=ctxtEdgeEndDecl version=1.0.0 description="Topology Edges: edge endpoint (end)" flavour=Java schema=java.lang.String
                        schema create name=ctxtEdgeStatusDecl version=1.0.0 description="Topology Edges: edge status as up (true) or down (false)" flavour=Java schema=java.lang.Boolean

                        schema create name=ctxtTopologyEdgesDecl version=1.0.0 description="Topology Edges Context Map" flavour=Avro schema=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/avro/topology-edges.avsc"
                        LE
                        album create name=albumTopoEdges scope=global writable=true schemaName=ctxtTopologyEdgesDecl


                        task create name=EdgeContextTask version=1.0.0 description="This task adds event context to edge context"
                        task inputfield create name=EdgeContextTask version=1.0.0 fieldName=edgeName schemaName=ctxtEdgeNameDecl schemaVersion=1.0.0
                        task inputfield create name=EdgeContextTask version=1.0.0 fieldName=start schemaName=ctxtEdgeStartDecl schemaVersion=1.0.0
                        task inputfield create name=EdgeContextTask version=1.0.0 fieldName=end schemaName=ctxtEdgeEndDecl schemaVersion=1.0.0
                        task inputfield create name=EdgeContextTask version=1.0.0 fieldName=status schemaName=ctxtEdgeStatusDecl schemaVersion=1.0.0
                        task outputfield create name=EdgeContextTask version=1.0.0 fieldName=report schemaName=reportDecl schemaVersion=1.0.0
                        task contextref create name=EdgeContextTask albumName=albumTopoEdges
                        task logic create name=EdgeContextTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/logic/ctxt-edges.js"
                        LE

                        event create name=EdgeContextEventIn version=1.0.0 description="Event to add an Edge to engine Context" nameSpace=org.onap.policy.apex.examples.pcvs.vpnsla source="CtxtManagement" target="APEX"
                        event parameter create name=EdgeContextEventIn version=1.0.0 parName=edgeName schemaName=ctxtEdgeNameDecl schemaVersion=1.0.0
                        event parameter create name=EdgeContextEventIn version=1.0.0 parName=start schemaName=ctxtEdgeStartDecl schemaVersion=1.0.0
                        event parameter create name=EdgeContextEventIn version=1.0.0 parName=end schemaName=ctxtEdgeEndDecl schemaVersion=1.0.0
                        event parameter create name=EdgeContextEventIn version=1.0.0 parName=status schemaName=ctxtEdgeStatusDecl schemaVersion=1.0.0

                        policy create name=EdgeContextPolicy version=1.0.0 description="Policy that adds an edge to context" template=FREEFORM firstState=EdgeContextState
                        policy state create name=EdgeContextPolicy version=1.0.0 stateName=EdgeContextState triggerName=EdgeContextEventIn triggerVersion=1.0.0 defaultTaskName=EdgeContextTask defaultTaskVersion=1.0.0
                        policy state output create name=EdgeContextPolicy version=1.0.0 stateName=EdgeContextState outputName=EdgeContextState_Output_Direct eventName=ReportOut eventVersion=1.0.0 nextState=NULL
                        policy state taskref create name=EdgeContextPolicy version=1.0.0 stateName=EdgeContextState taskLocalName=doContext taskName=EdgeContextTask taskVersion=1.0.0 outputType=DIRECT outputName=EdgeContextState_Output_Direct



                        schema create name=ctxtNodeNameDecl version=1.0.0 description="Topology Nodes: node name" flavour=Java schema=java.lang.String
                        schema create name=ctxtNodeMininetNameDecl version=1.0.0 description="Topology Nodes: node name in Mininet" flavour=Java schema=java.lang.String

                        schema create name=ctxtTopologyNodesDecl version=1.0.0 description="Topology Nodes Context Map" flavour=Avro schema=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/avro/topology-nodes.avsc"
                        LE
                        album create name=albumTopoNodes scope=global writable=true schemaName=ctxtTopologyNodesDecl

                        task create name=NodeContextTask version=1.0.0 description="This task adds event context to node context"
                        task inputfield create name=NodeContextTask version=1.0.0 fieldName=nodeName schemaName=ctxtNodeNameDecl schemaVersion=1.0.0
                        task inputfield create name=NodeContextTask version=1.0.0 fieldName=mininetName schemaName=ctxtNodeMininetNameDecl schemaVersion=1.0.0
                        task outputfield create name=NodeContextTask version=1.0.0 fieldName=report schemaName=reportDecl schemaVersion=1.0.0
                        task contextref create name=NodeContextTask albumName=albumTopoNodes
                        task logic create name=NodeContextTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/logic/ctxt-nodes.js"
                        LE

                        event create name=NodeContextEventIn version=1.0.0 description="Event to add Node to engine Context" nameSpace=org.onap.policy.apex.examples.pcvs.vpnsla source="CtxtManagement" target="APEX"
                        event parameter create name=NodeContextEventIn version=1.0.0 parName=nodeName schemaName=ctxtNodeNameDecl schemaVersion=1.0.0
                        event parameter create name=NodeContextEventIn version=1.0.0 parName=mininetName schemaName=ctxtNodeMininetNameDecl schemaVersion=1.0.0

                        policy create name=NodeContextPolicy version=1.0.0 description="Policy that adds an node to context" template=FREEFORM firstState=NodeContextState
                        policy state create name=NodeContextPolicy version=1.0.0 stateName=NodeContextState triggerName=NodeContextEventIn triggerVersion=1.0.0 defaultTaskName=NodeContextTask defaultTaskVersion=1.0.0
                        policy state output create name=NodeContextPolicy version=1.0.0 stateName=NodeContextState outputName=NodeContextState_Output_Direct eventName=ReportOut eventVersion=1.0.0 nextState=NULL
                        policy state taskref create name=NodeContextPolicy version=1.0.0 stateName=NodeContextState taskLocalName=doContext taskName=NodeContextTask taskVersion=1.0.0 outputType=DIRECT outputName=NodeContextState_Output_Direct




                        schema create name=ctxtCustomerNameDecl version=1.0.0 description="Customer Context: customer name" flavour=Java schema=java.lang.String
                        schema create name=ctxtCustomerPriorityDecl version=1.0.0 description="Customer Context: priority flag" flavour=Java schema=java.lang.Boolean
                        schema create name=ctxtCustomerSatisfactionDecl version=1.0.0 description="Customer Context: satisfaction in percent" flavour=Java schema=java.lang.Integer
                        schema create name=ctxtCustomerDowntimeSLADecl version=1.0.0 description="Customer Context: contracted downtime as per SLA" flavour=Java schema=java.lang.Integer
                        schema create name=ctxtCustomerDowntimeYTDDecl version=1.0.0 description="Customer Context: year-to-date downtime experienced" flavour=Java schema=java.lang.Integer
                        schema create name=ctxtCustomerLinksDecl version=1.0.0 description="Customer Context: links a customer uses (for events/task)" flavour=Java schema=java.lang.String

                        schema create name=ctxtCustomerMapDecl version=1.0.0 description="Map of customers with all known information" flavour=Avro schema=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/avro/customers.avsc"
                        LE
                        album create name=albumCustomerMap scope=global writable=true schemaName=ctxtCustomerMapDecl

                        task create name=CustomerContextTask version=1.0.0 description="This task adds event context to customer context"
                        task inputfield create name=CustomerContextTask version=1.0.0 fieldName=customerName schemaName=ctxtCustomerNameDecl schemaVersion=1.0.0
                        task inputfield create name=CustomerContextTask version=1.0.0 fieldName=priority schemaName=ctxtCustomerPriorityDecl schemaVersion=1.0.0
                        task inputfield create name=CustomerContextTask version=1.0.0 fieldName=satisfaction schemaName=ctxtCustomerSatisfactionDecl schemaVersion=1.0.0
                        task inputfield create name=CustomerContextTask version=1.0.0 fieldName=dtSLA schemaName=ctxtCustomerDowntimeSLADecl schemaVersion=1.0.0
                        task inputfield create name=CustomerContextTask version=1.0.0 fieldName=dtYTD schemaName=ctxtCustomerDowntimeYTDDecl schemaVersion=1.0.0
                        task inputfield create name=CustomerContextTask version=1.0.0 fieldName=links schemaName=ctxtCustomerLinksDecl schemaVersion=1.0.0
                        task outputfield create name=CustomerContextTask version=1.0.0 fieldName=report schemaName=reportDecl schemaVersion=1.0.0
                        task contextref create name=CustomerContextTask albumName=albumCustomerMap
                        task contextref create name=CustomerContextTask albumName=albumTopoEdges
                        task logic create name=CustomerContextTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/logic/ctxt-customer.js"
                        LE

                        event create name=CustomerContextEventIn version=1.0.0 description="Event to add Customers to engine Context" nameSpace=org.onap.policy.apex.examples.pcvs.vpnsla source="CtxtManagement" target="APEX"
                        event parameter create name=CustomerContextEventIn version=1.0.0 parName=customerName schemaName=ctxtCustomerNameDecl schemaVersion=1.0.0
                        event parameter create name=CustomerContextEventIn version=1.0.0 parName=priority schemaName=ctxtCustomerPriorityDecl schemaVersion=1.0.0
                        event parameter create name=CustomerContextEventIn version=1.0.0 parName=satisfaction schemaName=ctxtCustomerSatisfactionDecl schemaVersion=1.0.0
                        event parameter create name=CustomerContextEventIn version=1.0.0 parName=dtSLA schemaName=ctxtCustomerDowntimeSLADecl schemaVersion=1.0.0
                        event parameter create name=CustomerContextEventIn version=1.0.0 parName=dtYTD schemaName=ctxtCustomerDowntimeYTDDecl schemaVersion=1.0.0
                        event parameter create name=CustomerContextEventIn version=1.0.0 parName=links schemaName=ctxtCustomerLinksDecl schemaVersion=1.0.0

                        policy create name=CustomerContextPolicy version=1.0.0 description="Policy that adds Customer information to engine context" template=FREEFORM firstState=CustomerContextState
                        policy state create name=CustomerContextPolicy version=1.0.0 stateName=CustomerContextState triggerName=CustomerContextEventIn triggerVersion=1.0.0 defaultTaskName=CustomerContextTask defaultTaskVersion=1.0.0
                        policy state output create name=CustomerContextPolicy version=1.0.0 stateName=CustomerContextState outputName=CustomerContextState_Output_Direct eventName=ReportOut eventVersion=1.0.0 nextState=NULL
                        policy state taskref create name=CustomerContextPolicy version=1.0.0 stateName=CustomerContextState taskLocalName=doContext taskName=CustomerContextTask taskVersion=1.0.0 outputType=DIRECT outputName=CustomerContextState_Output_Direct




                        schema create name=edgeNameDecl version=1.0.0 description="Edge name" flavour=Java schema=java.lang.String
                        schema create name=edgeStatusDecl version=1.0.0 description="Statuf of the edge (UP, DOWN)" flavour=Avro schema=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/avro/link-status.avsc"
                        LE
                        schema create name=edgeChangedDecl version=1.0.0 description="Status Change (true:change, false:no change)" flavour=Java schema=java.lang.Boolean

                        task create name=VpnSlaPolicyMatchTask version=1.0.0 description="Pre-process an edge event"
                        task inputfield create name=VpnSlaPolicyMatchTask version=1.0.0 fieldName=edgeName schemaName=edgeNameDecl schemaVersion=1.0.0
                        task inputfield create name=VpnSlaPolicyMatchTask version=1.0.0 fieldName=status schemaName=edgeStatusDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyMatchTask version=1.0.0 fieldName=edgeName schemaName=edgeNameDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyMatchTask version=1.0.0 fieldName=status schemaName=edgeStatusDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyMatchTask version=1.0.0 fieldName=hasChanged schemaName=edgeChangedDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyMatchTask version=1.0.0 fieldName=matchStart schemaName=timestampDecl schemaVersion=1.0.0
                        task contextref create name=VpnSlaPolicyMatchTask albumName=albumTopoEdges
                        task logic create name=VpnSlaPolicyMatchTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/logic/task-match.js"
                        LE




                        schema create name=problemMapDecl version=1.0.0 description="Map of problems with all known Information" flavour=Avro schema=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/avro/problems.avsc"
                        LE
                        album create name=albumProblemMap scope=global writable=true schemaName=problemMapDecl

                        schema create name=establishSituationDecl version=1.0.0 description="Establish: the situation that was established" flavour=Avro schema=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/avro/situation.avsc"
                        LE

                        task create name=VpnSlaPolicyEstablishTask version=1.0.0 description="Task taking a match event and establishing a situation"
                        task inputfield create name=VpnSlaPolicyEstablishTask version=1.0.0 fieldName=edgeName schemaName=edgeNameDecl schemaVersion=1.0.0
                        task inputfield create name=VpnSlaPolicyEstablishTask version=1.0.0 fieldName=status schemaName=edgeStatusDecl schemaVersion=1.0.0
                        task inputfield create name=VpnSlaPolicyEstablishTask version=1.0.0 fieldName=hasChanged schemaName=edgeChangedDecl schemaVersion=1.0.0
                        task inputfield create name=VpnSlaPolicyEstablishTask version=1.0.0 fieldName=matchStart schemaName=timestampDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyEstablishTask version=1.0.0 fieldName=situation schemaName=establishSituationDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyEstablishTask version=1.0.0 fieldName=matchStart schemaName=timestampDecl schemaVersion=1.0.0
                        task contextref create name=VpnSlaPolicyEstablishTask albumName=albumProblemMap
                        task contextref create name=VpnSlaPolicyEstablishTask albumName=albumCustomerMap
                        task logic create name=VpnSlaPolicyEstablishTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/logic/task-establish.js"
                        LE




                        schema create name=decideDecisionDecl version=1.0.0 description="Decide: the taken decision" flavour=Avro schema=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/avro/decision.avsc"
                        LE

                        task create name=VpnSlaPolicyDecideNoneTask version=1.0.0 description="Decide task for a 'none' problem"
                        task inputfield create name=VpnSlaPolicyDecideNoneTask version=1.0.0 fieldName=situation schemaName=establishSituationDecl schemaVersion=1.0.0
                        task inputfield create name=VpnSlaPolicyDecideNoneTask version=1.0.0 fieldName=matchStart schemaName=timestampDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyDecideNoneTask version=1.0.0 fieldName=decision schemaName=decideDecisionDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyDecideNoneTask version=1.0.0 fieldName=matchStart schemaName=timestampDecl schemaVersion=1.0.0
                        task logic create name=VpnSlaPolicyDecideNoneTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/logic/task-decide-none.js"
                        LE


                        task create name=VpnSlaPolicyDecideSlaTask version=1.0.0 description="Decide task solving the problem by balancing SLAs"
                        task inputfield create name=VpnSlaPolicyDecideSlaTask version=1.0.0 fieldName=situation schemaName=establishSituationDecl schemaVersion=1.0.0
                        task inputfield create name=VpnSlaPolicyDecideSlaTask version=1.0.0 fieldName=matchStart schemaName=timestampDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyDecideSlaTask version=1.0.0 fieldName=decision schemaName=decideDecisionDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyDecideSlaTask version=1.0.0 fieldName=matchStart schemaName=timestampDecl schemaVersion=1.0.0
                        task contextref create name=VpnSlaPolicyDecideSlaTask albumName=albumCustomerMap
                        task contextref create name=VpnSlaPolicyDecideSlaTask albumName=albumProblemMap
                        task logic create name=VpnSlaPolicyDecideSlaTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/logic/task-decide-sla.js"
                        LE


                        task create name=VpnSlaPolicyDecidePriorityTask version=1.0.0 description="Decide task solving the problem by using customer priorities"
                        task inputfield create name=VpnSlaPolicyDecidePriorityTask version=1.0.0 fieldName=situation schemaName=establishSituationDecl schemaVersion=1.0.0
                        task inputfield create name=VpnSlaPolicyDecidePriorityTask version=1.0.0 fieldName=matchStart schemaName=timestampDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyDecidePriorityTask version=1.0.0 fieldName=decision schemaName=decideDecisionDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyDecidePriorityTask version=1.0.0 fieldName=matchStart schemaName=timestampDecl schemaVersion=1.0.0
                        task contextref create name=VpnSlaPolicyDecidePriorityTask albumName=albumCustomerMap
                        task contextref create name=VpnSlaPolicyDecidePriorityTask albumName=albumProblemMap
                        task logic create name=VpnSlaPolicyDecidePriorityTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/logic/task-decide-priority.js"
                        LE


                        task create name=VpnSlaPolicyDecideSolvedTask version=1.0.0 description="Decide task solving the problem by using customer priorities"
                        task inputfield create name=VpnSlaPolicyDecideSolvedTask version=1.0.0 fieldName=situation schemaName=establishSituationDecl schemaVersion=1.0.0
                        task inputfield create name=VpnSlaPolicyDecideSolvedTask version=1.0.0 fieldName=matchStart schemaName=timestampDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyDecideSolvedTask version=1.0.0 fieldName=decision schemaName=decideDecisionDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyDecideSolvedTask version=1.0.0 fieldName=matchStart schemaName=timestampDecl schemaVersion=1.0.0
                        task contextref create name=VpnSlaPolicyDecideSolvedTask albumName=albumProblemMap
                        task logic create name=VpnSlaPolicyDecideSolvedTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/logic/task-decide-solved.js"
                        LE




                        schema create name=actionDecl version=1.0.0 description="An action for the actioning system" flavour=Java schema=java.lang.String

                        task create name=VpnSlaPolicyActTask version=1.0.0 description="Task issueing an action for taken decision"
                        task inputfield create name=VpnSlaPolicyActTask version=1.0.0 fieldName=decision schemaName=decideDecisionDecl schemaVersion=1.0.0
                        task inputfield create name=VpnSlaPolicyActTask version=1.0.0 fieldName=matchStart schemaName=timestampDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyActTask version=1.0.0 fieldName=edgeName schemaName=edgeNameDecl schemaVersion=1.0.0
                        task outputfield create name=VpnSlaPolicyActTask version=1.0.0 fieldName=action schemaName=actionDecl schemaVersion=1.0.0
                        task contextref create name=VpnSlaPolicyActTask albumName=albumCustomerMap
                        task contextref create name=VpnSlaPolicyActTask albumName=albumProblemMap
                        task logic create name=VpnSlaPolicyActTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/logic/task-act.js"
                        LE







                        event create name=VpnSlaTrigger version=1.0.0 description="Event triggering the VPN SLA policy" nameSpace=org.onap.policy.apex.examples.pcvs.vpnsla source="TriggerSys" target="VpnSlaMatch"
                        event parameter create name=VpnSlaTrigger version=1.0.0 parName=edgeName schemaName=edgeNameDecl schemaVersion=1.0.0
                        event parameter create name=VpnSlaTrigger version=1.0.0 parName=status schemaName=edgeStatusDecl schemaVersion=1.0.0

                        event create name=VpnSlaMatchOut version=1.0.0 description="Event with matched trigger for the VPN SLA policy" nameSpace=org.onap.policy.apex.examples.pcvs.vpnsla source="VpnSlaMatch" target="VpnSlaEstablish"
                        event parameter create name=VpnSlaMatchOut version=1.0.0 parName=edgeName schemaName=edgeNameDecl schemaVersion=1.0.0
                        event parameter create name=VpnSlaMatchOut version=1.0.0 parName=status schemaName=edgeStatusDecl schemaVersion=1.0.0
                        event parameter create name=VpnSlaMatchOut version=1.0.0 parName=hasChanged schemaName=edgeChangedDecl schemaVersion=1.0.0
                        event parameter create name=VpnSlaMatchOut version=1.0.0 parName=matchStart schemaName=timestampDecl schemaVersion=1.0.0

                        event create name=VpnSlaEstablishOut version=1.0.0 description="Event with situation for the SLA policy" nameSpace=org.onap.policy.apex.examples.pcvs.vpnsla source="SlaEstablish" target="SlaDecide"
                        event parameter create name=VpnSlaEstablishOut version=1.0.0 parName=situation schemaName=establishSituationDecl schemaVersion=1.0.0
                        event parameter create name=VpnSlaEstablishOut version=1.0.0 parName=matchStart schemaName=timestampDecl schemaVersion=1.0.0

                        event create name=VpnSlaDecideOut version=1.0.0 description="Event with a decision for the SLA policy" nameSpace=org.onap.policy.apex.examples.pcvs.vpnsla source="SlaDecide" target="SlaAct"
                        event parameter create name=VpnSlaDecideOut version=1.0.0 parName=decision schemaName=decideDecisionDecl schemaVersion=1.0.0
                        event parameter create name=VpnSlaDecideOut version=1.0.0 parName=matchStart schemaName=timestampDecl schemaVersion=1.0.0

                        event create name=VpnSlaActOut version=1.0.0 description="Event action" nameSpace=org.onap.policy.apex.examples.pcvs.vpnsla source="SlaAct" target="ActioningSystem"
                        event parameter create name=VpnSlaActOut version=1.0.0 parName=edgeName schemaName=edgeNameDecl schemaVersion=1.0.0
                        event parameter create name=VpnSlaActOut version=1.0.0 parName=action schemaName=actionDecl schemaVersion=1.0.0


                        policy create name=VpnSlaPolicy version=1.0.0 description="Policy deciding customer treatment based on SLAs as MEDA policy" template=FREEFORM firstState=VpnSlaPolicyMatchState

                        policy state create name=VpnSlaPolicy version=1.0.0 stateName=VpnSlaPolicyActState triggerName=VpnSlaDecideOut triggerVersion=1.0.0 defaultTaskName=VpnSlaPolicyActTask defaultTaskVersion=1.0.0
                        policy state output create name=VpnSlaPolicy version=1.0.0 stateName=VpnSlaPolicyActState outputName=SlaPolicyAct_Output_Direct eventName=VpnSlaActOut eventVersion=1.0.0 nextState=NULL
                        policy state taskref create name=VpnSlaPolicy version=1.0.0 stateName=VpnSlaPolicyActState taskLocalName=act taskName=VpnSlaPolicyActTask taskVersion=1.0.0 outputType=DIRECT outputName=SlaPolicyAct_Output_Direct

                        policy state create name=VpnSlaPolicy version=1.0.0 stateName=VpnSlaPolicyDecideState triggerName=VpnSlaEstablishOut triggerVersion=1.0.0 defaultTaskName=VpnSlaPolicyDecideSlaTask defaultTaskVersion=1.0.0
                        policy state contextref create name=VpnSlaPolicy version=1.0.0 stateName=VpnSlaPolicyDecideState albumName=albumProblemMap
                        policy state selecttasklogic create name=VpnSlaPolicy stateName=VpnSlaPolicyDecideState logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/org/onap/policy/apex/examples/pcvs/vpnsla/logic/tsl-decide.js"
                        LE
                        policy state output create name=VpnSlaPolicy version=1.0.0 stateName=VpnSlaPolicyDecideState outputName=VpnSlaPolicyDecide_Output_Direct eventName=VpnSlaDecideOut eventVersion=1.0.0 nextState=VpnSlaPolicyActState
                        policy state taskref create name=VpnSlaPolicy version=1.0.0 stateName=VpnSlaPolicyDecideState taskLocalName=decideNone taskName=VpnSlaPolicyDecideNoneTask taskVersion=1.0.0 outputType=DIRECT outputName=VpnSlaPolicyDecide_Output_Direct
                        policy state taskref create name=VpnSlaPolicy version=1.0.0 stateName=VpnSlaPolicyDecideState taskLocalName=decideNone taskName=VpnSlaPolicyDecideSolvedTask taskVersion=1.0.0 outputType=DIRECT outputName=VpnSlaPolicyDecide_Output_Direct
                        policy state taskref create name=VpnSlaPolicy version=1.0.0 stateName=VpnSlaPolicyDecideState taskLocalName=decideSla taskName=VpnSlaPolicyDecideSlaTask taskVersion=1.0.0 outputType=DIRECT outputName=VpnSlaPolicyDecide_Output_Direct
                        policy state taskref create name=VpnSlaPolicy version=1.0.0 stateName=VpnSlaPolicyDecideState taskLocalName=decidePriority taskName=VpnSlaPolicyDecidePriorityTask taskVersion=1.0.0 outputType=DIRECT outputName=VpnSlaPolicyDecide_Output_Direct

                        policy state create name=VpnSlaPolicy version=1.0.0 stateName=VpmSlaPolicyEstablishState triggerName=VpnSlaMatchOut triggerVersion=1.0.0 defaultTaskName=VpnSlaPolicyEstablishTask defaultTaskVersion=1.0.0
                        policy state output create name=VpnSlaPolicy version=1.0.0 stateName=VpmSlaPolicyEstablishState outputName=VpnSlaPolicyEstablish_Output_Direct eventName=VpnSlaEstablishOut eventVersion=1.0.0 nextState=VpnSlaPolicyDecideState
                        policy state taskref create name=VpnSlaPolicy version=1.0.0 stateName=VpmSlaPolicyEstablishState taskLocalName=establish taskName=VpnSlaPolicyEstablishTask taskVersion=1.0.0 outputType=DIRECT outputName=VpnSlaPolicyEstablish_Output_Direct

                        policy state create name=VpnSlaPolicy version=1.0.0 stateName=VpnSlaPolicyMatchState triggerName=VpnSlaTrigger triggerVersion=1.0.0 defaultTaskName=VpnSlaPolicyMatchTask defaultTaskVersion=1.0.0
                        policy state output create name=VpnSlaPolicy version=1.0.0 stateName=VpnSlaPolicyMatchState outputName=VpnSlaPolicyMatch_Output_Direct eventName=VpnSlaMatchOut eventVersion=1.0.0 nextState=VpmSlaPolicyEstablishState
                        policy state taskref create name=VpnSlaPolicy version=1.0.0 stateName=VpnSlaPolicyMatchState taskLocalName=match taskName=VpnSlaPolicyMatchTask taskVersion=1.0.0 outputType=DIRECT outputName=VpnSlaPolicyMatch_Output_Direct



                        validate
                        quit

Context Events Nodes
--------------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  The following events create all nodes of the topology.

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "NodeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_NodeContext",
                            "nodeName": "A1",
                            "mininetName": "nn"
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "NodeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_NodeContext",
                            "nodeName": "A2",
                            "mininetName": "nn"
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "NodeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_NodeContext",
                            "nodeName": "B1",
                            "mininetName": "nn"
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "NodeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_NodeContext",
                            "nodeName": "B2",
                            "mininetName": "nn"
                        }


                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "NodeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_NodeContext",
                            "nodeName": "A1CO",
                            "mininetName": "s1"
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "NodeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_NodeContext",
                            "nodeName": "A2CO",
                            "mininetName": "s2"
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "NodeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_NodeContext",
                            "nodeName": "B1CO",
                            "mininetName": "s3"
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "NodeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_NodeContext",
                            "nodeName": "B2CO",
                            "mininetName": "s4"
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "NodeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_NodeContext",
                            "nodeName": "BBL",
                            "mininetName": "s5"
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "NodeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_NodeContext",
                            "nodeName": "BBR",
                            "mininetName": "s6"
                        }

Context Events Edges
--------------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  The following events create all edges of the topology.

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "EdgeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_EdgeContext",
                            "edgeName": "L01",
                            "start": "A1",
                            "end": "A1CO",
                            "status": true
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "EdgeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_EdgeContext",
                            "edgeName": "L02",
                            "start": "B1",
                            "end": "B1CO",
                            "status": true
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "EdgeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_EdgeContext",
                            "edgeName": "L03",
                            "start": "A2",
                            "end": "A2CO",
                            "status": true
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "EdgeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_EdgeContext",
                            "edgeName": "L04",
                            "start": "B2",
                            "end": "B2CO",
                            "status": true
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "EdgeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_EdgeContext",
                            "edgeName": "L05",
                            "start": "A1CO",
                            "end": "BBL",
                            "status": true
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "EdgeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_EdgeContext",
                            "edgeName": "L06",
                            "start": "B1CO",
                            "end": "BBL",
                            "status": true
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "EdgeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_EdgeContext",
                            "edgeName": "L07",
                            "start": "A2CO",
                            "end": "BBR",
                            "status": true
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "EdgeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_EdgeContext",
                            "edgeName": "L08",
                            "start": "B2CO",
                            "end": "BBR",
                            "status": true
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "EdgeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_EdgeContext",
                            "edgeName": "L09",
                            "start": "BBL",
                            "end": "BBR",
                            "status": true
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "EdgeContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_EdgeContext",
                            "edgeName": "L10",
                            "start": "BBR",
                            "end": "BBL",
                            "status": true
                        }

Context Events Customers
------------------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  The following events create all customers of the
                  topology.

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "CustomerContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_CustomerContext",
                            "customerName": "A",
                            "links": "L01 L05 L09 L10",
                            "dtSLA": 180,
                            "dtYTD": 10,
                            "priority": false,
                            "satisfaction": 80
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "CustomerContextEventIn",
                            "version": "1.0.0",
                            "source": "CtxtManagement",
                            "target" : "VpnSlaPolicy_CustomerContext",
                            "customerName": "B",
                            "links": "L02 L07 L09 L10",
                            "dtSLA": 180,
                            "dtYTD": 120,
                            "priority": true,
                            "satisfaction": 99
                        }

Trigger Examples
----------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  The following events are examples for trigger events

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "VpnSlaTrigger",
                            "version": "1.0.0",
                            "source": "ExampleEvents",
                            "target" : "VpnSlaPolicy",
                            "edgeName": "L09",
                            "status": "UP"
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "VpnSlaTrigger",
                            "version": "1.0.0",
                            "source": "ExampleEvents",
                            "target" : "VpnSlaPolicy",
                            "edgeName": "L09",
                            "status": "UP"
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "VpnSlaTrigger",
                            "version": "1.0.0",
                            "source": "ExampleEvents",
                            "target" : "VpnSlaPolicy",
                            "edgeName": "L09",
                            "status": "DOWN"
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "VpnSlaTrigger",
                            "version": "1.0.0",
                            "source": "ExampleEvents",
                            "target" : "VpnSlaPolicy",
                            "edgeName": "L09",
                            "status": "DOWN"
                        }

                        {
                            "nameSpace": "org.onap.policy.apex.examples.pcvs.vpnsla",
                            "name": "VpnSlaTrigger",
                            "version": "1.0.0",
                            "source": "ExampleEvents",
                            "target" : "VpnSlaPolicy",
                            "edgeName": "L09",
                            "status": "UP"
                        }

Link Monitor
------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  The Link Monitor is a Python script. At startup, it
                  sends the context events to APEX to initialize the
                  topology and the customers. Then it takes events from
                  Kafka and sends them to APEX.

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        # ============LICENSE_START=======================================================
                        #  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                        # ================================================================================
                        # Licensed under the Apache License, Version 2.0 (the "License");
                        # you may not use this file except in compliance with the License.
                        # You may obtain a copy of the License at
                        #
                        #      http://www.apache.org/licenses/LICENSE-2.0
                        #
                        # Unless required by applicable law or agreed to in writing, software
                        # distributed under the License is distributed on an "AS IS" BASIS,
                        # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                        # See the License for the specific language governing permissions and
                        # limitations under the License.
                        #
                        # SPDX-License-Identifier: Apache-2.0
                        # ============LICENSE_END=========================================================

                        import http.client
                        import json
                        import time
                        from kafka import KafkaConsumer, KafkaProducer

                        class StaticFlowPusher(object):

                            def __init__(self, server):
                                self.server = server

                            def get(self, data):
                                ret = self.rest_call({}, 'GET')
                                return json.loads(ret[2])

                            def set(self, data):
                                ret = self.rest_call(data, 'POST')
                                return ret[0] == 200

                            def remove(self, objtype, data):
                                ret = self.rest_call(data, 'DELETE')
                                return ret[0] == 200

                            def getControllerSummary(self, data):
                                ret = self.rest_call_controller_summary({}, 'GET')
                                return json.loads(ret[2])

                            def getLinks(self, data):
                                ret = self.rest_call_links({}, 'GET')
                                return json.loads(ret[2].decode())

                            def rest_call(self, data, action):
                                path = '/wm/staticflowpusher/json'
                                headers = {
                                    'Content-type': 'application/json',
                                    'Accept': 'application/json',
                                    }
                                body = json.dumps(data)
                                conn = http.client.HTTPConnection(self.server, 8080)
                                conn.request(action, path, body, headers)
                                response = conn.getresponse()
                                ret = (response.status, response.reason, response.read())
                                print(ret)
                                conn.close()
                                return ret

                            def rest_call_controller_summary(self, data, action):
                                path = '/wm/core/controller/summary/json'
                                headers = {
                                    'Content-type': 'application/json',
                                    'Accept': 'application/json',
                                    }
                                body = json.dumps(data)
                                conn = http.client.HTTPConnection(self.server, 8080)
                                conn.request(action, path, body, headers)
                                response = conn.getresponse()
                                ret = (response.status, response.reason, response.read())
                                print(ret)
                                conn.close()
                                return ret

                            def rest_call_links(self, data, action):
                                path = '/wm/topology/links/json'
                                headers = {
                                    'Content-type': 'application/json',
                                    'Accept': 'application/json',
                                    }
                                body = json.dumps(data)
                                conn = http.client.HTTPConnection(self.server, 8080)
                                conn.request(action, path, body, headers)
                                response = conn.getresponse()
                                ret = (response.status, response.reason, response.read())
                                conn.close()
                                return ret

                        pusher = StaticFlowPusher('127.0.1.1')


                        def parseLinks(links):
                                #print("\n\n\n",links)
                                result = []
                                for link in links:
                                        list = []
                                        #print("\n\n\n",link)
                                        #print("\nsrc-switch : s", link['src-switch'][len(link['src-switch'])-1])
                                        #print("\ndst-switch : s", link['dst-switch'][len(link['dst-switch'])-1])
                                        list.append("s")
                                        list.append(link['src-switch'][len(link['src-switch'])-1])
                                        list.append("-s")
                                        list.append(link['dst-switch'][len(link['dst-switch'])-1])
                                        result.append(''.join(list))
                                #print(result, "\n")
                                return result



                        counter =0
                        healthyList = []
                        testableList = []
                        healthyLinks = ""
                        testableLinks = ""
                        producer = KafkaProducer(bootstrap_servers='localhost:9092')
                        while(True):
                                time.sleep(30)
                                switchLinks = pusher.getLinks({})
                                if counter == 0:
                                        healthyList = parseLinks(switchLinks)
                                        #Build All Links
                                        print("READING LINKS FROM MININET\n")
                                        for l in healthyList:
                                                link = ""
                                                #print(l, "\n")
                                                #Links between switches [s6-s7 is ignored so it matches VPN SCENARIO]
                                                if(l == "s1-s5"):
                                                        link = "{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'EdgeContextEventIn','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy_EdgeContext','status': true,'edgeName': 'L05', 'start': 'A1CO','end': 'BBL'}"
                                                        producer.send("apex-in-0", bytes(link, encoding="ascii"))
                                                if(l == "s5-s6"):
                                                        link = "{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'EdgeContextEventIn','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy_EdgeContext','status': true,'edgeName': 'L09', 'start': 'BBL','end': 'BBR'}"
                                                        producer.send("apex-in-0", bytes(link, encoding="ascii"))
                                                if(l == "s2-s6"):
                                                        link = "{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'EdgeContextEventIn','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy_EdgeContext','status': true,'edgeName': 'L07', 'start': 'A2CO','end': 'BBR'}"
                                                        producer.send("apex-in-0", bytes(link, encoding="ascii"))
                                                if(l == "s5-s7"):
                                                        link = "{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'EdgeContextEventIn','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy_EdgeContext','status': true,'edgeName': 'L10', 'start': 'BBR','end': 'BBL'}"
                                                        producer.send("apex-in-0", bytes(link, encoding="ascii"))
                                                if(l == "s3-s5"):
                                                        link = "{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'EdgeContextEventIn','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy_EdgeContext','status': true,'edgeName': 'L06', 'start': 'B1CO','end': 'BBL'}"
                                                        producer.send("apex-in-0", bytes(link, encoding="ascii"))
                                                if(l == "s4-s6"):
                                                        link = "{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'EdgeContextEventIn','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy_EdgeContext','status': true,'edgeName': 'L08', 'start': 'B2CO','end': 'BBR'}"
                                                        producer.send("apex-in-0", bytes(link, encoding="ascii"))
                                        #Links between switches and hosts [NoT SENT IN FROM FLOODLIGHT]
                                        producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'EdgeContextEventIn','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy_EdgeContext','status': true,'edgeName': 'L01', 'start': 'A1','end': 'A1CO'}")
                                        producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'EdgeContextEventIn','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy_EdgeContext','status': true,'edgeName': 'L02', 'start': 'B1','end': 'B1CO'}")
                                        producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'EdgeContextEventIn','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy_EdgeContext','status': true,'edgeName': 'L03', 'start': 'A2','end': 'A2CO'}")
                                        producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'EdgeContextEventIn','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy_EdgeContext','status': true,'edgeName': 'L04', 'start': 'B2','end': 'B2CO'}")
                                        print("LINKS HAVE BEEN SENT TO APEX\n")

                                        #Build Customers
                                        print("BUILDING CUSTOMERS\n")
                                        producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'CustomerContextEventIn','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy_CustomerContext','dtYTD': 10,'dtSLA': 180,'links': 'L01 L05 L09 L10','customerName': 'A', 'priority': true,'satisfaction': 80}")
                                        producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'CustomerContextEventIn','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy_CustomerContext','dtYTD': 120,'dtSLA': 180,'links': 'L02 L07 L09 L10','customerName': 'B', 'priority': false,'satisfaction': 99}")
                                        print("CUSTOMERS HAVE BEEN SENT TO APEX\n")
                                        healthyLinks = switchLinks
                                        myfile = open('LinkInfo.json', 'a')
                                        myfile.write(str(healthyLinks))
                                        myfile.write('\n')
                                        myfile.close()
                                        print("We start off with", len(healthyLinks), "healthy Links!\n")
                                else:
                                        testableList = parseLinks(switchLinks)
                                        issueLink = "";
                                        for h in healthyList:
                                                issueLink = h
                                                for t in testableList:
                                                        if t == h:
                                                                issueLink = ""
                                                if issueLink != "":
                                                        print("There is an issue with the links! ", issueLink, " \n")
                                                        if(issueLink == "s1-s5"):
                                                                link = "{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'DOWN','edgeName': 'L05'}"
                                                                producer.send("apex-in-0", bytes(link, encoding="ascii"))
                                                        if(issueLink == "s5-s6"):
                                                                link = "{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'DOWN','edgeName': 'L09'}"
                                                                producer.send("apex-in-0", bytes(link, encoding="ascii"))
                                                        if(issueLink == "s2-s6"):
                                                                link = "{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'DOWN','edgeName': 'L07'}"
                                                                producer.send("apex-in-0", bytes(link, encoding="ascii"))
                                                        if(issueLink == "s5-s7"):
                                                                link = "{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'DOWN','edgeName': 'L10'}"
                                                                producer.send("apex-in-0", bytes(link, encoding="ascii"))
                                                        if(issueLink == "s3-s5"):
                                                                link = "{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'DOWN','edgeName': 'L06'}"
                                                                producer.send("apex-in-0", bytes(link, encoding="ascii"))
                                                        if(issueLink == "s4-s6"):
                                                                link = "{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'DOWN','edgeName': 'L08'}"
                                                                producer.send("apex-in-0", bytes(link, encoding="ascii"))
                                                        break
                                        if issueLink == "":
                                                print("All Links are working\n")
                                                producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'UP','edgeName': 'L01'}")
                                                producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'UP','edgeName': 'L02'}")
                                                producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'UP','edgeName': 'L03'}")
                                                producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'UP','edgeName': 'L04'}")
                                                producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'UP','edgeName': 'L05'}")
                                                producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'UP','edgeName': 'L06'}")
                                                producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'UP','edgeName': 'L07'}")
                                                producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'UP','edgeName': 'L08'}")
                                                producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'UP','edgeName': 'L09'}")
                                                producer.send("apex-in-0", b"{'nameSpace': 'org.onap.policy.apex.examples.pcvs.vpnsla','name': 'VpnSlaTrigger','version': '1.0.0','source': 'LinkMonitor.py','target': 'VpnSlaPolicy','status': 'UP','edgeName': 'L10'}")

                                        testableLinks = switchLinks
                                        myfile = open('LinkInfo.json', 'a')
                                        myfile.write(str(testableLinks))
                                        myfile.write('\n')
                                        myfile.close()
                                counter += 1

Mininet Topology
----------------

         .. container:: sect1

            .. container:: sectionbody

               .. container:: paragraph

                  The topology is realized using Mininet. The following
                  script is use to estalish the topology and to realize
                  network configurations.

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        # ============LICENSE_START=======================================================
                        #  Copyright (C) 2016-2018 Ericsson. All rights reserved.
                        # ================================================================================
                        # Licensed under the Apache License, Version 2.0 (the "License");
                        # you may not use this file except in compliance with the License.
                        # You may obtain a copy of the License at
                        #
                        #      http://www.apache.org/licenses/LICENSE-2.0
                        #
                        # Unless required by applicable law or agreed to in writing, software
                        # distributed under the License is distributed on an "AS IS" BASIS,
                        # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                        # See the License for the specific language governing permissions and
                        # limitations under the License.
                        #
                        # SPDX-License-Identifier: Apache-2.0
                        # ============LICENSE_END=========================================================

                        #Add Mininet to PATH
                        import sys
                        sys.path.insert(0, "/~/mininet")

                        #Kafka
                        import httplib
                        import json
                        import time
                        from kafka import KafkaConsumer, KafkaProducer

                        #Mininet
                        from mininet.clean import *
                        from mininet.cli import *
                        from mininet.link import *
                        from mininet.log import *
                        from mininet.net import *
                        from mininet.node import *
                        from mininet.nodelib import *
                        from mininet.topo import *
                        from mininet.topolib import *

                        class StaticFlowPusher(object):
                            def __init__(self, server):
                                self.server = server

                            def enableFirewall(self, data):
                                path = "/wm/firewall/module/enable/json"
                                headers = {'Content-Type': 'application/json','Accept': 'application/json',}
                                body = json.dumps(data)
                                conn = httplib.HTTPConnection(self.server, 8080)
                                conn.request("PUT", path, "")
                                response = conn.getresponse()
                                ret = (response.status, response.reason, response.read())
                                conn.close()
                                return ret

                            def addRule(self, data):
                                path = '/wm/firewall/rules/json'
                                headers = {'Content-Type': 'application/json','Accept': 'application/json',}
                                body = json.dumps(data)
                                conn = httplib.HTTPConnection(self.server, 8080)
                                conn.request('POST', path, body, headers)
                                response = conn.getresponse()
                                ret = (response.status, response.reason, response.read())
                                conn.close()
                                return ret

                            def deleteRule(self, data):
                                path = '/wm/firewall/rules/json'
                                headers = {'Content-Type': 'application/json','Accept': 'application/json',}
                                body = json.dumps(data)
                                conn = httplib.HTTPConnection(self.server, 8080)
                                conn.request('DELETE', path, body, headers)
                                response = conn.getresponse()
                                ret = (response.status, response.reason, response.read())
                                conn.close()
                                return ret

                        #Build Pusher(REST/IN)
                        pusher = StaticFlowPusher('127.0.0.1')

                        net = Mininet(link=TCLink)

                        #Create Customers
                        customerA1 = net.addHost( 'A1' )
                        customerA2 = net.addHost( 'A2' )
                        customerB1 = net.addHost( 'B1' )
                        customerB2 = net.addHost( 'B2' )

                        #Create Switches
                        switchA1CO = net.addSwitch( 's1' )
                        switchA2CO = net.addSwitch( 's2' )
                        switchB1CO = net.addSwitch( 's3' )
                        switchB2CO = net.addSwitch( 's4' )
                        switchBBL = net.addSwitch( 's5' )
                        switchBBR = net.addSwitch( 's6' )
                        # we need an extra switch here because Mininet does not allow two links between two switches
                        switchEx = net.addSwitch( 's7' )

                        #Create Links
                        net.addLink( customerA1, switchA1CO )
                        net.addLink( customerA2, switchA2CO )
                        net.addLink( customerB1, switchB1CO )
                        net.addLink( customerB2, switchB2CO )
                        net.addLink( switchA1CO, switchBBL )
                        net.addLink( switchB1CO, switchBBL )
                        net.addLink( switchA2CO, switchBBR )
                        net.addLink( switchB2CO, switchBBR )
                        net.addLink( switchBBL, switchBBR)
                        net.addLink( switchBBR, switchEx, bw=1.2 )
                        net.addLink( switchEx, switchBBL )

                        #Create Controller
                        floodlightController = net.addController(name='c0' , controller=RemoteController , ip='127.0.0.1', port=6653)

                        net.start()

                        if pusher.enableFirewall({})[0] == 200:
                            print("Firewall enabled!")

                        #print(pusher.addRule({"switchid": "00:00:00:00:00:00:00:01"})[2])
                        s1id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:01"})[2])['rule-id']
                        s2id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:02"})[2])['rule-id']
                        s3id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:03"})[2])['rule-id']
                        s4id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:04"})[2])['rule-id']
                        s5id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:05"})[2])['rule-id']
                        s6id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:06"})[2])['rule-id']
                        s7id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:07"})[2])['rule-id']


                        result = 100
                        while result!=0:
                            result = net.pingAll(None)
                        print("Network Simulation Complete")

                        #Assume control and when finished "exit"
                        cli = CLI( net )

                        consumer = KafkaConsumer(bootstrap_servers='localhost:9092',auto_offset_reset='latest')
                        consumer.subscribe(['apex-out'])
                        print("Starting Message Loop")
                        for message in consumer:
                            myOutput = json.loads(message.value.decode())
                            action = ""
                            try:
                                print("Checking Message")
                                #print("SWITCHES= ",net.switches)
                                #print("LINKS= ",net.links)
                                #print("VALUES= ",net.values)
                                if myOutput['edgeName'] != '':
                                    print("Message Received: ",myOutput['edgeName'])
                                    pusher.deleteRule({"ruleid": s1id})
                                    pusher.deleteRule({"ruleid": s2id})
                                    pusher.deleteRule({"ruleid": s3id})
                                    pusher.deleteRule({"ruleid": s4id})
                                    pusher.deleteRule({"ruleid": s5id})
                                    pusher.deleteRule({"ruleid": s6id})
                                    pusher.deleteRule({"ruleid": s7id})
                                    s1id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:01"})[2])['rule-id']
                                    s2id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:02"})[2])['rule-id']
                                    s3id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:03"})[2])['rule-id']
                                    s4id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:04"})[2])['rule-id']
                                    s5id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:05"})[2])['rule-id']
                                    s6id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:06"})[2])['rule-id']
                                    s7id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:07"})[2])['rule-id']
                                    if myOutput['edgeName'] == "L01":
                                        action = "link s1 s5 down"
                                        #net.configLinkStatus('s1', 's5', "down")
                                        pusher.deleteRule({"ruleid": s1id})
                                        s1id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:01", "action": "DENY"})[2])['rule-id']
                                    if myOutput['edgeName'] == "L02":
                                        action = "link s3 s5 down"
                                        #net.configLinkStatus('s3', 's5', "down")
                                        pusher.deleteRule({"ruleid": s3id})
                                        s3id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:03", "action": "DENY"})[2])['rule-id']
                                    if myOutput['edgeName'] == "L03":
                                        action = "link s2 s6 down"
                                        #net.configLinkStatus('s2', 's6', "down")
                                        pusher.deleteRule({"ruleid": s1id})
                                        s1id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:01", "action": "DENY"})[2])['rule-id']
                                    if myOutput['edgeName'] == "L04":
                                        action = "link s4 s6 down"
                                        #net.configLinkStatus('s4', 's6', "down")
                                        pusher.deleteRule({"ruleid": s3id})
                                        s3id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:03", "action": "DENY"})[2])['rule-id']
                                    if myOutput['edgeName'] == "L05":
                                        action = "link s1 s5 down"
                                        #net.configLinkStatus('s1', 's5', "down")
                                        pusher.deleteRule({"ruleid": s1id})
                                        s1id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:01", "action": "DENY"})[2])['rule-id']
                                    if myOutput['edgeName'] == "L06":
                                        action = "link s3 s5 down"
                                        #net.configLinkStatus('s3', 's5', "down")
                                        pusher.deleteRule({"ruleid": s3id})
                                        s3id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:03", "action": "DENY"})[2])['rule-id']
                                    if myOutput['edgeName'] == "L07":
                                        action = "link s2 s6 down"
                                        #net.configLinkStatus('s2', 's6', "down")
                                        pusher.deleteRule({"ruleid": s2id})
                                        s2id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:02", "action": "DENY"})[2])['rule-id']
                                    if myOutput['edgeName'] == "L08":
                                        action = "link s4 s6 down"
                                        #net.configLinkStatus('s4', 's6', "down")
                                        pusher.deleteRule({"ruleid": s4id})
                                        s4id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:04", "action": "DENY"})[2])['rule-id']
                                    if myOutput['edgeName'] == "L09":
                                        action = "link s5 s6 down"
                                        #net.configLinkStatus('s5', 's6', "down")
                                        pusher.deleteRule({"ruleid": s7id})
                                        s7id = json.loads(pusher.addRule({"switchid": "00:00:00:00:00:00:00:07", "action": "DENY"})[2])['rule-id']
                                    if myOutput['edgeName'] == "L10":
                                        print("L10")
                                    #print(action)
                                #print("3")
                            except KeyError:
                                print(myOutput)
                        print("HA")
                        net.stop()

   .. container::
      :name: footer-text

      2.3.0-SNAPSHOT
      Last updated 2020-04-03 16:04:24 IST


.. |ONAP| image:: ../../../images/logos.png
   :class: builtBy
   :target: http://www.onap.org/

.. |VPN SLA Architecture| image:: images/pcvs/vpnsla-arch.png


