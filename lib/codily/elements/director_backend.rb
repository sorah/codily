require 'codily/elements/service_belongging_base'

module Codily
  module Elements
    class DirectorBackend < ServiceBelonggingBase
      def_attr *%i(
        director_name
        backend_name
      )

      def key
        [service_name, director_name, backend_name]
      end

      def fastly_class
        nil
      end
    end
  end
end
