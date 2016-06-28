require 'codily/elements/service_belongging_base'

module Codily
  module Elements
    class Condition < ServiceBelonggingBase
      def_attr *%i(
        comment
        priority
        statement
      )

      def fastly_class
        Fastly::Condition
      end
    end
  end
end
