require 'codily/elements/service_belongging_base'
require 'codily/utils'

module Codily
  module Elements
    class Settings < ServiceBelonggingBase
      def setup
        @hash = Utils.symbolize_keys(@hash)
      end
      def dsl_args
        [as_hash]
      end

      def as_dsl_hash
        {}
      end

      def key
        service_name
      end

      def fastly_class
        Fastly::Settings
      end
    end
  end
end
