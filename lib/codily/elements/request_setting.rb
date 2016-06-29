require 'codily/elements/service_belongging_base'
require 'codily/elements/condition'

require 'codily/fastly_ext'

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

      defaults(
        force_ssl: nil,
        force_miss: nil,
        timer_support: nil,
        bypass_busy_wait: nil,
      )

      def setup
        delete_if_empty! *%i(
          default_host
          hash_keys
        )

        force_integer! *%i(
          force_ssl
          force_miss
          timer_support
          bypass_busy_wait
          max_stale_age
        )

        # NOTE: They can be 'N/A' (null) on app.fastly.com, but can't be back to N/A after changed to Y or N once?
        %i(force_ssl force_miss timer_support bypass_busy_wait).each do |k|
          @hash[k] = @hash[k] == 1 if @hash.key?(k)
        end
      end

      def as_hash
        super.tap do |x|
          %i(force_ssl force_miss timer_support bypass_busy_wait).each do |k|
            x[k] = !!x[k] ? 1 : 0 if x.key?(k) && !x[k].nil?
          end
        end
      end

      def request_condition(name = nil, &block)
        set_refer_element(:request_condition, Condition, {name: name, type: 'REQUEST', _service_name: self.service_name}, &block)
      end

      def fastly_class
        Fastly::RequestSetting
      end
    end
  end
end
