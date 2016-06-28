require 'fastly'
require 'codily/elements/base'

module Codily
  module Elements
    class ServiceBelonggingBase < Base
      def service_name
        @hash[:_service_name]
      end

      def key
        [service_name, name]
      end

      def as_hash
        @hash.reject { |k,v| k == '_service_name' }
      end
    end
  end
end
