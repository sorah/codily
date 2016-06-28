require 'codily/elements/service_belongging_base'
require 'codily/elements/condition'

module Codily
  module Elements
    class Gzip < ServiceBelonggingBase
      def_attr *%i(
        content_types
        extensions
      )

      def cache_condition(name = nil, &block)
        set_refer_element(:cache_condition, Condition, {name: name, _service_name: self.service_name}, &block)
      end

      def fastly_class
        Fastly::Gzip
      end
    end
  end
end
