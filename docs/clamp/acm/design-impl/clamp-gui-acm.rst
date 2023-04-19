.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _clamp-gui-acm:

The Policy GUI for Automation Compositions
******************************************

.. contents::
    :depth: 4

.. _Introduction:

1. Introduction
###############
The Policy GUI for Automation Compositions is designed to provide a user the ability to interact with the Automation Composition Runtime to perform several actions. The actual technical design of the Automation Composition Runtime is detailed in :ref:`clamp-runtime-acm`. All of the endpoints and the purpose for accessing those endpoints is discussed there. In the current release of the GUI, the main purposes are to perform the below:

- Commission new Tosca Service Templates.
- Editing Common Properties.
- Priming/De-priming Automation Composition Definitions.
- Decommission existing Tosca Service Templates.
- Create new instances of Automation Compositions.
- Change the state of the Automation Compositions.
- Delete Automation Compositions.

These functions can be carried out by accessing the Automation Composition Runtime alone but this should not be required for a typical user to access the system. That is why the Automation Composition GUI is required. The remainder of this document will be split into 2 main sections. The first section will show the overall architecture of Automation Composition with the GUI included, so that the reader can see where it fits in to the system. Then the section will outline the individual components required for a working GUI and outline how GUI interacts with these components and why. The final section has a diagram to show the flow of typical operations from the GUI, all the way down to the participants.

2. GUI-focussed System Architecture
###################################
An architectural/functional diagram has bee provided in below. This does not show details of the other components involved in the GUI functionality. Most of the detail is provided for the GUI itself.

    .. image:: ../images/gui/GUI-Architecture.png
        :align: center

The remainder of this section outlines the different elements that comprise the architecture of the GUI and how the different elements connect to one another.

2.1 Policy CLAMP GUI
--------------------

2.1.1 CLAMP GUI
================
The original Clamp project used the GUI to connect to various onap services, including policy api, policy pap, dcae, sdc and cds. Connection to all of these services is managed by the Camel Exchange present in the section :ref:`Policy Clamp Backend`.

Class-based react components are used to render the different pages related to functionality around

- Creating loop instances from existing templates that have been distributed by SDC.
- Deploying/Undeploying policies to the policy framework.
- Deploying/Undeploying microservices to the policy framework.
- Deleting Instances.


2.1.2 Automation Composition GUI
================================

The current automation composition GUI is an extension of the previously created GUI for the Clamp project. The Clamp project used the CLAMP GUI to connect to various onap services, including policy api, policy pap, dcae, sdc and cds. Although the current automation composition project builds upon this GUI, it does not rely on these connected services. Instead, the Automation Composition GUI connects to the Automation Composition Runtime only. The Automation Composition Runtime then communicates with the database and all the Automation Composition participants (indirectly) over DMAAP.

The CLAMP GUI was originally housed in the clamp repository but for the Istanbul release, it has been moved to the policy/gui repo. There are 3 different GUIs within this repository - clamp-gui (and Automation Composition gui) code is housed under the "gui-clamp" directory and the majority of development takes place within the "gui-clamp/ui-react" directory.

The original CLAMP GUI was created using the React framework, which is a light-weight framework that promotes use of component-based architecture. Previously, a class-based style was adopted to create the Clamp components. It was decided that Automation Composition would opt for the more concise functional style of components. This architecture style allows for the logical separation of functionality into different components and minimizes bloat. As you can see from the image, there is a "Automation Composition" directory under components where all of our Automation Composition components are housed.

    .. image:: ../images/gui/ComponentFileStructure.png

Any code that is directly involved in communication with outside services like Rest Apis is under "ui-react/src/api". The "fetch" Javascript library is used for these calls. The Automation Composition service communicates with just the Automation Composition Runtime Rest Api, so all of the communication code is within "ui-react/src/api/AutomationCompositionService.js".

2.1.2.1 Services
""""""""""""""""
The Automation Composition GUI is designed to be service-centric. This means that the code involved in rendering and manipulating data is housed in a different place to the code responsible for communication with outside services. The Automation Composition related services are those responsible for making calls to the commissioning and instantiation endpoints in the Automation Composition Runtime. Another detail to note is that both the Automation Composition and CLAMP GUI use a proxy to forward requests to the policy clamp backend. Any URLs called by the frontend that contain the path "restservices/clds/v2/" are forwarded to the backend. Services are detailed below:

- A commissioning call is provided for contacting the commissioning API to commission a tosca service template.
- A decommissioning call is provided for calling the decommissioning endpoint.
- A call to retrieve the tosca service template from the runtime is provided. This is useful for carrying out manipulations on the template, such as editing the common properties.
- A call to get the common or instance properties is provided. This is used to provide the user an opportunity to edit these properties.
- Calls to allow creation and deletion of an instance are provided
- Calls to change the state of and instance are provided.
- Calls to get the current state and ordered state of the instances, effectively monitoring.

These services provide the data and communication functionality to allow the user to perform all of the actions mentioned in the :ref:`Introduction`.

2.1.2.2 Components
""""""""""""""""""
The components in the architecture image reflect those rendered elements that are presented to the user. Each element is designed to be as user-friendly as possible, providing the user with clean uncluttered information. Note that all of these components relate to and were designed around specific system dialogues that are present in :ref:`system-level-label`.

- For commissioning, the user is provided with a simple file upload. This is something the user will have seen many times before and is self explanatory.
- For the edit of common properties, a JSON editor is used to present whatever common properties that are present in the service template to the user in as simple a way possible. The user can then edit, save and recommission.
- A link is provided to manage the tosca service template, where the user can view the file that has been uploaded in JSON format and optionally delete it.
- Several functions are exposed to the user in the "Manage Instances" modal. From there they can trigger, creation of an instance, view monitoring information, delete an instance and change the state.
- Before an instance is created, the user is provided an opportunity to edit the instance properties. That is, those properties that have not been marked as common.
- The user can change the state of the instance by using the "Change" button on the "Manage Instances" modal. This is effectively where the user can deploy and undeploy an instance.
- Priming and De-priming take place as a result of the action of commissioning and decommissioning a tosca service template. A more complete discussion of priming and de-priming is found here :ref:`acm-participant-protocol-label`.
- As part of the "Manage Instances" modal, we can monitor the state of the instances in 2 ways. The color of the instance highlight in the table indicates the state (grey - uninitialised, passive - yellow, green - running). Also, there is a monitoring button that allows use to view the individual elements' state.

.. _Policy Clamp Backend:

2.2 Policy Clamp Backend
------------------------
The only Rest API that the Automation Composition frontend (and CLAMP frontend) communicates with directly is the Clamp backend. The backend is written in the Springboot framework and has many functions. In this document, we will only discuss the Automation Composition related functionality. Further description of non-acm Clamp and its' architecture can be found in :ref:`architecture-label`. The backend receives the calls from the frontend and forwards the requests to other relevant APIs. In the case of the Automation Composition project, the only Rest API that it currently requires communication with is the runtime Automation Composition API. Automation Composition adopts the same "request forwarding" method as the non-acm elements in the CLAMP GUI. This forwarding is performed by Apache Camel Exchanges, which are specified in XML and can be found in the directory shown below in the Clamp repository.

    .. image:: ../images/gui/CamelDirectory.png

The Rest Endpoints for the GUI to call are defined in "clamp-api-v2.xml" and all of the runtime Automation Composition rest endpoints that GUI requests are forwarded to are defined in acm-flows.xml. If an Endpoint is added to the runtime Automation Composition component, or some other component you wish the GUI to communicate with, a Camel XML exchange must be defined for it here.

2.3 Automation Composition Runtime
----------------------------------
This is where all of the endpoints for operations on Automation Compositions are defined thus far. Commissioning, decommissioning, automation composition creation, automation composition state change and automation composition deletion are all performed here. The component is written using the Springboot framework and all of the code is housed in the runtime-acm directory shown below:

    .. image:: ../images/gui/RuntimeAcmDirectory.png

The rest endpoints are split over two main classes; CommissioningController.java and InstantiationController.java. There are also some rest endpoints defined in the MonitoringQueryController. These classes have minimal business logic defined in them and delegate these operations to other classes within the controlloop.runtime package. The Automation Composition Runtime write all data received on its' endpoints regarding commissioning and instantiation to its; database, where it can be easily accessed later by the UI.

The Runtime also communicates with the participants over DMAAP. Commissioning a automation composition definition writes it to the database but also triggers priming of the definitions over DMAAP. The participants then receive those definitions and hold them in memory. Similarly, upon decommissioning, a message is sent over DMAAP to the participants to trigger de-priming.

Using DMAAP, the Runtime can send; updates to the automation composition definitions, change the state of automation compositions, receive information about participants, receive state information about automation compositions and effectively supervise the automation compositions. This data is then made available via Rest APIs that can be queried by the frontend. This is how the GUI can perform monitoring operations.

More detail on the design of the Runtime Automation Composition can be found in :ref:`clamp-runtime-acm`.

2.4 DMAAP
---------
DMAAP is component that provides data movement services that transports and processes data from any source to any target.  It provides the capability to:
- Support the transfer of messages between ONAP components, as well as to other components
- Support the transfer of data between ONAP components as well as to other components.
- Data Filtering capabilities
- Data Processing capabilities
- Data routing (file based transport)
- Message routing (event based transport)
- Batch and event based processing

Specifically, regarding the communication between the Automation Composition Runtime and the Automation Composition Participants, both components publish and subscribe to a specific topic, over which data and updates from the participants and automation compositions are sent. The Automation Composition Runtime updates the current statuses sent from the participants in the database and makes them available the the GUI over the Rest API.

2.5 The Participants
--------------------
The purpose of the Automation Composition participants is to communicate with different services on behalf of the Automation Composition Runtime. As there are potentially many different services that a Automation Composition might require access to, there can be many different participants. For example, the kubernetes participant is responsible for carrying out operations on a kubernetes cluster with helm. As of the time of writing, there are three participants defined for the Automation Composition project; the policy participant, the kubernetes participant and the http participant. The participants are housed in the directory shown below in the policy-clamp repo.

    .. image:: ../images/gui/ParticipantsDirectory.png

The participants communicate with the Runtime over DMAAP. Tosca service template specifications, Automation Composition updates and state changes are shared with the participants via messages from runtime Automation Composition through the topic "POLICY-CLRUNTIME-PARTICIPANT".

3. GUI Sample Flows
###################
The primary flows from the GUI to the backend, through DMAAP and the participants are shown in the diagram below. This diagram just serves as an illustration of the scenarios that the user will experience in the GUI. You can see factually complete dialogues in :ref:`system-level-label`.

    .. image:: ../images/gui/GUI-Flow.png
