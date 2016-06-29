require 'codily/elements/service_belongging_base'
require 'codily/elements/condition'

module Codily
  module Elements
    class CacheSetting < ServiceBelonggingBase
      def_attr *%i(
        action
        stale_ttl
        ttl
      )

      def setup
        delete_if_empty! *%i(
          cache_condition
        )
        force_integer! *%i(
          ttl
          stale_ttl
        )
      end

      def cache_condition(name = nil, &block)
        set_refer_element(:cache_condition, Condition, {name: name, type: 'CACHE', _service_name: self.service_name}, &block)
      end

      def fastly_class
        Fastly::CacheSetting
      end
    end
  end
end
