.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _actors-overview-label:

#####################
Actor Design Overview
#####################

.. contents::

Intro
#####

An actor/operation is any ONAP component that an Operational Policy can use to control
a VNF/VM/etc. during execution of a control loop operational policy when a Control Loop
Event is triggered.

.. toctree::
    :maxdepth: 3

Components
##########

Actor
*****

- Use addOperator() to add operators
- Convention: static NAME field identifies the name of the actor
- Registered via the Java ServiceLoader by including its jar on the classpath and adding
  its class name to this file, typically contained within the jar:

      onap.policy.controlloop.actorServiceProvider.spi

Operator
********

- Typically don’t have to create any Operator classes; just use *HttpOperator* or
  *BidirectionalTopicOperator*.

Operation
*********

- Most operations require guard checks to be performed first. Thus, at a minimum, they
  should override *startPreprocessorAsync()* and have it invoke *startGuardAsync()*
- In addition, if the operation depends on properties being in the context, then it
  should override *startPreprocessorAsync()* and have it invoke *obtain()*. Note:
  *obtain()*
  and the guard can be performed in parallel by using the *allOf()* method.  If the
  guard
  happens to depend on the same data, then it will block until the data is available,
  and then continue; the invoker need not deal with the dependency
- Subclasses will typically derive from *HttpOperation* or *BidirectionalTopicOperation*,
  though if neither of those suffices, then they can derive from *OperationPartial*, or
  even just implement a raw *Operation*
- Operation subclasses should be written in a way so-as to avoid any blocking I/O
- Operations return a "future" when *start()* is invoked.  Typically, if the "future" is
  canceled, then any outstanding operation will be canceled.  For instance, HTTP
  connections will be closed without waiting for a response
- If an operation sets the outcome to "FAILURE", it will be automatically retried; other
  failure types are not retried

Params
******

- Identifies the operation to be performed
- Includes timeout and retry information, though the actors typically provide default
  values if unset
- Includes “Policy” fields

    - “recipe” is renamed to “operation”
- Includes the event "context"

Context (aka, Event Context)
****************************

- Includes:

    - original onset event
    - enrichment data associated with the event
    - results of A&AI queries

XxxParams and XxxConfig
***********************

- XxxParams objects are POJOs into which the property Maps are decoded when configuring
  actors or operators
- XxxConfig objects contain a single Operator's (or Actor's) configuration information,
  based on what was in the XxxParams.  For instance, the HttpConfig contains a reference
  to the HttpClient that is used to perform HTTP operations.  XxxConfig objects are
  shared by all operations created by a single Operator.  As a result, it should not
  contain any data associated with an individual operation; such data should be stored
  within the operation object, itself

Junit tests
***********

- Operation Tests may choose to subclass from *BasicHttpOperation*, which provides some
  supporting utilities and mock objects
- Tests with an actual REST server are performed within *HttpOperationTest*, so need not
  be repeated in subclasses. Instead, they can catch the callback to the *get()*,
  *post()*, etc., methods and pass the rawResponse to it there.  That being said, a
  number of actors spin up a simulator to verify end-to-end request/response processing

Clients (e.g., drools-applications)
***********************************

- When using callbacks, may want to use the *isFor()* method to verify that the outcome
  is for the desired operation, as callbacks are invoked with the outcome of all
  operations performed, including any preprocessor steps
