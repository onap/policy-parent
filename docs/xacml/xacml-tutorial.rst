.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _xacmltutorial-label:

Policy XACML - Custom Application Tutorial
##########################################

.. toctree::
   :maxdepth: 3

This tutorial shows how to build a XACML application for a Policy Type. Please be sure to clone the
policy repositories before going through the tutorial. See :ref:`<policy-dev-label>` for details.


Design a Policy Type
********************
Follow :ref:`TOSCA Policy Primer <tosca-label>` for more information. For the tutorial, we will use
this example Policy Type in which an ONAP PEP client would like to enforce an action **authorize**
for a *user* to execute a *permission* on an *entity*.

.. literalinclude:: tutorial/tutorial-policy-type.yaml
  :language: JSON
  :caption: Example Tutorial Policy Type
  :linenos:

We would expect then to be able to create the following policies to allow the demo user to Read/Write
a entity called foo. While the audit user can only read the entity called foo. No user has Delete
permission.

.. literalinclude:: tutorial/tutorial-policies.yaml
  :language: JSON
  :caption: Example Policies Derived From Tutorial Policy Type
  :linenos:

Design Decision Request and expected Decision Response
******************************************************
For the PEP (Policy Enforcement Point) client applications that call the Decision API, you need
to design how the Decision API Request resource fields will be sent via the PEP.

.. literalinclude:: tutorial/tutorial-decision-request.json
  :language: JSON
  :caption: Example Decision Request
  :linenos:

For simplicity, we expect only a *Permit* or *Deny* in the Decision Response.

.. literalinclude:: tutorial/tutorial-decision-response.json
  :language: JSON
  :caption: Example Decision Response
  :linenos:

Create A Maven Project
**********************
This part of the tutorial assumes you understand how to use Eclipse to create a Maven
project. Please follow any examples for the Eclipse installation you have to create
an empty application. For the tutorial, use groupId *org.onap.policy.tutorial* and artifactId
*tutorial*.

.. image:: tutorial/images/eclipse-create-maven.png

.. image:: tutorial/images/eclipse-maven-project.png

Be sure to import the policy/xacml-pdp project into Eclipse.

.. image:: tutorial/images/eclipse-import.png

Add Dependencies Into Application pom.xml
*****************************************

.. code-block:: java
  :caption: pom.xml dependencies

    <dependency>
      <groupId>org.onap.policy.xacml-pdp.applications</groupId>
      <artifactId>common</artifactId>
      <version>2.1.0-SNAPSHOT</version>
    </dependency>


Create A Java Class That Extends **StdXacmlApplicationServiceProvider**
***********************************************************************
You could implement **XacmlApplicationServiceProvider** if you wish, but
for simplicity if you just extend **StdXacmlApplicationServiceProvider** you
will get a lot of implementation done for your application up front. All
that needs to be implemented is providing a custom translator.

.. image:: tutorial/images/eclipse-inherit-app.png

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




Use the TutorialTranslator in the TutorialApplication
*****************************************************
Be sure to go back to the TutorialApplication and create an instance of the translator to return to the
StdXacmlApplicationServiceProvider. The StdXacmlApplicationServiceProvider uses the translator to convert
a policy when a new policy is deployed to the ONAP XACML PDP Engine.

.. code-block:: java
  :caption: Final TutorialApplication Class
  :linenos:
  :emphasize-lines: 37

  package org.onap.policy.tutorial.tutorial;

  import java.util.Arrays;
  import java.util.List;

  import org.onap.policy.models.tosca.authorative.concepts.ToscaPolicyTypeIdentifier;
  import org.onap.policy.pdp.xacml.application.common.ToscaPolicyTranslator;
  import org.onap.policy.pdp.xacml.application.common.std.StdXacmlApplicationServiceProvider;

  public class TutorialApplication extends StdXacmlApplicationServiceProvider {
	
	private final ToscaPolicyTypeIdentifier supportedPolicyType = new ToscaPolicyTypeIdentifier();
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

Create xacml.properties for the XACML PDP engine to use
*******************************************************
In the applications *src/test/resources* directory, create a xacml.properties file that will be used by the embedded
XACML PDP Engine when loading.

.. literal-include:: tutorial-xacml.properties
  :caption: Example xacml.properties file
  :linenos:
  :emphasize-lines: 20, 25

For simplicity, the tutorial application is downloaded here :download:`link <xacml-tutorial.zip>`


