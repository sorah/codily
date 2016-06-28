require 'codily/elements/service_belongging_base'

module Codily
  module Elements
    class Dictionary < ServiceBelonggingBase
      def_attr *%i(
      )

      def fastly_class
        Fastly::Dictionary
      end
    end
  end
end
