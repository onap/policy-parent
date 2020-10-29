.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _xacmltutorial-label:

Policy XACML - Custom Application Tutorial
##########################################

.. toctree::
   :maxdepth: 3

This tutorial shows how to build a XACML application for a Policy Type. Please be sure to clone the
policy repositories before going through the tutorial. See :ref:`policy-development-tools-label` for details.


Design a Policy Type
********************
Follow :ref:`TOSCA Policy Primer <tosca-label>` for more information. For the tutorial, we will use
this example Policy Type in which an ONAP PEP client would like to enforce an action **authorize**
for a *user* to execute a *permission* on an *entity*.

.. literalinclude:: tutorial/tutorial-policy-type.yaml
  :language: yaml
  :caption: Example Tutorial Policy Type
  :linenos:

:ref:`See here for latest Tutorial Policy Type <https://github.com/onap/policy-xacml-pdp/blob/master/tutorials/tutorial-xacml-application/src/test/resources/tutorial-policy-type.yaml>`__

We would expect then to be able to create the following policies to allow the demo user to Read/Write
an entity called foo, while the audit user can only read the entity called foo. Neither user has Delete
permission.

.. literalinclude:: tutorial/tutorial-policies.yaml
  :language: yaml
  :caption: Example Policies Derived From Tutorial Policy Type
  :linenos:

:ref:`See here for latest Tutorial Policies <https://github.com/onap/policy-xacml-pdp/blob/master/tutorials/tutorial-xacml-application/src/test/resources/tutorial-policies.yaml>`__

Design Decision Request and expected Decision Response
******************************************************
For the PEP (Policy Enforcement Point) client applications that call the Decision API, you need
to design how the Decision API Request resource fields will be sent via the PEP.

.. literalinclude:: tutorial/tutorial-decision-request.json
  :language: JSON
  :caption: Example Decision Request
  :linenos:

For simplicity, this tutorial expects only a *Permit* or *Deny* in the Decision Response. However, one could
customize the Decision Response object and send back whatever information is desired.

.. literalinclude:: tutorial/tutorial-decision-response.json
  :language: JSON
  :caption: Example Decision Response
  :linenos:

Create A Maven Project
**********************
Use whatever tool or environment to create your application project. This tutorial assumes you use Maven to build it.

Add Dependencies Into Application pom.xml
*****************************************

Here we import the XACML PDP Application common dependency which has the interfaces we need to implement. In addition,
we are importing a testing dependency that has common code for producing a JUnit test.

.. code-block:: java
  :caption: pom.xml dependencies

    <dependency>
      <groupId>org.onap.policy.xacml-pdp.applications</groupId>
      <artifactId>common</artifactId>
      <version>2.3.3</version>
    </dependency>
    <dependency>
      <groupId>org.onap.policy.xacml-pdp</groupId>
      <artifactId>xacml-test</artifactId>
      <version>2.3.3</version>
      <scope>test</scope>
    </dependency>

Create META-INF to expose Java Service
**************************************
The ONAP XACML PDP Engine will not be able to find the tutorial application unless it has
a property file located in src/main/resources/META-INF/services that contains a property file
declaring the class that implements the service.

The name of the file must match **org.onap.policy.pdp.xacml.application.common.XacmlApplicationServiceProvider**
and the contents of the file is one line **org.onap.policy.tutorial.tutorial.TutorialApplication**.

.. code-block:: java
  :caption: META-INF/services/org.onap.policy.pdp.xacml.application.common.XacmlApplicationServiceProvider

    org.onap.policy.tutorial.tutorial.TutorialApplication


Create A Java Class That Extends **StdXacmlApplicationServiceProvider**
***********************************************************************
You could implement **XacmlApplicationServiceProvider** if you wish, but
for simplicity if you just extend **StdXacmlApplicationServiceProvider** you
will get a lot of implementation done for your application up front. All
that needs to be implemented is providing a custom translator.

.. code-block:: java
  :caption: Custom Tutorial Application Service Provider
  :emphasize-lines: 6

  package org.onap.policy.tutorial.tutorial;

  import org.onap.policy.pdp.xacml.application.common.ToscaPolicyTranslator;
  import org.onap.policy.pdp.xacml.application.common.std.StdXacmlApplicationServiceProvider;

  public class TutorialApplication extends StdXacmlApplicationServiceProvider {

        @Override
        protected ToscaPolicyTranslator getTranslator(String type) {
                // TODO Auto-generated method stub
                return null;
        }

  }

Override Methods for Tutorial
*****************************
Override these methods to differentiate Tutorial from other applications so that the XACML PDP
Engine can determine how to route policy types and policies to the application.

.. code-block:: java
  :caption: Custom Tutorial Application Service Provider

  package org.onap.policy.tutorial.tutorial;

  import java.util.Arrays;
  import java.util.List;

  import org.onap.policy.models.tosca.authorative.concepts.ToscaPolicyTypeIdentifier;
  import org.onap.policy.pdp.xacml.application.common.ToscaPolicyTranslator;
  import org.onap.policy.pdp.xacml.application.common.std.StdXacmlApplicationServiceProvider;

  public class TutorialApplication extends StdXacmlApplicationServiceProvider {
	
    private final ToscaPolicyTypeIdentifier supportedPolicyType = new ToscaPolicyTypeIdentifier();

    @Override
    public String applicationName() {
        return "tutorial";
    }

    @Override
    public List<String> actionDecisionsSupported() {
        return Arrays.asList("authorize");
    }

    @Override
    public synchronized List<ToscaPolicyTypeIdentifier> supportedPolicyTypes() {
        return Arrays.asList(supportedPolicyType);
    }

    @Override
    public boolean canSupportPolicyType(ToscaPolicyTypeIdentifier policyTypeId) {
    	return supportedPolicyType.equals(policyTypeId);
    }

    @Override
        protected ToscaPolicyTranslator getTranslator(String type) {
        // TODO Auto-generated method stub
        return null;
    }

  }

Create A Translation Class that extends the ToscaPolicyTranslator Class
***********************************************************************
Please be sure to review the existing translators in the policy/xacml-pdp repo to see if they could
be re-used for your policy type. For the tutorial, we will create our own translator.

The custom translator is not only responsible for translating Policies derived from the Tutorial
Policy Type, but also for translating Decision API Requests/Responses to/from the appropriate XACML
requests/response objects the XACML engine understands.  

.. code-block:: java
  :caption: Custom Tutorial Translator Class

  package org.onap.policy.tutorial.tutorial;

  import org.onap.policy.models.decisions.concepts.DecisionRequest;
  import org.onap.policy.models.decisions.concepts.DecisionResponse;
  import org.onap.policy.models.tosca.authorative.concepts.ToscaPolicy;
  import org.onap.policy.pdp.xacml.application.common.ToscaPolicyConversionException;
  import org.onap.policy.pdp.xacml.application.common.ToscaPolicyTranslator;

  import com.att.research.xacml.api.Request;
  import com.att.research.xacml.api.Response;

  import oasis.names.tc.xacml._3_0.core.schema.wd_17.PolicyType;

  public class TutorialTranslator implements ToscaPolicyTranslator {

    public PolicyType convertPolicy(ToscaPolicy toscaPolicy) throws ToscaPolicyConversionException {
        // TODO Auto-generated method stub
        return null;
    }

    public Request convertRequest(DecisionRequest request) {
        // TODO Auto-generated method stub
        return null;
    }

    public DecisionResponse convertResponse(Response xacmlResponse) {
        // TODO Auto-generated method stub
        return null;
    }

  }

Implement the TutorialTranslator Methods
****************************************
This is the part where knowledge of the XACML OASIS 3.0 specification is required. Please refer to
that specification on the many ways to design a XACML Policy.

For the tutorial, we will build code that translates the TOSCA Policy into one XACML Policy that matches
on the user and action. It will then have one or more rules for each entity and permission combination. The
default combining algorithm for the XACML Rules are to "Deny Unless Permit".

.. Note::
  There are many ways to build the policy based on the attributes. How to do so is a matter of experience and
  fine tuning using the many options for combining algorithms, target and/or condition matching and the rich set of
  functions available.

:ref:`See the tutorial example <https://github.com/onap/policy-xacml-pdp/blob/master/tutorials/tutorial-xacml-application/src/main/java/org/onap/policy/tutorial/tutorial/TutorialTranslator.java>`__

Use the TutorialTranslator in the TutorialApplication
*****************************************************
Be sure to go back to the TutorialApplication and create an instance of the translator to return to the
StdXacmlApplicationServiceProvider. The StdXacmlApplicationServiceProvider uses the translator to convert
a policy when a new policy is deployed to the ONAP XACML PDP Engine.

.. code-block:: java
  :caption: Final TutorialApplication Class
  :linenos:
  :emphasize-lines: 38

    package org.onap.policy.tutorial.tutorial;

    import java.util.Arrays;
    import java.util.List;
    import org.onap.policy.models.tosca.authorative.concepts.ToscaPolicyTypeIdentifier;
    import org.onap.policy.pdp.xacml.application.common.ToscaPolicyTranslator;
    import org.onap.policy.pdp.xacml.application.common.std.StdXacmlApplicationServiceProvider;
    
    public class TutorialApplication extends StdXacmlApplicationServiceProvider {
    
        private final ToscaPolicyTypeIdentifier supportedPolicyType =
                new ToscaPolicyTypeIdentifier("onap.policies.Authorization", "1.0.0");
        private final TutorialTranslator translator = new TutorialTranslator();
    
        @Override
        public String applicationName() {
            return "tutorial";
        }
    
        @Override
        public List<String> actionDecisionsSupported() {
            return Arrays.asList("authorize");
        }
    
        @Override
        public synchronized List<ToscaPolicyTypeIdentifier> supportedPolicyTypes() {
            return Arrays.asList(supportedPolicyType);
        }
    
        @Override
        public boolean canSupportPolicyType(ToscaPolicyTypeIdentifier policyTypeId) {
            return supportedPolicyType.equals(policyTypeId);
        }
    
        @Override
        protected ToscaPolicyTranslator getTranslator(String type) {
            return translator;
        }
    
    }
    
:ref:`See the Tutorial Application Example <https://github.com/onap/policy-xacml-pdp/blob/master/tutorials/tutorial-xacml-application/src/main/java/org/onap/policy/tutorial/tutorial/TutorialApplication.java>`__

Create a XACML Request from ONAP Decision Request
*************************************************
The easiest way to do this is to use the annotations feature from XACML PDP library to create an example XACML
request. Then create an instance and simply populate it from an incoming ONAP Decision Request.

.. code-block:: java
  :caption: Final TutorialApplication Class
  :linenos:
    import com.att.research.xacml.std.annotations.XACMLAction;
    import com.att.research.xacml.std.annotations.XACMLRequest;
    import com.att.research.xacml.std.annotations.XACMLResource;
    import com.att.research.xacml.std.annotations.XACMLSubject;
    import java.util.Map;
    import java.util.Map.Entry;
    import lombok.Getter;
    import lombok.Setter;
    import lombok.ToString;
    import org.onap.policy.models.decisions.concepts.DecisionRequest;
    
    @Getter
    @Setter
    @ToString
    @XACMLRequest(ReturnPolicyIdList = true)
    public class TutorialRequest {
        @XACMLSubject(includeInResults = true)
        private String onapName;
    
        @XACMLSubject(attributeId = "urn:org:onap:onap-component", includeInResults = true)
        private String onapComponent;
    
        @XACMLSubject(attributeId = "urn:org:onap:onap-instance", includeInResults = true)
        private String onapInstance;
    
        @XACMLAction()
        private String action;
    
        @XACMLResource(attributeId = "urn:org:onap:tutorial-user", includeInResults = true)
        private String user;
    
        @XACMLResource(attributeId = "urn:org:onap:tutorial-entity", includeInResults = true)
        private String entity;
    
        @XACMLResource(attributeId = "urn:org:onap:tutorial-permission", includeInResults = true)
        private String permission;
    
        /**
         * createRequest.
         *
         * @param decisionRequest Incoming
         * @return TutorialRequest object
         */
        public static TutorialRequest createRequest(DecisionRequest decisionRequest) {
            //
            // Create our object
            //
            TutorialRequest request = new TutorialRequest();
            //
            // Add the subject attributes
            //
            request.onapName = decisionRequest.getOnapName();
            request.onapComponent = decisionRequest.getOnapComponent();
            request.onapInstance = decisionRequest.getOnapInstance();
            //
            // Add the action attribute
            //
            request.action = decisionRequest.getAction();
            //
            // Add the resource attributes
            //
            Map<String, Object> resources = decisionRequest.getResource();
            for (Entry<String, Object> entrySet : resources.entrySet()) {
                if ("user".equals(entrySet.getKey())) {
                    request.user = entrySet.getValue().toString();
                }
                if ("entity".equals(entrySet.getKey())) {
                    request.entity = entrySet.getValue().toString();
                }
                if ("permission".equals(entrySet.getKey())) {
                    request.permission = entrySet.getValue().toString();
                }
            }
    
            return request;
        }
    }

:ref:`See the Tutorial Request <https://github.com/onap/policy-xacml-pdp/blob/master/tutorials/tutorial-xacml-application/src/main/java/org/onap/policy/tutorial/tutorial/TutorialRequest.java>`__

Create a JUnit and use the TestUtils.java class in xacml-test dependency
************************************************************************
Be sure to create a JUnit that will test your translator and application code. You can utilize a TestUtils.java
class from the policy/xamcl-pdp repo's xacml-test submodule to use some utility methods for building the JUnit test.

Build the code and run the JUnit test. Its easiest to run it via a terminal command line using maven commands.

.. code-block:: bash
   :caption: Running Maven Commands
   :linenos:

   > mvn clean install

Building Docker Image
*********************
To build a docker image that incorporates your application with the XACML PDP Engine. The XACML PDP Engine
must be able to *find* your Java.Service in the classpath. This is easy to do, just create a jar file for your application
and copy into the same directory used to startup the XACML PDP.

Here is a Dockerfile as an example:

.. code-block:: bash
  :caption: Dockerfile
  :linenos:
  
    FROM onap/policy-xacml-pdp
    
    ADD maven/${project.build.finalName}.jar /opt/app/policy/pdpx/lib/${project.build.finalName}.jar
    
    RUN mkdir -p /opt/app/policy/pdpx/apps/tutorial
    
    COPY --chown=policy:policy xacml.properties /opt/app/policy/pdpx/apps/tutorial

Download Tutorial Application Example
*************************************

If you clone the XACML-PDP repo, the tutorial is included for local testing without building your own.

:ref:`Tutorial code located in xacml-pdp repo <https://github.com/onap/policy-xacml-pdp/tree/master/tutorials/tutorial-xacml-application>`__

There is an example Docker compose script that you can use to run the Policy Framework components locally and test the tutorial out.

:ref:`Docker compose script <https://github.com/onap/policy-xacml-pdp/blob/master/tutorials/tutorial-xacml-application/src/main/docker/docker-compose.yml>`__

In addition, there is a POSTMAN collection available for setting up and running tests against a
running instance of ONAP Policy Components (api, pap, dmaap-simulator, tutorial-xacml-pdp).

:ref:`POSTMAN collection for testing <https://github.com/onap/policy-xacml-pdp/blob/master/tutorials/tutorial-xacml-application/postman/PolicyApplicationTutorial.postman_collection.json>`__
