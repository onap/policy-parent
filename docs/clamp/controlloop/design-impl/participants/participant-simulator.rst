.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _clamp-controlloop-participant-simulator:

Participant Simulator
#####################

This can be used for simulation testing purpose when there are no actual frameworks or a full deployment.
Participant simulator can edit the states of ControlLoopElements and Participants for verification of other controlloop components
for early testing.
All controlloop components should be setup, except participant frameworks (for example, no policy framework components
are needed) and participant simulator acts as respective participant framework, and state changes can be done with following REST APIs

Participant Simulator API
=========================

This API allows a Participant Simulator to be started and run for test purposes.

:download:`Download Policy Participant Simulator API Swagger  <swagger/participant-sim.json>`

.. swaggerv2doc:: swagger/participant-sim.json
