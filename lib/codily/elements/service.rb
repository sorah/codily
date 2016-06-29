require 'codily/elements/base'
require 'codily/elements/backend'
require 'codily/elements/cache_setting'
require 'codily/elements/condition'
require 'codily/elements/dictionary'
require 'codily/elements/domain'
require 'codily/elements/gzip'
require 'codily/elements/header'
require 'codily/elements/healthcheck'
require 'codily/elements/request_setting'
require 'codily/elements/response_object'
require 'codily/elements/vcl'
require 'codily/elements/settings'

module Codily
  module Elements
    class Service < Base
      def setup
        @hash.delete :customer_id
        @hash.delete :versions
        delete_if_empty! :comment
      end

      def name(name = nil)
        getset :name, name
      end

      def comment(comment = nil)
        getset :comment, comment
      end

      def backend(name, &block)
        root.add_element Backend.new(root, {name: name, _service_name: self.name}, &block)
      end

      def cache_setting(name, &block)
        root.add_element CacheSetting.new(root, {name: name, _service_name: self.name}, &block)
      end

      def condition(name, &block)
        root.add_element Condition.new(root, {name: name, _service_name: self.name}, &block)
      end

      def dictionary(name, &block)
        root.add_element Dictionary.new(root, {name: name, _service_name: self.name}, &block)
      end

      def domain(name, &block)
        root.add_element Domain.new(root, {name: name, _service_name: self.name}, &block)
      end

      def gzip(name, &block)
        root.add_element Gzip.new(root, {name: name, _service_name: self.name}, &block)
      end

      def header(name, &block)
        root.add_element Header.new(root, {name: name, _service_name: self.name}, &block)
      end

      def healthcheck(name, &block)
        root.add_element Healthcheck.new(root, {name: name, _service_name: self.name}, &block)
      end

      def request_setting(name, &block)
        root.add_element RequestSetting.new(root, {name: name, _service_name: self.name}, &block)
      end

      def response_object(name, &block)
        root.add_element ResponseObject.new(root, {name: name, _service_name: self.name}, &block)
      end

      def vcl(name, &block)
        root.add_element Vcl.new(root, {name: name, _service_name: self.name}, &block)
      end
      
      def settings(kv)
        root.add_element Settings.new(root, {settings: kv, _service_name: self.name})
      end

      def fastly_class
        Fastly::Service
      end
    end
  end
end
