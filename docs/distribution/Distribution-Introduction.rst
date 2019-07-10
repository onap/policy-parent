.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0


Introduction to Policy-Distribution
***********************************

         .. container:: paragraph

            The main job of policy distribution component is to receive
            incoming notifications, download artifacts, decode policies
            from downloaded artifacts & forward the decoded policies to
            all configured policy engines.

|

         .. container:: paragraph

            The current implementation of distribution component comes
            with built-in SDC reception handler for receiving incoming
            distribution notifications from SDC using SDC client library.
            Upon receiving the notification, the corresponding CSAR artifacts
            are downloaded using SDC client library.The downloaded CSAR is
            then given to the configured policy decoder for decoding and
            generating policies. The generated policies are then forwarded
            to all configured policy engines. Related distribution status
            is sent to SDC at each step (download/deploy/done) during the
            entire flow.

|

         .. container:: paragraph

            The distribution component also comes with built-in REST based
            endpoints for fetching health check status & statistical data
            of running distribution system.

|

         .. container:: paragraph

            The distribution component is designed using plugin based architecture.
            All the handlers, decoders & forwarders are basically plugins to
            the running distribution engine. The plugins are configured in the
            configuration JSON file provided during startup of distribution engine.
            Adding a new plugin is simply implementing the related interfaces,
            adding them to the configuration JSON file & making the classes available
            in the classpath while starting distribution engine. There is no need
            to edit anything in the distribution core engine.
            Refer to distribution user manual for more details about the system and
            the configuration.
