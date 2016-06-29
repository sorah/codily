require 'fastly'
require 'codily/elements/base'

module Codily
  module Elements
    class ServiceBelonggingBase < Base
      def initialize(*)
        super

        if fastly_obj
          service_version = root.service_version_get(fastly_obj.service_id)
          raise "[bug?] Root#service_version_set should be called before passing fastly obj to ServiceBelonggingBase.new" unless service_version
          @hash[:_service_name] = service_version[:name]
          @hash[:_service_id] = service_version[:id]
        end
      end

      def service_id
        @hash[:_service_id] ||= begin
          service_version = root.service_version_get(service_name)
          if service_version
            service_version[:id]
          else
            nil
          end
        end
      end

      def service_name
        @hash[:_service_name]
      end

      def key
        [service_name, name]
      end

      def as_hash
        @hash.reject { |k,v| k == :_service_name || k == :_service_id }
      end
    end
  end
end
