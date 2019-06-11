package org.onap.policy.tutorial.tutorial;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.ServiceLoader;

import org.apache.commons.lang3.tuple.Pair;
import org.junit.BeforeClass;
import org.junit.ClassRule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.onap.policy.common.utils.coder.CoderException;
import org.onap.policy.common.utils.coder.StandardCoder;
import org.onap.policy.common.utils.resources.TextFileUtils;
import org.onap.policy.models.decisions.concepts.DecisionRequest;
import org.onap.policy.models.decisions.concepts.DecisionResponse;
import org.onap.policy.models.tosca.authorative.concepts.ToscaPolicy;
import org.onap.policy.pdp.xacml.application.common.TestUtils;
import org.onap.policy.pdp.xacml.application.common.XacmlApplicationException;
import org.onap.policy.pdp.xacml.application.common.XacmlApplicationServiceProvider;
import org.onap.policy.pdp.xacml.application.common.XacmlPolicyUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.att.research.xacml.api.Response;

public class TutorialApplicationTest {
	private static final Logger LOGGER = LoggerFactory.getLogger(TutorialApplicationTest.class);
    private static Properties properties = new Properties();
    private static File propertiesFile;
    private static XacmlApplicationServiceProvider service;
    private static StandardCoder gson = new StandardCoder();

    @ClassRule
    public static final TemporaryFolder policyFolder = new TemporaryFolder();

    @BeforeClass
    public static void setup() throws Exception {
        //
        // Setup our temporary folder
        //
        XacmlPolicyUtils.FileCreator myCreator = (String filename) -> policyFolder.newFile(filename);
        propertiesFile = XacmlPolicyUtils.copyXacmlPropertiesContents("src/test/resources/xacml.properties",
                properties, myCreator);
        //
        // Load XacmlApplicationServiceProvider service
        //
        ServiceLoader<XacmlApplicationServiceProvider> applicationLoader =
                ServiceLoader.load(XacmlApplicationServiceProvider.class);
        //
        // Look for our class instance and save it
        //
        Iterator<XacmlApplicationServiceProvider> iterator = applicationLoader.iterator();
        while (iterator.hasNext()) {
            XacmlApplicationServiceProvider application = iterator.next();
            //
            // Is it our service?
            //
            if (application instanceof TutorialApplication) {
            	service = application;
            }
        }
        //
        // Tell the application to initialize based on the properties file
        // we just built for it.
        //
        service.initialize(propertiesFile.toPath().getParent());
	}
    
    @Test
    public void test() throws CoderException, XacmlApplicationException, IOException {
        //
        // Now load the tutorial policies.
        //
        TestUtils.loadPolicies("src/test/resources/tutorial-policies.yaml", service);
        //
        // Load a Decision request
        //
        DecisionRequest decisionRequest = gson.decode(
                TextFileUtils
                .getTextFileAsString("src/test/resources/tutorial-decision-request.json"),
                DecisionRequest.class);
    	//
        // Test a decision
        //
        Pair<DecisionResponse, Response> decision = service.makeDecision(decisionRequest);
        LOGGER.info(decision.getLeft().toString());
    }

}
