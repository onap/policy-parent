package org.onap.policy.tutorial.tutorial;

import java.util.Map;
import java.util.Map.Entry;
import org.onap.policy.models.decisions.concepts.DecisionRequest;
import com.att.research.xacml.std.annotations.XACMLAction;
import com.att.research.xacml.std.annotations.XACMLRequest;
import com.att.research.xacml.std.annotations.XACMLResource;
import com.att.research.xacml.std.annotations.XACMLSubject;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

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
