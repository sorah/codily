require 'codily/elements/service_belongging_base'
require 'codily/elements/condition'

module Codily
  module Elements
    class RequestSetting < ServiceBelonggingBase
      def_attr *%i(
        action
        bypass_busy_wait
        default_host
        force_miss
        force_ssl
        geo_headers
        hash_keys
        max_stale_age
        timer_support
        xff
      )

      def request_condition(name = nil, &block)
        set_refer_element(:request_condition, Condition, {name: name, _service_name: self.service_name}, &block)
      end

      def fastly_class
        Fastly::RequestSetting
      end
    end
  end
end
