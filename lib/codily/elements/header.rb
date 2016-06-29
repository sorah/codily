require 'codily/elements/service_belongging_base'
require 'codily/elements/condition'

module Codily
  module Elements
    class Header < ServiceBelonggingBase
      def_attr *%i(
        action
        src
        dst
        ignore_if_set
        priority
        regex
        substitution
        type
      )

      def setup
        delete_if_empty! *%i(
          regex
          substitution
        )
        force_integer! *%i(
          priority
          ignore_if_set
        )
        if @hash.key?(:ignore_if_set)
          @hash[:ignore_if_set] = @hash[:ignore_if_set] == 1
        end
      end

      def as_hash
        super.tap do |x|
          if x.key?(:ignore_if_set)
            x[:ignore_if_set] = !!x[:ignore_if_set] ? 1 : 0
          end
        end
      end

      def cache_condition(name = nil, &block)
        set_refer_element(:cache_condition, Condition, {name: name, _service_name: self.service_name}, &block)
      end

      def request_condition(name = nil, &block)
        set_refer_element(:request_condition, Condition, {name: name, _service_name: self.service_name}, &block)
      end

      def response_condition(name = nil, &block)
        set_refer_element(:response_condition, Condition, {name: name, _service_name: self.service_name}, &block)
      end

      def fastly_class
        Fastly::Header
      end
    end
  end
end
