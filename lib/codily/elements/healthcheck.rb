require 'codily/elements/service_belongging_base'

module Codily
  module Elements
    class Healthcheck < ServiceBelonggingBase
      def_attr *%i(
        check_interval
        comment
        expected_response
        host
        http_version
        initial
        method
        path
        threshold
        timeout
        window
      )

      defaults(
        threshold: 1,
        window: 2,
        http_version: "1.1",
        timeout: 5000,
        method: "HEAD",
        expected_response: 200,
        check_interval: 60000,
        initial: 1,
      )

      def setup
        delete_if_empty! :comment
      end

      def fastly_class
        Fastly::Healthcheck
      end
    end
  end
end
