.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _apex-DecisionMakerExample:

APEX Examples Decision Maker
****************************

.. contents::
    :depth: 3

APEX Configuration: Rest Client
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

         .. container:: sect1

            .. container:: sectionbody

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        {
                            "engineServiceParameters": {
                                "name": "MyApexEngine",
                                "version": "0.0.1",
                                "id": 45,
                                "instanceCount": 4,
                                "deploymentPort": 12345,
                                "policyModelFileName": "examples/models/DecisionMaker/DecisionMakerPolicyModel.json",
                                "engineParameters": {
                                    "executorParameters": {
                                        "JAVASCRIPT": {
                                            "parameterClassName": "org.onap.policy.apex.plugins.executor.javascript.JavascriptExecutorParameters"
                                        }
                                    }
                                }
                            },
                            "eventInputParameters": {
                                "VNFInitConsumer": {
                                    "carrierTechnologyParameters": {
                                        "carrierTechnology": "FILE",
                                        "parameters": {
                                            "fileName": "examples/config/DecisionMaker/AnswerInitiationEvent.json"
                                        }
                                    },
                                    "eventProtocolParameters": {
                                        "eventProtocol": "JSON"
                                    }
                                },
                                "DMaaPConsumer": {
                                    "carrierTechnologyParameters": {
                                        "carrierTechnology": "RESTCLIENT",
                                        "parameterClassName": "org.onap.policy.apex.plugins.event.carrier.restclient.RestClientCarrierTechnologyParameters",
                                        "parameters": {
                                            "url": "http://localhost:3904/events/toApex/APEX/1?timeout=60000"
                                        }
                                    },
                                    "eventProtocolParameters": {
                                        "eventProtocol": "JSON"
                                    }
                                }
                            },
                            "eventOutputParameters": {
                                "logProducer": {
                                    "carrierTechnologyParameters": {
                                        "carrierTechnology": "FILE",
                                        "parameters": {
                                            "fileName": "/tmp/EventsOut.json"
                                        }
                                    },
                                    "eventProtocolParameters": {
                                        "eventProtocol": "JSON"
                                    }
                                },
                                "DMaapProducer": {
                                    "carrierTechnologyParameters": {
                                        "carrierTechnology": "RESTCLIENT",
                                        "parameterClassName": "org.onap.policy.apex.plugins.event.carrier.restclient.RestClientCarrierTechnologyParameters",
                                        "parameters": {
                                            "url": "http://localhost:3904/events/fromApex"
                                        }
                                    },
                                    "eventProtocolParameters": {
                                        "eventProtocol": "JSON"
                                    }
                                }
                            }
                        }


APEX Config: REST Server
^^^^^^^^^^^^^^^^^^^^^^^^

         .. container:: sect1

            .. container:: sectionbody

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        {
                            "engineServiceParameters": {
                                "name": "MyApexEngine",
                                "version": "0.0.1",
                                "id": 45,
                                "instanceCount": 4,
                                "deploymentPort": 12345,
                                "policyModelFileName": "examples/models/DecisionMaker/DecisionMakerPolicyModel.json",
                                "engineParameters": {
                                    "executorParameters": {
                                        "JAVASCRIPT": {
                                            "parameterClassName": "org.onap.policy.apex.plugins.executor.javascript.JavascriptExecutorParameters"
                                        }
                                    }
                                }
                            },
                            "eventInputParameters": {
                                "VNFInitConsumer": {
                                    "carrierTechnologyParameters": {
                                        "carrierTechnology": "FILE",
                                        "parameters": {
                                            "fileName": "examples/config/DecisionMaker/AnswerInitiationEvent.json"
                                        }
                                    },
                                    "eventProtocolParameters": {
                                        "eventProtocol": "JSON"
                                    }
                                },
                                "RESTConsumer": {
                                    "carrierTechnologyParameters": {
                                        "carrierTechnology": "RESTSERVER",
                                        "parameterClassName": "org.onap.policy.apex.plugins.event.carrier.restserver.RestServerCarrierTechnologyParameters",
                                        "parameters": {
                                            "standalone": true,
                                            "host": "0.0.0.0",
                                            "port": 23324
                                        }
                                    },
                                    "eventProtocolParameters": {
                                        "eventProtocol": "JSON"
                                    },
                                    "synchronousMode": true,
                                    "synchronousPeer": "RESTProducer",
                                    "synchronousTimeout": 500
                                }
                            },
                            "eventOutputParameters": {
                                "logProducer": {
                                    "carrierTechnologyParameters": {
                                        "carrierTechnology": "FILE",
                                        "parameters": {
                                            "fileName": "/tmp/EventsOut.json"
                                        }
                                    },
                                    "eventProtocolParameters": {
                                        "eventProtocol": "JSON"
                                    }
                                },
                                "RESTProducer": {
                                    "carrierTechnologyParameters":{
                                        "carrierTechnology" : "RESTSERVER",
                                        "parameterClassName" : "org.onap.policy.apex.plugins.event.carrier.restserver.RestServerCarrierTechnologyParameters"
                                    },
                                    "eventProtocolParameters":{
                                        "eventProtocol" : "JSON"
                                    },
                                    "synchronousMode"    : true,
                                    "synchronousPeer"    : "RESTConsumer",
                                    "synchronousTimeout" : 500
                                }
                            }
                        }


Initiation Event
^^^^^^^^^^^^^^^^^

         .. container:: sect1

            .. container:: sectionbody

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        {
                          "nameSpace": "org.onap.policy.apex.domains.decisionmaker",
                          "name": "AnswerEvent",
                          "version": "0.0.1",
                          "source": "dcae",
                          "target": "apex",
                          "a0" : "choice 0",
                          "a1" : "choice 1",
                          "a2" : "choice 2",
                          "a3" : "choice 3",
                          "a4" : "choice 4",
                          "a5" : "choice 5",
                          "a6" : "choice 6"
                        }


HTML Client
^^^^^^^^^^^

         .. container:: sect1

            .. container:: sectionbody

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        <!--
                          ============LICENSE_START=======================================================
                           Copyright (C) 2016-2018 Ericsson. All rights reserved.
                          ================================================================================
                          Licensed under the Apache License, Version 2.0 (the "License");
                          you may not use this file except in compliance with the License.
                          You may obtain a copy of the License at

                               http://www.apache.org/licenses/LICENSE-2.0

                          Unless required by applicable law or agreed to in writing, software
                          distributed under the License is distributed on an "AS IS" BASIS,
                          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                          See the License for the specific language governing permissions and
                          limitations under the License.

                          SPDX-License-Identifier: Apache-2.0
                          ============LICENSE_END=========================================================
                        -->

                        <!-- http://localhost:3904/events/toApex -->

                        <html>
                        <head>
                        <script src="http://code.jquery.com/jquery-latest.js"></script>
                        <script>
                            $(document).ready(function() {
                                $("#answerspost").click(function(e) {
                                    var elements = document.getElementById("answerform").elements;

                                    var formValues = new Object;
                                    formValues["name"] = "AnswerEvent";
                                    for (var i = 0, element; element = elements[i++];) {
                                        if (element.type === "text" && element.value != "") {
                                            formValues[element.name] = element.value;
                                        }
                                    }
                                    console.log(formValues);
                                    var stringifiedForm = JSON.stringify(formValues);
                                    console.log(stringifiedForm);
                                    $.ajax({
                                        type : "POST",
                                        url : "http://localhost:3904/events/toApex",
                                        data : stringifiedForm,
                                        crossDomain : true,
                                        contentType : "application/json; charset=utf-8",
                                        success : function(data) {
                                            alert("Answers Set Successfully !!!");
                                        },
                                        failure : function(errMsg) {
                                            alert(errMsg);
                                        }
                                    });
                                    e.preventDefault(); //STOP default action

                                });
                            });
                        </script>
                        <script>
                            $(document).ready(function() {
                                $("#modepost").click(function(e) {
                                    var elements = document.getElementById("modeform").elements;

                                    var formValues = new Object;
                                    formValues["name"] = "MakeDecisionEvent";
                                    for (var i = 0, element; element = elements[i++];) {
                                        if (element.type === "radio" && element.checked) {
                                            formValues[element.name] = element.value;
                                        }
                                    }
                                    console.log(formValues);
                                    var stringifiedForm = JSON.stringify(formValues);
                                    console.log(stringifiedForm);
                                    $.ajax({
                                        type : "POST",
                                        url : "http://localhost:3904/events/toApex",
                                        data : stringifiedForm,
                                        crossDomain : true,
                                        contentType : "application/json; charset=utf-8",
                                        success : function(data) {
                                            alert("Decision Taken: " + data.decision);
                                        },
                                        failure : function(errMsg) {
                                            alert(errMsg);
                                        }
                                    });
                                    e.preventDefault(); //STOP default action

                                });
                            });
                        </script>
                        </head>
                        <body>
                            <h3>Decision Maker Answers</h3>
                            <form name="answerform" id="answerform" method="POST">
                                <table>
                                    <tr>
                                        <td>First Answer:</td>
                                        <td><input type="text" name="a0" value="Never Ever" /></td>
                                    </tr>
                                    <tr>
                                        <td>Second Answer:</td>
                                        <td><input type="text" name="a1" value="No" /></td>
                                    </tr>
                                    <tr>
                                        <td>Third Answer:</td>
                                        <td><input type="text" name="a2" value="Maybe not" /></td>
                                    </tr>
                                    <tr>
                                        <td>Fourth Answer</td>
                                        <td><input type="text" name="a3" value="Wait" /></td>
                                    </tr>
                                    <tr>
                                        <td>Fifth Answer:</td>
                                        <td><input type="text" name="a4" value="Maybe" /></td>
                                    </tr>
                                    <tr>
                                        <td>Sixth Answer:</td>
                                        <td><input type="text" name="a5" value="Yes" /></td>
                                    </tr>
                                    <tr>
                                        <td>Seventh Answer:</td>
                                        <td><input type="text" name="a6" value="Absolutely" /></td>
                                    </tr>
                                    <tr>
                                        <td />
                                        <td><input type="button" class="btn btn-info" id="answerspost"
                                            value="Set Answers"></td>
                                    </tr>
                                </table>
                            </form>
                            <h3>Decision Maker Mode</h3>
                            <form name="modeform" id="modeform" method="POST">
                                <table>
                                    <tr>
                                        <td><input name="mode" type="radio" value="random"
                                            checked="checked">random</td>
                                        <td><input name="mode" type="radio" value="pessimistic">pessimistic</td>
                                        <td><input name="mode" type="radio" value="optimistic">
                                            optimistic</td>
                                        <td><input name="mode" type="radio" value="dithering">dithering</td>
                                    </tr>
                                    <tr>
                                        <td />
                                        <td />
                                        <td />
                                        <td><input type="button" class="btn btn-info" id="modepost"
                                            value="Make Decision"></td>
                                    </tr>
                                </table>
                            </form>
                        </body>
                        </html>

HTML Server
^^^^^^^^^^^

         .. container:: sect1

            .. container:: sectionbody

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        <!--
                          ============LICENSE_START=======================================================
                           Copyright (C) 2016-2018 Ericsson. All rights reserved.
                          ================================================================================
                          Licensed under the Apache License, Version 2.0 (the "License");
                          you may not use this file except in compliance with the License.
                          You may obtain a copy of the License at

                               http://www.apache.org/licenses/LICENSE-2.0

                          Unless required by applicable law or agreed to in writing, software
                          distributed under the License is distributed on an "AS IS" BASIS,
                          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                          See the License for the specific language governing permissions and
                          limitations under the License.

                          SPDX-License-Identifier: Apache-2.0
                          ============LICENSE_END=========================================================
                        -->

                        <!-- http://localhost:23324/apex/eventInput/EventIn -->

                        <html>
                        <head>
                        <script src="http://code.jquery.com/jquery-latest.js"></script>
                        <script>
                            $(document).ready(function() {
                                $("#answerspost").click(function(e) {
                                    var elements = document.getElementById("answerform").elements;

                                    var formValues = new Object;
                                    formValues["name"] = "AnswerEvent";
                                    for (var i = 0, element; element = elements[i++];) {
                                        if (element.type === "text" && element.value != "") {
                                            formValues[element.name] = element.value;
                                        }
                                    }
                                    console.log(formValues);
                                    var stringifiedForm = JSON.stringify(formValues);
                                    console.log(stringifiedForm);
                                    $.ajax({
                                        type : "POST",
                                        url : "http://localhost:23324/apex/RESTConsumer/EventIn",
                                        data : stringifiedForm,
                                        crossDomain : true,
                                        contentType : "application/json; charset=utf-8",
                                        success : function(data) {
                                            alert("Answers Set Successfully !!!");
                                        },
                                        failure : function(errMsg) {
                                            alert(errMsg);
                                        }
                                    });
                                    e.preventDefault(); //STOP default action

                                });
                            });
                        </script>
                        <script>
                            $(document).ready(function() {
                                $("#modepost").click(function(e) {
                                    var elements = document.getElementById("modeform").elements;

                                    var formValues = new Object;
                                    formValues["name"] = "MakeDecisionEvent";
                                    for (var i = 0, element; element = elements[i++];) {
                                        if (element.type === "radio" && element.checked) {
                                            formValues[element.name] = element.value;
                                        }
                                    }
                                    console.log(formValues);
                                    var stringifiedForm = JSON.stringify(formValues);
                                    console.log(stringifiedForm);
                                    $.ajax({
                                        type : "POST",
                                        url : "http://localhost:23324/apex/RESTConsumer/EventIn",
                                        data : stringifiedForm,
                                        crossDomain : true,
                                        contentType : "application/json; charset=utf-8",
                                        success : function(data) {
                                            alert("Decision Taken: " + data.decision);
                                        },
                                        failure : function(errMsg) {
                                            alert(errMsg);
                                        }
                                    });
                                    e.preventDefault(); //STOP default action

                                });
                            });
                        </script>
                        </head>
                        <body>
                            <h3>Decision Maker Answers</h3>
                            <form name="answerform" id="answerform" method="POST">
                                <table>
                                    <tr>
                                        <td>First Answer:</td>
                                        <td><input type="text" name="a0" value="Never Ever" /></td>
                                    </tr>
                                    <tr>
                                        <td>Second Answer:</td>
                                        <td><input type="text" name="a1" value="No" /></td>
                                    </tr>
                                    <tr>
                                        <td>Third Answer:</td>
                                        <td><input type="text" name="a2" value="Maybe not" /></td>
                                    </tr>
                                    <tr>
                                        <td>Fourth Answer</td>
                                        <td><input type="text" name="a3" value="Wait" /></td>
                                    </tr>
                                    <tr>
                                        <td>Fifth Answer:</td>
                                        <td><input type="text" name="a4" value="Maybe" /></td>
                                    </tr>
                                    <tr>
                                        <td>Sixth Answer:</td>
                                        <td><input type="text" name="a5" value="Yes" /></td>
                                    </tr>
                                    <tr>
                                        <td>Seventh Answer:</td>
                                        <td><input type="text" name="a6" value="Absolutely" /></td>
                                    </tr>
                                    <tr>
                                        <td />
                                        <td><input type="button" class="btn btn-info" id="answerspost"
                                            value="Set Answers"></td>
                                    </tr>
                                </table>
                            </form>
                            <h3>Decision Maker Mode</h3>
                            <form name="modeform" id="modeform" method="POST">
                                <table>
                                    <tr>
                                        <td><input name="mode" type="radio" value="random"
                                            checked="checked">random</td>
                                        <td><input name="mode" type="radio" value="pessimistic">pessimistic</td>
                                        <td><input name="mode" type="radio" value="optimistic">
                                            optimistic</td>
                                        <td><input name="mode" type="radio" value="dithering">dithering</td>
                                    </tr>
                                    <tr>
                                        <td />
                                        <td />
                                        <td />
                                        <td><input type="button" class="btn btn-info" id="modepost"
                                            value="Make Decision"></td>
                                    </tr>
                                </table>
                            </form>
                        </body>
                        </html>

HTML Client: Extra Mode
^^^^^^^^^^^^^^^^^^^^^^^

         .. container:: sect1

            .. container:: sectionbody

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        <!--
                          ============LICENSE_START=======================================================
                           Copyright (C) 2016-2018 Ericsson. All rights reserved.
                          ================================================================================
                          Licensed under the Apache License, Version 2.0 (the "License");
                          you may not use this file except in compliance with the License.
                          You may obtain a copy of the License at

                               http://www.apache.org/licenses/LICENSE-2.0

                          Unless required by applicable law or agreed to in writing, software
                          distributed under the License is distributed on an "AS IS" BASIS,
                          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                          See the License for the specific language governing permissions and
                          limitations under the License.

                          SPDX-License-Identifier: Apache-2.0
                          ============LICENSE_END=========================================================
                        -->

                        <!-- http://localhost:3904/events/toApex -->

                        <html>
                        <head>
                        <script src="http://code.jquery.com/jquery-latest.js"></script>
                        <script>
                            $(document).ready(function() {
                                $("#answerspost").click(function(e) {
                                    var elements = document.getElementById("answerform").elements;

                                    var formValues = new Object;
                                    formValues["name"] = "AnswerEvent";
                                    for (var i = 0, element; element = elements[i++];) {
                                        if (element.type === "text" && element.value != "") {
                                            formValues[element.name] = element.value;
                                        }
                                    }
                                    console.log(formValues);
                                    var stringifiedForm = JSON.stringify(formValues);
                                    console.log(stringifiedForm);
                                    $.ajax({
                                        type : "POST",
                                        url : "http://localhost:3904/events/toApex",
                                        data : stringifiedForm,
                                        crossDomain : true,
                                        contentType : "application/json; charset=utf-8",
                                        success : function(data) {
                                            alert("Answers Set Successfully !!!");
                                        },
                                        failure : function(errMsg) {
                                            alert(errMsg);
                                        }
                                    });
                                    e.preventDefault(); //STOP default action

                                });
                            });
                        </script>
                        <script>
                            $(document).ready(function() {
                                $("#modepost").click(function(e) {
                                    var elements = document.getElementById("modeform").elements;

                                    var formValues = new Object;
                                    formValues["name"] = "MakeDecisionEvent";
                                    for (var i = 0, element; element = elements[i++];) {
                                        if (element.type === "radio" && element.checked) {
                                            formValues[element.name] = element.value;
                                        }
                                    }
                                    console.log(formValues);
                                    var stringifiedForm = JSON.stringify(formValues);
                                    console.log(stringifiedForm);
                                    $.ajax({
                                        type : "POST",
                                        url : "http://localhost:3904/events/toApex",
                                        data : stringifiedForm,
                                        crossDomain : true,
                                        contentType : "application/json; charset=utf-8",
                                        success : function(data) {
                                            alert("Decision Taken: " + data.decision);
                                        },
                                        failure : function(errMsg) {
                                            alert(errMsg);
                                        }
                                    });
                                    e.preventDefault(); //STOP default action

                                });
                            });
                        </script>
                        </head>
                        <body>
                            <h3>Decision Maker Answers</h3>
                            <form name="answerform" id="answerform" method="POST">
                                <table>
                                    <tr>
                                        <td>First Answer:</td>
                                        <td><input type="text" name="a0" value="Never Ever" /></td>
                                    </tr>
                                    <tr>
                                        <td>Second Answer:</td>
                                        <td><input type="text" name="a1" value="No" /></td>
                                    </tr>
                                    <tr>
                                        <td>Third Answer:</td>
                                        <td><input type="text" name="a2" value="Maybe not" /></td>
                                    </tr>
                                    <tr>
                                        <td>Fourth Answer</td>
                                        <td><input type="text" name="a3" value="Wait" /></td>
                                    </tr>
                                    <tr>
                                        <td>Fifth Answer:</td>
                                        <td><input type="text" name="a4" value="Maybe" /></td>
                                    </tr>
                                    <tr>
                                        <td>Sixth Answer:</td>
                                        <td><input type="text" name="a5" value="Yes" /></td>
                                    </tr>
                                    <tr>
                                        <td>Seventh Answer:</td>
                                        <td><input type="text" name="a6" value="Absolutely" /></td>
                                    </tr>
                                    <tr>
                                        <td />
                                        <td><input type="button" class="btn btn-info" id="answerspost"
                                            value="Set Answers"></td>
                                    </tr>
                                </table>
                            </form>
                            <h3>Decision Maker Mode</h3>
                            <form name="modeform" id="modeform" method="POST">
                                <table>
                                    <tr>
                                        <td><input name="mode" type="radio" value="random"
                                            checked="checked">random</td>
                                        <td><input name="mode" type="radio" value="pessimistic">pessimistic</td>
                                        <td><input name="mode" type="radio" value="optimistic">
                                            optimistic</td>
                                        <td><input name="mode" type="radio" value="dithering">dithering</td>
                                        <td><input name="mode" type="radio" value="roundrobin">round
                                            robin</td>
                                    </tr>
                                    <tr>
                                        <td />
                                        <td />
                                        <td />
                                        <td />
                                        <td><input type="button" class="btn btn-info" id="modepost"
                                            value="Make Decision"></td>
                                    </tr>
                                </table>
                            </form>
                        </body>
                        </html>


HTML Client: Extra Mode
^^^^^^^^^^^^^^^^^^^^^^^

         .. container:: sect1

            .. container:: sectionbody

               .. container:: listingblock

                  .. container:: content

                     .. code:: CodeRay

                        <!--
                          ============LICENSE_START=======================================================
                           Copyright (C) 2016-2018 Ericsson. All rights reserved.
                          ================================================================================
                          Licensed under the Apache License, Version 2.0 (the "License");
                          you may not use this file except in compliance with the License.
                          You may obtain a copy of the License at

                               http://www.apache.org/licenses/LICENSE-2.0

                          Unless required by applicable law or agreed to in writing, software
                          distributed under the License is distributed on an "AS IS" BASIS,
                          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                          See the License for the specific language governing permissions and
                          limitations under the License.

                          SPDX-License-Identifier: Apache-2.0
                          ============LICENSE_END=========================================================
                        -->

                        <!-- http://localhost:23324/apex/EventIn -->

                        <html>
                        <head>
                        <script src="http://code.jquery.com/jquery-latest.js"></script>
                        <script>
                            $(document).ready(function() {
                                $("#answerspost").click(function(e) {
                                    var elements = document.getElementById("answerform").elements;

                                    var formValues = new Object;
                                    formValues["name"] = "AnswerEvent";
                                    for (var i = 0, element; element = elements[i++];) {
                                        if (element.type === "text" && element.value != "") {
                                            formValues[element.name] = element.value;
                                        }
                                    }
                                    console.log(formValues);
                                    var stringifiedForm = JSON.stringify(formValues);
                                    console.log(stringifiedForm);
                                    $.ajax({
                                        type : "POST",
                                        url : "http://localhost:23324/apex/RESTConsumer/EventIn",
                                        data : stringifiedForm,
                                        crossDomain : true,
                                        contentType : "application/json; charset=utf-8",
                                        success : function(data) {
                                            alert("Answers Set Successfully !!!");
                                        },
                                        failure : function(errMsg) {
                                            alert(errMsg);
                                        }
                                    });
                                    e.preventDefault(); //STOP default action

                                });
                            });
                        </script>
                        <script>
                            $(document).ready(function() {
                                $("#modepost").click(function(e) {
                                    var elements = document.getElementById("modeform").elements;

                                    var formValues = new Object;
                                    formValues["name"] = "MakeDecisionEvent";
                                    for (var i = 0, element; element = elements[i++];) {
                                        if (element.type === "radio" && element.checked) {
                                            formValues[element.name] = element.value;
                                        }
                                    }
                                    console.log(formValues);
                                    var stringifiedForm = JSON.stringify(formValues);
                                    console.log(stringifiedForm);
                                    $.ajax({
                                        type : "POST",
                                        url : "http://localhost:23324/apex/RESTConsumer/EventIn",
                                        data : stringifiedForm,
                                        crossDomain : true,
                                        contentType : "application/json; charset=utf-8",
                                        success : function(data) {
                                           alert("Decision Taken: " + data.decision);
                                        },
                                        failure : function(errMsg) {
                                            alert(errMsg);
                                        }
                                    });
                                    e.preventDefault(); //STOP default action

                                });
                            });
                        </script>
                        </head>
                        <body>
                            <h3>Decision Maker Answers</h3>
                            <form name="answerform" id="answerform" method="POST">
                                <table>
                                    <tr>
                                        <td>First Answer:</td>
                                        <td><input type="text" name="a0" value="Never Ever" /></td>
                                    </tr>
                                    <tr>
                                        <td>Second Answer:</td>
                                        <td><input type="text" name="a1" value="No" /></td>
                                    </tr>
                                    <tr>
                                        <td>Third Answer:</td>
                                        <td><input type="text" name="a2" value="Maybe not" /></td>
                                    </tr>
                                    <tr>
                                        <td>Fourth Answer</td>
                                        <td><input type="text" name="a3" value="Wait" /></td>
                                    </tr>
                                    <tr>
                                        <td>Fifth Answer:</td>
                                        <td><input type="text" name="a4" value="Maybe" /></td>
                                    </tr>
                                    <tr>
                                        <td>Sixth Answer:</td>
                                        <td><input type="text" name="a5" value="Yes" /></td>
                                    </tr>
                                    <tr>
                                        <td>Seventh Answer:</td>
                                        <td><input type="text" name="a6" value="Absolutely" /></td>
                                    </tr>
                                    <tr>
                                        <td />
                                        <td><input type="button" class="btn btn-info" id="answerspost"
                                            value="Set Answers"></td>
                                    </tr>
                                </table>
                            </form>
                            <h3>Decision Maker Mode</h3>
                            <form name="modeform" id="modeform" method="POST">
                                <table>
                                    <tr>
                                        <td><input name="mode" type="radio" value="random"
                                            checked="checked">random</td>
                                        <td><input name="mode" type="radio" value="pessimistic">pessimistic</td>
                                        <td><input name="mode" type="radio" value="optimistic">
                                            optimistic</td>
                                        <td><input name="mode" type="radio" value="dithering">dithering</td>
                                        <td><input name="mode" type="radio" value="roundrobin">round
                                            robin</td>
                                    </tr>
                                    <tr>
                                        <td />
                                        <td />
                                        <td />
                                        <td />
                                        <td><input type="button" class="btn btn-info" id="modepost"
                                            value="Make Decision"></td>
                                    </tr>
                                </table>
                            </form>
                        </body>
                        </html>


APEX Model (Policies)
^^^^^^^^^^^^^^^^^^^^^

         .. container:: sect1

            .. container:: sectionbody

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

                        model create name=DecisionMakerPolicyModel

                        schema create name=SimpleStringType  flavour=Java schema=java.lang.String
                        schema create name=SimpleIntegerType flavour=Java schema=java.lang.Integer

                        album create name=AnswerAlbum scope=policy writable=true schemaName=SimpleStringType
                        album create name=LastAnswerAlbum scope=policy writable=true schemaName=SimpleIntegerType

                        event create name=AnswerEvent nameSpace=org.onap.policy.apex.domains.decisionmaker source=DCAE target=apex
                        event parameter create name=AnswerEvent parName=a0 schemaName=SimpleStringType
                        event parameter create name=AnswerEvent parName=a1 schemaName=SimpleStringType
                        event parameter create name=AnswerEvent parName=a2 schemaName=SimpleStringType
                        event parameter create name=AnswerEvent parName=a3 schemaName=SimpleStringType
                        event parameter create name=AnswerEvent parName=a4 schemaName=SimpleStringType
                        event parameter create name=AnswerEvent parName=a5 schemaName=SimpleStringType
                        event parameter create name=AnswerEvent parName=a6 schemaName=SimpleStringType

                        event create name=MakeDecisionEvent nameSpace=org.onap.policy.apex.domains.decisionmaker source=DCAE target=apex
                        event parameter create name=MakeDecisionEvent parName=mode schemaName=SimpleStringType

                        event create name=DecisionEvent nameSpace=org.onap.policy.apex.domains.decisionmaker source=DCAE target=apex
                        event parameter create name=DecisionEvent parName=decision schemaName=SimpleStringType

                        task create name=AnswerInitTask
                        task inputfield create name=AnswerInitTask fieldName=a0 schemaName=SimpleStringType
                        task inputfield create name=AnswerInitTask fieldName=a1 schemaName=SimpleStringType
                        task inputfield create name=AnswerInitTask fieldName=a2 schemaName=SimpleStringType
                        task inputfield create name=AnswerInitTask fieldName=a3 schemaName=SimpleStringType
                        task inputfield create name=AnswerInitTask fieldName=a4 schemaName=SimpleStringType
                        task inputfield create name=AnswerInitTask fieldName=a5 schemaName=SimpleStringType
                        task inputfield create name=AnswerInitTask fieldName=a6 schemaName=SimpleStringType

                        task outputfield create name=AnswerInitTask fieldName=a0 schemaName=SimpleStringType
                        task outputfield create name=AnswerInitTask fieldName=a1 schemaName=SimpleStringType
                        task outputfield create name=AnswerInitTask fieldName=a2 schemaName=SimpleStringType
                        task outputfield create name=AnswerInitTask fieldName=a3 schemaName=SimpleStringType
                        task outputfield create name=AnswerInitTask fieldName=a4 schemaName=SimpleStringType
                        task outputfield create name=AnswerInitTask fieldName=a5 schemaName=SimpleStringType
                        task outputfield create name=AnswerInitTask fieldName=a6 schemaName=SimpleStringType

                        task contextref create name=AnswerInitTask albumName=AnswerAlbum
                        task contextref create name=AnswerInitTask albumName=LastAnswerAlbum

                        task logic create name=AnswerInitTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/logic/AnswerInitTask.js"
                        LE

                        task create name=RandomAnswerTask

                        task inputfield create name=RandomAnswerTask fieldName=mode schemaName=SimpleStringType

                        task outputfield create name=RandomAnswerTask fieldName=decision schemaName=SimpleStringType

                        task contextref create name=RandomAnswerTask albumName=AnswerAlbum

                        task logic create name=RandomAnswerTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/logic/RandomAnswerTask.js"
                        LE

                        task create name=PessimisticAnswerTask

                        task inputfield create name=PessimisticAnswerTask fieldName=mode schemaName=SimpleStringType

                        task outputfield create name=PessimisticAnswerTask fieldName=decision schemaName=SimpleStringType

                        task contextref create name=PessimisticAnswerTask albumName=AnswerAlbum

                        task logic create name=PessimisticAnswerTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/logic/PessimisticAnswerTask.js"
                        LE

                        task create name=OptimisticAnswerTask

                        task inputfield create name=OptimisticAnswerTask fieldName=mode schemaName=SimpleStringType

                        task outputfield create name=OptimisticAnswerTask fieldName=decision schemaName=SimpleStringType

                        task contextref create name=OptimisticAnswerTask albumName=AnswerAlbum

                        task logic create name=OptimisticAnswerTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/logic/OptimisticAnswerTask.js"
                        LE

                        task create name=DitheringAnswerTask

                        task inputfield create name=DitheringAnswerTask fieldName=mode schemaName=SimpleStringType

                        task outputfield create name=DitheringAnswerTask fieldName=decision schemaName=SimpleStringType

                        task contextref create name=DitheringAnswerTask albumName=AnswerAlbum

                        task logic create name=DitheringAnswerTask logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/logic/DitheringAnswerTask.js"
                        LE

                        #task create name=RoundRobinAnswerTask
                        #
                        #task inputfield create name=RoundRobinAnswerTask fieldName=mode schemaName=SimpleStringType
                        #
                        #task outputfield create name=RoundRobinAnswerTask fieldName=decision schemaName=SimpleStringType
                        #
                        #task contextref create name=RoundRobinAnswerTask albumName=AnswerAlbum
                        #task contextref create name=RoundRobinAnswerTask albumName=LastAnswerAlbum
                        #
                        #task logic create name=RoundRobinAnswerTask logicFlavour=JAVASCRIPT logic=LS
                        ##MACROFILE:"src/main/resources/logic/RoundRobinAnswerTask.js"
                        #LE

                        policy create name=AnswerInitPolicy template=freestyle firstState=AnswerInitState

                        policy state create name=AnswerInitPolicy stateName=AnswerInitState triggerName=AnswerEvent defaultTaskName=AnswerInitTask
                        policy state output create name=AnswerInitPolicy stateName=AnswerInitState outputName=AnswerInitOutput eventName=AnswerEvent
                        policy state taskref create name=AnswerInitPolicy stateName=AnswerInitState taskName=AnswerInitTask outputType=DIRECT outputName=AnswerInitOutput

                        policy create name=DecisionMakerPolicy template=freestyle firstState=MakeDecisionState

                        policy state create name=DecisionMakerPolicy stateName=MakeDecisionState triggerName=MakeDecisionEvent defaultTaskName=RandomAnswerTask
                        policy state output create name=DecisionMakerPolicy stateName=MakeDecisionState outputName=DecisionFinalOutput eventName=DecisionEvent
                        policy state taskref create name=DecisionMakerPolicy stateName=MakeDecisionState taskName=RandomAnswerTask outputType=DIRECT outputName=DecisionFinalOutput
                        policy state taskref create name=DecisionMakerPolicy stateName=MakeDecisionState taskName=PessimisticAnswerTask outputType=DIRECT outputName=DecisionFinalOutput
                        policy state taskref create name=DecisionMakerPolicy stateName=MakeDecisionState taskName=OptimisticAnswerTask outputType=DIRECT outputName=DecisionFinalOutput
                        policy state taskref create name=DecisionMakerPolicy stateName=MakeDecisionState taskName=DitheringAnswerTask outputType=DIRECT outputName=DecisionFinalOutput
                        #policy state taskref create name=DecisionMakerPolicy stateName=MakeDecisionState taskName=RoundRobinAnswerTask outputType=DIRECT outputName=DecisionFinalOutput

                        policy state selecttasklogic create name=DecisionMakerPolicy stateName=MakeDecisionState logicFlavour=JAVASCRIPT logic=LS
                        #MACROFILE:"src/main/resources/logic/MakeDecisionStateTSL.js"
                        LE

                        validate

Task Logic: Answer Init
-----------------------

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

                        executor.logger.info(executor.subject.id);
                        executor.logger.info(executor.inFields);

                        var answerAlbum = executor.getContextAlbum("AnswerAlbum");

                        answerAlbum.put("a0", executor.inFields.get("a0"));
                        answerAlbum.put("a1", executor.inFields.get("a1"));
                        answerAlbum.put("a2", executor.inFields.get("a2"));
                        answerAlbum.put("a3", executor.inFields.get("a3"));
                        answerAlbum.put("a4", executor.inFields.get("a4"));
                        answerAlbum.put("a5", executor.inFields.get("a5"));
                        answerAlbum.put("a6", executor.inFields.get("a6"));

                        var lastAnswerAlbum = executor.getContextAlbum("LastAnswerAlbum");
                        lastAnswerAlbum.put("lastAnswer", answerAlbum.size() - 1);

                        executor.outFields.put("a0", answerAlbum.get("a0"));
                        executor.outFields.put("a1", answerAlbum.get("a1"));
                        executor.outFields.put("a2", answerAlbum.get("a2"));
                        executor.outFields.put("a3", answerAlbum.get("a3"));
                        executor.outFields.put("a4", answerAlbum.get("a4"));
                        executor.outFields.put("a5", answerAlbum.get("a5"));
                        executor.outFields.put("a6", answerAlbum.get("a6"));

                        executor.logger.info(executor.outFields);

                        var returnValue = executor.isTrue;

Task Logic: Dithering Answer
----------------------------

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

                        executor.logger.info(executor.subject.id);
                        executor.logger.info(executor.inFields);

                        var size = executor.getContextAlbum("AnswerAlbum").size();

                        var selection = 2 + Math.floor(Math.random() * 3);

                        var selectionA = "a" + selection;

                        executor.logger.info(size);
                        executor.logger.info(selectionA);

                        executor.outFields.put("decision", executor.getContextAlbum("AnswerAlbum").get(selectionA));

                        executor.logger.info(executor.outFields);

                        var returnValue = executor.isTrue;


Task Selection Logic: Make Decision State
------------------------------------------

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

                        executor.logger.info(executor.subject.id);
                        executor.logger.info(executor.inFields);

                        var returnValue = executor.isTrue;

                        if (executor.inFields.get("mode").equals("random")) {
                            executor.subject.getTaskKey("RandomAnswerTask").copyTo(executor.selectedTask);
                        }
                        else if (executor.inFields.get("mode").equals("pessimistic")) {
                            executor.subject.getTaskKey("PessimisticAnswerTask").copyTo(executor.selectedTask);
                        }
                        else if (executor.inFields.get("mode").equals("optimistic")) {
                            executor.subject.getTaskKey("OptimisticAnswerTask").copyTo(executor.selectedTask);
                        }
                        else if (executor.inFields.get("mode").equals("dithering")) {
                            executor.subject.getTaskKey("DitheringAnswerTask").copyTo(executor.selectedTask);
                        }
                        //else if (executor.inFields.get("mode").equals("roundrobin")) {
                        //    executor.subject.getTaskKey("RoundRobinAnswerTask").copyTo(executor.selectedTask);
                        //}

                        executor.logger.info("Answer Selected Task:" + executor.selectedTask);

Task Logic: Optimistic Answer
-----------------------------

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

                        executor.logger.info(executor.subject.id);
                        executor.logger.info(executor.inFields);

                        var size = executor.getContextAlbum("AnswerAlbum").size();

                        var selection = size - Math.floor(Math.random() * size / 2) - 1;

                        var selectionA = "a" + selection;

                        executor.logger.info(size);
                        executor.logger.info(selectionA);

                        executor.outFields.put("decision", executor.getContextAlbum("AnswerAlbum").get(selectionA));

                        executor.logger.info(executor.outFields);

                        var returnValue = executor.isTrue;

Task Logic: Pessimistic Answer
------------------------------

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

                        executor.logger.info(executor.subject.id);
                        executor.logger.info(executor.inFields);

                        var size = executor.getContextAlbum("AnswerAlbum").size();

                        var selection = Math.floor(Math.random() * size / 2);

                        var selectionA = "a" + selection;

                        executor.logger.info(size);
                        executor.logger.info(selectionA);

                        executor.outFields.put("decision", executor.getContextAlbum("AnswerAlbum").get(selectionA));

                        executor.logger.info(executor.outFields);

                        var returnValue = executor.isTrue;

Task Logic: Random Answer
-------------------------

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

                        executor.logger.info(executor.subject.id);
                        executor.logger.info(executor.inFields);

                        var size = executor.getContextAlbum("AnswerAlbum").size();

                        var selection = Math.floor(Math.random() * size);

                        var selectionA = "a" + selection;

                        executor.logger.info(size);
                        executor.logger.info(selectionA);

                        executor.outFields.put("decision", executor.getContextAlbum("AnswerAlbum").get(selectionA));

                        executor.logger.info(executor.outFields);

                        var returnValue = executor.isTrue;

Task Logic: RoundRobin Answer
-----------------------------

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

                        executor.logger.info(executor.subject.id);
                        executor.logger.info(executor.inFields);

                        var size = executor.getContextAlbum("AnswerAlbum").size();
                        var lastAnswer = executor.getContextAlbum("LastAnswerAlbum").get("lastAnswer");

                        executor.logger.info(size);
                        executor.logger.info(lastAnswer);

                        var answer = ++lastAnswer;
                        if (answer >= size) {
                            answer = 0;
                        }

                        executor.getContextAlbum("LastAnswerAlbum").put("lastAnswer", answer)

                        var selectionA = "a" + answer;

                        executor.logger.info(selectionA);

                        executor.outFields.put("decision", executor.getContextAlbum("AnswerAlbum").get(selectionA));

                        executor.logger.info(executor.outFields);

                        var returnValue = executor.isTrue;


   .. container::
      :name: footer-text

      2.3.0-SNAPSHOT
      Last updated 2020-04-03 16:04:24 IST

.. |File > New to create a new Policy Model| image:: images/mfp/MyFirstPolicy_P1_newPolicyModel1.png
.. |Create a new Policy Model| image:: images/mfp/MyFirstPolicy_P1_newPolicyModel2.png
.. |ONAP| image:: ../../../images/logos.png
   :class: builtBy
   :target: http://www.onap.org/
.. |Right click to create a new event| image:: images/mfp/MyFirstPolicy_P1_newEvent1.png
.. |Fill in the necessary information for the 'SALE_INPUT' event and click 'Submit'| image:: images/mfp/MyFirstPolicy_P1_newEvent2.png
.. |Right click to create a new Item Schema| image:: images/mfp/MyFirstPolicy_P1_newItemSchema1.png
.. |Create a new Item Schema| image:: images/mfp/MyFirstPolicy_P1_newItemSchema2.png
.. |Add new event parameters to an event| image:: images/mfp/MyFirstPolicy_P1_newEvent3.png
.. |Right click to create a new task| image:: images/mfp/MyFirstPolicy_P1_newTask1.png
.. |Add input and out fields for the task| image:: images/mfp/MyFirstPolicy_P1_newTask2.png
.. |Add task logic the task| image:: images/mfp/MyFirstPolicy_P1_newTask3.png
.. |Create a new policy| image:: images/mfp/MyFirstPolicy_P1_newPolicy1.png
.. |Create a state| image:: images/mfp/MyFirstPolicy_P1_newState1.png
.. |Add a Task and Output Mapping| image:: images/mfp/MyFirstPolicy_P1_newState2.png
.. |Validate the policy model for error using the 'Model' > 'Validate' menu item| image:: images/mfp/MyFirstPolicy_P1_validatePolicyModel.png
.. |Download the completed policy model using the 'File' > 'Download' menu item| image:: images/mfp/MyFirstPolicy_P1_exportPolicyModel1.png
.. |Create a new alternative task \`MorningBoozeCheckAlt1\`| image:: images/mfp/MyFirstPolicy_P2_newTask1.png
.. |Right click to edit a policy| image:: images/mfp/MyFirstPolicy_P2_editPolicy1.png
.. |State definition with 2 Tasks and Task Selection Logic| image:: images/mfp/MyFirstPolicy_P2_editState1.png


