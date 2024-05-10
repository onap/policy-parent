.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

.. _property-configuration:

Property-configuration mechanisms
#################################

.. contents::
    :depth: 3

This article explains how to implement handling and validation of common parameters into the Policy Framework Components.

Not Spring boot framework
*************************
The application should have a ParameterHandler class to support the map of values from Json to a POJO; so it should load the file and convert it; performing all type conversion.

The code below shown is an example of ParameterHandler:

.. code-block:: java

   public class PapParameterHandler {

       private static final Logger LOGGER = LoggerFactory.getLogger(PapParameterHandler.class);

       private static final Coder CODER = new StandardCoder();

    public PapParameterGroup getParameters(final PapCommandLineArguments arguments) throws PolicyPapException {
           PapParameterGroup papParameterGroup = null;

           try {
               var file = new File(arguments.getFullConfigurationFilePath());
               papParameterGroup = CODER.decode(file, PapParameterGroup.class);
           } catch (final CoderException e) {
               final String errorMessage = "error reading parameters from \"" + arguments.getConfigurationFilePath()
                       + "\"\n" + "(" + e.getClass().getSimpleName() + ")";
               throw new PolicyPapException(errorMessage, e);
           }

           if (papParameterGroup == null) {
               final String errorMessage = "no parameters found in \"" + arguments.getConfigurationFilePath() + "\"";
               LOGGER.error(errorMessage);
               throw new PolicyPapException(errorMessage);
           }

           final ValidationResult validationResult = papParameterGroup.validate();
           if (!validationResult.isValid()) {
               String returnMessage =
                       "validation error(s) on parameters from \"" + arguments.getConfigurationFilePath() + "\"\n";
               returnMessage += validationResult.getResult();

               LOGGER.error(returnMessage);
               throw new PolicyPapException(returnMessage);
           }

           return papParameterGroup;
       }
   }


The POJO has to implement the **org.onap.policy.common.parameters.ParameterGroup** interface or eventually extend **org.onap.policy.common.parameters.ParameterGroupImpl**. The last one already implements the **validate()** method that performs error checking using validation **org.onap.policy.common.parameters.annotations**.

The code below shows an example of the POJO:

.. code-block:: java

   @NotNull
   @NotBlank
   @Getter
   public class PapParameterGroup extends ParameterGroupImpl {
       @Valid
       private RestServerParameters restServerParameters;
       @Valid
       private PdpParameters pdpParameters;
       @Valid
       private PolicyModelsProviderParameters databaseProviderParameters;
       private boolean savePdpStatisticsInDb;
       @Valid
       private TopicParameterGroup topicParameterGroup;

       private List<@NotNull @Valid RestClientParameters> healthCheckRestClientParameters;

       public PapParameterGroup(final String name) {
           super(name);
       }
   }


The code shown below, is an example of Unit Test validation of the POJO PapParameterGroup:

.. code-block:: java

   private static final Coder coder = new StandardCoder();

   @Test
   void testPapParameterGroup_NullName() throws Exception {
       String json = commonTestData.getPapParameterGroupAsString(1).replace("\"PapGroup\"", "null");
       final PapParameterGroup papParameters = coder.decode(json, PapParameterGroup.class);
       final ValidationResult validationResult = papParameters.validate();
       assertFalse(validationResult.isValid());
       assertEquals(null, papParameters.getName());
       assertThat(validationResult.getResult()).contains("is null");
   }


Using Spring boot framework
***************************
Spring loads the property file automatically and makes it available under the **org.springframework.core.env.Environment** Spring component.

Environment
+++++++++++
A component can use Environment component directly.

The Environment component is not a good approach because there is no type conversion or error checking, but it could be useful when the name of the property you need to access changes dynamically.

.. code-block:: java

   @Component
   @RequiredArgsConstructor
   public class Example {

   private Environment env;
   ....

   public void method(String pathPropertyName) {
    .....
    String path = env.getProperty(pathPropertyName);
    .....
   }

Annotation-based Spring configuration
+++++++++++++++++++++++++++++++++++++
All annotation-based Spring configurations support the Spring Expression Language (SpEL), a powerful expression language that supports querying and manipulating an object graph at runtime.
A documentation about SpEL could be found here: https://docs.spring.io/spring-framework/docs/3.0.x/reference/expressions.html.

A component can use **org.springframework.beans.factory.annotation.Value**, which reads from properties, performs a type conversion and injects the value into the field. There is no error checking, but it can assign a default value if the property is not defined.

.. code-block:: java

   @Value("${security.enable-csrf:true}")
   private boolean csrfEnabled = true;


The code below shows how to inject a value of a property into @Scheduled configuration.

.. code-block:: java

    @Scheduled(
            fixedRateString = "${runtime.participantParameters.heartBeatMs}",
            initialDelayString = "${runtime.participantParameters.heartBeatMs}")
    public void schedule() {
    }

ConfigurationProperties
+++++++++++++++++++++++
@ConfigurationProperties can be used to map values from .properties( .yml also supported) to a POJO. It performs all type conversion and error checking using validation **javax.validation.constraints**.

.. code-block:: java

   @Validated
   @Getter
   @Setter
   @ConfigurationProperties(prefix = "runtime")
   public class ClRuntimeParameterGroup {
       @Min(100)
       private long heartBeatMs;

       @Valid
       @Positive
       private long reportingTimeIntervalMs;

       @Valid
       @NotNull
       private ParticipantUpdateParameters updateParameters;

       @NotBlank
       private String description;
   }

In a scenario where we need to include the properties in a POJO, as shown before, in a class that implements **ParameterGroup** interface, we need to add the **org.onap.policy.common.parameters.validation.ParameterGroupConstraint** annotation. That annotation is configured to use **ParameterGroupValidator**, which handles the conversion of a **org.onap.policy.common.parameters.BeanValidationResult** to a Spring validation.

The code below shows how to add the TopicParameterGroup parameter into acRuntimeParameterGroup:

.. code-block:: java

   @NotNull
   @ParameterGroupConstraint
   private TopicParameterGroup topicParameterGroup;


A bean configured with ConfigurationProperties, is automatically a Spring component and could be injected into other Spring components. The code below shown an example:

.. code-block:: java

   @Component
   @RequiredArgsConstructor
   public class Example {

      private acRuntimeParameterGroup parameters;
      ....

      public void method() {
        .....
        long heartBeatMs = parameters.getHeartBeatMs();
        .....
      }

The code shown below, is an example of Unit Test validation of the POJO acRuntimeParameterGroup:

.. code-block:: java

   private ValidatorFactory validatorFactory = Validation.buildDefaultValidatorFactory();

   @Test
   void testParameters_NullTopicParameterGroup() {
       final acRuntimeParameterGroup parameters = CommonTestData.geParameterGroup();
       parameters.setTopicParameterGroup(null);
       assertThat(validatorFactory.getValidator().validate(parameters)).isNotEmpty();
   }
