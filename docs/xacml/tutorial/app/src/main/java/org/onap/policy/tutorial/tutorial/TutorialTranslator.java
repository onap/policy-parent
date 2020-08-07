/*-
 * ============LICENSE_START=======================================================
 * Copyright (C) 2020 AT&T Intellectual Property. All rights reserved.
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
 * ============LICENSE_END=========================================================
 */

package org.onap.policy.tutorial.tutorial;

import java.util.List;
import java.util.Map;
import org.onap.policy.models.decisions.concepts.DecisionRequest;
import org.onap.policy.models.decisions.concepts.DecisionResponse;
import org.onap.policy.models.tosca.authorative.concepts.ToscaPolicy;
import org.onap.policy.pdp.xacml.application.common.ToscaDictionary;
import org.onap.policy.pdp.xacml.application.common.ToscaPolicyConversionException;
import org.onap.policy.pdp.xacml.application.common.ToscaPolicyTranslator;
import org.onap.policy.pdp.xacml.application.common.ToscaPolicyTranslatorUtils;
import com.att.research.xacml.api.DataTypeException;
import com.att.research.xacml.api.Decision;
import com.att.research.xacml.api.Identifier;
import com.att.research.xacml.api.Request;
import com.att.research.xacml.api.Response;
import com.att.research.xacml.api.Result;
import com.att.research.xacml.api.XACML3;
import com.att.research.xacml.std.IdentifierImpl;
import com.att.research.xacml.std.annotations.RequestParser;
import oasis.names.tc.xacml._3_0.core.schema.wd_17.AnyOfType;
import oasis.names.tc.xacml._3_0.core.schema.wd_17.EffectType;
import oasis.names.tc.xacml._3_0.core.schema.wd_17.MatchType;
import oasis.names.tc.xacml._3_0.core.schema.wd_17.PolicyType;
import oasis.names.tc.xacml._3_0.core.schema.wd_17.RuleType;
import oasis.names.tc.xacml._3_0.core.schema.wd_17.TargetType;

public class TutorialTranslator implements ToscaPolicyTranslator {

    private static final Identifier ID_TUTORIAL_USER = new IdentifierImpl(ToscaDictionary.ID_URN_ONAP, "tutorial-user");
    private static final Identifier ID_TUTORIAL_ENTITY =
            new IdentifierImpl(ToscaDictionary.ID_URN_ONAP, "tutorial-entity");
    private static final Identifier ID_TUTORIAL_PERM = new IdentifierImpl(ToscaDictionary.ID_URN_ONAP, "tutorial-permission");

    @SuppressWarnings("unchecked")
	public PolicyType convertPolicy(ToscaPolicy toscaPolicy) throws ToscaPolicyConversionException {
        //
        // Here is our policy with a version and default combining algo
        //
        PolicyType newPolicyType = new PolicyType();
        newPolicyType.setPolicyId(toscaPolicy.getMetadata().get("policy-id"));
        newPolicyType.setVersion(toscaPolicy.getMetadata().get("policy-version"));
        //
        // When choosing the rule combining algorithm, be sure to be mindful of the
        // setting xacml.att.policyFinderFactory.combineRootPolicies in the
        // xacml.properties file. As that choice for ALL the policies together may have
        // an impact on the decision rendered from each individual policy.
        //
        // In this case, we will only produce XACML rules for permissions. If no permission
        // combo exists, then the default is to deny.
        //
        newPolicyType.setRuleCombiningAlgId(XACML3.ID_RULE_DENY_UNLESS_PERMIT.stringValue());
        //
        // Create the target for the Policy.
        //
        // For simplicity, let's just match on the action "authorize" and the user
        //
        MatchType matchAction = ToscaPolicyTranslatorUtils.buildMatchTypeDesignator(XACML3.ID_FUNCTION_STRING_EQUAL,
                "authorize", XACML3.ID_DATATYPE_STRING, XACML3.ID_ACTION_ACTION_ID, XACML3.ID_ATTRIBUTE_CATEGORY_ACTION);
        Map<String, Object> props = toscaPolicy.getProperties();
        String user = props.get("user").toString();
        MatchType matchUser = ToscaPolicyTranslatorUtils.buildMatchTypeDesignator(XACML3.ID_FUNCTION_STRING_EQUAL, user,
                XACML3.ID_DATATYPE_STRING, ID_TUTORIAL_USER, XACML3.ID_ATTRIBUTE_CATEGORY_RESOURCE);
        AnyOfType anyOf = new AnyOfType();
        //
        // Create AllOf (AND) of just Policy Id
        //
        anyOf.getAllOf().add(ToscaPolicyTranslatorUtils.buildAllOf(matchAction, matchUser));
        TargetType target = new TargetType();
        target.getAnyOf().add(anyOf);
        newPolicyType.setTarget(target);
        //
        // Now add the rule for each permission
        //
        int ruleNumber = 0;
        List<Object> permissions = (List<Object>) props.get("permissions");
        for (Object permission : permissions) {

            MatchType matchEntity = ToscaPolicyTranslatorUtils.buildMatchTypeDesignator(XACML3.ID_FUNCTION_STRING_EQUAL,
                    ((Map<String, String>) permission).get("entity"), XACML3.ID_DATATYPE_STRING, ID_TUTORIAL_ENTITY,
                    XACML3.ID_ATTRIBUTE_CATEGORY_RESOURCE);

            MatchType matchPermission = ToscaPolicyTranslatorUtils.buildMatchTypeDesignator(
                    XACML3.ID_FUNCTION_STRING_EQUAL, ((Map<String, String>) permission).get("permission"),
                    XACML3.ID_DATATYPE_STRING, ID_TUTORIAL_PERM, XACML3.ID_ATTRIBUTE_CATEGORY_RESOURCE);
            anyOf = new AnyOfType();
            anyOf.getAllOf().add(ToscaPolicyTranslatorUtils.buildAllOf(matchEntity, matchPermission));
            target = new TargetType();
            target.getAnyOf().add(anyOf);

            RuleType rule = new RuleType();
            rule.setDescription("Default is to PERMIT if the policy matches.");
            rule.setRuleId(newPolicyType.getPolicyId() + ":rule" + ruleNumber);

            rule.setEffect(EffectType.PERMIT);
            rule.setTarget(target);

            newPolicyType.getCombinerParametersOrRuleCombinerParametersOrVariableDefinition().add(rule);

            ruleNumber++;
        }
        return newPolicyType;
    }

    public Request convertRequest(DecisionRequest request) {
        try {
            return RequestParser.parseRequest(TutorialRequest.createRequest(request));
        } catch (IllegalArgumentException | IllegalAccessException | DataTypeException e) {
        }
        return null;
    }

    public DecisionResponse convertResponse(Response xacmlResponse) {
        DecisionResponse decisionResponse = new DecisionResponse();
        //
        // Iterate through all the results
        //
        for (Result xacmlResult : xacmlResponse.getResults()) {
            //
            // Check the result
            //
            if (xacmlResult.getDecision() == Decision.PERMIT) {
                //
                // Just simply return a Permit response
                //
                decisionResponse.setStatus(Decision.PERMIT.toString());
            } else {
                //
                // Just simply return a Deny response
                //
                decisionResponse.setStatus(Decision.DENY.toString());
            }
        }

        return decisionResponse;
    }

}
