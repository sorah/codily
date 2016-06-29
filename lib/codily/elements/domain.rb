require 'codily/elements/service_belongging_base'

module Codily
  module Elements
    class Domain < ServiceBelonggingBase
      def_attr *%i(
        comment
      )

      def setup
        delete_if_empty! :comment
      end

      def fastly_class
        Fastly::Domain
      end
    end
  end
end
