require 'codily/elements/service_belongging_base'

module Codily
  module Elements
    class Settings < ServiceBelonggingBase
      def_attr *%i(
        settings
      )

      def fastly_class
        Fastly::Settings
      end
    end
  end
end
