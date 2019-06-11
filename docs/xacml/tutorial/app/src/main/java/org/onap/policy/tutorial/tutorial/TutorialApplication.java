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
