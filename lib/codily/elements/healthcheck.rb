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

      def fastly_class
        Fastly::Healthcheck
      end
    end
  end
end
