FROM onap/policy-xacml-pdp:2.2.2

ADD maven/${project.build.finalName}.jar /opt/app/policy/pdpx/lib/${project.build.finalName}.jar

RUN mkdir -p /opt/app/policy/pdpx/apps/tutorial

COPY --chown=policy:policy xacml.properties /opt/app/policy/pdpx/apps/tutorial