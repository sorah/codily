require 'codily/elements/service_belongging_base'
require 'codily/elements/healthcheck'

require 'codily/elements/file_loadable'

module Codily
  module Elements
    class Backend < ServiceBelonggingBase
      include FileLoadable

      def_attr *%i(
        address
        auto_loadbalance
        between_bytes_timeout
        comment
        connect_timeout
        error_threshold
        first_byte_timeout
        hostname
        ipv4
        ipv6
        max_conn
        max_tls_version
        min_tls_version
        port
        shield
        ssl_cert_hostname
        ssl_ciphers
        ssl_hostname
        ssl_sni_hostname
        use_ssl
        weight
      )

      def_file_loadable_attr *%i(
        client_cert
        ssl_ca_cert
        ssl_check_cert
        ssl_client_cert
        ssl_client_key
      )

      def healthcheck(name = nil, &block)
        set_refer_element(:healthcheck, Healthcheck, {name: name, _service_name: self.service_name}, &block)
      end

      def request_condition(name = nil, &block)
        set_refer_element(:request_condition, Condition, {name: name, _service_name: self.service_name}, &block)
      end

      def fastly_class
        Fastly::Backend
      end
    end
  end
end
