require 'codily/elements/service_belongging_base'
require 'codily/elements/condition'

module Codily
  module Elements
    class Gzip < ServiceBelonggingBase
      def content_types(o = nil)
        o = case o
            when nil
              nil
            when String
              o
            when Array
              o.join(' ')
            end
        getset :content_types, o
      end

      def extensions(o = nil)
        o = case o
            when nil
              nil
            when String
              o
            when Array
              o.join(' ')
            end
        getset :content_types, o
      end

      def setup
        delete_if_empty! :cache_condition
      end

      def cache_condition(name = nil, &block)
        set_refer_element(:cache_condition, Condition, {name: name, type: 'CACHE', _service_name: self.service_name}, &block)
      end

      def fastly_class
        Fastly::Gzip
      end
    end
  end
end
