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
        substitution
        type
      )

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
